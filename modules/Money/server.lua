local function ConvertMoneyType(moneyType)
    if moneyType == 'money' and Config.Framework == 'qb' or Config.Framework == 'qbx' then
        return 'cash'
    elseif moneyType == 'cash' and Config.Framework == 'esx' then
        return 'money'
    else
        return moneyType
    end
end

local function AddMoney(src, moneyType, amount)
    local PlayerData = GetPlayer(scr)
    if Config.Framework == 'esx' then
        PlayerData.addAccountMoney(ConvertMoneyType(moneyType), amount)
    elseif Config.Framework == 'qb' or Framework == 'qbx' then
        PlayerData.Functions.AddMoney(ConvertMoneyType(moneyType), amount)
    else
        -- ADD CUSTOM FRAMEWORK SUPPORT HERE
    end
end

exports('AddMoney', AddMoney)