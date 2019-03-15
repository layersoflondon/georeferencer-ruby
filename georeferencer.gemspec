
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "georeferencer/version"

Gem::Specification.new do |spec|
  spec.name          = "georeferencer"
  spec.version       = Georeferencer::VERSION
  spec.authors       = ["Ed Jones", "Paul Hendrick"]
  spec.email         = ["ed@error.agency", "paul@error.agency"]

  spec.summary       = %q{A Ruby client for Georeferencer}
  spec.homepage      = "https://github.com/layersoflondon/georeferencer-ruby"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_dependency 'her'
  spec.add_dependency 'faraday_middleware'
  spec.add_dependency 'require_all'
  spec.add_dependency 'oj'
  spec.add_dependency 'activesupport'
end
