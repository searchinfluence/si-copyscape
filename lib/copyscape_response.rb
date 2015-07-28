module SI
  class CopyscapeResponse

    attr_reader :raw, :error

    def initialize raw_response:
      @raw = raw_response
      @error = _error_msg
    end

    def raw_xml
      raw.body
    end

    def raw_hash
      _to_hash
    end

    def remaining
      _to_hash.try(:[],'remaining')
    end

    def response
      _to_hash.try(:[], 'response')
    end

    def results
      result = response.try(:[],'result') || []
      result.is_a?(Array) ? result : [result]
    end

    def query_words
      response.try(:[], 'querywords')
    end

  private

    def _to_hash
      Crack::XML.parse(raw_xml)
    end

    def _error_msg
      response.try(:[], 'error')
    end

  end
end
