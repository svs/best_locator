class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def facebook
    user = User.from_omniauth(request.env["omniauth.auth"])
    if user.persisted?
      binding.pry
      sign_in_and_redirect user, notice: "Signed in!"
    else
      session["devise.user_attributes"] = user.attributes
      redirect_to new_user_registration_url
    end
  end

end
