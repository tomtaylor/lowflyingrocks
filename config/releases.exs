import Config

config :lowflyingrocks, import_interval: 3600
config :lowflyingrocks, perform_tweets: true

config :extwitter, :oauth, [
   consumer_key: System.fetch_env!("TWITTER_CONSUMER_KEY"),
   consumer_secret: System.fetch_env!("TWITTER_CONSUMER_SECRET"),
   access_token: System.fetch_env!("TWITTER_ACCESS_TOKEN"),
   access_token_secret: System.fetch_env!("TWITTER_ACCESS_TOKEN_SECRET")
]
