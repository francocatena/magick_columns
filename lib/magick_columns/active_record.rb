module MagickColumns
  module ActiveRecord
    def has_magick_columns(options = {})
      @@_magick_columns ||= {}
      @@_magick_columns[name] ||= []

      options.each do |field, type|
        column_options = magick_column_options(type)

        @@_magick_columns[name] << { field: field }.merge(column_options)
      end
    end

    def magick_search query
      or_queries = []
      terms = {}

      MagickColumns::Tokenizer.new(query).extract_terms.each_with_index do |or_term, i|
        and_queries = []

        or_term.each_with_index do |and_term, j|
          mini_query = []

          @@_magick_columns[name].each_with_index do |column, k|
            if column[:condition].call(and_term[:term])
              operator = and_term[:operator] || map_magick_column_operator(column[:operator])
              terms[:"t_#{i}_#{j}_#{k}"] = column[:mask] % {t: and_term[:term]}

              mini_query << "#{column[:field]} #{operator} :t_#{i}_#{j}_#{k}"
            end
          end

          and_queries << mini_query.join(' OR ')
        end

        or_queries << and_queries.map { |a_q| "(#{a_q})" }.join(' AND ')
      end

      where or_queries.map { |o_q| "(#{o_q})" }.join(' OR '), terms
    end

    private

    def magick_column_options(type)
      type.kind_of?(Hash) ? type : MagickColumns::DEFAULTS[type.to_sym]
    end

    def map_magick_column_operator(operator, db = nil)
      db ||= ::ActiveRecord::Base.connection.adapter_name

      operator == :like ? (db == 'PostgreSQL' ? 'ILIKE' : 'LIKE') : operator
    end
  end
end

ActiveRecord::Base.extend MagickColumns::ActiveRecord
