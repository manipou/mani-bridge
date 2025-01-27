local function addItem(src, item, amount, metadata)
    if Config.Inventory == 'ox' then
        local item = exports['ox_inventory']:AddItem(src, item, amount, metadata)
    elseif not Config.Inventory then
        -- ADD YOUR OWN INVENTORY SYSTEM HERE
        print('ERROR: This server does not have a supported inventory system.')
    end
end

exports('addItem', addItem)

local function removeItem(src, item, amount, slot)
    if Config.Inventory == 'ox' then
        exports['ox_inventory']:RemoveItem(src, item, amount, nil, slot)
    elseif not Config.Inventory then
        -- ADD YOUR OWN INVENTORY SYSTEM HERE
        print('ERROR: This server does not have a supported inventory system.')
    end
end

exports('removeItem', removeItem)

local function getItemFromSlot(src, slot)
    if Config.Inventory == 'ox' then
        return exports['ox_inventory']:GetSlot(src, slot)
    elseif not Config.Inventory then
        -- ADD YOUR OWN INVENTORY SYSTEM HERE
        print('ERROR: This server does not have a supported inventory system.')
    end
end

exports('getItemFromSlot', getItemFromSlot)

local function updateMetadata(src, slot, metadata)
    if Config.Inventory == 'ox' then
        local item = exports['ox_inventory']:GetSlot(src, slot)
        exports['ox_inventory']:SetMetadata(src, slot, metadata)
    elseif not Config.Inventory then
        -- ADD YOUR OWN INVENTORY SYSTEM HERE
        print('ERROR: This server does not have a supported inventory system.')
    end
end

exports('updateMetadata', updateMetadata)