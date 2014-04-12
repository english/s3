require "s3/version"
require "s3/put"
require "s3/delete"

module S3
  class S3Error < StandardError; end

  Configuration = Struct.new(:access_key_id, :secret_access_key_id, :bucket)

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure(&block)
    yield configuration
  end

  def self.signature(string_to_sign:, secret_access_key_id:)
    sha1_digest = OpenSSL::Digest.new("sha1")
    hmac = OpenSSL::HMAC.digest(sha1_digest, secret_access_key_id, string_to_sign)

    [hmac].pack("m").strip # base64
  end

  def self.string_to_sign(canonicalized_resource:, verb:, date:, content_type: "", content_md5: "")
    [verb, content_md5, content_type, date, canonicalized_resource].join("\n")
  end
end
