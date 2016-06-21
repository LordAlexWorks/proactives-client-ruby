require 'faraday'

class Proactives::Api::ProactivesUser
  def self.find(user_access_token, http_client: Faraday,
                proactives_config: Proactives::Config.new)
    params = { access_token: user_access_token }
    url = proactives_config.find_user_api_url
    response = http_client.get(url, params)

    raise_user_api_error(response) unless response.success?

    JSON.parse(response.body)['user']
  end

  def self.create(attributes = {}, http_client: Faraday,
                  proactives_config: Proactives::Config.new)
    attributes = attributes.symbolize_keys
    params = attributes.merge(access_token: proactives_config.app_access_token)
    url = proactives_config.create_user_api_url
    response = http_client.post(url, params)

    raise_user_api_error(response) unless response.success?

    JSON.parse(response.body)['user']
  end

  def self.update(attributes, http_client: Faraday,
                  proactives_config: Proactives::Config.new)
    attributes = attributes.symbolize_keys
    params = attributes.merge(access_token: attributes.fetch(:access_token))
    url = proactives_config.update_user_api_url(attributes.fetch(:id))
    response = http_client.patch(url, params)

    raise_user_api_error(response) unless response.success?

    JSON.parse(response.body)['user']
  end

  def self.authorize_url(redirect_uri,
                         oauth_provider: Proactives::Api::OauthProvider.new)
    oauth_provider.authorize_url(redirect_uri)
  end

  def self.token_by_code(code, redirect_uri,
                         token_provider: Proactives::Api::OauthProvider.new)
    token_provider.token_by_code(code, redirect_uri)
  end

  def self.token_by_password(username, password,
                             token_provider: Proactives::Api::OauthProvider.new)
    token_provider.token_by_password(username, password)
  end

  def self.generate_new_password_email(attributes = {},
                                       http_client: Faraday,
                                       proactives_config: Proactives::Config.new)
    attributes = attributes.symbolize_keys
    params = { access_token: proactives_config.app_access_token,
               email: attributes.fetch(:email) }
    url = proactives_config.generate_new_password_email_api_url
    response = http_client.post(url, params)

    raise_user_api_error(response) unless response.success?
    nil
  end

  def self.raise_user_api_error(response)
    case response.status
    when 422
      raise Proactives::Api::InvalidParamsError, error_message(response)
    when 401
      raise Proactives::Api::InvalidTokenError, 'The access token is invalid'
    when 404
      raise Proactives::Api::NotFoundError, error_message(response)
    when 403
      raise Proactives::Api::NotAuthorizedError, 'Not authorized'
    end
  end

  def self.error_message(response)
    JSON.parse(response.body)['error']
  end
end
