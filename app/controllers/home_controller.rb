class HomeController < ActionController::Base

  def index
    if current_user
      if current_user.has_live_trip?
        redirect_to new_trip_path and return
      else
        redirect_to profile_path and return
      end
    end
    render :layout => "application"
  end

end
