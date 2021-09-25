local Pings = {}

QBCore.Commands.Add("ping", "", {{name = "action", help="id | accept | deny"}}, true, function(source, args)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local task = args[1]
    local PhoneItem = Player.Functions.GetItemByName("phone")

    if PhoneItem ~= nil then
        if task == "accept" then
            if Pings[src] ~= nil then
                TriggerClientEvent('wolf-pings:client:AcceptPing', src, Pings[src], QBCore.Functions.GetPlayer(Pings[src].sender))
                TriggerClientEvent('QBCore:Notify', Pings[src].sender, Player.PlayerData.charinfo.firstname.." "..Player.PlayerData.charinfo.lastname.." accepted your ping!")
                Pings[src] = nil
            else
                TriggerClientEvent('QBCore:Notify', src, "You have no ping open.", "error")
            end
        elseif task == "deny" then
            if Pings[src] ~= nil then
                TriggerClientEvent('QBCore:Notify', Pings[src].sender, "Your ping has been rejected ..", "error")
                TriggerClientEvent('QBCore:Notify', src, "You turned down the ping..", "success")
                Pings[src] = nil
            else
                TriggerClientEvent('QBCore:Notify', src, "You have no ping open ..", "error")
            end
        else
            TriggerClientEvent('wolf-pings:client:DoPing', src, tonumber(args[1]))
        end
    else
        TriggerClientEvent('QBCore:Notify', src, "You don't have a phone ..", "error")
    end
end)

RegisterServerEvent('wolf-pings:server:SendPing')
AddEventHandler('wolf-pings:server:SendPing', function(id, coords)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local Target = QBCore.Functions.GetPlayer(id)
    local PhoneItem = Player.Functions.GetItemByName("phone")

    if PhoneItem ~= nil then
        if Target ~= nil then
            local OtherItem = Target.Functions.GetItemByName("phone")
            if OtherItem ~= nil then
                TriggerClientEvent('QBCore:Notify', src, "You have sent a ping to "..Target.PlayerData.charinfo.firstname.." "..Target.PlayerData.charinfo.lastname)
                Pings[id] = {
                    coords = coords,
                    sender = src,
                    receiver = id,
                }
                TriggerClientEvent('QBCore:Notify', id, "You have received a ping from "..Player.PlayerData.charinfo.firstname.." "..Player.PlayerData.charinfo.lastname..". /ping 'accept | deny'")
            else
                TriggerClientEvent('QBCore:Notify', src, "Could not send ping .. Person may be out of range.", "error")
            end
        else
            TriggerClientEvent('QBCore:Notify', src, "This person is not in town ..", "error")
        end
    else
        TriggerClientEvent('QBCore:Notify', src, "You don't have a phone..", "error")
    end
end)

RegisterServerEvent('wolf-pings:server:SendLocation')
AddEventHandler('wolf-pings:server:SendLocation', function(PingData, SenderData)
    TriggerClientEvent('wolf-pings:client:SendLocation', PingData.receiver, PingData, SenderData)
end)