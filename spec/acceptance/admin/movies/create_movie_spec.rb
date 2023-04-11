require_relative '../../acceptance_helper'

feature 'create movie', %(
  Only admins can create movies
) do
  scenario 'Non-authenticated user tries to create a movie' do
    visit new_admin_movie_path
    expect(page).to have_content('You need to sign in or sign up before continuing')
  end

  scenario 'Authenticated regular user tries to create a movie' do
    sign_in(create(:user))
    visit new_admin_movie_path
    expect(page).to have_content('You don\'t have rights to access this page')
  end

  scenario 'Admin tries to create a movie' do
    sign_in(create(:user, :admin))
    visit new_admin_movie_path
    fill_in 'Title', with: 'Title 1'
    fill_in 'Text', with: 'Some movie description text'
    attach_file 'Image', "#{Rails.root}/spec/fixtures/test_image.png"
    attach_file 'Trailer', "#{Rails.root}/spec/fixtures/test_video.mp4"
    click_on 'Create'
    expect(page).to have_content('Movie was successfully created')
    visit admin_movie_path(id: Movie.first.id)
    expect(page).to have_css("img[src='#{url_for(Movie.first.image)}']")
    expect(page).to have_css("video[src*='#{rails_blob_path(Movie.first.trailer)}']")
  end
end
