# -*- coding: utf-8 -*-

# 产生一个随机字符串
def randstr(length=8)
  base = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  size = base.size
  re = '' << base[rand(size-10)]
  (length - 1).times {
    re << base[rand(size)]
  }
  re
end

# 转换文件名为 mime-type
def file_content_type(file_name)
  MIME::Types.type_for(file_name).first.content_type
rescue
  ext = file_name.split(".")[-1]
  case ext
  when 'rmvb'
    'application/vnd.rn-realmedia'
  else
    'application/octet-stream'
  end
end

# 生成重名文件标示，例如: bla.jpg -> bla(1).jpg, bla(1).jpg -> bla(2).jpg
def rename_duplicated_file_name(file_name)
  file_ext = File.extname file_name
  file_basename = File.basename file_name, file_ext
  dup_note_reg = /\((\d)\)$/
  dup_note_match = file_basename.match dup_note_reg
  new_file_basename = dup_note_match ? file_basename.sub(dup_note_reg, "(#{dup_note_match[1].to_i + 1})") : file_basename + '(1)'

  new_file_basename + file_ext
end

def parse_csv_file(file)
  raise '请先选择 一个 CSV 文件' if file.blank?
  if File.extname(file.original_filename) != '.csv'
    raise '你导入的不是一个 CSV 文件'
  end
  require 'csv'
  rows = CSV::parse(file.read)
  puts "----------===========  #{rows}"
  puts "----------===========  #{rows[0]}"
  puts "----------===========  #{rows[0].join(",")}"

  # puts "----------===========  #{rows[0].join(",").utf8?}"
  # is_utf8 = rows[0].join(",").utf8?
  # puts "----------===========  #{is_utf8}"
  rows.each_with_index do |row,index|
    # next if index == 0
    # row = row.map{|v|(v || "").gb2312_to_utf8} if !is_utf8
    puts row
    puts '  '
    yield row,index
  end
end