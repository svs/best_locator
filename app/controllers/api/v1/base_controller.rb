class Api::V1::BaseController < ActionController::Base

  class NotAuthenticated < StandardError; end
  class NotAuthorized < StandardError; end

  rescue_from ActiveRecord::RecordNotFound do
    render json: "Not found", :status => 404
  end

  rescue_from NotAuthorized do
    render json: "Not found", :status => 404
  end

  def authenticate_user_from_token!
    user_email = params[:user_email].presence
    user       = user_email && User.find_by_email(user_email)

    # Notice how we use Devise.secure_compare to compare the token
    # in the database with the token given in the params, mitigating
    # timing attacks.
    if user && Devise.secure_compare(user.auth_token, params[:user_token])
      sign_in user, store: false
    end
    authenticate_user!
  end

  def observed_user
    current_user
  end

end
