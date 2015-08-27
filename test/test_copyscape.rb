require 'test_helper'

class TestCopyscape < Minitest::Test
  def test_error
    VCR.use_cassette("api_error") do
      response = @@cs.internet_matches! 'test'
      assert(response.error.is_a?(String), "Error should respond with a string when present.")
    end

    VCR.use_cassette("api_internet_matches") do
      response = @@cs.internet_matches! 'A national website promotion company, Search Influence routinely delivers a 10:1 return on investment, or better, for our customers.'
      assert_nil(response.error, "When no errors, error should return nil")
    end
  end

  def test_credit_balance
    VCR.use_cassette("api_balance") do
      response = @@cs.credit_balance
      assert_instance_of(SI::CopyScape::Balance, response)
      assert(response.value.is_a?(Float), "Credit Balance value must be a Float")
      assert(response.total.is_a?(Integer), "Credit Total must be an Int")
      assert(response.today.is_a?(Integer), "Credit Total Today must be an Int")
    end
  end

  def test_internet_matches
    VCR.use_cassette("api_internet_matches") do
      response = @@cs.internet_matches! 'A national website promotion company, Search Influence routinely delivers a 10:1 return on investment, or better, for our customers.'
      assert_instance_of(SI::CopyscapeMatches, response)
    end
  end

  def test_private_matches
    VCR.use_cassette("api_private_matches") do
      response = @@cs.private_matches! 'Because they are far less expensive when used, impractical vehicles sell well in the secondary market.'
      assert_instance_of(SI::CopyscapeMatches, response)
    end
  end

  def test_internet_and_private_matches
    VCR.use_cassette("api_internet_and_private_matches") do
      response = @@cs.internet_and_private_matches! 'A national website promotion company, Search Influence routinely delivers a 10:1 return on investment, or better, for our customers.'
      assert_instance_of SI::CopyscapeMatches, response
    end
  end

  def test_add_to_private_index
    VCR.use_cassette("api_add_to_private_index") do
      response = @@cs.add_to_private_index(text: 'Putting some text in our private index.  Fee Fi Fo Fum I smell the blood of an englishman')
      assert_instance_of SI::CopyScape::PrivateIndex, response
      assert(response.words.is_a?(Integer), 'Private Index words must return an integer')
      assert(response.handle.is_a?(String), 'Private Index handle must return a string')
      assert_respond_to(response, 'id')
      assert_respond_to(response, 'title')
    end
  end
end
