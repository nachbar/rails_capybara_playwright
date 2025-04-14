# spec/system/homepage_spec.rb
require 'rails_helper'

RSpec.describe "Simple Spec", type: :system do
  it "loads successfully and generates trace and screenshot" do
    # create a trace file.  Using starting the trace viewer within the devcontainer
    # does not seem to work, but you can view the trace file at https://
    # --- Start Tracing ---
    page.driver.with_playwright_page do |playwright_page|
      playwright_context = playwright_page.context
      playwright_tracing = playwright_context.tracing # Access the tracing object

      playwright_tracing.start(
        name: "trace_started_correctly", # Optional name
        screenshots: true,
        snapshots: true,
        sources: true
      )
    end # End of block for starting

    # --- Visit the page ---
    visit "/posts"

    save_and_open_page

    expect(page).to have_content("Posts") # Check for content on your homepage
    expect(page).to have_http_status(:ok) # Verify the page loaded successfully
    # expect(page.title).to include("My Rails App") # Check the page title

    # --- Stop Tracing and Save;
    #  view the saved trace.zip file at https://trace.playwright.dev
    page.driver.with_playwright_page do |playwright_page|
      playwright_context = playwright_page.context
      playwright_tracing = playwright_context.tracing # Access the tracing object again

      # Ensure the directory exists or use a full path.
      trace_path = Rails.root.join("tmp/capybara_traces/trace-final-#{Time.now.to_i}.zip")
      FileUtils.mkdir_p(File.dirname(trace_path)) # Ensure directory exists

      playwright_tracing.stop(path: trace_path.to_s)
    end # End of block for stopping
  end

  it "can create a post" do
    visit "/posts" # Visit the posts index page
    expect(page).to have_content("Posts") # Check for content on your homepage
    click_link "New post" # Click on the link to create a new post
    expect(page).to have_current_path('/posts/new') # Check that we are on the new post page
    expect(page).to have_content("New post") # Check for the new post form title
    expect(page).to have_field('Title') # Check for the title field
    expect(page).to have_field('Body') # Check for the body field
    expect(page).to have_button('Create Post') # Check for the create post button
    # Fill in the form fields
    fill_in 'Title', with: 'My Awesome Article Title'
    fill_in 'Body', with: 'Here is the body of my awesome article.'
    click_button 'Create Post' # Click the button to create the post
    expect(page).to have_content('Post was successfully created.') # Check for success message
    expect(page).to have_content('My Awesome Article Title') # Check for the title of the created post
    expect(page).to have_content('Here is the body of my awesome article.') # Check for the body of the created post
    # save_and_open_page
  end
end
