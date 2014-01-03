class FileEntity < ActiveRecord::Base
  include FileEntityConvertMethodes
  include FileEntityDownload

  if Rails.env == 'test'
    file_part_upload :path => File.join(R::UPLOAD_BASE_PATH, 'files/test/:class/:id/:name'),
                     :url  => File.join("/",R::STATIC_FILES_DIR, 'files/test/:class/:id/:name')

  else
    file_part_upload :path => File.join(R::UPLOAD_BASE_PATH, 'files/:class/:id/:name'),
                     :url  => File.join("/", R::STATIC_FILES_DIR, 'files/:class/:id/:name')
  end

  has_many :media_resources

  EXTNAME_HASH = {
    :video => [
      'avi', 'rm',  'rmvb', 'mp4', 
      'ogv', 'm4v', 'mpeg', '3gp'
    ],
    :audio => [
      'mp3', 'wma', 'm4a',  'wav', 
      'ogg'
    ],
    :image => [
      'jpg', 'jpeg', 'bmp', 'png', 
      'png', 'svg',  'tif', 'gif'
    ],
    :document => [
      'xls', 'txt'
    ],
    :swf => [
      'swf'
    ],
    :ppt => [
      'ppt', 'pptx'
    ],
    :pdf => [
      'pdf'
    ],
    :flv => [
      'flv'
    ],
    :doc => [
      'doc', 'docx'
    ]
  }

  # 获取资源种类
  def extname
    File.extname(self.attach_file_name).downcase.sub('.', '')
  end

  def content_kind
    EXTNAME_HASH.each do |key, value|
      return key if value.include?(extname)
    end
    return nil
  end

  EXTNAME_HASH.each do |key, value|
    define_method "is_#{key}?" do
      key == self.content_kind
    end
  end
end