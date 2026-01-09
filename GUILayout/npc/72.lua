local npc = {}

npc._config = teshudata["npc_72"]



local WINDOW_OPTS = {
    background = {skin = "res/custom/five_city/sgshz/bg.png", eff = true},
    title = {x = 56, y = 464, skin = "res/custom/five_city/sgshz/title.png"},
}

function Progress(num1, num2)
    local str = ""
    if num1 >= num2 then
        num1 = num2
        str = string.format("<font color='#FF0000' size='20' >(%d/%d)</font>",num1,num2)

    else
        str = string.format("<font color='#00FF00' size='20' >(%d/%d)</font>",num1,num2)

    end
    return str
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
                    GUI:RichText_Create(box_node, "num", 460, 10,
                        Progress((npc.data.dj_data[""..i] or 0), npc._config.config[i].max_level).."%"
                    , 500, 20, "#f7f7de", 3,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})
                ,0.5, 0)
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
            
            
            GUI:removeChildByName(GUI:ui_delegate(GUI:ui_delegate(npc.node).list)["box_node"..i], "num")
            GUI:setAnchorPoint(
                GUI:RichText_Create(GUI:ui_delegate(GUI:ui_delegate(npc.node).list)["box_node"..i], "num", 460, 10,
                    Progress((npc.data.dj_data[""..i] or 0), npc._config.config[i].max_level).."%"
                , 500, 20, "#f7f7de", 3,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})
            ,0.5, 0)

        end
    end
end

return npc