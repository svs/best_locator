class HomeController < ActionController::Base

  def index
    if current_user
      redirect_to new_trip_path and return
    end
    render :layout => "application"
  end

end
