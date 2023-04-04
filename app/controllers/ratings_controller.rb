class RatingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_movie
  before_action :set_rating, only: %i[update destroy]
  before_action :authorize, only: %i[update destroy]
  after_action :call_job

  def create
    @rating = @movie.ratings.create(points:, user_id: current_user.id)
    redirect_back(fallback_location: movies_path) if @rating.invalid?
  end

  def update
    @rating.update!(points:)
  rescue ActiveRecord::RecordInvalid
    redirect_back(fallback_location: movies_path)
  end

  def destroy
    @rating.destroy
  end

  private

  def call_job
    return unless @rating.saved_change_to_points? || @rating.destroyed?

    RatingCountJob.perform_later(@movie.id)
  end

  def set_movie
    @movie = Movie.find_by(id: params[:movie_id])
  end

  def set_rating
    @rating = Rating.find_by(id: params[:id])
  end

  def authorize
    return if @rating.user_id == current_user.id

    flash.alert = "You can\'t #{params[:action]} other\'s ratings"
    redirect_back(fallback_location: movies_path)
  end

  def points
    params.dig(:rating, :points)
  end
end
