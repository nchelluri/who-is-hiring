#!/usr/bin/env ruby

require 'json'
require 'erb'

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

def get_output(story)
  comments_output = ''
  story['comments'].each do |comment|
    comments_output += comments_output(comment)
  end

  erb = ERB.new(File.read('who-is-hiring.html.erb'))
  erb.result(binding)
end

if $0 == __FILE__
  unless ARGV.length == 1
    puts "usage: #{$0} story_id"
    puts '       where story_id is the ID of a "Who Is Hiring?" post'
    exit 1
  end

  id = ARGV[0]

  story = JSON.parse(File.read("story-and-comments-for-#{id}.json"))

  puts generate_output(story)
end
