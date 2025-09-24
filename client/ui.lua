-- RPR Unfit - Client UI Functions
function DrawModernUnfitHUD()
    local posX, posY = Config.HUDPosition.x, Config.HUDPosition.y
    local scaleX, scaleY = Config.HUDScale.x, Config.HUDScale.y
    local color = Config.HUDColor
    
    if Config.ShowHUDBackground then
        -- Draw background box
        local bgColor = Config.BackgroundColor
        DrawRect(posX, posY, 0.16, 0.07, bgColor.r, bgColor.g, bgColor.b, bgColor.a)
    end
    
    -- Main unfit text
    SetTextFont(4)
    SetTextScale(scaleX, scaleY)
    SetTextColour(color.r, color.g, color.b, color.a)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextCentre(true)
    SetTextEntry("STRING")
    AddTextComponentString(Config.Lang["unfit_for"] .. displayTime)
    DrawText(posX, posY - 0.015)
    
    -- Instructions text
    SetTextFont(4)
    SetTextScale(scaleX - 0.1, scaleY - 0.1)
    SetTextColour(color.r, color.g, color.b, 200)
    SetTextCentre(true)
    SetTextEntry("STRING")
    AddTextComponentString(Config.Lang["unfit_hide_text"])
    DrawText(posX, posY + 0.015)
end

function DrawLegacyUnfitText()
    local timeString = displayTime
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