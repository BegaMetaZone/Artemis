-- Player Class
Arta = {}
Arta.Player = {}
Arta.Player.__index = Arta.Player


function Arta.Player.new(id, name, cash, bank, crypto)
    local self = setmetatable({}, Arta.Player)
    self.id = id
    self.name = name
    self.cash = cash
    self.bank = bank
    self.crypto = crypto
    self.garages = {}
    return self
end


-- Garage Class
Arta.Player.Garage = {}
Arta.Player.Garage.__index = Arta.Player.Garage
function Arta.Player.Garage.new(id, name)
    local self = setmetatable({}, Arta.Player.Garage)
    self.id = id
    self.name = name
    self.vehicles = {}
    return self
end

-- Vehicle Class
Arta.Player.Garage.Vehicle = {}
Arta.Player.Garage.Vehicle.__index = Arta.Player.Garage.Vehicle
function Arta.Player.Garage.Vehicle.new(id, name)
    local self = setmetatable({}, Arta.Player.Garage.Vehicle)
    self.id = id
    self.name = name
    return self
end


function Arta.Player:addGarage(garage)
    table.insert(self.garages, garage)
end

function Arta.Player.Garage:addVehicle(vehicle)
    table.insert(self.vehicles, vehicle)
end


function Arta.Player:save()
    local sql = "INSERT INTO arta_players (id, name, cash, bank, crypto) VALUES (@id, @name, @cash, @bank, @crypto)"
    local parameters = {['@id'] = self.id, ['@name'] = self.name, ['@cash'] = self.cash, ['@bank'] = self.bank, ['@crypto'] = self.crypto}
    MySQL.Async.execute(sql, parameters, function(rowsChanged)
        print(rowsChanged .. " row(s) changed")
    end)
end


function Arta.Player.Garage:save()
    local sql = "INSERT INTO arta_garages (id, name, artaplayer_id) VALUES (@id, @name, @artaplayer_id)"
    local parameters = {['@id'] = self.id, ['@name'] = self.name, ['@artaplayer_id'] = self.player.id}
    MySQL.Async.execute(sql, parameters, function(rowsChanged)
        print(rowsChanged .. " row(s) changed")
    end)
end

function Arta.Player.Garage.Vehicle:save()
    local sql = "INSERT INTO arta_vehicles (id, name, artagarage_id) VALUES (@id, @name, @artagarage_id)"
    local parameters = {['@id'] = self.id, ['@name'] = self.name, ['@artagarage_id'] = self.garage.id}
    MySQL.Async.execute(sql, parameters, function(rowsChanged)
        print(rowsChanged .. " row(s) changed")
    end)
end


function Arta.Player:getMoney(type)
    if type == 'cash' then
        return self.cash
    elseif type == 'bank' then
        return self.bank
    elseif type == 'crypto' then
        return self.crypto
    else
        return 0
    end
end

function Arta.Player:setMoney(type, amount)
    if type == 'cash' then
        self.cash = amount
    elseif type == 'bank' then
        self.bank = amount
    else
        self.crypto = amount
    end
end

function Arta.Player:addMoney(type, amount)
    if type == 'cash' then
        self.cash = self.cash + amount
    elseif type == 'bank' then
        self.bank = self.bank + amount
    else
        self.crypto = self.crypto + amount
    end
end

function Arta.Player:takeMoney(type, amount)
    if type == 'cash' then
        self.cash = self.cash - amount
    elseif type == 'bank' then
        self.bank = self.bank - amount
    else 
        self.crypto = self.crypto - amount
    end
end
