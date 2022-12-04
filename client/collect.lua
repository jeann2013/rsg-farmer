local QRCore = exports['qr-core']:GetCoreObject()

-- collect water
Citizen.CreateThread(function()
    while true do
        Wait(0)
        local pos, awayFromObject = GetEntityCoords(PlayerPedId()), true
        for i = 1, #Config.WaterProps do
            local waterObject = GetClosestObjectOfType(pos, 5.0, GetHashKey(Config.WaterProps[i]), false, false, false)
            if waterObject ~= 0 then
                local objectPos = GetEntityCoords(waterObject)
                if #(pos - objectPos) < 3.0 then
                    awayFromObject = false
                    DrawText3Ds(objectPos.x, objectPos.y, objectPos.z + 1.0, "Collect Water [J]")
                    if IsControlJustReleased(0, QRCore.Shared.Keybinds['J']) then 
                        TriggerEvent('rsg-farmer:client:collectwater')
                    end
                end
            end
        end
        if awayFromObject then
            Citizen.Wait(1000)
        end
    end
end)

---------------------------------------------------------------------------------

-- do collecting water
RegisterNetEvent('rsg-farmer:client:collectwater')
AddEventHandler('rsg-farmer:client:collectwater', function()
    local hasItem = QRCore.Functions.HasItem('bucket', 1)
    local PlayerJob = QRCore.Functions.GetPlayerData().job.name
    if PlayerJob == Config.JobRequired then
        if hasItem and PlayerJob == Config.JobRequired then
            QRCore.Functions.Progressbar("collecting-water", "Collecting Water..", Config.CollectWaterTime, false, true, {
                disableMovement = true,
                disableCarMovement = false,
                disableMouse = false,
                disableCombat = true,
            }, {}, {}, {}, function() -- Done
                TriggerServerEvent('rsg-farmer:server:giveitem', 'water', 1)
            end)
        else
            QRCore.Functions.Notify('you need a bucket!', 'error')
        end
    else
        QRCore.Functions.Notify('only farmers can collect water!', 'error')
    end
end)

---------------------------------------------------------------------------------

function DrawText3Ds(x, y, z, text)
    local onScreen,_x,_y=GetScreenCoordFromWorldCoord(x, y, z)
    SetTextScale(0.30, 0.30)
    SetTextFontForCurrentCommand(9)
    SetTextColor(255, 255, 255, 215)
    local str = CreateVarString(10, "LITERAL_STRING", text, Citizen.ResultAsLong())
    SetTextCentre(1)
    DisplayText(str,_x,_y)
end

---------------------------------------------------------------------------------
