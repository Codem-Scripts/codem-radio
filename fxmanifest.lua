fx_version "cerulean"

description "CodeM Store"
author "canrow#8946"
version "1.0.0"

lua54 "yes"

game "gta5"

ui_page "resources/build/index.html"

shared_script "Settings.lua"

client_script "client.lua"

server_script "server.lua"


files {
  "resources/build/index.html",
  "resources/build/**/*"
}

escrow_ignore { 
  "Settings.lua",
  "server.lua",
  "client.lua"

}
dependency '/assetpacks'