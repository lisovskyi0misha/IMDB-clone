class FiltersController < ApplicationController
  before_action :check_request

  def index
    @pagy, @movies = pagy(Movie.where(category: categories).with_attached_image)
  end

  private

  def check_request
    redirect_to root_path unless turbo_frame_request?
  end

  def categories
    return valid_categoties unless params[:categories]

    common_categories.empty? ? valid_categoties : common_categories
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
