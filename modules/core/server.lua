Core = nil

CreateThread(function()
    local supportedCores = {
        esx = 'es_extended',
        qb = 'qb-core',
        qbx = 'qbx_core'
    }
    if GetResourceState(supportedCores[Config.Framework]) == 'started' then
        if supportedCores[Config.Framework] == 'es_extended' then
            Core = exports[supportedCores[Config.Framework]]:getSharedObject()
        elseif supportedCores[Config.Framework] == 'qb-core' then
            Core = exports[supportedCores[Config.Framework]]:GetCoreObject()
        elseif supportedCores[Config.Framework] == 'qbx_core' then
            Core = exports[supportedCores[Config.Framework]]:GetCoreObject()
        end
    end
end)

local function getCore()
    return Core
end

exports('getCore', getCore)