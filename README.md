# S3

Super simple library for uploading to, and deleting from, S3.

## Installation

Add this line to your application's Gemfile:

    gem 's3', github: 'jamienglish/s3'

And then execute:

    $ bundle

## Usage

```ruby
require "s3"

S3.configure do |config|
  config.access_key_id = ENV["AWS_ACCESS_KEY_ID"]
  config.secret_access_key_id = ENV["AWS_SECRET_ACCESS_KEY"]
  config.bucket = "mybucket"
end

image = Rack::Test::UploadedFile.new("image.jpg", "image/jpg")
url = S3::Put.call(image)

S3::Delete.call('path/to/image.jpg')
```
