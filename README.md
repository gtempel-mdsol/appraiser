# appraiser
ruby script to example 'bundle outdated' or 'bundle list' output and plumb rubygems to determine the appropriate ruby version(s)


[Bundler](http://bundler.io/) provides a great way to manage and update your ruby project's gems, but what if you want to know what ruby version is supported by your current set of gems? That's where appraiser comes in. It's smart enough to understand the output of bundler's [`list`](http://bundler.io/v1.16/man/bundle-list.1.html)
 and [`outdated`](http://bundler.io/v1.16/man/bundle-outdated.1.html) 
 commands, and will use that information to probe for ruby version information at [rubygems](http://rubygems.org).

## Usage: list
From within your ruby project's top level directory pipe the bundler output to this script. For example:

```
cd $HOME/projects/my_excellent_project
bundle list | ruby /where_ever/you/have/appraiser.rb
```

The appraiser will evalute bundler's output and emit output about your project's gems, such as

```
actionmailer @ v4.1.16 requires >= 1.9.3
actionpack @ v4.1.16 requires >= 1.9.3
actionview @ v4.1.16 requires >= 1.9.3
active_model_serializers @ v0.9.3 requires >= 1.9.3
active_record_query_trace @ v1.4 requires >= 0
activemodel @ v4.1.16 requires >= 1.9.3
activerecord @ v4.1.16 requires >= 1.9.3
activerecord-import @ v0.15.0 requires >= 1.9.2
activerecord-session_store @ v1.0.0 requires >= 1.9.3
activesupport @ v4.1.16 requires >= 1.9.3
NO INFO FOR   * activity_tracker_js (0.4.2 0487461)
NO INFO FOR   * acts_as_auditable (2.2.1 2dc5779)
american_date @ v1.0.0 requires ?
```

[Rubygems](http://rubygems.org) doesn't always have ruby version information for certain gems, and in those cases you'll see a `?` question mark. Rubygems obviously won't have information for your gems that are hosted in a git repo, and for those the appraiser will tell you that it cannot find any information for those gems, echoing out the bundler information instead.


## Usage: outdated

```
cd $HOME/projects/my_excellent_project
bundle outdated | ruby /where_ever/you/have/appraiser.rb
```

The appraiser will evalute bundler's output and emit output about your project's gems, such as

```
actionmailer @ v4.1.16 requires >= 1.9.3; newest v5.1.5 requires >= 2.2.2
actionpack @ v4.1.16 requires >= 1.9.3; newest v5.1.5 requires >= 2.2.2
actionview @ v4.1.16 requires >= 1.9.3; newest v5.1.5 requires >= 2.2.2
active_model_serializers @ v0.9.3 requires >= 1.9.3; newest v0.10.7 requires >= 2.1
active_record_query_trace @ v1.4 requires >= 0; newest v1.5.4 requires >= 0
activemodel @ v4.1.16 requires >= 1.9.3; newest v5.1.5 requires >= 2.2.2
activerecord @ v4.1.16 requires >= 1.9.3; newest v5.1.5 requires >= 2.2.2
activerecord-import @ v0.15.0 requires >= 1.9.2; newest v0.22.0 requires >= 1.9.2
activerecord-session_store @ v1.0.0 requires >= 1.9.3; newest v1.1.1 requires >= 1.9.3
activesupport @ v4.1.16 requires >= 1.9.3; newest v5.1.5 requires >= 2.2.2
NO INFO FOR   * activity_tracker_js (0.4.2 0487461)
NO INFO FOR   * acts_as_auditable (2.2.1 2dc5779)
american_date @ v1.0.0 requires ?; newest v1.1.1 requires >= 0
```

The same gem caveats apply here regarding gems that the appraiser cannot find information on.


## Development & Test

Setup:
```
bundle install --binstubs
```

Test:
```
bin/spec --format documentation
```
