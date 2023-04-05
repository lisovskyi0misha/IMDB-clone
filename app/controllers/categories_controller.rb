class CategoriesController < ApplicationController
  before_action :check_request

  def index
    @movies = Movie.where(category: categories)
  end

  private

  def check_request
    redirect_to root_path unless turbo_frame_request?
  end

  def categories
    return valid_categoties unless params[:categories]

    common_categories.empty? ? show_alert : common_categories
  end

  def show_alert
    flash.alert = 'Invalid category'
    redirect_to root_path
  end

  def valid_categoties
    @_valid_categoties ||= Movie.defined_enums['category'].keys
  end

  def common_categories
    @_common_categories ||= valid_categoties.intersection(params_categories)
  end

  def params_categories
    @_params_categories ||= params[:categories].split('-')
  end
end
