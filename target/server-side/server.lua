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
-----------------------------------------------------------------------------------------------------------------------------------------
-- PERMISSÃO POLICIA
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.PermissionPolicia()
	local source = source
	local user_id = vRP.getUserId(source)
	return vRP.hasPermission(user_id,"perm.policia")
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- PERMISSÃO PARAMEDICO
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.PermissionParamedico()
	local source = source
	local user_id = vRP.getUserId(source)
	return vRP.hasPermission(user_id,"perm.paramedico")
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- PERMISSÃO PARAMEDICO
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.PermissionAdmin()
	local source = source
	local user_id = vRP.getUserId(source)
	return vRP.hasPermission(user_id,"admin.permissao")
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VASCULHAR (COOLDOWN POR LIXEIRA + RATO)
-----------------------------------------------------------------------------------------------------------------------------------------
local delayVasculhar = {} -- Tabela: delayVasculhar[user_id][id_lixeira] = tempo
local listaItens = {
    [1] = { item = "plastico", min = 1, max = 3 },
    [2] = { item = "vidro", min = 1, max = 3 },
    [3] = { item = "metal", min = 1, max = 2 },
    [4] = { item = "borracha", min = 1, max = 2 },
    [5] = { item = "garrafavazia", min = 1, max = 3 },
    [6] = { item = "dinheirosujo", min = 50, max = 150 }
}

RegisterServerEvent("target:vasculhar")
AddEventHandler("target:vasculhar",function(data)
    local source = source
    local user_id = vRP.getUserId(source)

    if user_id then
        -- data[4] contém as coordenadas da lixeira vindas do client (x, y, z)
        if data and data[4] then
            local coords = data[4]
            -- Cria uma chave única para essa lixeira baseada na posição dela
            local idLixeira = string.format("%.2f-%.2f-%.2f", coords.x, coords.y, coords.z)

            -- Inicializa a tabela do jogador se não existir
            if not delayVasculhar[user_id] then
                delayVasculhar[user_id] = {}
            end

            -- Verifica o cooldown ESPECÍFICO desta lixeira
            if delayVasculhar[user_id][idLixeira] and os.time() < delayVasculhar[user_id][idLixeira] then
                local tempoRestante = delayVasculhar[user_id][idLixeira] - os.time()
                TriggerClientEvent("Notify",source,"negado","Esta lixeira está vazia. Volte em "..tempoRestante.." segundos.")
                return
            end

            -- Se passou, inicia a animação
            TriggerClientEvent("target:animVasculhar",source)

            SetTimeout(3000,function()
                -- Aplica o cooldown de 1 hora (3600s) APENAS nesta lixeira
                delayVasculhar[user_id][idLixeira] = os.time() + 3600

                -- Lógica de chance (60% itens / 40% rato)
                if math.random(100) <= 60 then
                    local rand = math.random(#listaItens)
                    local selecionado = listaItens[rand]
                    local quantidade = math.random(selecionado.min, selecionado.max)

                    if vRP.getInventoryWeight(user_id) + vRP.getItemWeight(selecionado.item) * quantidade <= vRP.getInventoryMaxWeight(user_id) then
                        vRP.giveInventoryItem(user_id, selecionado.item, quantidade, true)
                        TriggerClientEvent("Notify",source,"sucesso","Você encontrou "..quantidade.."x "..vRP.getItemName(selecionado.item)..".")
                    else
                        TriggerClientEvent("Notify",source,"negado","Mochila cheia.")
                        -- Se quiser permitir tentar de novo porque a mochila estava cheia, descomente a linha abaixo:
                        -- delayVasculhar[user_id][idLixeira] = 0 
                    end
                else
                    -- Rato
                    TriggerClientEvent("Notify",source,"negado","Você foi mordido por um rato!")
                    TriggerClientEvent("target:ratBite",source)
                end
            end)
        end
    end
end)