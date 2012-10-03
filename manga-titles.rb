#!/usr/bin/env ruby
# encoding: utf-8
require "nokogiri"
require "open-uri"
require "./settings"


def make_title_list
  manga_list=Hash.new#构造树
  page = Nokogiri::HTML.parse(open(ALL_PAGES), nil, "gb2312")#抓取目录页面
  #page = Nokogiri::HTML.parse(open('./index.html'),nil,"gb2312")

  page.css("h3+ul a").each do |link|
    if link[:href]=~/comic/ && link[:href].size<14
      #link['href']URI  link['title']漫画名称  link['rel']封面
      manga_list[link[:title]] = {url:link[:href],rel:link['rel']}
    end
  end
  #add 死神
  manga_list[:死神] = {url:'/comic/120/',rel:'http://i1.imanhua.com/Cover/2011-10/sishen.jpg'}

  manga_list
end

data = make_title_list
open("data/manga-titles-#{Time.now.to_i}-size-#{data.size}.rb","w") do |file|
  file << "#!/usr/bin/env ruby\n# encoding: utf-8\nManga_titles=#{data}"
end

puts "漫画目录抓取完毕,共计#{data.size}部"
puts "文件名:manga-titles-#{Time.now.to_i}-size-#{data.size}"
