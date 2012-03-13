require 'magick_columns/defaults'
require 'magick_columns/tokenizer'
require 'magick_columns/magick_columns'

autoload 'Timeliness', 'timeliness'

ActiveRecord::Base.send :include, MagickColumns::Base