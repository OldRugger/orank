# spec helper functions
module Helpers
  # Login helper for admin pages
  def admin_login
    user_name = 'admin'
    password = APP_CONFIG[:admin_pwd]
    token = ActionController::HttpAuthentication::Basic.encode_credentials(user_name, password)
    request.env['HTTP_AUTHORIZATION'] = token
  end
end
