require "webshaker/scrape_result"
require "webshaker/scraper"
require "webshaker/shaker"

module Webshaker
  class Configuration
    attr_accessor :open_ai_key, :model

    def initialize
      @open_ai_key = ENV.fetch("WEBSHAKER_OPEN_AI_KEY", nil)
      @model = ENV.fetch("WEBSHAKER_OPEN_AI_MODEL", "gpt-4o-mini")
    end
  end

  class << self
    attr_writer :config

    def config
      @config ||= Webshaker::Configuration.new
    end

    def configure
      yield(config)
    end
  end
end
