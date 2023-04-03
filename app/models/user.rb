class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  validates_presence_of :name

  has_many :ratings
  has_many :rated_movies, through: :ratings, class_name: 'Movie'
end
