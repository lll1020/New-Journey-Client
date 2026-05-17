local npc = {}
npc._config = teshudata["npc_8"]
local WINDOW_OPTS = {
    background = {skin = "res/custom/one_city/8_bg.png", eff = true},
    title = {x = 56, y = 464, skin = "res/custom/one_city/8_title.png"},
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

    -- 斗笠升级页中的展示装备仅用于预览，不允许拖动。
    local function show_static_item(parent, x, y, itemData)
        local box = GUI:Image_Create(parent, "kuang_" .. tostring(x) .. "_" .. tostring(y), x, y, "res/wy/public/70_70_k.png")
        UiTools.showItemData(box, itemData, nil, nil, {movable = false, doubleTakeOff = false})
        return box
    end

    local function UI_updata(node) --界面渲染
        if not node then
            return
        end
        GUI:removeAllChildren(node)
        local item = SL:GetMetaValue("EQUIP_DATA", npc._config.where)
        if not item then
            local emptyTip = GUI:Text_Create(node, "empty_tip", 450, 110, 28, "#F4D179", "请先穿戴斗笠")
            GUI:setAnchorPoint(emptyTip, 0.5, 0.5)
            GUI:Text_setFontName(emptyTip, "fonts/500.ttf")
            GUI:Text_enableOutline(emptyTip, "#000000", 2)
            return
        end
        local attrDesc = GUI:RichText_Create(node, "attr_desc", 100, 330, "<font color='#00FF00'>人物生命+"..(npc._config.config[Player:getEquipFieldByIndex(item.Index, 1)] and npc._config.config[Player:getEquipFieldByIndex(item.Index, 1)].ex_arrt[1] or 1).."%</font>\n"..Player:showEquipBaseAttr(item), 200, 17, "#f7f7de", 3, nil, nil, {
            outlineSize = 2,
            outlineColor = SL:ConvertColorFromHexString("#000000"),
        })
        GUI:setAnchorPoint(attrDesc, 0, 1)
        local equipLevel = tonumber(Player:getEquipFieldByIndex(item.Index, 1)) or 0
        show_static_item(node, 415, 280, item)
        local config = npc._config.config[equipLevel]
        if equipLevel < npc._config.max_level then
            show_static_item(node, 415 + 209, 280, SL:GetMetaValue("ITEM_DATA", SL:GetMetaValue("ITEM_INDEX_BY_NAME", config.give)))
            local cost_show = checkItemNumByTable_img_kuang(config.cost, nil,GUI:Node_Create(node, "cost_show", 0, 0))
            GUI:setPosition(cost_show, 490, 140)
            local attrDescNext = GUI:RichText_Create(node, "attr_desc_next", 100, 330 - 185, "<font color='#00FF00'>人物生命+"..config.ex_arrt[1].."%</font>\n"..Player:showEquipBaseAttr(SL:GetMetaValue("ITEM_DATA",SL:GetMetaValue("ITEM_INDEX_BY_NAME",config.give))), 200, 17, "#f7f7de", 3, nil, nil, {
                outlineSize = 2,
                outlineColor = SL:ConvertColorFromHexString("#000000"),
            })
            GUI:setAnchorPoint(attrDescNext, 0, 1)
            local Button= GUI:Button_Create(node, "Button", 450, 10.00, "res/custom/one_city/btn_1.png")
            GUI:addOnClickEvent(Button, function()
                SL:SendLuaNetMsg(100, npcid, 1, 0, "")
            end)
            if checkItemNum(config.cost) then
                NPC_UI_HELPER.redpoint_create(Button)
            end
        else
            local tipMax = GUI:Text_Create(node, "tip_max",460,150, 30, "#FF0000", "已达最高等级")
            GUI:Text_setFontName(tipMax, "fonts/500.ttf")
            GUI:Text_enableOutline(tipMax, "#000000", 2)
        end
    end
    if p2 == 0 then--界面
        npc.data = SL:JsonDecode(msgData,false)
        ensureWindow(npcid)
        UI_updata(npc.node)
    elseif p2 == 1 then
        UI_updata(npc.node)
    end
end
return npc
