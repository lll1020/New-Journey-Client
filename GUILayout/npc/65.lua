local npc = {}

npc._config = teshudata["npc_65"]



local WINDOW_OPTS = {
    background = {skin = "res/custom/four_city/gwjd/bg.png", eff = true},
    title = {x = 56, y = 464, skin = "res/custom/four_city/gwjd/title.png"},
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

    local function xjm_UI_updata(label, titles_sign) --界面渲染
        GUI:removeAllChildren(label)

        local name = GUI:Text_Create(label, "name",20 + 449,95 + 285, 30, "#F7E700", npc._config.config[npc.titles_sign].name)
        GUI:Text_setFontName(name, "fonts/501.ttf")
        GUI:setAnchorPoint(name ,0, 0.5)

        local name = GUI:Text_Create(label, "item",20 + 449,95 + 285 - 38, 30, "#FF0000", (npc.data.item and npc.data.item or (npc._config.config[npc.titles_sign].name.."（未鉴定）")))
        GUI:Text_setFontName(name, "fonts/501.ttf")
        GUI:setAnchorPoint(name ,0, 0.5)

        GUI:Frames_Create(label, "jcsx_eff", 440, 290, "res/private/item_tips/eff/jcsx/eff_", ".png", 1, 15,
        { speed = 75, count = 15, loop = -1})

        GUI:Frames_Create(label, "tsxg_eff", 440 + 150, 290, "res/private/item_tips/eff/tsxg/eff_", ".png", 1, 15,
        { speed = 75, count = 15, loop = -1})


        GUI:setAnchorPoint(GUI:RichText_Create(label, "attr_desc_next", 440, 290,  
            "<font color='#10FF00'>生命 + 7000</font>\n"..
            "<font color='#FF0000'>攻击 + 1-120</font>\n"..
            "<font color='#F0B42A'>防御 + 50</font>\n"..
            "<font color='#FF00FF'>(随机*1-3)</font>\n"
            , 200, 16, "#f7f7de", 0,nil,nil)
        , 0, 1)

        GUI:setAnchorPoint(GUI:RichText_Create(label, "ex_attr_desc", 440 + 150, 290, Player:showAttr(npc._config.config[npc.titles_sign].ex_attr).."<font color='#FF00FF'>(随机*0.5-3)</font>\n", 200, 16, "#f7f7de", 0,nil,nil)
        , 0, 1)

        local cost = checkItemNumByTable_img_kuang(npc._config.config[npc.titles_sign].cost, nil,label)
        GUI:setPosition(cost, 400, 110)

        local Button= GUI:Button_Create(label, "Button", 550, 10, "res/custom/four_city/gwjd/btn.png")
        GUI:setAnchorPoint(Button,0.5, 0)
        GUI:addOnClickEvent(Button, function()
            SL:SendLuaNetMsg(100, npcid, 1, 0, SL:JsonEncode({idx = npc.titles_sign}, false))
        end)
        if checkItemNum(npc._config.config[npc.titles_sign].cost) then
            NPC_UI_HELPER.redpoint_create(Button)
        end
        
    end

    local function UI_updata(node) --界面渲染
        if not node then
            return
        end

        GUI:removeAllChildren(node)

        npc.titles_sign = npc.titles_sign or 1
        npc.Label = GUI:Node_Create(node, "Label", 0, 0)

        local layout = GUI:Layout_Create(node, "dbLayout", 50, 10, 270, 340)
        for i = 1, 6 do
            local kuang = GUI:Image_Create(layout, "kuang"..i, 0, 0, "res/custom/fairyFate/kuang.png")
            GUI:setContentSize(kuang, 120, 110)
            local name = GUI:Text_Create(kuang, "name",60,95, 25, "#44DDFF", npc._config.config[i].name)
            GUI:Text_setFontName(name, "fonts/501.ttf")
            GUI:setAnchorPoint(name ,0.5, 0.5)

            local k_kuang = GUI:Image_Create(kuang, "kuang"..i, 60, 55, "res/custom/four_city/gwjd/kuang.png")
            GUI:setAnchorPoint(k_kuang,0.5, 0.5)
            local item = GUI:ItemShow_Create(k_kuang, "item", 56/2, 54/2, { index = SL:GetMetaValue("ITEM_INDEX_BY_NAME",npc._config.config[i].cost[1][1]), look = true, bgVisible = false })
            GUI:setAnchorPoint(item,0.5, 0.5)

            local Button= GUI:Button_Create(kuang, "Button", 60, 2, "res/custom/three_city/xianfu/ldl/btn_xz1.png")
            GUI:setAnchorPoint(Button,0.5, 0)
            GUI:addOnClickEvent(Button, function()
                npc.titles_sign = i
                npc.data.item = nil

                xjm_UI_updata(npc.Label, npc.titles_sign)
            end)
            if checkItemNum(npc._config.config[i].cost) then
                NPC_UI_HELPER.redpoint_create(kuang,{x=105,y=85})
            end
        end
        GUI:UserUILayout(layout, {dir=3,addDir=1,colnum = 2,gap = {x=10, y=0}})

        
        xjm_UI_updata(npc.Label, npc.titles_sign)

        local tip = GUI:Image_Create(node, "tip", 650, 0, "res/custom/four_city/gwjd/tip.png")
        if SL:GetMetaValue("WINPLAYMODE") then
            GUI:addMouseMoveEvent(tip, {onEnterFunc = function()
                local pos = GUI:getWorldPosition(tip)
                SL:OpenCommonDescTipsPop({str = "<古玩鉴定：/FCOLOR=243>\\<消耗未鉴定的古玩： /FCOLOR=249>\\<可以获得各个年代的古玩，年代越久远的古玩，属性越是强大 /FCOLOR=249>", worldPos = {x = pos.x, y = pos.y}, anchorPoint = {x = 0, y = 0}, formatWay = 0})
            end, onLeaveFunc = function()
                SL:CloseCommonDescTipsPop()
            end})
        else
            GUI:setTouchEnabled(tip, true)
            GUI:addOnTouchEvent(tip, function(self)
                local pos = GUI:getWorldPosition(tip)
                SL:OpenCommonDescTipsPop({str = "<古玩鉴定：/FCOLOR=243>\\<消耗未鉴定的古玩： /FCOLOR=249>\\<可以获得各个年代的古玩，年代越久远的古玩，属性越是强大 /FCOLOR=249>", worldPos = {x = pos.x, y = pos.y}, anchorPoint = {x = 0, y = 0}, formatWay = 0})
            end)
        end
    

    end


    if p2 == 0 then--界面
        npc.data = SL:JsonDecode(msgData,false)
        ensureWindow(npcid)
        UI_updata(npc.node)
    elseif p2 == 1 then
        npc.data = SL:JsonDecode(msgData,false)
        UI_updata(npc.node)
    end
end

return npc
