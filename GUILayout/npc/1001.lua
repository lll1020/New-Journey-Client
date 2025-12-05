local npc = {}

npc._config = {
    {"卍乱·阴阳卍",193,310,},
    {"卍锁·轮回卍",590,310,},
    {"卍斩·因果卍",492,310-180,},
    {"卍破·万法卍",392,310,},
    {"卍渎·神祁卍",292,310-180,},
}



local WINDOW_OPTS = {
    background = {skin = "res/custom/one_city/1001_bg.png", eff = true},
    title = {x = 56, y = 464, skin = "res/custom/one_city/1001_title.png"},
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
        for i, v in ipairs(npc._config) do
            local itemNode =  GUI:Node_Create(node,"node_"..i,v[2],v[3])

            --设置物品图标
            local item = GUI:ItemShow_Create(itemNode, "item", 0, 0, { index = SL:GetMetaValue("ITEM_INDEX_BY_NAME",v[1]), look = true, bgVisible = false })
            GUI:setAnchorPoint(item, 0.5, 0.5)
            GUI:Text_setFontName(GUI:Text_Create(itemNode, "name",-20,-85, 20, "#FF0000", npc.data.T_data[v[1]] or "暂未爆出")
            , "fonts/500.ttf")


        end
        

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