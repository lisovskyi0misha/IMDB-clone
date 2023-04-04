FactoryBot.define do
  factory :user do
    name { 'Some name' }
    sequence(:email) { |n| "test#{n}@test" }
    password { '123123' }
    password_confirmation { '123123' }
    confirmed_at { Date.today }
  end
end
