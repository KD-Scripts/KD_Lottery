fx_version 'adamant'
game 'gta5'
lua54 'yes'

author 'Kokkachi Damu#5646'

client_script {
    'client.lua'
}

server_scripts {
    'server.lua',
    'server_edit.lua'
}

shared_script {
    '@ox_lib/init.lua',
    'config.lua'
}

dependencies {
    'es_extended',
    'ox_lib'
}

escrow_ignore {
    'config.lua',
    'server_edit.lua'
}