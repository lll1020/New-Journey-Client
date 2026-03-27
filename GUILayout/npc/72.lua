local npc = {}

npc._config = teshudata["npc_72"]



local WINDOW_OPTS = {
    background = {skin = "res/custom/five_city/sgshz/bg.png", eff = true},
    title = {x = 56, y = 464, skin = "res/custom/five_city/sgshz/title.png"},
}

local ATTR_PERCENT_SCALE = {
    [22] = 1,
    [23] = 1,
    [34] = 100,
    [35] = 100,
    [36] = 100,
    [79] = 100,
    [80] = 100,
    [81] = 100,
    [245] = 100,
}

local function buildProgressText(num1, num2)
    num1 = tonumber(num1 or 0) or 0
    num2 = tonumber(num2 or 0) or 0
    if num1 >= num2 and num2 > 0 then
        return "<font color='#FF0000' size='20' >已满级</font>"
    end
    return string.format("<font color='#00FF00' size='20' >进度 %d/%d</font>", num1, num2)
end

local function formatAttrValue(cfg, value)
    local scale = ATTR_PERCENT_SCALE[cfg.attrID]
    if scale then
        local num = value / scale
        if num == math.floor(num) then
            return string.format("%d%%", num)
        end
        return string.format("%.2f%%", num)
    end
    return tostring(value)
end

local function buildAttrValueText(cfg, level)
    if not cfg then
        return ""
    end
    level = tonumber(level or 0) or 0
    local maxLevel = tonumber(cfg.max_level or 0) or 0
    if maxLevel > 0 and level > maxLevel then
        level = maxLevel
    end

    local ratio = tonumber(cfg.ratio or 0) or 0
    local value = level * ratio
    local isMax = maxLevel > 0 and level >= maxLevel
    local valueColor = isMax and "#CA352C" or "#00B4FF"
    return string.format(
        "<font color='#FFFFFF' size='18' >%s+</font><font color='%s' size='18' >%s</font>",
        tostring(cfg.attr_desc or "当前属性"),
        valueColor,
        formatAttrValue(cfg, value)
    )
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

    local function UI_updata(node) --界面渲染
        if not node then
            return
        end

        GUI:removeAllChildren(node)
        GUI:setAnchorPoint(GUI:ItemShow_Create(node, "item1", 383,53, { index = SL:GetMetaValue("ITEM_INDEX_BY_NAME",npc._config.cost[1][1]), look = true, bgVisible = false }),0.5, 0.5)


        local list = GUI:ListView_Create(node, "list", 30, 80, 700, 260,1)
        GUI:ListView_setItemsMargin(list, 54)
        GUI:ListView_setBounceEnabled(list, true)


        for i=0,10 do
            local box_node = GUI:Node_Create(list, "box_node"..i, 0, 0)
            if i%2 == 1 then
                GUI:Image_Create(box_node, "box", 0, -10, "res/custom/five_city/sgshz/box.png")
            end
            if i > 0 then
                GUI:Text_setFontName(GUI:Text_Create(box_node, "lv",15,10, 25, "#00FFFF", "时光之杖lv."..i), "fonts/501.ttf")

                GUI:Text_setFontName(GUI:Text_Create(box_node, "attr_desc",220,10, 25, "#FF00FF", npc._config.config[i].attr_desc), "fonts/501.ttf")

                GUI:setAnchorPoint(
                    GUI:RichText_Create(box_node, "attr_value", 380, 10,
                        buildAttrValueText(npc._config.config[i], (npc.data.dj_data[""..i] or 0))
                    , 180, 18, "#f7f7de", 1,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})
                ,0, 0)
                -- local attr_desc = GUI:Text_Create(box_node, "attr_value",460, -2, 25, "#FF00FF", buildAttrValueText(npc._config.config[i], (npc.data.dj_data[""..i] or 0)))
                -- GUI:Text_setFontName(attr_desc, "fonts/font4.ttf")
                -- GUI:setAnchorPoint(attr_desc ,0.5, 0)
                local Button= GUI:Button_Create(box_node, "Button", 560, 4, "res/custom/five_city/sgshz/btn.png")
                GUI:addOnClickEvent(Button, function() 
                    SL:SendLuaNetMsg(100, npcid, 1, 0, SL:JsonEncode({idx = i}, false))
                end)
            end

        end

    

        
       
    end


    if p2 == 0 then--界面
        npc.data = SL:JsonDecode(msgData,false)
        ensureWindow(npcid)
        UI_updata(npc.node)
    elseif p2 == 1 then--界面
        npc.data = SL:JsonDecode(msgData,false)
        
        for i=1,10 do
            local boxNode = GUI:ui_delegate(GUI:ui_delegate(npc.node).list)["box_node"..i]
            GUI:removeChildByName(boxNode, "num")
            GUI:removeChildByName(boxNode, "attr_value")
            GUI:setAnchorPoint(
                GUI:RichText_Create(boxNode, "attr_value", 380, 10,
                    buildAttrValueText(npc._config.config[i], (npc.data.dj_data[""..i] or 0))
                , 180, 18, "#f7f7de", 1,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})
            ,0, 0)

        end
    end
end

return npc
