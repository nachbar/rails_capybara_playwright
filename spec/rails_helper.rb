# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
# Uncomment the line below in case you have `--require rails_helper` in the `.rspec` file
# that will avoid rails generators crashing because migrations haven't been run yet
# return unless Rails.env.test?
require 'rspec/rails'
# Add additional requires below this line. Rails is not loaded until this point!

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
# Rails.root.glob('spec/support/**/*.rb').sort_by(&:to_s).each { |f| require f }

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove these lines.
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

# For capybara and playwright
require 'capybara/rspec'
require 'capybara/playwright' # Require the playwright driver

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_paths = [
    Rails.root.join('spec/fixtures')
  ]

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # You can uncomment this line to turn off ActiveRecord support entirely.
  # config.use_active_record = false

  # RSpec Rails uses metadata to mix in different behaviours to your tests,
  # for example enabling you to call `get` and `post` in request specs. e.g.:
  #
  #     RSpec.describe UsersController, type: :request do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://rspec.info/features/7-1/rspec-rails
  #
  # You can also this infer these behaviours automatically by location, e.g.
  # /spec/models would pull in the same behaviour as `type: :model` but this
  # behaviour is considered legacy and will be removed in a future version.
  #
  # To enable this behaviour uncomment the line below.
  # config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")
  #
  # == Capybara Settings == config from Gemini 2.5

  # Make Capybara DSL available in system specs
  config.include Capybara::DSL, type: :system

  # Set the default driver to Playwright
  Capybara.default_driver = :playwright
  # Also use Playwright for tests tagged with :js
  Capybara.javascript_driver = :playwright

  # Configure the Playwright driver
  Capybara.register_driver :playwright do |app|
    Capybara::Playwright::Driver.new(
      app,
      # Select the browser: :chromium, :firefox, or :webkit
      browser_type: :chromium,
      # Run in headless mode (no visible browser window) - Recommended for containers/CI
      headless: true, # Set to false if you somehow have X11 forwarding/VNC setup for debugging
      # You might need to adjust timeouts depending on your app and container performance
      # page_settings: { default_navigation_timeout: 10_000, default_timeout: 5_000 },
      # Other Playwright launch options can go here if needed
      # launch_options: { slow_mo: 50 } # Example: slows down execution for observation
    )
  end

  # Configure the Playwright driver for non-headless mode.
  #
  # TO USE THIS, change the
  # driven_by line in the system test config to use :playwright_non_headless
  # THEN, FROM A TERMINAL, run bin/start_vnc_server to start a VNC server
  # (tigervnc also has a server that worked for me)

  # THEN, CONNECT TO THE VNC SERVER ON localhost:5901 USING A VNC VIEWER

  # Of the VNC viewers:
  # The MacBook Screen Sharing asks for a password, and I could not get it to work with this setup.

  # However, using TigerVNC Viewer on the MacBook, I was able to connect to the VNC server and see the browser.
  # You can install TigerVNC Viewer using brew install --cask tigervnc-viewer
  # Then, you can run it from the Applications folder (TigerVNC Viewer), and connect to localhost:5901

  # Another option is to use RealVNC viewer.
  # After installation, RealVNC Viewer is in the Applications folder as "VNC Viewer"

  # When running the system tests, from a devcontainer terminal, use:
  # $ DISPLAY=:1 rspec spec/system/
  #
  # You can also use xterm with:
  # $ DISPLAY=:1 xterm
  # xterm does not play well with the vncviewer that homebrew installs with brew install tiger-vnc, and requires manual
  # refreshes.  The TigerVNC viewer app and RealVNC viewer app both work well with xterm and also refresh better
  # than the VNC viewer that homebrew installs with brew install tiger-vnc.
  #
  # IF YOU WANT TO SET A PASSWORD FOR THE VNC SERVER:
  # First, create the password file with:
  # # x11vnc -storepasswd
  # This will prompt you for a password and create a file ~/.vnc/passwd
  #
  # I could not locate a working vncpasswd command in the devcontainer

  # Then, start the server with a password file using bin/start_vnc_server_password, which starts the server with:
  # x11vnc -display :1 -rfbport 5901 -usepw -forever -listen 0.0.0.0 &
  # (removing the -nopw option and setting -useps, which defaults to using ~/.vnc/passwd)
  #
  # YOU MUST RUN RSPEC WITH DISPLAY=:1 TO CONNECT TO THE Xvfb DISPLAY
  # Otherwise, it will try to connect to the default display :0, which is not running
  # rspec will fail, with playwright telling you that you do not have an X display running.  Like:
  # DISPLAY=:1 bundle exec rspec ...
  #
  # AND DON'T FORGET TO CHANGE THE driven_by LINE IN THE SYSTEM TEST CONFIG TO USE :playwright_non_headless
  Capybara.register_driver :playwright_non_headless do |app|
    Capybara::Playwright::Driver.new(
      app,
      # Select the browser: :chromium, :firefox, or :webkit
      browser_type: :chromium,
      # Run in headless mode (no visible browser window) - Recommended for containers/CI
      headless: false, # Set to false if you somehow have X11 forwarding/VNC setup for debugging
        # You might need to adjust timeouts depending on your app and container performance
        # page_settings: { default_navigation_timeout: 10_000, default_timeout: 5_000 },
        # Other Playwright launch options can go here if needed
        # launch_options: { slow_mo: 50 } # Example: slows down execution for observation

        # Provided with non-headless
        # Optional: Increase timeouts if running non-headless is slower
        # page_settings: { default_navigation_timeout: 15_000, default_timeout: 7_000 },
        # Pass DISPLAY environment variable if needed (often handled globally)
        # launch_options: {
        #   env: { 'DISPLAY' => ENV['DISPLAY'] || ':1' }
        # }

      )
  end


  # == IMPORTANT: Devcontainer Network Configuration ==
  # Tell Capybara to bind the Rails server to all interfaces within the container
  Capybara.server_host = '0.0.0.0'

  # Tell Capybara how the browser (running inside the container) can reach the Rails server (also inside)
  # Option 1: If using docker-compose, use the service name and port
  # Replace 'web' with the name of your Rails app service in docker-compose.yml
  # Replace '3000' with the port your Rails app runs on *inside* the container
  # Capybara.app_host = "http://web:3000"

  # Option 2: If *not* using docker-compose (single container), localhost might work if the port is exposed
  # Capybara.app_host = "http://localhost:3000" # Check your setup

  # Determine the correct app_host based on your devcontainer setup (docker-compose or single container).
  # Often, using the server_port is sufficient if host is set correctly
  Capybara.server_port = 3010 # Use a different port for testing than your standard dev port (3000)
  Capybara.app_host = "http://#{IPSocket.getaddress(Socket.gethostname)}:#{Capybara.server_port}"


  # == System Test Configuration ==
  config.before(:each, type: :system) do
    # Use the :playwright driver for system tests by default

    # NOTE: to run system tests in a non-headless mode, you can use the :playwright_non_headless driver
    # driven_by :playwright
    driven_by :playwright_non_headless
  end

  # Optional: Configure Playwright page options for system tests
  # config.before(:each, type: :system, js: true) do
  #   page.driver.browser.contexts.first.set_default_navigation_timeout(10_000) # Example
  # end

  #
end
