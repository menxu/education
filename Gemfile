source 'http://ruby.taobao.org'

gem 'mysql2', '0.3.11' # MYSQL数据库连接
gem 'json'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

group :assets do
  gem 'sass-rails',   '~> 3.2.3'  # sass.scss
  gem 'coffee-rails', '~> 3.2.1'  #  js.coffee
  gem 'uglifier', '>= 1.0.3'
end

group :test do
  gem 'rspec-rails', '2.13.0' # rspec 测试
  gem 'factory_girl_rails', '~> 4.2.1' # yaml factory
end

group :examples do
  gem 'ruby-progressbar', '~> 1.0.2'   # 进度条 https://github.com/jfelchner/ruby-progressbar 
end

group :development do
  gem 'thin', '~> 1.5.1'
end

gem 'jquery-rails', '2.2.1'
gem 'jquery-ui-rails', '4.0.2'

gem 'unicorn'

# 登录验证
gem 'devise', '2.2.4'
# 权限管理
gem "cancan", "~> 1.6.10"

# 页面渲染
gem 'haml', '4.0.3' # HAML模板语言
gem 'cells', '3.8.8' # 用于复用一些前端组件
gem 'simple_form', '2.0.2' # 用于简化表单创建

# 文件上传 
gem "carrierwave", "0.8.0"
# carrierwave 用到的图片切割
gem "mini_magick", "3.5.0", :require => false

gem 'faye'
gem 'celluloid'

## 用户角色
gem 'roles-field'