class CollectUsersController < ApplicationController
  before_filter :authenticate_user! #, :except => [:show, :questions, :users_rank]

  layout Proc.new { |controller|
    case controller.action_name
    when :show, :update
      return 'collect_user_show'
    when 'index', 'import'
      return 'collect_user'
    else
      return 'application'
    end
  }
  
  def index
    
  end


  def import
    
  end

  def download_import_file
    authorize! :manage, User
    send_file CollectUser.download_from_csv, :filename => 'collect_users.csv'
  end

  def import_from_csv

    CollectUser.import_from_csv(params[:csv_file])
    redirect_to "/collect_users"
  rescue Exception => ex
    flash[:error] = ex.message
    redirect_to "/collect_users/import"
  end
  
  def collect_user
    
  end

  def user_des
    
  end
end