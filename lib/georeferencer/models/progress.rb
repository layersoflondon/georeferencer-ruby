module Georeferencer
  class Progress
    include Georeferencer::Base

    collection_path "progress"
    resource_path "progress?collection=:id"
    self.perform_object_caching = false


    def self.all
      raise NoMethodError, "Use #find(project_name)"
    end
  end
end
