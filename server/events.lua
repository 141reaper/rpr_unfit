-- RPR Unfit - Server Events
-- Event handlers
RegisterNetEvent("rpr_unfit:trigger")
AddEventHandler("rpr_unfit:trigger", function()
    local src = source
    local identifier = GetPlayerIdentifier(src)
    if not identifier then return end

    if not unfitPlayers[identifier] then
        unfitPlayers[identifier] = Config.Time
    else
        unfitPlayers[identifier] = unfitPlayers[identifier] + Config.ExtendTime
    end

    TriggerClientEvent("rpr_unfit:start", src, unfitPlayers[identifier])
    
    if Config.UseDatabase and hasMySQL then
        SaveUnfitStatus(identifier, unfitPlayers[identifier])
    end
end)

RegisterNetEvent("rpr_unfit:resetUnfitTimer")
AddEventHandler("rpr_unfit:resetUnfitTimer", function()
    local src = source
    local identifier = GetPlayerIdentifier(src)
    if not identifier then return end
    
    unfitPlayers[identifier] = nil
    TriggerClientEvent("rpr_unfit:resetUnfitTimer", src)
    
    if Config.UseDatabase and hasMySQL then
        ClearUnfitStatus(identifier)
    end
end)

RegisterNetEvent("rpr_unfit:getUnfitStatus")
AddEventHandler("rpr_unfit:getUnfitStatus", function()
    local src = source
    local identifier = GetPlayerIdentifier(src)
    
    if identifier and Config.UseDatabase and hasMySQL then
        LoadUnfitStatus(identifier, src)
    end
end)

RegisterNetEvent("rpr_unfit:saveUnfitStatus")
AddEventHandler("rpr_unfit:saveUnfitStatus", function(time)
    local src = source
    local identifier = GetPlayerIdentifier(src)
    
    if identifier and time then
        unfitPlayers[identifier] = time
        if Config.UseDatabase and hasMySQL then
            SaveUnfitStatus(identifier, time)
        end
    end
end)

RegisterNetEvent("rpr_unfit:updateUnfitTime")
AddEventHandler("rpr_unfit:updateUnfitTime", function(time)
    local src = source
    local identifier = GetPlayerIdentifier(src)
    
    if identifier and time then
        unfitPlayers[identifier] = time
        if Config.UseDatabase and hasMySQL then
            SaveUnfitStatus(identifier, time)
        end
    end
end)

RegisterNetEvent("rpr_unfit:clearUnfitStatus")
AddEventHandler("rpr_unfit:clearUnfitStatus", function()
    local src = source
    local identifier = GetPlayerIdentifier(src)
    
    if identifier then
        unfitPlayers[identifier] = nil
        if Config.UseDatabase and hasMySQL then
            ClearUnfitStatus(identifier)
        end
    end
end)

RegisterServerEvent("rpr_unfit:checkMedicPermission")
AddEventHandler("rpr_unfit:checkMedicPermission", function()
    local src = source
    
    if IsPlayerMedic(src) and Config.AllowMedicsToRevive then
        TriggerClientEvent("rpr_unfit:resetUnfitTimer", src)
        NotifyPlayer(src, Config.Lang["unfit_medic_remove"])
    else
        NotifyPlayer(src, Config.Lang["unfit_no_medic_permission"])
    end
end)

-- Add command to force unfit status on a player
RegisterServerEvent("rpr_unfit:forceUnfit")
AddEventHandler("rpr_unfit:forceUnfit", function(target, time)
    local src = source
    
    if not IsPlayerAdmin(src) then
        NotifyPlayer(src, Config.Lang["unfit_not_admin"])
        return
    end
    
    local targetId = target or src
    local targetIdentifier = GetPlayerIdentifier(targetId)
    
    if targetIdentifier then
        unfitPlayers[targetIdentifier] = time or Config.Time
        TriggerClientEvent("rpr_unfit:start", targetId, unfitPlayers[targetIdentifier])
        
        if Config.UseDatabase and hasMySQL then
            SaveUnfitStatus(targetIdentifier, unfitPlayers[targetIdentifier])
        end
        
        NotifyPlayer(src, string.format(Config.Lang["unfit_force"], targetId))
    else
        NotifyPlayer(src, Config.Lang["unfit_no_player_id"])
    end
end)

-- Check unfit status
RegisterServerEvent("rpr_unfit:checkStatus")
AddEventHandler("rpr_unfit:checkStatus", function(target)
    local src = source
    
    if target and not IsPlayerAdmin(src) then
        NotifyPlayer(src, Config.Lang["unfit_not_admin"])
        return
    end
    
    local targetId = target or src
    local targetIdentifier = GetPlayerIdentifier(targetId)
    
    if targetIdentifier then
        local isPlayerUnfit = unfitPlayers[targetIdentifier] ~= nil and unfitPlayers[targetIdentifier] > 0
        local timeRemaining = ""
        
        if isPlayerUnfit then
            timeRemaining = string.format(Config.Lang["unfit_status_time"], FormatTime(unfitPlayers[targetIdentifier]))
        end
        
        local statusText = string.format(Config.Lang["unfit_status"], targetId, 
            isPlayerUnfit and timeRemaining or Config.Lang["unfit_status_not"])
        
        NotifyPlayer(src, statusText)
    else
        NotifyPlayer(src, Config.Lang["unfit_no_player_id"])
    end
end)

-- Admin command to reset unfit status
RegisterCommand("resetunfit", function(source, args, rawCommand)
    if not IsPlayerAdmin(source) then
        NotifyPlayer(source, Config.Lang["unfit_not_admin"])
        return
    end
    
    local targetId = tonumber(args[1])
    if targetId then
        local targetIdentifier = GetPlayerIdentifier(targetId)
        
        if targetIdentifier then
            unfitPlayers[targetIdentifier] = nil
            if Config.UseDatabase and hasMySQL then
                ClearUnfitStatus(targetIdentifier)
            end
            TriggerClientEvent("rpr_unfit:adminCancelUnfit", targetId)
            NotifyPlayer(source, Config.Lang["unfit_removed_for1"] .. targetId .. Config.Lang["unfit_removed_for2"])
        else
            NotifyPlayer(source, Config.Lang["unfit_no_player_id"])
        end
    else
        NotifyPlayer(source, Config.Lang["unfit_no_player_id"])
    end
end, false)

-- Player disconnection handling
AddEventHandler('playerDropped', function(reason)
    local src = source
    local identifier = GetPlayerIdentifier(src)
    
    if identifier and unfitPlayers[identifier] and unfitPlayers[identifier] > 0 and Config.UseDatabase and hasMySQL then
        -- Save current state to database before player disconnects
        SaveUnfitStatus(identifier, unfitPlayers[identifier])
    end
end)