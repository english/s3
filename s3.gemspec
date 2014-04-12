# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "s3/version"

Gem::Specification.new do |spec|
  spec.name          = "s3"
  spec.version       = S3::VERSION
  spec.authors       = ["Jamie English"]
  spec.email         = ["jamienglish@gmail.com"]
  spec.summary       = %q{Very simple library for uploaded to, and deleting from, S3}
  spec.homepage      = "https://github.com/jamienglish/s3"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "rack-test"
end
