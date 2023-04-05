class RatingCountJob < ApplicationJob
  def perform(movie_id)
    movie = Movie.find(movie_id)
    ratings = Rating.where(movie_id:).pluck(:points)
    count = ratings.count
    new_rating = count.zero? ? 0 : (ratings.sum / count).round(2)
    movie.update!(rating: new_rating)
  end
end
