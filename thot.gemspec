
Gem::Specification.new do |spec|
  spec.name          = "thot"
  spec.version       = `cat VERSION`.chomp
  spec.authors       = ["Romain GEORGES"]
  spec.email         = ["gems@ultragreen.net"]

  spec.summary       = "THe Operative Templating "
  spec.description   = "the simpliest way to template in Ruby and command"
  spec.homepage      = "https://github.com/Ultragreen/thot"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["homepage_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "carioca", "~> 2.1"
  spec.add_dependency "inifile", "~> 3.0"

  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 1.54'
  spec.add_development_dependency "roodi", "~> 5.0"
  spec.add_development_dependency 'code_statistics', '~> 0.2.13'
  spec.add_development_dependency "yard", "~> 0.9.27"
  spec.add_development_dependency "yard-rspec", "~> 0.1"
  spec.add_development_dependency'version', '~> 1.1'

  spec.add_development_dependency "bundle-audit", "~> 0.1.0"

  spec.add_development_dependency "cyclonedx-ruby", "~> 1.1"
  spec.add_development_dependency "debride", "~> 1.12"
  
end
