require 'typhoeus'
require 'json'

class RubyGems
  URL_TEMPLATE = 'https://rubygems.org/api/v2/rubygems/%{name}/versions/%{version}.json'

  def url_for(name, version)
    URL_TEMPLATE % { name: name, version: version }
  end

  def find(name, version)
    response = (name && version) ? Typhoeus.get(url_for(name, version), followlocation: true) : nil
    response = (response && response.success?) ? JSON.parse(response.response_body) : nil
    response ? Hash[response.map {|k,v| [k.to_sym, v]}] : nil
  end

end