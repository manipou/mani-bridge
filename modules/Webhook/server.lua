local function DiscordWebhook(Source, Data) -- Remove this function if you don't want discord logging.
    local PlayerPed = GetPlayerPed(Source)
    local PlayerCoords = GetEntityCoords(PlayerPed)

    local embed = {
        title = GetPlayerName(Source) or 'N/A',
        description = ('### %s'):format(Data.Message),
        color = 5793266,
        fields = {
            { name = 'Server ID', value = ('```%s```'):format(Source or 'N/A'), inline = true },
            { name = 'Discord', value = ('```%s```'):format(GetPlayerIdentifierByType(Source, 'discord') or 'N/A'), inline = true },
            { name = 'Steam', value = ('```%s```'):format(GetPlayerIdentifierByType(Source, 'steam') or 'N/A'), inline = true },
            { name = 'Coords', value = ('```%s```'):format(string.format('%.2f, %.2f, %.2f', PlayerCoords.x, PlayerCoords.y, PlayerCoords.z) or 'Unknown'), inline = true },
        },
        footer = {
            text = '🕒 Logged at ' .. os.date('!%Y-%m-%d %H:%M:%S UTC'),
        }
    }

    local payload = json.encode({
        embeds = { embed },
        username = Data.Resource or 'Mani-Bridge',
        avatar_url = 'https://files.fivemerr.com/images/99d4531c-7016-4802-8f6c-2ad58ff22319.png'
    })

    PerformHttpRequest(Data.Webhook, function(err, text, headers)
        if err ~= 204 then
            lib.print.error('Failed to upload embed. Status: ' .. tostring(err))
        end
    end, 'POST', payload, { ['Content-Type'] = 'application/json' })
end

exports('DiscordWebhook', DiscordWebhook)