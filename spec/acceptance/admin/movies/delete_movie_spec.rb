require_relative '../../acceptance_helper'

feature 'delete movie', %(
  Only admins can delete movies
) do
  given(:movie) { create(:movie, title: 'Test movie title') }

  scenario 'Non-authenticated user tries to delete a movie' do
    visit admin_movie_path(movie)
    expect(page).to have_content('You need to sign in or sign up before continuing')
  end

  scenario 'Authenticated regular user tries to delete a movie' do
    sign_in(create(:user))
    visit admin_movie_path(movie)
    expect(page).to have_content('You don\'t have rights to access this page')
  end

  scenario 'Admin tries to delete a movie from show page' do
    sign_in(create(:user, :admin))
    visit admin_movie_path(movie)
    click_on 'Delete this movie'
    visit admin_movies_path
    expect(page).not_to have_content(movie.title)
  end

  scenario 'Admin tries to delete a movie from index page' do
    movie
    sign_in(create(:user, :admin))
    visit admin_movies_path
    # save_and_open_page
    within "#movie_#{movie.id}" do
      click_on 'Delete'
    end
    expect(page).not_to have_content(movie.title)
  end
end
