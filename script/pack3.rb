# -*- coding: utf-8 -*-
def pack5
  user_path = Rails.root.join('script/data/user.xlsx')
  p '导入用户'

  user_data_arr = Util.parse_excel(user_path, :user)
  Util.import_user_by_data(user_data_arr)

  admin_path = Rails.root.join('script/data/admin.xlsx')
  p '导入管理员'
end

class Util
  def self.parse_excel(path, role)
    file = File.open(path,"r")
    spreadsheet = SimpleExcelImport::ImportFile.open_spreadsheet(file)
    data_arr = []
    (2..spreadsheet.last_row).each do |i|
      row = spreadsheet.row(i)

      login = row(0)
      name  = row(1)
      email = row(2)
      params = {
        :login => login,
        :name  => name,
        :email => email,
        :role  => role
      }
      data_arr << params
    end
    return data_arr
  end
end