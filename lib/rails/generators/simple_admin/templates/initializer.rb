SimpleAdmin.setup do |config|
  config.require_user_method = :require_admin
  config.current_user_method = :current_user
  config.current_user_name_method = :current_user_name

  # config.site_title = "My Website"
end
