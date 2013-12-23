class Api::V1::UsersController < Api::V1::BaseController

  before_filter :authenticate_user_from_token!, except: :create
  before_filter :authenticate_user!, except: :create

  protect_from_forgery except: :create

  def show
    @user = current_user
    respond_to do |format|
      format.json { render json: @user.to_json}
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      render json: @user.to_json
    else
      render json: @user.errors, status: 422
    end
  end


  private

  def user_params
    params.require("user").permit("email","password","password_confirmation")
  end





end
