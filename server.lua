Framework = nil
PlayerStress = json.decode(LoadResourceFile(GetCurrentResourceName(), "./Stress.json"))

Citizen.CreateThread(function()
    while Framework == nil do Citizen.Wait(750) end
    Citizen.Wait(2500)
    for _,v in pairs(GetPlayers()) do
        local ID = (Customize.Framework == "ESX" or Customize.Framework == "NewESX") and Framework.GetPlayerFromId(tonumber(v))?.identifier or Framework.Functions.GetPlayer(tonumber(v))?.PlayerData?.citizenid
        if Player ~= nil then
            if not PlayerStress[ID] then PlayerStress[ID] = 0 end
            TriggerClientEvent('PlayerLoaded', tonumber(v), tonumber(PlayerStress[ID]))
            Wait(74)
        end
    end
end)

Citizen.CreateThread(function()
    Framework = GetFramework()
    Callback = (Customize.Framework == "ESX" or Customize.Framework == "NewESX") and Framework.RegisterServerCallback or Framework.Functions.CreateCallback
    Citizen.Wait(2000)

    Callback('Players', function(source, cb)
        local count = 0
        local plyr =  (Customize.Framework == "ESX" or Customize.Framework == "NewESX") and Framework.GetPlayers() or Framework.Functions.GetPlayers()
        for k,v in pairs(plyr) do
            if v ~= nil then count = count + 1 end
        end
        cb(count)
    end)

    Callback('GetMoney', function(source, cb)
        cb(Framework.GetPlayerFromId(source).getAccount("bank").money)
    end)

end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(src)
    Wait(700)
    local ID = Framework.GetPlayerFromId(src)?.identifier
    if not PlayerStress[ID] then PlayerStress[ID] = 0 end
    TriggerClientEvent('PlayerLoaded', src, tonumber(PlayerStress[ID]))
end)

RegisterNetEvent('QBCore:Server:OnPlayerLoaded')
AddEventHandler('QBCore:Server:OnPlayerLoaded', function()
    local source = source
    Wait(700)
    local ID = Framework.Functions.GetPlayer(source)?.PlayerData?.citizenid
    if not PlayerStress[ID] then PlayerStress[ID] = 0 end
    TriggerClientEvent('PlayerLoaded', source, tonumber(PlayerStress[ID]))
end)


-- PlayerStress = {}

RegisterNetEvent('SetStress', function(amount)
    local Player = (Customize.Framework == "ESX" or Customize.Framework == "NewESX") and Framework.GetPlayerFromId(source) or Framework.Functions.GetPlayer(source)
    local JobName = (Customize.Framework == "ESX" or Customize.Framework == "NewESX") and Player.job.label or Player.PlayerData.job.label
    local ID = (Customize.Framework == "ESX" or Customize.Framework == "NewESX") and Player.identifier or Player.PlayerData.citizenid
    local newStress
    if not Player or IsWhitelisted(Player, JobName) then return end -- OLD: if not Player or (Customize.DisablePoliceStress and JobName == 'police') then return end
    if not PlayerStress[ID] then PlayerStress[ID] = 0 end
    newStress = PlayerStress[ID] + amount
    if newStress <= 0 then newStress = 0 end
    if newStress > 100 then newStress = 100 end
    PlayerStress[ID] = newStress
    TriggerClientEvent('UpdateStress', source, PlayerStress[ID])
    SaveResourceFile(GetCurrentResourceName(), "./Stress.json", json.encode(PlayerStress), -1)
end)

function IsWhitelisted(Player, JobName)
    if Player then
        for _, v in pairs(Customize.DisableJobsStress) do
            if jobName == v then
                return true
            end
        end
    end
    return false
end