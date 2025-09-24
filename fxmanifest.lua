fx_version 'cerulean'
lua54 'yes'
game 'gta5'

author '141reaper (original by made040)'
description 'RPR Unfit System - Improved and Extended'
version '2.0.0'

shared_script 'config.lua'

client_scripts {
    'client/main.lua',
    'client/ui.lua',
    'client/events.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua', -- Optional, for database integration
    'server/main.lua',
    'server/utils.lua',
    'server/database.lua',
    'server/events.lua'
}

escrow_ignore {
    'config.lua',
    'client/*.lua',
    'server/*.lua'
}

dependencies {
    '/assetpacks',
    'oxmysql' -- Optional, for database integration
}

provide 'rpr_unfit'
