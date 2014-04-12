module S3
  class Delete
    def self.call(url)
      new(url).call
    end

    attr_reader :uri, :config, :time

    def initialize(url, config: S3.configuration, time: Time)
      @uri = URI(url)
      @config = config
      @time = time
    end

    def call
      http = Net::HTTP.new(uri.host)
      request = Net::HTTP::Delete.new(uri.path)
      request.initialize_http_header(headers)
      response = http.request(request)

      raise S3Error, response.body unless response.code.start_with?("2")
    end

    private

    def headers
      { "Date"          => time.now.httpdate,
        "Authorization" => "AWS #{config.access_key_id}:#{signature}" }
    end

    def signature
      S3.signature(string_to_sign: string_to_sign, secret_access_key_id: config.secret_access_key_id)
    end

    def string_to_sign
      canonicalized_resource = "/#{config.bucket}#{uri.path}"
      S3.string_to_sign(canonicalized_resource: canonicalized_resource, verb: "DELETE", date: time.now.httpdate)
    end
  end
end
