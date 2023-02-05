local hasJob
local PlayerJobs = {}
RedEM = exports["redem_roleplay"]:RedEM()

RegisterCommand('addjob', function(source, args)
    local Player = RedEM.GetPlayer(source)
    if Player then
        if exports.kfo_permissions.checkPlayerJob(Player.source, 'Admin', Player.identifier, Player.charid) then
            if args[1] and args[2] and args[3] then
                local params = {
                    idplayer = tonumber(args[1]),
                    permission = args[2],
                    perm_lv = tonumber(args[3])
                }
                MySQL.Async.fetchAll('SELECT * FROM kfo_permissions WHERE idplayer = @idplayer and permission=@permission', {idplayer=tonumber(args[1]), permission=args[2]}, function(result)
                    if result[1] then
                        MySQL.Async.fetchAll('UPDATE kfo_permissions SET perm_lv=@perm_lv where id=@id', {perm_lv = args[3], id=result[1].id})
                        TriggerClientEvent('redem_roleplay:Tip', Player.source, 'ID: '..args[1]..' atualizado set '..args[2]..' com o rank '..args[3], 7000)
                    else
                        MySQL.Async.execute('INSERT INTO kfo_permissions (idplayer, permission, perm_lv) VALUES(@idplayer, @permission, @perm_lv)', params)
                        TriggerClientEvent('redem_roleplay:Tip', Player.source, 'ID: '..args[1]..' setado com sucesso como '..args[2]..' rank '..args[3], 7000)
                    end
                    sendLogComandoAdminUsado(Player.identifier, Player.charid, '/addjob', args)
                    TriggerClientEvent('kfo_permissions:reloadPermission', Player.source)
                end)
                
            else
                TriggerClientEvent('redem_roleplay:Tip', Player.source, "Você deve usar /addjob [id] [NomePermissao] [rank]", 7000)
            end
        else
            sendLogComandoAdminTentado(Player.identifier, Player.charid, '/addjob',args)
            TriggerClientEvent('redem_roleplay:Tip', Player.source, "Você não tem permissão para acessar esse comando.", 7000)
        end
    end
end)

RegisterCommand('id', function(source, args)
    local Player = RedEM.GetPlayer(source)
    if Player then
        identifier = Player.identifier
        charid = Player.charid
        MySQL.Async.fetchAll('SELECT * FROM CHARACTERS WHERE identifier=@identifier and characterid = @charid', {identifier = identifier, charid = charid}, function(result)
            TriggerClientEvent('redem_roleplay:Tip', Player.source, "Seu ID: "..result[1].id, 7000)        
        end)
    end
end)

RegisterCommand('rmjob', function(source, args)
    local Player = RedEM.GetPlayer(source)
    if Player then
        if exports.kfo_permissions.checkPlayerJob(_source, 'Admin', Player.identifier, Player.charid) then
            if args[1] and args[2] then
                MySQL.Async.fetchAll('DELETE FROM kfo_permissions WHERE idplayer = @idplayer AND permission = @permission', {idplayer = tonumber(args[1]), permission = args[2]})
                TriggerClientEvent('redem_roleplay:Tip', _source, 'ID: '..args[1]..' foi removido com sucesso do set '..args[2], 7000)
                    TriggerClientEvent('kfo_permissions:reloadPermission', _source)  
                    sendLogComandoAdminUsado(Player.identifier, Player.charid, '/rmjob', args)  
                else
                    TriggerClientEvent('redem_roleplay:Tip', _source, "Você deve usar /rmjob [id] [NomePermissao]", 7000)
                end
            else
                TriggerClientEvent('redem_roleplay:Tip', _source, "Você não tem permissão para acessar esse comando.", 7000)
            sendLogComandoAdminTentado(Player.identifier, Player.charid, '/rmjob',args)
        end
    end
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
    local result = MySQL.query('SELECT * FROM CHARACTERS WHERE ID = @playerID', {playerID = playerID})
    if result[1] then
        return result[1].charid, result[1].identifier
    end
end)

exports('getJobs', function()
    return PlayerJobs
end)

RegisterNetEvent('kfo_permissions:addPlayerToJobs')
AddEventHandler('kfo_permissions:addPlayerToJobs', function()
    local Player = RedEM.GetPlayer(source)
    if Player then
        local id = getPlayerPermanentID(Player.identifier, Player.charid)
        if id then
            if id[1] then
                local jobs = getPlayerPermissions(id[1].id)
                PlayerJobs[Player.source] = {}
                for k, v in pairs(jobs) do 
                    table.insert(PlayerJobs[Player.source], {jobName = jobs[k].permission, jobLevel = jobs[k].perm_lv})
                end
            end
        end
    end    
end)

function getPlayerPermanentID(identifier, charid)
    if MySQL ~= nil then
        return MySQL.query.await('SELECT * FROM CHARACTERS WHERE identifier=@identifier and characterid = @charid', {
            ['identifier'] = identifier, 
            ['charid'] = charid
        })
    end
end

function getPlayerPermission(id, permission)
    if MySQL ~= nil then
        return MySQL.query.await('SELECT * FROM KFO_PERMISSIONS WHERE idplayer = @idplayer and permission=@permission', {
            ['idplayer'] = id,
            ['permission'] = permission
        })
    end
end

function getPlayerPermissions(id)
    if MySQL ~= nil then
        return MySQL.query.await('SELECT * FROM KFO_PERMISSIONS WHERE idplayer = @idplayer', {
            ['idplayer'] = id,
        })
    end
end

function getPlayerFullName(identifier, charid)
    if MySQL ~= nil then
        local obj = MySQL.query.await('SELECT * FROM CHARACTERS WHERE identifier=@identifier and characterid = @charid', {
            ['identifier'] = identifier, 
            ['charid'] = charid
        })
        
        return obj[1].firstname..' '..obj[1].lastname
    end
end