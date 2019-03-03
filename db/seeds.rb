User.create!(name:  "Example",
             email: "example@gmail.com",
             affiliation: "管理者",
             employee_number: 1111,
             card_id: 1111,
             basic_work_time: "08:00",
             specified_work_start_time: "09:00",
             specified_work_end_time: "18:00",
             password:              "foobar",
             password_confirmation: "foobar",
             admin: true,
             activated: true,
             activated_at: Time.zone.now)

User.create!(name:  "上長A",
             email: "superior@gmail.com",
             affiliation: "上長",
             employee_number: 2222,
             card_id: 2222,
             basic_work_time: "08:00",
             specified_work_start_time: "09:00",
             specified_work_end_time: "18:00",
             password:              "foobar",
             password_confirmation: "foobar",
             superior: true,
             activated_at: Time.zone.now)

User.create!(name:  "上長B",
             email: "superiorB@gmail.com",
             affiliation: "上長B",
             employee_number: 3333,
             card_id: 3333,
             basic_work_time: "08:00",
             specified_work_start_time: "09:00",
             specified_work_end_time: "18:00",
             password:              "foobar",
             password_confirmation: "foobar",
             superior: true,
             activated_at: Time.zone.now)

User.create!(name:  "一般社員",
             email: "example4@gmail.com",
             affiliation: "社員4",
             employee_number: 4444,
             card_id: 4444,
             basic_work_time: "08:00",
             specified_work_start_time: "09:00",
             specified_work_end_time: "18:00",
             password:              "foobar",
             password_confirmation: "foobar",
             activated: true,
             activated_at: Time.zone.now)

# 99.times do |n|
#   name     = Faker::Name.name
#   email    = "example-#{n+1}@railstutorial.org"
#   affiliation = "営業部#{n+1}"
#   employee_number= "#{n+1}"
#   card_id        = "#{n+1}"
#   basic_work_time= "08:00"
#   specified_work_start_time= "09:00"
#   specified_work_end_time= "18:00"
#   password= "password"
#   User.create!(name:  name,
#               email: email,
#               affiliation: affiliation,
#               employee_number: employee_number,
#               card_id: card_id,
#               basic_work_time: basic_work_time,
#               specified_work_start_time: specified_work_start_time,
#               specified_work_end_time: specified_work_end_time,
#               password:              password,
#               password_confirmation: password,
#               activated: true,
#               activated_at: Time.zone.now)
# end

# # # マイクロポスト
# # users = User.order(:created_at).take(6)
# # 50.times do
# #   content = Faker::Lorem.sentence(5)
# #   users.each { |user| user.microposts.create!(content: content) }
# # end

# # # リレーションシップ
# # users = User.all
# # user  = users.first
# # following = users[2..50]
# # followers = users[3..40]
# # following.each { |followed| user.follow(followed) }
# # followers.each { |follower| follower.follow(user) }