# Client Factory
FactoryGirl.define do
  factory :client do
    sequence(:account_name)  { |n| "awesome#{n}" }
    sequence(:contact_name)  { |n| "Captain Awesome#{n}" }
    sequence(:contact_email) { |n| "awesome#{n}@example.com" }
  end
end
