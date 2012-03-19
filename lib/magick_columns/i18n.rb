module MagickColumns
  module I18n
    def self.locale_dir
      File.expand_path('../locales', __FILE__)
    end

    def self.load_path
      Dir["#{locale_dir}/*.{rb,yml}"]
    end
    
    def self.magick_translate(keys, options = {})
      if defined? ::I18n
        defaults = Array(keys).dup
        defaults << Proc.new if block_given?
        ::I18n.translate(
          defaults.shift,
          options.merge(default: defaults, scope: :magick_columns, raise: true)
        )
      else
        key = Array === keys ? keys.first : keys
        yield key, options
      end
    end
  end
end