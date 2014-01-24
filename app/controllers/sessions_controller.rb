class SessionsController < Devise::SessionsController
  layout Proc.new { |controller|
    if controller.request.headers['X-PJAX']
      return false
    end

    case controller.action_name
    when 'new', 'create'
      return 'auth'
    when 'edit'
      return 'account'
    else
      return 'account'
    end
  }
  
  def new
    super
    # 在这里添加其他逻辑
  end

  def new_two
    @for = :two
    self.new
  end

  def new_education
    @for = :education
    self.new
  end

  def create
    if !request.xhr?
      return super
    end
    self.resource = warden.authenticate!(auth_options)
    set_flash_message(:notice, :signed_in) if is_navigational_format?
    sign_in(resource_name, resource)
    ### respond_with resource, :location => after_sign_in_path_for(resource)
    render :json => {:sign_in => 'ok', :location => after_sign_in_path_for(resource)} # 必须响应 json 否则会被 jquery 判为 error
  end
end