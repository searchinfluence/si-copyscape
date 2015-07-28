module SI
  class CopyscapeResponse

    attr_reader :raw, :error, :to_hash

    def initialize raw_response:
      @raw = raw_response
      @error = _error_msg
      @to_hash = _to_hash
    end

    def raw_xml
      raw.body
    end

  private

    def _to_hash
      Hash.from_xml(raw_xml).with_indifferent_access
    end

    def _error_msg
      _to_hash.try(:[], 'response').try(:[], 'error')
    end

  end
end
