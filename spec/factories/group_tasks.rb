FactoryBot.define do
  factory :group_task do
    association :group
    association :task
  end
end
