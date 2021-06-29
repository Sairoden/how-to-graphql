module Mutations
  class CreateUser < BaseMutation
    class AuthProviderSignupData < Types::BaseInputObject
      argument :credentials, Types::AuthProviderCredentialsInput, required: false
    end

    field :user, Types::UserType, null: false

    argument :name, String, required: true
    argument :auth_provider, AuthProviderSignupData, required: false

    def resolve (name:, auth_provider:)
      user = User.new(
        name: name,
        email: auth_provider&.[](:credentials)&.[](:email),
        password: auth_provider&.[](:credentials)&.[](:password)
      )
      
      if (user.save)
        {
          user: user,
          errors: []
        } else {
          user: nil,
          errors: user.errors.full_messages
        }
      end
    end
    
  end
end
