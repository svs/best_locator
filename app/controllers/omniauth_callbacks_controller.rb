class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def all
    user = User.from_omniauth(request.env["omniauth.auth"])
    if user.persisted?
      respond_to do |format|
        format.html {
          flash[:notice] = "Signed in successfully"
          sign_in_and_redirect user
        }
        format.json {
          sign_in user
          render json: user
        }
      end
    else
      session["devise.user_attributes"] = user.attributes
      redirect_to new_user_registration_url
    end
  end

  alias :google_oauth2 :all
  alias :facebook :all

end
