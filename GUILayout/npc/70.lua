local npc = {}

npc._config = teshudata["npc_70"]



local WINDOW_OPTS = {
    background = {skin = "res/custom/five_city/emjg/bg.png", eff = true},
    title = {x = 56, y = 464, skin = "res/custom/five_city/emjg/title.png"},
}
function npc.main(npcid, p2, p3, msgData)


    local function ensureWindow(npcid)
        local opts = {}
        for k, v in pairs(WINDOW_OPTS) do
            opts[k] = v
        end
        opts.titleText = NPC_UI_HELPER.formatNpcTitle(npcid, npc._config)
        opts.subTitle = npc._config and npc._config.title
        npc._window = NPC_UI_HELPER.ensureWindow(npc._window, npcid, opts)
        npc.bg = npc._window.bg
        npc.node = npc._window.node
        return npc.node
    end

    local function UI_updata(node) --鐣岄潰娓叉煋
        if not node then
            return
        end

        GUI:removeAllChildren(node)

        for i = 1, 4 do
            local kuang = GUI:Image_Create(node, "kuang"..i, 100 + (i-1)*150, 250.00, "res/custom/five_city/emjg/kuang.png")

            local itemShow = GUI:ItemShow_Create(kuang, "item", 69, 81, { index = SL:GetMetaValue("ITEM_INDEX_BY_NAME",npc._config.details[i].cost[1][1]), look = true, bgVisible = false })
            itemShow:setAnchorPoint(cc.p(0.5, 0.5))
        end
        checkItemNumByTable_img_kuang(npc._config.cost[1], nil,GUI:Node_Create(node, "cost_node1", 160, 180))
        checkItemNumByTable_img_kuang(npc._config.cost[2], nil,GUI:Node_Create(node, "cost_node2", 500, 180))

        local Button= GUI:Button_Create(node, "Button1", 150, 70.00, "res/custom/five_city/emjg/btn_1.png")
        GUI:addOnClickEvent(Button, function()
            SL:SendLuaNetMsg(100, npcid, 1, 0, SL:JsonEncode({idx = 1}, false))
        end)
        if checkItemNum(npc._config.cost[1]) then
            NPC_UI_HELPER.redpoint_create(Button)
        end

        local Button= GUI:Button_Create(node, "Button2", 150 + 340, 70.00, "res/custom/five_city/emjg/btn_2.png")
        GUI:addOnClickEvent(Button, function() 
            SL:SendLuaNetMsg(100, npcid, 1, 0, SL:JsonEncode({idx = 2}, false))
        end)
        if checkItemNum(npc._config.cost[2]) then
            NPC_UI_HELPER.redpoint_create(Button)
        end

        GUI:TextAtlas_Create(node, "TextAtlas_1", 190, 32, npc.data.num, "res/custom/public/text1.png", 14, 30, ".")

        
       
    end


    if p2 == 0 then--鐣岄潰
        npc.data = SL:JsonDecode(msgData,false)
        ensureWindow(npcid)
        UI_updata(npc.node)
    elseif p2 == 1 then--鐣岄潰
        npc.data = SL:JsonDecode(msgData,false)
        UI_updata(npc.node)
    end
end

return npc
