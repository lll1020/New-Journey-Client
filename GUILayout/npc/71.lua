local npc = {}

npc._config = teshudata["npc_71"]



local WINDOW_OPTS = {
    background = {skin = "res/custom/five_city/jxmj/bg.png", eff = false},
    closeButton = {x = 400 + 247, y = 200 + 100},
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

        local itemShow = GUI:ItemShow_Create(node, "next", 372, 202, { index = SL:GetMetaValue("ITEM_INDEX_BY_NAME","酒仙剑"), look = true, bgVisible = false })
        itemShow:setAnchorPoint(cc.p(0.5, 0.5))

        local Button = GUI:Button_Create(node, "Button1", 250, 30.00, "res/custom/five_city/jxmj/btn.png")
        GUI:addOnClickEvent(Button, function()
            SL:SendLuaNetMsg(100, npcid, 1, 0, "")
        end)

        
       
    end


    if p2 == 0 then--界面
        npc.data = SL:JsonDecode(msgData,false)
        ensureWindow(npcid)
        UI_updata(npc.node)
    elseif p2 == 1 then--界面
        npc.data = SL:JsonDecode(msgData,false)
        UI_updata(npc.node)
    end
end

return npc