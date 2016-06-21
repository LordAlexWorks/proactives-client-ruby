require 'test_helper'

class Proactives::Modules::Model::UserableTest < ActiveSupport::TestCase
  class DummyUserClass
    include Proactives::Modules::Model::Userable
  end

  test '.create' do
    proactives_user_api.stubs(:create).returns(attributes)
    user = User.create(attributes[:id])

    assert user.id == attributes[:id]
  end

  test '.create raises InvalidRegistrationParams' do
    proactives_user_api.stubs(:create)
                       .raises(Proactives::Api::InvalidParamsError)

    assert_raise Proactives::Errors::InvalidRegistrationParams do
      User.create(attributes[:id])
    end
  end

  test '.find_by' do
    proactives_user_api.stubs(:find).returns(attributes)
    user = User.find_by(attributes[:id])

    assert user.id == attributes[:id]
  end

  test '.token by password' do
    proactives_user_api.stubs(:token_by_password).returns('token')
    token = User.token(username: 'username', password: 'password')

    assert token == 'token'
  end

  test '.token by password raises InvalidUsernameOrPassword' do
    proactives_user_api.stubs(:token_by_password)
                       .raises(Proactives::Api::OauthGetTokenByPasswordError)

    assert_raise Proactives::Errors::InvalidUsernameOrPassword do
      User.token(username: 'username', password: 'password')
    end
  end

  test '.token by code' do
    proactives_user_api.stubs(:token_by_code).returns('token')
    token = User.token(code: 'code', redirect_uri: 'redirect_uri')

    assert token == 'token'
  end

  test '.token by code raises InvalidAuthorizationCode' do
    proactives_user_api.stubs(:token_by_code)
                       .raises(Proactives::Api::OauthGetTokenByCodeError)

    assert_raise Proactives::Errors::InvalidAuthorizationCode do
      User.token(code: 'code', redirect_uri: 'redirect_uri')
    end
  end

  test '.send_reset_password_instructions' do
    proactives_user_api.stubs(:generate_new_password_email).returns(nil)

    response = User.send_reset_password_instructions(email: 'test@test.com')

    assert_nil response
  end

  test '.send_reset_password_instructions raises UserNotFound' do
    proactives_user_api.stubs(:generate_new_password_email)
                       .raises(Proactives::Api::NotFoundError, 'error')

    assert_raise Proactives::Errors::UserNotFound, 'error' do
      User.send_reset_password_instructions(email: 'test@test.com')
    end
  end

  test '#update_attributes is successful' do
    proactives_user_api.stubs(:update)
                       .returns(attributes.merge(username: 'newname'))
    user = User.new(attributes)

    result = user.update_attributes(username: 'newname')

    assert result
    assert user.username == 'newname'
  end

  test '#update_attributes is not successful' do
    proactives_user_api.stubs(:update)
                       .raises(Proactives::Api::InvalidParamsError, 'error')
    user = User.new(attributes)

    result = user.update_attributes(username: 'newname')

    assert_not result
    assert user.errors.to_a.include? 'error'
  end

  test '#username' do
    user = User.new(attributes)
    assert user.username == attributes[:username]
  end

  test '#id' do
    user = User.new(attributes)
    assert user.id == attributes[:id]
  end

  test '#email' do
    user = User.new(attributes)
    assert user.email == attributes[:email]
  end

  def attributes
    {
      id: 1,
      username: 'Test',
      email: 'test@test.com',
      access_token: 'token'
    }
  end

  def proactives_user_api
    Proactives::Api::ProactivesUser
  end
end
