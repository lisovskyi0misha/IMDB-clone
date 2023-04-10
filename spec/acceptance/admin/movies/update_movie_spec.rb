require_relative '../../acceptance_helper'

feature 'update movie', %(
  Only admins can update movies
) do
  given(:movie) { create(:movie) }

  scenario 'Non-authenticated user tries to update a movie' do
    visit edit_admin_movie_path(movie)
    expect(page).to have_content('You need to sign in or sign up before continuing')
  end

  scenario 'Authenticated regular user tries to update a movie' do
    sign_in(create(:user))
    visit edit_admin_movie_path(movie)
    expect(page).to have_content('You don\'t have rights to access this page')
  end

  scenario 'Admin tries to update a movie' do
    sign_in(create(:user, :admin))
    visit edit_admin_movie_path(movie)
    fill_in 'Title', with: 'Changed Title 1'
    click_on 'Update'
    expect(page).to have_content('Movie was successfully updated')
    visit admin_movie_path(movie)
    expect(page).to have_content('Changed Title 1')
  end
end
