require "openai"

module Webshaker
  class Shaker
    attr_reader :url, :scrape_options

    def initialize(url, scrape_options = {})
      @url = url
      @scrape_options = scrape_options
    end

    def shake(with_prompt:, respond_with: :text, temperature: 0.8)
      ai_result(
        with_prompt,
        respond_with:,
        temperature:
      )
    end

    private

    def html
      @html ||= Webshaker::Scraper.new(url, scrape_options).scrape.html
    end

    def ai_result(user_prompt, respond_with: :text, temperature: 0.8)
      response = ai_client.chat(
        parameters: {
          model: Webshaker.config.model,
          messages: ai_prompt(user_prompt, html).concat((respond_with == :json) ? [{role: "user", content: "respond with json"}] : []),
          temperature:
        }.merge(
          (respond_with == :json) ? {response_format: {type: "json_object"}} : {}
        )
      )
      response = response["choices"][0]["message"]["content"]
      response = JSON.parse(response) if respond_with === :json
      response
    end

    def ai_client
      @client ||= OpenAI::Client.new(access_token: Webshaker.config.open_ai_key)
    end

    def ai_prompt(user_prompt, html_content)
      [
        {role: "system", content: "You are an HTML interpreter. The user will give you the contents of an HTML and ask you something about it. Please comply with what the user asks."},
        {role: "user", content: html_content},
        {role: "user", content: user_prompt}
      ]
    end
  end
end
