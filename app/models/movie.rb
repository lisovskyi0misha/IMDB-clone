class Movie < ApplicationRecord
  validates_presence_of :title, :text, :category
  validates_uniqueness_of :title
  validates_numericality_of :rating, { in: (0..10) }

  has_many :ratings, dependent: :destroy
  has_many :rated_users, through: :ratings, class_name: 'User', dependent: :nullify
  has_one_attached :image, dependent: :destroy
  has_one_attached :trailer, dependent: :destroy

  enum category: %i[action fantasy western cartoon comedy]
end
