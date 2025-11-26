function GetGender() -- Depricated, idk why i made this.
    return lib.callback.await('mani-bridge:server:getGender', false)
end

exports('GetGender', GetGender)

local function GetPlayerData()
    if Config.Framework == 'esx' then
        local xPlayer = Core.GetPlayerData()

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
        local Player = Core.Functions.GetPlayerData()
    
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
