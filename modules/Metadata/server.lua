local function setMetaData(src, metaName, metaData)
    local PlayerData = GetPlayer(src)
    if Config.Framework == 'esx' then
        PlayerData.setMeta(metaName, metaData)
    elseif Config.Framework == 'qb' then
        local metadata = PlayerData.PlayerData.metadata
        metadata[metaName] = metaData
        PlayerData.Functions.SetMetaData(metaName, metadata[metaName])
    end
end

exports('setMetaData', setMetaData)

local function getMetaData(src, metaName, type)
    local PlayerData = GetPlayer(src)
    if Config.Framework == 'esx' then
        if PlayerData.getMeta(metaName) == nil then PlayerData.setMeta(metaName, type == 'int' and 0 or type == 'string' and '' or type == 'table' and {}) end
        return PlayerData.getMeta(metaName)
    elseif Config.Framework == 'qb' then
        local metadata = PlayerData.PlayerData.metadata
        return metadata[metaName]
    end
end

exports('getMetaData', getMetaData)