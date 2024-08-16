require "spec_helper"

RSpec.describe Webshaker::Shaker do
  let(:url) { "http://example.com" }
  let(:scrape_options) { {} }
  let(:shaker) { described_class.new(url, scrape_options) }
  let(:scraper) { instance_double("Webshaker::Scraper") }
  let(:ai) { instance_double("Webshaker::AI") }
  let(:scrape_result) { OpenStruct.new(html: "<html></html>") }
  let(:ai_result) { "response text" }
  let(:prompt) { "prompt" }

  before do
    allow(Webshaker::Scraper).to receive(:new).and_return(scraper)
    allow(Webshaker::Ai).to receive(:new).and_return(ai)
    allow(scraper).to receive(:scrape).and_return(scrape_result)
    allow(ai).to receive(:analyze).with(with_prompt: prompt, respond_with: :text, temperature: 0.8).and_return(ai_result)
  end

  describe "#initialize" do
    it "sets the url and scrape_options" do
      expect(shaker.url).to eq(url)
      expect(shaker.scrape_options).to eq(scrape_options)
    end
  end

  describe "#shake" do
    it "returns the AI response" do
      expect(shaker.shake(with_prompt: prompt)).to eq(ai_result)
    end

    context "when respond_with is :json" do
      let(:ai_result) { {"key" => "value"} }

      before do
        allow(ai).to receive(:analyze).with(with_prompt: prompt, respond_with: :json, temperature: 0.8).and_return(ai_result)
      end

      it "returns the AI response as JSON" do
        expect(shaker.shake(with_prompt: prompt, respond_with: :json)).to eq(ai_result)
      end
    end

    context "allows to set a temperature" do
      before do
        allow(ai).to receive(:analyze).with(with_prompt: prompt, respond_with: :text, temperature: 0.5).and_return(ai_result)
      end

      it "returns the AI response as JSON" do
        expect(shaker.shake(with_prompt: prompt, temperature: 0.5)).to eq(ai_result)
      end
    end
  end
end
