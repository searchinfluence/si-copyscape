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
    assert_kind_of(String, @response.raw_xml, 'raw_xml should return an xml string')
  end

  def test_raw_hash
    assert(@response.raw_hash.is_a?(Hash), "raw_hash method must return a hash")
  end

  def test_remaining_on_normal_search
    assert_nil(@response.remaining, 'remaining should be nil if this isnt a balance check')
  end

  def test_remaining_on_balance_check
    VCR.use_cassette("api_balance") do
      api = SI::CopyscapeAPI.new(username: 'test', api_key: 'test', api_url: 'http://www.copyscape.com/api/')
      balance_response = api.request(operation: 'balance')
      assert_instance_of(SI::CopyscapeResponse, balance_response)
    end
  end

  def test_response
    assert(@response.response.is_a?(Hash), "response method must return a hash")
  end

  def test_results
    assert(@response.results.is_a?(Array), 'results method must return an array')
  end

  def test_query_words
    assert_equal(@response.query_words, 20)
  end
end
