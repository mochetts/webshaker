require_relative "lib/webshaker/version"

Gem::Specification.new do |spec|
  spec.name = "webshaker"
  spec.version = Webshaker::VERSION
  spec.authors = ["Martin Mochetti"]
  spec.email = ["martin@mochetts.com"]

  spec.summary = "An Intelligent web scraper"
  spec.description = "Web scraper that shakes a link to extract info out of it using AI."
  spec.homepage = "https://github.com/mochetts/webshaker"
  spec.license = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) || f.start_with?(*%w[bin/ spec/ .git .github .vscode])
    end
  end
  spec.require_paths = ["lib"]
  spec.executables = spec.files.grep(%r{\bin/}) { |f| File.basename(f) }
  spec.required_ruby_version = Gem::Requirement.new(">= 3.0.0")
  spec.bindir = "bin"

  spec.add_dependency "selenium-webdriver", "~> 4.0"
  spec.add_dependency "ruby-openai"
  spec.add_dependency "nokogiri"
end
