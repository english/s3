require "test_helper"

class S3::PutTest < Test::Unit::TestCase
  class FakeTime
    def self.now
      Time.parse("Fri, 24 May 2013 00:00:00 GMT")
    end
  end

  def test_uploads_things
    stub_request(:any, "examplebucket.s3-eu-west-1.amazonaws.com/image.jpg")

    config = S3::Configuration.new
    config.access_key_id = "AKIAIOSFODNN7EXAMPLE"
    config.secret_access_key_id = "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
    config.bucket = "examplebucket"

    file = Rack::Test::UploadedFile.new("test/fixtures/image.jpg", "image/jpg")
    S3::Put.new(file, config: config, time: FakeTime).call

    assert_requested(:put, "examplebucket.s3-eu-west-1.amazonaws.com/image.jpg",
                     headers: { "Date"           => "Fri, 24 May 2013 00:00:00 GMT",
                                "Content-Type"   => "image/jpg",
                                "Content-Length" =>'116311',
                                "Authorization"  => "AWS AKIAIOSFODNN7EXAMPLE:uHAkjUeB/A7hF2rNF4xu6O+hb9g=" })
  end
end
