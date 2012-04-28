# Client Factory
FactoryGirl.define do
  factory :client do
    sequence(:account_name)  { |n| "awesome#{n}" }
    sequence(:contact_name)  { |n| "Captain Awesome#{n}" }
    sequence(:contact_email) { |n| "awesome#{n}@example.com" }
  end

  factory :kong_user, :class => Kong::User do
    sequence(:username)              { |n| "user#{n}" }
    sequence(:email)                 { |n| "user#{n}@example.com" }
    sequence(:password)              { |n| "password" }
    sequence(:password_confirmation) { |n| "password" }
  end

  factory :user do
    sequence(:username)              { |n| "user#{n}" }
    sequence(:email)                 { |n| "user#{n}@example.com" }
    sequence(:password)              { |n| "password" }
    sequence(:password_confirmation) { |n| "password" }
  end
end
