ESX.RegisterUsableItem(Config.ItemName, function(playerId)
   local xPlayer = ESX.GetPlayerFromId(playerId)
   xPlayer.removeInventoryItem(Config.ItemName, 1)
   additem(xPlayer)
end)

lib.callback.register('KD_LotteryShop:buyItem', function(source, data)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xItem = xPlayer.getInventoryItem(data.item)
    local profit = math.floor(data.price * data.quantity)
    if xPlayer.getMoney() >= profit then
        xPlayer.addInventoryItem(data.item, data.quantity)
        xPlayer.removeAccountMoney(data.currency, profit)
        if Config.Society then
            addmoneytogov(profit)
        end
        return profit
    end
end)

function addmoneytogov(profit)
    TriggerEvent("esx_addonaccount:getSharedAccount", Config.SocietyAccount, function(account)
        if account ~= nil then
            account.addMoney(profit)
        end
    end)
end

function pricefromsoc(remove)
    if Config.Society then
        TriggerEvent("esx_addonaccount:getSharedAccount", Config.SocietyAccount, function(account)
            if account ~= nil then
                account.removeMoney(remove)
            end
        end)
    end
end