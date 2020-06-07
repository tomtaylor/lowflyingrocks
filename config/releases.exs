import Config

config :lowflyingrocks, import_interval: 3600
config :lowflyingrocks, perform_tweets: true

config :extwitter, :oauth, [
   consumer_key: "",
   consumer_secret: "",
   access_token: "",
   access_token_secret: ""
]
