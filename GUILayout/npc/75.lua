local npc = {}

npc._config = teshudata["npc_75"]



local WINDOW_OPTS = {
    background = {skin = "res/custom/five_city/zbjf/bg.png", eff = true},
    title = {x = 56, y = 464, skin = "res/custom/five_city/zbjf/title.png"},
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
    local function xjm_UI_updata(node,idx) --界面渲染
        if not node then
            return
        end
        GUI:removeAllChildren(node)

        -- SL:dump(npc._config.details[1].cost,"npc75")
        -- SL:dump(idx,"npc75")

        GUI:Text_setFontName(GUI:Text_Create(node, "tip",285,87, 20, "#00FFFF", "装备"..npc._config.details[idx].now)
        , "fonts/500.ttf")


        local cost = checkItemNumByTable_img_kuang(npc._config.details[idx].cost, nil,GUI:Node_Create(node, "cost_show", 0, 0))
        GUI:setPosition(cost, 280 - 47, 130)

        local Button = GUI:Button_Create(node, "Button", 778/2, 0, "res/custom/five_city/zbjf/btn.png")
        GUI:setAnchorPoint(Button, 0.5, 0)
        GUI:addOnClickEvent(Button, function()
            SL:SendLuaNetMsg(100, npcid, 1, 0, SL:JsonEncode({idx = idx}, false))
        end)   

        

    end

    local function UI_updata(node) --界面渲染
        if not node then
            return
        end

        GUI:removeAllChildren(node)
        npc.titles_sign = 1
        npc.xjm = GUI:Node_Create(node, "xjm", 0, 0)

        for i = 1, 4 do
            local cbl_item = GUI:Button_Create(node, "item" .. i, 27 + (i-1)*182, 330, "res/custom/five_city/zbjf/"..(npc.titles_sign == i and "l" or "n").."_"..i..".png")
            GUI:addOnClickEvent(cbl_item, function()
                GUI:Button_loadTextureNormal(GUI:ui_delegate(node)["item" .. npc.titles_sign], "res/custom/five_city/zbjf/n_"..npc.titles_sign..".png")
                npc.titles_sign = i
                GUI:Button_loadTextureNormal(cbl_item, "res/custom/five_city/zbjf/l_"..i..".png")

                xjm_UI_updata(npc.xjm,i)
            end)
        end

        xjm_UI_updata(npc.xjm, npc.titles_sign)


    end


    if p2 == 0 then--界面
        npc.data = SL:JsonDecode(msgData,false)
        ensureWindow(npcid)
        UI_updata(npc.node)
    elseif p2 == 1 then--界面
        npc.data = SL:JsonDecode(msgData,false)
        xjm_UI_updata(npc.xjm, npc.titles_sign)

    end
end

return npc