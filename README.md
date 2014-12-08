

Teamroq is an open source enterprise collaboration platform. It is ideal for organizations looking for

- Project management
- Teams management
- Document management
- Knowledge management
- Activity Feeds & Notifications

### Dependencies###

* Postgres Database
* Redis
* ImageMagick
* Memcached (optional)

### Installation steps ###

* Install all dependencies listed above
* Run the following rake task to create application.yml file.
`bundle exec rake teamroq:install`
* Edit the generated config file.
* It is very important to change application_secret_key_base property in configuration. Run 'rake secret' and copy the generate value to application.yml

## Configuration ##

### Database ###

In database.yml

### Redis ###

In redis.yml

### Imagemagick ###


### Memcached ###


## Running teamroq ##

Using Foreman

## Generating Admin User ##

Use the following rake task to generate an admin user.
`bundle exec rake teamroq:setup:admin ENV[EMAIL]='user@a.com' ENV[NAME] = 'Srikanth' ENV[PASSWORD]='foobar123' -e production`

## Generating a User ##

Use the following rake task to generate a user.
`bundle exec rake teamroq:setup:user ENV[EMAIL]='user@a.com' ENV[NAME] = 'Srikanth' ENV[PASSWORD]='foobar123' -e production`




	



### Installation Steps ###

* Summary of set up
* Configuration
* Dependencies
* Database configuration
* How to run tests
* Deployment instructions


