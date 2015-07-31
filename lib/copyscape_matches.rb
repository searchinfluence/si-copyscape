module SI
  class CopyscapeMatches

    include Enumerable
    attr_reader :collection, :query_word_count, :match_percent, :error

    def initialize response:, match_percent:
      @query_word_count = response.query_words.to_i
      @match_percent = match_percent.to_i
      @collection = _build_collection response.results
      @error = response.error
    end

    def all_text_snippets
      collection.map{|m| m.text_snippet}
    end

    def all_html_snippets
      collection.map{|m| m.html_snippet}
    end

    def each(&block)
      collection.each(&block)
    end

  private

    def _build_collection results
      results = _without_rejects(results).map do |match|
        SI::CopyScape::Match.new(
          match['wordsmatched'].to_i,
          match['percentmatched'].to_i,
          match['title'],
          match['url'],
          match['viewurl'],
          match['textsnippet'],
          match['htmlsnippet']
        )
      end
      _sort results
    end

    def _sort results
      results.sort{|a,b| b.percent_matched <=> a.percent_matched }
    end

    def _without_rejects results
      results.reject{|r| r['percentmatched'].to_i < match_percent && !r['urlerror'].nil? }
    end

  end
end
