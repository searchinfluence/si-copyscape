require 'test_helper'

class TestCopyscape < Minitest::Test
  def setup
    @cs = begin_copyscape

    VCR.use_cassette("api_balance") do
      @credit_balance = @cs.credit_balance
    end
    VCR.use_cassette("api_add_to_private_index") do
      @private_index = @cs.add_to_private_index(text: 'Putting some text in our private index.  Fee Fi Fo Fum I smell the blood of an englishman')
    end
  end

  def test_error
    VCR.use_cassette("api_error") do
      response = @cs.internet_matches! 'test'
      error = 'At least 15 words are required to perform a search'
      assert_equal(response.error, error)
    end

    VCR.use_cassette("api_internet_matches") do
      response = @cs.internet_matches! 'A national website promotion company, Search Influence routinely delivers a 10:1 return on investment, or better, for our customers.'
      assert_nil(response.error, "When no errors, error should return nil")
    end
  end

  def test_credit_balance
    assert_instance_of(SI::CopyScape::Balance, @credit_balance)
  end

  def test_credit_balance_value
    assert(@credit_balance.value.is_a?(Float), "Credit Balance value must be a Float")
    assert_equal(@credit_balance.value, 240.51)
  end

  def test_credit_balance_total
    assert(@credit_balance.total.is_a?(Integer), "Credit Total must be an Int")
    assert_equal(@credit_balance.total, 4810)
  end

  def test_credit_balance_today
    assert(@credit_balance.today.is_a?(Integer), "Credit Total Today must be an Int")
    assert_equal(@credit_balance.today, 4810)
  end

  def test_internet_matches
    VCR.use_cassette("api_internet_matches") do
      response = @cs.internet_matches! 'A national website promotion company, Search Influence routinely delivers a 10:1 return on investment, or better, for our customers.'
      assert_instance_of(SI::CopyscapeMatches, response)
    end
  end

  def test_private_matches
    VCR.use_cassette("api_private_matches") do
      response = @cs.private_matches! 'Because they are far less expensive when used, impractical vehicles sell well in the secondary market.'
      assert_instance_of(SI::CopyscapeMatches, response)
    end
  end

  def test_internet_and_private_matches
    VCR.use_cassette("api_internet_and_private_matches") do
      response = @cs.internet_and_private_matches! 'A national website promotion company, Search Influence routinely delivers a 10:1 return on investment, or better, for our customers.'
      assert_instance_of SI::CopyscapeMatches, response
    end
  end

  def test_add_to_private_index
    assert_instance_of SI::CopyScape::PrivateIndex, @private_index
  end

  def test_private_index_words
    assert(@private_index.words.is_a?(Integer), 'Private Index words must return an integer')
    assert_equal(@private_index.words, 18)
  end

  def test_private_index_handle
    assert(@private_index.handle.is_a?(String), 'Private Index handle must return a string')
    assert_equal(@private_index.handle, 'SIA_2_E00JOQ0A2W_F0N8GRC4GS')
  end

  def test_private_index_id
    assert_nil(@private_index.id)
  end

  def test_private_index_title
    assert_nil(@private_index.title)
  end
end
