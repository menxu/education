class LayoutCell < Cell::Rails
  helper :application
  
  def google_analytics_code
    render
  end

  def topnav(opts = {})
    @user = opts[:user]
    render
  end

  def searchbar(opts = {})
    @user = opts[:user]
    render
  end

  def sidebar(opts = {})
    @user = opts[:user]
    render
  end


  def login
    render
  end

  def tfoot
    render
  end
end
