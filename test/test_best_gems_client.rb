$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))
require "best_gems_client"
require "minitest/autorun"
require "pry-rescue/minitest"
require "minitest-vcr"
require "webmock"

MinitestVcr::Spec.configure!

VCR.configure do |c|
  c.cassette_library_dir = 'test/vcr'
  c.hook_into :webmock
end

describe "BestGemsClient", :vcr do
  before do
    @client = BestGemsClient.new
  end

  it "fetches featured gems ranking" do
    first = @client.featured.first
    assert_equal %w(rank diff daily_rank total_rank name summary link).sort,
      first.keys.sort
    assert first.values.all?{|i| !!i}
  end
end
