module AppWorker
  def self.include(base)
    base.send :include, Sidekiq::Worker
    base.send :extend,  ClassMethodes
  end

  module ClassMethodes
    def sidekiq_running?
      `ps aux | grep sidekiq`.split("\n").select { |process| process.include? 'busy'}.present?
    end
  end
  extend ClassMethodes
end