local function inventorySearch(search, item, metadata)
    if Config.Inventory == 'ox' then
        return exports['ox_inventory']:Search(search, item, metadata)
    elseif Config.Inventory == 'qb' then
        local Inventory = Core.Functions.GetPlayerData().items
        for _, invItem in ipairs(Inventory) do
            if invItem.name == item then
                return invItem.amount or invItem.count
            end
        end
        return 0
    else
        print('ERROR: This server does not have a supported inventory system.')
    end
end

exports('inventorySearch', inventorySearch)