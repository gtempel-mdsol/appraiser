class BundlerFilter
  
  def initialize
    @regex = /^(?:Fetching|Resolving|Gems|Outdated)\s+.*$/
  end

  def filter?(line)
    line.nil? ||
    line.strip.empty? ||
    !@regex.match(line).nil?
  end
end