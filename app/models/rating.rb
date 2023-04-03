class Rating < ApplicationRecord
  validates_presence_of :points
  validates_numericality_of :points, only_integer: true
  validates_uniqueness_of :user_id, scope: :movie_id

  belongs_to :rated_user, class_name: 'User', foreign_key: 'user_id'
  belongs_to :rated_movie, class_name: 'Movie', foreign_key: 'movie_id'
end
