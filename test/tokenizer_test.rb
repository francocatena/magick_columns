require 'test_helper'

class TokenizerTest < ActiveSupport::TestCase
  test 'extract terms' do
    terms = MagickColumns::Tokenizer.new('a b').extract_terms
    assert_equal [[{term: 'a'}, {term: 'b'}]], terms
    
    terms = MagickColumns::Tokenizer.new('a or b').extract_terms
    assert_equal [[{term: 'a'}], [{term: 'b'}]], terms
    
    terms = MagickColumns::Tokenizer.new('long_abc').extract_terms
    assert_equal [[{term: 'long_abc'}]], terms
    
    terms = MagickColumns::Tokenizer.new('  ').extract_terms
    assert_equal [], terms
  end
  
  test 'clean query' do
    query = MagickColumns::Tokenizer.new('a b').clean_query
    assert_equal 'a b', query
    
    query = MagickColumns::Tokenizer.new('and a b').clean_query
    assert_equal 'a b', query
    
    query = MagickColumns::Tokenizer.new('  and  and a b or or  ').clean_query
    assert_equal 'a b', query
  end
  
  test 'split in terms' do
    terms = MagickColumns::Tokenizer.new.split_term_in_terms('a')
    assert_equal [{term: 'a'}], terms
    
    terms = MagickColumns::Tokenizer.new.split_term_in_terms('from a')
    assert_equal [{term: 'a', operator: '>='}], terms
    
    terms = MagickColumns::Tokenizer.new.split_term_in_terms('until a')
    assert_equal [{term: 'a', operator: '<='}], terms
    
    terms = MagickColumns::Tokenizer.new.split_term_in_terms('until today')
    assert_equal [{term: Date.today.to_s(:db), operator: '<='}], terms
    
    terms = MagickColumns::Tokenizer.new.split_term_in_terms('from a to b')
    assert_equal(
      [{term: 'a', operator: '>='}, {term: 'b', operator: '<='}], terms
    )
  end
end