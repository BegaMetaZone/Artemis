-- server.lua
local MySQL = require("mysql-async")

-- Load the shared script
--local shared = require 'Arta'

-- Listen for the playerConnecting event
AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
    -- Get the source of the event (the player's server ID)
    local source = source

    -- Check if the player is already in the database
    local sql = "SELECT * FROM arta_players WHERE id = @id"
    local parameters = {['@id'] = source}
    MySQL.Async.fetchAll(sql, parameters, function(result)
        if #result == 0 then
            -- This is the player's first time joining, create a new player
            local player = Arta.Player.new(source, GetPlayerName(PlayerId()), 1000, 2000)

            -- Add some cryptocurrencies to the player
            --player:addMoney('bmz', 2) -- add 2 bmz coins
            --player:addMoney('arta', 10) -- add 10 arta coins

            -- Save the player to the database
            player:save()

            -- Send a message to the client
            TriggerClientEvent('onPlayerCreated', source, 'Player created!')
        else
            -- This is not the player's first time joining, do nothing
        end
    end)
end)
