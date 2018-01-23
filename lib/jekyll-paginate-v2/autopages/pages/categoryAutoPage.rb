module Jekyll
  module PaginateV2::AutoPages

    class CategoryAutoPage < BaseAutoPage
      def initialize(site, base, autopage_config, pagination_config, layout_name, category, category_name)

        # Construc the lambda function to set the config values
        # this function received the pagination config hash and manipulates it
        set_autopage_data_lambda = lambda do | in_config |
          in_config['category'] = category
        end

        get_autopage_permalink_lambda = lambda do |permalink_pattern|
          return Utils.format_cat_macro(permalink_pattern, category, autopage_config['special_characters'])
        end

        get_autopage_title_lambda = lambda do |title_pattern|
          return Utils.format_cat_macro(title_pattern, category, autopage_config['special_characters'])
        end
                
        # Call the super constuctor with our custom lambda
        super(site, base, autopage_config, pagination_config, layout_name, set_autopage_data_lambda, get_autopage_permalink_lambda, get_autopage_title_lambda, category_name)
        
      end #function initialize

    end #class CategoryAutoPage
  end # module PaginateV2
end # module Jekyll
