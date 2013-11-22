class UserMailer < ActionMailer::Base
  default from: "mxbeijingmi@163.com"

  def login_send_mail(user)
    # @url  = 'http://example.com/login'
    # mail( :subject => 'Education abcAAAAAAAASDFADSFADSFADSFDASFASDF', 
    #       :to => "menxu_work@163.com", 
    #       :from => 'mxbeijingmi@163.com', 
    #       :body => 'ddddadfsafsadfsadfasdfsadfsdaf
    #       ddddadfsafsadfsadfasdfsadfsdafasfsadfsadfsdafasdfsadfdsa
    #       ddddadfsafsadfsadfasdfsadfsdafasfsadfsadfsdafasdfsadfdsa
    #       ddddadfsafsadfsadfasdfsadfsdafasfsadfsadfsdafasdfsadfdsa
    #       ddddadfsafsadfsadfasdfsadfsdafasfsadfsadfsdafasdfsadfdsa
    #       ddddadfsafsadfsadfasdfsadfsdafasfsadfsadfsdafasdfsadfdsa',
    #       :date => Time.now
    #     ) 
    @user = user
    @url  = "http://嘎嘎香.com/login"
    mail(:from => "mxbeijingmi@163.com", :to => user.email, :subject => "欢迎来到 嘎嘎香")
  end 
end
