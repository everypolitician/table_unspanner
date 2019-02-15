# frozen_string_literal: true

require 'test_helper'

describe 'TableUnspanner' do
  it 'has a version number' do
    ::TableUnspanner::VERSION.wont_be_nil
  end

  let(:unspanned_table) do
    TableUnspanner::UnspannedTable.new(given_table)
  end

  let(:noko) do
    unspanned_table.nokogiri_node
  end

  describe 'UnspannedTable' do
    describe 'with rowspan attributes' do
      let(:given_table) do
        <<-TABLE.gsub(/^ +/, '')
          <table>
            <tr>
              <th rowspan="3">Employees</th>
              <th>Name</th>
              <th>Role</th>
              <th colspan="2">Start/End</th>
            </tr>
            <tr>
              <td>Alice</td>
              <td>Adviser</td>
              <td>2016-01-01</td>
              <td rowspan="2">2016-10-31</td>
            </tr>
            <tr>
              <td>Bob</td>
              <td>Builder</td>
            </tr>
          </table>
        TABLE
      end

      let(:expected_table) do
        <<-TABLE.gsub(/^ +/, '')
          <table>
            <tr>
              <th>Employees</th>
              <th>Name</th>
              <th>Role</th>
              <th>Start/End</th>
              <th>Start/End</th>
            </tr>
            <tr>
              <th>Employees</th>
              <td>Alice</td>
              <td>Adviser</td>
              <td>2016-01-01</td>
              <td>2016-10-31</td>
            </tr>
            <tr>
              <th>Employees</th>
              <td>Bob</td>
              <td>Builder</td>
              <td></td>
              <td>2016-10-31</td>
            </tr>
          </table>
        TABLE
      end

      it 'gets the header row correct' do
        row = noko.xpath('tr[1]/th').map(&:text)
        row[0].must_equal 'Employees'
        row[1].must_equal 'Name'
        row[2].must_equal 'Role'
        row[3].must_equal 'Start/End'
        row[4].must_equal 'Start/End'
      end

      it 'gets Alice correct' do
        noko.xpath('.//tr[2]/th').text.must_equal 'Employees'
        row = noko.xpath('.//tr[2]/td').map(&:text)
        row[0].must_equal 'Alice'
        row[1].must_equal 'Adviser'
        row[2].must_equal '2016-01-01'
        row[3].must_equal '2016-10-31'
      end

      it 'gets Bob correct' do
        noko.xpath('.//tr[3]/th').text.must_equal 'Employees'
        row = noko.xpath('.//tr[3]/td').map(&:text)
        row[0].must_equal 'Bob'
        row[1].must_equal 'Builder'
        row[2].must_equal ''
        row[3].must_equal '2016-10-31'
      end

      it 'can be returned as a string' do
        unspanned_table.html_string.strip.must_equal expected_table.strip
      end
    end
  end
end
