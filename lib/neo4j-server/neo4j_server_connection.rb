module Neo4j::Server
  class Connection
    attr_reader :host, :hydra

    GET = :get
    POST = :post
    JSON = { 'Content-Type' => 'application/json' }
    Ethon.logger.level = 999

    def initialize(host = 'http://localhost:7474')
      @hydra = Typhoeus::Hydra.new
      @host = host
    end

    def get(endpoint)
      response_for(Typhoeus.get(endpoint, headers: JSON), endpoint)
    end

    def post(endpoint, body = nil)
      post_params = body ? { body: body.to_json, headers: JSON } : { headers: JSON }
      response_for(Typhoeus.post(endpoint, post_params), endpoint)
    end

    def delete(endpoint, body = nil)
      response_for(Typhoeus.delete(endpoint, body: body.to_json, headers: JSON), endpoint)
    end

    private

    def response_for(request, endpoint)
      Neo4j::Server::ConnectionResponse.new request, endpoint
    end
  end
end