# Sage300 Web Application.

## Table of Contents

- [Build Docker Containers](#build-docker-containers)
  - [Build application](#build-application)
  - [Boot application](#boot-application)

- [New deployment](#new-deployment)
  - [Update ENV variables](#update-the-env-variables-file)
  - [Running migrations](#running-migrations)
  - [Deploying Code](#deploying-code)
  - [Set config files](#set-config-files)
  - [Background jobs Sidekiq](#sidekiq)
  - [Searchkick Indexes](#searchkick)
  - [Country Code](#country-code)
  - [Logrotate](#logrotate)

- [Ruby environment with rbenv](#ruby-environment-with-rbenv)
  - [Installation](#instalation)
  - [Command Reference](#command-reference)
    - [rbenv local](#rbenv-local)
    - [rbenv global](#rbenv-global)
    - [rbenv versions](#rbenv-versions)
    - [rbenv rehash](#rbenv-rehash)

# Build Docker Containers

First, make sure you have docker and docker-compose installed on your machine. To get a copy of the official Git repository, the command you need is `git clone <url>`.    
`git clone https://github.com/lepepe/sage300.git`   

### Build application

Then, get into the directory `sage300` and build the application containers.   
`docker-compose build`   
This will show the images being built. After the initial build, you will see the names of the containers being created.   

```
Pulling postgres (postgres:9.6.2-alpine)
9.6.2-alpine: Pulling from library/postgres
627beaf3eaaf: Pull complete
e351d01eba53: Pull complete
cbc11f1629f1: Pull complete
2931b310bc1e: Pull complete
2996796a1321: Pull complete
ebdf8bbd1a35: Pull complete
47255f8e1bca: Pull complete
4945582dcf7d: Pull complete
92139846ff88: Pull complete
Digest: sha256:7f3a59bc91a4c80c9a3ff0430ec012f7ce82f906ab0a2d7176fcbbf24ea9f893
Status: Downloaded newer image for postgres:9.6.2-alpine
Building web
```   
*This will take some minutes*.

### Boot application

Finaly you can now boot the app with docker-compose:
`docker-conmpose up`

If all’s well, you should see some output like:
```irb
web_1            | => Booting Puma
web_1            | => Rails 5.1.6 application starting in development 
web_1            | => Run `rails server -h` for more startup options
web_1            | Puma starting in single mode...
web_1            | * Version 3.12.0 (ruby 2.3.8-p459), codename: Llamas in Pajamas
web_1            | * Min threads: 5, max threads: 5
web_1            | * Environment: development
web_1            | * Listening on tcp://0.0.0.0:3000
web_1            | Use Ctrl-C to stop
worker_1         | 2020-01-10T22:12:25.779Z 1 TID-gs6m6t2n8 INFO: Running in ruby 2.3.8p459 (2018-10-18 revision 65136) [x86_64-linux]
worker_1         | 2020-01-10T22:12:25.779Z 1 TID-gs6m6t2n8 INFO: See LICENSE and the LGPL-3.0 for licensing details.
worker_1         | 2020-01-10T22:12:25.779Z 1 TID-gs6m6t2n8 INFO: Upgrade to Sidekiq Pro for more features and support: http://sidekiq.org
worker_1         | 2020-01-10T22:12:25.779Z 1 TID-gs6m6t2n8 INFO: Booting Sidekiq 4.2.10 with redis options {:url=>"redis://redis:6379"}
worker_1         | 2020-01-10T22:12:25.781Z 1 TID-gs6m6t2n8 INFO: Starting processing, hit Ctrl-C to stop

```   

You can now get into the application from a web browser: [http://localhost:3000](http://localhost:3000).

## New deployment

### Update the env variables file

Local machine.   
For development we need to update the env variable file: `variables.env`   
This file containes all env variable the application needs to run.   

```
ELASTICSEARCH_URL=http://elasticsearch:9200/
REDIS_URL=redis://redis:6379

# Sage300 DB
ACCPAC_DB_HOST=IP_ADDRESS
ACCPAC_DB_NAME=DB_NMAE
ACCPAC_DB_USERNAME=USER_NAME
ACCPAC_PASSWD=PASSWORD
ACCPAC_DB_PORT=PORT

# Mandrill
MANDRILL_API_KEY=API_KEY

# AWS S3
ERP_BUCKET=
ERP_ACCESS_KEY=
ERP_SECRET_ACCESS_KEY=
```   

*Make sure .gitignore file exclude variables.env so we don't push this ENV to main repository.*   

### Running migrations

To run migrations for MSSQL, need to run:   
`docker-compose run web bundle exec rake sqlserver:db:migrate` 


### Deploying Code
Once everything on the servers are configured and ready to go, we need a way to upload our code to production.   
Capistrano is a tool for making copies of your repository in production and then easily making new releases.   
Now we need to add a new file `config/deploy/DATABASE_ID.rb` to point to our server's IP address for deployments. Make sure to replace 1.2.3.4 with the proper server's 
public IP and DATABASE_ID with Sage300 Database Id.   

```ruby
server '1.2.3.4', user: 'deploy', roles: %w{web}
server '1.2.3.4', user: 'deploy', roles: %w{app}

set :application, "erp-DATABASE_ID"
set :repo_url, 'git@github.com:lepepe/sage300.git'
set :deploy_to, '/home/deploy/erp-DATABASE_ID'
```   

Now we can deploy to production:
`docker-compose run web bundle exec cap DATABASE_ID deploy`   

If any error ocurr during deplyment it should be related with missing configuration files, log in into the web servers set the files, see next [step](#set-config-files).

### Set Config Files
All these files needs to be located on: `/home/deploy/APP_LOCATION/shared/config`.   

`config/database.yml`: Sage300 SQL server database.   
`config/secrets.yml`: stores application's sensitive data, such as access keys and passwords that are required for external APIs.   

*The `database*` adapters and secrets on the configs file needs to be configured as the environment.*   
```
production: # This line has to be the Rails ENV
  secret_key_base: <%= ENV["SECRET_KEY_BASE"] %>
  access_key_id: <%= ENV["ERP_ACCESS_KEY"] %>
  secret_access_key: <%= ENV["ERP_SECRET_ACCESS_KEY"] %>
```   
Once all config files are set we need to restart the application: `touch /home/deploy/APP/current/tmp/restart.txt`.

### Sidekiq
:cloud: Remote production servers.   
We use [Sidekiq](https://github.com/mperham/sidekiq) as background job processing for our applications.   
Sidekiq uses threads to handle many jobs at the same time in the same process. It is integrated tightly with Rails to make background processing dead simple.   
Customize this block of code based on bundler location, app directory, etc and put it in /lib/systemd/system (Ubuntu), example:   
`sudo vim /lib/systemd/system/sidekiq.service`.   
Make sure the change `APP_LOCATION`, `ENVIRONMENT` and repeat the same steps on all productions servers that run the application listed on the load balancers.   

```
[Unit]
Description=sidekiq
After=syslog.target network.target

[Service]
Type=simple
WorkingDirectory=/home/deploy/APP_LOCATION/current
ExecStart=/home/deploy/.rbenv/shims/bundle exec sidekiq -e ENVIRONMENT
User=deploy
Group=deploy
UMask=0002

# Greatly reduce Ruby memory fragmentation and heap usage
# https://www.mikeperham.com/2018/04/25/taming-rails-memory-bloat/
Environment=MALLOC_ARENA_MAX=2

# if we crash, restart
RestartSec=1
Restart=on-failure

# output goes to /var/log/syslog
StandardOutput=syslog
StandardError=syslog

# This will default to "bundler" if we don't specify it
SyslogIdentifier=sidekiq

[Install]
WantedBy=multi-user.target
```

Then run:   
```
systemctl enable sidekiq
systemctl {start,stop,restart,reload} sidekiq
```

To check the service start sucessfully, run: `ps -aux | grep sidekiq`   
```
deploy     995  0.6  2.4 774000 394264 ?       Ssl  Apr01 2120:42 sidekiq 4.2.10 erp-mexico [0 of 25 busy]
deploy   16266  1.0  1.2 527616 207284 ?       Ssl  21:49   0:10 sidekiq 4.2.10 erp-spain [0 of 25 busy]
deploy   19357  0.0  0.0  14660  1052 pts/0    S+   22:06   0:00 grep --color=auto sidekiq
```

### Searchkick

Remote Database servers.   

[Searchkick](https://github.com/ankane/searchkick) is a gem that allows use elastic search with Rails applications.   

#### Models where we use elastic:

- Accpac::Icitem
- Accpac::Arcus
- Accpac::Apven

To run the indexes it is necessary to access via SSH to one of the production servers:   
```
ssh deploy@IP_ADDRESS
cd /path/to/app
bundle exec rake RAILS_ENV=ENVIRONEMNT searchkick:reindex CLASS=ClassName
```
Make sure to change the `ENVIRONMENT` and `ClassName`.

### Country Code

We use [ISO 3166-1 alpha-2](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2) for country codes. ISO 3166-1 alpha-2 codes are two-letter country codes defined in ISO 3166-1, 
part of the ISO 3166 standard published by the International Organization for Standardization (ISO), to represent countries, 
dependent territories, and special areas of geographical interest.   
Please make sure the Company Profile in Sage300 is filled with the proper country code.   

### Logrotate

Configuring Logrotate For Rails Production Logs.   
The first step is to edit `sudo vim /etc/logrotate.conf`, at the bottom of the file an add the following block of code (change the APPNAME, ex: erp-accltd):   

```
/home/deploy/APPNAME/current/log/*.log {
  daily
  missingok
  rotate 7
  compress
  delaycompress
  notifempty
  copytruncate
}
```

**How it works:**   
- daily – Rotate the log files each day.
- missingok – If the log file doesn’t exist, ignore it.
- rotate 7 – Only keep 7 days of logs.
- compress – GZip the log file on rotation.
- delaycompress – Rotate the file one day, then compress it the next day so we can be sure that it won’t interfere with the Rails server.
- notifempty – Don’t rotate the file if the logs are empty.
- copytruncate – Copy the log file and then empties it.

**Running Logrotate:**   
To run logrotate manually, we just do: `sudo /usr/sbin/logrotate -f /etc/logrotate.conf`

# Ruby environment with rbenv

Use rbenv to pick a Ruby version for our application to guarantee that our development environment matches production.

### Instalation

How to install Ruby using a Ruby version manager rbenv. It is the easiest and simplest option, plus it comes with some handy plugins to let us easily manage environment variables in production.   

```
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc
git clone https://github.com/rbenv/rbenv-vars.git ~/.rbenv/plugins/rbenv-vars
exec $SHELL
rbenv install 2.4.0
rbenv global 2.4.0
ruby -v
# Output ruby 2.4.0
```

### Command Reference

#### rbenv local

Sets a local application-specific Ruby version by writing the version name to a `.ruby-version` file in the current directory. This version overrides the global version, and can be overridden itself by setting the `RBENV_VERSION` environment variable or with the `rbenv shell` command.   

```
$ rbenv local 2.4.0
```

#### rbenv global

Sets the global version of Ruby to be used in all shells by writing the version name to the `~/.rbenv/version` file. This version can be overridden by an application-specific `.ruby-version` file, or by setting the `RBENV_VERSION` environment variable.   

```
$ rbenv global 2.4.0
```

#### rbenv versions

Lists all Ruby versions known to rbenv, and shows an asterisk next to the currently active version.   

```
$ rbenv versions
  system
* 2.3.7 (set by /home/deploy/.rbenv/version)
  2.4.0
```

#### rbenv rehash

Installs shims for all Ruby executables known to rbenv (i.e., `~/.rbenv/versions/*/bin/*`). Run this command after you install a new version of Ruby, or install a gem that provides commands.   

```
$ rbenv rehash
```
