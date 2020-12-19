require_relative 'lib/behind_the_name/version'

Gem::Specification.new do |spec|
  spec.name          = "behind_the_name"
  spec.version       = BehindTheName::VERSION
  spec.authors       = ["Michael Chui"]
  spec.email         = ["saraid216@gmail.com"]

  spec.summary       = %q{Unofficial Ruby Client for BehindTheName.com}
  spec.homepage      = 'https://github.com/saraid/behind_the_name'
  spec.licenses      = ['MIT']

  spec.metadata["homepage_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'rest-client', '~> 2'
  spec.add_dependency 'yaml', '~> 0'
end
