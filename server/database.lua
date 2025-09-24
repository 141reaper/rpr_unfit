-- RPR Unfit - Server DB Functions
-- Save unfit status to database
function SaveUnfitStatus(identifier, time)
    if not Config.UseDatabase or not identifier or not hasMySQL then return end

    exports['oxmysql']:execute('INSERT INTO rpr_unfit_status (identifier, unfit_time) VALUES (?, ?) ON DUPLICATE KEY UPDATE unfit_time = ?, timestamp = CURRENT_TIMESTAMP', 
        {identifier, time, time}, function(rowsChanged)
        if rowsChanged == 0 then
            print('[RPR-UNFIT] Error saving unfit status for ' .. identifier)
        end
    end)
end

-- Load unfit status from database
function LoadUnfitStatus(identifier, source)
    if not Config.UseDatabase or not identifier or not hasMySQL then return end

    exports['oxmysql']:scalar('SELECT unfit_time FROM rpr_unfit_status WHERE identifier = ?', {identifier}, 
        function(time)
        if time and time > 0 then
            -- Calculate time passed since last update
            exports['oxmysql']:scalar('SELECT TIMESTAMPDIFF(SECOND, timestamp, NOW()) FROM rpr_unfit_status WHERE identifier = ?', 
                {identifier}, function(secondsPassed)
                local adjustedTime = time - (secondsPassed or 0)
                if adjustedTime > 0 then
                    unfitPlayers[identifier] = adjustedTime
                    TriggerClientEvent('rpr_unfit:restoreUnfitState', source, adjustedTime)
                else
                    -- Clear expired status
                    ClearUnfitStatus(identifier)
                end
            end)
        end
    end)
end

-- Clear unfit status from database
function ClearUnfitStatus(identifier)
    if not Config.UseDatabase or not identifier or not hasMySQL then return end

    exports['oxmysql']:execute('DELETE FROM rpr_unfit_status WHERE identifier = ?', {identifier})
    unfitPlayers[identifier] = nil
end