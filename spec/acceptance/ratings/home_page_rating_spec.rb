require_relative '../acceptance_helper'

feature 'rate movie from home page', %(
  Every authenticated user can rate movie from home page
  Rating form must be a pop-up
  User can rate movie only once
) do
  given(:movie) { create(:movie) }
  let(:user) { create(:user) }

  scenario 'Non-authrnticated user tries to rate a movie', js: true do
    movie
    visit root_path
    expect(has_link?(href: new_movie_rating_path(movie))).to be false
  end

  scenario 'Authenticated user tries to rate a movie for the first time', js: true do
    sign_in user
    movie
    visit root_path
    click_link(href: new_movie_rating_path(movie))
    within '.rate-pop-up' do
      expect(page).to have_content(movie.title)
    end
    find(:label, for: 'radio-button-10').click
    click_button 'Rate'
    expect(page).not_to have_css('.rate-pop-up')
  end

  scenario 'Authenticated user tries to rate a movie for more than the first time', js: true do
    sign_in user
    movie
    create(:rating, rated_movie: movie, rated_user: user)
    visit root_path
    expect(has_link?(href: new_movie_rating_path(movie))).to be false
  end
end
