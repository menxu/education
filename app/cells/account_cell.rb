class AccountCell < Cell::Rails
  helper :application
  
  def sign_in_form(opts = {})
    @for = opts[:for]
    render
  end

  def sign_up_form
    render
  end

  def sign_toggle(opts = {})
    @is_sign_up = opts[:sign_up]
    render
  end

  def sign_logo(opts = {})
    @for = opts[:for]
    render
  end
end
