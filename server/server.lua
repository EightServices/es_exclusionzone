ESX = exports["es_extended"]:getSharedObject()

local webhookFile = LoadResourceFile(GetCurrentResourceName(), 'webhook.json')
local webhook = json.decode(webhookFile)

if not webhook or not webhook.webhook then
    print("Error loading webhook URL from webhook.json")
end

local activeBlips = {}

local function getLocale()
    return Locales[Config.Language] or Locales['en']
end

RegisterCommand("pd", function(source, args, rawCommand)
    local player = ESX.GetPlayerFromId(source)
    local Locale = getLocale()

    if player then
        local job = player.getJob().name

        if not HasActiveBlip(source) then
            local radius = tonumber(args[1]) or Config.StandartRadius

            if radius < Config.MinRadius then
                TriggerClientEvent("esx:showNotification", source, Locale.MinRadius)
                return
            end

            if radius > Config.MaxRadius then
                TriggerClientEvent("esx:showNotification", source, Locale.MaxRadius)
                return
            end

            local radiusString = string.format("%.1f", radius)

            if IsJobWithPermission(job) then
                local playerCoords = GetEntityCoords(GetPlayerPed(source))
                TriggerClientEvent("createBlip", -1, playerCoords.x, playerCoords.y, playerCoords.z, tonumber(radiusString))
                table.insert(activeBlips, {source = source, blip = blip, timestamp = os.time()})
                TriggerClientEvent("esx:showNotification", source, Locale.ExclusionZoneCreated)
                Announce(Locale.AnnounceExclusionZoneCreated)

                local xPlayer = ESX.GetPlayerFromId(source)
                local playerName = xPlayer.getName()
                LogToDiscord(playerName .. Locale.LogCreatedExclusionZone)
            else
                TriggerClientEvent("esx:showNotification", source, Locale.NoPermissions)
            end
        else
            TriggerClientEvent("esx:showNotification", source, Locale.AlreadyHaveAnExclusionZone)
        end
    end
end, false)

RegisterCommand("pdrm", function(source, args, rawCommand)
    local player = ESX.GetPlayerFromId(source)
    local Locale = getLocale()
    
    if player then
        local job = player.getJob().name
        if IsJobWithPermission(job) then
            for i = #activeBlips, 1, -1 do
                local blipData = activeBlips[i]
                if blipData.source == source then
                    local blip = blipData.blip
                    TriggerClientEvent("removeBlip", -1, blip)
                    TriggerClientEvent("esx:showNotification", source, Locale.RemovedExclusionZone)
                    Announce(Locale.RemovedExclusionZone)
                    table.remove(activeBlips, i)

                    local xPlayer = ESX.GetPlayerFromId(source)
                    local playerName = xPlayer.getName()
                    LogToDiscord(playerName .. Locale.LogRemovedExclusionZone)
                end
            end
        else
            TriggerClientEvent("esx:showNotification", source, Locale.NoPermissions)
        end
    end
end, false)

function IsJobWithPermission(job)
    for _, v in pairs(Config.JobsWithPermissions) do
        if v == job then
            return true
        end
    end
    return false
end

function HasActiveBlip(playerId)
    for _, v in pairs(activeBlips) do
        if v.source == playerId then
            return true
        end
    end
    return false
end

function LogToDiscord(message)
    local data = {
        username = Config.LogUsername,
        avatar_url = Config.LogAvatarUrl,
        embeds = {{
            title = Config.LogTitle,
            description = message,
            color = Config.LogColor
        }}
    }

    PerformHttpRequest(config.webhook, function(statusCode, response, headers)
    end, 'POST', json.encode(data), { ['Content-Type'] = 'application/json' })
end
