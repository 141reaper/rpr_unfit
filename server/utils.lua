-- RPR Unfit - Server Utility Functions
-- Get player identifier based on framework
function GetPlayerIdentifier(source)
    local identifier = nil
    if Config.Framework == 'esx' and ESX then
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer then
            identifier = xPlayer.getIdentifier()
        end
    elseif Config.Framework == 'qb' and QBCore then
        local Player = QBCore.Functions.GetPlayer(source)
        if Player then
            identifier = Player.PlayerData.citizenid
        end
    end
    return identifier
end

-- Check if player is admin
function IsPlayerAdmin(source)
    if Config.Framework == 'esx' and ESX then
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer then
            for _, group in ipairs(Config.AdminGroups) do
                if xPlayer.getGroup() == group then
                    return true
                end
            end
        end
    elseif Config.Framework == 'qb' and QBCore then
        local Player = QBCore.Functions.GetPlayer(source)
        if Player then
            for _, group in ipairs(Config.AdminGroups) do
                if QBCore.Functions.HasPermission(source, group) then
                    return true
                end
            end
        end
    end
    return false
end

-- Check if player is medic
function IsPlayerMedic(source)
    if Config.Framework == 'esx' and ESX then
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer and xPlayer.job.name == Config.AmbulanceJob then
            return true
        end
    elseif Config.Framework == 'qb' and QBCore then
        local Player = QBCore.Functions.GetPlayer(source)
        if Player and Player.PlayerData.job.name == Config.QBAmbulanceJob then
            return true
        end
    end
    return false
end

-- Show notification to player based on framework
function NotifyPlayer(source, message)
    if Config.Framework == 'esx' then
        TriggerClientEvent('esx:showNotification', source, message)
    elseif Config.Framework == 'qb' then
        TriggerClientEvent('QBCore:Notify', source, message)
    else
        -- Fallback to native notification
        TriggerClientEvent('rpr_unfit:showNotification', source, message)
    end
end