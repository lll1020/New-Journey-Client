local npc = {}

npc._config = teshudata["npc_32"]



local WINDOW_OPTS = {
    background = {skin = "res/custom/zhuansheng/bg.png", eff = true},
    title = {x = 56, y = 464, skin = "res/custom/zhuansheng/title.png"},
}

function npc.main(npcid, p2, p3, msgData)

    local function buildAccumulatedAttr(level)
        local details = npc._config and npc._config.details or {}
        local attrMap = {}
        local attrOrder = {}

        for i = 1, math.max(tonumber(level) or 0, 0) do
            local cfg = details[i]
            local attrs = cfg and cfg.attr
            if type(attrs) == "table" then
                for _, one in ipairs(attrs) do
                    local attrId = tonumber(one[1]) or 0
                    local attrValue = tonumber(one[2]) or 0
                    if attrId > 0 and attrValue ~= 0 then
                        if not attrMap[attrId] then
                            attrMap[attrId] = {attrId, 0, one[3]}
                            table.insert(attrOrder, attrId)
                        end
                        attrMap[attrId][2] = (tonumber(attrMap[attrId][2]) or 0) + attrValue
                        if one[3] and not attrMap[attrId][3] then
                            attrMap[attrId][3] = one[3]
                        end
                    end
                end
            end
        end

        local result = {}
        for _, attrId in ipairs(attrOrder) do
            table.insert(result, attrMap[attrId])
        end
        return result
    end

    local function buildCurrentAttrTips(level)
        local attrs = buildAccumulatedAttr(level)
        if #attrs <= 0 then
            return "<font color='#F4D179'>当前已获得属性</font><br><font color='#FFFFFF'>暂未完成转生</font>"
        end
        return string.format(
            "<font color='#F4D179'>当前已获得属性</font><br>%s",
            Player:showAttr(attrs)
        )
    end

    local function openCurrentAttrTips(tip)
        if not tip then
            return
        end
        local pos = GUI:getWorldPosition(tip)
        SL:OpenCommonDescTipsPop({
            str = buildCurrentAttrTips(npc.data and npc.data.level or 0),
            worldPos = {x = pos.x, y = pos.y},
            anchorPoint = {x = 0, y = 0},
            formatWay = 1
        })
    end

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
            local canPay = config and config.cost and checkItemNum(config.cost)
            local canGuideRebirth = (tonumber(npc.data.exp or 0) or 0) >= (tonumber(config and config.need_xxz or 0) or 0) and canPay

            if config and config.req_desc and config.req_desc ~= "" then
                local desc = GUI:Text_Create(node, "desc",386, 160, 20, "#ffffff", config.req_desc)
                GUI:Text_setFontName(desc, "fonts/font4.ttf")
                GUI:Text_enableOutline(desc, "#F03022", 2)
                GUI:setAnchorPoint(desc, 0.5, 0.5)
            end

            
            
            GUI:setContentSize(GUI:Image_Create(node, "rw_tb_bj", 50 + 160 - 5,40 + 145, "res/wy/public/tycccc.png"), 165, 110)

            GUI:Text_setFontName(GUI:Text_Create(node, "tip",50 + 160,40 + 220, 20, "#f7f7de", "下级转生属性:")
            , "fonts/font4.ttf")
            local attr_desc = GUI:RichText_Create(node, "attr_desc", 50 + 160,40 + 220 - 5,  Player:showAttr(config.attr), 200, 17, "#f7f7de", 3,nil,nil)
            GUI:setAnchorPoint(attr_desc, 0, 1)

            --可以展示当前以获取属性
            local tip = GUI:Image_Create(node, "tip2", 380 + 60 + 218, 350 + 30 - 260, "res/custom/msfc/page1/wenhao.png")
            if SL:GetMetaValue("WINPLAYMODE") then
                GUI:addMouseMoveEvent(tip, {onEnterFunc = function()
                    openCurrentAttrTips(tip)
                end, onLeaveFunc = function()
                    SL:CloseCommonDescTipsPop()
                end})
            else
                GUI:setTouchEnabled(tip, true)
                GUI:addOnTouchEvent(tip, function(self)
                    openCurrentAttrTips(tip)
                end)
            end


            


            local cost = ItemNumByTable_img_new(npc._config.details[level + 1].cost, nil,GUI:Node_Create(node, "cost", 0, 0))
            GUI:setPosition(cost, 200 + 390, 200  - 172)


            local Button= GUI:Button_Create(node, "Button", 750 - 469, 20.00, "res/custom/zhuansheng/btn.png")
            -- GUI:Button_setTitleText(Button, "转生")
            -- GUI:Button_setTitleFontSize(Button, 14)

            GUI:addOnClickEvent(Button, function()
                SL:SendLuaNetMsg(100, npcid, 1, 0, "")
            end)
            if canGuideRebirth then
                NPC_UI_HELPER.tryStartMainlineUpgradeGuide(npc, Button, node, npcid, 1, {
                    keyPrefix = "mainline_rebirth",
                    dir = 5,
                    isForce = false,
                    hideMask = true,
                    desc = "点击进行转生",
                })
            else
                NPC_UI_HELPER.closeGuideByDomain("mainline")
            end
            NPC_UI_HELPER.tryStartXylGuide(npc, Button, node, "rebirth_two", {
                taskName = "转生·二",
                dir = 5,
                desc = "点击进行转生",
            })
        else
            GUI:Image_Create(node, "Button", 750 - 469, 20.00, "res/wy/public/15.png")
            NPC_UI_HELPER.closeGuideByDomain("mainline")


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

