fx_version 'cerulean'
game 'gta5'

author 'AUTH'
version '1.0.0'

lua54'yes'

ox_lib 'locale'

dependency 'ox_lib'

shared_scripts {
    '@ox_lib/init.lua'
}


shared_script {
    'config.lua'
}

client_scripts {
    'client.lua'
}

server_scripts {
    'server.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js'
} 