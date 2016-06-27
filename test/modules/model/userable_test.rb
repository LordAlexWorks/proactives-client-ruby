require 'test_helper'

class Proactives::Modules::Model::UserableTest < Minitest::Test
  class DummyUserClass
    include Proactives::Modules::Model::Userable
  end

  def test_create
    proactives_user_api.stubs(:create).returns(attributes)
    user = DummyUserClass.create(attributes[:id])

    assert user.id == attributes[:id]
  end

  def test_create_raises_InvalidRegistrationParams
    proactives_user_api.stubs(:create)
                       .raises(Proactives::Api::InvalidParamsError)

    assert_raises Proactives::Errors::InvalidRegistrationParams do
      DummyUserClass.create(attributes[:id])
    end
  end

  def test_find_by
    proactives_user_api.stubs(:find).returns(attributes)
    user = DummyUserClass.find_by(attributes[:id])

    assert user.id == attributes[:id]
  end

  def test_token_by_password
    proactives_user_api.stubs(:token_by_password).returns('token')
    token = DummyUserClass.token(username: 'username', password: 'password')

    assert token == 'token'
  end

  def test_token_by_password_raises_InvalidUsernameOrPassword
    proactives_user_api.stubs(:token_by_password)
                       .raises(Proactives::Api::OauthGetTokenByPasswordError)

    assert_raises Proactives::Errors::InvalidUsernameOrPassword do
      DummyUserClass.token(username: 'username', password: 'password')
    end
  end

  def test_token_by_code
    proactives_user_api.stubs(:token_by_code).returns('token')
    token = DummyUserClass.token(code: 'code', redirect_uri: 'redirect_uri')

    assert token == 'token'
  end

  def test_token_by_code_raises_InvalidAuthorizationCode
    proactives_user_api.stubs(:token_by_code)
                       .raises(Proactives::Api::OauthGetTokenByCodeError)

    assert_raises Proactives::Errors::InvalidAuthorizationCode do
      DummyUserClass.token(code: 'code', redirect_uri: 'redirect_uri')
    end
  end

  def test_send_reset_password_instructions
    proactives_user_api.stubs(:generate_new_password_email).returns(nil)

    response = DummyUserClass.send_reset_password_instructions(email: 'test@test.com')

    assert_nil response
  end

  def test_send_reset_password_instructions_raises_UserNotFound
    proactives_user_api.stubs(:generate_new_password_email)
                       .raises(Proactives::Api::NotFoundError, 'error')

    assert_raises Proactives::Errors::UserNotFound, 'error' do
      DummyUserClass.send_reset_password_instructions(email: 'test@test.com')
    end
  end

  def test_update_attributes_is_successful
    proactives_user_api.stubs(:update)
                       .returns(attributes.merge(username: 'newname'))
    user = DummyUserClass.new(attributes)

    result = user.update_attributes(username: 'newname')

    assert result
    assert user.username == 'newname'
  end

  def test_update_attributes_is_not_successful
    proactives_user_api.stubs(:update)
                       .raises(Proactives::Api::InvalidParamsError, 'error')
    user = DummyUserClass.new(attributes)

    result = user.update_attributes(username: 'newname')

    assert result == false
    assert user.errors.to_a.include? 'error'
  end

  def test_username
    user = DummyUserClass.new(attributes)
    assert user.username == attributes[:username]
  end

  def test_id
    user = DummyUserClass.new(attributes)
    assert user.id == attributes[:id]
  end

  def test_email
    user = DummyUserClass.new(attributes)
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
