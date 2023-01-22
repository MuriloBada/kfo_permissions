local hasJob

RegisterCommand('addjob', function(source, args)
    local _source = source
    TriggerEvent('redemrp:getPlayerFromId', _source, function(user)
        if exports.kfo_permissions.checkPlayerJob(_source, 'Admin', user.getIdentifier(), user.getSessionVar('charid')) then
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
                    TriggerClientEvent('kfo_permissions:reloadPermission', _source)
                end)
                
            else
                TriggerClientEvent('redem_roleplay:Tip', _source, "Você deve usar /addjob [id] [NomePermissao] [rank]", 7000)
            end
        else
            sendLogComandoAdminTentado(user.getIdentifier(), user.getSessionVar('charid'), '/addjob',args)
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
        if exports.kfo_permissions.checkPlayerJob(_source, 'Admin', user.getIdentifier(), user.getSessionVar('charid')) then
            if args[1] and args[2] then
                MySQL.Async.fetchAll('DELETE FROM kfo_permissions WHERE idplayer = @idplayer AND permission = @permission', {idplayer = tonumber(args[1]), permission = args[2]})
                TriggerClientEvent('redem_roleplay:Tip', _source, 'ID: '..args[1]..' foi removido com sucesso do set '..args[2], 7000)
                    TriggerClientEvent('kfo_permissions:reloadPermission', _source)
                    
            else
                TriggerClientEvent('redem_roleplay:Tip', _source, "Você deve usar /rmjob [id] [NomePermissao]", 7000)
            end
        else
            TriggerClientEvent('redem_roleplay:Tip', _source, "Você não tem permissão para acessar esse comando.", 7000)
            sendLogComandoAdminTentado(user.getIdentifier(), user.getSessionVar('charid'), '/rmjob',args)
        end
    end)
end)

exports('checkPlayerJob', function(job, identifier, charid)
    local hasPerm = promise.new()
    local result1 = getPlayerPermanentID(identifier, charid)
    if result1 then
        local result2 = getPlayerPermission(result1[1].id, job)
        if result2[1] then
            hasPerm:resolve(true) 
        else 
            hasPerm:resolve(false) 
        end
    end
    return Citizen.Await(hasPerm)
end)

exports('getPlayerVariables', function(playerID) 
    local result = MySQL.Async.fetchAll('SELECT * FROM CHARACTERS WHERE ID = @playerID', {playerID = playerID})
    if result[1] then
        return result[1].charid, result[1].identifier
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

function getPlayerFullName(identifier, charid)
    local obj = MySQL.Sync.fetchAll('SELECT * FROM CHARACTERS WHERE identifier=@identifier and characterid = @charid', {
        ['identifier'] = identifier, 
        ['charid'] = charid
    })

    return obj[1].firstname..' '..obj[1].lastname
end

-- TPS NOT WORKING YET

-- RegisterCommand('tptome', function(source, args)
--     local _source = source
--     TriggerEvent('redemrp:getPlayerFromId', _source, function(user)
--         if user.getGroup() == 'superadmin' and _source ~= 0 then
--             if tonumber(args[1]) > 0 then
--                 local targetPed = GetPlayerPed(args[1])
--                 local ped = GetPlayerPed(_source)
--                 local x,y,z = GetEntityCoords(ped)
--                 SetEntityCoords(targetPed, x, y, z, false, false, false, false)
--             else
--                 TriggerClientEvent('redem_roleplay:Tip', _source, "Você deve usar /tp [id].", 7000)
--             end
--         else
--             TriggerClientEvent('redem_roleplay:Tip', _source, "Você não tem permissão para acessar este comando.", 7000)
--         end
--     end)
-- end)


-- RegisterCommand('tpcds', function(source, args)
--     local _source = source
--     TriggerEvent('redemrp:getPlayerFromId', _source, function(user)
--         if user.getGroup() == 'superadmin' and _source ~= 0 then
--             local ped = GetPlayerPed(_source)
--             local x = args[1]
--             local y = args[2]
--             local z = args[3]

--             SetEntityCoords(ped, x, y, z, false, false, false, false)
--         else
--             TriggerClientEvent('redem_roleplay:Tip', _source, "Você não tem permissão para acessar este comando.", 7000)
--         end
--     end)
-- end)

-- RegisterCommand('tpcds,', function(source, args)
--     local _source = source
--     TriggerEvent('redemrp:getPlayerFromId', _source, function(user)
--         if user.getGroup() == 'superadmin' and _source ~= 0 then
--             local ped = GetPlayerPed(_source)
--             local x = args[3]
--             local y = args[6]
--             local z = args[9]

--             SetEntityCoords(ped, x, y, z, false, false, false, false)
--         else
--             TriggerClientEvent('redem_roleplay:Tip', _source, "Você não tem permissão para acessar este comando.", 7000)
--         end
--     end)
-- end)
