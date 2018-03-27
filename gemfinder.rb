require 'typhoeus'
require 'json'

class GemFinder
  URL_TEMPLATE = 'https://rubygems.org/api/v2/rubygems/%{name}/versions/%{version}.json'

  def find(gem_name_and_version_hash)
    url = URL_TEMPLATE % gem_name_and_version_hash
    response = Typhoeus.get(url, followlocation: true)
    if response && response.success?
      JSON.parse response.response_body
    else
      nil
    end
  end
end