require 'test_helper'

class TestCopyscapeMatches < Minitest::Test
  def setup
    cs = begin_copyscape

    VCR.use_cassette("api_internet_matches") do
      @matches = cs.internet_matches! 'A national website promotion company, Search Influence routinely delivers a 10:1 return on investment, or better, for our customers.'
      @match = @matches.first
    end
  end

  def test_matches_object
    assert_instance_of(SI::CopyscapeMatches, @matches)
    assert(@matches.is_a?(Enumerable), 'Expected matches to be enumerable')
  end

  def test_matches_object_count
    assert_equal(@matches.count, 2, 'What goes in should come out')
  end

  def test_match_object
    assert_instance_of(SI::CopyScape::Match, @match)
  end

  def test_match_html_snippet
    snippet = '<font color="#777777">... Trusted, Scalable Search, Social and Online Advertising. </font><font color="#000000">A national website promotion company, Search Influence routinely delivers a 10:1 return on investment, or better, for our customers.</font>'
    assert_equal(@match.html_snippet, snippet)
  end

  def test_match_test_snippet
    snippet = '... Trusted, Scalable Search, Social and Online Advertising. A national website promotion company, Search Influence routinely delivers a 10:1 return on investment, or better, for our customers.'
    assert_equal(@match.text_snippet, snippet)
  end

  def test_match_copyscape_url
    url = 'http://view.copyscape.com/compare/6jq6k9utaz/1'
    assert_equal(@match.copyscape_url, url)
  end

  def test_match_url
    url = 'http://www.searchinfluence.com/'
    assert_equal(@match.url, url)
  end

  def test_match_title
    title = 'Search Influence | Website Promotion Company'
    assert_equal(@match.title, title)
  end

  def test_match_percent_matched
    assert_equal(@match.percent_matched, 100)
  end

  def test_match_words_matched
    assert_equal(@match.words_matched, 20)
  end

  def test_all_text_snippets
    snippet = '... Trusted, Scalable Search, Social and Online Advertising. A national website promotion company, Search Influence routinely delivers a 10:1 return on investment, or better, for our customers.'
    snippets = @matches.all_text_snippets
    assert(snippets.is_a?(Array), 'this should return an array')
    assert_equal(snippets.first, snippet)
  end

  def test_all_html_snippets
    snippets = @matches.all_html_snippets
    assert(snippets.is_a?(Array), 'this should return an array')
    assert(snippets.first.is_a?(String), 'Each array element should be a string')
  end
end
