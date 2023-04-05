class RatingsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_request, only: %i[new edit]
  before_action :set_movie
  before_action :set_rating, only: %i[edit update destroy]
  before_action :authorize, only: %i[update destroy]
  after_action :call_job, except: %i[new edit]

  def new
    @rating = @movie.ratings.build
  end

  def create
    @rating = @movie.ratings.create(points:, user_id: current_user.id)
    redirect_back(fallback_location: root_path) if @rating.invalid?
  end

  def edit; end

  def update
    @rating.update!(points:)
  rescue ActiveRecord::RecordInvalid
    redirect_back(fallback_location: root_path)
  end

  def destroy
    @rating.destroy
  end

  private

  def check_request
    redirect_to root_path unless turbo_frame_request?
  end

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
    redirect_back(fallback_location: root_path)
  end

  def points
    params.dig(:rating, :points)
  end
end
