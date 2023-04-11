module Admin
  class MoviesController < ApplicationController
    before_action :autenticate_and_authorize_user!
    before_action :set_movie, only: %i[show edit update destroy]

    layout 'admin_application'

    def index
      @movies = Movie.all
    end

    def show; end

    def new
      @movie = Movie.new
    end

    def create
      @movie = Movie.new(movie_params)
      if @movie.save
        redirect_to admin_movies_path, notice: 'Movie was successfully created'
      else
        flash.alert = @movie.errors.full_messages.join(', ')
        render :new, status: :unprocessable_entity
      end
    end

    def edit; end

    def update
      @movie.update!(movie_params)
      redirect_to admin_movie_path(@movie), notice: 'Movie was successfully updated'
    rescue ActiveRecord::RecordInvalid
      flash.alert = @movie.errors.full_messages.join(', ')
      render :edit, status: :unprocessable_entity
    end

    def destroy
      @movie.destroy
      redirect_to admin_movies_path, notice: 'Movie was successfully deleted'
    end

    private

    def set_movie
      @movie = Movie.find_by(id: params[:id])
    end

    def autenticate_and_authorize_user!
      authenticate_user!
      authorize_user!
    rescue AuthorizationError => e
      flash.alert = e.message
      redirect_to root_path
    end

    def authorize_user!
      raise AuthorizationError, 'You don\'t have rights to access this page' unless current_user.admin?
    end

    def movie_params
      params.require(:movie).permit(:title, :text, :category, :image, :trailer)
    end
  end
end
