fx_version 'adamant'
game 'gta5'

name "RaceMenu"
description "RaceMenu powered by ScaleformUI project , a standalone menu to manage races , leaderboards , vehicles , customizations and much more"
author "BegaMetaZone" 
version "1.0.0"

files { "carcols_gen9.meta", "carmodcols_gen9.meta" }
data_file "CARCOLS_GEN9_FILE" "carcols_gen9.meta"
data_file "CARMODCOLS_GEN9_FILE" "carmodcols_gen9.meta"

shared_script {'config.lua'}

client_scripts {
	"@ScaleformUI_Lua/ScaleformUI.lua",
	"RaceMenu.lua",
	"Functions.lua"
}

server_scripts {
	"Server.lua"
}