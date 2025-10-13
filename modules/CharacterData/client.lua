function GetGender() -- Depricated, idk why i made this.
    return lib.callback.await('mani-bridge:server:getGender', false)
end

exports('GetGender', GetGender)

local function GetPlayerData()
    if Config.Framework == 'esx' then
        local state = LocalPlayer.state

        return {
            Job = {
                Name = state.job.name,
                Label = state.job.label,
                Grade = state.job.grade,
                GradeLabel = state.job.grade_label,
                IsBoss = state.job.grade_name == 'boss'
            },
            Identifier = state.identifier
        }
    elseif Config.Framework == 'qb' or Config.Framework == 'qbx' then
        local Player = Core.Functions.GetPlayerData()
    
        return {
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
