A starting point for tools to do stuff with Github.

At this point, it's really just a ruby script that clones or updates a Github orginazations repositories and some notes on GraphQL.

You gotta start somewhere.

### Setup

This is setup to work with bundler:

    gem install bundler
    bundle install --path vendor/bundle

This will install dependencies into `vendor/bundle`.

### Usage

Clones and updates in the current working directory.

    ../github-org/fetch.rb <organization> <github-access-token>

### GraphQL

This is the new hoteness, apparently. And it's fun. I added some notes
on building my first query; need to figure out a few more pieces.

### Ruby Client

While the [Github Ruby client](https://github.com/github/graphql-client)
seems interesting, it has resisted efforts to talk to GitHub's API. No
idea what is going on, but a work-in-progress has been left in
`graphql-client-test.rb` until this can be figured out.
