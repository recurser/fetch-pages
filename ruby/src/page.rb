# frozen_string_literal: true

require 'httparty'
require 'nokogiri'

# A page represents a HTML page hosted on a remote URL, with support for fetching
# the page and its assets.
class Page
  # Stores the time that the data was last fetched.
  attr_reader :last_fetched_at

  # URL stores the URL of the page to be fetched.
  attr_reader :url

  # Constructor.
  #
  # The only option currently supported is a boolean 'metadata' flag, which prints metadata.
  def initialize(url, options = {})
    @url = url
    @options = options
  end

  # Writes the fetched HTML to a local file. This is a destructive action, since
  # it will over-write any existing files.
  def download!
    File.write(filename, html)
  end

  # Fetches the page source from the remote URL.
  def fetch
    # The spec wasn't clear on whether we should still download if metadata is requested.
    # I've opted to return early and save resources in this case.
    if options[:metadata]
      metadata
      return
    end

    download!
  end

  # A wrapper around the attribute which lazy-fetches the page.
  def html
    @html ||= begin
      result = HTTParty.get(url)
      raise "The page could not be fetched (#{url})" unless result.success?

      @last_fetched_at = Time.now

      result.response.body
    end
  end

  # Returns the list of image elements in the parsed source HTML.
  def images
    parsed_html.css('img')
  end

  # Returns the list of link elements in the parsed source HTML.
  def links
    parsed_html.css('a')
  end

  # Prints metadata about the page fetch.
  def metadata
    puts "site: #{url}"
    puts "num_links: #{links.length}"
    puts "images: #{images.length}"
    puts "last_fetch: #{last_fetched_at}"
  end

  private

  # Stores the HTML fetched from the page.
  attr_writer :html

  # Stores any options passed to the command.
  attr_reader :options

  # Stores the result of parsing the HTML with Nokogiri.
  attr_writer :parsed_html

  # Generates a base to store mirrored assets to.
  def basename
    url.split('/').last.gsub(/[^a-z0-9\.]/i, '-')
  end

  # A wrapper around the attribute which lazy-parses the HTML.
  def parsed_html
    @parsed_html ||= Nokogiri::HTML(html)
  end

  # Generates a filename to store the fetched HTML to.
  def filename
    "#{basename}.html"
  end
end
