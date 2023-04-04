FactoryBot.define do
  factory :rating do
    points { 5 }
    association :rated_movie, factory: :movie
    association :rated_user, factory: :user
  end
end
