class CategoriesController < ApplicationController
  def index
    @movies = Movie.where(category: categories)
  end

  private

  def categories
    return Movie.defined_enums['category'].keys unless params[:categories]

    params[:categories].split('-')
  end
end
