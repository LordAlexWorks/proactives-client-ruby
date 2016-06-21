require 'test_helper'

class Proactives::Api::ProactivesUserTest < ActiveSupport::TestCase
  test '.update when success' do
    http_client = mock('http_client')
    http_client.expects(:patch).returns(http_client_response)

    response = Proactives::Api::ProactivesUser.update(
      { id: 123, username: 'u', access_token: 'access_token' },
      http_client: http_client
    )

    assert response, user_params
  end

  test '.update when status 422 raises InvalidParamsError' do
    http_client = mock('http_client')
    response = http_client_response(
      body: { 'error' => 'Error' }, status: 422, success: false
    )
    http_client.expects(:patch).returns(response)

    assert_raise Proactives::Api::InvalidParamsError do
      response = Proactives::Api::ProactivesUser.update(
        { access_token: 'access_token', id: 123 }, http_client: http_client
      )
    end
  end

  test '.update when status 403 raises NotAuthorizedError' do
    http_client = mock('http_client')
    response = http_client_response(body: '', status: 403, success: false)
    http_client.expects(:patch).returns(response)

    assert_raise Proactives::Api::NotAuthorizedError do
      response = Proactives::Api::ProactivesUser.update(
        { access_token: 'access_token', id: 123 }, http_client: http_client
      )
    end
  end

  test '.update when status 401 raises InvalidTokenError' do
    http_client = mock('http_client')
    response = http_client_response(body: '', status: 401, success: false)
    http_client.expects(:patch).returns(response)

    assert_raise Proactives::Api::InvalidTokenError do
      response = Proactives::Api::ProactivesUser.update(
        { access_token: 'access_token', id: 123 }, http_client: http_client
      )
    end
  end

  test '.create when success' do
    http_client = mock('http_client')
    http_client.expects(:post).returns(http_client_response(status: 201))

    response = Proactives::Api::ProactivesUser.create(http_client: http_client)

    assert response, user_params
  end

  test '.create when status 422 raises InvalidParamsError' do
    http_client = mock('http_client')
    response = http_client_response(
      body: { 'error' => 'Error' }, status: 422, success: false
    )
    http_client.expects(:post).returns(response)

    assert_raise Proactives::Api::InvalidParamsError do
      response = Proactives::Api::ProactivesUser.create(http_client: http_client)
    end
  end

  test '.create when status 403 raises NotAuthorizedError' do
    http_client = mock('http_client')
    response = http_client_response(body: '', status: 403, success: false)
    http_client.expects(:post).returns(response)

    assert_raise Proactives::Api::NotAuthorizedError do
      response = Proactives::Api::ProactivesUser.create(http_client: http_client)
    end
  end

  test '.create when status 401 raises InvalidTokenError' do
    http_client = mock('http_client')
    response = http_client_response(body: '', status: 401, success: false)
    http_client.expects(:post).returns(response)

    assert_raise Proactives::Api::InvalidTokenError do
      response = Proactives::Api::ProactivesUser.create(http_client: http_client)
    end
  end

  test '.find when success' do
    http_client = mock('http_client')
    http_client.expects(:get).returns(http_client_response)

    response = Proactives::Api::ProactivesUser.find('token', http_client: http_client)

    assert response, user_params
  end

  test '.find when access token is nil raises InvalidTokenError' do
    http_client = mock('http_client')
    response = http_client_response(body: '', status: 401, success: false)
    http_client.expects(:get).returns(response)

    assert_raise Proactives::Api::InvalidTokenError do
      Proactives::Api::ProactivesUser.find(nil, http_client: http_client)
    end
  end

  test '.token_by_password when success' do
    token_provider = mock('token_provider')
    token_provider.stubs(:token_by_password)
                  .with('username', 'password').returns('token')

    token = Proactives::Api::ProactivesUser.token_by_password('username', 'password',
                                                    token_provider: token_provider)

    assert token, 'token'
  end

  test '.token_by_password when failure raises OauthGetTokenByPasswordError' do
    token_provider = mock('token_provider')
    token_provider.stubs(:token_by_password)
                  .with('username', 'password')
                  .raises(Proactives::Api::OauthGetTokenByPasswordError)

    assert_raise Proactives::Api::OauthGetTokenByPasswordError do
      Proactives::Api::ProactivesUser.token_by_password('username', 'password',
                                              token_provider: token_provider)
    end
  end

  test '.token_by_code when success' do
    token_provider = mock('token_provider')
    token_provider.stubs(:token_by_code).with('code', 'redirect_uri')
                  .returns('token')

    token = Proactives::Api::ProactivesUser.token_by_code('code', 'redirect_uri',
                                                          token_provider: token_provider)

    assert token, 'token'
  end

  test '.token_by_code when failure raises OauthGetTokenByCodeError' do
    token_provider = mock('token_provider')
    token_provider.stubs(:token_by_code).with('code', 'redirect_uri')
                  .raises(Proactives::Api::OauthGetTokenByCodeError)

    assert_raise Proactives::Api::OauthGetTokenByCodeError do
      Proactives::Api::ProactivesUser.token_by_code('code', 'redirect_uri',
                                                    token_provider: token_provider)
    end
  end

  test '.authorize_url when success' do
    oauth_provider = mock('oauth_provider')
    oauth_provider.stubs(:authorize_url).returns('url')

    url = Proactives::Api::ProactivesUser.authorize_url('redirect_uri',
                                                        oauth_provider: oauth_provider)

    assert url, 'url'
  end

  test '.authorize_url when failure raises OauthGetAuthorizeUrlError' do
    oauth_provider = mock('oauth_provider')
    oauth_provider.stubs(:authorize_url)
                  .raises(Proactives::Api::OauthGetAuthorizeUrlError)

    assert_raise Proactives::Api::OauthGetAuthorizeUrlError do
      Proactives::Api::ProactivesUser.authorize_url('redirect_uri',
                                          oauth_provider: oauth_provider)
    end
  end

  test '.generate_new_password_email when success' do
    http_client = mock('http_client')
    http_client.expects(:post).returns(http_client_response(status: 200))

    response = Proactives::Api::ProactivesUser.generate_new_password_email(
      { email: 'test@test.com' }, http_client: http_client
    )

    assert_nil response
  end

  test '.generate_new_password_email when status 404 raises NotFoundError' do
    http_client = mock('http_client')
    response = http_client_response(body: { error: 'error' },
                                    status: 404, success: false)
    http_client.expects(:post).returns(response)

    assert_raise Proactives::Api::NotFoundError do
      response = Proactives::Api::ProactivesUser.generate_new_password_email(
        { email: 'test@test.com' }, http_client: http_client
      )
    end
  end

  test '.generate_new_password_email when status 403 raises NotAuthorizedError' do
    http_client = mock('http_client')
    response = http_client_response(body: '', status: 403, success: false)
    http_client.expects(:post).returns(response)

    assert_raise Proactives::Api::NotAuthorizedError do
      response = Proactives::Api::ProactivesUser.generate_new_password_email(
        { email: 'test@test.com' }, http_client: http_client
      )
    end
  end

  test '.generate_new_password_email when status 401 raises InvalidTokenError' do
    http_client = mock('http_client')
    response = http_client_response(body: '', status: 401, success: false)
    http_client.expects(:post).returns(response)

    assert_raise Proactives::Api::InvalidTokenError do
      response = Proactives::Api::ProactivesUser.generate_new_password_email(
        { email: 'test@test.com' }, http_client: http_client
      )
    end
  end

  def http_client_response(body: user_params, status: 200, success: true)
    response = mock('http_client_response')
    response.stubs(:body).returns(body.to_json)
    response.stubs(:status).returns(status)
    response.stubs(:success?).returns(success)
    response
  end

  def user_params
    {
      'user' =>
        {
          'id' => 1,
          'username' => 'test',
          'email' => 'test@test.com',
          'created_at' => '2016-05-27T11:23:46.596Z',
          'updated_at' => '2016-05-27T13:59:30.315Z'
        }
    }
  end
end
