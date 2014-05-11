# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'best_gems_client/version'

Gem::Specification.new do |spec|
  spec.name          = "best_gems_client"
  spec.version       = BestGemsClient::VERSION
  spec.authors       = ["vzvu3k6k"]
  spec.email         = ["vzvu3k6k@gmail.com"]
  spec.summary       = %q{A scraper for bestgems.org, rubygem download rankings}
  spec.description   = spec.summary
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "minitest-vcr", "~> 0.1", "> 0.1.0"
  spec.add_development_dependency "webmock", "~> 1.17"
  spec.add_development_dependency "pry-rescue"

  spec.add_dependency "nokogiri", "~> 1.6"
end
