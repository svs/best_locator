module ApplicationHelper

  def profile_pic(user: current_user, style: {}, type: "square")
    image_tag "http://graph.facebook.com/#{user.uid}/picture?type=#{type}", :style => style
  end

end
