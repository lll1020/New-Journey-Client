local npc = {}

npc._config = teshudata["npc_64"]



local WINDOW_OPTS = {
    background = {skin = "res/custom/four_city/lingshou/bg.png", eff = false},
    closeButton = {x = 350 + 470, y = 180 + 288, skin = "res/wy/public/close_red_big.png"},
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

    local function GUI_createLabel(localNode,idx) --小界面渲染
        GUI:removeAllChildren(localNode)
        if idx == 1 then
            GUI:Image_Create(localNode, "wz1", 490, 380, "res/custom/four_city/lingshou/xjm/tip_1.png")
            GUI:Image_Create(localNode, "wz2", 490, 380 - 70, "res/custom/four_city/lingshou/xjm/tip_5.png")
            -- GUI:Image_Create(localNode, "wz3", 490, 380 - 140, "res/custom/four_city/lingshou/xjm/tip_4.png")

            
            GUI:Text_setFontName(GUI:Text_Create(localNode, "b_skill",500,360, 18, "#FFFFFF", npc._config.config.ls[npc.titles_sign].b_skill)
            , "fonts/500.ttf")
            local s_skill = GUI:Text_Create(localNode, "s_skill",500,360 - 45, 18, "#FFFFFF", npc._config.config.ls[npc.titles_sign].s_skill)
            GUI:Text_setFontName(s_skill, "fonts/500.ttf")
            GUI:setAnchorPoint(s_skill,0, 1)


            if npc.ls_data.T_data.ls[""..npc.titles_sign] >= npc._config.config.wy.max_level then
                GUI:Text_setFontName(GUI:Text_Create(localNode, "tip_max",490, 170, 30, "#FF0000", "已达最高等级亲密度")
                    , "fonts/500.ttf")
                return
            end
            GUI:Image_Create(localNode, "cost_img", 490, 170, "res/custom/four_city/lingshou/xjm/cost.png")

            local cost = checkItemNumByTable_img_kuang(npc._config.config.wy.cost[npc.ls_data.T_data.ls[""..npc.titles_sign] or 1], nil,localNode)
            GUI:setPosition(cost, 490 + 100, 160)

            local Button = GUI:Button_Create(localNode, "Button", 570, 90, "res/custom/four_city/lingshou/xjm/btn.png")
            GUI:addOnClickEvent(Button, function()
                SL:SendLuaNetMsg(100, npcid, 3, 0, SL:JsonEncode({idx = npc.titles_sign}, false))
            end)


        elseif idx == 2 then
            GUI:Image_Create(localNode, "wz1", 490, 380, "res/custom/four_city/lingshou/xjm/tip_2.png")
            GUI:Image_Create(localNode, "wz2", 490, 380 - 100, "res/custom/four_city/lingshou/xjm/tip_3.png")

            GUI:Text_setFontName(GUI:Text_Create(localNode, "attr_give_wz",500,360, 18, "#FFFFFF", npc._config.config.ls[npc.titles_sign].attr_give_wz)
            , "fonts/500.ttf")
            GUI:Text_setFontName(GUI:Text_Create(localNode, "attr_wz",500,360 - 100, 18, "#FFFFFF", npc._config.config.ls[npc.titles_sign].attr_wz)
            , "fonts/500.ttf")

            local attr = deepCopy(npc._config.config.wy.det[npc.ls_data.T_data.ls[""..npc.titles_sign] or 1].attr)
            for v,k in pairs(attr) do
                local kuang = GUI:Image_Create(localNode, "kuang"..v, 500, 360 - (v-1)*20 - 30, "res/custom/tianshu/qh/tip.png")
                -- k[2] = k[2] * npc.data.T_data.level[""..npc.current_idx]
                GUI:RichText_Create(kuang, "attr_desc", 20, 0, Player:showAttr({{k[1],k[2]}}), 200, 17, "#f7f7de", 3,nil,nil)
                GUI:Image_Create(kuang, "jt", 150, 0, "res/custom/tianshu/qh/jt.png")
                GUI:Text_Create(kuang, "old_attr_v",200,3, 17, "#00FFFF", (npc.ls_data.T_data.ls[""..npc.titles_sign] < npc._config.config.wy.max_level) and (npc._config.config.wy.det[(npc.ls_data.T_data.ls[""..npc.titles_sign] or 1) + 1].attr[v][2]) .. "(下一级亲密度)" or "已满级")
            end

        end
    end
    local function xjm_UI_updata() --小界面渲染
        npc.xjm_window = NPC_UI_HELPER.ensureWindow(nil, npcid, {
            windowName = "npc_anniu_44_xjm",
            background = {skin = "res/custom/four_city/lingshou/xjm/bg.png"},
            closeButton = {x = 330 + 220 + 347, y = 180 + 180 + 51, skin = "res/wy/public/close_red_big.png"},
        })
        npc.xjm_node = npc.xjm_window.node

        local eff = GUI:Frames_Create(npc.xjm_node, "eff", 288, 314, "res/custom/four_city/lingshou/xjm/eff/"..npc.titles_sign.."/eff_", ".png", 1, 30,
            { speed = 75, count = 30, loop = -1})
        GUI:setAnchorPoint(eff,0.5, 0.5)
        local wz = GUI:Image_Create(npc.xjm_node, "wz1", 290, 430, "res/custom/four_city/lingshou/xjm/wz_"..npc.titles_sign..".png")
        GUI:setAnchorPoint(wz,0.5, 0.5)
        GUI:Text_Create(wz, "qmd", 170, 31, 20, "#FF00FF", ((npc.ls_data.T_data.ls[""..npc.titles_sign] or 0) * 10) .."%")
        GUI:Text_Create(wz, "zhsj", 170, 7, 18, "#00FFFF", npc._config.config.wy.det[npc.ls_data.T_data.ls[""..npc.titles_sign] or 1].time.."秒")

        GUI:Image_Create(npc.xjm_node, "wz2", 430, 415, "res/custom/four_city/lingshou/xjm/wz/wz_"..npc.titles_sign..".png")

        GUI:Image_Create(npc.xjm_node, "syw", 170, 150, "res/custom/four_city/lingshou/xjm/syw.png")

        local kuang = GUI:Image_Create(npc.xjm_node, "kuang2", 170 + 120, 150 - 10, "res/wy/public/58_58_kuang.png")
        local item = GUI:ItemShow_Create(kuang, "item", 58/2, 58/2, { index = SL:GetMetaValue("ITEM_INDEX_BY_NAME",npc._config.config.ls[npc.titles_sign].syw), look = true, bgVisible = false })
        GUI:setAnchorPoint(item,0.5, 0.5)
        npc.ls_data.T_data.syw = npc.ls_data.T_data.syw or {}
        GUI:Text_Create(kuang, "qmd", 40, 0, 18, "#FF00FF", (npc.ls_data.T_data.syw[""..npc.titles_sign] and npc.ls_data.T_data.syw[""..npc.titles_sign] == 1) and "已激活" or "未激活")

        local Button= GUI:Button_Create(npc.xjm_node, "Button", 800, 0.00, "res/custom/four_city/lingshou/xjm/btn_cz.png")
        -- GUI:Button_setTitleText(Button, "出战")
        -- GUI:Button_setTitleFontSize(Button, 14)

        GUI:addOnClickEvent(Button, function()
            SL:SendLuaNetMsg(100, npcid, 2, 0, SL:JsonEncode({idx = npc.titles_sign}, false))
        end)
        
        npc.Label = GUI:Node_Create(npc.xjm_node, "Label", 0, 0)
 
        npc.xjm_titles_sign = 1
        for i = 1, 2 do
            local cbl_item = GUI:Button_Create(npc.xjm_node, "item" .. i, 570 + (i-1)*150, 455, "res/custom/four_city/lingshou/xjm/list/"..(npc.xjm_titles_sign == i and "l" or "n").."/"..i..".png")
            GUI:addOnClickEvent(cbl_item, function()
                GUI:Button_loadTextureNormal(GUI:ui_delegate(npc.xjm_node)["item" .. npc.xjm_titles_sign], "res/custom/four_city/lingshou/xjm/list/n/"..npc.xjm_titles_sign..".png")
                npc.xjm_titles_sign = i
                GUI_createLabel(npc.Label,i)

                GUI:Button_loadTextureNormal(GUI:ui_delegate(npc.xjm_node)["item" .. npc.xjm_titles_sign], "res/custom/four_city/lingshou/xjm/list/l/"..npc.xjm_titles_sign..".png")
            end)
        end
        GUI_createLabel(npc.Label,npc.xjm_titles_sign)

    end
    local function UI_updata(node) --界面渲染
        if not node then
            return
        end

        GUI:removeAllChildren(node)
        npc.titles_sign = npc.titles_sign or 1

        npc.ls_data.T_data.ls = npc.ls_data.T_data.ls or {}
        npc.ls_data.T_data.ls_sp = npc.ls_data.T_data.ls_sp or {}
        npc.ls_data.T_data.syw = npc.ls_data.T_data.syw or {}


        for i = 1, 5 do
            local Button = GUI:Button_Create(node, "line"..i, 160 + (i-1)*130, 100 + (i%2) * 30, "res/custom/four_city/lingshou/l_"..i..".png")
            if npc.ls_data.T_data.dqzh and npc.ls_data.T_data.dqzh == i then
                local eff = GUI:Frames_Create(Button, "eff", 108, 355, "res/custom/four_city/lingshou/new/eff_", ".png", 1, 15,
                    { speed = 75, count = 15, loop = -1})
                GUI:setAnchorPoint(eff,0.5, 0.5)
            end
            for ii = 1, 3 do
                GUI:Image_Create(Button, "star"..ii, 90, 80 + (ii-1)*40, "res/custom/four_city/lingshou/star_"..((npc.ls_data.T_data.ls_sp[""..i] or 0)>ii and "l" or "n")..".png")
            end

            

            if npc.ls_data.T_data.ls[""..i] and npc.ls_data.T_data.ls[""..i] >= 1 then
            else
                GUI:Button_setBrightEx(Button, false)
            end
            GUI:addOnClickEvent(Button, function()
                npc.titles_sign = i
                xjm_UI_updata()
            end)
        end

        
        GUI:setAnchorPoint(GUI:Image_Create(node, "wz1", 998/2, 80, "res/custom/four_city/lingshou/wz1.png")
        ,0.5, 0.5)

        local btn_tip = GUI:Button_Create(node, "btn_tip", 998/2 - 250, 80, "res/custom/four_city/lingshou/btn_tip.png")
        local btn_make = GUI:Button_Create(node, "btn_make", 998/2, 80, "res/custom/four_city/lingshou/btn_make.png")
        local btn_buy = GUI:Button_Create(node, "btn_buy", 998/2 + 250, 80, "res/custom/four_city/lingshou/btn_buy.png")
        GUI:setAnchorPoint(btn_tip,0.5, 0.5)
        GUI:setAnchorPoint(btn_make,0.5, 0.5)
        GUI:setAnchorPoint(btn_buy,0.5, 0.5)


        GUI:addOnClickEvent(btn_make, function()
            SL:SendLuaNetMsg(100, npcid, 1, 0, "")
        end)

        GUI:addOnClickEvent(btn_tip, function()
            npc.xjm_window = NPC_UI_HELPER.ensureWindow(nil, npcid, {
                windowName = "npc_anniu_44_xjm",
                background = {skin = "res/custom/four_city/lingshou/tip/bg.png"},
                closeButton = {x = 330 + 220 + 347 - 295, y = 180 + 180 + 51 - 100, skin = "res/wy/public/close_red_big.png"},
            })
        end)
    end


    if p2 == 0 then--界面
        npc.ls_data = SL:JsonDecode(msgData,false)
        ensureWindow(npcid)
        UI_updata(npc.node)
    elseif p2 == 1 then
        npc.ls_data = SL:JsonDecode(msgData,false)
        UI_updata(npc.node)
    elseif p2 == 3 then
        npc.ls_data = SL:JsonDecode(msgData,false)
        xjm_UI_updata()
    end
end

return npc