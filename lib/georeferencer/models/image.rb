module Georeferencer
  class Image
    include Georeferencer::Base
    self.preload_resources = true

    collection_path "display"
    resource_path "maps/:id"

    scope :unreferenced, -> {
      where(state: 'waiting')
    }
    
    def centroid
      # Data from the collection endpoint doesn't include the bounding box, so we need to check we have the full data,
      # or reload (which hits the resource endpoint) if not
      unless (respond_to?(:bbox) && !bbox.nil?)
        expire_cache!
        reload
      end
      (wlng, slat, elng, nlat) = bbox


      {lat: (slat+nlat)/2, lng: (wlng+elng)/2}
    end

    def url(width=200,height=nil)
      [thumbnail[:url],'full',"#{width},#{height}",0,'default.jpg'].join("/")
    end

  end
end