ESX = exports["es_extended"]:getSharedObject()
local unfitPlayers = {}

RegisterNetEvent("rpr_unfit:trigger")
AddEventHandler("rpr_unfit:trigger", function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end
    local identifier = xPlayer.getIdentifier()

    if not unfitPlayers[identifier] then
        unfitPlayers[identifier] = Config.Time
    else
        unfitPlayers[identifier] = unfitPlayers[identifier] + Config.Time
    end

    TriggerClientEvent("rpr_unfit:start", src, unfitPlayers[identifier])
end)

RegisterNetEvent("rpr_unfit:resetUnfitTimer")
AddEventHandler("rpr_unfit:resetUnfitTimer", function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end
    local identifier = xPlayer.getIdentifier()
    unfitPlayers[identifier] = nil
    TriggerClientEvent("rpr_unfit:resetUnfitTimer", src)
end)

RegisterCommand("resetunfit", function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() == Config.AdminGroup then
        local targetId = tonumber(args[1])
        if targetId then
            TriggerClientEvent("rpr_unfit:adminCancelUnfit", targetId)
            TriggerClientEvent('esx:showNotification', source, Config.Lang["unfit_removed_for1"] .. targetId .. Config.Lang["unfit_removed_for2"])
        else
            TriggerClientEvent('esx:showNotification', source, Config.Lang["unfit_no_player_id"])
        end
    else
        TriggerClientEvent('esx:showNotification', source, Config.Lang["unfit_not_admin"])
    end
end, false)

RegisterServerEvent("rpr_unfit:checkMedicPermission")
AddEventHandler("rpr_unfit:checkMedicPermission", function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if xPlayer.job.name == Config.AmbulanceJob then
        TriggerClientEvent("rpr_unfit:resetUnfitTimer", src)
        TriggerClientEvent('esx:showNotification', src, Config.Lang["unfit_medic_remove"])
    else
        TriggerClientEvent('esx:showNotification', src, Config.Lang["unfit_no_medic_permission"])
    end
end)

