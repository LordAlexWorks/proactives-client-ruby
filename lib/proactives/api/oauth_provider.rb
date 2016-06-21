require 'oauth2'

class Proactives::Api::OauthProvider
  def initialize(proactives_config = Proactives::Config.new)
    @app_id = proactives_config.app_id
    @secret = proactives_config.secret
    @site = proactives_config.site_url
  end

  def token_by_code(code, redirect_uri)
    response = client.auth_code.get_token(code, redirect_uri: redirect_uri)
    response.token
  rescue OAuth2::Error => e
    raise Proactives::Api::OauthGetTokenByCodeError, e
  end

  def token_by_password(username, password)
    response = client.password.get_token(username, password)
    response.token
  rescue OAuth2::Error => e
    raise Proactives::Api::OauthGetTokenByPasswordError, e
  end

  def authorize_url(redirect_uri)
    client.auth_code.authorize_url(redirect_uri: redirect_uri, scope: 'public write')
  rescue OAuth2::Error => e
    raise Proactives::Api::OauthGetAuthorizeUrlError, e
  end

  def client
    OAuth2::Client.new(@app_id, @secret, site: @site)
  end
end
