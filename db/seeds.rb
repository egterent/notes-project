User.create!(name:  "Example User",
             email: "example@railstutorial.org",
             password:              "foobar",
             password_confirmation: "foobar",
             admin: true)

99.times do |n|
name  = Faker::Name.name
email = "example-#{n+1}@railstutorial.org"
password = "password"
User.create!(name:  name,
             email: email,
             password:              'password',
             password_confirmation: 'password')
end

users = User.order(:created_at).take(6)
5.times do
  name = Faker::Lorem.word
  users.each { |user| user.categories.create!(name: name) }
end

users = User.order(:created_at).take(6)
users.each do |user|
  categories = user.categories.where(parent_id: nil)
  categories.each do |category|
    name = Faker::Lorem.word
    user.categories.create!(name: name, parent_id: category.id)
  end
end
