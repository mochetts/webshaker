require "spec_helper"

RSpec.describe Webshaker::Scraper do
  subject(:result) { scraper.scrape }

  let(:url) { "https://example.com" }
  let(:options) { {} }
  let(:status_updates) { [] }
  let(:status_update) {
    ->(status) { status_updates << status }
  }
  let(:scraper) { described_class.new(url, options, status_update:) }
  let(:mock_driver) { instance_double(Selenium::WebDriver::Driver) }
  let(:mock_navigate) { instance_double(Selenium::WebDriver::Navigation) }
  let(:mock_options) { instance_double(Selenium::WebDriver::Chrome::Options) }
  let(:mock_wait) { instance_double(Selenium::WebDriver::Wait) }
  let(:mock_element) { instance_double(Selenium::WebDriver::Element) }

  before do
    allow(Selenium::WebDriver).to receive(:for).and_return(mock_driver)
    allow(Selenium::WebDriver::Chrome::Options).to receive(:new).and_return(mock_options)
    allow(Selenium::WebDriver::Wait).to receive(:new).and_return(mock_wait)
    allow(mock_wait).to receive(:until).and_yield
    allow(mock_driver).to receive(:find_element).and_return(mock_element)
    allow(mock_options).to receive(:add_argument)
    allow(mock_options).to receive(:tap).and_yield(mock_options)
    allow(mock_driver).to receive(:navigate).and_return(mock_navigate)
    allow(mock_driver).to receive(:find_element).and_return(true)
    allow(mock_navigate).to receive(:to)
    allow(mock_driver).to receive(:screenshot_as).and_return("base64_screenshot")
    allow(mock_driver).to receive(:page_source).and_return("\n\n<html>    <head><script></script><link></link><style></style></head><body><svg><line></line></svg><a target='_blank' href='something'></a></body>   </html>\n")
    allow(mock_driver).to receive(:quit)
    result
  end

  describe "#initialize" do
    it "sets the url and options" do
      expect(scraper.url).to eq(url)
      expect(scraper.options).to eq(options)
    end

    it "initializes the driver with correct options" do
      expect(Selenium::WebDriver).to have_received(:for).with(:chrome, options: mock_options)
    end

    context "when headless option is set to false" do
      let(:options) { {headless: false} }

      it "does not add the headless argument" do
        expect(mock_options).not_to have_received(:add_argument).with("--headless")
      end
    end

    context "when headless option is not set" do
      it "adds the headless argument by default" do
        expect(mock_options).to have_received(:add_argument).with("--headless")
      end
    end
  end

  describe "#scrape" do
    it "navigates to the URL" do
      expect(mock_navigate).to have_received(:to).with(url)
    end

    it "takes a screenshot and gets page source" do
      expect(mock_driver).to have_received(:screenshot_as).with(:base64)
      expect(mock_driver).to have_received(:page_source)
    end

    it "quits the driver" do
      expect(mock_driver).to have_received(:quit)
    end

    it "returns a ScrapeResult" do
      expect(result).to be_a(Webshaker::ScrapeResult)
      expect(result.screenshot).to eq("base64_screenshot")
      expect(result.html).to eq("<html><head></head><body><a href=\"something\"></a></body></html>")
    end

    context "when wait_until option is set" do
      let(:options) { {wait_until: {css: ".some-class"}} }

      it "waits for the specified css element" do
        expect(Selenium::WebDriver::Wait).to have_received(:new).with(timeout: 10)
        expect(mock_driver).to have_received(:find_element).with(:css, ".some-class")
      end

      it "executes the status updates" do
        expect(status_updates).to eq [:scrape_init, :scrape_start, :scrape_waiting, :scrape_cleaning, :scrape_done]
      end
    end

    context "when wait_until option is set as a block" do
      let(:mock) { double(called: true) }
      let(:block) do
        ->(driver) do
          mock.called
        end
      end
      let(:options) { {wait_until: block} }

      it "waits for the specified css element" do
        expect(Selenium::WebDriver::Wait).to have_received(:new).with(timeout: 10)
        expect(mock).to have_received(:called)
      end
    end
  end

  describe ".scrape" do
    it "creates a new instance and calls scrape" do
      allow(described_class).to receive(:new).and_return(scraper)
      allow(scraper).to receive(:scrape)

      described_class.scrape(url, options)

      expect(described_class).to have_received(:new).with(url, options)
      expect(scraper).to have_received(:scrape)
    end
  end
end
