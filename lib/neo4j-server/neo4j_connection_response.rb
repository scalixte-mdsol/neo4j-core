module Neo4j::Server
  class ConnectionResponse
    attr_reader :response, :endpoint

    def initialize(response, endpoint)
      @response = response
      @endpoint = endpoint
    end

    def status
      response.response_code
    end

    def body
      @body ||= JSON.parse!(response.body)
    end

    def headers
      @headers ||= response.headers
    end
  end
end