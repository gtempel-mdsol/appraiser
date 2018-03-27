
require_relative './bundlerparser.rb'
require_relative './gemfinder.rb'
require_relative './rubyversioner.rb'
require_relative './bundlerfilter.rb'

parser = BundlerParser.new
gem_finder = GemFinder.new
versioner = RubyVersioner.new
filter = BundlerFilter.new

# data = File.new('list.txt')
data = File.new('outdated.txt')
# data = ARGF

data.each_line do |line|
  next if filter.filter? line
  message = ''
  search_data = parser.parse(line)
  gem_data = gem_finder.find search_data unless search_data.nil?
  if gem_data
    message = "#{gem_data['name']} @ " + versioner.version_info(gem_data)

    if search_data.key?(:newest)
      gem_data = gem_finder.find name: search_data[:name], version: search_data[:newest]
      message << "; " + versioner.version_info(gem_data)
    end
  else
    message = "NO INFO FOR #{line}"
  end
  puts message
end
