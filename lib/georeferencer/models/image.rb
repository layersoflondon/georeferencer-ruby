module Georeferencer
  class Image
    include Georeferencer::Base
    self.preload_resources = true

    collection_path "display"
    resource_path "maps/:id"

    default_scope -> {
      where(format: 'json')
    }

    scope :unreferenced, -> {
      where(state: 'waiting')
    }
    
    def centroid
      # Data from the collection endpoint doesn't include the bounding box, so we need to check we have the full data,
      # or reload (which hits the resource endpoint) if not
      if respond_to?(:bbox)
        (wlng, slat, elng, nlat) = bbox
      else
        (wlng, slat, elng, nlat) = reload.bbox
      end
      {lat: (slat+nlat)/2, lng: (wlng+elng)/2}
    end
  end
end