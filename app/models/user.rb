# -*- coding: utf-8 -*-
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
                    :length => {:in => 2..20},
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
  columns_roles :roles_mask, :roles => [:admin, :manager, :teacher, :student]

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

  # 分别为学生和老师增加动态字段
  include DynamicAttr::Owner
  has_dynamic_attrs :admin_attrs,
                    :updater => lambda {AttrsConfig.get(:admin)}
  has_dynamic_attrs :teacher_attrs,
                    :updater => lambda {AttrsConfig.get(:teacher)}

  # 导入文件
  excel_import :admin, :fields => [:login, :name, :email],
                                :default => {:role => :admin}

  excel_import :student, :fields => [:login, :name, :email],
                                :default => {:role => :student}
  def self.import_excel(excel_file, role, password = '123456')
    users = self.parse_excel_student excel_file if role == :student
    users = self.parse_excel_admin excel_file if role == :admin
    
    users.each do |u|
      u.password = password
      u.password_confirmation = password
      u.save
    end
  end

  private
    def welcome_message
      UserMailer.welcome_message(self).deliver
    end

  include ShortMessage::UserMethods
  include MediaResource::UserMethods
end
