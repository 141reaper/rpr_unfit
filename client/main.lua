-- RPR Unfit - Client Main File
-- Framework Detection and Initialization
ESX, QBCore = nil, nil
isUnfit = false
unfitTime = 0
displayTime = "00:00"
hudHidden = false
lastReviveTime = 0

-- Framework Detection and Initialization
CreateThread(function()
    if Config.Framework == 'esx' then
        ESX = exports["es_extended"]:getSharedObject()
    elseif Config.Framework == 'qb' then
        QBCore = exports['qb-core']:GetCoreObject()
    end
    Wait(1000)
    TriggerServerEvent('rpr_unfit:getUnfitStatus')
end)

-- Notification System
function ShowNotification(message)
    if not Config.UseNotifications then return end

    if Config.NotificationType == 'esx' and ESX then
        ESX.ShowNotification(message)
    elseif Config.NotificationType == 'qb' and QBCore then
        QBCore.Functions.Notify(message)
    elseif Config.NotificationType == 'okok' then
        exports['okokNotify']:Alert("Unfit", message, 5000, 'info')
    elseif Config.NotificationType == 'mythic' then
        exports['mythic_notify']:SendAlert('inform', message)
    elseif Config.NotificationType == 'custom' then
        -- Add your custom notification system here
        SetNotificationTextEntry('STRING')
        AddTextComponentString(message)
        DrawNotification(false, true)
    else
        -- Fallback to native notifications
        SetNotificationTextEntry('STRING')
        AddTextComponentString(message)
        DrawNotification(false, true)
    end
end

-- Main functions
function TriggerUnfitState(startTime)
    if not isUnfit then
        StartUnfitState(startTime or Config.Time)
    else
        unfitTime = unfitTime + (Config.ExtendTime or Config.Time)
        ShowNotification(Config.Lang["unfit_extended"])
        TriggerServerEvent('rpr_unfit:updateUnfitTime', unfitTime)
    end
end

function CancelUnfitState(message)
    isUnfit = false
    unfitTime = 0
    EnableAllControlActions(0)
    if message then
        ShowNotification(message)
    end
    
    if Config.UseDatabase then
        TriggerServerEvent('rpr_unfit:clearUnfitStatus')
    end
end

function StartUnfitState(startTime)
    isUnfit = true
    unfitTime = startTime or Config.Time
    hudHidden = false
    
    if Config.UseDatabase then
        TriggerServerEvent('rpr_unfit:saveUnfitStatus', unfitTime)
    end
    
    -- Timer thread
    CreateThread(function()
        while isUnfit do
            Wait(1000)
            if unfitTime > 0 then
                unfitTime = unfitTime - 1
                displayTime = FormatUnfitTime(unfitTime)
                
                -- Update server every 30 seconds if using database
                if Config.UseDatabase and unfitTime % 30 == 0 then
                    TriggerServerEvent('rpr_unfit:updateUnfitTime', unfitTime)
                end
                
                if unfitTime <= 0 then
                    CancelUnfitState(Config.Lang["unfit_expired"])
                end
            end
        end
    end)
    
    -- Control disabling thread
    CreateThread(function()
        while isUnfit do
            Wait(0)
            local ped = PlayerPedId()
            DisablePlayerFiring(ped, true)
            HudWeaponWheelIgnoreSelection()
            
            -- Disable configured controls
            for _, control in ipairs(Config.DisabledControls) do
                DisableControlAction(0, control, true)
            end
            
            -- Vehicle specific controls
            if IsPedInAnyVehicle(ped, false) and Config.DisableVehicleControls then
                DisableControlAction(0, 69, true) -- INPUT_VEH_ATTACK
                DisableControlAction(0, 70, true) -- INPUT_VEH_ATTACK2
                DisableControlAction(0, 92, true) -- INPUT_VEH_PASSENGER_ATTACK
                DisableControlAction(0, 114, true) -- INPUT_VEH_FLY_ATTACK
                DisableControlAction(0, 331, true) -- INPUT_VEH_ACCELERATE
                
                -- Prevent vehicle exit if configured
                if Config.DisableVehicleExit then
                    DisableControlAction(0, 23, true) -- INPUT_ENTER
                    DisableControlAction(0, 75, true) -- INPUT_VEH_EXIT
                end
            end
        end
    end)
    
    -- Start HUD thread
    if Config.UseModernHUD then
        CreateThread(function()
            while isUnfit do
                Wait(0)
                if not hudHidden then
                    DrawModernUnfitHUD()
                end
            end
        end)
    else
        CreateThread(function()
            while isUnfit do
                Wait(0)
                if not hudHidden then
                    DrawLegacyUnfitText()
                end
            end
        end)
    end
end

-- Utility Functions
function FormatUnfitTime(totalSeconds)
    -- Konstanten für die Zeitumrechnung
    local SECONDS_PER_MINUTE = 60
    local SECONDS_PER_HOUR = 3600
    local SECONDS_PER_DAY = 86400
    
    -- Berechnung der Tage, Stunden, Minuten und Sekunden
    local days = math.floor(totalSeconds / SECONDS_PER_DAY)
    local hours = math.floor((totalSeconds % SECONDS_PER_DAY) / SECONDS_PER_HOUR)
    local minutes = math.floor((totalSeconds % SECONDS_PER_HOUR) / SECONDS_PER_MINUTE)
    local seconds = totalSeconds % SECONDS_PER_MINUTE
    
    -- Format je nach Größe anpassen
    if days > 0 then
        -- Format mit Tagen
        return string.format("%dd %02dh %02dm %02ds", days, hours, minutes, seconds)
    elseif hours > 0 then
        -- Format mit Stunden
        return string.format("%02dh %02dm %02ds", hours, minutes, seconds)
    else
        -- Format nur mit Minuten und Sekunden
        return string.format("%02dm %02ds", minutes, seconds)
    end
end

-- Debug Function
function DebugLog(message)
    if Config.DebugMode then
        print("[RPR-UNFIT] " .. message)
    end
end