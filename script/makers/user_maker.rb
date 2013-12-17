require './script/makers/base_maker.rb'

class UserMaker < BaseMaker
  
  set_producer{|real_name, index|
    num = index + 1
    User.create(_user_attrs(real_name, num))
  }

  def _name_template(num)
    "#{self.type}#{num}"
  end

  def _user_attrs(real_name, num)
    {
      name:     real_name,
      password: 123456,
      email:    "#{_name_template(num)}@dnv.dev",
      role:     self.type
    }
  end
end