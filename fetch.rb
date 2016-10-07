#!/usr/bin/env ruby

require 'net/http'
require 'uri'
require 'json'
require 'cgi'
require 'nokogiri'

def get_item(id)
  puts "Getting #{id}"
  obj = JSON.parse(Net::HTTP.get(URI("https://hacker-news.firebaseio.com/v0/item/#{id}.json?print=pretty")))
  obj['text'] = Nokogiri::HTML::fragment(obj['text'])
  obj['by'] = CGI::escape(obj['by']) if obj['by'] != nil
  obj
end

def get_comments(id)
  comments = []

  comment = get_item(id)
  return comments if comment['dead'] || comment['deleted']

  comments << comment
  if comment['kids']
    comment['comments'] = []
    comment['kids'].each do |kid|
      comment['comments'] += get_comments(kid)
    end
  end

  comments
end

def get_comments_for_story(id)
  cached_filename = "story-and-comments-for-#{id}.json"
  if File.exists?(cached_filename)
    return JSON.parse(File.read(cached_filename))
  end

  # TODO: Maybe fix me up. Shouldn't need to recurse twice? Or should I...
  story = get_item(id)
  comments = []
  story['kids'].each do |kid|
    comments += get_comments(kid)
  end

  story['comments'] = comments

  puts "Generated data file for #{id}."

  File.write(cached_filename, JSON.pretty_generate(story))
  story
end

if $0 == __FILE__
  unless ARGV.length == 1
    puts "usage: #{$0} story_id"
    puts '       where story_id is the ID of a "Who\'s Hiring?" post'
    exit 1
  end

  get_comments_for_story(ARGV[0])
end
