function GetGender() -- Depricated, idk why i made this.
    return lib.callback.await('mani-bridge:server:getGender', false)
end

exports('GetGender', GetGender)

local function GetPlayerData()
    if Config.Framework == 'esx' then
        local state = LocalPlayer.state

        return {
            Job = {
                name = state.job.name,
                label = state.job.label,
                grade = state.job.grade,
                gradeLabel = state.job.grade_label,
                isBoss = state.job.grade_name == 'boss'
            },
            Identifier = state.identifier
        }
    elseif Config.Framework == 'qb' or Config.Framework == 'qbx' then
        local Player = Core.Functions.GetPlayerData()
    
        return {
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