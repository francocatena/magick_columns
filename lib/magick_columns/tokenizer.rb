module MagickColumns
  class Tokenizer
    def initialize(query = '')
      @query = query
    end
    
    def extract_terms
      terms = []

      clean_query.split(%r{\s+(#{MagickColumns.or_operators})\s+}).each do |o_t|
        unless o_t =~ %r{\A(#{MagickColumns.or_operators})\z}
          and_terms = []
          
          o_t.split(%r{\s+(#{MagickColumns.and_operators})\s+}).each do |t|
            unless t =~ %r{\A(#{MagickColumns.and_operators})\z}
              and_terms.concat split_term_in_terms(t)
            end
          end
          
          terms << and_terms unless and_terms.empty?
        end
      end

      terms.reject(&:empty?)
    end
    
    def clean_query
      @query.strip
        .gsub(%r{\A(\s*(#{MagickColumns.and_operators})\s+)+}, '')
        .gsub(%r{(\s+(#{MagickColumns.and_operators})\s*)+\z}, '')
        .gsub(%r{\A(\s*(#{MagickColumns.or_operators})\s+)+}, '')
        .gsub(%r{(\s+(#{MagickColumns.or_operators})\s*)+\z}, '')
    end
    
    def split_term_in_terms(term)
      term_copy = term.dup
      terms = []
      
      MagickColumns.replacement_rules.each do |rule, options|
        pattern = options[:pattern].respond_to?(:call) ?
          options[:pattern].call : options[:pattern]
        
        while(match = term_copy.match(pattern))
          term_copy.sub!(pattern, options[:replacement].call(match))
        end
      end
      
      MagickColumns.tokenize_rules.each do |rule, options|
        pattern = options[:pattern].respond_to?(:call) ?
          options[:pattern].call : options[:pattern]
        
        while(match = term_copy.match(pattern))
          terms << options[:tokenizer].call(match)
          
          term_copy.sub!(pattern, '')
        end
      end
      
      terms + term_copy.strip.split(/\s+/).map { |t| { term: t } }
    end
  end
end