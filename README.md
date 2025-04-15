# Simple devcontainer Rails App
## Using RSpec, capybara, and playwright for system tests, and allowing non-headless browser observation via VNC 

### Shout-out to Gemini for helping me sort this out

This Ruby on Rails app is very simple, and just for demonstration of configuration.

I wanted to be able to do system tests within a devcontainer, and using RSpec, capybara, playwright, and to be able to view the tests running in the browser over a VNC connection.

I also wanted to be able to make screenshots and create playwright trace files.

In practice, however, the non-headless feature is probably not as important as I had thought, given the effectiveness of the playwright trace files.

Although I could not get the playwright trace viewer to run within the devcontainer, there are other ways to use the Playwright Trace Viewer, and probably none easier than using the online viewer tool at https://trace.playwright.dev

### Creating the Ruby on Rails app with rails-new

To create the new Rails app, I used the "rails-new" application from https://github.com/rails/rails-new

rails-new allows you to create the rails app even without having ruby and/or rails installed on your system.  See their docs for prerequisites, which mostly include Docker - I used Docker Desktop on my Intel MacBook.

On the rails-new site, the compiled applications are on the releases page at https://github.com/rails/rails-new/releases . 

The trick is to find the "Assets" disclosure triangle and click on it to show the available versions.  Until you click that triangle, you will not see the versions.

As of rails-new v0.5.0 (16 Jan 2025), rails-new automatically downloads the latest available version of rails to the container, so you don't have to wait until a new version of rails-new is generated to be able to use the most current version of rails.  

Alternatively, you could create the app with `rails new`, or however you want, or you could start with an existing project to add this functionality.

I included the steps I used as commit messages, starting with generating the app with 

`rails-new my_awesome_app -T -d postgresql --devcontainer`

Then, with the Visual Studio Code devcontainer extension installed, when opening the folder in VS Code, the extension notices that there is a devcontainer configuration, and offers to build and connect to the devcontainer.

### Documentation for running system tests, and sample system tests

In addition to the commit messages, most of the instructions for the system tests are in the source files, especially spec/rails_helper.rb

A sample system test is in spec/system/simple_spec.rb, including configuring to save a playwright trace and to save a screen.  It appears that, when there is a test failure, a .png of the page is also saved.

### Additional Notes

playwright and its browsers are installed using the post-create devcontainer.json script rather than the Dockerfile, in order to use the correct user for the installation.  That installation did not work when included in the Dockerfile instead of devcontainer.json .

Although I include the code for non-headless browser, viewwed over VNC, I am not sure it is necessary to use non-headless, in that the playwright trace viewer is so effective.  

The instructions for changing system tests to use non-headless are in spec/rails_helper.rb 

If you do not want the installation for non-headless capability, just use the commit just before the "make non-headless playwright a possibility ..." commit.

For the VNC viewer, I did not have good luck with either the Mac Screen Sharing (which insisted on collecting a password) nor the TigerVNC viewer app installed that homebrew installs with `brew install tiger-vnc`  However, the TigerVNC Viewer installed with `brew install --cask tigervnc-viewer` (which is installed into the Applications folder) worked fine, as did the VNC Viewer installed by RealVNC, also found in the Applications folder.

To use non-headless, see the instructions in spec/rails_helper.rb to change driven_by, and start the XServer.  There are scripts at `bin/start_vnc_server` and `bin/start_vnc_server_password` to start the XServer, either with or without a password.

If you do want to use a password, it must be set before calling the script, but if you do not you will get a message telling you how to do it.

Not using a password is not as dangerous as it sounds, because VS Code will only map the port to localhost.

Once you have started the XServer, you can connect to it using one of the VNC Viewers, at localhost:5901

If you do use `driven_by :playwright_non_headless`, be sure to include `DISPLAY=:1` before your rspec or xterm calls, like:

`DISPLAY=:1 rspec spec/system`

or, for an xterm into the container:

`DISPLAY=:1 xterm`

If you forget the DISPLAY=:1 (or forget to start the XServer, or misspell DISPLAY), you will get an error from playwright:

`Looks like you launched a headed browser without having a XServer running.  Set either 'headless: true' or use 'xvfb-run <your-playwright-app>' before running Playwright.  <3 Playwright Team`

The instructions are included as comments in spec/rails_helper.rb