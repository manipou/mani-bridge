local function progressBar(data, completed, cancelled)
    if Config.oxOptions.ProgressBar ~= false then
        if Config.oxOptions.ProgressBar == 'bar' then
            if lib.progressBar({
                duration = data.duration,  
                label = data.label,      
                useWhileDead = data.useWhileDead,
                allowSwimming = data.allowSwimming, 
                canCancel = data.canCancel,  
                disable = data.disable 
            }) then 
                completed()
            else 
                cancelled()
            end
        elseif Config.oxOptions.ProgressBar == 'circle' then
            if lib.progressCircle({
                duration = data.duration,  
                label = data.label,      
                useWhileDead = data.useWhileDead,
                allowSwimming = data.allowSwimming, 
                canCancel = data.canCancel,  
                disable = data.disable 
            }) then 
                completed()
            else 
                cancelled()
            end
        end
    elseif Config.Framework == 'esx' then
        Core.Progressbar(data.label, data.duration,{
            FreezePlayer = data.disable.move, 
            onFinish = function()
                completed()
        end, onCancel = function()
                cancelled()
        end
        })
    elseif Config.Framework == 'qb' then
        Core.Functions.Progressbar(data.name, data.label, data.duration, data.useWhileDead, data.canCancel, {
            disableMovement = data.disable.move,
            disableCarMovement = data.disable.car,
            disableMouse = data.disable.mouse,
            disableCombat = data.disable.combat,
            }, {}, {}, {}, function()
                completed()
            end, function()
                cancelled()
        end)
    end
end

exports('progressBar', progressBar)

local function progressActive()
    Config.oxOptions.ProgressBar ~= false then
        return lib.progressActive()
    else
        return false -- add custom progress active check
    end
end

exports('progressActive', progressActive)