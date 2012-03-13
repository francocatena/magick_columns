class Person < ActiveRecord::Base
  has_magick_columns name: :string, email: :email, birth: :date
end
