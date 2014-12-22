module Neo4j::Server
  class Connection
    attr_reader :host, :hydra, :headers, :global_params

    GET           = :get
    POST          = :post
    JSON          = { 'Content-Type' => 'application/json' }
    SSL_VERIFY    = { ssl_verifyhost: 2 }
    SSL_NO_VERIFY = { ssl_verifyhost: 0 }
    EMPTY_PARAMS  = {}
    Ethon.logger.level = 999

    def initialize(params = nil)
      @hydra = Typhoeus::Hydra.new
      @global_params = params_hash(params)
      @headers = JSON.dup
    end

    def basic_creds
      global_params[:userpwd]
    end

    def verify_ssl?
      global_params[:ssl_verifyhost] == 2
    end

    def get(endpoint)
      response_for(Typhoeus.get(endpoint, post_params(nil)), endpoint)
    end

    def post(endpoint, body = nil)
      response_for(Typhoeus.post(endpoint, post_params(body)), endpoint)
    end

    def delete(endpoint, body = nil)
      response_for(Typhoeus.delete(endpoint, post_params(body)), endpoint)
    end

    private

    def params_hash(params)
      return EMPTY_PARAMS unless params
      init_params = params[:initialize] ? params[:initialize] : {}
      basic_creds =  params[:basic_auth] ? { userpwd: "#{params[:basic_auth][:username]}:#{params[:basic_auth][:password]}" } : {}
      ssl         =  init_params[:ssl] ? verify_ssl(init_params[:ssl][:verify]) : {}
      basic_creds.merge! ssl
    end

    def post_params(body)
      if body
        { body: body.to_json, headers: headers }.merge! global_params
      else
        { headers: headers }.merge! global_params
      end
    end

    def verify_ssl(ssl_param)
      ssl_param ? SSL_VERIFY : SSL_NO_VERIFY
    end

    def response_for(request, endpoint)
      Neo4j::Server::ConnectionResponse.new request, endpoint
    end
  end
end