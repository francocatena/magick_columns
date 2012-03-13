require 'test_helper'

class MagickColumnsTest < ActiveSupport::TestCase
  test 'correct definition' do
    assert_kind_of Module, MagickColumns
  end
  
  test 'map magick column operator' do
    operator = Person.send(:_map_magick_column_operator, '=', 'PostgreSQL')
    assert_equal '=', operator
    
    operator = Person.send(:_map_magick_column_operator, :like)
    assert_equal 'ILIKE', operator
    
    operator = Person.send(:_map_magick_column_operator, :like, 'MySQL')
    assert_equal 'LIKE', operator
  end
  
  test 'string magick search' do
    people = Person.magick_search('obi')
    
    assert_equal 1, people.count
    assert people.first.name =~ /obi/i
    
    people = Person.magick_search('skywalker')
    
    assert_equal 2, people.count
    assert people.all? { |p| p.name =~ /skywalker/i }
    
    people = Person.magick_search('anakin skywalker')
    
    assert_equal 1, people.count
    assert people.first.name =~ /anakin skywalker/i
    
    people = Person.magick_search('anakin or skywalker')
    
    assert_equal 2, people.count
    assert people.all? { |p| p.name =~ /anakin|skywalker/i }
    
    people = Person.magick_search('nobody')
    
    assert people.empty?
  end
  
  test 'email magick search' do
    people = Person.magick_search('obi@')
    
    assert_equal 1, people.count
    assert people.first.email =~ /obi@/i
    
    people = Person.magick_search('@sw.com')
    
    assert_equal 3, people.count
    assert people.all? { |p| p.email =~ /@sw.com/i }
    
    people = Person.magick_search('nobody@sw.com')
    
    assert people.empty?
  end
  
  test 'integer magick search' do
    articles = Article.magick_search('1')
    
    assert_equal 1, articles.count
    assert articles.first.code == 1
    
    articles = Article.magick_search('100')
    
    assert articles.empty?
  end
  
  test 'date magick search' do
    people = Person.magick_search("#{1000.years.from_now.to_date}")
    
    assert_equal 1, people.count
    assert people.first.birth == 1000.years.from_now.to_date
    
    people = Person.magick_search("#{1020.years.from_now.to_date}")
    
    assert_equal 1, people.count
    assert people.first.birth == 1020.years.from_now.to_date
    
    people = Person.magick_search("#{Date.today}")
    
    assert people.empty?
  end
  
  test 'combine date and string in magick search' do
    birth = 1000.years.from_now.to_date
    people = Person.magick_search("#{birth} or luke")
    
    assert_equal 2, people.count
    assert people.all? { |p| p.birth == birth || p.name =~ /luke/i }
  end
end
