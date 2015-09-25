Generates a config for Etsy's [Hound](https://github.com/etsy/hound), crawling over a list of TeamCity servers to get their VCS roots and spitting it out. Archived projects are ignored.

Usage:

1. `bundle install`
1. `touch serverlist`
1. Add TeamCity server hostnames to `serverlist`, each on a new line
1. `./generate-config.rb > config.json`
1. Put `config.json` in your Hound folder
