namespace :baboon do
  desc "Populate the databse with sample data"
  task populate: :environment do
    puts "Resetting the database"

    Rake::Task['db:reset'].invoke

    puts "Database reset"

    30.times do
      contact_name = Faker::Name.name

      Client.create!(
        account_name: Faker::Company.name.split(" ").first.parameterize,
        contact_name: contact_name,
        contact_email: Faker::Internet.email(contact_name)
      )
    end
  end
end
