module Proactives::Modules::Controller::Authenticable
  def self.included(base)
    base.helper_method :current_user, :user_signed_in?
    base.rescue_from Proactives::Api::InvalidTokenError, with: :invalid_token_error
  end

  def authenticate_user!
    return if user_signed_in?
    raise Proactives::Errors::UserNotAuthenticated, 'Please sign up or sign in!'
  end

  def current_user
    @current_user ||= User.find_by(session[:user_access_token])
  end

  def user_signed_in?
    current_user.present?
  end

  def send_reset_password_instructions(attributes = {})
    User.send_reset_password_instructions(attributes)
  end

  def sign_up_user(user_params)
    user = User.create(user_params)
    session[:user_access_token] = user.access_token
    @current_user = user
  end

  def sign_in_user(args = {})
    args[:redirect_uri] = callback_url if args[:code].present?
    token = User.token(password: args[:password], username: args[:username],
                       code: args[:code], redirect_uri: args[:redirect_uri])
    raise Proactives::Errors::UserNotAuthenticated if token.nil?

    session[:user_access_token] = token
  end

  def sign_out_user
    session[:user_access_token] = nil
  end

  def redirect_to_login_page
    redirect_to User.authorize_url(callback_url)
  end

  protected

  def callback_url
    raise NotImplementedError,
          'Implement this method to return the url that the user will be redirect to after login'
  end

  def invalid_token_error(_error)
    raise NotImplementedError,
          'Implement this method to handle the flow when the access token is invalid.'
  end
end
