# Discourse Dev

![Gem](https://img.shields.io/gem/v/discourse_dev)

Rake helper tasks for Discourse developers. These tasks can be used to populate random data like topics, groups, users, categories, and tags in your local `discourse_development` database.

## Available Rake Tasks

#### `dev:reset`

* db:migrate:reset
  * db:drop
  * db:create
  * db:migrate
* dev:config
* admin:create
* dev:populate
  * groups:populate
  * users:populate
  * categories:populate
  * topics:populate
  * tags:populate

The `rake dev:reset` command will just invoke other rake tasks in the above order. So it will completely recreate your development environment.

#### `dev:config`

Reloads the site settings from the dev.yml file.

#### `dev:populate`

Runs all of the sub-populate tasks.

### `*:populate`

Populates the specified groups of records based on settings in dev.yml.

* `groups:populate`
* `users:populate`
* `categories:populate`
* `tags:populate`
* `topics:populate`
* `replies:populate`

## Configuration

In your local Discourse repository, this gem is included as a dependency. When you run the gem for the first time it will look for a `config/dev.yml` file and if it does not find one it will generate one from the default included with the gem. Here you can specify site settings which will override default site setting values, as well as configuration for how the local data is generated with this gem.

For category, group, post, tag, topic, and user you can specify the `count`, which is the maximum number of records that will be generated by the associated task.

For more in-depth information about configuration, consul the comments in the default `dev.yml` in the source code.
