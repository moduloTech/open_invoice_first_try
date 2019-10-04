<img src="app/assets/images/open_invoice/logo.svg" align="right" alt="..." width="200px" />

# OpenInvoice

Initial development. Documentation would be here when something would work.

# OpenInvoice Rails engine

## Usage
How to use my plugin.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'open_invoice'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install open_invoice
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

# OpenInvoice Dummy App

This repository is dual: Rails Engine contains fully functional Dummy App that can be
deployed to Heroku, DigitalOcean, private server ...  anywhere.

## Heroku deployment
OpenInvoice repository on GitHub is ready to be deployed to Heroku. Use the button
below and fill up all required fields on the next page. It requires minimum setup 
and uses only add-ons with free plans. So you can try it at zero price.

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)

### Configuration

#### Heroku application name
During the installation you have to choose unique application name. It serves as 
heroku app identifier and as a part of your application URL address. 

Say, your app name is `my-open-invoice`. Then the URL where installed app is hosted
would be `https://my-open-invoice.herokuapp.com`.

It is possible to change application URL to your custom domain. But you will loose 
heroku SSL free support, since using Heroku SSL requires payed dynos.

See [heroku docs](https://devcenter.heroku.com/articles/custom-domains) for more
information about how to configure your custom domain.

#### Heroku ENV

There are 3 required ENV variables for one-click setup: `OPEN_INVOICE_APP_NAME`,
`OPEN_INVOICE_DOMAIN`, `OPEN_INVOICE_HOST`. See 
[ENV variables](#openinvoice-env) section.

### Heroku AddOns

We use the following AddOns to make Dummy App work. Free plan limits are available
here (updated 10/04/2019). To find what actual limits are visit corresponding add-on
pages.

|Add-on|Free limit|Description|
|---|---|---|
|[CloudCube](https://elements.heroku.com/addons/cloudcube)|Storage **5MB**|AWS S3 storage. Used to store invoices pdf files.|
|[Heroku Redis](https://elements.heroku.com/addons/heroku-redis)|Memory **25MB**<br>Connections **20**|Redis storage. Used for Rails session and cache storage.|
|[Heroku Postgres](https://elements.heroku.com/addons/heroku-postgresql)|Row limit **10,000**<br>Connections **20**|PostgreSQL database. Used to back our models.|
|[SendGrid](https://elements.heroku.com/addons/sendgrid)|Emails per month **12,000**|Email delivery platform. Used to notify recipients about newly assigned invoices.|

## Digital Ocean deployment
We've got plans to create a marketplace image with everything installed.

Here is the TODO list for DO droplet configuration.
- create an ubuntu 18.04 droplet, add ssh key
- add firewall and restrict outside access to all ports except:
  - 22 (ssh), 
  - 80 (http), 
  - 443 (https)
- configure custom domain if any
- create user "deploy", add to "sudo" group
    ```
    root@remote ~# adduser deploy
    root@remote ~# adduser deploy sudo
    ```
- authorize ssh key to deploy user. ssh-copy-id won't work! password auth is disabled
 by default
  ```
  root@remote ~# mkdir /home/deploy/.ssh
  user@local ~$ scp ~/.ssh/id_rsa.pub root@<droplet ip>:/home/deploy/.ssh/authorized_keys
  root@remote ~# chown -R deploy:deploy /home/deploy/.ssh
  root@remote ~# chmod 700 /home/deploy/.ssh
  root@remote ~# chmod 600 /home/deploy/.ssh/authorized_keys
  ```
- install postgresql
  ```
  root@remote ~# apt install postgresql postgresql-contrib libpq-dev
  root@remote ~# su - postgres
  postgres@remote ~$ createuser deploy
  postgres@remote ~$ psql
  postgres=# alter user deploy with superuser; \q 
  ```
- install redis-server and nginx
  ```
  root@remote ~# apt install redis-server nginx
  ```
- under user deploy install rvm
  ```
  deploy@remote ~$ gpg --keyserver hkp://pool.sks-keyservers.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
  deploy@remote ~$ \curl -sSL https://get.rvm.io | bash -s stable
  ```
- create project directory
  ```
  deploy@remote ~$ mkdir open_invoice
  ```
- put those environment variables to the **beginning** of .bashrc
  ```
  export RAILS_ENV="production"
  export RACK_ENV="production"
  export LANG="en_US.UTF-8"
  export RAILS_SERVE_STATIC_FILES="false"
  export OPEN_INVOICE_STORAGE="file"
  export OPEN_INVOICE_DIR_PREFIX="/home/deploy/open_invoice/shared/spec/dummy/storage"
  export OPEN_INVOICE_APP_NAME="Open Invoice DO"
  export OPEN_INVOICE_DOMAIN="<droplet ip or custom domain>"
  export OPEN_INVOICE_HOST="http://<droplet ip or custom domain>"
  export SECRET_KEY_BASE="<use 'rails secret' to generate key>"
  ```

## ENV variables

### Rails ENV

| variable | required | example | description |
| --- | --- | --- | --- |
| `RAILS_ENV` | false | production | Rails environment |
| `RACK_ENV` | false | production | Rack environment |
| `RAILS_SERVE_STATIC_FILES` | false | true/false | Set to "true" if you want rails server to send files from public directory. When set to "false" rails will only process its own routes/controllers. You can disable serve static files by rails when using rails server on top of nginx or apache platforms |
| `SECRET_KEY_BASE` | **true** | asdasd232dasdas | Random string. You can use `rails secret` to generate new secret key base.

### OpenInvoice ENV

| variable | required | example | description |
| --- | --- | --- | --- |
| `OPEN_INVOICE_APP_NAME` | **true** | My Open Invoice | Application instance name. It is used in page titles, outgoing emails, etc. |
| `OPEN_INVOICE_DOMAIN` | **true** | my-site.com | Application domain. Domain is used for mailer. |
| `OPEN_INVOICE_HOST` | **true** | https://my-site.com | Application host. Root application URL. |
| `OPEN_INVOICE_STORAGE` | **true** | file<br>aws | **file** means storing within the webserver filesystem<br> **aws** means object storage aws-s3-like |
| `OPEN_INVOICE_DIR_PREFIX` | false | /some/absolute/path<br>or<br>relative/to/public/path | when storage=**file** this option configures local storage folder<br>when storage=**aws** this option configures remote object name path |
| `OPEN_INVOICE_AWS_KEY_ID`<br>`OPEN_INVOICE_AWS_SECRET`<br>`OPEN_INVOICE_AWS_REGION`<br>`OPEN_INVOICE_AWS_BUCKET` | storage == aws | 123<br>asd123<br>eu-central-1<br>my-bucket | AWS S3 storage credentials. |
| `OPEN_INVOICE_MAILER_FROM` | false | no-reply@my-site.com | Default "from" field value for mailer |

### Heroku-specific ENV

- CloudCube aws-s3 add-on adds `CLOUDCUBE_ACCESS_KEY_ID`, 
`CLOUDCUBE_SECRET_ACCESS_KEY`, `CLOUDCUBE_URL`. When `CLOUDCUBE_ACCESS_KEY_ID` is
present, then dummy's initializer is able to configure AWS access.
- SendGrid mail delivery add-on adds `SENDGRID_USERNAME` and `SENDGRID_PASSWORD`. 
When `SENDGRID_USERNAME` is present, dummy's initializer adds SendGrid configuration
to ActionMailer.
