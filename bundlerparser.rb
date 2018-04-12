# Class to parse Bundler list and/or outdated output and capture the
# gem, version, and possibly ruby version information.
class BundlerParser
  BUNDLER_LIST_REGEX =
    /^[\s\*]+([^\s\*]+)\s+\(([\d\.]+)[^\)]*\).*$/
  BUNDLER_OUTDATED_REGEX =
    /^[\s\*]+([^\s\*]+)\s+\(newest\s+([\d\.]+),\s*installed\s+([\d\.]+)[^\)]*\).*$/

  def parse(bundle_info_record)
    captures = nil
    if bundle_info_record
      captures = match_bundle_list(bundle_info_record)
      captures = match_bundle_outdated(bundle_info_record) if captures.nil?
    end
    captures
  end

  def match_bundle_list(bundle_info_record)
    match(BUNDLER_LIST_REGEX, bundle_info_record) do |captures|
      { name: captures[0], version: captures[1] }
    end
  end

  def match_bundle_outdated(bundle_info_record)
    match(BUNDLER_OUTDATED_REGEX, bundle_info_record) do |captures|
      { name: captures[0], newest: captures[1], version: captures[2] }
    end
  end

  private

  def match(regex, bundle_info_record)
    match_data = bundle_info_record.match(regex)
    captures = match_data.nil? ? [] : match_data.captures
    yield(captures) unless captures.empty?
  end
end
