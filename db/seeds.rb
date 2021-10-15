# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
groups = ["development","sales department","accounting division","planning department"]
groups.each do |name|
  Group.create!(name:name)
end

group = Group.find_by(name:"development")
group.users.create(name:"testuser",email:"testuser@email.com",password:"password",password_confirmation:"password",admin:true)
# User.create!(name:"testuser",email:"testuser@email.com",password:"password",password_confirmation:"password",admin:true)
10.times do |i|
  @group = Group.create!(name:"group#{i}")
  10.times do |j|
    name = "user#{i}#{j}"
    email = name + "@email.com"
    password = "password"
    @group.users.create!(name:name,email:email,password:password,password_confirmation:password)
  end
end
@group = Group.all
@group.each do |group|
  group.users.each do |user|
    10.times do |t|
      title = content =  "#{user.name}#{t} task"
      user.tasks.create!(title:title,content:content)
    end
  end
end
# 10.times do |i|
#   @group = Group.create!(name:"group#{i}")
#   10.times do |j|
#     name = "user#{i}#{j}"
#     email = name + "@email.com"
#     password = "password"
#     @user = @group.users.create!(name:name,email:email,password:password,password_confirmation:password)
#     3.times do |t|
#       title = "task #{i}#{t}"
#       content = "task content #{t}"
#       @user.tasks.create!(title:title,content:content)
#     end
#   end
# end
