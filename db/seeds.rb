# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Quote.destroy_all
Quote.create!(body: "May you live in interesting times", author: "unknown")
Quote.create!(body: "That which does not kill us makes us stronger.", author: "Friedrich Nietzsche")


100.times do 
  Quote.create!(body: Faker::Quote.famous_last_words, author: Faker::Name.unique.name)
end
