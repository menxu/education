class CollectUser < ActiveRecord::Base


  def self.import_from_csv(file)
    ActiveRecord::Base.transaction do
      p '==================  self methods'
      parse_csv_file(file) do |row,index|
        # course = Course.new(:name => row[0], :cid => row[1], :desc => row[4])
        # puts '---------'
        # puts row
        # puts '---------'
        if !course.save
          message = course.errors.first[1]
          raise "第 #{index+1} 行解析出错,可能的错误原因 #{message} ,请修改后重新导入"
        end
      end
    end
  end
end