# TODO: These rules should be added to a live array, not a constant one
module MagickColumns
  TOKENIZE_RULES = {
    from: {
      pattern: -> { /(\A\s*|\s+)(#{MagickColumns.from_operators})\s+(\S+)/ },
      tokenizer: ->(match) { { operator: '>=', term: match[3] } }
    },
    until:{
      pattern: -> { /(\A\s*|\s+)(#{MagickColumns.until_operators})\s+(\S+)/ },
      tokenizer: ->(match) { { operator: '<=', term: match[3] } }
    }
  }
  
  REPLACEMENT_RULES = {
    today: {
      pattern: -> { /#{MagickColumns.today_operators}/ },
      replacement: ->(match) { Date.today.to_s(:db) }
    }
  }
end