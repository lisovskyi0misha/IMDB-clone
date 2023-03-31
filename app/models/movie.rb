class Movie < ApplicationRecord
  validates_presence_of :title, :text, :category
  validates_uniqueness_of :title
  validates_numericality_of :rating, { in: (0..10) }

  enum category: %i[action fantasy western cartoon comedy]
end
