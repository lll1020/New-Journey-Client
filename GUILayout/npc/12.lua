local npc = {}

npc._config = teshudata["npc_12"]



local WINDOW_OPTS = {}

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

        GUI:setAnchorPoint(
                GUI:RichText_Create(node, "desc", 200, 430,
                        "<font color='#00FF00' size='20' >每日兑换次数："..npc._config.xg_day.."，当前兑换次数："..(npc.data.dh_num or 0).."</font>"
                , 500, 20, "#f7f7de", 3,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})
        , 0, 1)

        local cllist = GUI:ListView_Create(node, "cllist", 200, 70, 500, 300, 1)
        GUI:ListView_setItemsMargin(cllist, 10)
        for v,k in ipairs(npc._config.sd) do
            local l = GUI:Image_Create(cllist, "img_bj_l_"..v, 0, 0, 'res/wy/public/500-200.png')
            GUI:setContentSize(l, 500, 70)

            local cost = ItemNumByTable_img(k.cost, nil,GUI:Node_Create(l, "cost", 0, 0))
            GUI:setPosition(cost, 10, 10)

            GUI:Text_Create(l, "wz",200,30, 20, "#FF0000", "兑换为")


            local give = ItemNumByTable_img({{k.give,1}}, nil,GUI:Node_Create(l, "give", 0, 0))
            GUI:setPosition(give, 300, 10)

            local Button= GUI:Button_Create(l, "Button", 400, 20, "res/public/1900000660.png")
            GUI:Button_setTitleText(Button, "兑换")
            GUI:Button_setTitleFontSize(Button, 14)

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