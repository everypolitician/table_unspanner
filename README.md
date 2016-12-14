# TableUnspanner

Takes a table with `rowspan` and/or `colspan` attributes on `<th>` and `<td>`
elements and returns a version of the table with those replaced by duplicate
rows to make scraping easier.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'table_unspanner'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install table_unspanner

## Usage

### Standalone

```ruby
require 'table_unspanner'

table = <<-TABLE
<table>
  <tr>
    <th>Name</th>
    <th>Role</th>
  </tr>
  <tr>
    <td>Alice</td>
    <td rowspan="2">Test subject</td>
  </tr>
  <tr>
    <td>Bob</td>
  </tr>
</table>
TABLE

puts TableUnspanner::UnspannedTable.new(table: table).children
```

### With `scraped`

This library comes with support for
[`scraped`](https://github.com/everypolitician/scraped) out of the box. You can
use it as a decorator and it will unspan _all_ the tables on the current page.

```ruby
require 'table_unspanner/scraped'

class MemberPage < Scraped::HTML
  decorator TableUnspanner::Decorator

  # Other fields etc
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/everypolitician/table_unspanner.
