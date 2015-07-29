module SI
  class CopyScape

    # Data Structures used for responses to the public api
    Match = Struct.new(:words_matched, :percent_matched, :title, :url, :copyscape_url, :text_snippet, :html_snippet)
    Balance = Struct.new(:value, :total, :today)
    PrivateIndex = Struct.new(:words, :handle, :id, :title)


    attr_reader :api, :match_percent

    def initialize username: nil, api_key: nil, uri: nil, match_percent: 5
      username ||= ENV['COPYSCAPE_USERNAME']
      api_key ||= ENV['COPYSCAPE_API_KEY']
      uri ||= 'http://www.copyscape.com/api/'
      @match_percent = match_percent
      @api = SI::CopyscapeAPI.new(username: username, api_key: api_key, api_url: uri)
    end

    def error
      api.response.try(:error)
    end

    def credit_balance
      res = _request(operation: 'balance').remaining
      Balance.new(res['value'].to_f, res['total'].to_i, res['today'].to_i)
    end

    def internet_matches! text
      # cost 1 credit
      return SI::CopyscapeMatches.new(
        response: _text_search(text: text, operation: 'csearch'),
        match_percent: match_percent
      )
    end

    def private_matches! text
      # cost 1 credit
      return SI::CopyscapeMatches.new(
        response: _text_search(text: text, operation: 'psearch'),
        match_percent: match_percent
      )
    end

    def internet_and_private_matches! text
      # cost 2 credits
      return SI::CopyscapeMatches.new(
        response: _text_search(text: text, operation: 'cpsearch'),
        match_percent: match_percent
      )
    end

    def add_to_private_index text:, title: nil, id: nil, encoding: 'UTF-8'
      params = { e: encoding, a: title, i: id }
      res = _request(operation: 'pindexadd', params: params, postdata: text).response
      PrivateIndex.new(res['words'],res['handle'],res['id'],res['title'])
    end

  private

    def _text_search text:, operation:, encoding: 'UTF-8', full: 3
      params = { e: encoding, c: full.to_s }
      _request(operation: operation, params: params, postdata: text);
    end

    def _request operation:, params: {}, postdata: nil
      api.request(operation: operation, params: params, postdata: postdata)
    end

  end
end
