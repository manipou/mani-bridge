local function SafeCrack(entity, locks, cb, createCam)
    if not DoesEntityExist(entity) then lib.print.error('SafeCrack: Entity does not exist') return end
    local ped = cache.ped
    local coords = GetEntityCoords(entity)
    local rotation = GetEntityRotation(entity)
    local dict = 'anim@scripted@heist@ig15_safe_crack@male@'
    local openedProp = GetHashKey('h4_prop_h4_safe_01b')
    local heading = GetEntityHeading(entity)
    
    lib.requestAnimDict(dict)

    local intro = NetworkCreateSynchronisedScene(coords.xy, coords.z - 0.05, rotation, 2, true, false, -1, 0, 1.0)
    NetworkAddPedToSynchronisedScene(ped, intro, dict, "enter_player", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(entity, intro, dict, "enter_safe", 1.0, 1.0, 1)
    if createCam then NetworkAddSynchronisedSceneCamera(intro, dict, 'enter_cam') end
    NetworkStartSynchronisedScene(intro)
    Wait(766)

    local idle = NetworkCreateSynchronisedScene(coords.xy, coords.z - 0.05, rotation, 2, true, true, -1, 0, 1.0)
    NetworkAddPedToSynchronisedScene(ped, idle, dict, "idle_player", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(entity, idle, dict, "idle_safe", 1.0, 1.0, 1)
    if createCam then NetworkAddSynchronisedSceneCamera(idle, dict, 'idle_cam') end
    NetworkStartSynchronisedScene(idle)

    local success = NetworkCreateSynchronisedScene(coords.xy, coords.z - 0.05, rotation, 2, true, false, -1, 0, 1.0)
    NetworkAddPedToSynchronisedScene(ped, success, dict, "door_open_player", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(entity, success, dict, "door_open_safe", 1.0, 1.0, 1)
    if createCam then  NetworkAddSynchronisedSceneCamera(success, dict, 'door_open_cam') end

    exports['st_minigames']:SafeCrack(true, locks, function(hasWon)
        if hasWon then
            lib.requestModel(openedProp)
            NetworkStartSynchronisedScene(success)
            Wait(2533)
            NetworkStopSynchronisedScene(success)

            DeleteEntity(entity)
            local openedSafe = CreateObject(openedProp, coords.x, coords.y, coords.z, true, true, true)
            SetEntityHeading(openedSafe, heading)

            cb(true, openedSafe)
        else
            NetworkStopSynchronisedScene(idle)
            cb(false, nil)
        end
    end)

    RemoveAnimDict(dict)
end

exports('SafeCrack', SafeCrack)

local function EletricBox(entity, cb, time)
    if not DoesEntityExist(entity) then lib.print.error('EletricBox: Entity does not exist') return end
    local ped = cache.ped
    local coords = GetEntityCoords(entity)
    local rotation = GetEntityRotation(entity)
    local dict = 'anim@scripted@player@mission@tun_control_tower@male@'
    
    lib.requestAnimDict(dict)

    local intro = NetworkCreateSynchronisedScene(coords.xyz, rotation, 2, true, false, -1, 0, 1.0)
    NetworkAddPedToSynchronisedScene(ped, intro, dict, "enter", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(entity, intro, dict, "enter_electric_box", 1.0, 1.0, 1)
    NetworkStartSynchronisedScene(intro)
    Wait(1566)

    local idle = NetworkCreateSynchronisedScene(coords.xyz, rotation, 2, false, true, -1, 0, 1.0)
    NetworkAddPedToSynchronisedScene(ped, idle, dict, "loop", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(entity, idle, dict, "loop_electric_box", 1.0, 1.0, 1)
    NetworkStartSynchronisedScene(idle)

    local exit = NetworkCreateSynchronisedScene(coords.xyz - 0.05, rotation, 2, true, false, -1, 0, 1.0)
    NetworkAddPedToSynchronisedScene(ped, exit, dict, "exit", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(entity, exit, dict, "exit_electric_box", 1.0, 1.0, 1)

    local hasWon = exports['elevate-minigames']:CircuitBreaker(1)
    if hasWon then
        NetworkStartSynchronisedScene(exit)
        Wait(2100)
        NetworkStopSynchronisedScene(exit)
        cb(true)
    else
        NetworkStartSynchronisedScene(exit)
        Wait(2100)
        NetworkStopSynchronisedScene(exit)
        cb(false)
    end

    RemoveAnimDict(dict)
end

exports('EletricBox', EletricBox)