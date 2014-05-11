require "best_gems_client/version"
require "open-uri"
require "nokogiri"

class BestGemsClient
  BASE_URL = "http://bestgems.org/"

  def initialize(user_agent: nil, request_per_minute: 10)
    @user_agent = user_agent
    @request_per_minute = request_per_minute
    @request_timestamps = []
  end

  def get(path)
    @request_timestamps.select!{|i| Time.now - i <= 60}
    sleep(@request_timestamps.min + 60 - Time.now) if @request_timestamps.size >= @request_per_minute
    @request_timestamps << Time.now

    open("#{BASE_URL}#{path}",
         "User-Agent" => @user_agent || "BestGemsClient #{VERSION}")
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
            gem = keys.zip(tr.search("td").map(&:text)).map{|key, value|
              if key =~ /Rank|Diff|Downloads/
                value = value.gsub(",", "").to_i
              end
              key = key.gsub(/\s/, "").split(/(?=[A-Z][^A-Z])/).join("_").downcase # to snake_case
              [key, value]
            }.to_h

            gem["link"] = URI.join(BASE_URL, tr.at('a[href*="/gems/"]')["href"])

            y << gem
          end

          break if html.at(".pagination .disabled:last-of-type") # Checks if there is a next page
          current_page += 1
        end
      }.lazy
    end
  end
end
