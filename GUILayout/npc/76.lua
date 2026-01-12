local npc = {}

npc._config = teshudata["npc_76"]



local WINDOW_OPTS = {
    background = {skin = "res/custom/five_city/tmsl/bg.png", eff = true},
    title = {x = 56, y = 464, skin = "res/custom/five_city/tmsl/title.png"},
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
    local function GUI_createLabel(node,idx) --界面渲染
        GUI:removeAllChildren(node)

        npc.data.T_data["npc_76"] = npc.data.T_data["npc_76"] or {}
        local tip = GUI:Text_Create(node, "tip",300,150 + 177 - 140, 20, "#00FFFF", "完成【"..teshudata["npc_74"].details[idx].name.."】天道命盘任务")
        GUI:Text_setFontName(tip, "fonts/500.ttf")
        GUI:setAnchorPoint(tip, 0.5, 0.5)
        local cost = checkItemNumByTable_img_kuang(npc._config.details[idx].cost, nil,GUI:Node_Create(node, "cost_show", 0, 0))
        GUI:setPosition(cost, 400, 100)
        cost = checkItemNumByTable_img_kuang(npc._config.details[idx].reward, nil,GUI:Node_Create(node, "jl_show", 0, 0))
        GUI:setPosition(cost, 205, 100)

        

        cost = ItemNumByTable_img_new({{"天命·复活",1},{"天命·麻痹",1},{"天命·神镰",1},{"天命·神斧",1}}, nil,GUI:Node_Create(node, "jl2_show", 0, 0))
        GUI:setPosition(cost, 80, 20)


        if npc.data.T_data["npc_76"][""..idx] then
            GUI:setAnchorPoint(GUI:Image_Create(node, "Button", 480, 0, "res/wy/public/10_2.png")
            , 0.5, 0)
        else
            local Button = GUI:Button_Create(node, "Button", 480, 0, "res/custom/five_city/tmsl/btn.png")
            GUI:setAnchorPoint(Button, 0.5, 0)
            GUI:addOnClickEvent(Button, function()
                SL:SendLuaNetMsg(100, npcid, 1, 0, SL:JsonEncode({idx = idx}, false))
            end)   
        end

    end

    local function UI_updata(node) --界面渲染
        if not node then
            return
        end

        GUI:removeAllChildren(node)
        npc.cbl_list = GUI:ListView_Create(node, "cbl_list", -5, 10, 170, 440, 1)
        GUI:ListView_setGravity(npc.cbl_list, 1)
        GUI:ListView_setItemsMargin(npc.cbl_list, 10)
        npc.Label = GUI:Node_Create(node, "Label", 170, 15)

        npc.titles_sign = 1
        for i = 1, 4 do
            local cbl_item = GUI:Button_Create(npc.cbl_list, "item" .. i, 0, 0, "res/custom/five_city/tmsl/list/"..(npc.titles_sign == i and "l" or "n").."/"..i..".png")
            -- GUI:Button_setTitleText(cbl_item, titles[i])
            -- GUI:Button_setTitleFontSize(cbl_item, 14)
            GUI:Image_Create(npc.cbl_list, "fgx"..i, 0, 0, "res/custom/fulitating/list/fgx.png")
            GUI:addOnClickEvent(cbl_item, function()
                GUI:Button_loadTextureNormal(GUI:ui_delegate(npc.cbl_list)["item" .. npc.titles_sign], "res/custom/five_city/tmsl/list/n/"..npc.titles_sign..".png")
                npc.titles_sign = i
                GUI_createLabel(npc.Label,i)

                GUI:Button_loadTextureNormal(GUI:ui_delegate(npc.cbl_list)["item" .. npc.titles_sign], "res/custom/five_city/tmsl/list/l/"..npc.titles_sign..".png")
            end)
        end
        GUI_createLabel(npc.Label,npc.titles_sign)




    end


    if p2 == 0 then--界面
        npc.data = SL:JsonDecode(msgData,false)
        ensureWindow(npcid)
        UI_updata(npc.node)
    elseif p2 == 1 then--界面
        npc.data = SL:JsonDecode(msgData,false)
        GUI_createLabel(npc.Label, npc.titles_sign)

    end
end

return npc