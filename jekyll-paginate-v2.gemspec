# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jekyll-paginate-v2/version'

Gem::Specification.new do |spec|
  spec.name          = "jekyll-paginate-v2"
  spec.version       = Jekyll::PaginateV2::VERSION
  spec.platform      = Gem::Platform::RUBY
  spec.date          = DateTime.now.strftime('%Y-%m-%d')
  spec.authors       = ["Sverrir Sigmundarson"]
  spec.email         = ["jekyll@sverrirs.com"]
  spec.homepage      = "https://github.com/sverrirs/jekyll-paginate-v2"
  spec.license       = "MIT"

  spec.summary       = %q{Pagination Generator for Jekyll 3}
  spec.description   = %q{An enhanced zero-configuration in-place replacement for the now decomissioned built-in jekyll-paginate gem. This pagination gem offers full backwards compatability as well as a slew of new frequently requested features with minimal additional site and page configuration.}
  
  #spec.files         = `git ls-files -z`.split("\x0")
  spec.files          = Dir['CODE_OF_CONDUCT.md', 'README.md', 'LICENSE', 'Rakefile', '*.gemspec', 'Gemfile', 'lib/**/*', 'spec/**/*']
  #spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "jekyll", ">= 3.0"
  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest", '~> 5.4', '>= 5.4.3'
end