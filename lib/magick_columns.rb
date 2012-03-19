module MagickColumns
  autoload :DEFAULTS, 'magick_columns/defaults'
  autoload :I18N_DEFAULTS, 'magick_columns/defaults'
  autoload :TOKENIZE_RULES, 'magick_columns/rules'
  autoload :REPLACEMENT_RULES, 'magick_columns/rules'
  autoload :Tokenizer, 'magick_columns/tokenizer'
  
  class << self
    private

    def _default_setup_for(config)
      translation = I18n.t("magick_columns.#{config}", raise: true) rescue MagickColumns::I18N_DEFAULTS[config]

      if translation.respond_to?(:map)
        translation.map { |c| Regexp.quote(c) }.join('|')
      else
        translation
      end
    end
  end
  
  # Strings considered "and" spliters
  mattr_accessor :and_operators
  @@and_operators = _default_setup_for :and
  
  # Strings considered "or" spliters
  mattr_accessor :or_operators
  @@or_operators = _default_setup_for :or
  
  # Strings considered "from" terms (like "from 01/01/2012")
  mattr_accessor :from_operators
  @@from_operators = _default_setup_for :from
  
  # Strings considered "until" terms (like "until 01/01/2012")
  mattr_accessor :until_operators
  @@until_operators = _default_setup_for :until
  
  # Strings considered "today" strings (like "from today")
  mattr_accessor :today_operators
  @@today_operators = _default_setup_for :today
  
  # Rules to replace text in the natural string
  mattr_accessor :replacement_rules
  @@replacement_rules = REPLACEMENT_RULES.dup
  
  # Rules for tokenize the natural string
  mattr_accessor :tokenize_rules
  @@tokenize_rules = TOKENIZE_RULES.dup
  
  # Setup method for plugin configuration
  def self.setup
    yield self
  end
end

autoload :Timeliness, 'timeliness'

require 'magick_columns/railtie' if defined?(Rails)