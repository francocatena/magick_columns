module MagickColumns
  module Base
    extend ActiveSupport::Concern
 
    included do
    end
 
    module ClassMethods
      def has_magick_columns(options = {})
        @@_magick_columns ||= {}
        @@_magick_columns[name] ||= []
      
        options.each do |field, type|
          column_options = _magick_column_options(type)
    
          @@_magick_columns[name] << { field: field }.merge(column_options)
        end
      end
      
      def magick_search(query)
        or_queries = []
        terms = {}

        _extract_magick_query_terms(query).each_with_index do |or_term, i|
          and_queries = []
          
          or_term.each_with_index do |and_term, j|
            mini_query = []

            @@_magick_columns[name].each_with_index do |column, k|
              if column[:condition].call(and_term)
                operator = _map_magick_column_operator(column[:operator])
                terms[:"t_#{i}_#{j}_#{k}"] = column[:mask] % { t: and_term }

                mini_query << "#{column[:field]} #{operator} :t_#{i}_#{j}_#{k}"
              end
            end

            and_queries << mini_query.join(' OR ')
          end

          or_queries << and_queries.map { |a_q| "(#{a_q})" }.join(' AND ')
        end

        where(or_queries.map { |o_q| "(#{o_q})" }.join(' OR '), terms)
      end

      private
      
      def _magick_column_options(type)
        type.kind_of?(Hash) ? type : MagicColumns::DEFAULTS[type.to_sym]
      end

      def _extract_magick_query_terms(query)
        ands = Regexp.quote("#{I18n.t('magick_columns.and', default: 'and')}")
        ors = Regexp.quote("#{I18n.t('magick_columns.or', default: 'or')}")
        clean_query = query.strip
          .gsub(%r{\A\s*(#{ands})\s+}, '')
          .gsub(%r{\s+(#{ands})\s*\z}, '')
          .gsub(%r{\A\s*(#{ors})\s+}, '')
          .gsub(%r{\s+(#{ors})\s*\z}, '')
        or_terms = []

        clean_query.split(%r{\s+(#{ors})\s+}).each do |or_term|
          or_terms << or_term.split(%r{\s+(#{ands})\s+|\s+}).reject do |t|
            t =~ %r{\A(#{ands})\z} || t =~ %r{\A(#{ors})\z}
          end
        end

        or_terms.reject(&:empty?)
      end

      def _map_magick_column_operator(operator, db = nil)
        db ||= ActiveRecord::Base.connection.adapter_name
        
        operator == :like ? (db == 'PostgreSQL' ? 'ILIKE' : 'LIKE') : operator
      end
    end
  end
end