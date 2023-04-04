FactoryBot.define do
  factory :movie do
    sequence(:title) { |n| "Movie #{n}" }
    text { 'Some movie description text' }
    category { :comedy }

    trait :with_ratings do
      after(:create) do |movie|
        create_list(:rating, 3, rated_movie: movie)
      end
    end
  end
end
