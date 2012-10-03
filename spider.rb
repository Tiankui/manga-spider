#!/usr/bin/env ruby
# encoding: utf-8
require "anemone"
require "./settings"


Anemone.crawl DOMAIN do |anemone|
  anemone.on_every_page do |page|
    #if /\/conmic\//=~page.url
      p page.url
    #end
  end
end
