class IndexController < ApplicationController
  before_filter :authenticate_user!
  def index
    # if !user_signed_in?
    #   return redirect_to '/account/sign_in'
    # end

    # return redirect_to "admin_home" if current_user.is_admin?
    # render :text => current_user.is_admin?
  end
end