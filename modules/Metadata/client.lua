local function getMetaData(metaName, type)
    return lib.callback.await('mani-bridge:server:getMetaData', metaName, type)
end

exports('getMetaData', getMetaData)