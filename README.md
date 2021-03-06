# TableUnspanner

Takes a string containing an HTML `<table>` which has `rowspan` and/or `colspan`
attributes on `<th>` and `<td>` elements and returns a processed version of the
table with those attributes replaced by duplicate rows to make scraping them easier.

## Example

If you're scraping a webpage that has the table below on it you want the row containing Bob to also contains the `<td>` element which is implied by the `rowspan` attribute on the previous row.

```html
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
```

After running the table above though `table_unspanner` it would then look like this, making it much easier to scrape.

```html
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
```

It also does what you'd expect for any `colspan` attributes that it encounters.

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

To use the library create a new instance of `TableUnspanner::UnspannedTable`, passing a string containing an HTML `<table>` to the constructor. You can then call the `#nokogiri_node` method to retrieve the processed version of the table as a `Nokogiri::Node` instance. Alternatively you can call `#html_string` if you just want to get back a string containing the HTML for the table.

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

unspanned_table = TableUnspanner::UnspannedTable.new(table)

# Access the `Nokogiri::Node` instance for the table
unspanned_table.nokogiri_node

# Or just get the raw HTML as a string
unspanned_table.html_string
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/everypolitician/table_unspanner.
