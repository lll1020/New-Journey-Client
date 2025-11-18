local npc = {}

npc._config = teshudata["npc_13"]



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

        if npc.data.dj_num < npc._config.max_level then
            local config = npc._config.config[npc.data.dj_num + 1]
            GUI:setAnchorPoint(
                    GUI:RichText_Create(node, "desc", 200, 430,
                            "<font color='#00FF00' size='20' >当前好感度："..npc.data.dj_num.."</font>\n"..
                                    "<font color='#00FF00' size='20' >当前切割+"..npc._config.config[npc.data.dj_num].ratio.."</font>\n"..
                                    "<font color='#00FF00' size='20' >下一级切割+"..npc._config.config[npc.data.dj_num + 1].ratio.."</font>"
                    , 500, 20, "#f7f7de", 3,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})
            , 0, 1)
            local kuang = GUI:Image_Create(node, "kuang2", 750, 250, "res/wy/public/70_70_k.png")
            local showItem = UiTools.showItemData(kuang, SL:GetMetaValue("ITEM_DATA",SL:GetMetaValue("ITEM_INDEX_BY_NAME",config.cost[1][1])))
            GUI:ItemShow_OnRunFunc(showItem, "SetCount", config.cost[1][2])


            if npc.data.dj_num == 0 then
                kuang = GUI:Image_Create(node, "kuang10", 400, 250, "res/wy/public/70_70_k.png")
                UiTools.showItemData(kuang, SL:GetMetaValue("ITEM_DATA",SL:GetMetaValue("ITEM_INDEX_BY_NAME",npc._config.half_give)))
            end
        end


        local Button= GUI:Button_Create(node, "Button2", 750, 150.00, "res/public/1900000660.png")
        GUI:Button_setTitleText(Button, "提交")
        GUI:Button_setTitleFontSize(Button, 14)

        GUI:addOnClickEvent(Button, function()
            SL:SendLuaNetMsg(100, npcid, 1, 0, '')
        end)

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