FactoryBot.define do
  factory :user do
    name {"Sample User"}
    # email {"sample@email.com"}
    sequence(:email) {|n|"user#{n}@email.com"}
    password {"password"}
    association :group

    trait :with_5_tasks_and_5_group_tasks do
      after(:create) {|user| create_list(:task,5,user:user)}
      after(:create) { |user|
        for task in user.tasks
          create_list(:group_task,1,group:user.group,task:task)
        end
      }
    end

  end
end
