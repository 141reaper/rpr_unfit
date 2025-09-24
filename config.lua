Config = {}

-- Core Settings
Config.Framework = 'esx' -- Options: 'esx', 'qb'
Config.UseDatabase = true -- Save unfit state to database for persistence after server restart
Config.ReviveTrigger = "esx_ambulancejob:revive" -- Place your revive trigger here
Config.QBReviveTrigger = "hospital:client:Revive" -- QBCore revive trigger
Config.Time = 600 -- How long should the player be disabled? (in seconds)
Config.ExtendTime = 600 -- Time added when unfit is extended (in seconds)
Config.AdminGroups = {"admin", "superadmin", "mod"} -- Groups that can reset a player
Config.AmbulanceJob = "ambulance" -- Name of your esx ambulance job
Config.QBAmbulanceJob = "ambulance" -- Name of your qbcore ambulance job

-- Display Settings
Config.UseModernHUD = false -- Use the new styled HUD
Config.HUDPosition = {x = 0.5, y = 0.80} -- HUD position on screen
Config.HUDScale = {x = 0.5, y = 0.5} -- HUD text scale
Config.HUDColor = {r = 255, g = 255, b = 255, a = 255} -- HUD text color
Config.ShowHUDBackground = false -- Show a background behind the HUD text
Config.BackgroundColor = {r = 0, g = 0, b = 0, a = 150} -- HUD background color
Config.UseNotifications = true -- Use on-screen notifications
Config.NotificationType = 'esx' -- Options: 'esx', 'qb', 'custom', 'okok', 'mythic'

-- Feature Settings
Config.DisableVehicleExit = false -- Prevent player from exiting vehicle when unfit
Config.DisableVehicleControls = false -- Disable vehicle controls when unfit
Config.AllowMedicsToRevive = true -- Allow medics to revive unfit players
Config.MedicReviveCooldown = 300 -- Cooldown for medic revives (in seconds)
Config.EnablePersistence = true -- Save unfit status between server restarts
Config.DebugMode = false -- Enable debug mode

-- Integration Hooks
Config.UseEventHooks = true -- Enable hooks for other scripts to interact with unfit
Config.TriggerCommands = { -- Commands that can trigger unfit state
    -- Leere Liste, da Kampfunfähigkeit nur durch den Revive-Trigger ausgelöst werden soll
}

-- Advanced Settings
Config.DisabledControls = { -- Control IDs to disable when unfit
    24, 25, 47, 58, 263, 264, 257, 140, 141, 142, 143, 
    69, 70, 92, 114, 331, 68, 91, 347
}

Config.Lang = {
    -- Client
    ["unfit_for"] = "Du bist Kampfunfähig für ",
    ["unfit_extended"] = "Deine Kampfunfähigkeit wurde verlängert!",
    ["unfit_reset"] = "Kampfunfähigkeit aufgehoben",
    ["unfit_admin_cancel"] = "Deine Kampfunfähigkeit wurde durch einen Admin beendet",
    ["unfit_hide_text"] = "Drücke ~b~N~w~ oder nutze /unfithud um die Anzeige zu verstecken",
    ["unfit_hide_notify_visible"] = "Unfit-HUD eingeblendet",
    ["unfit_hide_notify_hidden"] = "Unfit-HUD ausgeblendet",
    ["unfit_expired"] = "Du bist nicht mehr kampfunfähig",
    ["unfit_saved"] = "Dein Kampfunfähigkeitsstatus wurde gespeichert",
    ["unfit_restored"] = "Dein vorheriger Kampfunfähigkeitsstatus wurde wiederhergestellt",
    ["unfit_cooldown"] = "Du musst noch %s Sekunden warten, bevor du diese Aktion ausführen kannst",
    ["unfit_time_set"] = "Deine Kampfunfähigkeit wurde auf %s Sekunden gesetzt",
    ["unfit_invalid_time"] = "Ungültige Zeitangabe",
    ["unfit_invalid_id"] = "Ungültige Spieler-ID",
    ["unfit_not_unfit"] = "Dieser Spieler ist nicht kampfunfähig",
    ["unfit_already_unfit"] = "Du bist bereits kampfunfähig",

    -- Server
    ["unfit_removed_for1"] = "Du hast den Kampfunfähigkeitsstatus für Spieler ",
    ["unfit_removed_for2"] = " zurückgesetzt.",
    ["unfit_not_admin"] = "Du hast nicht die Berechtigung diesen Befehl zu benutzen.",
    ["unfit_no_player_id"] = "Du musst eine Spieler-ID angeben.",
    ["unfit_no_medic_permission"] = "Du bist kein Sanitäter und kannst diese Funktion nicht nutzen.",
    ["unfit_medic_remove"] = "Du hast die Kampfunfähigkeit eines Spielers beendet",
    ["unfit_force"] = "Kampfunfähigkeit wurde für Spieler %s aktiviert",
    ["unfit_remove_success"] = "Kampfunfähigkeit für Spieler %s wurde aufgehoben",
    ["unfit_status"] = "Spieler %s ist%s kampfunfähig",
    ["unfit_status_time"] = " für noch %s",
    ["unfit_status_not"] = " nicht",
    ["unfit_db_error"] = "Fehler beim Speichern des Kampfunfähigkeitsstatus in der Datenbank"
}