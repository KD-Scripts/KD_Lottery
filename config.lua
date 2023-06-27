ESX = exports["es_extended"]:getSharedObject()

Config = {}

Config.Society = false --true means money will add to Config.SocietyAccount and remove also
Config.SocietyAccount = "society_gov"

Config.ItemName = 'lottery'

Config.BuyShop = true
Config.BuyShops = {
    { 
        coords = vec3(193.6462097168, -901.43676757812, 31.116777420044-1.0),
        heading = 326.16430664062,
        ped = 'a_m_m_og_boss_01',
        anim = 'mini@strip_club@idles@bouncer@base',
        label = 'Lottery Shop',
        icon = 'fa-solid fa-cart-shopping',
        blip = {
            enabled = true,
            sprite = 11,
            color = 11,
            scale = 0.75 
        },
        items = {
            { item = 'lottery', label = 'Lottery', price = 10, currency = 'money' }
        }
    },
}

--You Can Add More In server_edit