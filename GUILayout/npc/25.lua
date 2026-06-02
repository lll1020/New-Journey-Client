local npc = {}

npc._config = teshudata["npc_25"]



local WINDOW_OPTS = {
    background = {skin = "res/custom/two_city/xyqh/bg.png", eff = true},
    title = {x = 56, y = 464, skin = "res/custom/two_city/xyqh/title.png"},
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
        GUI:Effect_Create(npc.bg, "eff", 240, 130, 0, 60457)
        npc.node = npc._window.node
        return npc.node
    end

    local function UI_updata(node) --界面渲染
        if not node then
            return
        end

        GUI:removeAllChildren(node)
        --{"level":0,"exp":0}



        local config = npc._config.details[npc.data.level + 1]

        GUI:setAnchorPoint(GUI:Image_Create(node, "num", 610, 175, "res/custom/two_city/xyqh/num/"..npc.data.level..".png")
        , 0.5, 0.5)


        if config then
            local cost = ItemNumByTable_img(config.cost, nil,GUI:Node_Create(node, "cost", 0, 0))
            GUI:setPosition(cost, 530, 85)

            -- GUI:setAnchorPoint(
            --         GUI:RichText_Create(node, "desc", 200, 430,
            --                 "<font color='#00FF00' size='20' >当前幸运等级："..npc.data.level.."</font>\n"..
            --                 "<font color='#00FF00' size='20' >强化成功率："..config.fake_gl.."</font>\n"
            --         , 500, 20, "#f7f7de", 3,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})
            -- , 0, 1)

            

            GUI:Text_setFontName(GUI:Text_Create(node, "wz",668,96, 25, "#00FF00", config.fake_gl.."%" )
            , "fonts/501.ttf")
            local Button= GUI:Button_Create(node, "Button", 500, 0.00, "res/custom/two_city/xyqh/btn.png")

            GUI:addOnClickEvent(Button, function()
                SL:SendLuaNetMsg(100, npcid, 1, 0, "")
            end)
            if checkItemNum(config.cost) then
                NPC_UI_HELPER.redpoint_create(Button)
            end
            NPC_UI_HELPER.tryStartXylGuide(npc, Button, node, "lucky_upgrade", {
                taskNames = {"引导幸运增幅", "幸运增幅", "幸运强化", "幸运增幅强化一次"},
                desc = "点击进行幸运强化",
                dir = 3,
                hideMask = true,
            })
        else
            local cost = ItemNumByTable_img({ {"灵石",999999} }, nil,GUI:Node_Create(node, "cost", 0, 0))
            GUI:setPosition(cost, 530, 85)
            GUI:Text_setFontName(GUI:Text_Create(node, "wz",668,96, 25, "#00FF00", "0%" )
            , "fonts/501.ttf")
            GUI:Image_Create(node, "Button", 500, 20.00, "res/wy/public/15.png")


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
