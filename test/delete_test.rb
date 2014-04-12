require "test_helper"

class S3DeleteTest < Test::Unit::TestCase
  class FakeTime
    def self.now
      Time.parse("Fri, 24 May 2013 00:00:00 GMT")
    end
  end

  def test_deletes_things
    stub_request(:any, "examplebucket.s3.amazonaws.com/test.txt")

    config = S3::Configuration.new
    config.access_key_id = "AKIAIOSFODNN7EXAMPLE"
    config.secret_access_key_id = "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
    config.bucket = "examplebucket"

    S3::Delete.new("https://examplebucket.s3.amazonaws.com/test.txt", config: config, time: FakeTime).call

    assert_requested(:delete, "examplebucket.s3.amazonaws.com/test.txt",
                     headers: { "Date"          => "Fri, 24 May 2013 00:00:00 GMT",
                                "Authorization" => "AWS AKIAIOSFODNN7EXAMPLE:VHgvHWe1PAO3PMPWSQ21qO25duQ=" })
  end
end
