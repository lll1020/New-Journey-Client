local npc = {}
npc.x_config = teshudata["npc_"..1002]



local WINDOW_OPTS = {
    background = {skin = "res/custom/shape/bg.png", eff = true},
    title = {x = 56, y = 464, skin = "res/custom/shape/title.png"},
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

        npc._config = teshudata["npc_"..npcid]
        local v = npc.x_config.details.sz[npc._config.idx]
        local wz5 = GUI:Text_Create(node, "name",220, 370, 25, "#FF0000", v.name)
        GUI:setAnchorPoint(wz5, 0.5, 0.5)
        GUI:Text_setFontName(wz5, "fonts/500.ttf")
        
        GUI:Effect_Create(node, "sEffect", 100, 250, 0, v.sEffect, 0, 0, 3, 1)
        GUI:Effect_Create(node, "shape", 60 + 270, 100, 4, v.shape, 0, 0, 3, 1)

        local cost_show = checkItemNumByTable_img(npc._config.cost, nil,GUI:Node_Create(node, "cost_show", 0, 0))
        GUI:setPosition(cost_show, 480, 100)



        local Button = GUI:Button_Create(node, "Button", 470, 10.00, "res/custom/shape/btn.png")
        GUI:addOnClickEvent(Button, function()
            SL:SendLuaNetMsg(100, npcid, 1, 0, "")
        end)

    end


    if p2 == 0 then--界面
        npc.data = SL:JsonDecode(msgData,false)
        npc.data.T_data.yjs = npc.data.T_data.yjs or {}
        ensureWindow(npcid)
        UI_updata(npc.node)
    elseif p2 == 1 then
        npc.data = SL:JsonDecode(msgData,false)
        npc.data.T_data.yjs = npc.data.T_data.yjs or {}
        UI_updata(npc.node)
    end
end

return npc