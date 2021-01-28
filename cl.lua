ESX = nil
local PlayerData = {}
local sleep = 2500

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)
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
    local elements = {}
    while true do
        local pPed = PlayerPedId()
        local pCoords = GetEntityCoords(pPed)
        for k,v in pairs(Ruq.Spawner) do
            local dist = #(pCoords - v)

            if dist < 1.5 then
                if PlayerData.job and PlayerData.job.name == "police" then
                    sleep = 1
                    DrawText3D(v.x, v.y, v.z, "Press ~g~[E]~s~ to access the police garage.")

                    if IsControlJustPressed(0, 38) then
                            ESX.UI.Menu.CloseAll()

                            table.insert(elements, {label = "Spawn vehicle", value = "spawnveh"})
                            table.insert(elements, {label = "Delete vehicle", value = "deleteveh"})
                            table.insert(elements, {label = "Close the menu", value = "close"})

                            ESX.UI.Menu.Open("default", GetCurrentResourceName(), "select", {
                                title = "Select an option",
                                align = "right",
                                elements = elements
                            }, function(data, menu)

                                if data.current.value == "spawnveh" then
                                    print("gay1")
                                    elements = {}
                                    print("setelements")
                                    for k,v in pairs(Ruq.Vehicles) do
                                        table.insert(elements, {modelName = v.modelName, label = v.label})
                                    end

                                    ESX.UI.Menu.Open("default", GetCurrentResourceName(), "spawnveh", {
                                        title = "Select a vehicle to spawn",
                                        align = "right",
                                        elements = elements
                                    }, function(data1, menu1)

                                    ESX.Game.SpawnVehicle(data1.current.modelName, vector3(454.6, -1017.4, 28.4), 100.0, function(vehicle)
                                        local plate = exports.esx_vehicleshop:GeneratePlate()
                                        SetVehicleNumberPlateText(vehicle, plate)
                                        SetPedIntoVehicle(pPed, vehicle, -1)
                                        SetVehicleDirtLevel(vehicle, 0.1)
                                        exports.LegacyFuel:SetFuel(vehicle, 100.0)
                                    end)

                                    ESX.UI.Menu.CloseAll()
                                    end, function(data1, menu1)
                                        menu1.close()
                                    end)
                                elseif data.current.value == "deleteveh" then
                                    if IsPedInAnyVehicle(pPed, false) then
                                        local myVeh = GetVehiclePedIsIn(pPed, false)
                                        ESX.Game.DeleteVehicle(myVeh)
                                        ESX.ShowNotification("Vehicle deleted successfully.")
                                    else
                                        ESX.ShowNotification("You are not in any vehicle.")
                                    end
                                elseif data.current.value == "close" then
                                    ESX.UI.Menu.CloseAll()
                                end
                            end, function(data, menu)
                                menu.close()
                            end)
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
