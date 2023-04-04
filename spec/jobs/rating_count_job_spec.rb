require 'rails_helper'

RSpec.describe RatingCountJob do
  subject(:job) { described_class.perform_later(movie.id) }
  let!(:movie) { create(:movie, :with_ratings, rating: 5) }

  context 'when created' do
    before { create(:rating, points: 9, rated_movie: movie) }

    it 'adds points to rating' do
      perform_enqueued_jobs { job }
      movie.reload
      expect(movie.rating).to eq(6.0)
    end
  end

  context 'when updated' do
    before { movie.ratings.last.update(points: 2) }

    it 'change points in rating' do
      perform_enqueued_jobs { job }
      movie.reload
      expect(movie.rating).to eq(4.0)
    end
  end

  context 'when deleted' do
    before do
      create(:rating, points: 8, rated_movie: movie)
      movie.ratings.first.destroy
    end

    it 'removes points from rating' do
      perform_enqueued_jobs { job }
      movie.reload
      expect(movie.rating).to eq(6.0)
    end
  end
end
