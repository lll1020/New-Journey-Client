local npc = {}

npc._config = {

     rwjl = {{"仙草种子",9},{"元宝",200000}},
}


local WINDOW_OPTS = {
    background = {skin = "res/custom/three_city/xfts/bg.png", eff = true},
    title = {x = 56, y = 464, skin = "res/custom/three_city/xfts/title.png"},
}

local function createText(parent, name, x, y, size, color, text)
    local label = GUI:Text_Create(parent, name, x, y, size, color, text)
    GUI:setAnchorPoint(label, 0.5, 0.5)
    GUI:Text_enableOutline(label, "#100808", 2)
    return label
end

local function createOpenWayShow(parent, name, x, title, items, tip)
    local group = GUI:Node_Create(parent, name, x, 0)
    -- createText(group, "title", 0, 135, 22, "#FFF2D7", title)
    local itemShow = ItemNumByTable_img_new(items, nil, GUI:Node_Create(group, "items", -35, 55 + 44))
    GUI:setScale(itemShow, 0.9)
    createText(group, "tip", 0, 38 + 40, 16, "#9CFF87", tip)
    return group
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




        -- GUI:setAnchorPoint(
        --         GUI:RichText_Create(node, "desc", 200, 430,
        --                 "<font color='#00FF00' size='20' >领取任务 共计击杀200只怪物，当前击杀："..(npc.data.sg_data.npc_55 or 0).."</font>"
        --         , 500, 20, "#f7f7de", 3,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})
        -- , 0, 1)
        --显示奖励
        -- local rwjl_show = ItemNumByTable_img_new(npc._config.rwjl, nil,GUI:Node_Create(node, "rwjl", 0, 0))
        -- GUI:setPosition(rwjl_show, 490, 80)
        



        if npc.data.jq_data["npc_55"] and npc.data.jq_data["npc_55"] == 2 then
            GUI:Text_setFontName(GUI:Text_Create(node, "tip",450,30, 25, "#00FF00", "任务已完成，恭喜您！")
            , "fonts/500.ttf")
        else



            local openCfg = npc.data.open_cfg or {}
            local permitItem = openCfg.permit_item or "开辟许可证"
            local forceCost = openCfg.force_cost or {{"碎岩锤", 20}}
            createOpenWayShow(node, "permit_way_show", 350 + 110, "", {{permitItem, 1}}, "拥有即可，不消耗")
            createOpenWayShow(node, "force_way_show", 550 + 110, "", forceCost, "消耗材料开辟")

            local Button= GUI:Button_Create(node, "Button1", 450 - 100, 0.00, "res/custom/three_city/xfts/btn1.png")
            GUI:addOnClickEvent(Button, function()
                SL:SendLuaNetMsg(100, npcid, 1, 0, "")
            end)
            local Button= GUI:Button_Create(node, "Button2", 450 + 100, 0.00, "res/custom/three_city/xfts/btn2.png")
            GUI:addOnClickEvent(Button, function()
                SL:SendLuaNetMsg(100, npcid, 2, 0, "")
            end)
        end
        
    end


    if p2 == 0 then--界面
        npc.data = SL:JsonDecode(msgData,false)
        ensureWindow(npcid)
        UI_updata(npc.node)
    elseif p2 == 1 then
        npc.data.jq_data["npc_55"] = p3
        UI_updata(npc.node)
    end
end

return npc
