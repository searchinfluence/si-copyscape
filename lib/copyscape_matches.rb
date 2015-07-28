module SI
  class CopyscapeMatches

    include Enumerable
    attr_reader :collection, :query_word_count, :match_percent, :error
    delegate :each, to: :collection

    def initialize response:, match_percent:
      @query_word_count = response.query_words.to_i
      @match_percent = match_percent.to_i
      @collection = _build_collection response
      @error = response.error
    end

    def all_text_snippets
      collection.map{|m| m.text_snippet}
    end

    def all_html_snippets
      collection.map{|m| m.html_snippet}
    end

  private

    def _build_collection response
      response.results.map do |match|
        SI::CopyScape::Match.new(
          match['wordsmatched'].to_i,
          match['percentmatched'].to_i,
          match['title'],
          match['url'],
          match['viewurl'],
          match['textsnippet'],
          match['htmlsnippet']
        ) if match['percentmatched'].to_i >= match_percent
      end.compact.sort{|a,b| b.percent_matched <=> a.percent_matched}
    end

  end
end
