local function SendMessage(Source, From, Message)
    if not Config.Phone then return false end

    if Config.Phone == 'lb' then
        local PhoneNumber = exports["lb-phone"]:GetEquippedPhoneNumber(Source)
        if not PhoneNumber then return false end

        exports['lb-phone']:SendMessage(From, PhoneNumber, Message)
        return true
    end
end

exports('SendMessage', SendMessage)