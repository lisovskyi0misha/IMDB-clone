class MoviesController < ApplicationController
  before_action :set_movie, only: %i[show edit update destroy]

  def index
    @movies = Movie.all
  end

  def show; end

  def new
    @movie = Movie.new
  end

  def edit; end

  def create
    @movie = Movie.new(movie_params)
    if @movie.save
      redirect_to root_path, notice: 'Movie was successfully created'
    else
      flash.alert = @movie.errors.full_messages.join(', ')
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @movie.update!(movie_params)
    redirect_to movie_path(@movie), notice: 'Movie was successfully updated'
  rescue ActiveRecord::RecordInvalid
    flash.alert = @movie.errors.full_messages.join(', ')
    render :edit, status: :unprocessable_entity
  end

  def destroy
    @movie.destroy
    redirect_to root_path, notice: 'Movie was successfully deleted'
  end

  private

  def set_movie
    @movie = Movie.find(params[:id])
  end

  def movie_params
    params.require(:movie).permit(:title, :text, :category)
  end
end
