local npc = {}

npc._config = teshudata["npc_27"]



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

        local cllist = GUI:ListView_Create(node, "cllist", 200, 100, 500, 350, 1)
        GUI:ListView_setItemsMargin(cllist, 3)

        npc.data.T_data.level = npc.data.T_data.level or {}
        for v,k in ipairs(npc._config.details) do
            local l = GUI:Image_Create(cllist, "img_bj_l_"..v, 0, 0, 'res/wy/public/jdtk_1.png')
            GUI:setContentSize(l, 500, 50)
            GUI:RichText_Create(l, "text_name", 20, 20,
                    "<font color='#00FF00' size='16' >"..k.name.."</font>"..
                            "<font color='#0000FF' size='18' >".."技能等级".." + "..(npc.data.T_data.level[""..v] or 0).."%</font>"..
                            SetCompletionProgress((npc.data.T_data.level[""..v] or 0), k.max_level)
            , 500, 20, "#f7f7de", 3,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})


            local Button= GUI:Button_Create(l, "Button", 350, 5, "res/public/1900000660.png")
            GUI:Button_setTitleText(Button, "升级")
            GUI:Button_setTitleFontSize(Button, 14)

            GUI:addOnClickEvent(Button, function()
                SL:SendLuaNetMsg(100, npcid, 1, v, '')
            end)
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