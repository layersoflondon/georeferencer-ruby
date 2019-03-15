module Georeferencer
  # This mixin adds object caching when you call find(). It overloads the find() method to cache the result, and read that instead if possible.
  module ObjectCache
    def self.included(base)
      base.extend(ClassMethods)
    end

    # Utility method to get the cache key for the instance.
    def cache_key
      "#{self.class.cache_key_base}/#{self.id}"
    end

    def expire_cache!
      self.class.send(:expire_cache_for, self.id)
    end

    alias_method :expire!, :expire_cache!

    def reload
      if Georeferencer.configuration.perform_caching
        expire_cache!
      end
      super
    end

    module ClassMethods

      # Base of the cache key for this class.
      def cache_key_base
        "georeferencer/#{Georeferencer::VERSION}/#{self.to_s.underscore}"
      end

      # Redeclare the find() method, with caching. Only pass uncached keys to the super method.
      def find(*ids)
        if Georeferencer.configuration.perform_caching
          ids.uniq!
          uncached_ids = ids.reject {|i| Georeferencer.configuration.cache.read("#{cache_key_base}/#{i}").present?}
          [super(*uncached_ids)].flatten.reject(&:blank?).collect do |object|
            Georeferencer.configuration.logger.debug("Caching #{cache_key_base}/#{object.id}")
            Georeferencer.configuration.cache.write(object.cache_key, object)
          end
          all_objects = ids.collect do |id|
            Georeferencer.configuration.cache.read("#{cache_key_base}/#{id}")
          end

          all_objects.each {|o| o.run_callbacks(:find)}
          all_objects.length == 1 ? all_objects.first : all_objects
        else
          super
        end
      end


      # A method to expire the relevant caches for a collection of objects or ids
      # @param args [Array] of either objects which respond to `.id`, or ids themselves
      def expire_cache_for(*args)
        args = args.collect {|a| a.respond_to?(:id) ? a.id : a}.flatten
        # the caches we need to clear are:
        # - the object cache
        # - any collection caches which included this object
        args.each do |id|
          object_cache_key = "#{cache_key_base}/#{id}"
          object_collections = Georeferencer.configuration.cache.read("#{object_cache_key}/collection_hashes")
          if object_collections.present?
            # this object has a list of collection hashes, each of which we need to remove
            object_collections.each do |hash|
              Georeferencer.configuration.cache.delete("#{cache_key_base}/collection_query/#{hash}")
            end
            # by implication, the cached object should also be present; clear that too, along with any of its child keys
            begin
              Georeferencer.configuration.cache.delete_matched("#{object_cache_key}*")
            rescue NotImplementedError
              # rescue to removing the whole cache if delete_matched isn't supported
              Georeferencer.configuration.cache.clear
            end

          else
            # the object isn't in any collections; unfortunately we can't be sure whether this is because the object is old
            # and uncached, or new and therefore needs to be in collections which currently exist for this class.
            # Because of that, we'll aggressively remove caches for collections
            begin
              Georeferencer.configuration.cache.delete_matched("#{cache_key_base}/collection_query*")
            rescue NotImplementedError
              Georeferencer.configuration.cache.clear # rescue to cache.clear for caching methods where delete_matched isn't supported
            end
          end
          # Always remove the object's cache. There's no risk of doing this for nonexistent things.
          Georeferencer.configuration.cache.delete(object_cache_key)


        end
      end
    end
  end
end
