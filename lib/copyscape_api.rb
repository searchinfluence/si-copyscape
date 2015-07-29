module SI
  class CopyscapeAPI

    attr_reader :api_url, :api_key, :username, :response

    def initialize username:, api_key:, api_url:
      @username ||= username
      @api_key ||= api_key
      @api_url ||= api_url
    end

    def request operation:, params: {}, postdata: nil
      uri_hash = { u: username, k: api_key, o: operation }
      uri_string = api_url + '?' + params.merge(uri_hash).map{|k,v| "#{k}=#{v}"}.join('&')
      uri = URI.parse(URI.encode(uri_string))
      @response = _respond_to _call_api(uri, postdata)
    end

  private

    def _respond_to request
      if request.is_a?(Net::HTTPSuccess) || request.is_a(Net::HTTPRedirection)
        SI::CopyscapeResponse.new(raw_response: request)
      end
    end

    def _call_api uri, postdata=nil
      if postdata.nil?
          Net::HTTP.get_response(uri)
        else
          http = Net::HTTP.new(uri.host, uri.port)
          request = Net::HTTP::Post.new(uri.request_uri)
          request.body = postdata
          http.request(request)
        end
    end

  end
end
