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

local function GetPlayerData(src)
    if Config.Framework == 'esx' then
        local xPlayer = Core.GetPlayerFromId(src)

        return {
            Character = {
                Firstname = xPlayer.variables.firstName,
                Lastname = xPlayer.variables.lastName,
                Fullname = xPlayer.variables.firstName .. ' ' .. xPlayer.variables.lastName,
                Gender = xPlayer.sex == 0 and 'male' or 'female',
            },
            Job = {
                name = xPlayer.job.name,
                label = xPlayer.job.label,
                grade = xPlayer.job.grade,
                gradeLabel = xPlayer.job.grade_label,
                isBoss = xPlayer.job.grade_name == 'boss'
            },
            Identifier = xPlayer.identifier
        }
    elseif Config.Framework == 'qb' or Config.Framework == 'qbx' then
        local Player = Core.Functions.GetPlayer(src).PlayerData

        return {
            Character = {
                Firstname = Player.charinfo.firstname,
                Lastname = Player.charinfo.lastname,
                Fullname = Player.charinfo.firstname .. ' ' .. Player.charinfo.lastname,
                Gender = Player.charinfo.gender == 0 and 'male' or 'female',
            },
            Job = {
                name = Player.job.name,
                label = Player.job.label,
                grade = Player.job.grade.level,
                gradeLabel = Player.job.grade.name,
                isBoss = Player.job.isboss
            },
            Identifier = Player.citizenid
        }
    else
        -- ADD CUSTOM FRAMEWORK SUPPORT HERE
    end
end

exports('GetPlayerData', GetPlayerData)