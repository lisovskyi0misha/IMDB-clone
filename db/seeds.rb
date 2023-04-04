10.times do |n|
  category_list = Movie.defined_enums['category'].keys
  category = category_list[n] || category_list[n - 5]
  Movie.create(title: Faker::Movie.title, text: Faker::Movie.quote, category:)
end
