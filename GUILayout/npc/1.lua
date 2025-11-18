local npc = {}

npc._config = teshudata["npc_1"]



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

        GUI:RichText_Create(node, "desc", 200, 430,
                "<font color='#00FF00' size='20' >最多洗练5次，当前洗练："..(npc.data.cs or 0).."</font>"
        , 500, 20, "#f7f7de", 3,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})

        for i = 1, 5 do
            GUI:RichText_Create(node, "text_name" .. i, 200, 200 + (i - 1) * 30,
                    "<font color='#00FF00' size='16' >"..npc._config.config[i].name.."</font>"..
                            "<font color='#0000FF' size='18' >"..npc._config.config[i].attr_desc.." + </font>"..
                            SetCompletionProgress((npc.data.data[""..i] or 0), npc._config.config[i].range[2])
            , 500, 20, "#f7f7de", 3,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})
        end

        local Button= GUI:Button_Create(node, "Button", 750, 100.00, "res/public/1900000660.png")
        GUI:Button_setTitleText(Button, "刷新灵根")
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
        npc.data.data = SL:JsonDecode(msgData,false)
        npc.data.cs = (npc.data.cs or 0) + 1
        UI_updata(npc.node)
    end
end

return npc