require_relative './geminfo'
require_relative './gemversion'
require_relative './rubygems'

class GemFinder
  attr_reader :rubygems

  def initialize(rubygems)
    @rubygems = rubygems
  end

  def search(search_data)
    gem_info = GemInfo.new search_data[:name]
    rubygems_data = rubygems.find search_data[:name], search_data[:version]
    gem_info.current_version = GemVersion.new(search_data[:version], detect_ruby_version(rubygems_data))

    # is there a newest version?
    if search_data.key?(:newest)
      rubygems_data = rubygems.find search_data[:name], search_data[:newest]
      gem_info.newest_version = GemVersion.new(search_data[:newest], detect_ruby_version(rubygems_data))
    end
    gem_info
  end

  def detect_ruby_version(rubygems_data)
    version = rubygems_data && rubygems_data.key?(:ruby_version) ? rubygems_data[:ruby_version] : ''
    (version.nil? || version.empty?) ? '?' : version
  end

end
