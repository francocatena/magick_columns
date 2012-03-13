require 'test_helper'

class TokenizerTest < ActiveSupport::TestCase
  test 'extract terms' do
    terms = MagickColumns::Tokenizer.new('a b').extract_terms
    assert_equal [['a', 'b']], terms
    
    terms = MagickColumns::Tokenizer.new('a or b').extract_terms
    assert_equal [['a'], ['b']], terms
    
    terms = MagickColumns::Tokenizer.new('long_abc').extract_terms
    assert_equal [['long_abc']], terms
    
    terms = MagickColumns::Tokenizer.new('  ').extract_terms
    assert_equal [], terms
  end
end