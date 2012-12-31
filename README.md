# Myaka

Rails web application for managing [akas](http://nameblossom.org/akas/), used by [my.aka.nu](https://my.aka.nu/)

## Current Functionality

* Create an aka
* Add/remove profile links
* Set tent server URL
* Edit profile page
* Reset password
* Find akas given e-mail address
* Change password, email, display name

## Running it

I keep the secret token in an external configuration file. You can specify its location via the MYAKA_CONFIG
environment variable, or place it in a file called local_myaka_config.rb in the parent directory above the
rails root. You also need to specify the config.environment_name variable.

For example:

    Myaka::Application.configure do
        config.secret_token = "12345....67890"
    end

The admin interface will only show up if it's requested from the config.myaka_domain host (default my.aka.nu);
otherwise it assumes you're asking for an aka and will try to find an aka with a matching subdomain. You can
set up your hosts file to match your config.myaka_domain for local development.

Akas are subdomains under the domain set in config.aka_domain (default aka.nu); you can also set up profile
URLs under that in your hosts file for local development.

    127.0.0.1 my.aka.nu       # config.myaka_domain
    127.0.0.1 paul.aka.nu     # profile url on config.aka_domain
    127.0.0.1 paulodin.aka.nu # anther profile url

## Group

If you want to discuss this project join the Nameblossom [Yahoo group](http://tech.groups.yahoo.com/group/nameblossom)
