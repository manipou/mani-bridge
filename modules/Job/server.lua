local JobCache, LastJobs, PlayerJobs = {}, {}, {}

local function OnJobChange(src, newJob, oldJob)
    if oldJob then
        LastJobs[src] = oldJob.name
        JobCache[oldJob.name] = JobCache[oldJob.name] or {}
        for i = 1, #JobCache[oldJob.name] do
            if JobCache[oldJob.name][i].Source == src then
                table.remove(JobCache[oldJob.name], i)
                break
            end
        end
    end

    if newJob then
        PlayerJobs[src] = newJob.name
        JobCache[newJob.name] = JobCache[newJob.name] or {}
        JobCache[newJob.name][#JobCache[newJob.name] + 1] = { Source = src, Grade = newJob.grade }
    end

    TriggerEvent('mani-bridge:server:onJobChange', src, newJob, oldJob)
    TriggerClientEvent('mani-bridge:client:onJobChange', src, newJob, oldJob)
end

CreateThread(function()
    if Config.Framework == 'esx' then
        RegisterNetEvent('esx:setJob', function(src, job, lastJob) OnJobChange(src, job, lastJob) end)
    elseif Config.Framework == 'qb' or Config.Framework == 'qbx' then
        RegisterNetEvent('QBCore:Server:OnJobUpdate', function(src, job) OnJobChange(src, job, LastJobs[src]) end)
    end
    
    AddEventHandler('playerDropped', function() OnJobChange(source, nil, nil) end)
end)

local function HasJob(src, job)
    if not PlayerJobs[src] then return false end
    if type(job) == 'table' then
        for i = 1, #job do
            if job[i] == PlayerJobs[src] then
                return true
            end
        end
    elseif PlayerJobs[src] == job then
        return true
    else
        return false
    end
end

exports('HasJob', HasJob)

local function GetPlayerJob(src)
    return PlayerJobs[src] or nil
end

exports('GetPlayerJob', GetPlayerJob)

local function RunActionForJob(job, action)
    if not JobCache[job] then return end
    for i = 1, #JobCache[job] do
        action(JobCache[job][i])
    end
end

exports('RunActionForJob', RunActionForJob)

local function GetJobCount(job)
    return JobCache[job] and #JobCache[job] or 0
end

exports('GetJobCount', GetJobCount)
