require_relative '../acceptance_helper'

feature 'Change movie rating', %(
  Authenticated user can change his rating to a rating in range of 1 to 10 points
  Rating form must be a pop-up
  User can change only his own rating) do
  given(:user) { create(:user) }
  given(:movie) { create(:movie) }

  scenario 'non-authenticated user tries to change rating' do
    visit movie_path(movie)
    expect(page).not_to have_link('Change rating')
  end

  scenario 'authenticated user tries to change rating of a movie he has already rated', js: true do
    sign_in user
    create(:rating, rated_movie: movie, rated_user: user, points: 5)
    visit movie_path(movie)
    click_on 'Change rating'
    find(:label, for: 'radio-button-10').click
    click_button 'Rate'
    expect(page).not_to have_css('.rate-pop-up')
    expect(page).to have_link('Change rating')
  end

  scenario 'authenticated user tries to change rating of a movie he has not rated yet' do
    sign_in user
    movie
    visit movie_path(movie)
    expect(page).not_to have_link('Change rating')
    expect(page).to have_link('Rate movie')
  end
end
