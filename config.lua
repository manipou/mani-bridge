Config = Config or {}

local function dependencyCheck(data)
    for k, v in pairs(data) do
        if GetResourceState(k):find('started') ~= nil then
            return v
        end
    end
    return false
end

Config.Framework = dependencyCheck({
    ['es_extended'] = 'esx',
    ['qb-core'] = 'qb',
    ['qbx_core'] = 'qbx'
}) or nil

Config.oxOptions = { -- ox_lib usage options
    Notify = true,
}