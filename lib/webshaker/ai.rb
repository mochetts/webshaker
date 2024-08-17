module Webshaker
  class Ai
    attr_reader :html_content, :status_update

    def initialize(html_content, status_update: ->(status) {})
      @html_content = html_content
      @status_update = status_update
    end

    def analyze(with_prompt:, model: Webshaker.config.model, respond_with: :text, temperature: 0.8, full_response: false)
      status_update.call(:ai_start)

      response = ai_client.chat(
        parameters: {
          model:,
          messages: messages(with_prompt).concat((respond_with.to_sym == :json) ? [{role: "user", content: "respond with json"}] : []),
          temperature:
        }.merge(
          (respond_with.to_sym == :json) ? {response_format: {type: "json_object"}} : {}
        )
      )

      # Return full response from the ai client if the respond_with is set to :full
      if full_response
        status_update.call(:ai_done)
        return response
      end

      response = response["choices"][0]["message"]["content"]
      response = JSON.parse(response) if respond_with.to_sym === :json

      status_update.call(:ai_done)
      response
    end

    private

    def ai_client
      @client ||= OpenAI::Client.new(access_token: Webshaker.config.open_ai_key)
    end

    def messages(user_prompt)
      [
        {role: "system", content: "You are an HTML interpreter. The user will give you the contents of an HTML and ask you something about it. Please comply with what the user asks."},
        {role: "user", content: html_content},
        {role: "user", content: user_prompt}
      ]
    end
  end
end
