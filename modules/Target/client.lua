local function AddTargetModel(models, options)
    if Config.Target == 'ox' then
        exports['ox_target']:addModel(models, options)
    end
end

exports('AddTargetModel', AddTargetModel)

local function AddBoxTarget(parameters)
    if Config.Target == 'ox' then
        exports['ox_target']:addBoxZone(parameters)
    end
end

exports('AddBoxTarget', AddBoxTarget)

local function AddLocalEntityTarget(entity, options)
    if Config.Target == 'ox' then
        exports['ox_target']:addLocalEntity(entity, options)
    end
end

exports('AddLocalEntity', AddLocalEntity)

local function AddGlobalVehicleTarget(options)
    if Config.Target == 'ox' then
        exports['ox_target']:addGlobalVehicle(options)
    end
end

exports('AddGlobalVehicleTarget', AddGlobalVehicleTarget)

local function RemoveTargetZone(id)
    if Config.Target == 'ox' then
        exports['ox_target']:removeZone(id)
    end
end

exports('RemoveTargetZone', RemoveTargetZone)

local function RemoveTargetModel(models, optionNames)
    if Config.Target == 'ox' then
        exports['ox_target']:removeModel(models, optionNames)
    end
end

exports('RemoveTargetModel', RemoveTargetModel)