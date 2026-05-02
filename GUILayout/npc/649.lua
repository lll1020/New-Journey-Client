local npc = {}

npc._config = teshudata["npc_649"]



local WINDOW_OPTS = {
    background = {skin = "res/custom/all_story_mission/4/649_bg.png"},
    closeButton = {x = 747, y = 380},
}
local key = "npc_649"
local try_key = key.."_try"
local ok_key = key.."_ok"
local btn_pos = {600, 170}
local cost_pos = {507 + 25, 202 + 10}

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

        local jl = ItemNumByTable_img_new(npc._config.jl, nil,GUI:Node_Create(node, "jl", 0, 0))
        GUI:setPosition(jl, 190 - 10, 90)
        

        npc.data.T_dljq[key] = (npc.data.T_dljq and npc.data.T_dljq[key]) and npc.data.T_dljq[key] or 0
        npc.data.T_dljq[try_key] = (npc.data.T_dljq and npc.data.T_dljq[try_key]) and npc.data.T_dljq[try_key] or 0
        npc.data.T_dljq[ok_key] = (npc.data.T_dljq and npc.data.T_dljq[ok_key]) and npc.data.T_dljq[ok_key] or 0

        local desc = GUI:Text_Create(node, "desc1",160 + 158 + 34,211, 20, "#808080", npc.data.T_dljq[try_key])
        GUI:Text_setFontName(desc, "fonts/500.ttf")
        GUI:Text_enableOutline(desc, "#FFFF00", 2)


        desc = GUI:Text_Create(node, "desc2",160 + 158 + 34,185, 20, "#808080", npc.data.T_dljq[ok_key])
        GUI:Text_setFontName(desc, "fonts/500.ttf")
        GUI:Text_enableOutline(desc, "#FFFF00", 2)

        if npc.data.T_dljq[key] == 1 or npc.data.T_dljq[key] == 0 then
            local Button= GUI:Button_Create(node, "Button", btn_pos[1], btn_pos[2], "res/custom/all_story_mission/4/649_btn.png")
            GUI:setAnchorPoint(Button, 0.5, 0.5)
            GUI:addOnClickEvent(Button, function()
                SL:SendLuaNetMsg(100, npcid, 1, 0, "")
            end)
        elseif npc.data.T_dljq[key] == 2 then
            GUI:Image_Create(node, "Button", btn_pos[1], btn_pos[2], "res/wy/public/7_1.png")
        end


    

    end


    if p2 == 0 then
        npc.data = SL:JsonDecode(msgData,false)
        ensureWindow(npcid)
        UI_updata(npc.node)
    elseif p2 == 1 then
        local data = SL:JsonDecode(msgData,false)
        npc.data.T_dljq[key] = p3
        npc.data.T_dljq[try_key] = data.try_key
        npc.data.T_dljq[ok_key] = data.ok_key
        UI_updata(npc.node)
    end
end

return npc
