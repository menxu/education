require 'docsplit'

module Docsplit
  class ImageExtractor
    def resize_arg(size)
      return '' if size.nil?
      crop_arg = size[-1] == '#' ? " -gravity Center -crop #{size.gsub('#','')}+0+0" : ''
      "-resize #{size.gsub('#','^')}#{crop_arg}"
    end
  end
end

class CourseWareConverter
  include AppWorker
  sidekiq_options :queue => 'course_ware'
  Sidekiq::Queue['course_ware'].limit = 1

  def perform(entity_id)
    entity = FileEntity.find(entity_id)
    entity.convert_converting!
    sizes = ["100%","800x", "150x150#"]
    Docsplit.extract_images(entity.attach.path,
                            :output => entity.convert_output_dir,
                            :size   => sizes,
                            :format => [:png])
    sizes.zip(%[origin normal small]).map do |pair|
      pair.map do |item|
        File.join(entity.convert_output_dir,item)
      end
    end.each do |source_path, dest_path|
      if File.exists?(dest_path)
        FileUtils.rm_r  dest_path, :force => true
      end
      if File.exists?(source_path) && File.exists(dest_path)
        FileUtils.mv source_path, dest_path
      end
    end
    entity.convert_success!
  rescue Exception => ex
    puts ex
    puts ex.backtrace
    entity.convert_failed!
  end
end