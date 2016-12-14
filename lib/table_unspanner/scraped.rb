require 'scraped'
require 'table_unspanner'

module TableUnspanner
  class Decorator < Scraped::Response::Decorator
    def body
      Nokogiri::HTML(super).tap do |doc|
        doc.css('table').each do |table|
          table.children = UnspannedTable.new(table).children
        end
      end.to_s
    end
  end
end
