ESX = exports["es_extended"]:getSharedObject()

local createdBlips = {}

RegisterNetEvent("createBlip")
AddEventHandler("createBlip", function(x, y, z, radius)
    if radius < Config.MinRadius then
        ESX.ShowNotification(Locales.MinRadius)
        return
    end

    local blip = AddBlipForCoord(x, y, z)
    SetBlipSprite(blip, Config.BlipSprite)
    SetBlipDisplay(blip, 2)
    SetBlipScale(blip, Config.BlipScale)
    SetBlipColour(blip, Config.BlipColor)
    SetBlipAsShortRange(blip, Config.BlipAsShortRange)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(Config.BlipName)
    EndTextCommandSetBlipName(blip)

    local radiusBlip = AddBlipForRadius(x, y, z, radius)
    SetBlipSprite(radiusBlip, 9)
    SetBlipColour(radiusBlip, Config.RadiusBlipColor)
    SetBlipAlpha(radiusBlip, Config.RadiusBlipAlpha)

    table.insert(createdBlips, {blip = blip, radiusBlip = radiusBlip})

    Wait(Config.AutoExclusionZoneRemove)
    RemoveBlip(blip)
    RemoveBlip(radiusBlip)
    for i, blipData in ipairs(createdBlips) do
        if blipData.blip == blip then
            table.remove(createdBlips, i)
            break
        end
    end
end)

RegisterNetEvent("removeBlip")
AddEventHandler("removeBlip", function(blip)
    for _, blipData in pairs(createdBlips) do
        RemoveBlip(blipData.blip)
        RemoveBlip(blipData.radiusBlip)
    end
    createdBlips = {}
end)