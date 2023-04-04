class RatingCountJob < ApplicationJob
  def perform(movie_id)
    movie = Movie.find(movie_id)
    ratings = Rating.where(movie_id:).pluck(:points)
    new_rating = (ratings.sum / ratings.count).round(2)
    movie.update!(rating: new_rating)
  end
end
