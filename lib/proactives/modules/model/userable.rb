module Proactives
  module Modules
    module Model
      module Userable
        def self.included(base)
          base.extend ClassMethods
          base.send :include, ActiveModel::Model
          base.send :include, InstanceMethods
        end

        module ClassMethods
          def create(attributes)
            new(Proactives::Api::ProactivesUser.create(attributes))
          rescue Proactives::Api::InvalidParamsError => e
            raise Proactives::Errors::InvalidRegistrationParams, e
          end

          def find_by(user_access_token)
            return if user_access_token.nil?

            new(Proactives::Api::ProactivesUser.find(user_access_token))
          end

          def token(args = {})
            token = token_by_password(args[:username], args[:password])
            token = token_by_code(args[:code], args[:redirect_uri]) unless token
            token
          end

          def token_by_password(username, password)
            return unless username && password
            Proactives::Api::ProactivesUser.token_by_password(username, password)
          rescue Proactives::Api::OauthGetTokenByPasswordError
            raise Proactives::Errors::InvalidUsernameOrPassword,
                  'Invalid username or password'
          end

          def token_by_code(code, redirect_uri)
            return unless code && redirect_uri
            Proactives::Api::ProactivesUser.token_by_code(code, redirect_uri)
          rescue Proactives::Api::OauthGetTokenByCodeError => e
            raise Proactives::Errors::InvalidAuthorizationCode, e.message
          end

          def authorize_url(redirect_uri)
            Proactives::Api::ProactivesUser.authorize_url(redirect_uri)
          end

          def send_reset_password_instructions(attributes)
            Proactives::Api::ProactivesUser.generate_new_password_email(attributes)
          rescue Proactives::Api::NotFoundError => e
            raise Proactives::Errors::UserNotFound, e.message
          end
        end

        module InstanceMethods
          attr_accessor :id, :username, :email, :password, :avatar, :access_token,
                        :created_at, :updated_at

          def update_attributes(attributes)
            attributes = build_attributes_to_update(attributes)
            attributes = Proactives::Api::ProactivesUser.update(attributes)
            assign_attributes(attributes.symbolize_keys)
            true
          rescue Proactives::Api::InvalidParamsError,
                 Proactives::Api::NotAuthorizedError => e
            errors.add(:base, e.message)
            false
          end

          private

          def build_attributes_to_update(attributes)
            attributes = attributes.to_h.symbolize_keys
            attributes.delete(:password) if attributes[:password].blank?
            attributes[:avatar] = build_avatar(attributes[:avatar])
            attributes.delete(:avatar) if attributes[:avatar].blank?
            attributes.merge(id: id, access_token: access_token)
          end

          def build_avatar(avatar_image)
            return unless avatar_image.present?

            if avatar_image.instance_of? ActionDispatch::Http::UploadedFile
              {
                filename: avatar_image.original_filename,
                content_type: avatar_image.content_type,
                content: Base64.encode64(avatar_image.read),
                headers: avatar_image.headers
              }
            end
          end
        end
      end
    end
  end
end
