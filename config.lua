Config = Config or {}

local function dependencyCheck(resources)
    for k, v in pairs(resources) do
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

Config.Inventory = dependencyCheck({
    ['ox_inventory'] = 'ox',
}) or nil

Config.oxOptions = { -- ox_lib usage options
    Notify = true,
    ProgressBar = 'bar' -- 'bar' or 'circle' - false to disable
}