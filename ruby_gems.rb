# frozen_string_literal: true

require 'typhoeus'
require 'json'

# Class providing ruby gem information via calls to rubygems via its API.
class RubyGems
  URL_TEMPLATE =
    'https://rubygems.org/api/v2/rubygems/%<name>s/versions/%<version>s.json'

  def url_for(name, version)
    format(URL_TEMPLATE, name: name, version: version)
  end

  def find(name, version)
    response = nil
    begin
      response = search_and_parse url_for(name, version)
    rescue RuntimeError
      response = nil
    end
    response
  end

  private

  def search_and_parse(url)
    response = Typhoeus.get(url, followlocation: true)
    if response.success?
      response = JSON.parse(response.response_body)
      response = Hash[response.map { |k, v| [k.to_sym, v] }]
    else
      response = nil
    end
    response
  end
end
