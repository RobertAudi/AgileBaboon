namespace :baboon do
  desc "Install agile baboon"
  task install: :environment do
    # Add an admin user to Kong
    unless Kong::User.find_by_username("admin")
      print "Creating admin user..."
      Kong::User.create!(
        username: "admin",
        email: "admin@example.com",
        password: "admin",
        password_confirmation: "admin"
      )
      puts "Done"
    end

    # Add default issue types
    print "Adding default issue types..."
    %w[TODO FIXME NOTE BUG CHANGED OPTIMIZE XXX !!!].each do |issue_type|
      unless IssueType.find_by_label(issue_type)
        IssueType.create!(label: issue_type)
      end
    end
    puts "Done"
  end
end
