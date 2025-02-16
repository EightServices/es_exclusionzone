Config = {}

Config.Language = "de"

Config.JobsWithPermissions = {
    'police',
    'fib'
}

Config.StandartRadius = 200.0
Config.MinRadius = 50.0
Config.MaxRadius = 400.0

Config.BlipSprite = 60
Config.BlipScale = 0.8
Config.BlipColor = 3
Config.BlipAsShortRange = true
Config.BlipName = "Sperrzone"

Config.RadiusBlipColor = 3
Config.RadiusBlipAlpha = 100

Config.AutoExclusionZoneRemove = 1200000

Config.LogUsername = 'Eight Services | Exclusion Zone'
Config.LogAvatarUrl = 'YOUR_AVATAR_URL'
Config.LogTitle = "Eight Services | Exclusion Zone"
Config.LogColor = 47541

function Announce(message)
    TriggerClientEvent("eight_announce", "Sperrzone", message, 8000)
end