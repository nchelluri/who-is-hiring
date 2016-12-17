#!/usr/bin/env ruby

# try to find the latest one

require 'cgi'
require 'net/http'
require 'json'
require './fetch'
require './parse'

when_str = Time.now.strftime('%B %Y')

def find_story_id(when_str)
  url = "https://hn.algolia.com/api/v1/search?query=%22ask%20hn:%20who%20is%20hiring%3F%20(#{CGI::escape(when_str)})%22"
  uri = URI(url)

  json = Net::HTTP.get(uri)
  result = JSON.parse(json)
  if result['nbHits'] > 0
    result['hits'][0]['objectID']
  else
    nil
  end
end

unless (id = find_story_id(when_str))
  id = find_story_id((Time.now - 86400 * 30).strftime('%B %Y'))
end

unless id
  puts "Unable to retrieve story ID."
  exit 1
end

refresh = ARGV[0] == '--refresh'

story = get_comments_for_story(id, refresh)
File.open('who-is-hiring.html', 'w') do |f|
  f.puts get_output(story)
end
puts "Generated who-is-hiring.html for #{when_str}."
