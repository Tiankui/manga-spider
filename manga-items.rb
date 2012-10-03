#!/usr/bin/env ruby
# encoding: utf-8

require "nokogiri"
require "open-uri"
require "./data/manga-titles-1349253256-size-3549"
require "./data/manga-items-1349106078-size-50591"
require "./settings"

#Manga_titles标题列表
#Manga_items卷集列表
#比较标题列表和现有item列表
#更新现有item列表
#
#
def compare_item(new_titles,old_items,has_count)
  data_end=Hash.new
  count = 0

  if old_items==nil&&has_count==nil
    add_items new_titles
  else
    new_titles.each_key do |key|
      if old_items[key] == nil
        count += 1
        data = add_items(new_titles,key,old_items,has_count)
        data_end = data[:data]
        count = data[:count]
      end
    end
  end
  make_file(data_end,count)
  p "新增#{count}部漫画"
end

#获取3级树子项数目,现有数据漫画卷树
def get_count_3 tree
  count = 0
  tree.each_key do |key|
    len = tree[key][:child].size
    if len==1
      count += 1
    else
      count += (len-1)
    end
  end

  p ""
  p "现共有#{count}卷漫画"
  p ""

  count
end

#生成新的卷数据
def add_items(new_titles,key,old_items,has_count)

  count = has_count||0

  if old_items !=nil
    data = old_items
    data[key] = new_titles[key].clone
    data[key][:child] = Hash.new
  else
    data[key][:child] = Hash.new
  end


  page = Nokogiri::HTML(open DOMAIN+data[key][:url])

  p "#{'-'*20}"
  p "漫画名称：#{key}"
  p "抓取地址：#{DOMAIN+data[key][:url]}"
  p "现计#{count}卷"
  p "#{'-'*20}"

  page.css(".subBookList a").each do |link|
    if link[:href] =~ /comic/
      p link[:title]
      count = count+1
      data[key][:child][link[:title]] = {url:link[:href]}
    end
  end

  p "完成！一共#{data.size}部#{count}卷"

  {data:data,count:count}
end

def make_file(data,count)
  open("data/manga-items-#{Time.now.to_i}-size-#{count}.rb","w") do |file|
    file << "#!/usr/bin/env ruby\n# encoding: utf-8\nManga_items=#{data}"
  end
end

compare_item(Manga_titles,Manga_items,get_count_3(Manga_items))
