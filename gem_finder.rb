# frozen_string_literal: true

require_relative './gem_info'
require_relative './gem_version'
require_relative './ruby_gems'

# Class that, given a ruby gems instance, will try to create and populate
# gem info objects using the gem and ruby version information provided by
# the ruby gems instance.
class GemFinder
  attr_reader :rubygems

  DEFAULT_RUBY_VERSION = '?'

  def initialize(rubygems)
    @rubygems = rubygems
  end

  def detect_ruby_version(rubygems_data = {})
    version = rubygems_data&.key?(:ruby_version) ? rubygems_data[:ruby_version] : DEFAULT_RUBY_VERSION
    version.nil? || version.empty? ? DEFAULT_RUBY_VERSION : version
  end

  def search(search_data = {})
    gem_info = GemInfo.new(search_data[:name])
    gem_info.current_version = do_search(name: search_data[:name], version: search_data[:version])

    if search_data&.key?(:newest)
      gem_info.newest_version = do_search(name: search_data[:name], version: search_data[:newest])
    end
    gem_info
  end

  private

  def do_search(name:, version:)
    rubygems_data = rubygems.find name, version
    version_info = GemVersion.new(version, detect_ruby_version(rubygems_data))
    version_info
  end
end
