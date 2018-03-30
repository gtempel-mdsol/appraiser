class GemVersion

  def initialize(gem_version, ruby_version)
    @data = {
      gem_version: gem_version,
      ruby_version: ruby_version
    }
  end

  def gem
    @data[:gem_version]
  end

  def ruby
    @data[:ruby_version]
  end

  def to_s
    "v#{gem} requires #{ruby}"
  end

  def valid?
    !(gem.nil? || gem.empty?) &&
    !(ruby.nil? || ruby.empty?)
  end
end
