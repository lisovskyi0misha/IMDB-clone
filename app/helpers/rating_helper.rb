module RatingHelper
  def can?(action, movie, current_user)
    RatingPolicy.new(current_user, movie).send("#{action}?".to_sym)
  end
end
