class Article < ActiveRecord::Base
  has_magick_columns name: :string, code: :integer
end
