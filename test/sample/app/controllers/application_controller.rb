class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user, :current_user_name

  def current_user
    {:display_name => 'Jesse Dylan'}
  end

  def current_user_name
    current_user[:display_name]
  end

  def require_admin
  end
end
