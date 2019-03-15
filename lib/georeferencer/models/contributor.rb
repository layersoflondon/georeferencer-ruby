module Georeferencer
  class Contributor
    include Georeferencer::Base

    collection_path "contributors"

    default_scope -> {
      where(format: 'json')
    }
  end
end