-- RPR Unfit - Client Events
-- Register ESX Revive Event
RegisterNetEvent(Config.ReviveTrigger)
AddEventHandler(Config.ReviveTrigger, function()
    TriggerUnfitState()
end)

-- Core Unfit Events
RegisterNetEvent("rpr_unfit:trigger")
AddEventHandler("rpr_unfit:trigger", function(startTime)
    TriggerUnfitState(startTime)
end)

RegisterNetEvent("rpr_unfit:start")
AddEventHandler("rpr_unfit:start", function(time)
    if not isUnfit then
        StartUnfitState(time)
    else
        unfitTime = time
        ShowNotification(Config.Lang["unfit_extended"])
    end
end)

RegisterNetEvent("rpr_unfit:resetUnfitMedic")
AddEventHandler("rpr_unfit:resetUnfitMedic", function()
    local currentTime = GetGameTimer()
    if (currentTime - lastReviveTime) / 1000 < Config.MedicReviveCooldown then
        local remainingTime = math.ceil(Config.MedicReviveCooldown - (currentTime - lastReviveTime) / 1000)
        ShowNotification(string.format(Config.Lang["unfit_cooldown"], remainingTime))
        return
    end
    
    lastReviveTime = currentTime
    TriggerServerEvent("rpr_unfit:checkMedicPermission")
end)

RegisterNetEvent("rpr_unfit:resetUnfitTimer")
AddEventHandler("rpr_unfit:resetUnfitTimer", function()
    if isUnfit then
        CancelUnfitState(Config.Lang["unfit_reset"])
    end
end)

RegisterNetEvent("rpr_unfit:adminCancelUnfit")
AddEventHandler("rpr_unfit:adminCancelUnfit", function()
    if isUnfit then
        CancelUnfitState(Config.Lang["unfit_admin_cancel"])
    end
end)

RegisterNetEvent("rpr_unfit:restoreUnfitState")
AddEventHandler("rpr_unfit:restoreUnfitState", function(timeRemaining)
    if timeRemaining and timeRemaining > 0 then
        StartUnfitState(timeRemaining)
        ShowNotification(Config.Lang["unfit_restored"])
    end
end)

-- Commands
RegisterCommand("unfithud", function()
    if isUnfit then
        hudHidden = not hudHidden
        if not hudHidden then
            ShowNotification(Config.Lang["unfit_hide_notify_visible"])
        else
            ShowNotification(Config.Lang["unfit_hide_notify_hidden"])
        end
    end
end, false)

-- Add command to check unfit status
RegisterCommand("unfitcheck", function(source, args)
    local targetId = args[1]
    if targetId then
        TriggerServerEvent("rpr_unfit:checkStatus", tonumber(targetId))
    else
        TriggerServerEvent("rpr_unfit:checkStatus")
    end
end, false)

-- Add command to force unfit status on a player
RegisterCommand("forceunfit", function(source, args)
    local targetId = args[1]
    local time = args[2] and tonumber(args[2]) or Config.Time
    
    if targetId then
        TriggerServerEvent("rpr_unfit:forceUnfit", tonumber(targetId), time)
    else
        TriggerServerEvent("rpr_unfit:forceUnfit", nil, time)
    end
end, false)

-- Key Mapping
RegisterKeyMapping('unfithud', 'Kampfunfähigkeits-HUD ein-/ausblenden', 'keyboard', 'n')

-- Integration with trigger commands
if Config.UseEventHooks then
    for _, cmd in pairs(Config.TriggerCommands) do
        local cleanCmd = cmd:gsub("/", "")
        RegisterCommand(cleanCmd, function()
            TriggerServerEvent("rpr_unfit:trigger")
        end, false)
    end
end