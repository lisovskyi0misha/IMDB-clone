require_relative '../acceptance_helper'

feature 'rate movie',
  "Authenticated user can rate any movie in range of 1 to 10 points
  Rating form must be a pop-up
  User can rate a movie only once" do
  given(:user) { create(:user) }
  given(:movie) { create(:movie) }

  scenario 'non-authenticated user tryes to rate a movie' do
    visit movie_path(movie)
    click_on 'Rate movie'
    expect(page).to have_content('You need to sign in or sign up before continuing')
  end

  scenario 'authenticated user tryes to rate a movie', js: true do
    sign_in user
    movie
    visit movie_path(movie)
    click_on 'Rate movie'
    choose(option: '10')
    click_button 'Rate'
    expect(page).not_to have_button('Rate')
    expect(page).to have_link('Change rating')
  end
end
