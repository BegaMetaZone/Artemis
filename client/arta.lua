-- client.lua chatgpt on meth 
-- This script runs on the client-side

-- Load the shared script
--local shared = require 'Arta'

-- Create a new player when the game starts
-- GetPlayerName(PlayerId())

--local Player = Arta.Player.new(1, GetPlayerName(PlayerId()), 1000, 2000)

-- Listen for the key press event
RegisterCommand('+addMoney', function(source, args)
    -- Parse the command arguments
    local type = args[1]
    local amount = tonumber(args[2])
    if type and amount then
        -- Add money to the player
        Arta.Player:addMoney(type, amount)
        print('Added '..amount..' to '..type)
    end
end, false)
