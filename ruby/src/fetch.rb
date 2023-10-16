# frozen_string_literal: true

require_relative './page'

if ARGV.empty?
  puts "usage: #{$PROGRAM_NAME} <URL 1> <URL 2> ..."
  exit(1)
end

ARGV.each do |url|
  page = Page.new(url)
  begin
    page.fetch
    page.download!
  rescue StandardError => e
    warn e.message
  end
end
