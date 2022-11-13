local hasJob
RegisterCommand('addjob', function(source, args)
    local _source = source
    TriggerEvent('redemrp:getPlayerFromId', _source, function(user)
        if user.getGroup('superadmin') then
            if args[1] and args[2] and args[3] then
                local params = {
                    idplayer = tonumber(args[1]),
                    permission = args[2],
                    perm_lv = tonumber(args[3])
                }
                MySQL.Async.fetchAll('SELECT * FROM kfo_permissions WHERE idplayer = @idplayer and permission=@permission', {idplayer=tonumber(args[1]), permission=args[2]}, function(result)
                    if result[1] then
                        MySQL.Async.fetchAll('UPDATE kfo_permissions SET perm_lv=@perm_lv where id=@id', {perm_lv = args[3], id=result[1].id})
                        TriggerClientEvent('redem_roleplay:Tip', _source, 'ID: '..args[1]..' atualizado set '..args[2]..' com o rank '..args[3], 7000)
                    else
                        MySQL.Async.execute('INSERT INTO kfo_permissions (idplayer, permission, perm_lv) VALUES(@idplayer, @permission, @perm_lv)', params)
                        TriggerClientEvent('redem_roleplay:Tip', _source, 'ID: '..args[1]..' setado com sucesso como '..args[2]..' rank '..args[3], 7000)
                    end
                end)
                
            else
                TriggerClientEvent('redem_roleplay:Tip', _source, "Você deve usar /addjob [id] [NomePermissao] [rank]", 7000)
            end
        else
            TriggerClientEvent('redem_roleplay:Tip', _source, "Você não tem permissão para acessar esse comando.", 7000)
        end
    end)
end)

RegisterCommand('id', function(source, args)
    local _source = source
    local identifier, charid
    TriggerEvent('redemrp:getPlayerFromId', _source, function(user)
        identifier = user.getIdentifier()
        charid = user.getSessionVar('charid')
        MySQL.Async.fetchAll('SELECT * FROM CHARACTERS WHERE identifier=@identifier and characterid = @charid', {identifier = identifier, charid = charid}, function(result)
            TriggerClientEvent('redem_roleplay:Tip', _source, "Seu ID: "..result[1].id, 7000)        
        end)
    end)
    
end)

RegisterCommand('rmjob', function(source, args)
    local _source = source
    TriggerEvent('redemrp:getPlayerFromId', _source, function(user)
        if user.getGroup('superadmin') then
            if args[1] and args[2] then
                MySQL.Async.fetchAll('DELETE FROM kfo_permissions WHERE idplayer = @idplayer AND permission = @permission', {idplayer = tonumber(args[1]), permission = args[2]})
                TriggerClientEvent('redem_roleplay:Tip', _source, 'ID: '..args[1]..' foi removido com sucesso do set '..args[2], 7000)

            else
                TriggerClientEvent('redem_roleplay:Tip', _source, "Você deve usar /rmjob [id] [NomePermissao]", 7000)
            end
        else
            TriggerClientEvent('redem_roleplay:Tip', _source, "Você não tem permissão para acessar esse comando.", 7000)
        end
    end)
end)


RegisterServerEvent('kfo_permissions:checkPlayerJob')
AddEventHandler('kfo_permissions:checkPlayerJob', function(job)
    local _source = source
    local identifier, charid
    TriggerEvent('redemrp:getPlayerFromId', _source, function(user)
        identifier = user.getIdentifier()
        charid = user.getSessionVar('charid')
    end)

    local result1 = getPlayerPermanentID(identifier, charid)

    if result1 then
        local result2 = getPlayerPermission(result1[1].id, job)
        if result2[1] then 
            TriggerClientEvent('handlePermissionCheck', _source, true)
        else 
            TriggerClientEvent('handlePermissionCheck', _source, false)
        end
    end
end)

function getPlayerPermanentID(identifier, charid)
   return MySQL.Sync.fetchAll('SELECT * FROM CHARACTERS WHERE identifier=@identifier and characterid = @charid', {
        ['identifier'] = identifier, 
        ['charid'] = charid
    })
end

function getPlayerPermission(id, permission)
    return MySQL.Sync.fetchAll('SELECT * FROM KFO_PERMISSIONS WHERE idplayer = @idplayer and permission=@permission', {
        ['idplayer'] = id,
        ['permission'] = permission
    })
end

RegisterCommand('charusuario', function(source, args)
    local _source = source
    TriggerEvent('redemrp:getPlayerFromId', _source, function(user)
        if args[1] then
            MySQL.Async.fetchAll("SELECT * FROM characters WHERE identifier = @identifier", {identifier = args[1]}, function(result)
                if result[1] then
                    TriggerClientEvent('redem_roleplay:Tip', _source, 'Verifique seu F8.', 7000)
                    TriggerClientEvent('printCharID', _source, result)
                end
            end)
        else
            TriggerClientEvent('redem_roleplay:Tip', _source, "Você deve usar /charusuario [hex]", 7000)
        end
    end)
end)


RegisterCommand('setped', function(source, args)
    local _source = source
    TriggerEvent('redemrp:getPlayerFromId', _source, function(user)
        if user.getGroup() == 'superadmin' and _source ~= 0 then
            if args[1] and args[2] and args[3] then
                MySQL.Async.fetchAll("SELECT * FROM skins WHERE identifier = @identifier and charid = @charid", {identifier = args[1], charid = tonumber(args[3])}, function(result)
                    if result[1] then
                        local skin = json.decode(result[1].skin)
                        skin.model = args[2]
                        MySQL.Async.execute("UPDATE skins SET skin = @skin where identifier = @identifier and charid = @charid", {skin = json.encode(skin), identifier = args[1], charid = tonumber(args[3])})
                    end
                end)
                TriggerClientEvent('redem_roleplay:Tip', _source, "Ped "..args[2]..' setado com sucesso para '..args[1]..' charID: ['..args[3]..']', 7000)
            else
                TriggerClientEvent('redem_roleplay:Tip', _source, "Você deve usar /setped [hex] [nome_ped] [charID] ", 7000)
            end
        else
            TriggerClientEvent('redem_roleplay:Tip', _source, "Você não tem permissão para acessar este comando.", 7000)
        end
    end)
end)

RegisterCommand("nc", function(source, args, rawCommand)
    local _source = source
    TriggerEvent('redemrp:getPlayerFromId', _source, function(user)
        
        if user.getGroup() == 'superadmin' and _source ~= 0 then
            TriggerClientEvent('Noclip', source)
        else
            TriggerClientEvent('nopermissionnotify', source)
        end
    end)
end)

RegisterCommand("spawnped",function(source, args, rawCommand)
    local _source = source
    TriggerEvent('redemrp:getPlayerFromId', _source, function(user)
        if user.getGroup() == 'superadmin' and _source ~= 0 then
            if #args >= 1 then
                if args[2] ~= nil then
                    TriggerClientEvent("Spawnped", source, args[1], tonumber(args[2]))
                    
                else
                    TriggerClientEvent("Spawnped", source, args[1])
                end
            end
        else
            TriggerClientEvent('redem_roleplay:Tip', _source, "Você não tem permissão para acessar este comando.", 7000)
        end
    end)
end)

RegisterCommand('tp', function(source, args)
    local _source = source
end)

RegisterCommand('tptome', function(source, args)
    local _source = source
end)