require_relative '../acceptance_helper'

feature 'pagination', %(
  Users can see movies partially with pagination
  1 page contains 5 movies
) do
  given(:movies) { create_list(:movie, 5) }
  given(:last_movie) { create(:movie, title: 'Last movie title') }

  scenario 'User tries to use pagination', js: true do
    movies
    last_movie
    visit movies_path
    expect(page).not_to have_content('Last movie title')
    click_on 'Next'
    expect(page).to have_content('Last movie title')
  end
end
