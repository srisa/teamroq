# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
Teamroq::Application.config.secret_key_base = ENV["application_secret_key_base"]
#Teamroq::Application.config.secret_key_base = "ab3abc423232bcde23a3434aaa2323239898c9898d989f98989a898"