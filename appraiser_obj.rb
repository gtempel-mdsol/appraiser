class Appraiser
  attr_accessor :parser, :gem_finder

  def initialize(parser, gem_finder)
    @parser = parser
    @gem_finder = gem_finder
  end

  def appraise_gem(bundler_gem_info)
    search_terms = parser.parse(bundler_gem_info)
    gem_info = gem_finder.find search_terms
  end

end
