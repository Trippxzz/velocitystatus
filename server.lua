
ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local webhooklink = 'https://discord.com/api/webhooks/' -- PUT YOUR WEBHOOK LINK


Citizen.CreateThread(function()
    while true do
	if Config.MessageId ~= nil and Config.MessageId ~= '' then
		Players()
	else
		DeployStatusMessage()
		break
	end

	Citizen.Wait(Config.UpdateTime)
    end
end)


function DeployStatusMessage()
	local footer = nil
	if Config.Use24hClock then
		footer = os.date('Date: %d/%m/%Y  |  Hour: %H:%M')
	else
		footer = os.date('Date: %d/%m/%Y  |  Hour: %I:%M %p')
	end

	if Config.Debug then
		print('Deplying Status Message ['..footer..']')
	end

	local embed = {
		{
			["color"] = 3158326,
			["title"] = "** Development message!**",
			["description"] = 'Copy this message id and put it into Config and restart script!',
			["footer"] = {
				["text"] = footer,
			},
		}
	}

	PerformHttpRequest(webhooklink, function(err, text, headers) end, 'POST', json.encode({
		embeds = embed, 
	}), { ['Content-Type'] = 'application/json' })
end



function Players()
	local footer = nil
	local xPlayers = ESX.GetPlayers()
	local players = GetNumPlayerIndices()
	local maxplayers = GetConvarInt('sv_maxclients', 0)
	police = 0
	medic = 0
	staffs = 0
	mechanic = 0

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == Config.Job1 then
			police = police + 1
		end
		if xPlayer.job.name == Config.Job2 then
			medic = medic + 1
		end
		if xPlayer.job.name == Config.Job3 then
			mechanic = mechanic + 1
		end
        if xPlayer.getGroup() ~= "user" then
			staffs = staffs + 1
		end	
	end
	if Config.Use24hClock then
		footer = os.date('Date: %d/%m  |  Updated: %H:%M:%S')
	else
		footer = os.date('Date: %d/%m/%Y  |  Hour: %I:%M %p')
	end

	if Config.Debug then
		print('Updating Status Message ['..footer..']')
	end

	local message = json.encode({
		embeds = {
			{
				["username"] = "FiveM Status", -- CHANGE FOR YOUR NAME
				["avatar_url"]= "https://cdn.discordapp.com/attachments/927442566071320586/1016500758377672795/Velocity_Develoment_Logo_4.png", -- CHANGE FOR YOUR LOGO
				["color"] = 1287415, -- CHANGE FOR YOUR FAVORITE COLOR  https://www.spycolor.com AND COPY THE DECIMAL VALUE
				["title"] = '**FiveM Status**',
			    ["fields"] = {
					{
					["name"]= "Officers ",
					["value"]= "```"..police.."```",
					["inline"]= true,
					},
					{
						["name"]= "Mechanics ",
						["value"]= "```"  ..mechanic.."```",
						["inline"]= true,
					},
					{
						["name"]= "Medics",
						["value"]= "```" ..medic.."```",
						["inline"]= true,
					},
					{
						["name"]= "Staffs ",
						["value"]= "```" ..staffs.."```",
						["inline"]= true,
					},
					{
						["name"]= "Players ",
						["value"]= "```[" ..players.. "/"..maxplayers.."]```",
						["inline"]= true,
					}
					
		    	},
				["image"]= {
					["url"]= "https://cdn.discordapp.com/attachments/927442566071320586/1016505073452462221/standard_1.gif"
				  },
				["footer"] = {
					["text"] = footer,
				},
			}
		},
	})

	PerformHttpRequest(webhooklink..'/messages/'..Config.MessageId, function(err, text, headers) 
		if Config.Debug then
			print('[DEBUG] err=', err)
			print('[DEBUG] text=', text)
		end
	end, 'PATCH',message, { ['Content-Type'] = 'application/json' })

end

ESX.RegisterServerCallback('callbackplayers', function(source, cb)
	
	Players()

    local data  = {
        cpolice = police,
        cmedic = medic,
        cstaffs = staffs,
        cmechanic = mechanic,
    }
        cb(data)
end)