Apartment.configure do |config|
  # These models will not be multi-tenanted, but remain in the global (public) namespace
  config.excluded_models = ["Client", "Kong::User", "IssueType", "Role"]

  # Dynamically get database names to migrate
  config.database_names = lambda { Client.select(:account_name).map(&:account_name) }

  # Don't prepend the environment to the database name in production
  config.prepend_environment = !Rails.env.production?
end
