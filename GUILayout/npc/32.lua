local npc = {}

npc._config = teshudata["npc_32"]



local WINDOW_OPTS = {
    background = {skin = "res/custom/zhuansheng/bg.png", eff = true},
    title = {x = 56, y = 464, skin = "res/custom/zhuansheng/title.png"},
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


        local level = npc.data.level
        

        -- GUI:setAnchorPoint(
        --         GUI:RichText_Create(node, "desc", 200, 430,
        --                 "<font color='#00FF00' size='20' >当前转生等级："..level.."</font>"
        --         , 500, 20, "#f7f7de", 3,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})
        -- , 0, 1)
        local cx, cy = 386, 70
        local r = 300
        local angles = {30, 42, 54, 66, 78, 102, 114, 126, 138, 150}
        for i = 1, 10 do
            local rad = math.rad(angles[i])
            local x = cx + r * math.cos(rad)
            local y = cy + r * math.sin(rad)
            local star = GUI:Image_Create(node, "star" .. i, x, y, i <= (level % 10) and "res/custom/zhuansheng/k_2.png" or "res/custom/zhuansheng/k_1.png")
            GUI:setAnchorPoint(star, 0.5, 0.5)
        end

        local kaung = GUI:Image_Create(node, "kaung", 386, 120, "res/custom/zhuansheng/kaung.png")
        GUI:setAnchorPoint(kaung, 0.5, 0.5)
        local stage = math.floor(level / 10) + 1
        local rank = level % 10
        local level_wz = GUI:Text_Create(kaung, "level", kaung:getContentSize().width / 2, kaung:getContentSize().height / 2 + 10, 30, "#FFFFFF", string.format("%d阶转生·%d重", stage, rank))
        GUI:setAnchorPoint(level_wz, 0.5, 0.5)
        GUI:Text_setFontName(level_wz, "fonts/501.ttf")

        


        if level < npc._config.max_level then
            local config = npc._config.details[level + 1]

            if config and config.req_desc and config.req_desc ~= "" then
                local desc = GUI:Text_Create(node, "desc",386, 160, 20, "#00FB00", config.req_desc)
                GUI:Text_setFontName(desc, "fonts/500.ttf")
                GUI:Text_enableOutline(desc, "#F03022", 2)
                GUI:setAnchorPoint(desc, 0.5, 0.5)
            end

            
            
            GUI:setContentSize(GUI:Image_Create(node, "rw_tb_bj", 50 + 160 - 5,40 + 145, "res/wy/public/tycccc.png"), 165, 110)

            GUI:Text_setFontName(GUI:Text_Create(node, "tip",50 + 160,40 + 220, 20, "#f7f7de", "下级转生属性:")
            , "fonts/font4.ttf")
            local attr_desc = GUI:RichText_Create(node, "attr_desc", 50 + 160,40 + 220 - 5,  Player:showAttr(config.attr), 200, 17, "#f7f7de", 3,nil,nil)
            GUI:setAnchorPoint(attr_desc, 0, 1)

            


            local cost = ItemNumByTable_img_new(npc._config.details[level + 1].cost, nil,GUI:Node_Create(node, "cost", 0, 0))
            GUI:setPosition(cost, 200 + 390, 200  - 172)


            local Button= GUI:Button_Create(node, "Button", 750 - 469, 20.00, "res/custom/zhuansheng/btn.png")
            -- GUI:Button_setTitleText(Button, "转生")
            -- GUI:Button_setTitleFontSize(Button, 14)

            GUI:addOnClickEvent(Button, function()
                SL:SendLuaNetMsg(100, npcid, 1, 0, "")
            end)
        else
            GUI:Image_Create(node, "Button", 750 - 469, 20.00, "res/wy/public/15.png")


        end

    end


    if p2 == 0 then--界面
        npc.data = SL:JsonDecode(msgData,false)
        ensureWindow(npcid)
        UI_updata(npc.node)
    elseif p2 == 1 then
        npc.data.level = npc.data.level + 1
        UI_updata(npc.node)
    end
end

return npc
