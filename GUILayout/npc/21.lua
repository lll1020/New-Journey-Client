local npc = {}

npc._config = teshudata["npc_21"]



local WINDOW_OPTS = {
    background = {skin = "res/custom/jingjie/bg.png", eff = false},
    title = {x = 56 + 231, y = 464 - 120, skin = "res/custom/jingjie/title.png"},
    closeButton = {x = 700, y = 340, skin = "res/wy/public/close_red_big.png"},
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

        GUI:Frames_Create(node, "eff", 0, 0, "res/custom/jingjie/eff/eff_", ".png", 1, 75,
            { speed = 75, count = 75, loop = -1})
        --{"level":0,"exp":0}
        local level = npc.data.level
        local exp = npc.data.exp

        GUI:Image_Create(node, "kuang", 395, 20.00, "res/custom/jingjie/kuang.png")

        
        local wz_2 = GUI:Image_Create(node, "wz_2", 400, 300.00, "res/custom/jingjie/wz_2.png")
        local wz_3 = GUI:Image_Create(node, "wz_3", 30, 300.00, "res/custom/jingjie/wz_3.png")


        local desc = GUI:Text_Create(wz_2, "desc",130,0, 25, "#FF0000", (npc._config.details[npc.data.level] and npc._config.details[npc.data.level].title or "无"))
        GUI:Text_setFontName(desc, "fonts/502.ttf")
        GUI:Text_enableOutline(desc, "#000000", 2)

        local desc = GUI:Text_Create(wz_3, "desc",130,0, 25, "#FFFFFF", npc.data.exp)
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
            GUI:Text_setFontName(GUI:Text_Create(kuang, "attr_name",25,-2, 20, "##00FFFF", k.attr_name.." +")
            , "fonts/502.ttf")
            local old_config = npc._config.details[level] or nil
            local new_config = npc._config.details[level + 1] or nil
            GUI:Text_setFontName(GUI:Text_Create(kuang, "new_attr_v",125,-2, 20, "##00FFFF", (old_config and old_config.attr[k.idx]) and old_config.attr[k.idx][2] or 0)
            , "fonts/502.ttf")
            GUI:Image_Create(kuang, "jt", 170, -2, "res/custom/tianshu/qh/jt.png")
            GUI:Text_setFontName(GUI:Text_Create(kuang, "old_attr_v",215,-2, 20, "##109C18", new_config and ((new_config.attr[k.idx]) and new_config.attr[k.idx][2] or 0) or "已满级")
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

            local desc = GUI:Text_Create(node, "need_xxz",130 + 290,267, 25, "#FFFFFF", "下一级需要的修为："..config.need_xxz)
            GUI:Text_setFontName(desc, "fonts/502.ttf")
            GUI:Text_enableOutline(desc, "#000000", 2)

            

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
            if canGuideUpgrade then
                NPC_UI_HELPER.tryStartMainlineUpgradeGuide(npc, Button, GUI:getParent(GUI:getParent(Button)), npcid, 1, {
                    taskMap = {[21] = 20},
                    keyPrefix = "mainline_realm",
                    dir = 5,
                    isForce = false,
                    hideMask = true,
                })
            else
                NPC_UI_HELPER.closeGuideByDomain("mainline")
            end

            
        else
            GUI:Image_Create(node, "Button", 460, 10.00, "res/wy/public/15.png")
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
