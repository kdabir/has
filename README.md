# dq

Check how developer friendly is your machine!

## How ?

Just fire the following from the Terminal 

    curl -sL https://dqhub.herokuapp.com/dq?check=*/java,*/ruby,*/python,*/git,*/node | bash`

Should produce output like:

    ✔ git                            2.3.0
    ✔ java                           1.8.0
    ✔ node                           0.12.0
    ✔ python                         2.7.6
    ✔ ruby                           2.1.2
    Your dq is 5 / 5

We have checks for more than 40 commands, 

## Sharable url?
The urls like above look bit long and scary. They are not 'share' friendly. We've got you covered. You can shorten 
the url either using dqhub itself (and give a logical name too) or any third party url-shortner.

We have already done for the check that we did above:
 
    curl -sL https://dqhub.herokuapp.com/check/minimal | bash
 
**Feeling courageous**, see what all you have got :

    curl -sL https://dqhub.herokuapp.com/check/all | bash

This checks for about 40 commands on your box

## More configurable DQ

You can edit the query params to make dq check for only those commands that you care about:

    https://dqhub.herokuapp.com/dq?check=frontend/*
    
Check the lib directory structure, `check` query param should be comma separated list of globs (path)
     

## Running Locally

`cd` in to directory and just do a `bundle install` once and then to start server `rackup`.


## Rolling out your own locally

When you need to mix and match, it's equally simple. Checkout the repo, and execute from the root:

`ruby build.rb <command_patterns> | sh`

For example, if you develop frontend apps with node/ruby and use some typical databases

`ruby build.rb "db/*,frontend/*,ruby/*" | sh`

Or, you develop server side java/groovy and use some common databases

`ruby build.rb "java/*,groovy/*,db/*" | sh`

There no external gem dependency, you just need to have `ruby` though.


## Deploying to heroku

 heroku addons:add mongolab
 
## #noserver
checkout bash-only branch, it's maintained by awesome @dexterous.

## About

Ever got onto a new machine or a remote server ? If you develop, you almost certainly need to check availability of your
tool-chain on command line. DQ is intended to relieve you from pain of checking each command individually.

It was named DQ as Developer Quotient (or Developer Friendliness Quotient of a machine), which may not be the most
apt name but that was the best name I could think of.

## Contributing

Please submit more command checks, it's very easy to do so. Fork the repo and send PR.
Issues and feedback welcome.

## Paranoid ?

Don't want to run `curl` piping to `bash`. Understandably, you might be concerned. Worry not.
- If you still want to check, do a  `curl -sL <url> | cat`  first.
    (replacing `bash` with `cat`, to see the content of the file )

### ♥
