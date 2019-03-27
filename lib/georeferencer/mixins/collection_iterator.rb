module Georeferencer
  # This is mixed into Her::Model::Relation and redefines how `fetch()` works, iterating over pages from the GR endpoint
  module CollectionIterator

    def fetch
      # only invoke this is the parent is a Georeferencer class
      if @parent.ancestors.include?(Georeferencer::Base)
        # get the collection
        @_collection = super
        metadata = @_collection.metadata.except(:start)

        # check the params don't specifically include a :start argument (in which case we don't need to loop),
        # and that the response metadata includes a :start key
        if !start_included? && @_collection.metadata[:start].present? && (!limited_included? || (limited_included? && @_collection.count < params[:limit]))
          @params.merge!(start: @_collection.metadata[:start])
          loop do
            clear_fetch_cache!
            new_collection = super
            @_collection += new_collection
            break if limited_included? && @_collection.count >= @params[:limit]
            if new_collection.metadata[:start].present? && new_collection.metadata[:start] != @params[:start]
              @params.merge!(start: new_collection.metadata[:start])
            else
              break
            end
          end
        end

        if @parent.preload_resources == true
          Her::Collection.new(@_collection.collect(&:reload), metadata)
        else
          Her::Collection.new(@_collection, metadata)
        end


      else
        super
      end
    end

    def limited_included?
      (@params.keys.include?(:limit) || @params.keys.include?("limit"))
    end

    def start_included?
      (@params.keys.include?(:start) || @params.keys.include?("start"))
    end


  end

end
