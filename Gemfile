source 'http://ruby.taobao.org' #6222600910073212720

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

gem 'docsplit',      '0.7.2'

gem 'sidekiq', '2.8.0'
gem 'sidekiq-limit_fetch', '1.4'

gem 'slim', '1.3.8', :require => false
gem 'sinatra', '1.3.0', :require => false

group :test do
  gem "awesome_print"
  gem 'database_cleaner', '~> 1.2.0' # 加速测试时数据库清理
  gem 'rspec-rails', '2.13.0' # rspec 测试
  gem 'factory_girl_rails', '~> 4.2.1' # yaml factory
  gem 'capybara', '2.0.2' # 集成测试框架
  gem 'timecop', '0.6.1' # 用于在测试中调整时间
  gem 'rspec-cells', '0.1.7' # 用于测试 cells
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
gem "font-awesome-rails"

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

# 编码处理基础库
gem 'iconv', '1.0.2'

# 权限管理
gem "cancan", "~> 1.6.10"

## 用户角色
gem 'columns-roles',
    :git => 'git://github.com/topmi/columns-roles.git' 
    # tag -> 0.0.1

gem 'excel-import',
    :git => 'git://github.com/menxu/excel_import.git'
    #tag -> 0.0.1

## 页面布局辅助
gem 'simple-page-layout',
    :git => 'git://github.com/mindpin/simple-page-layout',
    :tag => '0.0.3'
gem 'simple-page-compoents',
    :git => 'git://github.com/mindpin/simple-page-compoents',
    :tag => '0.0.7.8'

## 文件分段上传
gem 'file-part-upload', 
    :git => 'git://github.com/mindpin/file-part-upload.git',
    :tag => '0.0.8'

## 给指定 activerecord 模型动态添加属性
gem 'dynamic_attrs',
    :git => 'git://github.com/kaid/dynamic_attrs.git',
    :tag => 'v0.0.1'