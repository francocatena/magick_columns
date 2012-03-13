require 'magick_columns/magick_columns'
require 'magick_columns/defaults'

autoload 'Timeliness', 'timeliness'

ActiveRecord::Base.send :include, MagickColumns::Base