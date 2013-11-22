class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :login, :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body

  validates :login, :format => {:with => /\A\w+\z/, :message => '只允许数字、字母和下划线'},
                    :length => {:in => 6..20},
                    :presence => true,
                    :uniqueness => {:case_sensitive => false},
                    :unless => Proc.new { |user|
                      user.login == user.email
                    }

  validates :email, :uniqueness => {:case_sensitive => false}

  def self.find_for_database_authentication(conditions)
    login = conditions.delete(:login)
    self.where(:login => login).first || self.where(:email => login).first
  end

  # ------------ 以上是用户登录相关代码，不要改动
  # ------------ 任何代码请在下方添加

  # 管理员修改基本信息
  attr_accessible :login, :name, :email, :role, :as => :manage_change_base_info
  # 修改基本信息
  attr_accessible :login, :name, :email, :as => :change_base_info
  # 修改密码
  attr_accessible :password, :password_confirmation, :as => :change_password

  # 声明角色
  attr_accessible :role
  validates :role, :presence => true
  roles_field :roles_mask, :roles => [:admin, :manager, :teacher, :student]

  attr_accessible :name

  before_validation :set_default_role
  def set_default_role
    self.role = :student if self.role.blank?
  end

  before_validation :set_login_for_internet_version
  def set_login_for_internet_version
    self.login = self.email if self.login.blank?
    if self.id.blank?
      self.password_confirmation = self.password
    end
  end

  private
    def welcome_message
      UserMailer.welcome_message(self).deliver
    end
end
