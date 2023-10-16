# frozen_string_literal: true

require 'optparse'

require_relative 'page'

# handle the --metadata flag.
options = {}
OptionParser.new do |opt|
  opt.on('-m', '--metadata') { options[:metadata] = true }
  opt.on('-r', '--mirror') { options[:mirror] = true }
end.parse!

# Check that we have argument(s).
if ARGV.empty?
  puts "usage: #{$PROGRAM_NAME} <URL 1> <URL 2> <...>"
  exit(1)
end

ARGV.each do |url|
  page = Page.new(url, options)
  begin
    page.fetch
  rescue StandardError => e
    warn e.message
  end
end
