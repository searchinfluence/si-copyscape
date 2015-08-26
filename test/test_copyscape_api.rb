require 'test_helper'

class TestCopyscapeAPI < Minitest::Test
  def test_request
    api = SI::CopyscapeAPI.new(
      username: 'test',
      api_key: 'test',
      api_url: 'http://www.copyscape.com/api/'
    )
    VCR.use_cassette("api_balance") do
      response = api.request(operation: 'balance')
      assert_instance_of SI::CopyscapeResponse, response
    end
  end
end
