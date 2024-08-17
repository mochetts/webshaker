require "openai"

module Webshaker
  class Shaker
    attr_reader :url, :scrape_options, :status_update

    def initialize(url, scrape_options = {}, status_update: ->(status) {})
      @url = url
      @scrape_options = scrape_options
      @status_update = status_update
    end

    def shake(with_prompt:, respond_with: :text, temperature: 0.8)
      ai.analyze(with_prompt:, respond_with: :text, temperature: 0.8)
    end

    private

    def html
      @html ||= Webshaker::Scraper.new(url, scrape_options, status_update:).scrape.html
    end

    def ai
      @ai ||= Webshaker::Ai.new(html, status_update:)
    end
  end
end
