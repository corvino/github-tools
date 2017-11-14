#!/usr/bin/env ruby

## This seems like it should work but doesn't. The graphql client seems
## to blow up pretty much as soon as it taled to api.github.com. Sigh.
##
## https://github.com/github/graphql-client
## https://github.com/github/github-graphql-rails-example

Dir.chdir(File.dirname(__FILE__)) do
  require "bundler/setup"
end

require "graphql/client"
require "graphql/client/http"

schema = File.join(File.dirname(__FILE__), "github.graphql.schema")
puts schema

module GitHub
  HTTP = GraphQL::Client::HTTP.new("https://api.github.com/graphql") do
    def headers(_context)
      { "Authorization" => "Bearer `security find-generic-password -a github-graphql-spelunking -w`" }
    end
  end
  Client = GraphQL::Client.new(schema: "./github.graphql.schema", execute: HTTP)
  #Schema = GraphQL::Client.load_schema(HTTP)
  #Client = GraphQL::Client.new(schema: Schema, execute: HTTP)
end

query = File.read("graphql/example.graphql")
query = GitHub.Client.parse query
puts query
# query = GitHub.Client.parse <<-'GRAPHQL'
# query {
#   viewer {
#     login
#   }
# }
# GRAPHQL

puts document

response = GitHub::Client.query(query)

puts response
