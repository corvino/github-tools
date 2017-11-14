#!/usr/bin/env ruby

require 'json'
require 'net/http'
require 'uri'

Dir.chdir(File.dirname(__FILE__)) do
  require "bundler/setup"
end

def squash_graphql(query)
  query = query.gsub('"', '\\"')
  query = query.gsub("\r", " ")
  query = query.gsub("\n", " ")
  query = query.gsub("\t", " ")

  len = -1
  while query.length != len do
    len = query.length
    query = query.gsub("  ", " ")
  end

  return query.strip
end

uri = URI.parse("https://api.github.com/graphql")
token = `security find-generic-password -a github-graphql-spelunking -w`
headers = {"Authorization" => "bearer #{token}"}

query = File.read("graphql/pr.graphql")

document = "{ \"query\": \"#{squash_graphql(query)}\" }"

http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true
response = http.post(uri.path, document, headers)

puts JSON.pretty_generate(JSON.parse(response.body))
