require "spec_helper"

RSpec.describe Webshaker::ScrapeResult do
  let(:screenshot_base64) { Base64.encode64("fake_screenshot_data") }
  let(:html_content) { "<html><body>Sample HTML content</body></html>" }
  let(:scrape_result) { described_class.new(screenshot_base64, html_content) }
  let(:output_dir) { Dir.mktmpdir }

  after do
    FileUtils.remove_entry(output_dir)
  end

  describe "#save_to" do
    before do
      scrape_result.save_to(output_dir)
    end

    it "saves the screenshot to the specified directory" do
      screenshot_path = File.join(output_dir, "screenshot.png")
      expect(File).to exist(screenshot_path)
      expect(File.read(screenshot_path)).to eq("fake_screenshot_data")
    end

    it "saves the HTML content to the specified directory" do
      html_path = File.join(output_dir, "content.html")
      expect(File).to exist(html_path)
      expect(File.read(html_path)).to eq(html_content)
    end
  end
end
