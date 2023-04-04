require 'rails_helper'

RSpec.describe Rating do
  it { should validate_presence_of(:points) }
  it { should validate_numericality_of(:points).only_integer }
  it { should validate_numericality_of(:points).is_in(1..10) }
  it do
    user = create(:user)
    movie = create(:movie)
    Rating.create(user_id: user.id, movie_id: movie.id, points: 5)
    should validate_uniqueness_of(:user_id).scoped_to(:movie_id)
  end

  it { should belong_to(:rated_movie).class_name('Movie') }
  it { should belong_to(:rated_user).class_name('User') }
end
