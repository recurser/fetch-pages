# frozen_string_literal: true

require 'httparty'

# A page represents a HTML page hosted on a remote URL, with support for fetching
# the page and its assets.
class Page
  # Constructor.
  def initialize(url)
    @url = url
  end

  # Fetches the page source from the remote URL.
  def fetch
    result = HTTParty.get(url)

    raise "The page could not be fetched (#{url})" unless result.success?

    @html = result.response.body
  end

  # Writes the fetched HTML to a local file. This is a destructive action, since
  # it will over-write any existing files.
  def download!
    raise "The page has not yet been fetched (#{url})" if html.nil?

    File.open(filename, 'w') { |file| file.write(html) }
  end

  private

  # URL stores the URL of the page to be fetched.
  attr_reader :url

  # html stores the HTML fetched from the page.
  attr_reader :html

  # Generates a filename to store the fetched HTML to.
  def filename
    "#{url.split('/').last.gsub(/[^a-zA-Z0-9.]/, '-')}.html"
  end
end
