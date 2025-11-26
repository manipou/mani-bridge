function GetGender() -- Depricated, idk why i made this.
    return lib.callback.await('mani-bridge:server:getGender', false)
end

exports('GetGender', GetGender)

local function GetPlayerData()
    if Config.Framework == 'esx' then
        local xPlayer = Core.GetPlayerData()
        if not xPlayer then return false end

        return {
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
        local Player = Core.Functions.GetPlayerData()
        if not Player then return false end

        return {
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
