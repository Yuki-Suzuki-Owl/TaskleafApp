FactoryBot.define do
  factory :group do
    # name {"development"}
    sequence(:name) {|n| "group#{n}"}

    trait :with_10_users do
      after(:create) {|group| create_list(:user,10,group:group)}
    end
  end
end
