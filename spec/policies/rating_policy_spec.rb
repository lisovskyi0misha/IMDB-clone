require 'rails_helper'
require_relative 'shared_examples/owner_related_examples.rb'

RSpec.describe RatingPolicy do
  describe '#new?' do
    subject(:new?) { described_class.new(current_user, movie).new? }
    let(:movie) { create(:movie) }

    include_examples 'where owner interferes'
  end

  describe '#edit?' do
    subject(:edit?) { described_class.new(current_user, movie, rating).edit? }
    let(:movie) { create(:movie) }
    let(:rating) { create(:rating, rated_movie: movie, rated_user: owner) }

    include_examples 'where owner required'
  end

  describe '#create?' do
    subject(:create?) { described_class.new(current_user, movie).create? }
    let(:movie) { create(:movie) }

    include_examples 'where owner interferes'
  end

  describe '#destroy?' do
    subject(:destroy?) { described_class.new(current_user, movie, rating).destroy? }
    let(:movie) { create(:movie) }
    let(:rating) { create(:rating, rated_movie: movie, rated_user: owner) }

    include_examples 'where owner required'
  end

  describe '#update?' do
    subject(:update?) { described_class.new(current_user, movie, rating).update? }
    let(:movie) { create(:movie) }
    let(:rating) { create(:rating, rated_movie: movie, rated_user: owner) }

    include_examples 'where owner required'
  end
end
