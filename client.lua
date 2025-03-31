local Framework = nil
local npcPed = nil

Citizen.CreateThread(function()
    if Config.Framework == "auto" then
        if GetResourceState('es_extended') == 'started' then
            Framework = "esx"
            ESX = exports['es_extended']:getSharedObject()
        elseif GetResourceState('qb-core') == 'started' then
            Framework = "qbcore"
            QBCore = exports['qb-core']:GetCoreObject()
        elseif GetResourceState('qbx_core') == 'started' then
            Framework = "qbox"
            QBox = exports['qbx_core']:GetCoreObject()
        end
    else
        Framework = Config.Framework
        if Framework == "esx" then
            ESX = exports['es_extended']:getSharedObject()
        elseif Framework == "qbcore" then
            QBCore = exports['qb-core']:GetCoreObject()
        elseif Framework == "qbox" then
            QBox = exports['qbx_core']:GetCoreObject()
        end
    end
end)

local isMenuOpen = false

Citizen.CreateThread(function()
    local blip = AddBlipForCoord(-269.0, -955.0, 31.0)
    SetBlipSprite(blip, 498)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.7)
    SetBlipColour(blip, 3)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Job Center")
    EndTextCommandSetBlipName(blip)
end)

function CreateNPC()
    if Config.TargetSystem == "marker" then return end

    RequestModel(GetHashKey(Config.NPC.model))
    while not HasModelLoaded(GetHashKey(Config.NPC.model)) do
        Wait(1)
    end

    npcPed = CreatePed(4, GetHashKey(Config.NPC.model), Config.NPC.coords.x, Config.NPC.coords.y,
        Config.NPC.coords.z - 1.0, Config.NPC.coords.w, false, true)
    SetEntityHeading(npcPed, Config.NPC.coords.w)
    FreezeEntityPosition(npcPed, true)
    SetEntityInvincible(npcPed, true)
    SetBlockingOfNonTemporaryEvents(npcPed, true)
    ClearPedTasks(npcPed)
    ClearPedSecondaryTask(npcPed)
    if Config.NPC.scenario then
        TaskStartScenarioInPlace(npcPed, Config.NPC.scenario, 0, true)
    end

    if Config.TargetSystem == "ox_target" then
        exports.ox_target:addLocalEntity(npcPed, {
            {
                name = 'job_center',
                icon = 'fas fa-briefcase',
                label = 'Open Job Center',
                onSelect = function()
                    OpenJobCenter()
                end
            }
        })
    elseif Config.TargetSystem == "qb_target" then
        exports['qb-target']:AddTargetEntity(npcPed, {
            options = {
                {
                    type = "client",
                    event = "auth-jobcenter:client:openMenu",
                    icon = "fas fa-briefcase",
                    label = "Open Job Center",
                }
            },
            distance = 2.5
        })
    end
end

Citizen.CreateThread(function()
    if Config.TargetSystem ~= "marker" then return end
    local sleep = 1000
    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        local distance = #(coords - vector3(-264.1702, -965.3143, 31.2238))

        if distance < 6.0 then
            DrawMarker(20, -264.1702, -965.3143, 31.2238, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 0, 150, 255, 100,
                false, true, 2, false, nil, nil, false)

            if distance < 1.5 then
                if not isMenuOpen then
                    if IsControlJustPressed(0, 38) then
                        OpenJobCenter()
                    end
                end
            end
        else
            sleep = 300
            Wait(sleep)
        end
    end
    Wait(sleep)
end)

RegisterNetEvent('auth-jobcenter:client:openMenu')
AddEventHandler('auth-jobcenter:client:openMenu', function()
    OpenJobCenter()
end)

function OpenJobCenter()
    isMenuOpen = true
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "openMenu"
    })
    TriggerServerEvent('auth-jobcenter:server:getPlayerInfo')
    TriggerServerEvent('auth-jobcenter:server:getJobs')
end

RegisterNUICallback('closeMenu', function(data, cb)
    isMenuOpen = false
    SetNuiFocus(false, false)
    cb('ok')
end)

RegisterNUICallback('selectJob', function(data, cb)
    TriggerServerEvent('auth-jobcenter:server:changeJob', data.jobName)
    cb('ok')
end)

RegisterNetEvent('auth-jobcenter:client:receivePlayerInfo')
AddEventHandler('auth-jobcenter:client:receivePlayerInfo', function(playerInfo)
    SendNUIMessage({
        action = "updatePlayerInfo",
        playerInfo = playerInfo
    })
end)

RegisterNetEvent('auth-jobcenter:client:receiveJobs')
AddEventHandler('auth-jobcenter:client:receiveJobs', function(jobs)
    SendNUIMessage({
        action = "updateJobs",
        jobs = jobs
    })
end)

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then return end
    CreateNPC()
end)

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then return end
    if npcPed then
        DeleteEntity(npcPed)
    end
end)
