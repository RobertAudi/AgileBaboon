namespace :baboon do
  desc "Populate the databse with sample data"
  task populate: :environment do
    puts "Resetting the database"

    Rake::Task['db:reset'].invoke

    puts "Database reset"

    puts "Installing agile baboon..."
    Rake::Task['baboon:install'].invoke

    print "Adding sample data..."
    %w[acme jupix google microsoft facebook oracle nokia apple twitter github hipchat codebase atlassian].each do |account_name|
      Client.create!(
        account_name: account_name,
        contact_name: "Robert Audi",
        contact_email: account_name + "@example.com"
      )
    end
    puts "Done"
  end
end
