QBCore = nil

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        if QBCore == nil then
            TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
            Citizen.Wait(200)
        end
    end
end)

-- Code

local CurrentPings = {}

local CurrentPings = {}

RegisterNetEvent('qb-pings:client:DoPing')
AddEventHandler('qb-pings:client:DoPing', function(id)
    local player = GetPlayerFromServerId(id)
    local ped = GetPlayerPed(player)
    local pos = GetEntityCoords(ped)
    local coords = {
        x = pos.x,
        y = pos.y,
        z = pos.z,
    }
    if not exports['qb-policejob']:IsHandcuffed() then
        TriggerServerEvent('qb-pings:server:SendPing', id, coords)
    else
        QBCore.Functions.Notify('You cannot currently send pings.', 'error')
    end
end)

RegisterNetEvent('qb-pings:client:AcceptPing')
AddEventHandler('qb-pings:client:AcceptPing', function(PingData, SenderData)
    local ped = GetPlayerPed(-1)
    local pos = GetEntityCoords(ped)

    if not exports['qb-policejob']:IsHandcuffed() then
        TriggerServerEvent('qb-pings:server:SendLocation', PingData, SenderData)
    else
        QBCore.Functions.Notify('You cannot currently accept the ping.', 'error')
    end
end)

RegisterNetEvent('qb-pings:client:SendLocation')
AddEventHandler('qb-pings:client:SendLocation', function(PingData, SenderData)
    QBCore.Functions.Notify('The location is indicated on your map with a blip.', 'success')

    CurrentPings[PingData.sender] = AddBlipForCoord(PingData.coords.x, PingData.coords.y, PingData.coords.z)
    SetBlipSprite(CurrentPings[PingData.sender], 280)
    SetBlipDisplay(CurrentPings[PingData.sender], 4)
    SetBlipScale(CurrentPings[PingData.sender], 1.1)
    SetBlipAsShortRange(CurrentPings[PingData.sender], false)
    SetBlipColour(CurrentPings[PingData.sender], 0)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName(SenderData.PlayerData.charinfo.firstname.." "..SenderData.PlayerData.charinfo.lastname)
    EndTextCommandSetBlipName(CurrentPings[PingData.sender])

    SetTimeout(5 * (60 * 1000), function()
        QBCore.Functions.Notify('Ping '..PingData.sender..' expired..', 'error')
        RemoveBlip(CurrentPings[PingData.sender])
        CurrentPings[PingData.sender] = nil
    end)
end)