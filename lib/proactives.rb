require 'proactives/version'
require 'proactives/config'

# API
require 'proactives/api/invalid_params_error'
require 'proactives/api/invalid_token_error'
require 'proactives/api/not_authorized_error'
require 'proactives/api/not_found_error'
require 'proactives/api/oauth_get_authorize_url_error'
require 'proactives/api/oauth_get_token_by_code_error'
require 'proactives/api/oauth_get_token_by_password_error'
require 'proactives/api/oauth_provider'
require 'proactives/api/proactives_user'

# ERRORS
require 'proactives/errors/invalid_authorization_code'
require 'proactives/errors/invalid_registration_params'
require 'proactives/errors/invalid_username_or_password'
require 'proactives/errors/user_not_authenticated'
require 'proactives/errors/user_not_found'

# MODULES
require 'proactives/modules/controller/authenticable'
require 'proactives/modules/model/userable'
