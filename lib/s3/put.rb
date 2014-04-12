module S3
  class Put
    REGION = "s3-eu-west-1"
    HOST   = "amazonaws.com"

    def self.call(file)
      new(file).call
    end

    attr_reader :file, :config, :time

    def initialize(file, config: S3.configuration, time: Time)
      @file = file
      @config = config
      @time = time
    end

    def call
      http = Net::HTTP.new(domain)
      request = Net::HTTP::Put.new(path)
      request.initialize_http_header(headers)
      request.body_stream = File.open(file.path)

      response = http.request(request)

      raise S3Error, response.body unless response.code.start_with?("2")

      url
    end

    private

    def url
      "http://#{domain}/#{file.original_filename}"
    end

    def headers
      { "Authorization"  => "AWS #{config.access_key_id}:#{signature}",
        "Date"           => time.now.httpdate,
        "Content-Type"   => content_type,
        "Content-Length" => content_length }
    end

    def path
      "/" + file.original_filename
    end

    def content_type
      extension = File.extname(file.original_filename).gsub(".", "")
      raise "Unsupported File Type" unless %w( jpg png gif ).include?(extension)

      file.content_type
    end

    def content_length
      File.open(file.path).lstat.size.to_s
    end

    def signature
      S3.signature(string_to_sign: string_to_sign, secret_access_key_id: config.secret_access_key_id)
    end

    def string_to_sign
      canonicalized_resource = "/#{config.bucket}/#{file.original_filename}"
      S3.string_to_sign(canonicalized_resource: canonicalized_resource, verb: "PUT", content_type: content_type, date: time.now.httpdate)
    end

    def domain
      [config.bucket, REGION, HOST].join(".")
    end
  end
end
