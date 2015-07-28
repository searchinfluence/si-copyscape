# SI::CopyScape Gem
A gem to provide the communication layer with the Copyscape.com Premium API and your application.

Copyscape Documentation: (requires login) http://copyscape.com/apiconfigure.php

## Usage:
Set the following environment variables (or pass the values in during initialization):
- ENV['COPYSCAPE_USERNAME']
- ENV['COPYSCAPE_API_KEY']
 
```
gem install si-copyscape
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
#=>{"value"=>"114.9", "total"=>"2298", "today"=>"2298"}
```

Perform text searches for copy matches
```ruby
text = "All the words to look for"

# Performs a public internet search (CREDIT COST: 1)
copyscape.internet_matches! text

# Performs a private index search (CREDIT COST: 1)
copyscape.private_matches! text

# Performs a public internet & private index search (CREDIT COST: 2)
copyscape.internet_and_private_matches! text
```
