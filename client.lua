Framework, PlayerLoaded, SpeedType, PlayerPed, stress, seatbeltOn = nil, false, nil, nil, 0, false
Framework = GetFramework()
Callback = (Customize.Framework == "ESX" or Customize.Framework == "NewESX") and Framework.TriggerServerCallback or Framework.Functions.TriggerCallback

-- Optimization
Citizen.CreateThread(function()
    Citizen.Wait(1)
    while true do
        PlayerPed = PlayerPedId()
        Citizen.Wait(4500)
    end
end)

RegisterNetEvent('PlayerLoaded', function(set)
    stress = Customize.Stress and set or 0
    FirstSetUp()
    LoadRectMinimap()
end)


function FirstSetUp()
    SpeedType = Customize.SpeedometerTypeKMH and 3.6 or 2.23694
    SendReactMessage('setFirstSetUp', {
        ID = GetPlayerServerId(PlayerId()),
        ServerName = Customize.ServerName,
        AlwaysOnMinimap = Customize.AlwaysOnMinimap,
        SpeedType = Customize.SpeedometerTypeKMH and 'km/h' or 'mp/h',
        MoneyType = Customize.MoneyType,
        StreetDisplay = Customize.StreetDisplay,
        UIColor = Customize.UIColor,
        Display = Customize.Display,
        StressDisplay = Customize.Stress,
        setVisible = true
    })
    if (Customize.Framework == "ESX" or Customize.Framework == "NewESX") then
        Callback('GetMoney', function(bank) SendReactMessage('setMoney', bank) end)
    else
        TriggerServerEvent('QBCore:UpdatePlayer')
        SendReactMessage('setMoney', Framework.Functions.GetPlayerData().money.bank)
    end
    SendReactMessage('setUpdateStress', math.ceil(stress))
    PlayerLoaded = true
end

Citizen.CreateThread(function() -- Online Players
    local wait
    while true do
        if Optimize() then
            Callback('Players', function(Get) SendReactMessage('setPlayersUpdate', Get) end)
            wait = Customize.OnlinePlayersRefreshTime or 25000
        else
            wait = 2000
        end
        Citizen.Wait(wait)
    end
end)


function Optimize()
    if Framework == nil or not PlayerLoaded or PlayerPed == nil then
        return false
    else
        return true
    end
end

-- ! Health
local LastHealth
Citizen.CreateThread(function()
    local wait
    while true do
        if Optimize() then
            local Health = math.floor((GetEntityHealth(PlayerPed)/2))
            if IsPedInAnyVehicle(PlayerPed) then wait = 250 else wait = 650 end
            if Health ~= LastHealth then
                if GetEntityModel(PlayerPed) == `mp_f_freemode_01` and Health ~= 0 then Health = (Health+13) end
                SendReactMessage('setHealth', Health)
                LastHealth = Health
            else
                wait = wait + 1200
            end
        else
            Citizen.Wait(2000)
        end
        Citizen.Wait(wait)
    end
end)

-- ! Armour
local LastArmour
Citizen.CreateThread(function()
    while true do
        if Optimize() then
            local Armour = GetPedArmour(PlayerPed)
            if Armour ~= LastArmour then
                SendReactMessage('setArmour', Armour)
                Citizen.Wait(2500)
                LastArmour = Armour
            else
                Citizen.Wait(4321)
            end
        else
            Citizen.Wait(2000)
        end
    end
end)

-- ! Stamina
Citizen.CreateThread(function()
local wait, LastOxygen
    while true do
        local Player = PlayerId()
        local newoxygen = GetPlayerSprintStaminaRemaining(Player)
        if IsPedInAnyVehicle(PlayerPed) then wait = 2100 end
        if LastOxygen ~= newoxygen then
            wait = 125
            if IsEntityInWater(PlayerPed) then
                oxygen = GetPlayerUnderwaterTimeRemaining(Player) * 10
            else
                oxygen = 100 - GetPlayerSprintStaminaRemaining(Player)
            end
            LastOxygen = newoxygen
            SendReactMessage('setStamina', math.ceil(oxygen))
        else
            wait = 1850
        end
        Citizen.Wait(wait)
    end
end)


-- ? Status
RegisterNetEvent('hud:client:UpdateNeeds', function(newHunger, newThirst) -- Triggered in qb-core
    local Hungerr = 0
    local Thirstt = 0
    if math.ceil(newHunger) > 100 then
        Hungerr = 100
    else
        Hungerr = math.ceil(newHunger)
    end
    if math.ceil(newThirst) > 100 then
        Thirstt = 100
    else
        Thirstt = math.ceil(newThirst)
    end
    SendReactMessage('setUpdateNeeds', { Hunger = Hungerr, Thirst = Thirstt })
end)

Citizen.CreateThread(function()
    if Customize.Framework == "NewESX" or Customize.Framework == "ESX" then 

        Citizen.CreateThread(function()
            Citizen.Wait(2500)
            TriggerEvent('esx_status:getStatus', 'hunger', function(hunger)
                TriggerEvent('esx_status:getStatus', 'thirst', function(thirst)
                    SendReactMessage('setUpdateNeeds', { Hunger = math.ceil(hunger.getPercent()), Thirst = math.ceil(thirst.getPercent()) })
                end)
            end)
        end)
            
        RegisterNetEvent("esx_status:onTick")
        AddEventHandler("esx_status:onTick", function(data)
            for _,v in pairs(data) do
                if v.name == "hunger" then
                    SendReactMessage('setUpdateNeedsHunger', math.ceil(v.percent))
                elseif v.name == "thirst" then
                    SendReactMessage('setUpdateNeedsThirst', math.ceil(v.percent))
                end
            end
        end)
      
        RegisterNetEvent('esx_status:update')
        AddEventHandler('esx_status:update', function(data)
            for _,v in pairs(data) do
                if v.name == "hunger" then
                    SendReactMessage('setUpdateNeedsHunger', math.ceil(v.percent))
                elseif v.name == "thirst" then
                    SendReactMessage('setUpdateNeedsThirst', math.ceil(v.percent))
                end
            end
        end)

    end
end)




-- ? Speedometer
local LastSpeed, LastRpm, LastEngine, LastLight, LastSeatbelt
local LastFuel = 0
Citizen.CreateThread(function()
    DisplayRadar(false)
    local wait
    while true do
        if Optimize() then
            if IsPedInAnyVehicle(PlayerPed) then
                local Vehicle = GetVehiclePedIsIn(PlayerPed, false)
                if Vehicle then
                    local Plate = GetVehicleNumberPlateText(Vehicle)
                    SendReactMessage('setSpedometer', true)
                    wait = 90
                    local LightVal, LightLights, LightHighlights  = GetVehicleLightsState(Vehicle)
                    Light = false
                    if LightLights == 1 and LightHighlights == 0 or LightLights == 1 and LightHighlights == 1 then Light = true end
                    local Speed, Rpm, Fuel, Engine = GetEntitySpeed(Vehicle), GetVehicleCurrentRpm(Vehicle), getFuelLevel(Vehicle), GetIsVehicleEngineRunning(Vehicle)
                    local VehGear = GetVehicleCurrentGear(Vehicle)
                    if (Speed == 0 and VehGear == 0) or (Speed == 0 and VehGear == 1) then VehGear = 'N' elseif Speed > 0 and VehGear == 0 then VehGear = 'R' end
                    if LastSeatbelt ~= seatbeltOn or LastSpeed ~= Speed or LastRpm ~= Rpm or LastFuel ~= Fuel or LastEngine ~= Engine or LastLight ~= Light then
                        SendReactMessage('Speed', {
                            Speed = ("%.1d"):format(math.ceil(Speed * SpeedType)),
                            Rpm = Rpm,
                            Gear = VehGear,
                            Fuel = Fuel,
                            EngineDamage = GetVehicleEngineHealth(Vehicle) / 10,
                            Engine = Engine,
                            Seatbelt = seatbeltOn,
                            Light = Light,
                        })
                        LastSpeed, LastRpm, LastFuel, LastEngine, LastLight = Speed, Rpm, Fuel, Engine, Light
                        LastSeatbelt = seatbeltOn
                    else wait = 175
                    end
                    DisplayRadar(true)
                end
            else
                SendReactMessage('setSpedometer', false)
                DisplayRadar((Customize.AlwaysOnMinimap) and true or false)
                -- if not Customize.AlwaysOnMinimap then DisplayRadar((not Customize.AlwaysOnMinimap) and false or true) end
                wait = 2750
            end
         else
             Citizen.Wait(2000)
         end
        Citizen.Wait(wait)
    end
end)


local lastFuelUpdate = 0
function getFuelLevel(vehicle)
    local updateTick = GetGameTimer()
    if (updateTick - lastFuelUpdate) > 2000 then
        lastFuelUpdate = updateTick
        LastFuel = math.floor(Customize.GetVehFuel(vehicle))
    end
    return LastFuel
end

if Customize.StreetDisplay then
    local LastStreet1, LastStreet1
    Citizen.CreateThread(function()
        local wait = 2500
        while true do
            local Coords = GetEntityCoords(PlayerPed)
            local Street1, Street2 = GetStreetNameAtCoord(Coords.x, Coords.y, Coords.z, Citizen.ResultAsInteger(), Citizen.ResultAsInteger())
            if IsPedInAnyVehicle(PlayerPed) then wait = 1700 else wait = 4000 end
            StreetName1 = GetLabelText(GetNameOfZone(Coords.x, Coords.y, Coords.z))
            StreetName2 = GetStreetNameFromHashKey(Street1)
            if Street1 ~= LastStreet1 or Street2 ~= LastStreet2 then
                SendReactMessage('setStreet', {
                    Street1 = StreetName1,
                    Street2 = StreetName2
                })
                LastStreet1 = StreetName1
                LastStreet2 = StreetName2
            else
                wait = wait + 2100
            end
            Citizen.Wait(wait)
        end
    end)
end



-- Stress

-- Stress Gain
RegisterNetEvent('UpdateStress', function(newStress) -- Add this event with adding stress elsewhere (QBCore)
    SendReactMessage('setUpdateStress', math.ceil(newStress))
    stress = newStress
end)

if Customize.Stress then
    
    CreateThread(function() -- Speeding
        while true do
            if Optimize() then
                if IsPedInAnyVehicle(PlayerPed, false) then
                    local speed = GetEntitySpeed(GetVehiclePedIsIn(PlayerPed, false)) * SpeedType
                    local stressSpeed = seatbeltOn and Customize.MinimumSpeed or Customize.MinimumSpeedUnbuckled
                    if speed >= stressSpeed then
                        TriggerServerEvent('SetStress', math.random(1, 3))
                    end
                end
            end
            Wait(10000)
        end
    end)
    
    local function IsWhitelistedWeaponStress(weapon)
        if weapon then
            for _, v in pairs(Customize.WhitelistedWeaponStress) do
                if weapon == v then
                    return true
                end
            end
        end
        return false
    end
    
    CreateThread(function() -- Shooting
        while true do
            if Optimize() then
                local weapon = GetSelectedPedWeapon(PlayerPed)
                if weapon ~= `WEAPON_UNARMED` then
                    if IsPedShooting(PlayerPed) and not IsWhitelistedWeaponStress(weapon) then
                        if math.random() < Customize.StressChance then
                            TriggerServerEvent('SetStress', math.random(1, 3))
                        end
                    end
                else
                    Wait(1000)
                end
            end
            Wait(8)
        end
    end)
    
    -- Stress Screen Effects
    
    function GetBlurIntensity(stresslevel)
        for _, v in pairs(Customize.Intensity) do
            if stresslevel >= v.min and stresslevel <= v.max then
                return v.intensity
            end
        end
        return 1500
    end
    
    function GetEffectInterval(stresslevel)
        for _, v in pairs(Customize.EffectInterval) do
            if stresslevel >= v.min and stresslevel <= v.max then
                return v.timeout
            end
        end
        return 60000
    end
    
    CreateThread(function()
        while true do
            local effectInterval = GetEffectInterval(stress)
            if stress >= 100 then
                local BlurIntensity = GetBlurIntensity(stress)
                local FallRepeat = math.random(2, 4)
                local RagdollTimeout = FallRepeat * 1750
                TriggerScreenblurFadeIn(1000.0)
                Wait(BlurIntensity)
                TriggerScreenblurFadeOut(1000.0)
    
                if not IsPedRagdoll(PlayerPed) and IsPedOnFoot(PlayerPed) and not IsPedSwimming(PlayerPed) then
                    SetPedToRagdollWithFall(PlayerPed, RagdollTimeout, RagdollTimeout, 1, GetEntityForwardVector(PlayerPed), 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
                end
    
                Wait(1000)
                for _ = 1, FallRepeat, 1 do
                    Wait(750)
                    DoScreenFadeOut(200)
                    Wait(1000)
                    DoScreenFadeIn(200)
                    TriggerScreenblurFadeIn(1000.0)
                    Wait(BlurIntensity)
                    TriggerScreenblurFadeOut(1000.0)
                end
            elseif stress >= Customize.MinimumStress then
                local BlurIntensity = GetBlurIntensity(stress)
                TriggerScreenblurFadeIn(1000.0)
                Wait(BlurIntensity)
                TriggerScreenblurFadeOut(1000.0)
            end
            Wait(effectInterval)
        end
    end)

end

-- ? seatbelt
RegisterNetEvent('seatbelt:client:ToggleSeatbelt', function() -- Triggered in smallresources
    seatbeltOn = not seatbeltOn
end)

exports("SeatbeltState", function(state)
    seatbeltOn = state
end)

-- ? Money
RegisterNetEvent("QBCore:Player:SetPlayerData")
AddEventHandler("QBCore:Player:SetPlayerData", function(data)
  SendReactMessage('setMoney', data.money.bank)
end)


RegisterNetEvent('esx:setAccountMoney', function(account)
    if account.name == 'bank' then
        SendReactMessage('setBankMoney', account.money)
    end
end)


function SendReactMessage(action, data) SendNUIMessage({ action = action, data = data }) end


-- ? Map


-- Minimap update
-- CreateThread(function()
--     while true do
--         SetRadarBigmapEnabled(false, false)
--         SetRadarZoom(1000)
--         Wait(500)
--     end
-- end)

Citizen.CreateThread(function()
    local minimap = RequestScaleformMovie("minimap")
    SetRadarBigmapEnabled(true, false)
    Wait(0)
    SetRadarBigmapEnabled(false, false)
end)

CreateThread(function()
    local minimap = RequestScaleformMovie("minimap")
    if not HasScaleformMovieLoaded(minimap) then
        RequestScaleformMovie(minimap)
        while not HasScaleformMovieLoaded(minimap) do Wait(1) end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        HideHudComponentThisFrame(6) -- VEHICLE_NAME
        HideHudComponentThisFrame(7) -- AREA_NAME
        HideHudComponentThisFrame(8) -- VEHICLE_CLASS
        HideHudComponentThisFrame(9) -- STREET_NAME
        HideHudComponentThisFrame(3) -- CASH
        HideHudComponentThisFrame(4) -- MP_CASH
    end
end)

function LoadRectMinimap()
    local defaultAspectRatio = 1920/1080 -- Don't change this.
    local resolutionX, resolutionY = GetActiveScreenResolution()
    local aspectRatio = resolutionX/resolutionY
    local minimapOffset = 0
    if aspectRatio > defaultAspectRatio then
        minimapOffset = ((defaultAspectRatio-aspectRatio)/3.6)-0.008
    end
    RequestStreamedTextureDict("squaremap", false)
    while not HasStreamedTextureDictLoaded("squaremap") do
        Wait(150)
    end

    SetMinimapClipType(0)
    AddReplaceTexture("platform:/textures/graphics", "radarmasksm", "squaremap", "radarmasksm")
    AddReplaceTexture("platform:/textures/graphics", "radarmask1g", "squaremap", "radarmasksm")
    -- 0.0 = nav symbol and icons left
    -- 0.1638 = nav symbol and icons stretched
    -- 0.216 = nav symbol and icons raised up
    SetMinimapComponentPosition("minimap", "L", "B", 0.0 + minimapOffset, -0.047, 0.1638, 0.183)

    -- icons within map
    SetMinimapComponentPosition("minimap_mask", "L", "B", 0.0 + minimapOffset, 0.0, 0.128, 0.20)

    -- -0.01 = map pulled left
    -- 0.025 = map raised up
    -- 0.262 = map stretched
    -- 0.315 = map shorten
    SetMinimapComponentPosition('minimap_blur', 'L', 'B', -0.01 + minimapOffset, 0.025, 0.262, 0.300)

    SetBlipAlpha(GetNorthRadarBlip(), 0)
    SetRadarBigmapEnabled(true, false)
    SetMinimapClipType(0)
    Wait(0)
    SetRadarBigmapEnabled(false, false)
end

RegisterNetEvent('esx_basicneeds:onEat')
AddEventHandler('esx_basicneeds:onEat', function()
    TriggerServerEvent('SetStress', -math.random(5, 15))
end)

RegisterNetEvent('consumables:client:Eat')
AddEventHandler('consumables:client:Eat', function()
    TriggerServerEvent('SetStress', -math.random(5, 15))
end)


RegisterNetEvent('consumables:client:Drink')
AddEventHandler('consumables:client:Drink', function()
    TriggerServerEvent('SetStress', -math.random(5, 15))
end)
RegisterNetEvent('consumables:client:DrinkAlcohol')
AddEventHandler('consumables:client:DrinkAlcohol', function()
    TriggerServerEvent('SetStress', -math.random(5, 15))
end)


RegisterNetEvent('esx_optionalneeds:onDrink')
AddEventHandler('esx_optionalneeds:onDrink', function()
    TriggerServerEvent('SetStress', -math.random(5, 15))
end)


RegisterNetEvent('esx_basicneeds:onDrink')
AddEventHandler('esx_basicneeds:onDrink', function()
    TriggerServerEvent('SetStress', -math.random(5, 15))
end)

AddEventHandler('esx:onPlayerDeath', function()
    TriggerServerEvent('SetStress', -100)
end)

RegisterNetEvent('hospital:client:RespawnAtHospital')
AddEventHandler('hospital:client:RespawnAtHospital', function()
    TriggerServerEvent('SetStress', -100)
end)

RegisterNetEvent('hospital:client:Revive')
AddEventHandler('hospital:client:Revive', function()
    TriggerServerEvent('SetStress', -100)
end)