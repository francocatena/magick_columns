module MagickColumns
  DEFAULTS = {
    string: {
      operator: :like,
      mask: '%%%{t}%%',
      condition: ->(t) { t =~ /.+/ },
      convert: ->(t) { t.to_s }
    },

    email: {
      operator: :like,
      mask: '%%%{t}%%',
      condition: ->(t) { t =~ /(.+@.*)|(.*@.+)/ },
      convert: ->(t) { t.to_s }
    },

    integer: {
      operator: '=',
      mask: '%{t}',
      condition: ->(t) { t =~ /\A\d+\z/ },
      convert: ->(t) { t.to_i }
    },

    date: {
      operator: '=',
      mask: '%{t}',
      condition: ->(t) { ::Timeliness.parse(t.to_s) },
      convert: ->(t) { ::Timeliness.parse(t.to_s) }
    }
  }
end
