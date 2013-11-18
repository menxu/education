class SessionsController < Devise::SessionsController
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
    return super
  end
end