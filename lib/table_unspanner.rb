require 'table_unspanner/version'
require 'nokogiri'

module TableUnspanner
  class UnspannedTable
    def initialize(table)
      @table = Nokogiri::HTML.fragment(table.to_s).at_css('table')
    end

    def nokogiri_node
      table.children = reparsed.map { |c| '<tr>' + c.map { |n| n ? n.to_html : "<td>" }.join + '</tr>' }.join
      table
    end

    def html_string
      nokogiri_node.to_s
    end

    private

    attr_reader :table

    def reparsed
      grid = []

      table.css('tr').each_with_index do |row, curr_x|
        row.css('td, th').each_with_index do |cell, curr_y|
          rowspan = cell.remove_attribute('rowspan').value.to_i rescue 1
          colspan = cell.remove_attribute('colspan').value.to_i rescue 1

          0.upto(rowspan - 1).each do |x|
            0.upto(colspan - 1).each do |y|
              curr_y += 1 while (grid[curr_x + x] ||= [])[curr_y + y]
              grid[curr_x + x][curr_y + y] = cell
            end
          end
        end
      end

      grid
    end
  end
end
