module Georeferencer
  class Engine < Rails::Engine
    isolate_namespace Georeferencer

    config.after_initialize do
      Georeferencer.configuration.logger ||= Rails.logger
      Georeferencer.configuration.cache ||= Rails.cache
      Georeferencer.configuration.perform_caching ||= Rails.configuration.action_controller.perform_caching
    end

  end

end
