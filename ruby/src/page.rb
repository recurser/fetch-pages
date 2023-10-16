# frozen_string_literal: true

require 'httparty'
require 'nokogiri'

# A page represents a HTML page hosted on a remote URL, with support for fetching
# the page and its assets.
class Page
  # Stores the HTML fetched from the page.
  attr_reader :html

  # Stores the time that the data was last fetched.
  attr_reader :last_fetched_at

  # Stores any options passed to the command.
  attr_reader :options

  # Stores the result of parsing the HTML with Nokogiri.
  attr_reader :parsed_html

  # URL stores the URL of the page to be fetched.
  attr_reader :url

  # Constructor.
  #
  # The only option currently supported is a boolean 'metadata' flag, which prints metadata.
  def initialize(url, options = {})
    @url = url
    @options = options
  end

  # Fetches the page source from the remote URL.
  def fetch
    result = HTTParty.get(url)
    raise "The page could not be fetched (#{url})" unless result.success?

    @last_fetched_at = Time.now

    @html = result.response.body
    parse

    # The spec wasn't clear on whether we should still download if metadata is requested.
    # I've opted to return early and save resources in this case.
    if options[:metadata]
      metadata
      return
    end

    download!
  end

  # Writes the fetched HTML to a local file. This is a destructive action, since
  # it will over-write any existing files.
  def download!
    ensure_fetched!

    File.write(filename, html)
  end

  # Prints metadata about the page fetch.
  def metadata
    ensure_fetched!

    puts "site: #{url}"
    puts "num_links: #{num_links}"
    puts "images: #{num_images}"
    puts "last_fetch: #{last_fetched_at}"
  end

  # Returns the number of links present in the HTML source.
  def num_images
    ensure_parsed!

    parsed_html.css('img').length
  end

  # Returns the number of links present in the HTML source.
  def num_links
    ensure_parsed!

    parsed_html.css('a').length
  end

  private

  # Generates a base to store mirrored assets to.
  def basename
    url.split('/').last.gsub(/[^a-z0-9\.]/i, '-')
  end

  # Raises an error is the page has not been fetched yet.
  def ensure_fetched!
    raise "The page has not yet been fetched (#{url})" if html.nil?
  end

  # Raises an error is the page HTML has not been parsed yet.
  def ensure_parsed!
    ensure_fetched!

    raise "The page has not yet been parsed (#{url})" if parsed_html.nil?
  end

  # Generates a filename to store the fetched HTML to.
  def filename
    "#{basename}.html"
  end

  # Parses the page HTML with Nokogiri.
  def parse
    @parsed_html = Nokogiri::HTML(html)
  end
end
