FactoryBot.define do
  factory :movie do
    sequence(:title) { |n| "Movie #{n}" }
    text { 'Some movie description text' }
    category { :comedy }

    trait :action do
      category { :action }
    end

    trait :cartoon do
      category { :cartoon }
    end

    trait :comedy do
      category { :comedy }
    end

    trait :with_ratings do
      after(:create) do |movie|
        create_list(:rating, 3, rated_movie: movie)
      end
    end
  end
end
