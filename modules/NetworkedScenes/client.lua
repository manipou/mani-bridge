local function SafeCrack(entity, locks, cb, createCam)
    if not DoesEntityExist(entity) then lib.print.error('SafeCrack: Entity does not exist') return end

    while NetworkGetEntityOwner(entity) ~= PlayerId() do
        NetworkRequestControlOfEntity(entity)
        Wait(100)
    end

    local ped = cache.ped
    local coords = GetEntityCoords(entity)
    local rotation = GetEntityRotation(entity)
    local dict = 'anim@scripted@heist@ig15_safe_crack@male@'
    local openedProp = GetHashKey('h4_prop_h4_safe_01b')
    local heading = GetEntityHeading(entity)
    
    lib.requestAnimDict(dict)

    local intro = NetworkCreateSynchronisedScene(coords.xy, coords.z - 0.05, rotation, 2, true, false, -1, 0, 1.0)
    NetworkAddPedToSynchronisedScene(ped, intro, dict, 'enter_player', 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(entity, intro, dict, 'enter_safe', 1.0, 1.0, 1)
    if createCam then NetworkAddSynchronisedSceneCamera(intro, dict, 'enter_cam') end
    NetworkStartSynchronisedScene(intro)
    Wait(766)

    local idle = NetworkCreateSynchronisedScene(coords.xy, coords.z - 0.05, rotation, 2, true, true, -1, 0, 1.0)
    NetworkAddPedToSynchronisedScene(ped, idle, dict, 'idle_player', 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(entity, idle, dict, 'idle_safe', 1.0, 1.0, 1)
    if createCam then NetworkAddSynchronisedSceneCamera(idle, dict, 'idle_cam') end
    NetworkStartSynchronisedScene(idle)

    local success = NetworkCreateSynchronisedScene(coords.xy, coords.z - 0.05, rotation, 2, true, false, -1, 0, 1.0)
    NetworkAddPedToSynchronisedScene(ped, success, dict, 'door_open_player', 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(entity, success, dict, 'door_open_safe', 1.0, 1.0, 1)
    if createCam then  NetworkAddSynchronisedSceneCamera(success, dict, 'door_open_cam') end

    exports['st_minigames']:SafeCrack(true, locks, function(hasWon)
        if hasWon then
            lib.requestModel(openedProp)
            NetworkStartSynchronisedScene(success)
            Wait(2533)
            NetworkStopSynchronisedScene(success)

            DeleteEntity(entity)
            
            local OpenedSafe = exports['mani-bridge']:CreateObj(openedProp, vec4(coords.x, coords.y, coords.z, heading))

            cb(true, OpenedSafe)
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

    while NetworkGetEntityOwner(entity) ~= PlayerId() do
        NetworkRequestControlOfEntity(entity)
        Wait(100)
    end

    local ped = cache.ped
    local coords = GetEntityCoords(entity)
    local rotation = GetEntityRotation(entity)
    local dict = 'anim@scripted@player@mission@tun_control_tower@male@'
    
    lib.requestAnimDict(dict)

    local intro = NetworkCreateSynchronisedScene(coords.xyz, rotation, 2, true, false, -1, 0, 1.0)
    NetworkAddPedToSynchronisedScene(ped, intro, dict, 'enter', 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(entity, intro, dict, 'enter_electric_box', 1.0, 1.0, 1)
    NetworkStartSynchronisedScene(intro)
    Wait(1566)

    local idle = NetworkCreateSynchronisedScene(coords.xyz, rotation, 2, false, true, -1, 0, 1.0)
    NetworkAddPedToSynchronisedScene(ped, idle, dict, 'loop', 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(entity, idle, dict, 'loop_electric_box', 1.0, 1.0, 1)
    NetworkStartSynchronisedScene(idle)

    local exit = NetworkCreateSynchronisedScene(coords.xyz - 0.05, rotation, 2, true, false, -1, 0, 1.0)
    NetworkAddPedToSynchronisedScene(ped, exit, dict, 'exit', 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(entity, exit, dict, 'exit_electric_box', 1.0, 1.0, 1)

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

local function OpenContainer(entity, cb)
    if not DoesEntityExist(entity) then lib.print.error('OpenContainer: Entity does not exist') return end

    while NetworkGetEntityOwner(entity) ~= PlayerId() do
        NetworkRequestControlOfEntity(entity)
        Wait(100)
    end

    local ped = cache.ped
    local coords = GetEntityCoords(entity)
    local rotation = GetEntityRotation(entity)
    local dict = 'anim@scripted@player@mission@tunf_train_ig1_container_p1@male@'
    local bagModel = GetHashKey('hei_p_m_bag_var22_arm_s')
    local grinderModel = GetHashKey('tr_prop_tr_grinder_01a')
    local lockModel = GetHashKey('tr_prop_tr_lock_01a')
    local heading = GetEntityHeading(entity)
    
    lib.requestAnimDict(dict)
    lib.requestModel(bagModel)
    lib.requestModel(grinderModel)
    lib.requestModel(lockModel)
    lib.requestNamedPtfxAsset('scr_tn_tr')

    local bagProp = CreateObject(bagModel, coords.x, coords.y, coords.z, true, true, true)
    local grinderProp = CreateObject(grinderModel, coords.x, coords.y, coords.z, true, true, true)
    local lockProp = CreateObject(lockModel, coords.x, coords.y, coords.z, true, true, true)

    SetEntityCollision(bagProp, false, true)
    SetEntityCollision(grinderProp, false, true)
    SetEntityCollision(lockProp, false, true)

    local scene = NetworkCreateSynchronisedScene(coords.xy, coords.z - 0.05, rotation, 2, true, false, -1, 0, 1.0)
    NetworkAddPedToSynchronisedScene(ped, scene, dict, 'action', 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bagProp, scene, dict, 'action_bag', 1.0, 1.0, 1)
    NetworkAddEntityToSynchronisedScene(grinderProp, scene, dict, 'action_angle_grinder', 1.0, 1.0, 1)
    NetworkAddEntityToSynchronisedScene(lockProp, scene, dict, 'action_lock', 1.0, 1.0, 1)
    
    local propScene = NetworkCreateSynchronisedScene(coords.xy, coords.z - 0.05, rotation, 2, true, false, -1, 0, 1.0)
    NetworkAddEntityToSynchronisedScene(entity, propScene, dict, 'action_container', 1.0, 1.0, 1)

    NetworkStartSynchronisedScene(scene)
    NetworkStartSynchronisedScene(propScene)

    Wait(4000)
    UseParticleFxAssetNextCall('scr_tn_tr')
    local particles = StartParticleFxLoopedOnEntity('scr_tn_tr_angle_grinder_sparks', grinderProp, 0.0, 0.25, 0.0, 0.0, 0.0, 0.0, 1.0, false, false, false, 1065353216, 1065353216, 1065353216, 1)
    Wait(1000)
    StopParticleFxLooped(particles, 1)

    Wait(2000)

    cb()

    Wait(3400)

    DeleteEntity(bagProp)
    DeleteEntity(grinderProp)
    DeleteEntity(lockProp)

    SetEntityCollision(entity, false, true)

    RemoveAnimDict(dict)
    SetModelAsNoLongerNeeded(bagModel)
    SetModelAsNoLongerNeeded(grinderModel)
    SetModelAsNoLongerNeeded(lockModel)
    RemoveNamedPtfxAsset('scr_tn_tr')
end

exports('OpenContainer', OpenContainer)

local function OpenCrate(entity, cb)
    if not DoesEntityExist(entity) then lib.print.error('OpenContainer: Entity does not exist') return end

    while NetworkGetEntityOwner(entity) ~= PlayerId() do
        NetworkRequestControlOfEntity(entity)
        Wait(100)
    end

    local ped = cache.ped
    local coords = GetEntityCoords(entity)
    local rotation = GetEntityRotation(entity)
    local dict = 'anim@scripted@player@mission@trn_ig2_empty@male@'
    local crowbarModel = GetHashKey('w_me_crowbar')
    local heading = GetEntityHeading(entity)
    
    lib.requestAnimDict(dict)
    lib.requestModel(crowbarModel)

    local crowbarProp = CreateObject(crowbarModel, coords.x, coords.y, coords.z, true, true, true)

    SetEntityCollision(crowbarProp, false, true)

    local scene = NetworkCreateSynchronisedScene(coords.xy, coords.z - 0.05, rotation, 2, true, false, -1, 0, 1.0)
    NetworkAddPedToSynchronisedScene(ped, scene, dict, 'empty', 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(crowbarProp, scene, dict, 'empty_crowbar', 1.0, 1.0, 1)
    
    local propScene = NetworkCreateSynchronisedScene(coords.xy, coords.z - 0.05, rotation, 2, true, false, -1, 0, 1.0)
    NetworkAddEntityToSynchronisedScene(entity, propScene, dict, 'empty_crate', 1.0, 1.0, 1)

    NetworkStartSynchronisedScene(scene)
    NetworkStartSynchronisedScene(propScene)

    Wait(5000)

    cb()

    Wait(1000)

    DeleteEntity(crowbarProp)

    RemoveAnimDict(dict)
    SetModelAsNoLongerNeeded(crowbarModel)
end

exports('OpenCrate', OpenCrate)

local function HackUSB(minigame, cb)
    local ped = cache.ped
    local coords = GetOffsetFromEntityInWorldCoords(ped, 0.075, 0.84, 0.35)
    local rotation = GetEntityRotation(ped)
    local dict = 'anim@scripted@player@mission@tunf_hack_keypad@male@'
    local phoneModel = GetHashKey('prop_npc_phone')
    local usbModel = GetHashKey('tr_prop_tr_usb_drive_01a')
    local heading = GetEntityHeading(ped)

    lib.requestAnimDict(dict)
    lib.requestModel(phoneModel)
    lib.requestModel(usbModel)

    local phoneProp = CreateObject(phoneModel, coords.x, coords.y, coords.z, true, true, true)
    local usbProp = CreateObject(usbModel, coords.x, coords.y, coords.z, true, true, true)

    SetEntityCollision(phoneProp, false, true)
    SetEntityCollision(usbProp, false, true)

    local scene = NetworkCreateSynchronisedScene(coords.xy, coords.z, rotation, 2, true, false, -1, 0, 1.0)
    NetworkAddPedToSynchronisedScene(ped, scene, dict, 'action', 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(phoneProp, scene, dict, 'action_phone', 1.0, 1.0, 1)
    NetworkAddEntityToSynchronisedScene(usbProp, scene, dict, 'action_usb_drive', 1.0, 1.0, 1)

    NetworkStartSynchronisedScene(scene)

    Wait(4566)

    local loopScene = NetworkCreateSynchronisedScene(coords.xy, coords.z, rotation, 2, true, true, -1, 0, 1.0)
    NetworkAddPedToSynchronisedScene(ped, loopScene, dict, 'hack_loop', 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(phoneProp, loopScene, dict, 'hack_loop_phone', 1.0, 1.0, 1)
    NetworkAddEntityToSynchronisedScene(usbProp, loopScene, dict, 'hack_loop_usb_drive', 1.0, 1.0, 1)

    NetworkStartSynchronisedScene(loopScene)

    minigame(function(success)
        cb(success)
    end)

    local exitScene = NetworkCreateSynchronisedScene(coords.xy, coords.z, rotation, 2, true, true, -1, 0, 1.0)
    NetworkAddPedToSynchronisedScene(ped, exitScene, dict, 'exit', 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(phoneProp, exitScene, dict, 'exit_phone', 1.0, 1.0, 1)
    NetworkAddEntityToSynchronisedScene(usbProp, exitScene, dict, 'exit_usb_drive', 1.0, 1.0, 1)

    NetworkStartSynchronisedScene(exitScene)

    Wait(3600)

    DeleteEntity(phoneProp)
    DeleteEntity(usbProp)

    RemoveAnimDict(dict)
    SetModelAsNoLongerNeeded(phoneModel)
    SetModelAsNoLongerNeeded(usbModel)
end

exports('HackUSB', HackUSB)

local function HackPhone(minigame, cb)
    local ped = cache.ped
    local coords = GetOffsetFromEntityInWorldCoords(ped, 0.075, 0.84, 0.35)
    local rotation = GetEntityRotation(ped)
    local dict = 'anim_heist@hs3f@ig1_hack_keypad@arcade@male@'
    local phoneModel = GetHashKey('prop_phone_ing')
    local heading = GetEntityHeading(ped)

    lib.requestAnimDict(dict)
    lib.requestModel(phoneModel)

    local phoneProp = CreateObject(phoneModel, coords.x, coords.y, coords.z, true, true, true)

    SetEntityCollision(phoneProp, false, true)

    local loopScene = NetworkCreateSynchronisedScene(coords.xy, coords.z, rotation, 2, true, true, -1, 0, 1.0)
    NetworkAddPedToSynchronisedScene(ped, loopScene, dict, 'hack_loop_var_01', 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(phoneProp, loopScene, dict, 'hack_loop_var_01_prop_phone_ing', 1.0, 1.0, 1)

    NetworkStartSynchronisedScene(loopScene)

    local successScene = NetworkCreateSynchronisedScene(coords.xy, coords.z, rotation, 2, true, true, -1, 0, 1.0)
    NetworkAddPedToSynchronisedScene(ped, successScene, dict, 'success_react_exit_var_01', 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(phoneProp, successScene, dict, 'success_react_exit_var_01_prop_phone_ing', 1.0, 1.0, 1)

    local failScene = NetworkCreateSynchronisedScene(coords.xy, coords.z, rotation, 2, true, true, -1, 0, 1.0)
    NetworkAddPedToSynchronisedScene(ped, failScene, dict, 'fail_react', 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(phoneProp, failScene, dict, 'fail_react_prop_phone_ing', 1.0, 1.0, 1)

    minigame(function(success)
        cb(success)
        if success then
            NetworkStartSynchronisedScene(successScene)
            Wait(4200)
            NetworkStopSynchronisedScene(successScene)
        else
            NetworkStartSynchronisedScene(failScene)
            Wait(3566)
            NetworkStopSynchronisedScene(failScene)
        end
    end)

    DeleteEntity(phoneProp)

    RemoveAnimDict(dict)
    SetModelAsNoLongerNeeded(phoneModel)
end

exports('HackPhone', HackPhone)

local function StealPainting(Entity, CB, CreateCam)
    if not DoesEntityExist(Entity) then lib.print.error('StealPainting: Entity does not exist') return end

    while NetworkGetEntityOwner(Entity) ~= PlayerId() do
        NetworkRequestControlOfEntity(Entity)
        Wait(100)
    end

    local PlayerPed = cache.ped
    local Coords = GetEntityCoords(Entity)
    local Rotation = GetEntityRotation(Entity)
    local Dict = 'anim_heist@hs3f@ig11_steal_painting@male@'
    local BagModel = GetHashKey('hei_p_m_bag_var22_arm_s')

    lib.requestModel(BagModel)
    lib.requestAnimDict(Dict)

    local BagProp = CreateObject(BagModel, Coords.x, Coords.y, Coords.z, true, true, true)

    local Enter = NetworkCreateSynchronisedScene(Coords.xy, Coords.z - 0.05, Rotation, 2, true, false, -1, 0, 1.0)
    NetworkAddPedToSynchronisedScene(PlayerPed, Enter, Dict, 'ver_01_top_left_enter', 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(Entity, Enter, Dict, 'ver_01_top_left_enter_ch_prop_vault_painting_01a', 1.0, 1.0, 1)
    NetworkAddEntityToSynchronisedScene(BagProp, Enter, Dict, 'ver_01_top_left_enter_hei_p_m_bag_var22_arm_s', 1.0, 1.0, 1)
    if CreateCam then NetworkAddSynchronisedSceneCamera(Enter, Dict, 'ver_01_top_left_enter_cam_ble') end
    NetworkStartSynchronisedScene(Enter)
    Wait(2033)

    local LeftToRight = NetworkCreateSynchronisedScene(Coords.xy, Coords.z - 0.05, Rotation, 2, true, false, -1, 0, 1.0)
    NetworkAddPedToSynchronisedScene(PlayerPed, LeftToRight, Dict, 'ver_01_cutting_top_left_to_right', 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(Entity, LeftToRight, Dict, 'ver_01_cutting_top_left_to_right_ch_prop_vault_painting_01a', 1.0, 1.0, 1)
    NetworkAddEntityToSynchronisedScene(BagProp, LeftToRight, Dict, 'ver_01_cutting_top_left_to_right_hei_p_m_bag_var22_arm_s', 1.0, 1.0, 1)
    if CreateCam then NetworkAddSynchronisedSceneCamera(LeftToRight, Dict, 'ver_01_cutting_top_left_to_right_cam') end
    NetworkStartSynchronisedScene(LeftToRight)
    Wait(2600)

    local RightToBottom = NetworkCreateSynchronisedScene(Coords.xy, Coords.z - 0.05, Rotation, 2, true, false, -1, 0, 1.0)
    NetworkAddPedToSynchronisedScene(PlayerPed, RightToBottom, Dict, 'ver_01_cutting_right_top_to_bottom', 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(Entity, RightToBottom, Dict, 'ver_01_cutting_right_top_to_bottom_ch_prop_vault_painting_01a', 1.0, 1.0, 1)
    NetworkAddEntityToSynchronisedScene(BagProp, RightToBottom, Dict, 'ver_01_cutting_right_top_to_bottom_hei_p_m_bag_var22_arm_s', 1.0, 1.0, 1)
    if CreateCam then NetworkAddSynchronisedSceneCamera(RightToBottom, Dict, 'ver_01_cutting_right_top_to_bottom_cam') end
    NetworkStartSynchronisedScene(RightToBottom)
    Wait(2700)

    local BottomRightToLeft = NetworkCreateSynchronisedScene(Coords.xy, Coords.z - 0.05, Rotation, 2, true, false, -1, 0, 1.0)
    NetworkAddPedToSynchronisedScene(PlayerPed, BottomRightToLeft, Dict, 'ver_01_cutting_bottom_right_to_left', 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(Entity, BottomRightToLeft, Dict, 'ver_01_cutting_bottom_right_to_left_ch_prop_vault_painting_01a', 1.0, 1.0, 1)
    NetworkAddEntityToSynchronisedScene(BagProp, BottomRightToLeft, Dict, 'ver_01_cutting_bottom_right_to_left_hei_p_m_bag_var22_arm_s', 1.0, 1.0, 1)
    if CreateCam then NetworkAddSynchronisedSceneCamera(BottomRightToLeft, Dict, 'ver_01_cutting_bottom_right_to_left_cam') end
    NetworkStartSynchronisedScene(BottomRightToLeft)
    Wait(2933)

    local TopLeftToBottom = NetworkCreateSynchronisedScene(Coords.xy, Coords.z - 0.05, Rotation, 2, true, false, -1, 0, 1.0)
    NetworkAddPedToSynchronisedScene(PlayerPed, TopLeftToBottom, Dict, 'ver_01_re-enter_cutting_left_top_to_bottom', 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(Entity, TopLeftToBottom, Dict, 'ver_01_re-enter_cutting_left_top_to_bottom_ch_prop_vault_painting_01a', 1.0, 1.0, 1)
    NetworkAddEntityToSynchronisedScene(BagProp, TopLeftToBottom, Dict, 'ver_01_re-enter_cutting_left_top_to_bottom_hei_p_m_bag_var22_arm_s', 1.0, 1.0, 1)
    if CreateCam then NetworkAddSynchronisedSceneCamera(TopLeftToBottom, Dict, 'ver_01_re-enter_cutting_left_top_to_bottom_cam') end
    NetworkStartSynchronisedScene(TopLeftToBottom)
    Wait(2433)

    local ExitWithPainting = NetworkCreateSynchronisedScene(Coords.xy, Coords.z - 0.05, Rotation, 2, true, false, -1, 0, 1.0)
    NetworkAddPedToSynchronisedScene(PlayerPed, ExitWithPainting, Dict, 'ver_01_with_painting_exit', 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(Entity, ExitWithPainting, Dict, 'ver_01_with_painting_exit_ch_prop_vault_painting_01a', 1.0, 1.0, 1)
    NetworkAddEntityToSynchronisedScene(BagProp, ExitWithPainting, Dict, 'ver_01_with_painting_exit_hei_p_m_bag_var22_arm_s', 1.0, 1.0, 1)
    if CreateCam then NetworkAddSynchronisedSceneCamera(ExitWithPainting, Dict, 'ver_01_with_painting_exit_cam_re1') end
    NetworkStartSynchronisedScene(ExitWithPainting)
    Wait(7233)

    NetworkStopSynchronisedScene(ExitWithPainting)

    DeleteEntity(BagProp)
    SetModelAsNoLongerNeeded(BagModel)
    RemoveAnimDict(Dict)

    CB()
end

exports('StealPainting', StealPainting)