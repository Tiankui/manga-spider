#!/usr/bin/env ruby
# encoding: utf-8

require "./data/manga-items-1349258275-size-48385"
require "./manga-items"

def title_strip manga_list
  data = {}

  #trip 3th of tree
  manga_list.each_key do |key|
    data[key.to_s.strip]=Marshal.load(Marshal.dump(manga_list[key]))
  end

  manga_list.each_key do |key|
    manga_list[key][:child].each_key do |k|
      data[key.to_s.strip][:child].delete k
      data[key.to_s.strip][:child][k.to_s.strip]=manga_list[key][:child][k]
    end
  end
  data
end

data = title_strip Manga_items

data.each_key do |key|
  data[key][:child].each_key{|a| p a}
end

make_file(data,get_count_3(data))
