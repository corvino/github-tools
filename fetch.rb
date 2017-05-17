#!/usr/bin/env ruby

Dir.chdir(File.dirname(__FILE__)) do
  puts Dir.getwd
  require "bundler/setup"
end

require 'json'
require 'net/http'
require 'uri'

require "link_header"


if (2 != ARGV.length)
  raise ArgumentError, "Expected 2 arguments"
end

org = ARGV[0]
token = ARGV[1]

repos = []
next_url = "https://api.github.com/orgs/#{org}/repos"

while next_url do
  uri = URI.parse(next_url)
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true

  request = Net::HTTP::Get.new("#{uri.path}?#{uri.query}")
  request.add_field("Authorization",  "token #{token}")

  response = http.request(request)
  repos += JSON.parse(response.body)

  next_url = nil
  links = LinkHeader.parse(response["link"])
  for link in links.links do
    for attr in link.attr_pairs do
      if "next" == attr[1]
        next_url = link.href
      end
    end
  end
end

puts "#{repos.length} Repositories"
for repo in repos do
  name = repo["full_name"].split("/").last

  #puts name
  if Dir.exist?(name)
    puts "Updating #{name}"
    Dir.chdir(name) do
      `git fetch -fp`
    end
  else
    puts "Cloning #{name}"
    `git clone #{repo["ssh_url"]}`
  end
end
