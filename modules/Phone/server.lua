local function SendMessage(Source, From, Message)
    if Config.Phone == 'lb' then
        local PhoneNumber = exports["lb-phone"]:GetEquippedPhoneNumber(Source)
        print(PhoneNumber)
        if not PhoneNumber then return end

        exports['lb-phone']:SendMessage(From, PhoneNumber, Message)
    end
end

exports('SendMessage', SendMessage)