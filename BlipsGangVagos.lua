--=====================================--
--=============== BLIPS ===============--
--=====================================--

local ESX, PlayerData = exports["es_extended"]:getSharedObject();

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(player)
    PlayerData = player;
    ESX.PlayerLoaded = true
end)

---@public
---@class gangBlipsClient_Storage
gangBlipsClient_Storage = {};

---@private
---@type table gangBlips
local gangBlips = {
    ["vagos"] = {
      {
        position = vector3(336.6304, -2014.9887, 21.1000), name = "Nom du blip", gang = 'vagos', sprite = 566, scale = 0.6, colour = 46, 
    },
    {
        position = vector3(332.2128, -2013.7816, 21.3000), name = "Nom du blip", gang = 'vagos', sprite = 499, scale = 0.6, colour = 46,
    },
    --{
        --position = vector3(2685.0136, 3515.5346, 52.3043), name = "Nom du blip", gang = 'vagos', sprite = 772, scale = 0.6, colour = 46,
    --},
    --{
        --position = vector3(-394.2285, 6076.4599, 31.5001), name = "Nom du blip", gang = 'vagos', sprite = 756, scale = 0.6, colour = 46,
    --},

    
  }
};

---@private
---@type function createBlips
---@param data table
local function createBlips(data)
    local blip = AddBlipForCoord(data.pos)
    SetBlipSprite(blip, data.sprite)
    SetBlipScale(blip, data.scale)
    SetBlipColour(blip, data.colour)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString(data.name)
    EndTextCommandSetBlipName(blip)
    return blip;
end

---@private
---@type function verifyPlayerGang
local function verifyPlayerGang()
    ESX.PlayerData = ESX.GetPlayerData();

    if (ESX.PlayerData ~= nil) then
        local haveGang = false
        if (ESX.PlayerData.job2.name ~= 'unemployed2') then
            haveGang = true;
        end

        if (#gangBlipsClient_Storage > 0) then
            for _,v in pairs(gangBlipsClient_Storage) do
                if (v.gang ~= ESX.PlayerData.job2.name) then
                    RemoveBlip(v.blip);
                    gangBlipsClient_Storage = {  };
                end
            end
        else
            if (haveGang) then
                local playerGang = (ESX.PlayerData.job2.name or "unemployed2");
                
                if (gangBlips[playerGang]) then
                    for _,v in pairs(gangBlips[playerGang]) do
                        if (v.gang == "unemployed") then return end

                        if (v.gang == playerGang) then
                            local blips = createBlips({ pos = v.position, sprite = v.sprite, scale = v.scale, colour = v.colour, name = v.name });
                            table.insert(gangBlipsClient_Storage, {blip = blips, gang = v.gang})
                        end
                    end
                end
            end
        end
    end
end

CreateThread(function()
    if (ESX.GetPlayerData().job ~= nil) then
        ESX.PlayerLoaded = true
    end

    while (not ESX.PlayerLoaded) do
        Wait(250.0);
    end

    while (ESX.PlayerLoaded) do
        local tick = 1450;
        verifyPlayerGang()

        Wait(tick)
    end
end)
