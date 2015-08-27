require 'minitest/autorun'
require 'copyscape_api'
require 'copyscape'
require 'copyscape_matches'
require 'copyscape_response'
require 'crack'
require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = "test/cassettes"
  config.hook_into :webmock # or :fakeweb
end

def begin_copyscape
  SI::CopyScape.new(username: 'test', api_key: 'test')
end
