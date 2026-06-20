local npc = {}
npc._config = teshudata["npc_21"]
local WINDOW_OPTS = {
    background = {skin = "res/custom/jingjie/bg.png", eff = false},
    title = {x = 56 + 231, y = 464 - 120, skin = "res/custom/jingjie/title.png"},
    closeButton = {x = 700, y = 340, skin = "res/wy/public/close_red_big.png"},
}
function npc.main(npcid, p2, p3, msgData)
    local function format_attr_value(attrIdx, value)
        local num = tonumber(value) or 0
        if attrIdx == 5 or attrIdx == 7 or attrIdx == 8 or attrIdx == 9 or attrIdx == 10 then
            local percent = num / 100
            if math.floor(percent) == percent then
                return string.format("%d%%", percent)
            end
            return (string.format("%.2f", percent):gsub("%.?0+$", "")) .. "%"
        end
        if attrIdx == 11 then
            return string.format("%d%%", num)
        end
        return tostring(num)
    end
    -- 当前境界在 0 级时显示为“凡人”，避免界面出现“无”。
    local function get_current_realm_title(level)
        local curLevel = tonumber(level or 0) or 0
        if curLevel <= 0 then
            return "凡人"
        end
        local config = npc._config and npc._config.details and npc._config.details[curLevel] or nil
        return (config and config.title) or "凡人"
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
        GUI:Frames_Create(node, "eff", 0, 0, "res/custom/jingjie/eff/eff_", ".png", 1, 75,
            { speed = 75, count = 75, loop = -1})
        --{"level":0,"exp":0}
        local level = npc.data.level
        local exp = npc.data.exp
        GUI:Image_Create(node, "kuang", 395, 20.00, "res/custom/jingjie/kuang.png")
        local wz_2 = GUI:Image_Create(node, "wz_2", 400, 300.00, "res/custom/jingjie/wz_2.png")
        local wz_3 = GUI:Image_Create(node, "wz_3", 30, 300.00, "res/custom/jingjie/wz_3.png")
        -- 当前境界名称改为同源显示，0 级明确展示为“凡人”。
        local desc = GUI:Text_Create(wz_2, "desc",130,0, 25, "#FF0000", get_current_realm_title(level))
        GUI:Text_setFontName(desc, "fonts/502.ttf")
        GUI:Text_enableOutline(desc, "#000000", 2)
        -- 当前修为统一显示为数值文本，和底图“当前修为”保持一致。
        local desc = GUI:Text_Create(wz_3, "desc",130,0, 25, "#00FF00", tostring(exp or 0))
        GUI:Text_setFontName(desc, "fonts/502.ttf")
        GUI:Text_enableOutline(desc, "#000000", 2)
        local attr = {
                {attr_name = "生命魔法", idx = 1},
                {attr_name = "人物攻击", idx = 3},
                {attr_name = "攻击速度", idx = 5},
                {attr_name = "打怪爆率", idx = 7},
                {attr_name = "P K 减伤", idx = 8},
                {attr_name = "鞭尸几率", idx = 9},
                {attr_name = "对怪吸血", idx = 10},
                {attr_name = "全 属 性", idx = 11},
        }
        local ScrollView = GUI:ScrollView_Create(node, "ScrollView", 240 + 176, 110 + 41, 284, 119, 1)
        GUI:ScrollView_setBounceEnabled(ScrollView, true)
        GUI:ScrollView_setInnerContainerSize(ScrollView, 284, (26 * #attr))
        GUI:ScrollView_setBackGroundImage(ScrollView, "res/wy/public/500-200.png")
        local dbLayout = GUI:Layout_Create(ScrollView, "dbLayout", 0,0, 284, (26 * #attr))
        for v,k in pairs(attr) do
            local kuang = GUI:Image_Create(dbLayout, "kuang"..v, 0, 0, "res/custom/tianshu/qh/tip.png")
            GUI:Text_setFontName(GUI:Text_Create(kuang, "attr_name",25,-2, 20, "#00FFFF", k.attr_name.." +")
            , "fonts/502.ttf")
            local old_config = npc._config.details[level] or nil
            local new_config = npc._config.details[level + 1] or nil
            GUI:Text_setFontName(GUI:Text_Create(kuang, "new_attr_v",125,-2, 20, "#00FFFF", format_attr_value(k.idx, (old_config and old_config.attr[k.idx]) and old_config.attr[k.idx][2] or 0))
            , "fonts/502.ttf")
            GUI:Image_Create(kuang, "jt", 170, -2, "res/custom/tianshu/qh/jt.png")
            GUI:Text_setFontName(GUI:Text_Create(kuang, "old_attr_v",215,-2, 20, "#109C18", new_config and format_attr_value(k.idx, (new_config.attr[k.idx]) and new_config.attr[k.idx][2] or 0) or "已满级")
            , "fonts/502.ttf")
            -- GUI:Image_Create(kuang, "up", 290, 3, "res/custom/tianshu/qh/up.png")
        end
        GUI:UserUILayout(dbLayout, {dir=3,addDir=1,colnum = 1,gap = {x=40, y=0}})
        GUI:setAnchorPoint(dbLayout, 0, 0)
        if level < npc._config.max_level then
            local wz_1 = GUI:Image_Create(node, "wz_1", 410, 100.00, "res/custom/jingjie/wz_1.png")
            local wz_4 = GUI:Image_Create(node, "wz_4", 410 + 155, 100.00, "res/custom/jingjie/wz_4.png")
            local config = npc._config.details[npc.data.level + 1]
            local canPay = config and config.cost and checkItemNum(config.cost)
            local canGuideUpgrade = (tonumber(npc.data.exp or 0) or 0) >= (tonumber(config and config.need_xxz or 0) or 0) and canPay
            local cost = checkItemNumByTable_img_kuang(config.cost, nil,GUI:Node_Create(wz_1, "cost", 0, 0))
            GUI:setPosition(cost, 75, -10)
            local desc = GUI:Text_Create(wz_4, "desc",100,2, 25, "#FFFFFF", config.gl.."%")
            GUI:Text_setFontName(desc, "fonts/502.ttf")
            GUI:Text_enableOutline(desc, "#000000", 2)
            local needXxz = tonumber(config.need_xxz or 0) or 0
            local curXxz = tonumber(npc.data.exp or 0) or 0
            local curColor = curXxz >= needXxz and "#00FF00" or "#FF0000"
            local needX = 130 + 290
            local needLabel = GUI:Text_Create(node, "need_xxz_label", needX, 267, 25, "#FFFFFF", "所需修为：")
            GUI:Text_setFontName(needLabel, "fonts/502.ttf")
            GUI:Text_enableOutline(needLabel, "#000000", 2)
            local labelSize = GUI:getContentSize(needLabel)
            local curText = GUI:Text_Create(node, "need_xxz_cur", needX + (labelSize and labelSize.width or 0), 267, 25, curColor, tostring(curXxz))
            GUI:Text_setFontName(curText, "fonts/502.ttf")
            GUI:Text_enableOutline(curText, "#000000", 2)
            local curSize = GUI:getContentSize(curText)
            local needText = GUI:Text_Create(node, "need_xxz_need", needX + (labelSize and labelSize.width or 0) + (curSize and curSize.width or 0), 267, 25, "#FFFFFF", "/" .. tostring(needXxz))
            GUI:Text_setFontName(needText, "fonts/502.ttf")
            GUI:Text_enableOutline(needText, "#000000", 2)
            if level == 9 then
                local jzColor = tonumber(npc.data.jz_dan_color or 249) == 250 and "#00FF00" or "#FF0000"
                local jzText = tostring(npc.data.jz_dan_text or "未服用")
                local jzBg = GUI:Layout_Create(node, "jz_dan_tip_bg", 75 - 53, 198, 387, 54, false)
                GUI:Layout_setBackGroundColorType(jzBg, 1)
                GUI:Layout_setBackGroundColor(jzBg, "#000000")
                GUI:Layout_setBackGroundColorOpacity(jzBg, 165)
                local jzDesc = GUI:Text_Create(jzBg, "jz_dan_tip", 5, 14, 20, jzColor, "筑基条件：需要服用筑基丹 " .. jzText)
                GUI:Text_setFontName(jzDesc, "fonts/502.ttf")
                GUI:Text_enableOutline(jzDesc, "#000000", 2)
                local jzEff = GUI:Effect_Create(jzBg, "jz_dan_eff", 330 + 25, 27 + 2, 0, 13048)
                GUI:setScale(jzEff, 0.8)
                GUI:setAnchorPoint(GUI:ItemShow_Create(jzBg, "jz_dan_item", 330 + 25, 27 + 2, {index= SL:GetMetaValue("ITEM_INDEX_BY_NAME","筑基丹"),count = 1,look= true, bgVisible = false}), 0.5, 0.5)
            end
            -- GUI:setAnchorPoint(
            --         GUI:RichText_Create(node, "desc", 200, 430,
            --                 "<font color='#00FF00' size='20' >当前修仙值："..npc.data.exp.."</font>\n"..
            --                 "<font color='#00FF00' size='20' >当前修仙等级："..(npc._config.details[npc.data.level] and npc._config.details[npc.data.level].title or "无").."</font>\n"..
            --                 "<font color='#00FF00' size='20' >下一级需要的修仙值："..config.need_xxz.."</font>\n"..
            --                 "<font color='#00FF00' size='20' >下一级修仙等级："..(config.title or 0).."</font>\n"
            --         , 500, 20, "#f7f7de", 3,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})
            -- , 0, 1)
            local Button= GUI:Button_Create(node, "Button", 460, 10.00, "res/custom/jingjie/btn_2.png")
            -- GUI:Button_setTitleText(Button, "升级")
            -- GUI:Button_setTitleFontSize(Button, 14)
            GUI:addOnClickEvent(Button, function()
                SL:SendLuaNetMsg(100, npcid, 1, 0, "")
            end)
            if NPC_UI_HELPER.isCurrentXylTask({"筑基", "提升修为至筑基境"}) then
                NPC_UI_HELPER.closeGuideByDomain("xyl")
            end
        else
            GUI:Image_Create(node, "Button", 460, 10.00, "res/wy/public/15.png")
            NPC_UI_HELPER.closeGuideByDomain("mainline")
        end
    end
    if p2 == 2 then
        SL:OpenCommonTipsPop({
            str = "未检测到筑基丹，是否前往在线充值购买？",
            btnType = 2,
            callback = function(atype)
                if atype == 1 then
                    SL:SendLuaNetMsg(100, npcid, 2, 0, "")
                end
            end,
        })
        return
    end
    if p2 == 0 then--界面
        npc.data = SL:JsonDecode(msgData,false)
        ensureWindow(npcid)
        UI_updata(npc.node)
    elseif p2 == 1 then
        npc.data = SL:JsonDecode(msgData,false)
        UI_updata(npc.node)
        if NPC_UI_HELPER.isCurrentXylTask({"筑基", "提升修为至筑基境"})
            and (tonumber(npc.data and npc.data.level or 0) or 0) >= 10 then
            NPC_UI_HELPER.closeWindow(npc._window)
        end
    end
end
return npc
