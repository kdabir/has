# has

`has` helps you check presence of various command line tools on path.

## How ?

  Download the `has` file. There is no dependency apart from `bash` itself 

    $ bash has node npm java git gradle 
    ✔ node 8.2.1
    ✔ npm 5.3.0
    ✔ java 1.8.0
    ✔ git 2.14.1
    ✔ gradle 4.0.1

## Installing

Just download the `has` script in your path. 

If you are lazy, you can has of the internet as well

    curl -sL https://raw.githubusercontent.com/kdabir/has/master/has | bash -s git node npm
    ✔ git 2.14.1
    ✔ node 8.2.1
    ✔ npm 5.3.0


And if that's too much of typing everytime, setup an alias
    
    alias has="curl -sL https://raw.githubusercontent.com/kdabir/has/master/has | bash -s"

And uses it

    $ has git
    ✔ git 2.14.1


### ♥
