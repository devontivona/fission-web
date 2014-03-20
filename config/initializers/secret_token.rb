# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
Fission::Application.config.secret_key_base = '66924f906bc4946c28a73e44f6cc306b5bbcc5ad3f2e967967c94431581d864632f221059405520a04de91e61d3d07b91417c0a56fa44bb394350f04d1fb82b7'
