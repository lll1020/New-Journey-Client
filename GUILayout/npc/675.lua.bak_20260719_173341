local npc = {}

npc._config = teshudata["npc_675"]



local WINDOW_OPTS = {
    background = {skin = "res/custom/all_story_mission/4/675_bg.png"},
    closeButton = {x = 747, y = 380},
}
local key = "npc_675"
local btn_pos = {600, 110}
local cost_pos = {643, 195}

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

        npc.data.T_dljq[key] = (npc.data.T_dljq and npc.data.T_dljq[key]) and npc.data.T_dljq[key] or 0

        -- local ch_kuang = GUI:Image_Create(node, "ch_kuang", 553, 125, "res/wy/public/70_70_k.png")
        -- UiTools.showItemData(ch_kuang, SL:GetMetaValue("ITEM_DATA",SL:GetMetaValue("ITEM_INDEX_BY_NAME",npc._config.ch.."[称号]")))

        if npc._config.cost then
            local cost = checkItemNumByTable_img_kuang(npc._config.cost, nil,GUI:Node_Create(node, "cost1", 0, 0))
            GUI:setPosition(cost, cost_pos[1], cost_pos[2])

            local cost = ItemNumByTable_img_new(npc._config.bag_cost, nil,GUI:Node_Create(node, "cost_node2", 0, 0))
            GUI:setPosition(cost, cost_pos[1] - 340, cost_pos[2])
        end

        GUI:RichText_Create(node, "cost_hb", 142 + 132, 50 + 112,  ItemNumByTable(npc._config.hb), 500, 18, "#f7f7de", 3,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})

        local desc = GUI:Text_Create(node, "desc",300 + 358 - 109,50 + 112, 20, "#808080", "切割 + 1888")
        GUI:Text_setFontName(desc, "fonts/501.ttf")
        GUI:Text_enableOutline(desc, "#00FFFF", 2)
        local center_x, center_y = 524, 330
        local spread_w, spread_h = 300, 100
        local min_spacing = 30
        local half_w = spread_w / 2
        local half_h = spread_h / 2
        local positions = {}
        for i = 1, 9 do
            local x, y
            local tries = 0
            while true do
                tries = tries + 1
                x = center_x - half_w + math.random() * spread_w
                y = center_y - half_h + math.random() * spread_h
                local ok = true
                for j = 1, #positions do
                    local dx = x - positions[j][1]
                    local dy = y - positions[j][2]
                    if (dx * dx + dy * dy) < (min_spacing * min_spacing) then
                        ok = false
                        break
                    end
                end
                if ok or tries >= 200 then
                    break
                end
            end
            positions[#positions + 1] = {x, y}
            local star = GUI:Image_Create(node, "star_"..i, x, y, "res/custom/all_story_mission/4/675/t.png")
            if i <= npc.data.T_dljq[key] then
                GUI:Image_setGrey(star, true)
            end
        end


        if npc.data.T_dljq[key] < npc._config.max_num then
            local Button= GUI:Button_Create(node, "Button", btn_pos[1], btn_pos[2], "res/custom/all_story_mission/4/675/btn_1.png")
            GUI:setAnchorPoint(Button, 0.5, 0.5)
            GUI:addOnClickEvent(Button, function()
                SL:SendLuaNetMsg(100, npcid, 1, 0, "")
            end)
            if not checkItemNum(npc._config.bag_cost) then
                local Button= GUI:Button_Create(node, "Button2", btn_pos[1] - 300, btn_pos[2], "res/custom/all_story_mission/4/675/btn_2.png")
                GUI:setAnchorPoint(Button, 0.5, 0.5)
                GUI:addOnClickEvent(Button, function()
                    SL:SendLuaNetMsg(100, npcid, 2, 0, "")
                end)
            end
        else
            GUI:Image_Create(node, "Button", btn_pos[1], btn_pos[2], "res/wy/public/7_1.png")
        end

    

    end


    if p2 == 0 then
        npc.data = SL:JsonDecode(msgData,false)
        ensureWindow(npcid)
        UI_updata(npc.node)
    elseif p2 == 1 then
        npc.data.T_dljq[key] = p3
        UI_updata(npc.node)
    end
end

return npc
