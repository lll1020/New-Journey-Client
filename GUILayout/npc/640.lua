local npc = {}

npc._config = teshudata["npc_640"]



local WINDOW_OPTS = {
    background = {skin = "res/custom/all_story_mission/3/640_bg.png"},
    closeButton = {x = 747, y = 380},
}
local key = "npc_640"
local btn_pos = {500, 80}
local cost_pos = {507 - 170, 202 + 60 - 85}

local BOARD_CFG = {
    size = 12,
    cell = 45,
    board_pos = {120, 80},
    board_bg = "res/wy/public/500-300.png",
    board_bg_size = {500, 300},
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

    local function renderBoard()

        npc.xjm_window = NPC_UI_HELPER.ensureWindow(nil, 30, {
            windowName = "npc_640_xjm",
            background = {skin = ""},
            closeButton = {x = cogin.w/2-200, y = cogin.h/2-200},
        })
        npc.xjm_node = npc.xjm_window.node

        local bg = GUI:Frames_Create(npc.xjm_node, "bg", 0,  0, "res/custom/all_story_mission/3/eff_640/eff_", ".png", 1, 85,
                { speed = 75, count = 85, loop = -1})
        GUI:setContentSize(bg, cogin.w, cogin.h)
        GUI:setAnchorPoint(bg, 0.5, 0.5)
        GUI:setTouchEnabled(bg, true)

        local size = (npc.state and npc.state.size) or BOARD_CFG.size
        local cell = BOARD_CFG.cell
        local ox, oy = cogin.w / 2, cogin.h / 2
        local grid_w = size * cell
        local grid_h = size * cell
        local grid = GUI:Node_Create(bg, "grid", ox - grid_w / 2, oy - grid_h / 2)
        
        
        GUI:setContentSize(GUI:Image_Create(grid, "640_kuang", 0, 0, "res/custom/all_story_mission/3/640_kuang.png"), cell * size, cell * size)
        GUI:setContentSize(GUI:Image_Create(grid, "ch_kuang", 0, 0, "res/wy/public/guang.png"), cell * size, cell * size)

        local desc = GUI:Text_Create(grid, "desc",320 + 230,200, 25, "#808080", "我方为黑子")
            GUI:Text_setFontName(desc, "fonts/500.ttf")
        GUI:Text_enableOutline(desc, "#00FFFF", 2)
        
        for y = 1, size do
            for x = 1, size do
                local btn = GUI:Button_Create(grid, "cell_"..x.."_"..y, (x - 1) * cell, (y - 1) * cell, "res/wy/public/bigkuang.png")
                GUI:setContentSize(btn, cell, cell)
                GUI:addOnClickEvent(btn, function()
                    if not npc.state or not npc.state.board then
                        return
                    end
                    if npc.state.result == "win" or npc.state.result == "fail" then
                        return
                    end
                    SL:SendLuaNetMsg(100, npcid, 2, 0, SL:JsonEncode({x = x, y = y}, false))
                end)
            end
        end

        for _, s in ipairs(npc.state and npc.state.board or {}) do
            local px = (s.x - 1) * cell + cell / 2
            local py = (s.y - 1) * cell + cell / 2
            local mark = s.role == 1 and "b" or "w"
            local color = s.role == 1 and "#FFFFFF" or "#FF0000"
            -- local stone = GUI:Text_Create(grid, "stone_"..s.x.."_"..s.y, px, py, 22, color, mark)
            local stone = GUI:Image_Create(grid, "stone_"..s.x.."_"..s.y, px, py, "res/custom/all_story_mission/3/"..mark..".png")
            GUI:setAnchorPoint(stone, 0.5, 0.5)
            -- GUI:Text_setFontName(stone, "fonts/500.ttf")
            -- GUI:Text_enableOutline(stone, "#000000", 1)
        end
    end

    local function UI_updata(node)
        if not node then
            return
        end

        GUI:removeAllChildren(node)

        npc.data.T_dljq[key] = (npc.data.T_dljq and npc.data.T_dljq[key]) and npc.data.T_dljq[key] or 0

        if npc._config.ch then
            local ch_kuang = GUI:Image_Create(node, "ch_kuang", 588, 270, "res/wy/public/70_70_k.png")
            UiTools.showItemData(ch_kuang, SL:GetMetaValue("ITEM_DATA",SL:GetMetaValue("ITEM_INDEX_BY_NAME",npc._config.ch.."[称号]")))
        end

        if npc.state and (npc.state.tip or npc.state.result) then
            local tip = npc.state.tip
            if npc.state.result == "win" then
                tip = "恭喜胜利"
            elseif npc.state.result == "fail" then
                tip = "挑战失败"
            end
            if tip then
                local tip_label = GUI:Text_Create(node, "tip", 420, 420, 18, "#FFD27F", tip)
                GUI:setAnchorPoint(tip_label, 0.5, 0.5)
                GUI:Text_setFontName(tip_label, "fonts/500.ttf")
                GUI:Text_enableOutline(tip_label, "#000000", 1)
            end
        end

        if npc.state and npc.state.board then
            renderBoard()
        end

        if npc._config.cost then
            local cost = checkItemNumByTable_img_kuang(npc._config.cost, nil,GUI:Node_Create(node, "cost", 0, 0))
            GUI:setPosition(cost, cost_pos[1], cost_pos[2])
        end

        local Button= GUI:Button_Create(node, "Button", btn_pos[1], btn_pos[2], "res/custom/all_story_mission/3/btn_641.png")
        GUI:setAnchorPoint(Button, 0.5, 0.5)
        GUI:addOnClickEvent(Button, function()
            SL:SendLuaNetMsg(100, npcid, 1, 0, "")
        end)

    end


    if p2 == 0 then
        npc.data = SL:JsonDecode(msgData,false)
        npc.state = nil
        ensureWindow(npcid)
        UI_updata(npc.node)
    elseif p2 == 1 then
        npc.state = SL:JsonDecode(msgData,false)
        renderBoard()
    elseif p2 == 2 then
        npc.state = SL:JsonDecode(msgData,false)
        renderBoard()
    end
end

return npc
