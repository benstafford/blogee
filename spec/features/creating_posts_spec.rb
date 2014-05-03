require 'spec_helper'

feature 'Creating posts' do
  before do
    @user = FactoryGirl.create(:user)
  end

  scenario 'with valid attributes' do
    # visit the posts path in the browser
    visit posts_path
    # find a link titled new post and click it
    click_link 'New Post'

    message = "You need to sign in or sign up before continuing."
    expect(page).to have_content(message)

    fill_in "Username", with: @user.username
    fill_in "Password", with: @user.password
    click_button "Sign in"

    # find the text field called Title and fill it in with the text
    visit posts_path
    click_link 'New Post'
    fill_in 'Title', with: 'My First Post'
    # find the text field called Content and fill it in with the text
    fill_in 'Content', with: 'Lorem ipsum dolor sit amet.'

    # find the button called Save and click it
    click_button 'Save'
    # Assert that there is now 1 post stored in the database
    expect(Post.count).to eq 1
    # load the last post from the database for assertions
    post = Post.last
    # assert the browsers current path to be the given path
    expect(current_path).to eq post_path(post)
    # assert that the posts title is correct
    expect(post.title).to eq 'My First Post'

    within "#title #author" do
      expect(page).to have_content("Created by: #{@user.username}")
    end
  end

  scenario 'with invalid attributes' do
    # visit the posts path in the browser
    visit posts_path
    # find a link titled New Post and click it
    click_link 'New Post'

    fill_in "Username", with: @user.username
    fill_in "Password", with: @user.password
    click_button "Sign in"

    click_link 'New Post'
    # find the button called Save and click it
    click_button 'Save'
    # assert that we are still on the form
    expect(current_path).to eq new_post_path
    # assert that we are getting the error flash
    expect(page).to have_css('.alert.alert-error')
  end

  scenario "Creating a post with an attachment" do
    visit posts_path
    click_link 'New Post'

    ### IF YOU HAVE Authentication in place
    fill_in "Username", with: @user.username
    fill_in "Password", with: @user.password
    click_button "Sign in"
    click_link 'New Post'
    ### END if authentication in place

    fill_in 'Title', with: 'My First Post'
    fill_in 'Content', with: 'Lorem ipsum dolor sit amet.'

    attach_file "File", "spec/fixtures/mogester1.jpg"
    click_button "Save"

    expect(page).to have_content("My First Post")

    within("#asset") do
      expect(page).to have_content("mogester1.jpg")
    end
  end
end
