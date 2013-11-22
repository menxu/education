class AccountController < Devise::RegistrationsController

  def new
    super
  end

  def edit
    super
  end

  def create
    if !request.xhr?
      return super
    end

    build_resource

    if resource.save
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?
        sign_up(resource_name, resource)
        UserMailer.login_send_mail(@user).deliver unless @user.invalid?
        # respond_with resource, :location => after_sign_up_path_for(resource)
        render :json => {:sign_in => 'ok', :location => after_sign_up_path_for(resource)}
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
        expire_session_data_after_sign_in!
        # respond_with resource, :location => after_inactive_sign_up_path_for(resource)
        render :json => {:sign_in => 'ok', :location => after_inactive_sign_up_path_for(resource)}
      end
    else
      clean_up_passwords resource
      # respond_with resource
      render :json => resource.errors.map{|k, v| v}.uniq, :status => 403
    end
  end

  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    re = params[:by] == 'pwd' ? resource.update_with_password(resource_params) : resource.update_attributes(resource_params)

    if re
      if is_navigational_format?
        flash_key = update_needs_confirmation?(resource, prev_unconfirmed_email) ?
          :update_needs_confirmation : :updated
        set_flash_message :notice, flash_key
      end
      sign_in resource_name, resource, :bypass => true
      respond_with resource, :location => after_update_path_for(resource)
    else
      clean_up_passwords resource
      respond_with resource
    end
  end
end