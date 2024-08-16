require "openai"

module Webshaker
  class Shaker
    attr_reader :url, :scrape_options

    def initialize(url, scrape_options = {})
      @url = url
      @scrape_options = scrape_options
    end

    def shake(with_prompt:, respond_with: :text, temperature: 0.8)
      ai.analyze(with_prompt:, respond_with: :text, temperature: 0.8)
    end

    private

    def html
      @html ||= Webshaker::Scraper.new(url, scrape_options).scrape.html
    end

    def ai
      @ai ||= Webshaker::Ai.new(html)
    end
  end
end
