local npc = {}

npc._config = teshudata["npc_608"]



local WINDOW_OPTS = {
    background = {skin = "res/custom/all_story_mission/2/608_bg.png"},
    closeButton = {x = 747, y = 380},
}
local key = "npc_608"
local btn_pos = {462, 70}

local function getDisplayRewardList()
    local rewardList = {}
    for _, entry in ipairs(npc._config.rwjl or {}) do
        rewardList[#rewardList + 1] = entry
    end
    if npc._config.ch and npc._config.ch ~= "" then
        rewardList[#rewardList + 1] = {tostring(npc._config.ch) .. "[称号]", 1}
    end
    return rewardList
end

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

        local jl = ItemNumByTable_img_new(getDisplayRewardList(), nil,GUI:Node_Create(node, "jl", 0, 0))
        GUI:setPosition(jl, 390 + 165, 115 + 90)
        npc.data.jq_data[key] = (npc.data.jq_data and npc.data.jq_data[key]) and npc.data.jq_data[key] or 0

        

        if npc.data.jq_data[key] == 0 then
            local Button= GUI:Button_Create(node, "Button", btn_pos[1], btn_pos[2], "res/custom/all_story_mission/2/btn_take.png")
            GUI:setAnchorPoint(Button, 0.5, 0.5)
            GUI:addOnClickEvent(Button, function()
                SL:SendLuaNetMsg(100, npcid, 1, 0, "")
            end)
            NPC_UI_HELPER.tryStartMainlineUpgradeGuide(npc, Button, node, npcid, "story_608_take", {
                taskMap = {[npcid] = 25},
                keyPrefix = "mainline_story_608",
                dir = 5,
                desc = "点击领取任务",
            })
        elseif npc.data.jq_data[key] == 1 then
            local desc = GUI:Text_Create(node, "desc",300,130, 20, "#F4D179", "当前击杀："..(npc.data.sg_data[key] or 0))
            GUI:Text_setFontName(desc, "fonts/502.ttf")
            GUI:Text_enableOutline(desc, "#CA352C", 2)
            
            local Button= GUI:Button_Create(node, "Button", btn_pos[1], btn_pos[2], "res/custom/all_story_mission/2/btn_give.png")
            GUI:setAnchorPoint(Button, 0.5, 0.5)
            GUI:addOnClickEvent(Button, function()
                SL:SendLuaNetMsg(100, npcid, 2, 0, "")
            end)
            NPC_UI_HELPER.tryStartMainlineUpgradeGuide(npc, Button, node, npcid, "story_608_submit", {
                taskMap = {[npcid] = 25},
                keyPrefix = "mainline_story_608",
                dir = 5,
                desc = "点击提交任务",
            })
        elseif npc.data.jq_data[key] == 2 then
            GUI:Image_Create(node, "Button", btn_pos[1], btn_pos[2], "res/wy/public/7_1.png")
        end

    end


    if p2 == 0 then
        npc.data = SL:JsonDecode(msgData,false)
        ensureWindow(npcid)
        UI_updata(npc.node)
    elseif p2 == 1 then
        npc.data.jq_data[key] = p3
        UI_updata(npc.node)
    end
end

return npc
