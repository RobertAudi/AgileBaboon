# Client Factory
FactoryGirl.define do
  factory :client do
    sequence(:account_name)  { |n| "awesome#{n}" }
    sequence(:contact_name)  { |n| "Captain Awesome#{n}" }
    sequence(:contact_email) { |n| "awesome#{n}@example.com" }
  end

  factory :kong_user, :class => Kong::User do
    sequence(:username)   { |n| "user#{n}" }
    sequence(:email)      { |n| "user#{n}@example.com" }
    password              "password"
    password_confirmation { |u| u.password }
  end

  factory :user do
    sequence(:username)   { |n| "user#{n}" }
    sequence(:email)      { |n| "user#{n}@example.com" }
    password              "password"
    password_confirmation { |u| u.password }
    admin                 "0"

    # I need to hardcode the client id here due to FactoryGirl sucking ass
    client_id             1
  end

  factory :admin, class: User do
    sequence(:username)   { |n| "admin#{n}" }
    sequence(:email)      { |n| "admin#{n}@example.com" }
    password              "admin"
    password_confirmation { |u| u.password }
    admin                 "1"

    # I need to hardcode the client id here due to FactoryGirl sucking ass
    client_id             1
  end

  factory :superadmin, class: User do
    sequence(:username)   { |n| "admin#{n}" }
    sequence(:email)      { |n| "admin#{n}@example.com" }
    password              "admin"
    password_confirmation { |u| u.password }
    admin                 "1"

    # I need to hardcode the client id here due to FactoryGirl sucking ass
    client_id             1
  end

  factory :issue_type do
    sequence(:label) { |n| "BUG#{n}" }
  end

  factory :issue do
    sequence(:title)         { |n| "Issue ##{n}" }
    sequence(:description)   { |n| "This is issue ##{n}" }
    issue_type
    user
    client
    project
  end

  factory :project do
    sequence(:name)         { |n| "Project ##{n}" }
    sequence(:description)  { |n| "This is project ##{n}" }
  end
end
