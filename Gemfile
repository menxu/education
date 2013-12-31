source 'http://ruby.taobao.org'

gem 'rails', '3.2.12'

gem 'mysql2', '0.3.11' # MYSQL数据库连接
gem 'json', '1.7.7'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

group :assets do
  gem 'sass-rails',   '~> 3.2.3'  # sass.scss
  gem 'coffee-rails', '~> 3.2.1'  #  js.coffee
  gem 'uglifier', '>= 1.0.3'
end

gem 'sunspot_rails', '2.0.0'
gem 'sunspot_solr',  '2.1.0'

group :test do
  gem 'database_cleaner', '~> 1.2.0'
  gem 'rspec-rails', '2.13.0' # rspec 测试
  gem 'factory_girl_rails', '~> 4.2.1' # yaml factory
  gem 'sunspot-rails-tester', '1.0.0'
end

group :examples do
  gem 'ruby-progressbar', '~> 1.0.2'   # 进度条 https://github.com/jfelchner/ruby-progressbar 
end

group :development do
  gem 'thin', '~> 1.5.1'
end

gem 'jquery-rails', '2.2.1'
gem 'jquery-ui-rails', '4.0.2'

gem 'unicorn', '4.6.2'

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

gem 'faye', '1.0.1'
gem 'celluloid'

## 用户角色
gem 'columns-roles',
    :git => 'git://github.com/topmi/columns-roles.git' 
    # tag -> 0.0.1

gem 'excel-import',
    :git => 'git://github.com/menxu/excel_import.git'
    #tag -> 0.0.1