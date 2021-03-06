# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

print("Example Userを作成...\n")
User.create!(
  name: "Example User", 
  email: "example@railstutorial.org",
  password: "foobar",
  password_confirmation: "foobar",
  admin: true,
  activated: true,
  activated_at: Time.zone.now)

print("99人のランダムなユーザを作成...")
99.times do |n|
  name = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(
    name: name,
    email: email,
    password: password,
    password_confirmation: password,
    activated: true,
    activated_at: Time.zone.now)
  if(n % 9 == 0)
    print("\#")
  end
end
print("完了\n")

print("サンプルのマイクロポストを作成...")
users = User.order(:created_at).take(6)
50.times do |n|
  content = Faker::Lorem.sentence(5)
  users.each {|user| user.microposts.create!(content: content)}
  if(n % 5 == 0)
    print("\#")
  end
  print("完了\n")
end