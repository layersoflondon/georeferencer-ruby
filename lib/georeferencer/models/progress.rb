module Georeferencer
  class Progress
    include Georeferencer::Base

    collection_path "progress"
    resource_path "progress?collection=:id"


    def self.all
      raise NoMethodError, "Use #find(project_name)"
    end
  end
end
