namespace :baboon do
  desc "Install agile baboon"
  task :install => :environment do
    unless Kong::User.find_by_username("admin")
      Kong::User.create!(
        :username => "admin",
        :email => "admin@example.com",
        :password => "password",
        :password_confirmation => "password"
      )
    end
  end
end
