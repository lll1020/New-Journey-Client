local npc = {}

npc._config = teshudata["npc_14"]



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

        local cllist = GUI:ListView_Create(node, "cllist", 200, 70, 500, 300, 1)
        GUI:ListView_setItemsMargin(cllist, 3)
        for v,k in ipairs(npc._config.config) do
            local l = GUI:Image_Create(cllist, "img_bj_l_"..v, 0, 0, 'res/wy/public/jdtk_1.png')
            GUI:setContentSize(l, 500, 50)
            GUI:RichText_Create(l, "text_name", 20, 20,
                    "<font color='#00FF00' size='16' >"..k.cost[1][1].."</font>"..
                            "<font color='#0000FF' size='18' >"..k.attr_desc.." + "..(npc.data.dj_data[""..v] or 0).."</font>"..
                            SetCompletionProgress((npc.data.dj_data[""..v] or 0), k.max_level)
            , 500, 20, "#f7f7de", 3,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})


            local Button= GUI:Button_Create(l, "Button", 350, 5, "res/public/1900000660.png")
            GUI:Button_setTitleText(Button, "食用")
            GUI:Button_setTitleFontSize(Button, 14)

            GUI:addOnTouchEvent(Button, function(sender, type)
                -- 触发控件（sender）：控件本身
                -- 事件类型（type）：触摸阶段 0-3
                if type == SLDefine.TouchEventType.began then           -- 0 触摸开始
                    if not sender._clicking then
                        sender._clicking = true
                        SL:scheduleOnce(sender, function()
                            GUI:schedule(Button, function()
                                if sender._clicking then
                                    SL:SendLuaNetMsg(100, npcid, 1, 0, '{"idx":'..v..'}')
                                else
                                    GUI:unSchedule(Button)
                                end
                            end,0.1)
                        end, 0.5)
                    end
                elseif type == SLDefine.TouchEventType.moved then       -- 1 触摸移动


                elseif type == SLDefine.TouchEventType.ended or type == SLDefine.TouchEventType.canceled then       -- 2 触摸结束 3 触摸取消
                    if sender._clicking then
                        sender._clicking = false
                        SL:SendLuaNetMsg(100, npcid, 1, 0, '{"idx":'..v..'}')
                    end
                end
            end)
        end

        local kuang = GUI:Image_Create(node, "kuang2", 750, 250, "res/wy/public/70_70_k.png")
        UiTools.showItemData(kuang, SL:GetMetaValue("ITEM_DATA",SL:GetMetaValue("ITEM_INDEX_BY_NAME",npc._config.title.."[称号]")))
    end


    if p2 == 0 then--界面
        npc.data = SL:JsonDecode(msgData,false)
        ensureWindow(npcid)
        UI_updata(npc.node)
    elseif p2 == 1 then
        --npc.data = SL:JsonDecode(msgData,false)
        --UI_updata(npc.node)
    end
end

return npc
