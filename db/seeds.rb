# Программа для заполнения базы данных примерами пользователей.
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
               password:              password,
               password_confirmation: password)
end

#Сначала надо сбросить бд, а затем вызвать файл сид
# rails db:migrate:reset
# rails db:seed