module MagickColumns
  autoload :DEFAULTS, 'magick_columns/defaults'
  autoload :TOKENIZE_RULES, 'magick_columns/rules'
  autoload :REPLACEMENT_RULES, 'magick_columns/rules'
  autoload :Tokenizer, 'magick_columns/tokenizer'
  autoload :I18n, 'magick_columns/i18n'
  
  class << self
    private

    def _default_setup_for(config)
      -> {
        translation = I18n.magick_translate(config)

        if translation.respond_to?(:map)
          translation.map { |c| Regexp.quote(c) }.join('|')
        else
          translation
        end
      }
    end
  end
  
  DYNAMIC_READERS = [
    :and_operators, :or_operators, :from_operators, :until_operators,
    :today_operators
  ]
  
  # Strings considered "and" spliters
  mattr_writer :and_operators
  @@and_operators = _default_setup_for :and
  
  # Strings considered "or" spliters
  mattr_writer :or_operators
  @@or_operators = _default_setup_for :or
  
  # Strings considered "from" terms (like "from 01/01/2012")
  mattr_writer :from_operators
  @@from_operators = _default_setup_for :from
  
  # Strings considered "until" terms (like "until 01/01/2012")
  mattr_writer :until_operators
  @@until_operators = _default_setup_for :until
  
  # Strings considered "today" strings (like "from today")
  mattr_writer :today_operators
  @@today_operators = _default_setup_for :today
  
  # Rules to replace text in the natural string
  mattr_accessor :replacement_rules
  @@replacement_rules = REPLACEMENT_RULES.dup
  
  # Rules for tokenize the natural string
  mattr_accessor :tokenize_rules
  @@tokenize_rules = TOKENIZE_RULES.dup
  
  DYNAMIC_READERS.each do |m|
    instance_eval <<-RUBY
      def #{m}
        @@#{m}.respond_to?(:call) ? @@#{m}.call : @@#{m}
      end
    RUBY
  end
  
  # Setup method for plugin configuration
  def self.setup
    yield self
  end
end

autoload :Timeliness, 'timeliness'

require 'magick_columns/railtie' if defined?(Rails)