require "best_gems_client/version"
require "open-uri"
require "nokogiri"

class BestGemsClient
  VERSION = "0.0.1"

  def get(path)
    open("http://bestgems.org/#{path}", "User-Agent" => "BestGemsClient #{VERSION}")
  end

  %w(total daily featured).each do |name|
    define_method(name) do |page = 1|
      Enumerator.new{|y|
        current_page = page
        loop do
          html = Nokogiri::HTML.parse(get("#{name}?page=#{current_page}"))

          table = html.at("table")
          keys = table.at("tr").search("th").map(&:text)

          gems = table.search("tr").drop(1)
          break if gems.empty? # If `current_page` is too large, an empty table will be returned.

          gems.each do |tr|
            y << keys.zip(tr.search("td").map(&:text)).map{|key, value|
              if key =~ /Rank|Diff|Downloads/
                value = value.gsub(",", "").to_i
              end
              [key, value]
            }.to_h
          end

          current_page += 1
        end
      }.lazy
    end
  end
end
