fx_version 'adamant'
game 'gta5'

name "Artemis"
description "Project Artemis powered by ScaleformUI project , a standalone menu to manage races , leaderboards , vehicles , customizations and much more"
author "BegaMetaZone" 
version "1.0.1"

files { "carcols_gen9.meta", "data/carmodcols_gen9.meta" }
data_file "CARCOLS_GEN9_FILE" "data/carcols_gen9.meta"
data_file "CARMODCOLS_GEN9_FILE" "data/carmodcols_gen9.meta"

shared_script {'conf/*.lua'}

client_scripts {
	"@ScaleformUI_Lua/ScaleformUI.lua",
	"client/*.lua"
}

server_scripts {
	"server/*.lua"
}