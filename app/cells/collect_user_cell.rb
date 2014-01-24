class CollectUserCell < Cell::Rails
  helper :application

  def show_all(opts = {})
    @user = opts[:user]
    @collect_users = opts[:collect_users]
    render
  end
end