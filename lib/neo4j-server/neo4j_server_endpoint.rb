module Neo4j::Server
  class Neo4jServerEndpoint
    def initialize(params = {})
      @params = params
      @connection = Faraday.new
    end

    def merged_options(options)
      options.merge!(@params)
    end

    def get(url, options={})
      @connection.get(url, merged_options(options))
    end

    def post(url, options={})
      @connection.post(url, merged_options(options))
    end

    def delete(url, options={})
      @connection.delete(url, merged_options(options))
    end

  end
end
