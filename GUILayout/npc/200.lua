
local npc = {}

npc._config = {

    --{"地图名",x,y,限制fun,提示文字,所属大陆}
    [201] = {"山庄",0,0,nil,nil,1},
    [202] = {"幽谷",0,0,nil,nil,1},
    [203] = {"洞穴",0,0,nil,nil,1},
    [204] = {"古殿",0,0,nil,nil,1},

    [205] = {"隐藏地图二",100,100,nil,nil,2},
    [206] = {"野火帮",100,100,nil,nil,2},
    [207] = {"极光城郊",100,100,nil,nil,2},
    [208] = {"兵道古藏",100,100,nil,nil,2},
    [209] = {"夜魔洞",100,100,nil,nil,2},
    [210] = {"特殊秘境副本二",100,100,nil,nil,2},

    [211] = {"隐藏地图三",100,100,nil,nil,3},
    [212] = {"灰界",100,100,nil,nil,3},
    [213] = {"群星海",100,100,nil,nil,3},
    [214] = {"红尘城",100,100,nil,nil,3},
    [215] = {"无主深渊",100,100,nil,nil,3},
    [216] = {"草药谷",100,100,nil,nil,3},
    [217] = {"特殊秘境副本三",100,100,nil,nil,3},
}


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

        local Button= GUI:Button_Create(node, "Button", 750, 100.00, "res/public/1900000660.png")
        GUI:Button_setTitleText(Button, "进入地图")
        GUI:Button_setTitleFontSize(Button, 14)

        GUI:addOnClickEvent(Button, function()
            SL:SendLuaNetMsg(100, npcid, 1, 0, "")
        end)
        if npcid == 201 or npcid == 202 or npcid == 203 or npcid == 204 then
            Button= GUI:Button_Create(node, "Button1", 750, 200.00, "res/public/1900000660.png")
            GUI:Button_setTitleText(Button, "进入地图深处")
            GUI:Button_setTitleFontSize(Button, 14)

            GUI:addOnClickEvent(Button, function()
                SL:SendLuaNetMsg(100, npcid, 1, 1, "")
            end)
        end
    end


    if p2 == 0 then--界面
        npc.data = SL:JsonDecode(msgData,false)
        ensureWindow(npcid)
        UI_updata(npc.node)
    end
end

return npc