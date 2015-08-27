require 'test_helper'

class TestCopyscapeResponse < Minitest::Test
  def setup
    api = SI::CopyscapeAPI.new(
      username: 'test',
      api_key: 'test',
      api_url: 'http://www.copyscape.com/api/'
    )
    VCR.use_cassette("api_internet_matches") do
      text = 'A national website promotion company, Search Influence routinely delivers a 10:1 return on investment, or better, for our customers.'
      @response = api.request(operation: 'csearch', params: {c:3, e: 'UTF-8'}, postdata: text)
    end
  end

  def test_raw_xml
    assert(@response.raw_xml.is_a?(String), 'raw_xml should return an xml string')
  end

  def test_raw_hash
    assert(@response.raw_hash.is_a?(Hash), "raw_hash method must return a hash")
  end

  def test_remaining
    assert_nil(@response.remaining, 'remaining should be nil if this isnt a balance check')

    VCR.use_cassette("api_balance") do
      api = SI::CopyscapeAPI.new(username: 'test', api_key: 'test', api_url: 'http://www.copyscape.com/api/')
      balance_response = api.request(operation: 'balance')
      assert(balance_response.remaining.is_a?(Hash), 'remaining method should return a hash')
      refute_nil(balance_response.remaining, 'remaining should not be nil if this is a balance check')
    end
  end

  def test_response
    assert(@response.response.is_a?(Hash), "response method must return a hash")
  end

  def test_results
    assert(@response.results.is_a?(Array), 'results method must return an array')
  end

  def test_query_words
    assert(@response.query_words.is_a?(Integer), 'query_words method must return an integer')
  end
end
