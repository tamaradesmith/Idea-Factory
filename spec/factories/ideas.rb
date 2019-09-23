FactoryBot.define do
  factory :idea do
    title { Faker::Nation.nationality  }
    description { Faker::Hacker.say_something_smart  }
    user
  end
end
