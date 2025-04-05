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