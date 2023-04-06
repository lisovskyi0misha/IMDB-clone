class RatingPolicy
  def initialize(current_user, movie, rating = nil)
    @user = current_user
    @movie = movie
    @rating = rating
  end

  def new?
    return false if user.nil?

    !rating?
  end

  def edit?
    return false if user.nil?

    rating.user_id == user.id
  end

  def create?
    return false if user.nil?

    !rating?
  end

  def update?
    return false if user.nil?

    rating.user_id == user.id
  end

  def destroy?
    return false if user.nil?

    rating.user_id == user.id
  end

  private

  attr_reader :user, :movie, :rating

  def rating?
    movie.ratings.find_by(user_id: user.id).present?
  end
end
