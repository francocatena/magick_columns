module MagickColumns
  class Railtie < Rails::Railtie
    initializer 'magick_columns' do
      ActiveSupport.on_load :active_record do
        require 'magick_columns/active_record'
      end

      self.class.add_locale_path config
    end

    def self.add_locale_path config
      config.i18n.railties_load_path.unshift *MagickColumns::I18n.load_path
    end
  end
end
