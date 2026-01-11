-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
cRP = {}
Tunnel.bindInterface("target",cRP)
vSERVER = Tunnel.getInterface("target")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Zones = {}
local Models = {}
local success = false
local innerEntity = {}
local setDistance = 10.0
local targetActive = false
local playerActive = true
-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP:PLAYERACTIVE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp:playerActive")
AddEventHandler("vrp:playerActive",function()
	playerActive = true
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	RegisterCommand("+entityTarget",playerTargetEnable)
	RegisterCommand("-entityTarget",playerTargetDisable)
	RegisterKeyMapping("+entityTarget","Target","keyboard","LMENU")

	--=====================================================================--

	AddCircleZone("CallBurgerShot",vec3(-1187.86,-904.92,13.73),0.75,{
		name = "CallBurgerShot",
		heading = 136.07
	},{
		distance = 1.0,
		options = {
			{
				event = "target:CallWorks",
				label = "Buscar Entregadores",
				tunnel = "server"
			}
		}
	})

	AddCircleZone("CallParamedic",vec3(-678.14,326.62,82.96),0.75,{
		name = "CallParamedic",
		heading = 136.07
	},{
		distance = 2.0,
		options = {
			{
				event = "target:CallWorks",
				label = "Buscar Doadores",
				tunnel = "server"
			}
		}
	})

	AddCircleZone("treatment1",vector3(-673.77,325.54,88.02),0.75,{
		name = "treatment1",
		heading = 136.07
	},{
		distance = 1.25,
		options = {
			{
				event = "checkin:initCheck",
				label = "Tratamento",
				tunnel = "client"
			}
		}
	})

	AddCircleZone("treatment2",vector3(-675.12, 326.4, 83.09),0.75,{
		name = "treatment2",
		heading = 136.07
	},{
		distance = 1.25,
		options = {
			{
				event = "checkin:initCheck",
				label = "Tratamento",
				tunnel = "client"
			}
		}
	})

	AddTargetModel({ 1631638868,2117668672,-1498379115,-1519439119,-289946279 },{
		options = {
			{
				event = "target:animDeitar",
				label = "Deitar",
				tunnel = "client"
			}
		},
		distance = 1.00
	})

	AddTargetModel({ -171943901,-109356459,1805980844,-99500382,1262298127,1737474779,2040839490,1037469683,867556671,-1521264200,-741944541,-591349326,-293380809,-628719744,-1317098115,1630899471,38932324,-523951410,725259233,764848282,2064599526,536071214,589738836,146905321,47332588,-1118419705,538002882,-377849416,96868307,-1195678770,-606800174 },{
		options = {
			{
				event = "target:animSentar",
				label = "Sentar",
				tunnel = "client"
			}
		},
		distance = 1.00
	})

	AddTargetModel({ -205311355, 1245865676, -874338148 },{
		options = {
			{
				event = "trydeleteobj",
				label = "Remover",
				tunnel = "objects"
			}
		},
		distance = 1.50
	})

	AddTargetModel({ 
        669632651, 1437508529, 1329570871, 1143474856, -468629664, -130812911, -58485588, 
        218085040, -2096124444, 682791951, -2140839391, 1614658037, -1096777189, 
        -422870120, -1345305746, 1748268526, 684586828, 1511880420, 1114216298 
    },{
        options = {
            {
                event = "target:vasculhar",
                label = "Vasculhar",
                tunnel = "server" -- Envia direto para o servidor para dar a recompensa
            }
        },
        distance = 1.2
    })
end)


-----------------------------------------------------------------------------------------------------------------------------------------
-- PARAMEDICMENU
-----------------------------------------------------------------------------------------------------------------------------------------
local paramedicMenu = {
	{
		event = "paramedic:reanimar",
		label = "Reanimar",
		tunnel = "paramedic"
	},
	{
		event = "paramedic:tratamento",
		label = "Tratamento",
		tunnel = "paramedic"
	},
	{
		event = "paramedic:maca",
		label = "Deitar Paciente",
		tunnel = "paramedic"
	},
	{
		event = "paramedic:presetBurn",
		label = "Roupa de Queimadura",
		tunnel = "paramedic"
	},
	{
		event = "paramedic:presetPlaster",
		label = "Roupa de Gesso",
		tunnel = "paramedic"
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- POLICEVEH
-----------------------------------------------------------------------------------------------------------------------------------------
local policeVeh = {
		{
		event = "Target:Placa",
		label = "Placa",
		tunnel = "server"
	},
    { event = "target:trunkin", label = "Entrar no Porta-Malas", tunnel = "server" },
    { event = "target:cv", label = "Colocar na viatura", tunnel = "server" },
    { event = "target:rv", label = "Remover da viatura", tunnel = "server" },
    { event = "target:hood", label = "Abrir/Fechar Capô", tunnel = "client" },
    { event = "target:trunk", label = "Abrir/Fechar Porta-Malas", tunnel = "client" },
    { event = "target:doors", label = "Abrir/Fechar Portas", tunnel = "client" }, -- Estilo ox_target
    { event = "target:windows", label = "Abrir/Fechar Vidros", tunnel = "client" },
    { event = "target:engine", label = "Ligar/Desligar Motor", tunnel = "client" } -- Estilo ox_target
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- TWOPED
-----------------------------------------------------------------------------------------------------------------------------------------
local twoPed = {
	{
		event = "target:algemar",
		label = "Algemar",
		tunnel = "server"
	},
	{
	   event = "target:revistar",
       label = "Revistar" ,
	   tunnel = "client"
	},
   

}
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADMINMENU
-----------------------------------------------------------------------------------------------------------------------------------------
local adminMenu = {
	{
		event = "nation:deleteVehicleSync",
		label = "Deletar Veículo",
		tunnel = "admin"
	},
	{
		event = "tryreparar",
		label = "Fix",
		tunnel = "admin"
	},
	{
		event = "target:sequestrar",
		label = "Sequestrar",
		tunnel = "server" 

	},
	{
		event = "target:trunkin",
		label = "Entrar no Porta-Malas",
		tunnel = "server"
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERVEH
-----------------------------------------------------------------------------------------------------------------------------------------
local playerVeh = {
    { event = "target:trunkin", label = "Entrar no Porta-Malas", tunnel = "server" },
    { event = "target:sequestrar", label = "Sequestrar", tunnel = "server" },
    { event = "target:hood", label = "Abrir/Fechar Capô", tunnel = "client" },
    { event = "target:trunk", label = "Abrir/Fechar Porta-Malas", tunnel = "client" },
    { event = "target:doors", label = "Abrir/Fechar Portas", tunnel = "client" }, -- Estilo ox_target
    { event = "target:windows", label = "Abrir/Fechar Vidros", tunnel = "client" },
    { event = "target:engine", label = "Ligar/Desligar Motor", tunnel = "client" }, -- Estilo ox_target
    { event = "target:checkVeh", label = "Verificar Veículo", tunnel = "client" }, -- Estilo ox_target
    { event = "target:pneu", label = "Remover Pneu", tunnel = "client" },
    { event = "target:pneucolocar", label = "Colocar Pneu", tunnel = "client" }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERTARGETENABLE
-----------------------------------------------------------------------------------------------------------------------------------------
function playerTargetEnable()
	if playerActive then
		if success or IsPedArmed(PlayerPedId(),6) or IsPedInAnyVehicle(PlayerPedId()) then
			return
		end

		targetActive = true

		SendNUIMessage({ response = "openTarget" })

		while targetActive do
			local ped = PlayerPedId()
			local coords = GetEntityCoords(ped)
			local hit,entCoords,entity = RayCastGamePlayCamera(setDistance)

			if hit == 1 then
				innerEntity = {}

				if GetEntityType(entity) ~= 0 then
					
					if not vSERVER.PermissionPolicia() and not vSERVER.PermissionParamedico() and vSERVER.Desativado() then
						if DoesEntityExist(entity) then
							if #(coords - entCoords) <= setDistance then
								success = true

								NetworkRegisterEntityAsNetworked(entity)
								while not NetworkGetEntityIsNetworked(entity) do
									NetworkRegisterEntityAsNetworked(entity)
									Citizen.Wait(1)
								end

								local netObjects = NetworkGetNetworkIdFromEntity(entity)
								SetNetworkIdCanMigrate(netObjects,true)
								NetworkSetNetworkIdDynamic(netObjects,false)
								SetNetworkIdExistsOnAllMachines(netObjects,true)

								if IsEntityAVehicle(entity) then
									innerEntity = { netObjects,GetVehicleNumberPlateText(entity) }
								else
									innerEntity = { netObjects }
								end

								SendNUIMessage({ response = "validTarget", data = adminMenu })

								while success and targetActive do
									local ped = PlayerPedId()
									local coords = GetEntityCoords(ped)
									local hit,entCoords,entity = RayCastGamePlayCamera(setDistance)

									DisablePlayerFiring(ped,true)

									if (IsControlJustReleased(1,24) or IsDisabledControlJustReleased(1,24)) then
										SetCursorLocation(0.5,0.5)
										SetNuiFocus(true,true)
									end

									if GetEntityType(entity) == 0 or #(coords - entCoords) > setDistance then
										success = false
									end

									Citizen.Wait(1)
								end

								SendNUIMessage({ response = "leftTarget" })
							end
						end
					elseif IsEntityAVehicle(entity) then
						if #(coords - entCoords) <= 1.0 then
							success = true

							innerEntity = { GetVehicleNumberPlateText(entity),vRP.vehicleModel(GetEntityModel(entity)),entity,VehToNet(entity) }

							if vSERVER.PermissionPolicia() then
								SendNUIMessage({ response = "validTarget", data = policeVeh })
							else
								SendNUIMessage({ response = "validTarget", data = playerVeh })
							end

							while success and targetActive do
								local ped = PlayerPedId()
								local coords = GetEntityCoords(ped)
								local hit,entCoords,entity = RayCastGamePlayCamera(setDistance)

								DisablePlayerFiring(ped,true)

								if (IsControlJustReleased(1,24) or IsDisabledControlJustReleased(1,24)) then
									SetCursorLocation(0.5,0.5)
									SetNuiFocus(true,true)
								end

								if GetEntityType(entity) == 0 or #(coords - entCoords) > 1.0 then
									success = false
								end

								Citizen.Wait(1)
							end

							SendNUIMessage({ response = "leftTarget" })
						end
					elseif IsPedAPlayer(entity) then
						if #(coords - entCoords) <= 1.0 then
							local index = NetworkGetPlayerIndexFromPed(entity)
							local source = GetPlayerServerId(index)

							success = true
							innerEntity = { source }
							if vSERVER.PermissionParamedico() then
								SendNUIMessage({ response = "validTarget", data = paramedicMenu })
							else
								SendNUIMessage({ response = "validTarget", data = twoPed })
							end

							while success and targetActive do
								local ped = PlayerPedId()
								local coords = GetEntityCoords(ped)
								local hit,entCoords,entity = RayCastGamePlayCamera(setDistance)

								DisablePlayerFiring(ped,true)

								if (IsControlJustReleased(1,24) or IsDisabledControlJustReleased(1,24)) then
									SetCursorLocation(0.5,0.5)
									SetNuiFocus(true,true)
								end

								if GetEntityType(entity) == 0 or #(coords - entCoords) > 1.0 then
									success = false
								end

								Citizen.Wait(1)
							end

							SendNUIMessage({ response = "leftTarget" })
						end
					elseif DoesEntityExist(entity) and not IsPedAPlayer(entity) and NetworkGetEntityIsNetworked(entity) and IsEntityAPed(entity) then
						if not IsPedDeadOrDying(entity) and not IsPedInAnyVehicle(entity) and GetPedType(entity) ~= 28 and GetPedType(entity) ~= 29 then 
							if #(coords - entCoords) <= 4.0 then
								success = true
								innerEntity = { entity,PedToNet(entity) }
								SendNUIMessage({ response = "validTarget", data = npcMenu })

								while success and targetActive do
									local ped = PlayerPedId()
									local coords = GetEntityCoords(ped)
									local hit,entCoords,entity = RayCastGamePlayCamera(setDistance)

									DisablePlayerFiring(ped,true)

									if (IsControlJustReleased(1,24) or IsDisabledControlJustReleased(1,24)) then
										SetCursorLocation(0.5,0.5)
										SetNuiFocus(true,true)
									end

									if GetEntityType(entity) == 0 or #(coords - entCoords) > 2.0 then
										success = false
									end

									Citizen.Wait(1)
								end

								SendNUIMessage({ response = "leftTarget" })
							end
						end
					else
						for k,v in pairs(Models) do
							if DoesEntityExist(entity) then
								if k == GetEntityModel(entity) then
									if #(coords - entCoords) <= Models[k]["distance"] then

										success = true

										NetworkRegisterEntityAsNetworked(entity)
										while not NetworkGetEntityIsNetworked(entity) do
											NetworkRegisterEntityAsNetworked(entity)
											Citizen.Wait(1)
										end

										while not NetworkHasControlOfEntity(entity) do
											NetworkRequestControlOfEntity(entity)
											Citizen.Wait(1)
										end

										local netObjects = NetworkGetNetworkIdFromEntity(entity)
										SetNetworkIdCanMigrate(netObjects,true)
										NetworkSetNetworkIdDynamic(netObjects,false)
										SetNetworkIdExistsOnAllMachines(netObjects,true)

										innerEntity = { entity,k,netObjects,GetEntityCoords(entity) }
										SendNUIMessage({ response = "validTarget", data = Models[k]["options"] })

										while success and targetActive do
											local ped = PlayerPedId()
											local coords = GetEntityCoords(ped)
											local hit,entCoords,entity = RayCastGamePlayCamera(setDistance)

											DisablePlayerFiring(ped,true)

											if (IsControlJustReleased(1,24) or IsDisabledControlJustReleased(1,24)) then
												SetCursorLocation(0.5,0.5)
												SetNuiFocus(true,true)
											end

											if GetEntityType(entity) == 0 or #(coords - entCoords) > Models[k]["distance"] then
												success = false
											end

											Citizen.Wait(1)
										end

										SendNUIMessage({ response = "leftTarget" })
									end
								end
							end
						end
					end
				end

				for k,v in pairs(Zones) do
					if Zones[k]:isPointInside(entCoords) then
						if #(coords - Zones[k]["center"]) <= v["targetoptions"]["distance"] then
							success = true

							SendNUIMessage({ response = "validTarget", data = Zones[k]["targetoptions"]["options"] })

							if v["targetoptions"]["shop"] ~= nil then
								innerEntity = { v["targetoptions"]["shop"] }
							end

							while success and targetActive do
								local ped = PlayerPedId()
								local coords = GetEntityCoords(ped)
								local hit,entCoords,entity = RayCastGamePlayCamera(setDistance)

								DisablePlayerFiring(ped,true)

								if (IsControlJustReleased(1,24) or IsDisabledControlJustReleased(1,24)) then
									SetCursorLocation(0.5,0.5)
									SetNuiFocus(true,true)
								end

								if not Zones[k]:isPointInside(entCoords) or #(coords - Zones[k]["center"]) > v["targetoptions"]["distance"] then
									success = false
								end

								Citizen.Wait(1)
							end

							SendNUIMessage({ response = "leftTarget" })
						end
					end
				end
			end

			Citizen.Wait(250)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TARGET:ANIMDEITAR
-----------------------------------------------------------------------------------------------------------------------------------------
local beds = {
	[1631638868] = { 0.0,0.0 },
	[2117668672] = { 0.0,0.0 },
	[-1498379115] = { 1.0,90.0 },
	[-1519439119] = { 1.0,0.0 },
	[-289946279] = { 1.0,0.0 }
}

RegisterNetEvent("target:animDeitar")
AddEventHandler("target:animDeitar",function()
	local ped = PlayerPedId()
	if GetEntityHealth(ped) > 101 then
		local objCoords = GetEntityCoords(innerEntity[1])

		SetEntityCoords(ped,objCoords["x"],objCoords["y"],objCoords["z"] + beds[innerEntity[2]][1],1,0,0,0)
		SetEntityHeading(ped,GetEntityHeading(innerEntity[1]) + beds[innerEntity[2]][2] - 360.0)

		vRP._playAnim(false,{{"amb@world_human_sunbathe@female@back@idle_a","idle_a"}},true)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TARGET:PACIENTEDEITAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("target:pacienteDeitar")
AddEventHandler("target:pacienteDeitar",function()
	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped)

	for k,v in pairs(beds) do
		local object = GetClosestObjectOfType(coords["x"],coords["y"],coords["z"],0.9,k,0,0,0)
		if DoesEntityExist(object) then
			local objCoords = GetEntityCoords(object)

			SetEntityCoords(ped,objCoords["x"],objCoords["y"],objCoords["z"] + v[1],1,0,0,0)
			SetEntityHeading(ped,GetEntityHeading(object) + v[2] - 360.0)

			vRP._playAnim(false,{{"amb@world_human_sunbathe@female@back@idle_a","idle_a"}},true)
			break
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVETARGETMODEL
-----------------------------------------------------------------------------------------------------------------------------------------
function RemoveTargetModel(models)
	for k,v in pairs(models) do
		if Models[v] then
			Models[v] = nil
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TARGET:SENTAR
-----------------------------------------------------------------------------------------------------------------------------------------
local chairs = {
	[-171943901] = 0.0,
	[-109356459] = 0.5,
	[1805980844] = 0.5,
	[-99500382] = 0.3,
	[1262298127] = 0.0,
	[1737474779] = 0.5,
	[2040839490] = 0.0,
	[1037469683] = 0.4,
	[867556671] = 0.4,
	[-1521264200] = 0.0,
	[-741944541] = 0.4,
	[-591349326] = 0.5,
	[-293380809] = 0.5,
	[-628719744] = 0.5,
	[-1317098115] = 0.5,
	[1630899471] = 0.5,
	[38932324] = 0.5,
	[-523951410] = 0.5,
	[725259233] = 0.5,
	[764848282] = 0.5,
	[2064599526] = 0.5,
	[536071214] = 0.5,
	[589738836] = 0.5,
	[146905321] = 0.5,
	[47332588] = 0.5,
	[-1118419705] = 0.5,
	[538002882] = -0.1,
	[-377849416] = 0.5,
	[96868307] = 0.5,
	[-1195678770] = 0.7,
	[-606800174] = 0.5
}

RegisterNetEvent("target:animSentar")
AddEventHandler("target:animSentar",function()
	local ped = PlayerPedId()
	if GetEntityHealth(ped) > 101 then
		local objCoords = GetEntityCoords(innerEntity[1])

		FreezeEntityPosition(innerEntity[1],true)
		SetEntityCoords(ped,objCoords["x"],objCoords["y"],objCoords["z"] + chairs[innerEntity[2]],1,0,0,0)
		if chairs[innerEntity[2]] == 0.7 then
			SetEntityHeading(ped,GetEntityHeading(innerEntity[1]))
		else
			SetEntityHeading(ped,GetEntityHeading(innerEntity[1]) - 180.0)
		end

		vRP.playAnim(false,{ task = "PROP_HUMAN_SEAT_CHAIR_MP_PLAYER" },false)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERTARGETDISABLE
-----------------------------------------------------------------------------------------------------------------------------------------
function playerTargetDisable()
	if success or not targetActive then
		return
	end

	targetActive = false
	SendNUIMessage({ response = "closeTarget" })
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SELECTTARGET
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("selectTarget",function(data,cb)
	success = false
	targetActive = false
	SetNuiFocus(false,false)
	SendNUIMessage({ response = "closeTarget" })

	if data["tunnel"] == "client" then
		TriggerEvent(data["event"],innerEntity)
	elseif data["tunnel"] == "server" then
		TriggerServerEvent(data["event"],innerEntity)
	elseif data["tunnel"] == "shop" then
		TriggerEvent(data["event"],innerEntity[1])
	elseif data["tunnel"] == "paramedic" then
		TriggerServerEvent(data["event"],innerEntity[1])
	elseif data["tunnel"] == "police" then
		TriggerServerEvent(data["event"],innerEntity,data["service"])
	elseif data["tunnel"] == "objects" then
		TriggerServerEvent(data["event"],innerEntity[3])
	elseif data["tunnel"] == "admin" then
		TriggerServerEvent(data["event"],innerEntity[1],innerEntity[2])
	else
		TriggerServerEvent(data["event"])
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSETARGET
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("closeTarget",function(data,cb)
	success = false
	targetActive = false
	SetNuiFocus(false,false)
	SendNUIMessage({ response = "closeTarget" })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RESETDEBUG
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("target:resetDebug")
AddEventHandler("target:resetDebug",function()
	success = false
	targetActive = false
	SetNuiFocus(false,false)
	SendNUIMessage({ response = "closeTarget" })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ROTATIONTODIRECTION
-----------------------------------------------------------------------------------------------------------------------------------------
function RotationToDirection(rotation)
	local adjustedRotation = {
		x = (math.pi / 180) * rotation["x"],
		y = (math.pi / 180) * rotation["y"],
		z = (math.pi / 180) * rotation["z"]
	}

	local direction = {
		x = -math.sin(adjustedRotation["z"]) * math.abs(math.cos(adjustedRotation["x"])),
		y = math.cos(adjustedRotation["z"]) * math.abs(math.cos(adjustedRotation["x"])),
		z = math.sin(adjustedRotation["x"])
	}

	return direction
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RAYCASTGAMEPLAYCAMERA
-----------------------------------------------------------------------------------------------------------------------------------------
function RayCastGamePlayCamera(distance)
	local cameraCoord = GetGameplayCamCoord()
	local cameraRotation = GetGameplayCamRot()
	local direction = RotationToDirection(cameraRotation)

	local destination = {
		x = cameraCoord["x"] + direction["x"] * distance,
		y = cameraCoord["y"] + direction["y"] * distance,
		z = cameraCoord["z"] + direction["z"] * distance
	}

	local a,b,c,d,e = GetShapeTestResult(StartShapeTestRay(cameraCoord["x"],cameraCoord["y"],cameraCoord["z"],destination["x"],destination["y"],destination["z"],-1,PlayerPedId(),0))

	return b,c,e
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADDCIRCLEZONE
-----------------------------------------------------------------------------------------------------------------------------------------
function AddCircleZone(name,center,radius,options,targetoptions)
	Zones[name] = CircleZone:Create(center,radius,options)
	Zones[name]["targetoptions"] = targetoptions
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADDBOXZONE
-----------------------------------------------------------------------------------------------------------------------------------------
function AddBoxZone(name,center,length,width,options,targetoptions)
	Zones[name] = BoxZone:Create(center,length,width,options)
	Zones[name]["targetoptions"] = targetoptions
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADDPOLYZONE
-----------------------------------------------------------------------------------------------------------------------------------------
function AddPolyzone(name,points,options,targetoptions)
	Zones[name] = PolyZone:Create(points,options)
	Zones[name]["targetoptions"] = targetoptions
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADDTARGETMODEL
-----------------------------------------------------------------------------------------------------------------------------------------
function AddTargetModel(models,parameteres)
	for k,v in pairs(models) do
		Models[v] = parameteres
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- EXPORTS
-----------------------------------------------------------------------------------------------------------------------------------------
exports("AddBoxZone",AddBoxZone)
exports("AddPolyzone",AddPolyzone)
exports("AddCircleZone",AddCircleZone)
exports("AddTargetModel",AddTargetModel)

-----------------------------------------------------------------------------------------------------------------------------------------
-- VEICULOS: CAPÔ (HOOD)
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("target:hood")
AddEventHandler("target:hood",function(data)
    local vehicle = data[3]
    if DoesEntityExist(vehicle) then
        if GetVehicleDoorAngleRatio(vehicle, 4) > 0.0 then
            SetVehicleDoorShut(vehicle, 4, false)
        else
            SetVehicleDoorOpen(vehicle, 4, false, false)
        end
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- VEICULOS: PORTA-MALAS (TRUNK)
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("target:trunk")
AddEventHandler("target:trunk",function(data)
    local vehicle = data[3]
    if DoesEntityExist(vehicle) then
        if GetVehicleDoorAngleRatio(vehicle, 5) > 0.0 then
            SetVehicleDoorShut(vehicle, 5, false)
        else
            SetVehicleDoorOpen(vehicle, 5, false, false)
        end
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- VEICULOS: VIDROS (WINDOWS)
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("target:windows")
AddEventHandler("target:windows",function(data)
    local vehicle = data[3]
    if DoesEntityExist(vehicle) then
        -- Verifica se a janela do condutor está levantada para decidir se abre ou fecha todas
        if IsVehicleWindowIntact(vehicle, 0) then
            RollDownWindow(vehicle, 0)
            RollDownWindow(vehicle, 1)
            RollDownWindow(vehicle, 2)
            RollDownWindow(vehicle, 3)
        else
            RollUpWindow(vehicle, 0)
            RollUpWindow(vehicle, 1)
            RollUpWindow(vehicle, 2)
            RollUpWindow(vehicle, 3)
        end
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- VEICULOS: PORTAS GERAIS (DOORS)
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("target:doors")
AddEventHandler("target:doors",function(data)
    local vehicle = data[3]
    if DoesEntityExist(vehicle) then
        -- Verifica a porta do condutor para decidir a lógica, ou alterna as portas da frente
        if GetVehicleDoorAngleRatio(vehicle, 0) > 0.0 or GetVehicleDoorAngleRatio(vehicle, 1) > 0.0 then
            SetVehicleDoorShut(vehicle, 0, false)
            SetVehicleDoorShut(vehicle, 1, false)
            SetVehicleDoorShut(vehicle, 2, false)
            SetVehicleDoorShut(vehicle, 3, false)
        else
            SetVehicleDoorOpen(vehicle, 0, false, false)
            SetVehicleDoorOpen(vehicle, 1, false, false)
            SetVehicleDoorOpen(vehicle, 2, false, false)
            SetVehicleDoorOpen(vehicle, 3, false, false)
        end
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- VEICULOS: MOTOR (ENGINE)
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("target:engine")
AddEventHandler("target:engine",function(data)
    local vehicle = data[3]
    if DoesEntityExist(vehicle) then
        local isRunning = GetIsVehicleEngineRunning(vehicle)
        SetVehicleEngineOn(vehicle, not isRunning, true, true)
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- VEICULOS: VERIFICAR ESTADO (CHECK)
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("target:checkVeh")
AddEventHandler("target:checkVeh",function(data)
    local vehicle = data[3]
    if DoesEntityExist(vehicle) then
        local bodyHealth = GetVehicleBodyHealth(vehicle)
        local engineHealth = GetVehicleEngineHealth(vehicle)
        local fuel = GetVehicleFuelLevel(vehicle)
        
        -- Formata a mensagem. Pode alterar para usar o sistema de notify do seu servidor.
        local message = string.format("Lataria: %.1f%% | Motor: %.1f%% | Combustível: %.1f%%", bodyHealth/10, engineHealth/10, fuel)
        TriggerEvent("Notify","importante",message) -- Certifique-se que o seu servidor usa este evento de Notify
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- ANIM: VASCULHAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("target:animVasculhar")
AddEventHandler("target:animVasculhar",function()
    local ped = PlayerPedId()
    if not IsPedInAnyVehicle(ped) then
        -- Toca animação de vasculhar
        vRP._playAnim(false,{{"amb@prop_human_bum_bin@base","base"}},true)
        -- Congela o jogador durante a ação
        FreezeEntityPosition(ped,true)
        Citizen.Wait(3000)
        -- Solta o jogador
        FreezeEntityPosition(ped,false)
        ClearPedTasks(ped)
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- EFEITO: MORDIDA DE RATO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("target:ratBite")
AddEventHandler("target:ratBite",function()
    local ped = PlayerPedId()
    
    -- Som de impacto seco (menos exagerado que o Wasted)
    PlaySoundFrontend(-1, "Hit", "RESPAWN_ONLINE_SOUNDSET", 1)
    
    -- Efeito visual de dano na tela (pisca vermelho)
    StartScreenEffect("Damage", 0, 0)
    
    -- Treme a câmera levemente (reduzi a intensidade para 0.5)
    ShakeGameplayCam("SMALL_EXPLOSION_SHAKE", 0.05)
    
    -- Aplica 10 de dano ao jogador
    ApplyDamageToPed(ped, 10, false)
    
    -- Para o efeito visual após 1 segundo
    SetTimeout(1000,function()
        StopScreenEffect("Damage")
    end)
end)