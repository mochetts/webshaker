# frozen_string_literal: true

RSpec.describe Webshaker do
  it "has a version number" do
    expect(Webshaker::VERSION).to eq "0.0.5"
  end

  it "allows to configure" do
    Webshaker.configure do |config|
      config.open_ai_key = "client_id"
    end
    expect(Webshaker.config.open_ai_key).to eq("client_id")
  end
end
