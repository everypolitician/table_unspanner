# TableUnspanner

Takes a string containing an HTML `<table>` which has `rowspan` and/or `colspan`
attributes on `<th>` and `<td>` elements and returns a processed version of the
table with those attributes replaced by duplicate rows to make scraping them easier.

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

To use the library create a new instance of `TableUnspanner::UnspannedTable`, passing it a `table` keyword argument that contains an HTML string representing your table. Then call the `#html_string` method which will return a string containing the processed HTML table.

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

puts TableUnspanner::UnspannedTable.new(table: table).html_string
```

When the above code is run it will output the following:

    <table>
      <tr>
        <th>Name</th>
        <th>Role</th>
      </tr>
      <tr>
        <td>Alice</td>
        <td>Test subject</td>
      </tr>
      <tr>
        <td>Bob</td>
        <td>Test subject</td>
      </tr>
    </table>

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/everypolitician/table_unspanner.
