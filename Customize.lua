Customize = {
    Framework = "QBCore", -- QBCore | ESX | NewESX | OldQBCore (Write the framework you used as in the example)    
    
    SpeedometerTypeKMH = true, -- kmh | mph
    AlwaysOnMinimap = false, -- Specifies whether the minimap should be visible outside the vehicle
    StreetDisplay = true,
    ServerName = 'uz rp',
    MoneyType = '$',
    OnlinePlayersRefreshTime = 25000,

    GetVehFuel = function(Veh)
        return GetVehicleFuelLevel(Veh) -- exports["LegacyFuel"]:GetFuel(Veh) - GetVehicleFuelLevel(Veh) - exports["uz_fuel"]:GetFuel(Veh)
    end,

    Display = {
        PlayerDisplay = true,
        MoneyDisplay = true
    },

    UIColor = {
        Health = '#F3163E',
        Armour = '#00A3FF',
        Hunger = '#ADFE00',
        Thirst = '#00FFF0',
        Stamina = '#FFA048',
        Stress = '#FF0099',
        Location = '#FFFFFF',
        MoneyBackground = '#FFFFFF',
        ServersBackground = '#FFFFFF',
        ServerDetails = '#F3163E',
        MoneyIcon = '#F3163E',
    },


    Stress = true, -- true | false
    StressChance = 0.1, -- Default: 10% -- Percentage Stress Chance When Shooting (0-1)
    MinimumStress = 50, -- Minimum Stress Level For Screen Shaking
    MinimumSpeed = 100, -- Going Over This Speed Will Cause Stress
    MinimumSpeedUnbuckled = 50, -- Going Over This Speed Will Cause Stress
    DisableJobsStress = { 'police', 'ambulance'}, -- Add here jobs you want to disable stress - OLD: -- DisablePoliceStress = true, -- If true will disable stress for people with the police job

    WhitelistedWeaponStress = {
        `weapon_petrolcan`,
        `weapon_hazardcan`,
        `weapon_fireextinguisher`
    },

    Intensity = {
        [1] = {
            min = 50,
            max = 60,
            intensity = 1500,
        },
        [2] = {
            min = 60,
            max = 70,
            intensity = 2000,
        },
        [3] = {
            min = 70,
            max = 80,
            intensity = 2500,
        },
        [4] = {
            min = 80,
            max = 90,
            intensity = 2700,
        },
        [5] = {
            min = 90,
            max = 100,
            intensity = 3000,
        },
    },

    EffectInterval = {
        [1] = {
            min = 50,
            max = 60,
            timeout = math.random(50000, 60000)
        },
        [2] = {
            min = 60,
            max = 70,
            timeout = math.random(40000, 50000)
        },
        [3] = {
            min = 70,
            max = 80,
            timeout = math.random(30000, 40000)
        },
        [4] = {
            min = 80,
            max = 90,
            timeout = math.random(20000, 30000)
        },
        [5] = {
            min = 90,
            max = 100,
            timeout = math.random(15000, 20000)
        }
    }
}



function GetFramework()
    local Get = nil
    if Customize.Framework == "NewESX" then
        Get = exports['es_extended']:getSharedObject()
    end
    if Customize.Framework == "QBCore" then
        Get = exports["qb-core"]:GetCoreObject()
    end
    if Customize.Framework == "ESX" then
        while Get == nil do
            TriggerEvent('esx:getSharedObject', function(Set) Get = Set end)
            Citizen.Wait(0)
        end
    end
    if Customize.Framework == "OldQBCore" then
        while Get == nil do
            TriggerEvent('QBCore:GetObject', function(Set) Get = Set end)
            Citizen.Wait(200)
        end
    end
    return Get
end
