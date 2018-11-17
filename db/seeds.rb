User.create!(name:  "Example",
             email: "example@gmail.com",
             affiliation: "管理者",
             employee_number: 1111,
             card_id: 1111,
             basic_work_time: "08:00",
             specified_work_start_time: "09:00",
             specified_work_end_time: "18:00",
             password:              "password",
             password_confirmation: "password",
             admin: true,
             activated: true,
             activated_at: Time.zone.now)

User.create!(name:  "Example1",
             email: "example2@gmail.com",
             affiliation: "社員B",
             employee_number: 2222,
             card_id: 2222,
             basic_work_time: "08:00",
             specified_work_start_time: "09:00",
             specified_work_end_time: "18:00",
             password:              "password",
             password_confirmation: "password",
             admin: true,
             activated: true,
             activated_at: Time.zone.now)

User.create!(name:  "Example2",
             email: "example3@gmail.com",
             affiliation: "社員C",
             employee_number: 3333,
             card_id: 3333,
             basic_work_time: "08:00",
             specified_work_start_time: "09:00",
             specified_work_end_time: "18:00",
             password:              "password",
             password_confirmation: "password",
             admin: true,
             activated: true,
             activated_at: Time.zone.now)

# 99.times do |n|
#   name     = Faker::Name.name
#   email    = "example-#{n+1}@railstutorial.org"
#   affiliation = "ユーザー"
#   password = "password"
#   User.create!(name:  name,
#               email: email,
#               affiliation: affiliation,
#               password:              password,
#               password_confirmation: password,
#               activated: true,
#               activated_at: Time.zone.now)
# end

# # マイクロポスト
# users = User.order(:created_at).take(6)
# 50.times do
#   content = Faker::Lorem.sentence(5)
#   users.each { |user| user.microposts.create!(content: content) }
# end

# # リレーションシップ
# users = User.all
# user  = users.first
# following = users[2..50]
# followers = users[3..40]
# following.each { |followed| user.follow(followed) }
# followers.each { |follower| follower.follow(user) }