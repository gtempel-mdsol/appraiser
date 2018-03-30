class GemInfo
  attr_reader :name

  def initialize(name)
    @name = name
    @versions = {}
  end

  def valid?
    return !name.nil? && 
      !name.empty? && 
      current_version?
  end

  def current_version=(gem_version_info)
    @versions[:current] = gem_version_info
  end

  def current_version
    @versions[:current]
  end

  def current_version?
    !@versions[:current].nil? && current_version.valid?
  end

  def newer_version?
    !@versions[:newest].nil? && newest_version.valid?
  end

  def newest_version=(gem_version_info)
    @versions[:newest] = gem_version_info
  end

  def newest_version
    @versions[:newest]
  end

end