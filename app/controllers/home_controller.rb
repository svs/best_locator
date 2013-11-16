class HomeController < ActionController::Base

  def index
    @user = current_user
    render :layout => "application"
  end

end
