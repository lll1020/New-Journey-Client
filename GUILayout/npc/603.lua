
local npc = {}

npc._config = teshudata["npc_603"]



local WINDOW_OPTS = {
    background = {skin = "res/custom/all_story_mission/2/603_bg.png"},
    closeButton = {x = 747, y = 380},
}
local key = "npc_603"
local btn_pos = {462,70}


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

        local jl = ItemNumByTable_img_new(npc._config.rwjl, nil,GUI:Node_Create(node, "jl", 0, 0))
        GUI:setPosition(jl, 390, 115)
        npc.data.jq_data[key] = (npc.data.jq_data and npc.data.jq_data[key]) and npc.data.jq_data[key] or 0

        

        if npc.data.jq_data[key] == 0 then --接取任务
            local Button= GUI:Button_Create(node, "Button", btn_pos[1], btn_pos[2], "res/custom/all_story_mission/2/btn_take.png")
            GUI:setAnchorPoint(Button, 0.5, 0.5)
            GUI:addOnClickEvent(Button, function()
                SL:SendLuaNetMsg(100, npcid, 1, 0, "")
            end)
        elseif npc.data.jq_data[key] == 1 then --领取奖励
            local desc = GUI:Text_Create(node, "desc",500,200, 20, "#808080", "当前击杀："..(npc.data.sg_data[key] or 0))
            GUI:Text_setFontName(desc, "fonts/500.ttf")
            GUI:Text_enableOutline(desc, "#00FFFF", 2)
            
            local desc = GUI:Text_Create(node, "desc",500,200, 20, "#808080", "当前击杀："..(npc.data.sg_data[key] or 0))
            GUI:Text_setFontName(desc, "fonts/500.ttf")
            GUI:Text_enableOutline(desc, "#00FFFF", 2)
            
            local Button= GUI:Button_Create(node, "Button", btn_pos[1], btn_pos[2], "res/custom/all_story_mission/2/btn_give.png")
            GUI:setAnchorPoint(Button, 0.5, 0.5)
            GUI:addOnClickEvent(Button, function()
                SL:SendLuaNetMsg(100, npcid, 2, 0, "")
            end)
        elseif npc.data.jq_data[key] == 2 then --已完成
            GUI:Image_Create(node, "Button", btn_pos[1], btn_pos[2], "res/wy/public/7_1.png")
        end






       
    end


    if p2 == 0 then--界面
        npc.data = SL:JsonDecode(msgData,false)
        ensureWindow(npcid)
        UI_updata(npc.node)
    elseif p2 == 1 then--刷新数据
        npc.data.jq_data[key] = p3
        UI_updata(npc.node)
    end
end

return npc