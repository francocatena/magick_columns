module MagickColumns
  class Tokenizer
    def initialize(query)
      @query = query
    end
    
    def extract_terms
      ands = Regexp.quote("#{I18n.t('magick_columns.and', default: 'and')}")
      ors = Regexp.quote("#{I18n.t('magick_columns.or', default: 'or')}")
      clean_query = @query.strip
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
  end
end