FactoryBot.define do
  factory :movie do
    sequence(:title) { |n| "Movie #{n}" }
    text { 'Some movie description text' }
    category { :comedy }
  end
end
