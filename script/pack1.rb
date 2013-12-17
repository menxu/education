# -*- coding: utf-8 -*-
require './script/makers/user_maker'

def pack1
  User.destroy_all
  admin = User.create(:name     => '管理员',
                      :email    => 'admin@env.com',
                      :password => '123456',
                      :role     => :admin)

  ['users', 'admins'].each {|yaml| UserMaker.new(yaml).produce}
end