local Framework = nil

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

local function GetPlayer(source)
    if not Framework then return nil end
    
    if Framework == "esx" then
        return ESX.GetPlayerFromId(source)
    elseif Framework == "qbcore" then
        return QBCore.Functions.GetPlayer(source)
    elseif Framework == "qbox" then
        return QBox.GetPlayer(source)
    end
end

RegisterNetEvent('auth-jobcenter:server:getJobs')
AddEventHandler('auth-jobcenter:server:getJobs', function()
    local src = source
    TriggerClientEvent('auth-jobcenter:client:receiveJobs', src, Config.Jobs)
end)

RegisterNetEvent('auth-jobcenter:server:changeJob')
AddEventHandler('auth-jobcenter:server:changeJob', function(jobName)
    local src = source
    local Player = GetPlayer(src)
    
    if not Player then return end
    
    local job = nil
    for _, v in pairs(Config.Jobs) do
        if v.name == jobName then
            job = v
            break
        end
    end
    
    if not job then return end
    
    if Framework == "esx" then
        Player.setJob(job.name, 0)
    elseif Framework == "qbcore" then
        Player.Functions.SetJob(job.name, 0)
    elseif Framework == "qbox" then
        Player.Functions.SetJob(job.name, 0)
    end
    
    TriggerClientEvent('QBCore:Notify', src, 'Job changed successfully!', 'success')
end)

RegisterNetEvent('auth-jobcenter:server:getPlayerInfo')
AddEventHandler('auth-jobcenter:server:getPlayerInfo', function()
    local src = source
    local Player = GetPlayer(src)
    
    if not Player then return end
    
    local playerInfo = {
        name = "",
        money = 0,
        job = "",
        jobGrade = ""
    }
    
    if Framework == "esx" then
        playerInfo.name = Player.getName()
        playerInfo.money = Player.getMoney()
        playerInfo.job = Player.job.label
        playerInfo.jobGrade = Player.job.grade_label
    elseif Framework == "qbcore" then
        playerInfo.name = Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname
        playerInfo.money = Player.PlayerData.money['cash']
        playerInfo.job = Player.PlayerData.job.label
        playerInfo.jobGrade = Player.PlayerData.job.grade.name
    elseif Framework == "qbox" then
        playerInfo.name = Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname
        playerInfo.money = Player.PlayerData.money['cash']
        playerInfo.job = Player.PlayerData.job.label
        playerInfo.jobGrade = Player.PlayerData.job.grade.name
    end
    
    TriggerClientEvent('auth-jobcenter:client:receivePlayerInfo', src, playerInfo)
end) 