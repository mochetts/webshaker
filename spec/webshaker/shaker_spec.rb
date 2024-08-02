require "spec_helper"

RSpec.describe Webshaker::Shaker do
  let(:url) { "http://example.com" }
  let(:scrape_options) { {} }
  let(:shaker) { described_class.new(url, scrape_options) }
  let(:scraper) { instance_double("Webshaker::Scraper") }
  let(:ai_client) { instance_double(OpenAI::Client) }
  let(:scrape_result) { OpenStruct.new(html: "<html></html>") }

  before do
    allow(Webshaker::Scraper).to receive(:new).and_return(scraper)
    allow(scraper).to receive(:scrape).and_return(scrape_result)
    allow(OpenAI::Client).to receive(:new).and_return(ai_client)
  end

  describe "#initialize" do
    it "sets the url and scrape_options" do
      expect(shaker.url).to eq(url)
      expect(shaker.scrape_options).to eq(scrape_options)
    end
  end

  describe "#shake" do
    let(:prompt) { "Test prompt" }

    before do
      allow(ai_client).to receive(:chat).with(
        parameters: {
          model: "gpt-4o-mini",
          messages: [
            {role: "system", content: "You are an HTML interpreter. The user will give you the contents of an HTML and ask you something about it. Please comply with what the user asks."},
            {role: "user", content: "<html></html>"},
            {role: "user", content: prompt}
          ],
          temperature: 0.8
        }
      ).and_return({"choices" => [{"message" => {"content" => "response text"}}]})
    end

    it "returns the AI response" do
      expect(shaker.shake(with_prompt: prompt)).to eq("response text")
    end

    context "when respond_with is :json" do
      before do
        allow(ai_client).to receive(:chat).with(
          parameters: {
            model: "gpt-4o-mini",
            messages: [
              {role: "system", content: "You are an HTML interpreter. The user will give you the contents of an HTML and ask you something about it. Please comply with what the user asks."},
              {role: "user", content: "<html></html>"},
              {role: "user", content: prompt},
              {role: "user", content: "respond with json"}
            ],
            temperature: 0.8,
            response_format: {type: "json_object"}
          }
        ).and_return({"choices" => [{"message" => {"content" => '{"key": "value"}'}}]})
      end

      it "returns the AI response as JSON" do
        expect(shaker.shake(with_prompt: prompt, respond_with: :json)).to eq({"key" => "value"})
      end
    end
  end
end
