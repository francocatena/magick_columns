# MagickColumns

This gem extends ActiveRecord to provide queries built from *simple* strings

## Instalation

Add to your Gemfile:

```ruby
gem 'magick_columns'
```

## Usage

You must declare `has_magick_columns` in your model:

```ruby
class Person < ActiveRecord::Base
  has_magick_columns name: :string, email: :email, birth: :date
end
```

And now you can do something like this:

```ruby
people = Person.magick_search('anakin or luke')
```

The method returns a Relation, so you can apply any aditional method you want:

```ruby
people.order('name').limit(5)
```

And of course you can "spy" the query with:

```ruby
people.to_sql
```

## Rules

There is also a set of rules, for tokenize and replace some types of "patterns".
For example, you can write:

```ruby
people = Person.magick_search('from 01/01/2000')
```

And you get the people born in the XXI century =)

## Custom configuration

If you want to define your own rules, or replace some existing configuration add
in `config/initializers` one ruby file, for example `magick_columns_config.rb`

```ruby
MagickColumns.setup do |config|
  config.and_operators = ['and']
  config.or_operators = ['or']
  config.from_operators = ['from', 'since']
  config.until_operators = ['to', 'until']
  config.today_operators = ['today', 'now']
  # Each replacement rule consists in a pattern and a replacement proc or lambda
  config.replacement_rules[:new_replacement_rule] =
    pattern: /today/,
    replacement: ->(match) { Date.today.to_s(:db) }
  }
  # Each tokenizer rule consists in a pattern and a tokenizer proc or lambda.
  # The proc must return a hash with a valid SQL operator and a term for the
  # condition.
  config.tokenize_rules[:new_tokenize_rule] = {
    pattern: /(\A\s*|\s+)(from|since)\s+(\S+)/,
    tokenizer: ->(match) { { operator: '>=', term: match[3] } }
  }
end
```

## I18n

If you want to translate the built in rules, you can =). Add a
`magick_columns.en.yml` in your `config/locales` and you are done...

```yml
'en':
  magick_columns:
    and:
      - and
    or:
      - or
    from:
      - from
      - since
    until:
      - to
      - until
    today:
      - today
      - now
```

You can see more examples in the `magick_columns/locales` folder.

## How to contribute

If you find what you might think is a bug:

1. Check the GitHub issue tracker to see if anyone else has had the same issue.
   https://github.com/francocatena/magick_columns/issues/
2. If you do not see anything, create an issue with information on how to reproduce it.

If you want to contribute an enhancement or a fix:

1. Fork the project on GitHub.
   https://github.com/francocatena/magick_columns/
2. Make your changes with tests.
3. Commit the changes without making changes to the Rakefile, VERSION, or any other files that are not related to your enhancement or fix
4. Send a pull request.