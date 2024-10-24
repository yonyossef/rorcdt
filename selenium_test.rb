# selenium_test.rb

require 'selenium-webdriver'

begin
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('--headless')
  options.add_argument('--disable-gpu')
  options.add_argument('--no-sandbox')
  options.add_argument('--disable-dev-shm-usage') # Important for VM
  options.add_argument('--window-size=1400,1400')

  # Enable ChromeDriver logging
  options.logging_prefs = { browser: 'ALL', driver: 'ALL' }

  service = Selenium::WebDriver::Service.chrome(args: ['--log-path=chromedriver.log'])

  driver = Selenium::WebDriver.for :chrome, options: options, service: service

  driver.navigate.to "http://www.google.com"
  puts "Title: #{driver.title}"

  driver.quit
rescue Selenium::WebDriver::Error::SessionNotCreatedError => e
  puts "Error: #{e.message}"
end