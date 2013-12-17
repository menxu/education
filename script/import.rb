# -*- coding: utf-8 -*-
require './script/helper.rb'
require './script/pack1.rb'
require './script/pack2.rb'

case ARGV[0]
when 'clear-pack-recodes'
  puts '删除脚本运行记录'
  `rm -rf tmp/scripts`
  exit
when 'clear-db'
  puts '清空数据库...'
  `rake db:drop rake db:create rake db:migrate > /dev/null`
  exit
end

prompt = %~
=========================================

            请选择要导入的数据包

=========================================

1.  用户, 管理员等相关用户用户
2.  删除所有用户
3.  导入excel用户

~

puts prompt

def get_choice
  print '请选择要导入的选项(1-3): '
  choice = gets.chomp.to_i
  return choice if (1..3) === choice
  get_choice
end

def run
  `mkdir -p tmp/scripts`
  choice = get_choice
  puts "准备运行选项---  #{choice}  .......\n\n"
  send "pack#{choice}"
end

run