module SI
  class CopyscapeResponse

    attr_reader :raw_response, :error

    def initialize raw_response:
      @raw_response ||= raw_response
      @error = _error_msg
    end

    def raw_xml
      raw_response.body
    end

    def raw_hash
      _to_hash
    end

    def remaining
      raw_hash['remaining']
    end

    def response
      raw_hash['response']
    end

    def results
      result = response['result'] if response.is_a?(Hash)
      result.is_a?(Array) ? result : [result].compact
    end

    def query_words
      response['querywords'].to_i if response.is_a?(Hash)
    end

  private

    def _to_hash
      Crack::XML.parse(raw_xml)
    end

    def _error_msg
      response['error'] if response.is_a?(Hash)
    end

  end
end
