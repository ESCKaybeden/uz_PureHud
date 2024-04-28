fx_version "cerulean"

description "UZStore"
author "UZ#5751"
version "1.0.0"
repository "https://discord.gg/8zhnDMMfNk"

lua54 "yes"

game "gta5"

ui_page "resources/build/index.html"

shared_script "Customize.lua"

client_script "client.lua"

server_script "server.lua"

files {
  "resources/build/index.html",
  "resources/build/**/*",
}

escrow_ignore { "Customize.lua" }
