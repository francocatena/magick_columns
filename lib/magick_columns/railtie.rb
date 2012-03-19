module MagickColumns
  class Railtie < Rails::Railtie
    initializer 'magick_columns.active_record' do
      ActiveSupport.on_load :active_record do
        require 'magick_columns/active_record'
      end
    end
  end
end