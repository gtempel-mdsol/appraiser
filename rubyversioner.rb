class RubyVersioner
  def version_info(gem_data)
    version = gem_data && gem_data.key?('ruby_version') ? gem_data['ruby_version'] : ''
    version = '?' if version.nil? || version.empty?
    "v#{gem_data['version']} requires #{version}"
  end
end