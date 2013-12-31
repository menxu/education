HASH = {
  :libreoffice_path  => '/opt/libreoffice3.6',
  :convert_base_path => '../public'
}

class R
  LIBREOFFICE_PATH = HASH[:libreoffice_path]
  CONVERT_BASE_PATH = File.expand_path(HASH[:convert_base_path], Rails.root.join('config'))

  STATIC_FILES_DIR = "static_files"
  UPLOAD_BASE_PATH = File.join(CONVERT_BASE_PATH, STATIC_FILES_DIR)

  # -------------------

  WEIBO_KEY = HASH[:weibo_key]
  WEIBO_SECRET = HASH[:weibo_secret]

  GITHUB_KEY = HASH[:github_key]
  GITHUB_SECRET = HASH[:github_secret]

  # -------------------

  EMAIL_ADDRESS  = ''
  EMAIL_USER     = ''
  EMAIL_PASSWORD = ''
end