module Webshaker
  class ScrapeResult
    attr_accessor :screenshot, :html

    def initialize(screenshot, html)
      @screenshot = screenshot
      @html = html
    end

    def save_to(output_dir_path)
      save_shot(output_dir_path)
      save_html(output_dir_path)
    end

    private

    def save_shot(output_dir_path)
      shot_path = File.join(output_dir_path, "screenshot.png")
      File.write(shot_path, Base64.decode64(screenshot))
    end

    def save_html(output_dir_path)
      html_path = File.join(output_dir_path, "content.html")
      File.write(html_path, html)
    end
  end
end
