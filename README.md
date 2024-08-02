# Webshaker


|  Tests |  Coverage  |
|:-:|:-:|
| [![Tests](https://github.com/mochetts/webshaker/actions/workflows/main.yml/badge.svg?branch=main)](https://github.com/mochetts/webshaker/actions/workflows/main.yml)  |  [![Codecov Coverage](https://codecov.io/github/mochetts/webshaker/graph/badge.svg?token=SKTT14JJGV)](https://codecov.io/github/mochetts/webshaker) |

An intelligent web scraper that uses Selenium WebDriver to scrape a URL and parse it using AI.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "webshaker"
```

### Configuration

In rails applications, it's standard to provide an initializer (e.g `config/initializers/webshaker.rb`) to load all the configuration settings of the gem. If you follow the previous step (First Time Authorization), you can do the following:

```rb
Webshaker.configure do |config|
  # Your app private key. Typically stored in the environment variables as it's a sensitive secret.
  config.open_ai_key = ENV["WEBSHAKER_OPEN_AI_KEY"]

  # The model you want to use to analyze the html content.
  config.model = ENV["WEBSHAKER_OPEN_AI_MODEL"]
end
```

## Usage

### Basic usage

```ruby
# Create a shaker out of a specific URL.
# Make sure certain xpath is fulfilled before downloading the HTML content (to circumvent client dynamic hydration).
# You can also wait for css: {wait_for: {css: ".some-class"}}
# Or you can wait for some tag name: {wait_for: {tag_name: "body"}}
shaker = Webshaker::Shaker.new(
  "https://www.google.com",
  {wait_for: {xpath: "/html/body/div[1]/div[3]/form/div[1]/div[1]/div[1]/div/div[3]"}}
)

# Query anything about the website.
result = shaker.shake(with_prompt: "What's this website about?")
# => "This website appears to be the homepage of Google, specifically targeting users in Uruguay (as indicated by the reference to \"Uruguay\" and the Spanish language). It contains links to various Google services such as Gmail, Google Images, and a login page for Google accounts. Additionally, there are sections for user feedback, search functionalities, and links to Google policies and services. The layout includes buttons, forms, and elements for user interaction, typical of a search engine homepage."

result = shaker.shake(with_prompt: "Give me a list of all the links", respond_with: :json)
# =>
#  {"links"=>
#   ["https://mail.google.com/mail/&ogbl",
#    "https://www.google.com/imghp?hl=es-419&ogbl",
#    "https://accounts.google.com/ServiceLogin?hl=es-419&passive=true&continue=https://www.google.com/&ec=GAZAmgQ",
#    "/search?sca_esv=08a7c6c574dce941&sca_upv=1&q=vela+olimpiadas&oi=ddle&ct=335645951&hl=es-419&sa=X&ved=0ahUKEwiBsrmL9taHAxWGq5UCHV1hEJkQPQgC",
#    "https://about.google/?utm_source=google-UY&utm_medium=referral&utm_campaign=hp-footer&fg=1",
#    "https://www.google.com/intl/es-419_uy/ads/?subid=ww-ww-et-g-awa-a-g_hpafoot1_1!o2&utm_source=google.com&utm_medium=referral&utm_campaign=google_hpafooter&fg=1",
#    "https://www.google.com/services/?subid=ww-ww-et-g-awa-a-g_hpbfoot1_1!o2&utm_source=google.com&utm_medium=referral&utm_campaign=google_hpbfooter&fg=1",
#    "https://google.com/search/howsearchworks/?fg=1",
#    "https://policies.google.com/privacy?hl=es-419&fg=1",
#    "https://policies.google.com/terms?hl=es-419&fg=1",
#    "https://www.google.com/preferences?hl=es-419&fg=1",
#    "/advanced_search?hl=es-419&fg=1",
#    "/history/privacyadvisor/search/unauth?utm_source=googlemenu&fg=1&cctld=com",
#    "/history/optout?hl=es-419&fg=1",
#    "https://support.google.com/websearch/?p=ws_results_help&hl=es-419&fg=1"]}
```

## Development

You can use `bin/console` to access an interactive console. This will preload environment variables from a `.env` file.

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at <https://github.com/mochetts/webshaker>. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/mochetts/webshaker/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Revolut::Connect project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/mochetts/webshaker/blob/main/CODE_OF_CONDUCT.md).
