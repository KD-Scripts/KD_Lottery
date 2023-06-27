function additem(player)
    local count = math["random"](1, 50)
    local xPlayer = player
    if count == 30 then
        winprice = 2
        xPlayer.addMoney(winprice)
        xPlayer.showNotification('You Won ' ..winprice .. '$')
        pricefromsoc(winprice)
    elseif count == 43 then
        winprice = 1
        xPlayer.addMoney(winprice)
        xPlayer.showNotification('You Won ' ..winprice .. '$')
        pricefromsoc(winprice)
    elseif count == 22 then
        winprice = 3
        xPlayer.addMoney(winprice)
        xPlayer.showNotification('You Won ' ..winprice .. '$')
        pricefromsoc(winprice)
    elseif count == 15 then
        winprice = 'bread'
        count = 5
        removefromsoc = 500000
        xPlayer.addInventoryItem(winprice, count)
        xPlayer.showNotification('You Won ' ..count.. ' ' ..winprice .. '$')
        pricefromsoc(removefromsoc)
    else
        xPlayer.showNotification('You Won Nothing Try Again')
    end
end