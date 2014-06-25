# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
LtiSecurity::Application.config.secret_key_base = '377c69ac20b5535992a72cc0543d9342aec9c6fe8ff19804d08c5632b83bd98304dca977ab3884b3706c9bbb2a1fe30fd432ca97052ddd46a16d592c5952001f'
