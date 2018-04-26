class RubyVersioner

  def initialize
    @versions = {}
  end

  def <<(gem_info)
    add_gem_info  gem_name: gem_info.name,
                  gem_version: gem_info.current_version.gem,
                  ruby_version: gem_info.current_version.ruby if gem_info&.valid?

    add_gem_info  gem_name: gem_info.name,
                  gem_version: gem_info.newest_version.gem,
                  ruby_version: gem_info.newest_version.ruby if gem_info&.valid? && gem_info&.newer_version?
  end

  def ruby_versions
    @versions.keys
  end

  def ruby_version(version)
    @versions[version]
  end

  private
  
  def add_gem_info(gem_name:, gem_version:, ruby_version:)
    @versions[ruby_version] = [] unless @versions.has_key?(ruby_version)
    @versions[ruby_version] << "#{gem_name} #{gem_version}"
  end
end
