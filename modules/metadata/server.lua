local function setMetaData(src, metaName, metaData)
    if Config.Framework == 'esx' then
        local xPlayer = Core.GetPlayerFromId(src)
        xPlayer.setMeta(metaName, metaData)
    elseif Config.Framework == 'qb' then
        local Player = Core.Functions.GetPlayer(src)
        local metadata = Player.PlayerData.metadata
        metadata[metaName] = metaData
        Player.Functions.SetMetaData(metaName, metadata[metaName])
    end
end

exports('setMetaData', setMetaData)

local function getMetaData(src, metaName, type)
    if Config.Framework == 'esx' then
        local xPlayer = Core.GetPlayerFromId(src)
        if xPlayer.getMeta(metaName) == nil then xPlayer.setMeta(metaName, type == 'int' and 0 or type == 'string' and '' or type == 'table' and {}) end
        return xPlayer.getMeta(metaName)
    elseif Config.Framework == 'qb' then
        local Player = Core.Functions.GetPlayer(src)
        local metadata = Player.PlayerData.metadata
        return metadata[metaName]
    end
end

exports('getMetaData', getMetaData)