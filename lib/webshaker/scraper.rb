require "selenium-webdriver"
require "base64"
require "nokogiri"

module Webshaker
  class Scraper
    attr_reader :url, :driver, :options

    def initialize(url, options = {})
      @url = url
      @options = options
      @driver = Selenium::WebDriver.for(
        :chrome,
        options: Selenium::WebDriver::Chrome::Options.new.tap(&method(:configure))
      )
    end

    def scrape
      driver.navigate.to url

      do_wait

      screenshot = driver.screenshot_as :base64
      html_content = driver.page_source
      driver.quit
      ScrapeResult.new(screenshot, clean_up(html_content))
    end

    def self.scrape(url, options = {})
      new(url, options).scrape
    end

    private

    def configure(driver_options)
      driver_options.add_argument("--headless") if options.fetch(:headless, true)
      driver_options
    end

    def do_wait
      wait_until = options[:wait_until]

      return if wait_until.nil?

      wait = Selenium::WebDriver::Wait.new(timeout: 10) # Waits a maximum of 10 seconds

      wait.until do
        if wait_until.is_a?(Proc)
          wait_until.call(driver)
        elsif wait_until.is_a?(Hash)
          selector = wait_until[:css] || wait_until[:tag_name] || wait_until[:xpath] || raise(ArgumentError, "wait_until must be a hash with one of these keys: :css, :tag_name, or :xpath")
          driver.find_element(wait_until.keys.first, selector)
        end
      end
    end

    def clean_up(html_content)
      # Parse the HTML content

      doc = Nokogiri::HTML5(html_content)

      # Remove scripts, styles, stylesheets and SVGs
      doc.xpath("//script").remove
      doc.xpath("//style").remove
      doc.xpath("//link").remove
      doc.xpath("//*[local-name() = 'svg']").remove

      # Recursively remove attributes from nodes (except href's)
      doc.traverse do |node|
        if node.element?
          node.attributes.each_key do |attr|
            node.remove_attribute(attr) unless attr == "href"
          end
        end
      end

      # Return the cleaned HTML (without newlines and with no spaces between tags)
      doc.inner_html.delete("\n").gsub(/>\s*</, "><")
    end
  end
end
