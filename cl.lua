ESX = nil
local PlayerData = {}
local sleep = 2500

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
    end
end)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(xPlayer)
	PlayerData = xPlayer
end)

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function(job)
	PlayerData.job = job
end)

Citizen.CreateThread(function()
    while true do
        for k,v in pairs(Ruq.Spawner) do
            local pPed = PlayerPedId()
            local elements = {}
            local pCoords = GetEntityCoords(pPed)
            local dist = #(pCoords - v)

            if dist < 1.5 then
                sleep = 1
                DrawText3D(v.x, v.y, v.z, "Press ~g~[E]~s~ to access the police garage.")

                if IsControlJustPressed(0, 38) then
                    if PlayerData.job and PlayerData.job.name == 'police' then
                        ESX.UI.Menu.CloseAll()

                        for k,v in pairs(Ruq.Vehicles) do
                            table.insert(elements, {modelName = v.modelName, label = v.label})
                        end

                        ESX.UI.Menu.Open("default", GetCurrentResourceName(), "spawnmenu", {
                            title = "Police Garage",
                            align = "right",
                            elements = elements
                        }, function(data, menu)

                            ESX.Game.SpawnVehicle(data.current.modelName, vector3(454.6, -1017.4, 28.4), 100.0, function(vehicle)
                                local plate = exports.esx_vehicleshop:GeneratePlate()
                                SetVehicleNumberPlateText(vehicle, plate)
                                SetPedIntoVehicle(pPed, vehicle, -1)
                                SetVehicleDirtLevel(vehicle, 0.1)
                                exports.LegacyFuel:SetFuel(vehicle, 100.0)
                            end)

                            ESX.UI.Menu.CloseAll()
                        end, function(data, menu)
                            menu.close()
                        end)
                    else
                        ESX.ShowNotification("Sorry, only polices can enter the police garage.")
                    end
                end
            elseif dist < 10.0 then
                sleep = 1
                DrawMarker(20, v.x, v.y, v.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 50, 205, 50, 128, false, false, 2, true, nil, nil, false)
            end
        end

        Citizen.Wait(sleep)
    end
end)

function DrawText3D(x, y, z, text)
    local onScreen,_x,_y=World3dToScreen2d(x, y, z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end
