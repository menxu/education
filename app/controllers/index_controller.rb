class IndexController < ApplicationController
  before_filter :authenticate_user!
  def index
    if !user_signed_in?
      return redirect_to '/account/sign_in'
    end
  end
end