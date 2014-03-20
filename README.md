# Fission (API Server)
Fission is a hosted, mobile split testing library for iOS. This application serves as the endpoint for the iOS library.

### Installation
These instructions assume you are setting up the development environment for Fission on a Mac with a ruby environment, git, and a recent version of OS X installed.

1. Install [Homebrew](http://brew.sh) for easy package management by running the following in Terminal: 
        
        $ ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
1. Install [Pow](http://pow.cx) for hosting Rack apps locally by running the following command in Terminal: 
    
        $ curl get.pow.cx | sh
1. Install PostgreSQL for data persistence by running the following command in Terminal: 

        $ brew install postgresql

    Important: Follow the instructions given after running this command to have PostgreSQL initialize automatically on startup.
1. Clone this repository onto your development environment.
        
        $ cd ~/Projects
        $ git clone https://github.com/devontivona/fission-web.git fission-web
1. Setup a symlink to create the Rack app in Pow.
    
        $ cd ~/.pow
        $ ln -s ~/Projects/fission-web

1. Return to the directory where you cloned Varsity to setup the Rails app.

        $ cd ~/Projects/fission-web
        $ bundle install
        $ rake db:setup

1. You should be set! Open `http://fission-web.dev` in your web browser to see the results of your hard work! If you have any questions please reach out to [devon@tivona.me](mailto:devon@tivona.me).