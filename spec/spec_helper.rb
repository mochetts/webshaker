# frozen_string_literal: true

if ENV["COVERAGE_DIR"]
  require "simplecov"
  SimpleCov.coverage_dir(ENV["COVERAGE_DIR"])
  if ENV["CI"]
    require "simplecov-cobertura"
    SimpleCov.formatter = SimpleCov::Formatter::CoberturaFormatter
  end
  SimpleCov.start
end

require "bundler/setup"
require "webmock/rspec"
require "webshaker"
require "dotenv"
Dotenv.load(".env.test")
require "dotenv/autorestore"
Bundler.require(:default, :development, :test)

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
