class CollectUser < ActiveRecord::Base


  def self.import_from_csv(file)
    ActiveRecord::Base.transaction do
      parse_csv_file(file) do |row,index|
        # course = Course.new(:name => row[0], :cid => row[1], :desc => row[4])
        puts "-----#{index}----"
        puts row[0]
        # puts row[0]
        # puts row[1]
        # puts row[2]
        # puts row[3]
        puts "-----#{index}----"
        # if !course.save
        #   message = course.errors.first[1]
        #   raise "第 #{index+1} 行解析出错,可能的错误原因 #{message} ,请修改后重新导入"
        # end
      end
    end
  end
end