local Framework, PlayerPed, MenuOpen = nil, nil, nil


Framework = GetFramework()
CreateThread(function()
    while Framework == nil do Citizen.Wait(750) end
    Citizen.Wait(2500)
end)

-- Functions

SendReactMessage = function(action, data)
    SendNUIMessage({
        action = action,
        data = data
    })
end

function OpenClose(data)
    MenuOpen = data
    SetNuiFocus(data, data)
    toggleRadioAnimation(data)
    SendReactMessage('setOpen', {
        OpenClose = data,
        PlayerID = GetPlayerServerId(PlayerId()),
        Language = Settings.Language, 
    })
end

-- Event

RegisterNetEvent("codem-radio:opencloseui", function(data)
    OpenClose(data)
end)

RegisterNetEvent("GetRadioPlayer", function(data)
    SendReactMessage('setPlayerID', data) 
end)
-- Command 

RegisterCommand(Settings.ResetCommad, function()
    SendReactMessage('setRadioReset') 
end)

-- NuiCallback 

RegisterNuiCallback("Close", function()
    OpenClose(false)
end)

RegisterNuiCallback("RadioLeave", function()
    TriggerServerEvent("setRadioChannel", 0)
    if Settings.Voice == "pma-voice" then 
        exports['pma-voice']:removePlayerFromRadio()
    elseif Settings.Voice == "saltychat" then
        exports["saltychat"]:RemovePlayerRadioChannel()
    elseif Settings.Voice == "mumble-voip" then
        exports["mumble-voip"]:removePlayerFromRadio()
    end 
end)

RegisterNuiCallback("setVolume", function(data)
    if Settings.Voice == "pma-voice" then 
        exports['pma-voice']:setRadioVolume(tonumber(data)) 
    elseif Settings.Voice == "saltychat" then
        exports["saltychat"]:SetRadioVolume(tonumber(data)) 
    end 
end)

RegisterNUICallback('setRadio', function(data)
    local RadioCode = data
    local isJob = false
    local JobControl = false
    local PlayerData = (Settings.Framework == "ESX" or Settings.Framework == "NewESX") and Framework.GetPlayerData() or Framework.Functions.GetPlayerData()

    if RadioCode ~= nil then
        if Settings.MaxFrequency > RadioCode then 
            if Settings.OnlyJob[RadioCode] and Settings.OnlyJob[RadioCode].RadioCode then 
                JobControl = true
                local radioJobs = Settings.OnlyJob[RadioCode].Jobs
                for _, job in pairs(radioJobs) do
                    if job == PlayerData.job.name then
                        isJob = true
                        break
                    end
                end
            else
                ConnectRadio(RadioCode)
            end
        end
    end

    if JobControl then 
        if isJob then
            ConnectRadio(RadioCode)
        else
            SendMessage(Settings.Language.encrypted, "error", "client") 
        end
    end
end)
