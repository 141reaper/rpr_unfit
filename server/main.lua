-- RPR Unfit - Server Main File
ESX, QBCore = nil, nil
unfitPlayers = {}
hasMySQL = false

-- Framework Detection and Initialization
if Config.Framework == 'esx' then
    ESX = exports["es_extended"]:getSharedObject()
elseif Config.Framework == 'qb' then
    QBCore = exports['qb-core']:GetCoreObject()
end

-- Database functions
function InitializeDatabase()
    if not Config.UseDatabase then return end
    
    -- Check if MySQL is available
    if GetResourceState('oxmysql') ~= 'started' then
        print('[RPR-UNFIT] MySQL is not available, database functionality disabled')
        Config.UseDatabase = false
        return
    end
    
    hasMySQL = true
    exports['oxmysql']:execute([[
        CREATE TABLE IF NOT EXISTS `rpr_unfit_status` (
            `identifier` VARCHAR(60) NOT NULL,
            `unfit_time` INT(11) NOT NULL,
            `timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (`identifier`)
        )
    ]], {}, function(rowsChanged)
        print('[RPR-UNFIT] Database initialized')
    end)
end

-- Initialize database on resource start if enabled
CreateThread(function()
    if Config.UseDatabase then
        Wait(1000) -- Wait for MySQL to be ready
        InitializeDatabase()
    end
end)

-- Utility function for time formatting
function FormatTime(seconds)
    local minutes = math.floor(seconds / 60)
    local remainingSeconds = seconds % 60
    
    if minutes > 0 then
        return string.format("%d:%02d", minutes, remainingSeconds)
    else
        return string.format("%d sec", remainingSeconds)
    end
end

-- Debug function
function DebugPrint(message)
    if Config.DebugMode then
        print("[RPR-UNFIT] " .. message)
    end
end