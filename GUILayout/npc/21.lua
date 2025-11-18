local npc = {}

npc._config = teshudata["npc_21"]



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
        --{"level":0,"exp":0}

        local config = npc._config.details[npc.data.level + 1]

        local cost = ItemNumByTable_img(config.cost, nil,GUI:Node_Create(node, "cost", 0, 0))
        GUI:setPosition(cost, 200, 200)

        GUI:setAnchorPoint(
                GUI:RichText_Create(node, "desc", 200, 430,
                        "<font color='#00FF00' size='20' >当前修仙值："..npc.data.exp.."</font>\n"..
                        "<font color='#00FF00' size='20' >当前修仙等级："..(npc._config.details[npc.data.level] and npc._config.details[npc.data.level].title or "无").."</font>\n"..
                        "<font color='#00FF00' size='20' >下一级需要的修仙值："..config.need_xxz.."</font>\n"..
                        "<font color='#00FF00' size='20' >下一级修仙等级："..(config.title or 0).."</font>\n"
                , 500, 20, "#f7f7de", 3,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})
        , 0, 1)


        local Button= GUI:Button_Create(node, "Button", 750, 100.00, "res/public/1900000660.png")
        GUI:Button_setTitleText(Button, "升级")
        GUI:Button_setTitleFontSize(Button, 14)

        GUI:addOnClickEvent(Button, function()
            SL:SendLuaNetMsg(100, npcid, 1, 0, "")
        end)

    end


    if p2 == 0 then--界面
        npc.data = SL:JsonDecode(msgData,false)
        ensureWindow(npcid)
        UI_updata(npc.node)
    elseif p2 == 1 then
        npc.data.level = npc.data.level + 1
        UI_updata(npc.node)
    end
end

return npc