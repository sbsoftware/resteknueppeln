require "crumble"
require "sqlite3"
require "orma"
require "crumble-turbo"
require "./ext/**"
require "./models/*"
require "./views/*"
require "./resources/*"
require "./styles/*"

Crumble::Server.start
