require "spec_helper"

RSpec.describe Webshaker::Ai do
  subject { described_class.new(html_content) }

  let(:ai_client) { instance_double(OpenAI::Client) }
  let(:html_content) { "<html></html>" }
  let(:prompt) { "prompt" }
  let(:temperature) { 0.8 }
  let(:respond_with) { :text }
  let(:ai_response) { "response text" }
  let(:ai_messages) {
    [
      {role: "system", content: "You are an HTML interpreter. The user will give you the contents of an HTML and ask you something about it. Please comply with what the user asks."},
      {role: "user", content: html_content},
      {role: "user", content: prompt}
    ]
  }
  let(:response_format) { {} }
  let(:client_response) { {"choices" => [{"message" => {"content" => ai_response}}]} }

  before do
    allow(OpenAI::Client).to receive(:new).and_return(ai_client)
    allow(ai_client).to receive(:chat).with(
      parameters: {
        model: "gpt-4o-mini",
        messages: ai_messages,
        temperature:
      }.merge(response_format)
    ).and_return(client_response)
  end

  describe "#analyze" do
    it "returns the ai response" do
      expect(subject.analyze(with_prompt: prompt)).to eq(ai_response)
    end

    context "when setting the response format and the temperature" do
      let(:temperature) { 0.5 }
      let(:respond_with) { :json }
      let(:ai_response) { {a: "b"}.to_json }
      let(:response_format) { {response_format: {type: "json_object"}} }

      before do
        ai_messages.push({role: "user", content: "respond with json"})
      end

      it "users the response format and the temperature" do
        expect(subject.analyze(with_prompt: prompt, respond_with:, temperature:)).to eq(JSON.parse(ai_response))
      end

      it "returns the full response" do
        expect(subject.analyze(with_prompt: prompt, respond_with: :json, temperature:, full_response: true)).to eq(client_response)
      end
    end
  end
end
