class MediaResource < ActiveRecord::Base
  include MediaResourceCrudMethods
  include MediaResourceDownload

  attr_accessible :name,
                  :is_dir,
                  :creator,
                  :media_resources,
                  :file_entity,
                  :is_removed

  belongs_to :file_entity

  belongs_to :creator, :class_name  => 'User',
                       :foreign_key => 'creator_id'

  belongs_to :dir, :class_name  => 'MediaResource',
                   :foreign_key => 'dir_id',
                   :conditions  => {:is_dir => true}

  has_many   :media_resources, :foreign_key => 'dir_id',
                               :order => "name asc"

  validates  :creator, :presence => true

  validates  :name, :uniqueness => {
                      :case_sensitive => false,
                      :scope => [:dir_id, :creator_id]
                    }
  
  scope :dir_res,  :conditions => ['is_dir = ?', true]
  scope :root_res, :conditions => ['dir_id = ?', 0]

  class InvalidPathError < Exception; end
  class RepeatedlyCreateFolderError < Exception; end
  class NotAssignCreatorError < Exception; end
  class FileEmptyError < Exception; end
  class NotDirError < Exception; end
  class RootDir
    def self.media_resources
      MediaResource.root_res
    end
  end

  module UserMethods
    extend ActiveSupport::Concern

    included do
      has_many :media_resources, :foreign_key => 'creator_id'
    end

    def set_default_media_resource_dirs
      return true if !self.media_resources.root_res.dir_res.blank?
      
      names = YAML.load_file(Rails.root.join('config/default_media_resource_dir.yaml'))["default_dir"]
      names.each do |name|
        MediaResource.create_folder(self, File.join('/', name))
      end
      return true
    rescue
      true
    end
  end
end