require_relative '../acceptance_helper'

feature 'rate movie from show page',
  "\nAuthenticated user can rate any movie in range of 1 to 10 points
  Rating form must be a pop-up
  User can rate a movie only once\n" do
  given(:user) { create(:user) }
  given(:movie) { create(:movie) }

  scenario 'non-authenticated user tries to rate a movie' do
    visit movie_path(movie)
    expect(page).not_to have_link('Rate movie')
  end

  scenario 'authenticated user tries to rate a movie for the first time', js: true do
    sign_in user
    movie
    visit movie_path(movie)
    click_on 'Rate movie'
    find(:label, for: 'radio-button-10').click
    click_button 'Rate'
    expect(page).not_to have_css('.rate-pop-up')
    expect(page).to have_link('Change rating')
  end

  scenario 'authenticated user tries to rate a movie for the second time' do
    sign_in user
    create(:rating, rated_movie: movie, rated_user: user)
    visit movie_path(movie)
    expect(page).not_to have_link('Rate movie')
    expect(page).to have_link('Change rating')
  end
end
