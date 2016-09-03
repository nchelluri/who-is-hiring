#!/usr/bin/env ruby

require 'json'
require 'erb'

id = 12405698

story = JSON.parse(File.read("story-and-comments-for-#{id}.json"))

erb = ERB.new(File.read('whoshiring.html.erb'))

def comments_output(item, level = 1)
  output = ''

  return output if item['dead'] || item['deleted']
  classes = ''
  classes += 'remote ' if item['text'] =~ /remote/i
  classes += 'interns ' if item['text'] =~ /interns/i
  classes += 'visa ' if item['text'] =~ /visa/i

  output += '<div class="content ' + classes + '"' + (level > 1 ? ' style="margin-left:' + (level * 20).to_s + 'px"' : '') + '>' +
      '<strong>by <a href="https://news.ycombinator.com/user?id=' + item['by'] + '">' + item['by'] +
      '</a></strong> <small><a href="https://news.ycombinator.com/item?id=' + item['id'].to_s + '">Original Post</a>' +
      '</small><br><br>' + item['text'] + '</div>' + "\n\n"

  item['comments'].each do |comment|
    output += comments_output(comment, level + 1)
  end if item['comments']

  output
end

comments_output = ''
story['comments'].each do |comment|
  comments_output += comments_output(comment)
end

puts erb.result(binding)
