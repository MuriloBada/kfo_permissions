
--__________________________________[FUNCTIONS]_________________________________
local function GetPlayerEntity()
    local playerEntity = PlayerPedId()
    
    if IsPedOnMount(playerEntity) then
		playerEntity = GetMount(playerEntity)
    else
        if IsPedInAnyVehicle(playerEntity) then
            playerEntity = GetVehiclePedIsUsing(playerEntity)
        end
    end
    return playerEntity
end


function RotationToDirection(rotation)
	local adjustedRotation = {
        x = (math.pi / 180) * rotation.x,
		y = (math.pi / 180) * rotation.y,
		z = (math.pi / 180) * rotation.z
	}
	local direction = {
        x = -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
		y = math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
		z = math.sin(adjustedRotation.x)
	}
	return direction
end

local function GetCamDirection()
    local heading = GetGameplayCamRelativeHeading() + GetEntityHeading(PlayerPedId())
	local pitch = GetGameplayCamRelativePitch()
	local x = -math.sin(heading * math.pi / 180.0)
	local y = math.cos(heading * math.pi / 180.0)
	local z = math.sin(pitch * math.pi / 180.0)
	local len = math.sqrt(x * x + y * y + z *z)
    
    if len ~= 0 then
		x = x / len
		y = y / len
		z = z / len
	end
    return x, y, z
end
--______________________________________________________________________________

--___________________________________[COMMANDS]__________________________________
RegisterCommand("rotate",function()
    local _source = source
    TriggerServerEvent('redemrp:getPlayerFromId', function(user)
        if user.getGroup() == 'superadmin' and _source ~= 0 then
            local pped = PlayerPedId()
            local h = GetEntityRotation(pped)
            print(h)
        else
            TriggerClientEvent('redem_roleplay:Tip', _source, "Você não tem permissão para acessar este comando.", 7000)
        end
    end)
end)

RegisterCommand('dv', function(source, args, rawCommand)
    local _source = source
    TriggerServerEvent('redemrp:getPlayerFromId', function(user)
        if user.getGroup() == 'superadmin' and _source ~= 0 then
            local ped = PlayerPedId()
            local pedVector = GetEntityCoords(ped)

            local cameraRotation = GetGameplayCamRot()
            local cameraCoord = GetGameplayCamCoord()
            local direction = RotationToDirection(cameraRotation)
            local lastCoords = vec3(cameraCoord.x + direction.x * 10.0, cameraCoord.y + direction.y * 10.0, cameraCoord.z + direction.z * 10.0)

            local rayHandle = StartShapeTestRay(cameraCoord, lastCoords, -1, ped, 0)
            local _, hit, endCoords, _, entityHit = GetShapeTestResult(rayHandle)

            if hit == 1 and entityHit ~= 0 then
                SetEntityAsMissionEntity(entityHit, true, true)

                DeleteEntity(entityHit)
            end
        else
            TriggerClientEvent('redem_roleplay:Tip', _source, "Você não tem permissão para acessar este comando.", 7000)
        end
    end)
end)

RegisterCommand("status+", function (source, args, rawCommand)
    local _source = source
    TriggerServerEvent('redemrp_status:AddAmount', 100 , 100)
end)

RegisterCommand("status-", function (source, args, rawCommand)
    local _source = source
    TriggerServerEvent('redemrp_status:AddAmount', -100 , -100)
end)

RegisterCommand('tpw', function (source,args,rawCommand)
    local _source = source
    TriggerServerEvent('redemrp:getPlayerFromId', function(user)
        if user.getGroup() == 'superadmin' and _source ~= 0 then
            local ped = PlayerPedId()
            local waypoint = GetWaypointCoords(ped) 
            SetEntityCoords(ped, waypoint)
        else
            TriggerClientEvent('redem_roleplay:Tip', _source, "Você não tem permissão para acessar este comando.", 7000)
        end
    end)
end)

RegisterCommand('tpcds', function (source, args, rawCommand)
    local _source = source
    TriggerServerEvent('redemrp:getPlayerFromId', function(user)
        if user.getGroup() == 'superadmin' and _source ~= 0 then
            local x = args[1]
            local y = args[2]
            local z = args[3]
            print(x,y,z)
            local ped = PlayerPedId()
            SetEntityCoords(ped, tonumber(x), tonumber(y), tonumber(z))
        else
            TriggerClientEvent('redem_roleplay:Tip', _source, "Você não tem permissão para acessar este comando.", 7000)
        end
    end)
end)

RegisterCommand('tpcds2', function (source, args, rawCommand)
    local _source = source
    TriggerServerEvent('redemrp:getPlayerFromId', function(user)
        if user.getGroup() == 'superadmin' and _source ~= 0 then
            local x = args[3]
            local y = args[6]
            local z = args[9]
            
            local ped = PlayerPedId()
            SetEntityCoords(ped, tonumber(x), tonumber(y), tonumber(z))
        else
            TriggerClientEvent('redem_roleplay:Tip', _source, "Você não tem permissão para acessar este comando.", 7000)
        end
    end)
end)

RegisterCommand('veh', function(source, args, rawCommand)
    local _source = source
    TriggerServerEvent('redemrp:getPlayerFromId', function(user)
        if user.getGroup() == 'superadmin' and _source ~= 0 then
            local car = GetHashKey(args[1])

            RequestModel(car)
            while not HasModelLoaded(car) do
                RequestModel(car)
                Citizen.Wait(0)
            end

            local rotate = GetEntityRotation(PlayerPedId())

            local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
            vehicle2 = CreateVehicle(car, x, y, z, rotate[3], true, false)
            SetEntityAsMissionEntity(vehicle2, true, true)
            SetVehicleOnGroundProperly(vehicle2)
            SetModelAsNoLongerNeeded(car)
        else
            TriggerClientEvent('redem_roleplay:Tip', _source, "Você não tem permissão para acessar este comando.", 7000)
        end
    end)
end)
--______________________________________________________________________________


--____________________________________[EVENTS]___________________________________
RegisterNetEvent("Spawnped")
AddEventHandler("Spawnped",function(pedModel, outfit)
    local _source = source
    TriggerServerEvent('redemrp:getPlayerFromId', function(user)
        if user.getGroup() == 'superadmin' and _source ~= 0 then
            local pedModelHash = GetHashKey(pedModel)
            if not IsModelValid(pedModelHash) then
                print("model is not valid")
                return
            end

            if not HasModelLoaded(pedModelHash) then
                RequestModel(pedModelHash)
                while not HasModelLoaded(pedModelHash) do
                    Citizen.Wait(10)
                end
            end

            local ped = CreatePed(pedModelHash, GetEntityCoords(PlayerPedId()), GetEntityHeading(PlayerPedId()), 1, 0)
            Citizen.InvokeNative(0x283978A15512B2FE, ped, true)
            Citizen.InvokeNative(0x58A850EAEE20FAA3, ped)

            SetEntityAsMissionEntity(ped)

            SetPedAsGroupMember(ped, GetDefaultRelationshipGroupHash(pedModelHash))

            Citizen.InvokeNative(0xC80A74AC829DDD92, ped, GetDefaultRelationshipGroupHash(pedModelHash))

            if outfit ~= nil then
                SetPedOutfitPreset(ped, tonumber(outfit))
                Citizen.InvokeNative(0x7528720101A807A5, ped, 2)
            end
        else
            TriggerClientEvent('redem_roleplay:Tip', _source, "Você não tem permissão para acessar este comando.", 7000)
        end
    end)
end)

RegisterNetEvent('printCharID')
AddEventHandler('printCharID', function(obj)
    print('======================= CHAR USUARIO ==============================')
    for k,v in ipairs(obj) do
        print(k..'# Hex:'..v.identifier..' charID: '..v.characterid..' '..v.firstname..' '..v.lastname)
    end
    print('===================================================================')
end)

local noclip = false

RegisterNetEvent('Noclip', function()
    local playerEntity = GetPlayerEntity()
    noclip = not noclip
    SetEntityInvincible(playerEntity, noclip)
    SetEntityVisible(playerEntity, not noclip)
    SetEntityCollision(playerEntity, not noclip, not noclip)

	while noclip do
        local playerPosition = GetEntityCoords(playerEntity)
        local x, y, z = playerPosition.x, playerPosition.y, playerPosition.z
        local dx, dy, dz = GetCamDirection()
        local speed = 1.0

        SetEntityVelocity(playerEntity, 0.0001, 0.0001, 0.0001)

        if IsControlPressed(0, 0xD9D0E1C0) then
            speed = speed + 10.0
        end

        if IsControlPressed(0, 0xDB096B85) then
            speed = speed - 0.9
        end

        if IsControlPressed(0, 0x8FFC75D6) then
            speed = speed + 3.0
        end

        if IsControlPressed(0, 0x8FD015D8) then
            x = x + speed * dx
            y = y + speed * dy
            z = z + speed * dz
        end

        if IsControlPressed(0, 0xD27782E3) then
            x = x - speed * dx
			y = y - speed * dy
			z = z - speed * dz
        end

        SetEntityCoordsNoOffset(playerEntity, x, y, z, true, true, true)
        Wait(0)
    end
end)

--______________________________________________________________________________