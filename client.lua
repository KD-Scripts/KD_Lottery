addCommas = function(n)
	return tostring(math.floor(n)):reverse():gsub("(%d%d%d)","%1,")
								  :gsub(",(%-?)$","%1"):reverse()
end

CreateBlip = function(coords, sprite, colour, text, scale)
    local blip = AddBlipForCoord(coords)
    SetBlipSprite(blip, sprite)
    SetBlipColour(blip, colour)
    SetBlipAsShortRange(blip, true)
    SetBlipScale(blip, scale)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(text)
    EndTextCommandSetBlipName(blip)
end

AddEventHandler('KD_LotteryShop:buyItem', function(data)
    local data = data
    local input = lib.inputDialog('How many would you like to buy?', {'Quantity'})
    if Config.BuyShop then
        if input then
            data.quantity = math.floor(tonumber(input[1]))
            if data.quantity < 1 then
                lib.notify({
                    title = 'Error',
                    description = 'Please enter a valid amount!',
                    type = 'error'
                })
            else
                local done = lib.callback.await('KD_LotteryShop:buyItem', 100, data)
                if not done then
                    lib.notify({
                        title = 'Error',
                        description = 'You lacked the requested items to buy!',
                        type = 'error'
                    })
                else
                    lib.notify({
                        title = 'Success',
                        description = 'You sold your goods for and profited $'..addCommas(done),
                        type = 'success'
                    })
                end
            end
        else
            lib.notify({
                title = 'Error',
                description = 'Please enter a valid amount!',
                type = 'error'
            })
        end
    end
end)

AddEventHandler('KD_LotteryShop:interact', function(data)
    local storeData = data.store
    local items = storeData.items
    local Options = {}
    if Config.BuyShop then
        for i=1, #items do
            table.insert(Options, {
                title = items[i].label,
                description = 'Price: $'..items[i].price,
                event = 'KD_LotteryShop:buyItem',
                args = { item = items[i].item, price = items[i].price, currency = items[i].currency }
            })
        end
        lib.registerContext({
            id = 'storeInteract',
            title = storeData.label,
            options = Options
        })
        lib.showContext('storeInteract')
    end
end)

-- Blips/Targets
CreateThread(function()
    if Config.BuyShop then
        for i=1, #Config.BuyShops do
            exports.qtarget:AddBoxZone(i.."_buy_shop", Config.BuyShops[i].coords, 1.0, 1.0, {
                name=i.."_buy_shop",
                heading=Config.BuyShops[i].blip.heading,
                debugPoly=false,
                minZ=Config.BuyShops[i].coords.z-1.5,
                maxZ=Config.BuyShops[i].coords.z+1.5
            }, {
                options = {
                    {
                        event = 'KD_LotteryShop:interact',
                        icon = Config.BuyShops[i].icon,
                        label = Config.BuyShops[i].label,
                        store = Config.BuyShops[i]
                    }
                },
                job = 'all',
                distance = 1.5
            })
            if Config.BuyShops[i].blip.enabled then
                CreateBlip(Config.BuyShops[i].coords, Config.BuyShops[i].blip.sprite, Config.BuyShops[i].blip.color, Config.BuyShops[i].label, Config.BuyShops[i].blip.scale)
            end
        end
    end
end)

-- Ped spawn thread
local pedSpawned = {}
local pedPool = {}
CreateThread(function()
	while true do
		local sleep = 1500
        local playerPed = cache.ped
        local pos = GetEntityCoords(playerPed)
		for i=1, #Config.BuyShops do
            if Config.BuyShop then
			    local dist = #(pos - Config.BuyShops[i].coords)
			    if dist <= 20 and not pedSpawned[i] then
				    pedSpawned[i] = true
                    lib.requestModel(Config.BuyShops[i].ped, 100)
                    lib.requestAnimDict(Config.BuyShops[i].anim, 100)
				    pedPool[i] = CreatePed(28, Config.BuyShops[i].ped, Config.BuyShops[i].coords.x, Config.BuyShops[i].coords.y, Config.BuyShops[i].coords.z, Config.BuyShops[i].heading, false, false)
				    FreezeEntityPosition(pedPool[i], true)
				    SetEntityInvincible(pedPool[i], true)
				    SetBlockingOfNonTemporaryEvents(pedPool[i], true)
				    TaskPlayAnim(pedPool[i], Config.BuyShops[i].anim,'base', 8.0, 0.0, -1, 1, 0, 0, 0, 0)
			    elseif dist >= 21 and pedSpawned[i] then
				    local model = GetEntityModel(pedPool[i])
				    SetModelAsNoLongerNeeded(model)
				    DeletePed(pedPool[i])
				    SetPedAsNoLongerNeeded(pedPool[i])
                    pedPool[i] = nil
				    pedSpawned[i] = false
			    end
            end
		end
		Wait(sleep)
	end
end)