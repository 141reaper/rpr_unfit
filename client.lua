ESX = exports["es_extended"]:getSharedObject()
local isUnfit = false
local unfitTime = 0
local displayMinutes = 0
local displaySeconds = 0
local hudHidden = false

RegisterNetEvent(Config.ReviveTrigger)
AddEventHandler(Config.ReviveTrigger, function()
    if not isUnfit then
        StartUnfitState()
    else
        unfitTime = unfitTime + Config.Time
        ESX.ShowNotification(Config.Lang["unfit_extended"])
    end
end)

RegisterNetEvent("rpr_unfit:trigger")
AddEventHandler("rpr_unfit:trigger", function(startTime)
    if not isUnfit then
        StartUnfitState(startTime)
    else
        unfitTime = unfitTime + Config.Time
        ESX.ShowNotification(Config.Lang["unfit_extended"])
    end
end)

RegisterNetEvent("rpr_unfit:resetUnfitMedic")
AddEventHandler("rpr_unfit:resetUnfitMedic", function()
    TriggerServerEvent("rpr_unfit:checkMedicPermission")
end)

RegisterNetEvent("rpr_unfit:resetUnfitTimer")
AddEventHandler("rpr_unfit:resetUnfitTimer", function()
    if isUnfit then
        isUnfit = false
        unfitTime = 0
        EnableAllControlActions(0)
        ESX.ShowNotification(Config.Lang["unfit_reset"])
    end
end)

RegisterNetEvent("rpr_unfit:adminCancelUnfit")
AddEventHandler("rpr_unfit:adminCancelUnfit", function()
    if isUnfit then
        isUnfit = false
        unfitTime = 0
        EnableAllControlActions(0)
        ESX.ShowNotification(Config.Lang["unfit_admin_cancel"])
    end
end)

function StartUnfitState(startTime)
    isUnfit = true
    unfitTime = startTime or Config.Time
    hudHidden = false

    Citizen.CreateThread(function()
        while isUnfit do
            Citizen.Wait(1000)
            if unfitTime > 0 then
                unfitTime = unfitTime - 1
                displayMinutes = math.floor(unfitTime / 60)
                displaySeconds = unfitTime % 60
                if unfitTime <= 0 then
                    isUnfit = false
                    EnableAllControlActions(0)
                    ESX.ShowNotification(Config.Lang["unfit_expired"])
                end
            end
        end
    end)

    Citizen.CreateThread(function()
        while isUnfit do
            Citizen.Wait(0)
            local ped = PlayerPedId()
            DisablePlayerFiring(ped, true)
            HudWeaponWheelIgnoreSelection()
            DisableControlAction(0, 24, true)
            DisableControlAction(0, 25, true)
            DisableControlAction(0, 47, true)
            DisableControlAction(0, 58, true)
            DisableControlAction(0, 263, true)
            DisableControlAction(0, 264, true)
            DisableControlAction(0, 257, true)
            DisableControlAction(0, 140, true)
            DisableControlAction(0, 141, true)
            DisableControlAction(0, 142, true)
            DisableControlAction(0, 143, true)
            if IsPedInAnyVehicle(ped, false) then
                DisableControlAction(0, 69, true)
                DisableControlAction(0, 70, true)
                DisableControlAction(0, 92, true)
                DisableControlAction(0, 114, true)
                DisableControlAction(0, 331, true)
                -- Driveby
                DisableControlAction(0, 25, true)
                DisableControlAction(0, 68, true)
                DisableControlAction(0, 91, true)
                DisableControlAction(0, 347, true)
            end
        end
    end)
end


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if isUnfit and not hudHidden then
            DrawUnfitText()
        end
    end
end)

RegisterCommand("unfithud", function()
    if isUnfit then
        hudHidden = not hudHidden
        if not hudHidden then
            ESX.ShowNotification(Config.Lang["unfit_hide_notify_visible"])
        else
            ESX.ShowNotification(Config.Lang["unfit_hide_notify_hidden"])
        end
    end
end, false)

RegisterKeyMapping('unfithud', 'Kampfunfähigkeits-HUD ein-/ausblenden', 'keyboard', 'n')

function FormatUnfitTime(totalSeconds)
    if totalSeconds >= 3600 then
        local hours = math.floor(totalSeconds / 3600)
        local minutes = math.floor((totalSeconds % 3600) / 60)
        local seconds = totalSeconds % 60
        return string.format("%02d:%02d:%02d", hours, minutes, seconds)
    else
        local minutes = math.floor(totalSeconds / 60)
        local seconds = totalSeconds % 60
        return string.format("%02d:%02d", minutes, seconds)
    end
end

function DrawUnfitText()
    local timeString = FormatUnfitTime(unfitTime)
    SetTextFont(4)
    SetTextScale(0.5, 0.5)
    SetTextColour(255, 255, 255, 255)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextCentre(true)
    SetTextEntry("STRING")
    AddTextComponentString(Config.Lang["unfit_for"] .. timeString)
    DrawText(0.5, 0.80)
    SetTextFont(4)
    SetTextScale(0.4, 0.4)
    SetTextColour(255, 255, 255, 200)
    SetTextCentre(true)
    SetTextEntry("STRING")
    AddTextComponentString(Config.Lang["unfit_hide_text"])
    DrawText(0.5, 0.83)
end