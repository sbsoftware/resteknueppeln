require "crumble"
require "sqlite3"
require "orma"
require "crumble-turbo"
require "crumble-material"
require "./ext/**"
require "./models/*"
require "./views/**"
require "./resources/*"
require "./styles/*"

Crumble::Server.start
