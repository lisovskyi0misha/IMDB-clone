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

    owner?
  end

  def create?
    return false if user.nil?

    !rating?
  end

  def update?
    return false if user.nil?

    owner?
  end

  def destroy?
    return false if user.nil?

    owner?
  end

  private

  attr_reader :user, :movie, :rating

  def owner?
    if rating.present?
      rating.user_id == user.id
    else
      rating?
    end
  end

  def rating?
    movie.ratings.find_by(user_id: user.id).present?
  end
end
