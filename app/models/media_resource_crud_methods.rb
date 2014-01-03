module MediaResourceCrudMethods
  extend ActiveSupport::Concern

  module CreateMethods
    extend ActiveSupport::Concern

    module ClassMethods
      def create_folder(creator, resource_path)
        raise MediaResource::RepeatedlyCreateFolderError if !self.get(creator, resource_path).blank?

        with_exclusive_scope do
          dir_names = split_path(resource_path)
          return _mkdirs_by_names(creator, dir_names)
        end
      rescue MediaResource::InvalidPathError
        return nil
      end

      private

        def _mkdirs_by_names(creator, dir_names)
          collect = creator.media_resources.root_res
          dir_resource = MediaResource::RootDir

          dir_names.each {|dir_name|
            dir_resource = collect.find_or_initialize_by_name_and_creator_id(dir_name, creator.id)
            dir_resource.update_attributes :is_removed => false, :is_dir => true
            collect = dir_resource.media_resources
          }

          return dir_resource
        end
    end
  end

  module ReadMethods
    extend ActiveSupport::Concern

    module ClassMethods
      # 根据传入的资源路径字符串，查找一个资源对象
      # 传入的路径类似 /foo/bar/hello/test.txt
      # 或者 /foo/bar/hello/world
      # 找到的资源对象，可能是一个文件资源，也可能是一个文件夹资源
      def get(creator, resource_path)
        collect = creator.media_resources.root_res
        resource = nil
        split_path(resource_path).each { |name|
          resource = collect.find_by_name(name)
          return nil if resource.blank?
          collect = resource.media_resources
        }

        return resource
      rescue MediaResource::InvalidPathError
        return nil
      end
    end
  end

  module UpdateMethods
    extend ActiveSupport::Concern

  end

  module DeleteMethods
    extend ActiveSupport::Concern

  end

  module CommonMethods
    extend ActiveSupport::Concern

    module ClassMethods
      private
      # 根据传入的 resource_path 划分出涉及到的资源名称数组
        def split_path(resource_path)
          raise MediaResource::InvalidPathError if resource_path.blank?
          raise MediaResource::InvalidPathError if resource_path[0...1] != '/'
          raise MediaResource::InvalidPathError if resource_path == '/'
          raise MediaResource::InvalidPathError if resource_path.match /\/{2,}/
          raise MediaResource::InvalidPathError if resource_path.include?('\\')

          resource_path.sub('/', '').split('/')
        end
    end
  end

  include CreateMethods
  include ReadMethods
  include UpdateMethods
  include DeleteMethods
  # include ShareMethods
  # include TagsMethods
  include CommonMethods
end