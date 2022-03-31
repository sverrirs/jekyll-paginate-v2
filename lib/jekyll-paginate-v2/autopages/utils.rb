module Jekyll
  module PaginateV2::AutoPages

    class Utils
      # Static: returns all documents from all collections defined in the hash of collections passed in
      # excludes all non-pagination pages though
      def self.collect_all_docs(site_collections)
        coll = {}
        site_collections.each do |coll_name, coll_data|
          unless coll_data.nil?
            coll[coll_name] = coll_data.docs.select { |doc| !doc.data.has_key?('pagination') } # Exclude all non-pagination pages
          end
        end
        return coll
      end

    end # class Utils

  end # module PaginateV2
end # module Jekyll
