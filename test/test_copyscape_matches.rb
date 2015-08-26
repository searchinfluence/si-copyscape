require 'test_helper'

class TestCopyscapeMatches < Minitest::Test
  def setup
    VCR.use_cassette("api_internet_matches") do
      cs = SI::CopyScape.new(username: 'test', api_key: 'test')
      @matches = cs.internet_matches! 'A national website promotion company, Search Influence routinely delivers a 10:1 return on investment, or better, for our customers.'
    end
  end

  def test_matches_object
    assert_kind_of(SI::CopyscapeMatches, @matches)
    assert(@matches.is_a?(Enumerable), 'Expected matches to be enumerable')
  end

  def test_match_object
    match = @matches.first
    assert_kind_of(SI::CopyScape::Match, match)
    assert_respond_to(match, 'html_snippet')
    assert_respond_to(match, 'text_snippet')
    assert_respond_to(match, 'copyscape_url')
    assert_respond_to(match, 'url')
    assert_respond_to(match, 'title')
    assert(match.percent_matched.is_a?(Integer), 'percent_matched method must return an integer')
    assert(match.words_matched.is_a?(Integer), 'words_matched method must return an integer')
  end

  def test_all_text_snippets
    snippets = @matches.all_text_snippets
    assert(snippets.is_a?(Array), 'this should return an array')
    assert(snippets.first.is_a?(String), 'Each array element should be a string')
  end

  def test_all_html_snippets
    snippets = @matches.all_html_snippets
    assert(snippets.is_a?(Array), 'this should return an array')
    assert(snippets.first.is_a?(String), 'Each array element should be a string')
  end
end
