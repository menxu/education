class IndexController < ApplicationController
  before_filter :authenticate_user!
  def index
    if !user_signed_in?
      return redirect_to '/account/sign_in'
    end

    return redirect_to "admin_home" if current_user.is_admin?
    # render :text => current_user.is_admin?
    # return redirect_to '/collect_users' if true

    return redirect_to "/user_home" if current_user.is_admin?

    return redirect_to "/collect_users"
  end

  def admin_home
    
  end

  def user_home
    
  end
end