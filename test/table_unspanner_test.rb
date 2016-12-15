require 'test_helper'

describe 'TableUnspanner' do
  it 'has a version number' do
    ::TableUnspanner::VERSION.wont_be_nil
  end

  describe 'UnspannedTable' do
    it 'replaces span elements with multiple cells' do
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

      expected = "<tr><th>Name</th><th>Role</th></tr><tr><td>Alice</td>" \
        "<td>Test subject</td></tr><tr><td>Bob</td><td>Test subject</td></tr>"

      TableUnspanner::UnspannedTable.new(table: table).children.must_equal expected
    end
  end
end
