class Api::V1::UsersController < Api::V1::BaseController

  before_filter :authenticate_user_from_token!
  before_filter :authenticate_user!

  def show
    @user = current_user
    respond_to do |format|
      format.json { render json: @user.to_json}
    end
  end



end
