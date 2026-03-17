local npc = {}

npc._config = teshudata["npc_43"]



local WINDOW_OPTS = {
    background = {skin = "res/custom/two_city/43_bg.png", eff = true},
    title = {x = 56, y = 464, skin = "res/custom/two_city/43_title.png"},
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

        GUI:Text_setFontName(GUI:Text_Create(node, "new",210,355, 25, "#FF0000", (npc.data.dj_num > 0 and "["..npc._config.ch[npc.data.dj_num].."]" or "[无称号]"))
        , "fonts/500.ttf")
        if npc.data.dj_num > 0 then
            GUI:setAnchorPoint(GUI:RichText_Create(node, "new_attr_desc", 80, 330,  Player:showEquipAttr(SL:GetMetaValue("ITEM_DATA",SL:GetMetaValue("ITEM_INDEX_BY_NAME",npc._config.ch[npc.data.dj_num]))), 200, 17, "#f7f7de", 3,nil,nil)
            , 0, 1)
        else
            GUI:setAnchorPoint(GUI:RichText_Create(node, "new_attr_desc", 80, 330,  "<font color='#00FF00' size='18' >「墨纸未书，\n             侠名待启」</font>\n\n<font color='#00FFFF' size='16' >这张空白的宣纸，\n正等待你的故事。\n用文书与铜钱\n写下第一笔江湖印记，\n从此你的名字，\n将在这片大陆流传。</font>", 200, 17, "#f7f7de", 3,nil,nil)
            , 0, 1)
        end
      


        GUI:Text_setFontName(GUI:Text_Create(node, "next",545,355, 25, "#FF0000", (npc.data.dj_num < npc._config.max_level and "["..npc._config.ch[npc.data.dj_num + 1].."]" or "[已经最高级]"))
        , "fonts/500.ttf")

        if npc.data.dj_num < npc._config.max_level then
            GUI:setAnchorPoint(GUI:RichText_Create(node, "next_attr_desc", 520, 330,  Player:showEquipAttr(SL:GetMetaValue("ITEM_DATA",SL:GetMetaValue("ITEM_INDEX_BY_NAME",npc._config.ch[npc.data.dj_num + 1]))), 200, 17, "#f7f7de", 3,nil,nil)
            , 0, 1)

            local cost_show = ItemNumByTable_img(npc._config.cost[npc.data.dj_num + 1], nil,GUI:Node_Create(node, "cost_show", 0, 0))
            GUI:setPosition(cost_show, 335, 100)

            local Button= GUI:Button_Create(node, "Button", 778/2, 50.00, "res/custom/two_city/43_btn.png")
            GUI:setAnchorPoint(Button, 0.5, 0.5)
            GUI:addOnClickEvent(Button, function()
                SL:SendLuaNetMsg(100, npcid, 1, 0, "")
            end)
            if checkItemNum(npc._config.cost[npc.data.dj_num + 1]) then
                NPC_UI_HELPER.redpoint_create(Button)
            end
        else
            local tip_max = GUI:Text_Create(node, "tip_max",390, 50, 30, "#FF0000", "已达最高等级")
            GUI:Text_setFontName(tip_max, "fonts/500.ttf")
            GUI:setAnchorPoint(tip_max, 0.5, 0.5)
        end


        

    end


    if p2 == 0 then--界面
        npc.data = SL:JsonDecode(msgData,false)
        ensureWindow(npcid)
        UI_updata(npc.node)
    elseif p2 == 1 then
        npc.data.dj_num = npc.data.dj_num + 1
        UI_updata(npc.node)
    end
end

return npc
