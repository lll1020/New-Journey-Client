local npc = {}

npc._config = teshudata["npc_47"]



local WINDOW_OPTS = {
    background = {skin = "res/custom/three_city/cbt/bg.png", eff = true},
    title = {x = 56, y = 464, skin = "res/custom/three_city/cbt/title.png"},
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

    local function UI_updata(node) --界面渲染
        if not node then
            return
        end

        GUI:removeAllChildren(node)


        local rwjl_show = ItemNumByTable_img_new(npc._config.cost, nil,GUI:Node_Create(node, "cost", 0, 0))
        GUI:setPosition(rwjl_show, 145, 30)

        for i = 1,3 do
            local kuang = GUI:Image_Create(node, "kuang"..i, 150 + 385 + (i-1)*50, 343.00, "res/wy/public/40-42.png")
            GUI:setAnchorPoint(GUI:ItemShow_Create(kuang, "item", 20, 20, { index = SL:GetMetaValue("ITEM_INDEX_BY_NAME",npc._config.details[4-i].item), look = true, movable = false, bgVisible = false }), 0.5, 0.5)

        end

        -- for i = 1,3 do
        --     GUI:Text_Create(node, "map"..i,360,147 - (i-1)*30, 20, "#00FFFF", npc.data.T_data["level_"..i] and "["..npc._config.details[npc.data.T_data["level_"..i]].itme.."]"..string.format("地图：%s  x:%s  y:%s", npc.data.T_data["map_"..i].map_name, npc.data.T_data["map_"..i].map_x, npc.data.T_data["map_"..i].map_y) or "未揭示宝藏")
        -- end

        GUI:Text_Create(node, "num",300 + 138,150 + 3, 20, "#00FFFF", npc._config.max - npc.data.J_cs)

        GUI:Image_Create(node, "wz", 300, 150.00, "res/custom/three_city/cbt/wz.png")



        local Button= GUI:Button_Create(node, "btn_hc", 550, 20.00, "res/custom/three_city/cbt/btn_hc.png")
        GUI:addOnClickEvent(Button, function()
            SL:SendLuaNetMsg(100, npcid, 1, 0, "")
        end)
        NPC_UI_HELPER.tryStartXylGuide(npc, Button, node, "treasure_master", {
            taskName = "寻宝大师",
            dir = 5,
            desc = "点击合成藏宝图",
        })

        -- Button= GUI:Button_Create(node, "btn", 520, 10.00, "res/custom/three_city/cbt/btn.png")
        -- GUI:addOnClickEvent(Button, function()
        -- end)

    end


    if p2 == 0 then--界面
        npc.data = SL:JsonDecode(msgData,false)
        ensureWindow(npcid)
        UI_updata(npc.node)
    elseif p2 == 1 then
        UI_updata(npc.node)
    end
end

return npc
