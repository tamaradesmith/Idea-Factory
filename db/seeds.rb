# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Idea.destroy_all
User.destroy_all
Review.destroy_all
Like.destroy_all


NUM_IDEAS = 500
NUM_USERS = 15

PASSWORD = 'hudson'

NUM_USERS.times do
    first_name = Faker::Name.first_name
    last_name = Faker::Name.last_name
        User.create(
            first_name: first_name,
            last_name: last_name,
            email: "#{first_name}.#{last_name}@example.com",
            password: PASSWORD
        )
end

users = User.all

NUM_IDEAS.times do
 created_at = Faker::Date.backward(days: 365 * 5)
    i= Idea.create(
         title: Faker::Coin.name,
        description: Faker::Movies::HarryPotter.quote,
        created_at: created_at,
        updated_at: created_at,
        user: users.sample
    )
    if i.valid?
        i.reviews = rand(0..8).times.map do
            Review.new(body:Faker::GreekPhilosophers.quote, user: users.sample)

        end
        i.likers = users.shuffle.slice(0, rand(users.count/2))
    end
end

    ideas = Idea.all

    
    puts "Generated #{users.count} users"
    puts "Generated #{ideas.count} ideas"
    puts "login with password: #{PASSWORD}"