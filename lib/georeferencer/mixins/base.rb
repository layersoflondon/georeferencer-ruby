module Georeferencer
  module Base
    def self.included(base)
      base.include Her::Model
      base.include Georeferencer::ObjectCache
      base.send(:use_api, ->{Georeferencer.configuration.connection})

      base.extend ClassMethods
      base.preload_resources = false
    end

    module ClassMethods
      attr_accessor :preload_resources

    end

  end
end