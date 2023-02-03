Citizen.CreateThread(function ()
    Wait(1000)
    TriggerEvent('chat:addSuggestion','/addjob', 'Seta Um player', {
        {name = "ID", help = "ID Fixo"},
        {name = "Permissão", help = "Nome do Set"},
        {name = "Rank", help = "Nível do Rank"},
    })
    TriggerEvent('chat:addSuggestion','/id', 'Veja seu ID fixo', {})

    TriggerEvent('chat:addSuggestion','/rmjob', 'Remove o set de um player', {
        {name = "ID", help = "ID Fixo"},
        {name = "Permissão", help = "Nome do Set"},
    })
end)

AddEventHandler('playerSpawned', function()
    TriggerServerEvent('kfo_permissions:addPlayerToJobs')
end)

AddEventHandler('onResourceStart', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        Citizen.CreateThread(function()
            TriggerServerEvent('kfo_permissions:addPlayerToJobs')
        end)
    end
end)