local function TeleportEntity(Entity, Coords, Transition)
    if Transition then
        SwitchOutPlayer(Entity, 0, 1)
	    Wait(2500)
    end

    if DoesEntityExist(Entity) then
        RequestCollisionAtCoord(Coords.x, Coords.y, Coords.z)

        local Vehicle = cache.vehicle

        if IsEntityAPed(Entity) and Vehicle then
            SetPedCoordsKeepVehicle(Entity, Coords.x, Coords.y, Coords.z)
            SetEntityHeading(Vehicle, Coords.w or Coords.heading or 0.0)
        else
            SetEntityCoords(Entity, Coords.x, Coords.y, Coords.z, false, false, false, false)
            SetEntityHeading(Entity, Coords.w or Coords.heading or 0.0)
        end

        FreezeEntityPosition(Entity, true)

        while not HasCollisionLoadedAroundEntity(Entity) do Wait(0) end

        FreezeEntityPosition(Entity, false)
    end

    if Transition then
        Wait(2500)
        SwitchInPlayer(Entity)
    end
end

exports('TeleportEntity', TeleportEntity)