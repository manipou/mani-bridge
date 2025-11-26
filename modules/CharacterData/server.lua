function GetPlayer(src)
    if Config.Framework == 'esx' then
        return Core.GetPlayerFromId(src)
    elseif Config.Framework == 'qb' then
        return Core.Functions.GetPlayer(src)
    elseif Config.Framework == 'qbx' then
        return exports['qbx_core']:GetPlayer(src)
    else
        -- ADD CUSTOM FRAMEWORK SUPPORT HERE
    end
end

exports('GetPlayer', GetPlayer)

local function GetPlayerFromIdentifier(Identifier)
    if Config.Framework == 'esx' then
        return Core.GetPlayerFromIdentifier(Identifier)
    end
end

exports('GetPlayerFromIdentifier', GetPlayerFromIdentifier)

local function GetGender(src)
    local PlayerData = GetPlayer(src)
    if Config.Framework == 'esx' then
        return PlayerData.get("sex") or "Male"
    elseif Config.Framework == 'qb' or Config.Framework == 'qbx' then
        return PlayerData.PlayerData.charinfo.gender == 0 and 'Male' or 'Female'
    else
        -- ADD CUSTOM FRAMEWORK SUPPORT HERE
    end
end

exports('GetGender', GetGender)

lib.callback.register('mani-bridge:server:getGender', function(src)
    return GetGender(src)
end)

local function GetPlayerData(Source)
    if Config.Framework == 'esx' then
        local xPlayer = Core.GetPlayerFromId(Source)

        return {
            Source = Source,
            Character = {
                Firstname = xPlayer.variables.firstName,
                Lastname = xPlayer.variables.lastName,
                Fullname = xPlayer.variables.firstName .. ' ' .. xPlayer.variables.lastName,
                Gender = xPlayer.sex == 0 and 'male' or 'female',
            },
            Job = {
                Name = xPlayer.job.name,
                Label = xPlayer.job.label,
                Grade = xPlayer.job.grade,
                GradeLabel = xPlayer.job.grade_label,
                IsBoss = xPlayer.job.grade_name == 'boss'
            },
            Identifier = xPlayer.identifier
        }
    elseif Config.Framework == 'qb' or Config.Framework == 'qbx' then
        local Player = Core.Functions.GetPlayer(Source).PlayerData

        return {
            Source = Source,
            Character = {
                Firstname = Player.charinfo.firstname,
                Lastname = Player.charinfo.lastname,
                Fullname = Player.charinfo.firstname .. ' ' .. Player.charinfo.lastname,
                Gender = Player.charinfo.gender == 0 and 'male' or 'female',
            },
            Job = {
                Name = Player.job.name,
                Label = Player.job.label,
                Grade = Player.job.grade.level,
                GradeLabel = Player.job.grade.name,
                IsBoss = Player.job.isboss
            },
            Identifier = Player.citizenid
        }
    else
        -- ADD CUSTOM FRAMEWORK SUPPORT HERE
    end
end

exports('GetPlayerData', GetPlayerData)

if Config.Framework == 'esx' then
    AddEventHandler('esx:playerLoaded', function(Source)
        local PlayerData = GetPlayerData(Source)
        if not PlayerData then return end

        TriggerServerEvent('mani-bridge:server:PlayerLoaded', PlayerData)
        TriggerClientEvent('mani-bridge:client:PlayerLoaded', Source, PlayerData)
    end)
elseif Config.Framework == 'qb' or Config.Framework == 'qbx' then
    RegisterNetEvent('QBCore:Server:OnPlayerLoaded', function()
        local Source = source
        local PlayerData = GetPlayerData(Source)
        if not PlayerData then return end

        TriggerServerEvent('mani-bridge:server:PlayerLoaded', PlayerData)
        TriggerClientEvent('mani-bridge:client:PlayerLoaded', Source, PlayerData)
    end)
end