local npc = {}

npc._config = teshudata["npc_699"]

local WINDOW_OPTS = {
    background = {skin = "res/custom/all_story_mission/5/699_bg.png"},
    closeButton = {x = 37, y = 10,skin = "res/custom/all_story_mission/5/697_btn.png"},
}
local key = "npc_699"

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
    local function UI_updata(node)
        if not node then
            return
        end

        GUI:removeAllChildren(node)
        GUI:setAnchorPoint(GUI:ItemShow_Create(node, "item", 145, 114, {index=SL:GetMetaValue("ITEM_INDEX_BY_NAME","侠义祝福[称号]"),count = 1,look= true})
        , 0.5, 0.5)

    end

    if p2 == 0 then
        npc._config = teshudata[key]
        npc.data = SL:JsonDecode(msgData, false) or {}
        npc.data.T_dljq = npc.data.T_dljq or {}
        npc.data.sg_data = npc.data.sg_data or {}
        ensureWindow(npcid)
        UI_updata(npc.node)
    end
end

return npc
