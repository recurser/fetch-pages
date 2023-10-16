# frozen_string_literal: true

require 'httparty'
require 'nokogiri'

# Defines the name of the attribute that contains the URL we want to mirror,
# for each tag type.
URL_ATTR_NAMES = {
  img: :src,
  link: :href,
  script: :src
}.freeze

# An asset represents an element from a HTML page that can be mirrored,
# such as images, CSS files, etc.
class Asset
  # Constructor.
  def initialize(page_url, element)
    @page_url = page_url
    @element = element
  end

  # Downloads the given asset to the local folder, and updates the element
  # to point to the new copy. This is a destructive action, since it will
  # overwrite existing assets.
  def mirror!
    return if asset_url.nil?

    download!
    element[url_attr_name] = local_path
  end

  private

  # The Nokogiri element that this asset represents.
  attr_reader :element

  # URL stores the URL of the page to be fetched.
  attr_reader :page_url

  # Returns a 'standardized' URL for the asset, taking into account
  # whether the asset has a relative or absolute path.
  def asset_url
    @asset_url ||= begin
      url = element[url_attr_name]
      if url.nil?
        nil
      elsif url =~ %r{^[a-z]+://}
        url
      else
        File.join(page_uri.path.empty? ? page_uri.to_s : File.dirname(page_uri.to_s), url)
      end
    end
  end

  # Returns the name of the attribute that contains the URL we want to download.
  def url_attr_name
    URL_ATTR_NAMES[element.name.to_sym]
  end

  # Generates a base folder to store mirrored assets to.
  def base_folder
    @base_folder ||= begin
      path = File.join("#{page_url.split('/').last.gsub(/[^a-z0-9\.]/i, '-')}-assets", element.name)
      FileUtils.mkdir_p(path)
      path
    end
  end

  # Writes the remote asset to a local file. This is a destructive action, since
  # it will over-write any existing files.
  def download!
    File.open(local_path, 'w') do |file|
      next if asset_url.nil?

      HTTParty.get(asset_url, stream_body: true) do |fragment|
        file.write(fragment)
      end
    end
  end

  # Returns a 'standardized' URL for the asset, taking into account
  # whether the asset has a relative or absolute path.
  def local_path
    filename = asset_url.split('/').last
    extension = File.extname(filename)
    basename = File.basename(filename, extension).gsub(/[^a-z0-9]/i, '-')
    "./#{base_folder}/#{basename}#{extension}"
  end

  # Parses the page URL, and returns the resulting URI object.
  def page_uri
    @page_uri ||= URI.parse(page_url)
  end
end
