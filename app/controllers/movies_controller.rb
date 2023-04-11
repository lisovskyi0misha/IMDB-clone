class MoviesController < ApplicationController
  before_action :set_movie, only: %i[show]

  def index; end

  def show
    @rating = @movie.ratings.find_by(user_id: current_user&.id)
  end

  private

  def set_movie
    @movie = Movie.includes(:ratings).find(params[:id])
  end
end
