User.create!(name:  "Grim",
             email: "bozya003@gmail.com",
             password:              "Ch1ens",
             password_confirmation: "Ch1ens",
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