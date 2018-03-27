class BundlerParser
  def parse(bundle_info_record)
    captures = nil
    if bundle_info_record
      captures = match_bundle_info(bundle_info_record)
      captures = match_bundle_outdated(bundle_info_record) if captures.nil?
    end
    captures
  end

  def match_bundle_info(bundle_info_record)
    match(/^[\s*\*]+(\S+)\s+\(([0-9\.]+)[^\)]*\).*$/, bundle_info_record) do |captures|
      { name: captures[0], version: captures[1] }
    end
  end

  def match_bundle_outdated(bundle_info_record)
    match(/^[\s*\*]+(\S+)\s+\(newest\s+([0-9\.]+),\s*installed\s+([0-9\.]+)[^\)]*\).*$/, bundle_info_record) do |captures|
      { name: captures[0], newest: captures[1], version: captures[2] }
    end
  end

  private
  def match(regex, bundle_info_record)
    match_data = bundle_info_record.match(regex)
    captures = match_data.nil? ? [] : match_data.captures
    if !captures.empty?
      yield(captures)
    else
      nil
    end
  end
end
