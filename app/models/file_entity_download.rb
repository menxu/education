module FileEntityDownload
  def self.included(base)
    base.send :extend, ClassMethodes
  end
  module ClassMethodes
    def from_download_id(download_id)
      decode = Base64.decode64(download_id)
      self.find decode.split(",")[1].to_i
    end
  end
end