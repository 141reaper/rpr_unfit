Config = {}

Config.ReviveTrigger = "esx_ambulancejob:revive" -- place your revive trigger here
Config.Time = 600 -- how long should the player be disabled? (in seconds)
Config.AdminGroup = "admin" -- the group with which you can reset a player (example: mod, admin, superadmin, ...)
Config.AmbulanceJob = "ambulance" -- name of your esx ambulance job 



Config.Lang = {
    -- Client
    ["unfit_for"] = "Du bist Kampfunfähig für ",
    ["unfit_extended"] = "Deine Kampfunfähigkeit wurde um 10 Minuten verlängert!",
    ["unfit_reset"] = "Kampfunfähigkeit aufgehoben",
    ["unfit_admin_cancel"] = "Deine Kampfunfähigkeit wurde durch einen Admin beendet",
    ["unfit_hide_text"] = "Drücke ~b~N~w~ oder nutze /unfithud um die Anzeige zu verstecken",
    ["unfit_hide_notify_visible"] = "Unfit-HUD eingeblendet",
    ["unfit_hide_notify_hidden"] = "Unfit-HUD ausgeblendet",
    ["unfit_expired"] = "Du bist nicht mehr kampunfähig",

    -- Server
    ["unfit_removed_for1"] = "Du hast den Kampfunfähigkeitsstatus für Spieler ",
    ["unfit_removed_for2"] = " zurückgesetzt.",
    ["unfit_not_admin"] = "Du hast nicht die Berechtigung diesen Befehl zu benutzen.",
    ["unfit_no_player_id"] = "Du musst eine Spieler-ID angeben.",
    ["unfit_no_medic_permission"] = "Du bist kein Sanitäter und kannst diese Funktion nicht nutzen.",
    ["unfit_medic_remove"] = "Du hast die Kampfunfähigkeit eines Spielers beendet"
}