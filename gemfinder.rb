require_relative './geminfo'
require_relative './gemversion'
require_relative './rubygems'

# Class that, given a ruby gems instance, will try to create and populate
# gem info objects using the gem and ruby version information provided by
# the ruby gems instance.
class GemFinder
  attr_reader :rubygems

  def initialize(rubygems)
    @rubygems = rubygems
  end

  def search(search_data)
    gem_info = GemInfo.new search_data[:name]
    rubygems_data = rubygems.find search_data[:name], search_data[:version]
    gem_info.current_version = GemVersion.new(search_data[:version],
                                              detect_ruby_version(rubygems_data))

    # is there a newest version?
    if search_data.key?(:newest)
      rubygems_data = rubygems.find search_data[:name], search_data[:newest]
      gem_info.newest_version = GemVersion.new(search_data[:newest],
                                               detect_ruby_version(rubygems_data))
    end
    gem_info
  end

  def detect_ruby_version(rubygems_data)
    default_version = '?'
    version = default_version
    if rubygems_data && rubygems_data.key?(:ruby_version)
      version = rubygems_data[:ruby_version]
    end
    version.nil? || version.empty? ? '?' : version
  end
end
