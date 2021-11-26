FactoryBot.define do
  factory :task do
    # title {"Sample task"}
    sequence(:title) {|n| "user task#{n}"}
    content {"This is sample task"}
    association :user
  end
end
