local ESX, PlayerData = nil, {}
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)
        Citizen.Wait(10)
    end
    while not ESX.GetPlayerData().job do
        Citizen.Wait(10)
    end
    PlayerData = ESX.GetPlayerData()
end)
RegisterNetEvent("esx:playerLoaded", function(xPlayer) PlayerData = xPlayer end)
RegisterNetEvent("esx:setJob", function(job) PlayerData.job = job end)


function GetCurrentPlayers()
    local TotalPlayers = 0

    for _, player in ipairs(GetActivePlayers()) do
        TotalPlayers = TotalPlayers + 1
    end

    return TotalPlayers
end

Citizen.CreateThread(function()
    while true do
        ESX.TriggerServerCallback('callbackplayers', function(data)     
            cpolice = data.cpolice
            cmedic = data.cmedic
            cstaffs = data.cstaffs
            cmechanic = data.cmechanic
            players = GetCurrentPlayers()
        end)
        Citizen.Wait(Config.UpdateTime)
    end
end)

RegisterCommand('scoreboard', function()
    Scoreboard()
end)


RegisterKeyMapping('scoreboard', 'Open Scoreboard Menu' , 'keyboard', 'F10')


Scoreboard = function()
		    local elements = {}
            if Config.Hide0 then
                if cpolice >= 1 then
                table.insert(elements,  {label = '👮🏻‍♂️ Officers: '..cpolice..'', value = 'pol'})
                end
                if cmedic >= 1 then
                table.insert(elements,  {label = '👨🏻‍⚕️ Medics: '..cmedic..'', value = 'med'} )
                end
                if cmechanic >= 1 then
                table.insert(elements,  {label = '👨🏻‍🔧 Mechanics: '..cmechanic..'', value = 'mec'} ) 
                end
                if cstaffs >= 1 then
                table.insert(elements,  {label = '🧙🏻 Connected Staffs: '..cstaffs..'', value = 'staff'} )
                end
                table.insert(elements,  {label = '👤Connected Players: '..players..'', value = 'ply'} )
                table.insert(elements,  {label = 'Close', value = 'close'} )
            else
                table.insert(elements,  {label = '👮🏻‍♂️ Officers: '..cpolice..'', value = 'pol'})
                table.insert(elements,  {label = '👨🏻‍⚕️ Medics: '..cmedic..'', value = 'med'} )
                table.insert(elements,  {label = '👨🏻‍🔧 Mechanics: '..cmechanic..'', value = 'mec'} ) 
                table.insert(elements,  {label = '🧙🏻 Connected Staffs: '..cstaffs..'', value = 'staff'} )
                table.insert(elements,  {label = '👤 Connected Players: '..players..'', value = 'ply'} )
                table.insert(elements,  {label = 'Close', value = 'close'} )
            end

                ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'score',
                {
                title = 'Player List',
                align = Config.Align,
                elements = elements,
                },
	function(data, menu)
		local action = data.current.value

		if action == 'pol' then
			ESX.ShowNotification("There are "..cpolice.." police officers on duty")  
		elseif action == 'med' then 
            ESX.ShowNotification("There are "..cmedic.." medics on duty")  
		elseif action == 'mec' then 
            ESX.ShowNotification("There are "..cmechanic.." mechanics on duty")  
        elseif action == 'staff' then 
            ESX.ShowNotification("There are "..cstaffs.." Staffs connected")  
        elseif action == 'ply' then 
            ESX.ShowNotification("There are "..players.." Players connected")  
		elseif action == 'close' then
            ESX.UI.Menu.CloseAll()
		end
	end,
	function(data, menu)
		menu.close()
	end)
end