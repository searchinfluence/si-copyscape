# SI::CopyScape Gem
A gem to provide the communication layer with the Copyscape.com Premium API and your application.

Wiki: (requires login) http://wiki.searchinfluence.com/index.php?title=CopyScape

API Documentation: (requires login) http://copyscape.com/apiconfigure.php

## Usage:
Set the following environment variables (or pass the values in during initialization):
- ENV['COPYSCAPE_USERNAME']
- ENV['COPYSCAPE_API_KEY']

Find the most recent version of this gem at http://gems.searchinfluence.com/gems/si-copyscape and then specify the version number when adding this gem to your application's Gemfile.

```ruby
# Add the following to your Gemfile
source 'http://user:pass@gems.searchinfluence.com' do
  gem 'si-copyscape', '0.0.0'
end
```

Instantiate the copyscape object with the following optional paramaters
```ruby
copyscape = SI::CopyScape.new(
  username: "foo", # not required if ENV['COPYSCAPE_USERNAME'] is set
  api_key: "bar", # not required if ENV['COPYSCAPE_API_KEY'] is set
  uri: "http://foo", # defaults to http://www.copyscape.com/api/
  match_percent: 10 # defaults to 5
)
```

Get Remaining Credit Information
```ruby
copyscape.credit_balance
#=><struct SI::CopyScape::Balance value=112.62, total=2252, today=2252>
```

Perform text searches for copy matches
```ruby
text = "A national website promotion company, Search Influence routinely delivers a 10:1 return on investment, or better, for our customers."

# Performs a public internet search (CREDIT COST: 1)
copyscape.internet_matches! text

# Performs a private index search (CREDIT COST: 1)
copyscape.private_matches! text

# Performs a public internet & private index search (CREDIT COST: 2)
copyscape.internet_and_private_matches! text

# All these methods return an array of data structs ex:
#=>
# [
#  <struct SI::CopyScape::Match
#        words_matched = 20,
#      percent_matched = 100,
#                title = "Search Influence | Website Promotion Company",
#                  url = "http://www.searchinfluence.com/",
#        copyscape_url = "http://view.copyscape.com/compare/wpbdhatumu/1",
#         text_snippet = "... Trusted, Scalable Search, Social and Online Advertising. A national website promotion company, Search Influence routinely delivers a 10:1 return on investment, or better, for our customers.",
#         html_snippet = "<font color=\"#777777\">... Trusted, Scalable Search, Social and Online Advertising. </font><font color=\"#000000\">A national website promotion company, Search Influence routinely delivers a 10:1 return on investment, or better, for our customers.</font>"
#  >
# ]
```

Add text to our private index on Copyscape.com
```ruby
copyscape.add_to_private_index(
 text: 'Text to add to index',
 title: 'Title', # not required
 id: 420 # not required
)
#=><struct SI::CopyScape::PrivateIndex words=5, handle="SIA_2_E00JOQ0A2W_T1Q2J78LA1", id="420", title="Title">
```

If there is an error, you can get a string describing the error (returns nil if there is no error)
```ruby
copyscape.internet_matches! "test"
copyscape.error
#=>"At least 15 words are required to perform a search"
```

The error method is also available on the SI::CopyscapeMatches collection returned after a search
```ruby
matches = copyscape.internet_matches! "test"
matches.error
#=>"At least 15 words are required to perform a search"
```

# Flog Score
```
   177.7: flog total
     5.2: flog/method average

    35.0: SI::CopyscapeMatches total
    16.5: SI::CopyscapeMatches#_build_collection lib/copyscape_matches.rb:28
    11.0: SI::CopyscapeMatches#_without_rejects lib/copyscape_matches.rb:47
     7.5: SI::CopyscapeMatches#initialize  lib/copyscape_matches.rb:7

    31.6: SI::CopyScape total
    11.0: SI::CopyScape#credit_balance     lib/copyscape.rb:23
     9.6: SI::CopyScape#add_to_private_index lib/copyscape.rb:52
     6.0: SI::CopyScape#initialize         lib/copyscape.rb:11
     5.0: SI::CopyScape#none

    25.8: SI::CopyscapeAPI total
    14.8: SI::CopyscapeAPI#request         lib/copyscape_api.rb:12
    11.0: SI::CopyscapeAPI#_call_api       lib/copyscape_api.rb:27

     7.7: main total
     7.7: main#none

     7.1: SI::CopyscapeResponse total
     7.1: SI::CopyscapeResponse#results    lib/copyscape_response.rb:27
```