# BestGemsClient

A scraper for http://bestgems.org/ (rubygem download rankings).

## Installation

BestGemsClient is yet to be released on rubygems.org.

`git clone https://github.com/vzvu3k6k/best_gems_client/ && cd best_gems_client && bundle && bundle exec rake install`

## Usage

This gem is beta and subject to imcompatible changes without notice.

```rb
require "best_gems_client"

client = BestGemsClient.new
client.featured #=> Featured gem ranking (http://bestgems.org/featured)
client.daily    #=> Daily gem ranking    (http://bestgems.org/daily)
client.total    #=> Total gem ranking    (http://bestgems.org/total)
```

All rankings are given as `Enumerator::Lazy` so that you don't need to worry about pagination.

```rb
# Gets top 10 gems whose name is shorter than 5 characters
# from top 100 gems in total download ranking
client.total.take(100).select{|gem| gem["name"].size < 5}.first(10)
```

## Contributing

1. Fork it ( https://github.com/vzvu3k6k/best_gems_client/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

Tips: `$ bundle exec rake test` to run tests.
