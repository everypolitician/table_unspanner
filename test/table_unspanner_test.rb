require 'test_helper'

describe 'TableUnspanner' do
  it 'has a version number' do
    ::TableUnspanner::VERSION.wont_be_nil
  end

  let(:unspanned_table) do
    TableUnspanner::UnspannedTable.new(table_html)
  end

  describe 'UnspannedTable' do
    describe 'with rowspan attributes' do
      let(:table_html) do
        <<-TABLE
          <table>
            <tr>
              <th rowspan="3">Employees</th>
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
      end

      it 'duplicates the <th> over three rows' do
        unspanned_table.nokogiri_node.xpath('tr[1]/th[1]').text.must_equal 'Employees'
        unspanned_table.nokogiri_node.xpath('tr[2]/th[1]').text.must_equal 'Employees'
        unspanned_table.nokogiri_node.xpath('tr[3]/th[1]').text.must_equal 'Employees'
      end

      it 'duplicates the <td> over two rows' do
        unspanned_table.nokogiri_node.xpath('tr[2]/td[2]').text.must_equal 'Test subject'
        unspanned_table.nokogiri_node.xpath('tr[3]/td[2]').text.must_equal 'Test subject'
      end

      it 'can be returned as a string' do
        unspanned_table.html_string.must_equal <<-TABLE.strip
<table>
<tr>
<th>Employees</th>
<th>Name</th>
<th>Role</th>
</tr>
<tr>
<th>Employees</th>
<td>Alice</td>
<td>Test subject</td>
</tr>
<tr>
<th>Employees</th>
<td>Bob</td>
<td>Test subject</td>
</tr>
</table>
        TABLE
      end
    end

    describe 'with colspan attributes' do
      let(:table_html) do
        <<-TABLE
          <table>
            <tr>
              <th>Name</th>
              <th>Role</th>
              <th>Division</th>
            </tr>
            <tr>
              <td>Alice</td>
              <td colspan="2">Retired</td>
            </tr>
          </table>
        TABLE
      end

      let(:cells) { unspanned_table.nokogiri_node.xpath('tr[2]/td') }

      it 'replaces them with duplicate cells' do
        cells.size.must_equal 3
        cells[1].text.must_equal 'Retired'
        cells[2].text.must_equal 'Retired'
      end
    end
  end
end
