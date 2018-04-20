# frozen_string_literal: true

require_relative './bundlerparser.rb'
require_relative './gemfinder.rb'
require_relative './rubygems.rb'
require_relative './bundlerfilter.rb'
require_relative './geminfo.rb'
require_relative './rubyversioner.rb'

parser = BundlerParser.new
gem_finder = GemFinder.new(RubyGems.new)
filter = BundlerFilter.new
ruby_versioner = RubyVersioner.new

# you can use either of the Files to test sample bundler output
data = File.new('list.txt')
# data = File.new('outdated.txt')
# use ARGF when you want to pipe bundler output to this script
# example:
# bundle list | ruby $HOME/projects/experiments/appraiser/appraiser.rb
# data = ARGF

data.each_line do |line|
  next if filter.filter? line
  message = ''

  search_data = parser.parse(line)
  gem_info = gem_finder.search(search_data) unless search_data.nil?
  if gem_info&.valid?
  # if gem_info && gem_info.valid?
    message = "#{gem_info.name} " + gem_info.current_version.to_s
    if gem_info.newer_version?
      message << '; newest ' + gem_info.newest_version.to_s
    end
    ruby_versioner << gem_info
  else
    message = "NO INFO FOR #{line}"
  end
  puts message
end

ruby_versioner.ruby_versions.sort.each do |version|
  puts "ruby version #{version}: #{ruby_versioner.ruby_version(version)}"
end
 