class ServiceStatus
  ROOT_PATH = File.expand_path('../../',__FILE__)

  class << self
    def check_for_project_start
      case Rails.env
      when 'test'
      when 'development'
      when 'production'
        check_faye
      end
    end

    def check_faye
      if !faye_is_run?
        raise 'faye 没有启动，可以使用 ./deploy/sh/faye.sh start 命令启动 faye'
      end
    end

    ###############
    def faye_is_run?
      sh_path = File.join(ROOT_PATH, 'deploy/sh/faye.sh')
      _service_is_run?(sh_path)
    end

    private
    def _service_is_run?(sh_path)
      content = `#{sh_path} status`
      content.match("not").nil? && content.match("running").present?
    end
  end
end