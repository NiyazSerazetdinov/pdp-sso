class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  PROVIDERS = %i(facebook vkontakte)

  PROVIDERS.each do |provider|
    define_method(provider) do
      if user_signed_in?
        link_identity_and_current_user
      else
        identity = Identity.find_by(provider: auth_data.provider, uid: auth_data.uid)
        user = User.find_by(email: auth_data.info.email)

        if identity.present?
          sign_in_and_redirect identity.user
        elsif user.present?
          user.identities.create(provider: auth_data.provider, uid: auth_data.uid, user: user)

          sign_in_and_redirect user
          redirect_to new_user_registration_url, notice: "Please finish registering"
        end
      end
    end
  end

  private

  def auth_data
    request.env["omniauth.auth"]
  end

  def link_identity_and_current_user
    if current_user.identities.find_by(provider: auth_data.provider, uid: auth_data.uid).any?
      redirect_to root_path, notice: "Already linked that account!"
    else
      Identity.create(
        provider: auth_data.provider
        uid: auth_data.uid
        user: current_user
      )
      redirect_to root_path, notice: "Successfully linked that account!"
    end
  end
end
