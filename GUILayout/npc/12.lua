local npc = {}

npc._config = teshudata["npc_12"]



local WINDOW_OPTS = {
    background = {skin = "res/custom/one_city/clyz/bg.png", eff = true},
    title = {x = 56, y = 464, skin = "res/custom/one_city/clyz/title.png"},
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

        -- GUI:setAnchorPoint(
        --         GUI:RichText_Create(node, "desc", 200, 430,
        --                 "<font color='#00FF00' size='20' >每日兑换次数："..npc._config.xg_day.."，当前兑换次数："..(npc.data.dh_num or 0).."</font>"
        --         , 500, 20, "#f7f7de", 3,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})
        -- , 0, 1)

       
       
        GUI:setAnchorPoint(GUI:Image_Create(node, "tip_1", 778/2, 40, "res/custom/one_city/clyz/tip_1.png")
        , 0.5, 0.5)

        GUI:setAnchorPoint(GUI:Image_Create(node, "tip_wz", 430, 360, "res/custom/one_city/clyz/tip_wz.png")
        , 0.5, 0.5)

        GUI:RichText_Create(node, "desc", 490, 348,
                "<font color='#00FF00' size='20' >"..npc._config.xg_day - (npc.data.dh_num or 0).."</font>"
        , 500, 30, "#f7f7de", 3,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})
        


        local cllist = GUI:ListView_Create(node, "cllist", 30, 70, 720, 300, 2)
        GUI:ListView_setItemsMargin(cllist, 3)
        for v,k in ipairs(npc._config.sd) do
            local l = GUI:Image_Create(cllist, "img_bj_l_"..v, 0, 0, "res/custom/one_city/clyz/kuang.png")

            local cost = GUI:RichText_Create(l, "cost", 90, 20,  checkItemNumByTable(k.cost), 500, 18, "#f7f7de", 3,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})
            GUI:setAnchorPoint(cost, 0.5, 0.5)



            local give = ItemNumByTable_img({{k.give,1}}, nil,GUI:Node_Create(l, "give", 0, 0))
            GUI:setPosition(give, 65, 60)
            local name = GUI:Text_Create(l, "name",90,190, 25, "#FF0000", k.give)
            GUI:Text_setFontName(name, "fonts/500.ttf")
            GUI:setAnchorPoint(name, 0.5, 0.5)
            GUI:Text_enableOutline(name, "#000000", 2)

            local Button= GUI:Button_Create(l, "Button", 90, -30, "res/custom/one_city/clyz/btn.png")
            GUI:setAnchorPoint(Button, 0.5, 0.5)
            GUI:addOnClickEvent(Button, function()
                SL:SendLuaNetMsg(100, npcid, 1, v, "")
            end)
        end

    end


    if p2 == 0 then--界面
        npc.data = SL:JsonDecode(msgData,false)
        ensureWindow(npcid)
        UI_updata(npc.node)
    elseif p2 == 1 then
        npc.data = SL:JsonDecode(msgData,false)
        UI_updata(npc.node)
    end
end

return npc
