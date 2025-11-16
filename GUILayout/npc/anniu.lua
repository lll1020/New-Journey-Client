local npc = {}

---顶部图标显示
npc.iconpx = {
    {
        {7, "天天省钱",509,1}, {3, "福利大厅",511,2}, {1, "游戏攻略",512,3},{5, "活动大厅",507,4},{8, "首充礼包",501,5},{4, "仙途奇缘",515,15}
    },
    {
        {12, "在线充值", 502,11}, {2, "交易行",510,12},{4, "解绑特权",504,13},{4, "狂暴之力",513,14},{4, "世界地图",514,15},{4, "免费赞助",516,16},{4, "聚宝盆",517,17}
    }
}
npc.LeftTop = GUI:Attach_LeftTop() -- 左上
npc.RightTop = GUI:Attach_RightTop() -- 右上
npc.RightBottom = GUI:Attach_RightBottom() -- 右下
npc.qiehuan = GUI:Win_FindParent(109)--手机端切换
npc.xinjn = GUI:Win_FindParent(1104)--主界面最顶右下
npc.xinjn32 = GUI:Win_FindParent(1003)--主界面最顶右下

npc.db_anniu = {} --按钮
---特殊任务描述
npc.rw = {

}  --任务描述


local zbz = {}
if cogin.isWin32 then
    zbz = {-700, -150, 200, -180, -60}
else
    zbz = {-700, -150, 200, -160, -60}
end


npc[0] = function(p2, p3, msgData) -- 任务处理
    if p2 == 1 then
        local zysj = SL:JsonDecode(msgData,false)
        if zysj.lx == 1 then
            if GUI:getFlippedX(npc.dbshousuo) then
                GUI:setFlippedX(npc.dbshousuo, false)
                GUI:setPosition(npc.dbLayout, zbz[1], zbz[2])
                if npc.db_anniu[""..zysj.an] then
                    SL:StartGuide({dir = zysj.fx ,guideWidget = npc.db_anniu[""..zysj.an] ,guideParent=npc.dbLayout,guideDesc=zysj.ms,isForce = false})
                end
            else
                if npc.db_anniu[""..zysj.an] then
                    SL:StartGuide({dir = zysj.fx ,guideWidget = npc.db_anniu[""..zysj.an] ,guideParent=npc.dbLayout,guideDesc=zysj.ms,isForce = false})
                end
            end
        elseif zysj.lx == 2 then  --npc 寻路
            local rwxx = SL:GetMetaValue("ACTOR_MAP_X", SL:GetMetaValue("MAIN_ACTOR_ID"))
            SL:SetMetaValue("BATTLE_MOVE_BEGIN", zysj.npcdt,zysj.xx == rwxx and zysj.xx + 1 or zysj.xx ,zysj.yy, {type = 1 ,index = zysj.npcid}, 1)
        elseif zysj.lx == 3 then
            SL:RefreshBagPos()
            if cogin.isWin32 then
                SL:StartGuide({dir = 1 ,guideWidget = MainProperty._ui.Button_bag ,guideParent= MainProperty._ui.Panel_act,guideDesc="打开背包",isForce = false})
                GUI:Timeline_FadeIn(MainProperty._ui.Button_bag, 0.2)
            else
                SL:StartGuide({dir = 1 ,guideWidget = npc.sjbeibao ,guideParent= npc.RightTop,guideDesc="打开背包",isForce = false})
            end
            if zysj.rwid then
                cogin.sjtb.zxrwid = zysj.rwid
            end
        elseif zysj.lx == 4 then  --npc 寻路
            local rwxx = SL:GetMetaValue("ACTOR_MAP_X", SL:GetMetaValue("MAIN_ACTOR_ID"))
            SL:SetMetaValue("BATTLE_MOVE_BEGIN", zysj.yd[1],zysj.yd[2] == rwxx and zysj.yd[2] + 1 or zysj.yd[2] ,zysj.yd[3], {type = 0}, 1)
        elseif zysj.lx == 14 then
            if cogin.isWin32 then
                SL:StartGuide({dir = 2 ,guideWidget = MainProperty._ui.Button_role ,guideParent= MainProperty._ui.Panel_act,guideDesc="打开人物界面",isForce = false})
                GUI:Timeline_FadeIn(MainProperty._ui.Button_role, 0.2)
            else
                SL:StartGuide({dir = 1 ,guideWidget = npc.jueshe ,guideParent= npc.RightTop,guideDesc="打开人物界面",isForce = false})
            end
        end
    elseif p2 == 9 then
        local da = SL:JsonDecode(msgData,false)
        local parent = GUI:GetWindow(nil, "npc_jiangli")
        if parent then
            GUI:removeAllChildren(parent)
        else
            parent = GUI:Win_Create("npc_jiangli",cogin.w/2, cogin.h/2,0,0,false,false,false,true,true,0,1)
        end
        local bjt = GUI:Image_Create(parent, "bjt",-20,0, "res/public/1900000651_1.png")
        GUI:setAnchorPoint(bjt, 0.5,0.5)
        GUI:setContentSize(bjt, cogin.w + 100, cogin.h + 100)
        GUI:setTouchEnabled(bjt, true)
        GUI:addOnClickEvent(bjt, function() 
            GUI:Win_Close(parent)  
        end)
        local lingjiang = GUI:Image_Create(parent, "lingjiang", 0.00, 0.00, "res/wy/public/0-"..(p3 == 1000 and 2 or 1)..".png")
        GUI:setAnchorPoint(lingjiang, 0.5, 0.5)

        local Layout1 = GUI:Layout_Create(lingjiang, "Layout1", 831.00/2, 170, #da.item * 71, 60.00, false)
        GUI:setAnchorPoint(Layout1, 0.5, 0)
        for k, v in ipairs(da.item) do
            local k = GUI:Image_Create(Layout1, "item"..k, 0.00, 0.00, "res/wy/public/555.png")
            GUI:ItemShow_Create(k, "kuang", 20, 20, {index=SL:GetMetaValue("ITEM_INDEX_BY_NAME", v[1]),look=true,count=v[2]})
        end
        GUI:UserUILayout(Layout1, {dir=2,addDir=2,interval=1,gap = {x=20}})
        local Button = GUI:Button_Create(lingjiang, "Button", 831.00/2, 80, "res/wy/public/0-1_an.png")
        GUI:setAnchorPoint(Button, 0.5, 0)
        GUI:addOnClickEvent(Button, function() 
            GUI:Win_Close(parent)  
        end)
        GUI:setScaleX(lingjiang, 0)
        GUI:Timeline_ScaleTo(lingjiang, 1, 0.2)
    end
end

npc[1] = function(p2, p3, msgData) -- 初始化按钮
    --预渲染
    if p2 == 0 then
        local function ding_an(sy)
            GUI:removeAllChildren(npc.dbLayout)
            npc.dbrqs = GUI:Layout_Create(npc.dbLayout, "Layout_s", 0.00, 70.00, 490.00, 80.00, false)
            npc.dbrqx = GUI:Layout_Create(npc.dbLayout, "Layout_x", 0.00, -10.00, 490.00, 80.00, false)
            local zbjs = 1
            for i, v in ipairs(npc.iconpx[1]) do
                if false then
                else
                    npc.db_anniu[""..v[4]] = GUI:Button_Create(npc.dbrqs, "anniu_1" .. i, 498 - 80 * zbjs, 0, "res/wy/icon/" .. v[1] .. ".png")
                    GUI:Text_Create(npc.db_anniu[""..v[4]], "tt", 0, 14, 14, "#ffffff", v[2])
                    GUI:addOnClickEvent(npc.db_anniu[""..v[4]], function()
                        SL:SendLuaNetMsg(101, v[3], 0, 0, "")
                    end)
                    zbjs = zbjs + 1
                end
            end
            zbjs = 1
            for i, v in ipairs(npc.iconpx[2]) do
                if false then
                else
                    npc.db_anniu[""..v[4]] = GUI:Button_Create(npc.dbrqx, "anniu_2" .. i, 498 - 80 * zbjs, 0, "res/wy/icon/" .. v[1] .. ".png")
                    GUI:Text_Create(npc.db_anniu[""..v[4]], "tt", 0, 14, 14, "#ffffff", v[2])
                    GUI:addOnClickEvent(npc.db_anniu[""..v[4]], function()
                        SL:SendLuaNetMsg(101, v[3], 0, 0, "")
                    end)
                    zbjs = zbjs +1
                end
            end
        end
        if p3 == 0 then
            local guaji = {}
            if cogin.isWin32 then
                guaji[1] = GUI:Button_Create(npc.RightBottom, "guaji", -80, 500, "res/wy/icon/base.png")
                local dalucs = GUI:Button_Create(npc.RightBottom, "dalucs", -80, 200, "res/wy/icon/sjdt.png")
                GUI:addOnClickEvent(dalucs, function()
                    Npclib["anniu"][4](0)
                end)

                ---暂时隐藏一下
                --GUI:setVisible(guaji[1],false)
                GUI:setVisible(dalucs,false)

                ---测试使用
                local Button_1 = GUI:Button_Create(npc.RightBottom, "Button_1", -86, 340 + 100, "res/private/player_main_layer_ui/player_main_layer_ui_win32/1900015011.png")
                GUI:Button_setTitleText(Button_1, "测试")
                GUI:addOnClickEvent(Button_1, function()
                    SL:SendLuaNetMsg(105, 665, 665, 0, "")
                end)
                npc.an_cbl = GUI:Button_Create(npc.RightBottom, "an_cbl", -86, 340, "res/private/main/bottom/1900012580.png")
                GUI:Button_loadTexturePressed(npc.an_cbl, "res/private/main/bottom/1900012580.png")
                GUI:setAnchorPoint(GUI:Image_Create(npc.an_cbl, "ts", 86/2, 86/2, "res/private/main/bottom/1900012538.png")
                , 0.5, 0.5)
                GUI:addOnClickEvent(npc.an_cbl, function()
                    local parent = GUI:GetWindow(nil, "main_cbl")
                    if parent then
                        GUI:removeAllChildren(parent)
                    else
                        parent = GUI:Win_Create("main_cbl", 0, 0, 0, 0, false, false, true, true, true, idx, 1)
                    end
                    local bjt = GUI:Image_Create(parent, "bjt", cogin.w / 2, cogin.h / 2, "res/public/1900000651_1.png")
                    GUI:setAnchorPoint(bjt, 0.5, 0.5)
                    GUI:setContentSize(bjt, cogin.w + 100, cogin.h + 100)
                    GUI:setTouchEnabled(bjt, true)
                    ---侧边栏ui
                    local cbl = GUI:Image_Create(parent,"bj",cogin.w,0,"res/wy/public/main_cbl_bj.png")
                    GUI:setAnchorPoint(cbl, 1, 0)
                    GUI:setTouchEnabled(cbl, true)
                    GUI:addOnClickEvent(bjt, function()
                        GUI:Timeline_EaseSineIn_MoveTo(cbl, {x = cogin.w + 300, y = 0}, 0.5,function()
                            GUI:Win_Close(parent)
                        end)
                    end)
                    GUI:addMouseOverTips(bjt, "", {x = 0, y = 0}, {x = 0, y = 0})


                    local width = GUI:getContentSize(cbl).width
                    GUI:setContentSize(cbl, width, cogin.h)
                    GUI:setPosition(cbl, cogin.w + width,0)

                    local close = GUI:Button_Create(cbl, 'close', width - 10, cogin.h - 10, 'res/wy/public/main_cbl_close.png')
                    GUI:setAnchorPoint(close, 1, 1)
                    GUI:addOnClickEvent(close, function()
                        GUI:Timeline_EaseSineIn_MoveTo(cbl, {x = cogin.w + 300, y = 0}, 0.5,function()
                            GUI:Win_Close(parent)
                        end)
                    end)

                    local hh = GUI:Button_Create(GUI:Image_Create(cbl,"hh",10, 150,"res/wy/public/main_cbl_kuang.png"), "img", 39, 34.5, "res/private/main/bottom/sj_hh.png")
                    local sz = GUI:Button_Create(GUI:Image_Create(cbl,"sz",110, 50,"res/wy/public/main_cbl_kuang.png"), "img",39,34.5, "res/private/main/bottom/sj_sz.png")
                    local exit = GUI:Button_Create(GUI:Image_Create(cbl,"exit",210, 50,"res/wy/public/main_cbl_kuang.png"), "img", 39,34.5, "res/private/main/bottom/sj_exit.png")
                    local sj_xz = GUI:Button_Create(GUI:Image_Create(cbl,"paimai",210, 150,"res/wy/public/main_cbl_kuang.png"), "img", 39,34.5, "res/private/main/bottom/sj_xz.png")
                    local haoyou = GUI:Button_Create(GUI:Image_Create(cbl,"haoyou",110, 150,"res/wy/public/main_cbl_kuang.png"), "img", 39,34.5, "res/private/main/bottom/sj_haoyou.png")
                    local paihang = GUI:Button_Create(GUI:Image_Create(cbl,"paihang",10, 50,"res/wy/public/main_cbl_kuang.png"), "img", 39,34.5, "res/private/main/bottom/sj_paihang.png")
                    GUI:setAnchorPoint(hh, 0.5, 0.5)
                    GUI:setAnchorPoint(sz, 0.5, 0.5)
                    GUI:setAnchorPoint(exit, 0.5, 0.5)
                    GUI:setAnchorPoint(sj_xz, 0.5, 0.5)
                    GUI:setAnchorPoint(haoyou, 0.5, 0.5)
                    GUI:setAnchorPoint(paihang, 0.5, 0.5)
                    GUI:addOnClickEvent(hh, function()
                        SL:JumpTo(31)
                    end)
                    GUI:addOnClickEvent(sj_xz, function()
                        SL:SendLuaNetMsg(105, 8, 8, 0, "")
                    end)
                    GUI:addOnClickEvent(haoyou, function()
                        SL:JumpTo(28)
                    end)
                    GUI:addOnClickEvent(sz, function()
                        SL:JumpTo(23)
                    end)
                    GUI:addOnClickEvent(paihang, function()
                        SL:JumpTo(32)
                    end)
                    GUI:addOnClickEvent(exit, function()
                        SL:JumpTo(29)
                    end)
                    local zz = GUI:Button_Create(cbl, "lbg", width/2, cogin.h - 80, "res/wy/public/main_cbl_zz.png")
                    local syt = GUI:Button_Create(cbl, "sqt", width/2, cogin.h - 80 - 105, "res/wy/public/main_cbl_syt.png")
                    local ldl = GUI:Button_Create(cbl, "tj", width/2, cogin.h - 80 - 210, "res/wy/public/main_cbl_ldl.png")
                    GUI:setAnchorPoint(zz, 0.5, 1)
                    GUI:setAnchorPoint(syt, 0.5, 1)
                    GUI:setAnchorPoint(ldl, 0.5, 1)
                    GUI:addOnClickEvent(zz, function() SL:SendLuaNetMsg(105, 166, 166, 0, "") end)
                    GUI:addOnClickEvent(syt, function() SL:SendLuaNetMsg(105, 19, 19, 0, "") end)
                    GUI:addOnClickEvent(ldl, function()  SL:SendLuaNetMsg(105, 103, 103, 0, "") end)
                    GUI:Timeline_EaseSineIn_MoveTo(cbl, {x = cogin.w, y = 0}, 0.5)
                end)
                --客服
                if SL:GetMetaValue("IS_SHOW_MAUNAL_SERVICE") then
                    local kefu = GUI:Button_Create(npc.RightBottom, "kefu", -260 - 100, 90, "res/wy/icon/kefu_pc.png")
                    GUI:addOnClickEvent(kefu, function()
                        SL:RequestOpen996ManualService()
                    end)
                    ManualService = {}
                    function ManualService.OnUnReadMessage(data)
                        if data and data.unReadNums > 0 then
                            return
                        end
                    end

                    function ManualService.RegisterEvent()
                        SL:RegisterLUAEvent("LUA_EVENT_MANUAL_SERVICE_MESSAGE_UN_READ", "ManualService", ManualService.OnUnReadMessage)
                    end

                    function ManualService.UnRegisterEvent()
                        SL:UnRegisterLUAEvent("LUA_EVENT_MANUAL_SERVICE_MESSAGE_UN_READ", "ManualService")
                    end
                end

                local moji = GUI:Effect_Create(npc.RightBottom, "moji", -260, 40, 0, 7060, 0, 0, 0, 1)
                local Layout = GUI:Layout_Create(moji, "Layout", 0, 0, 48, 48, false)
                GUI:setTouchEnabled(Layout, true)
                GUI:addOnClickEvent(Layout, function()
                    SL:OpenChatExtendUI(2)
                end)

                --移动各位刺杀开关
                local gwcs = GUI:Button_Create(npc.RightBottom, "gwcs", -200, 250, "res/wy/icon/gwcs.png")
                GUI:Button_setGrey(gwcs,  SL:GetMetaValue("SETTING_VALUE", 56)[1] ~= 1)
                GUI:addOnClickEvent(gwcs, function()
                    if SL:GetMetaValue("SETTING_VALUE", 56)[1] == 1 then
                        SL:SetMetaValue("SETTING_VALUE", 56, {0})
                        GUI:Button_setGrey(gwcs, true)
                    else
                        SL:SetMetaValue("SETTING_VALUE", 56, {1})
                        GUI:Button_setGrey(gwcs, false)
                    end
                end)
            else
                npc.sjbeibao = GUI:Button_Create(npc.RightTop, "beibao", -240, -230, "res/private/main/bottom/bag.png")
                npc.jueshe = GUI:Button_Create(npc.RightTop, "jueshe", -320, -230, "res/private/main/bottom/js.png")
                GUI:addOnClickEvent(npc.sjbeibao, function()
                    SL:OpenBagUI()
                end)
                GUI:addOnClickEvent(npc.jueshe, function()
                    SL:OpenMyPlayerUI()
                end)

                local dalucs = GUI:Button_Create(npc.RightTop, "dalucs", -160, -230, "res/wy/icon/sjdt.png")
                GUI:addOnClickEvent(dalucs, function() 
                    Npclib["anniu"][4](0)
                end)
                guaji[1] = GUI:Button_Create(npc.RightTop, "guaji", -80, -230, "res/wy/icon/base.png")

                --移动各位刺杀开关
                local gwcs = GUI:Button_Create(npc.RightTop, "gwcs", -250 - 100, -360 - 93, "res/wy/icon/gwcs.png")
                GUI:Button_setGrey(gwcs,  SL:GetMetaValue("SETTING_VALUE", 56)[1] ~= 1)
                GUI:addOnClickEvent(gwcs, function()
                    if SL:GetMetaValue("SETTING_VALUE", 56)[1] == 1 then
                        SL:SetMetaValue("SETTING_VALUE", 56, {0})
                        --GUI:Text_setString(gwcs_wz, "未开启")
                        GUI:Button_setGrey(gwcs, true)
                    else
                        SL:SetMetaValue("SETTING_VALUE", 56, {1})
                        --GUI:Text_setString(gwcs_wz, "已开启")
                        GUI:Button_setGrey(gwcs, false)
                    end
                end)
            end
            GUI:addOnClickEvent(guaji[1], function()
                if SL:GetMetaValue("BATTLE_IS_AFK") then
                    SL:SetMetaValue("BATTLE_AFK_END")
                else
                    SL:SetMetaValue("BATTLE_AFK_BEGIN")
                end
            end)
            SL:RegisterLUAEvent(LUA_EVENT_AFKBEGIN, "开始自动挂机", function()
                guaji[3] = GUI:Effect_Create(guaji[1], "moji", 32, 32, 0, 4005, 0, 0, 0, 1)
                GUI:setScale(guaji[3], 0.6)
                SL:RegisterLUAEvent(LUA_EVENT_PLAYER_ACTION_BEGIN, "主玩家行为动作开始-挂机用", function(data)
                    if SL:GetMetaValue("BATTLE_IS_AFK") then
                        if data.act == 25 then
                            if cogin.guajikawei[1] == 6 or cogin.guajikawei[1] == 1 then
                                if cogin.guajikawei[2] > 5 then
                                    cogin.guajikawei[2] = 0
                                    --TODO -- 怪物卡位
                                    --SL:UseItemByIndex(10001)
                                else
                                    cogin.guajikawei[1] = 0
                                    cogin.guajikawei[2] = cogin.guajikawei[2] + 1
                                end
                            else
                                if cogin.guajikawei[2] > 0 then
                                    cogin.guajikawei[2] = 0
                                end
                            end
                        else
                            cogin.guajikawei[1] = data.act
                        end
                    end
                end)
            end)
            SL:RegisterLUAEvent(LUA_EVENT_AFKEND, "结束自动挂机", function()
                SL:UnRegisterLUAEvent(LUA_EVENT_PLAYER_ACTION_BEGIN, "主玩家行为动作开始-挂机用")
                if guaji[3] then
                    GUI:removeFromParent(guaji[3])
                end
            end)

            npc.dbLayout = GUI:Layout_Create(npc.RightTop, "Layout1", zbz[1], zbz[2], 490, 160, false)
            npc.dbshousuo = GUI:Button_Create(npc.RightTop, "shousuo", zbz[4], zbz[5], "res/wy/icon/s.png")
            GUI:setAnchorPoint(npc.dbshousuo, 0.5, 0)
            GUI:addOnClickEvent(npc.dbshousuo, function(self)
                if GUI:getFlippedX(self) then
                    GUI:setFlippedX(self, false)
                    GUI:Timeline_EaseSineIn_MoveTo(npc.dbLayout, {x = zbz[1], y = zbz[2]}, 0.3)
                else
                    GUI:setFlippedX(self, true)
                    GUI:Timeline_EaseSineIn_MoveTo(npc.dbLayout, {x = zbz[3], y = zbz[2]}, 0.3)
                end
            end)
            ding_an("")
        elseif p3 == 1 then
            ding_an(msgData)
        end
    elseif p2 == 10 then -- 红点
        if npc.db_anniu[""..p3] and not GUI:ui_delegate(npc.db_anniu[""..p3]).ists then
            local ists = GUI:Image_Create(npc.db_anniu[""..p3], "ists", 65, 65, "res/public/ists.png")
            GUI:setAnchorPoint(ists, 0.5, 0.5)
        end
    end
end
---回收面板
npc[2] = function(p2, p3, msgData) -- 回收面板
    if p2 == 2 then
        local shuju = SL:JsonDecode(msgData,false)
        local parent = GUI:GetWindow(nil, "npc_huishou")
        if parent then
            GUI:removeAllChildren(parent)
        else
            parent = GUI:Win_Create("npc_huishou",cogin.w/2, cogin.h/2,0,0,false,false,false,true,true,0,1)
        end
        local bjt = GUI:Image_Create(parent, "bjt", 0, 0, "res/public/1900000651_1.png")
        GUI:setAnchorPoint(bjt, 0.5, 0.5)
        GUI:setContentSize(bjt, cogin.w + 100, cogin.h + 100)
        GUI:setTouchEnabled(bjt, true)
        GUI:addOnClickEvent(bjt, function()
            GUI:Win_Close(parent)
        end)
        GUI:addMouseOverTips(bjt, "", {x = 0, y = 0}, {x = 0, y = 0})


        npc.bg = GUI:Image_Create(parent, "img_bj", 0.00, 0.00, "res/wy/public/hs_bj.png")
        GUI:setAnchorPoint(npc.bg, 0.5, 0.5)
        GUI:setTouchEnabled(npc.bg, true)
        GUI:Timeline_Window3(npc.bg)
        local close = GUI:Button_Create(npc.bg, 'close', 840, 482, "res/wy/public/npc_39_close.png")
        GUI:addOnClickEvent(close, function()
            GUI:Win_Close(parent)
        end)

         function xiaohui_update()
            GUI:removeAllChildren(npc.bbzs)
            local bbitme = {}
            local item = SL:GetMetaValue("BAG_DATA")
            npc.hs = {}
            local h = 0
            local i = 1
            local ii = 1
            local inRecycle = {}  -- 用于记录物品是否在回收列表中
            local huishou_jc_list = cogin.huishou_jc_list

            for k, v in pairs(item) do
                if i > 12*h then
                    h = h + 1
                    bbitme["h"..h] = GUI:Layout_Create(npc.bbzs, "h"..h, 0, 0, 500, 41 ,false)
                end
                if huishou_jc_list[v.Index] then
                    -- 闭包函数捕获当前的索引 i
                    local currentI = k
                    bbitme["kuang"..i] = GUI:Image_Create(bbitme["h"..h], "kuang"..i, ((((i-1)%12))*41)+4, 0, "res/wy/public/40-40.png")
                    bbitme["l"..currentI] = GUI:ItemShow_Create(bbitme["kuang"..i], "item"..i, 20, 20, {itemData = v, count = v.Count, look = true, bgVisible = false})
                    if cogin.isWin32 then
                    else
                        GUI:setScale(bbitme["l"..currentI], 0.7)
                    end
                    GUI:setAnchorPoint(bbitme["l"..currentI], 0.5, 0.5)
                    GUI:setTouchEnabled(bbitme["kuang"..i], true)
                    GUI:addOnClickEvent(bbitme["kuang"..i], function()
                        if inRecycle[currentI] then
                            -- 在回收列表里,移除
                            GUI:ItemShow_setItemShowChooseState(bbitme["l"..currentI], false)
                            -- 从回收表中移除当前索引
                            for idx = #npc.hs, 1, -1 do
                                if npc.hs[idx] == currentI then
                                    table.remove(npc.hs, idx)
                                    break
                                end
                            end
                            inRecycle[currentI] = false  -- 更新标记为不在回收列表中
                        else
                            -- 不在回收列表里,添加
                            GUI:ItemShow_setItemShowChooseState(bbitme["l"..currentI], true)
                            table.insert(npc.hs, currentI)
                            ii = ii + 1
                            inRecycle[currentI] = true  -- 更新标记为在回收列表中
                        end
                    end)
                    GUI:ItemShow_addReplaceClickEvent(bbitme["l"..currentI], function(self)
                        if inRecycle[currentI] then
                            -- 在回收列表里,移除
                            GUI:ItemShow_setItemShowChooseState(bbitme["l"..currentI], false)
                            -- 从回收表中移除当前索引
                            for idx = #npc.hs, 1, -1 do
                                if npc.hs[idx] == currentI then
                                    table.remove(npc.hs, idx)
                                    break
                                end
                            end
                            inRecycle[currentI] = false  -- 更新标记为不在回收列表中
                        else
                            -- 不在回收列表里,添加
                            GUI:ItemShow_setItemShowChooseState(bbitme["l"..currentI], true)
                            table.insert(npc.hs, currentI)
                            ii = ii + 1
                            inRecycle[currentI] = true  -- 更新标记为在回收列表中
                        end
                    end)
                    -- 初始化时根据条件判断是否在回收列表中
                    if (huishou_jc_list[v.Index].gl and huishou_jc_list[v.Index].gl == 1 and
                            (shuju.xz["1_"..huishou_jc_list[v.Index][1]] or shuju.xz["1_"..huishou_jc_list[v.Index][1].."_"..huishou_jc_list[v.Index][2]])) or
                            (huishou_jc_list[v.Index].gl and huishou_jc_list[v.Index].gl == 2 and shuju.xz["2_"..huishou_jc_list[v.Index][1]]) or
                            (huishou_jc_list[v.Index].gl and huishou_jc_list[v.Index].gl == 3 and shuju.xz["3_"..huishou_jc_list[v.Index][1]]) or
                            (huishou_jc_list[v.Index].gl and huishou_jc_list[v.Index].gl == 4 and
                                    (shuju.xz["4_"..huishou_jc_list[v.Index][1]] or shuju.xz["4_"..huishou_jc_list[v.Index][1].."_"..huishou_jc_list[v.Index][2]])) or
                            (shuju.xz[""..v.Index]) then

                        inRecycle[k] = true  -- 将索引 i 标记为在回收列表中
                        table.insert(npc.hs, k)
                        GUI:ItemShow_setItemShowChooseState(bbitme["l"..currentI], true)  -- 设置选中状态
                    else
                        inRecycle[k] = false  -- 将索引 i 标记为不在回收列表中
                    end
                    i = i + 1
                end
            end
        end


        local jm_node = GUI:Node_Create(npc.bg, 'node',0,0)

        local l_list = GUI:ListView_Create(npc.bg, "ListView", 25.00, 30.00, 190.00, 450.00, 1)
        GUI:ListView_setItemsMargin(l_list, 25)
        GUI:ListView_setGravity(l_list, 2)


        local function new_hs_update()
            GUI:removeAllChildren(jm_node)
            local xjm_parent = GUI:GetWindow(nil, "hs_xjm")
            if xjm_parent then
                GUI:Win_Close(xjm_parent)
            end
            GUI:Frames_Create(jm_node, "tip", 220, 480, "res/wy/eff/city/huishou_tip_", ".png", 1, 15, {count=15,speed=100,loop=-1})
            GUI:Frames_Create(jm_node, "tip2", 30, 50, "res/wy/eff/city/huishou_tip2_", ".png", 1, 15, {count=15,speed=100,loop=-1})
            if npc.s == 1 then
                local s_list = GUI:ListView_Create(jm_node, "s_list", 225.00, 128.00, 650.00, 340.00, 1)
                GUI:ListView_setItemsMargin(s_list, 10)
                for v,k in pairs(cogin.hs.zzhs)  do
                    if npc.s_s == v or true then
                        local s_s_list = GUI:ListView_Create(s_list, "s_s_list"..v, 0, 0, 650.00, 35.00, 2)
                        GUI:setTouchEnabled(s_s_list, false)
                        GUI:ListView_setItemsMargin(s_s_list, 10)
                        for vv,kk in pairs(k)  do
                            local s_s_btn = GUI:Image_Create(s_s_list, "s_s_btn"..vv, 0, 0, "res/wy/public/new_kuang.png")
                            local s_s_CheckBox = GUI:CheckBox_Create(s_s_btn, "CheckBox",GUI:getContentSize(s_s_btn).width - 40, 3, "res/wy/public/new_check_0.png", "res/wy/public/new_check_1.png")
                            GUI:CheckBox_setSelected(s_s_CheckBox, (shuju.xz[npc.s.."_"..v] and shuju.xz[npc.s.."_"..v] == 1) or (shuju.xz[npc.s.."_"..v.."_"..vv] and shuju.xz[npc.s.."_"..v.."_"..vv] == 1))
                            GUI:CheckBox_addOnEvent(s_s_CheckBox, function(self)
                                shuju.xz[npc.s.."_"..v.."_"..vv] = GUI:CheckBox_isSelected(self) and 1 or nil
                                SL:SendLuaNetMsg(101, 2, 2, 0, npc.s.."_"..v.."_"..vv)
                                if shuju.xz[npc.s.."_"..v] and shuju.xz[npc.s.."_"..v] == 1 then
                                    shuju.xz[npc.s.."_"..v] = nil
                                    SL:SendLuaNetMsg(101, 2, 2, 0, npc.s.."_"..v)
                                end
                            end)
                            local s_s_wz = GUI:Text_Create(s_s_btn, "wz", 70, 17, 17, "#44DDFF", kk.name)
                            GUI:setAnchorPoint(s_s_wz, 0.5, 0.5)
                            GUI:Text_enableOutline(s_s_wz, "#150800", 2)
                            if vv == 1 then
                                GUI:Text_enableUnderline(s_s_wz)
                                if SL:GetMetaValue("WINPLAYMODE") and false then
                                    GUI:addMouseMoveEvent(s_s_btn, {onEnterFunc = function()
                                        local xjm_parent = GUI:GetWindow(nil, "hs_xjm")
                                        if xjm_parent then
                                            GUI:removeAllChildren(xjm_parent)
                                            GUI:setPosition(xjm_parent, 0, 0)
                                        else
                                            xjm_parent = GUI:Win_Create("hs_xjm", 0, 0, 0, 0, false, false, true, true, true, npcid, 1)
                                        end
                                        local pos = GUI:getWorldPosition(s_s_btn)
                                        npc.hs_xbj = GUI:Image_Create(xjm_parent, "bj", pos.x + GUI:getContentSize(s_s_btn).width, pos.y + 35, "res/private/item_tips/bg_tipszy_05.png")
                                        GUI:setAnchorPoint(npc.hs_xbj, 0, 1)
                                        GUI:setTouchEnabled(npc.hs_xbj, true)
                                        GUI:setContentSize(npc.hs_xbj, GUI:getContentSize(s_s_btn).width + 10,5 * (35 + 10))
                                        local x_close = GUI:Button_Create(npc.hs_xbj, 'close', GUI:getContentSize(s_s_btn).width + 10, 5 * (35 + 10), 'res/public/1900000511.png')
                                        GUI:setAnchorPoint(x_close, 0, 1)
                                        GUI:addOnClickEvent(x_close, function()
                                            GUI:Win_Close(xjm_parent)
                                        end)
                                        local s_s_s_list = GUI:ListView_Create(npc.hs_xbj, "s_s_s_list", 0, 3, GUI:getContentSize(s_s_btn).width + 10, 5 * (35 + 10) - 6, 1)
                                        GUI:ListView_setGravity(s_s_s_list, 2)
                                        GUI:ListView_setItemsMargin(s_s_s_list, 10)
                                        for vvv,kkk in pairs(kk.l)  do
                                            local s_s_s_btn = GUI:Image_Create(s_s_s_list, "s_s_s_btn"..vvv, 0, 0, "res/wy/public/new_kuang.png")
                                            local s_s_s_CheckBox = GUI:CheckBox_Create(s_s_s_btn, "CheckBox",GUI:getContentSize(s_s_s_btn).width - 40, 3, "res/wy/public/new_check_0.png", "res/wy/public/new_check_1.png")
                                            GUI:CheckBox_setSelected(s_s_s_CheckBox, (shuju.xz[npc.s.."_"..v] and shuju.xz[npc.s.."_"..v] == 1) or (shuju.xz[npc.s.."_"..v.."_"..vv] and shuju.xz[npc.s.."_"..v.."_"..vv] == 1) or (shuju.xz[""..vvv] and shuju.xz[""..vvv] == 1))
                                            GUI:CheckBox_addOnEvent(s_s_s_CheckBox, function(self)
                                                shuju.xz[""..vvv] = GUI:CheckBox_isSelected(self) and 1 or nil
                                                SL:SendLuaNetMsg(101, 2, 2, 0, vvv)
                                                if shuju.xz[npc.s.."_"..v] and shuju.xz[npc.s.."_"..v] == 1 then
                                                    shuju.xz[npc.s.."_"..v] = nil
                                                    SL:SendLuaNetMsg(101, 2, 2, 0, npc.s.."_"..v)
                                                end
                                                if shuju.xz[npc.s.."_"..v.."_"..vv] and shuju.xz[npc.s.."_"..v.."_"..vv] == 1 then
                                                    shuju.xz[npc.s.."_"..v.."_"..vv] = nil
                                                    SL:SendLuaNetMsg(101, 2, 2, 0, npc.s.."_"..v.."_"..vv)
                                                end
                                            end)
                                            local s_s_s_wz = GUI:RichText_Create(s_s_s_btn, "s_s_s_wz", 77, 17,  "<a href='jump#item_tips#"..vvv.."'>"..kkk[3].."</a>", 500, 17, "#f7f7de", 3,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})
                                            GUI:setAnchorPoint(s_s_s_wz, 0.5, 0.5)
                                        end
                                    end, onLeaveFunc = function()
                                    end})
                                else
                                    GUI:setTouchEnabled(s_s_btn, true)
                                    GUI:addOnClickEvent(s_s_btn, function()
                                        local xjm_parent = GUI:GetWindow(nil, "hs_xjm")
                                        if xjm_parent then
                                            GUI:removeAllChildren(xjm_parent)
                                            GUI:setPosition(xjm_parent, 0, 0)
                                        else
                                            xjm_parent = GUI:Win_Create("hs_xjm", 0, 0, 0, 0, false, false, true, true, true, npcid, 1)
                                        end
                                        local pos = GUI:getWorldPosition(s_s_btn)
                                        npc.hs_xbj = GUI:Image_Create(xjm_parent, "bj", pos.x + GUI:getContentSize(s_s_btn).width, pos.y + 35, "res/private/item_tips/bg_tipszy_05.png")
                                        GUI:setAnchorPoint(npc.hs_xbj, 0, 1)
                                        GUI:setTouchEnabled(npc.hs_xbj, true)
                                        GUI:setContentSize(npc.hs_xbj, GUI:getContentSize(s_s_btn).width + 10,5 * (35 + 10))

                                        local x_close = GUI:Button_Create(npc.hs_xbj, 'close', GUI:getContentSize(s_s_btn).width + 10, 5 * (35 + 10), 'res/public/1900000511.png')
                                        GUI:setAnchorPoint(x_close, 0, 1)
                                        GUI:addOnClickEvent(x_close, function()
                                            GUI:Win_Close(xjm_parent)
                                        end)


                                        local s_s_s_list = GUI:ListView_Create(npc.hs_xbj, "s_s_s_list", 0, 3, GUI:getContentSize(s_s_btn).width + 10, 5 * (35 + 10) - 6, 1)
                                        GUI:ListView_setGravity(s_s_s_list, 2)
                                        GUI:ListView_setItemsMargin(s_s_s_list, 10)
                                        for vvv,kkk in pairs(kk.l)  do
                                            local s_s_s_btn = GUI:Image_Create(s_s_s_list, "s_s_s_btn"..vvv, 0, 0, "res/wy/public/new_kuang.png")
                                            local s_s_s_CheckBox = GUI:CheckBox_Create(s_s_s_btn, "CheckBox",GUI:getContentSize(s_s_s_btn).width - 40, 3, "res/wy/public/new_check_0.png", "res/wy/public/new_check_1.png")
                                            GUI:CheckBox_setSelected(s_s_s_CheckBox, (shuju.xz[npc.s.."_"..v] and shuju.xz[npc.s.."_"..v] == 1) or (shuju.xz[npc.s.."_"..v.."_"..vv] and shuju.xz[npc.s.."_"..v.."_"..vv] == 1) or (shuju.xz[""..vvv] and shuju.xz[""..vvv] == 1))
                                            GUI:CheckBox_addOnEvent(s_s_s_CheckBox, function(self)
                                                shuju.xz[""..vvv] = GUI:CheckBox_isSelected(self) and 1 or nil
                                                SL:SendLuaNetMsg(101, 2, 2, 0, vvv)
                                                if shuju.xz[npc.s.."_"..v] and shuju.xz[npc.s.."_"..v] == 1 then
                                                    shuju.xz[npc.s.."_"..v] = nil
                                                    SL:SendLuaNetMsg(101, 2, 2, 0, npc.s.."_"..v)
                                                end
                                                if shuju.xz[npc.s.."_"..v.."_"..vv] and shuju.xz[npc.s.."_"..v.."_"..vv] == 1 then
                                                    shuju.xz[npc.s.."_"..v.."_"..vv] = nil
                                                    SL:SendLuaNetMsg(101, 2, 2, 0, npc.s.."_"..v.."_"..vv)
                                                end
                                            end)
                                            local s_s_s_wz = GUI:RichText_Create(s_s_s_btn, "s_s_s_wz", 77, 17,  "<a href='jump#item_tips#"..vvv.."'>"..kkk[3].."</a>", 500, 17, "#f7f7de", 3,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})
                                            GUI:setAnchorPoint(s_s_s_wz, 0.5, 0.5)
                                        end
                                    end)
                                end
                            end
                        end
                    else
                        for vv,kk in pairs(k)  do
                            for vvv,kkk in pairs(kk.l)  do
                                if SL:GetMetaValue("ITEM_COUNT", vvv) > 0 then
                                end
                            end
                        end
                    end
                end
                local hs_zdhs = GUI:Image_Create(jm_node, 'hs_zdhs', 450, 60, 'res/wy/public/huishou/hs_zdhs.png')
                local CheckBox_zdhs = GUI:CheckBox_Create(hs_zdhs, "CheckBox_zdhs",GUI:getContentSize(hs_zdhs).width + 2, -2, "res/wy/public/xz0.png", "res/wy/public/xz1.png")
                GUI:setAnchorPoint(CheckBox_zdhs, 1, 0)
                GUI:CheckBox_setSelected(CheckBox_zdhs, shuju.kg[4] == 1)
                GUI:CheckBox_addOnEvent(CheckBox_zdhs, function(self)
                    SL:SendLuaNetMsg(101, 2, 4, 4, GUI:CheckBox_isSelected(self) and 1 or 0)
                end)


                local zidong2 = GUI:Image_Create(jm_node, 'zidong2', 250, 80, 'res/wy/public/hsan_122.png')
                local zidong3 = GUI:Image_Create(jm_node, 'zidong3', 250, 40, 'res/wy/public/hsan_123.png')

                local CheckBox2 = GUI:CheckBox_Create(zidong2, "kaiguan2",107, 0, "res/wy/public/xz0.png", "res/wy/public/xz1.png")
                GUI:CheckBox_setSelected(CheckBox2, shuju.kg[1] == 1)
                GUI:CheckBox_addOnEvent(CheckBox2, function(self)
                    SL:SendLuaNetMsg(101, 2, 4, 1, GUI:CheckBox_isSelected(self) and 1 or 0)
                end)
                local CheckBox3 = GUI:CheckBox_Create(zidong3, "kaiguan3",107, 0, "res/wy/public/xz0.png", "res/wy/public/xz1.png")
                GUI:CheckBox_setSelected(CheckBox3, shuju.kg[2] == 1)
                GUI:CheckBox_addOnEvent(CheckBox3, function(self)
                    SL:SendLuaNetMsg(101, 2, 4, 2, GUI:CheckBox_isSelected(self) and 1 or 0)
                end)
            elseif npc.s == 2 then
                local s_list = GUI:ListView_Create(jm_node, "s_list", 225.00, 128.00, 650.00, 340.00, 1)
                GUI:ListView_setItemsMargin(s_list, 10)
                for v,k in pairs(cogin.hs.zsfj)  do
                    if npc.s_s == v or true then
                        local s_s_list = GUI:ListView_Create(s_list, "s_s_list"..v, 0, 0, 650.00, 35.00, 2)
                        GUI:setTouchEnabled(s_s_list, false)
                        GUI:ListView_setItemsMargin(s_s_list, 10)
                        for vv,kk in pairs(k)  do
                            local s_s_btn = GUI:Image_Create(s_s_list, "s_s_btn"..vv, 0, 0, "res/wy/public/new_kuang.png")
                            local s_s_CheckBox = GUI:CheckBox_Create(s_s_btn, "CheckBox",GUI:getContentSize(s_s_btn).width - 40, 3, "res/wy/public/new_check_0.png", "res/wy/public/new_check_1.png")
                            GUI:CheckBox_setSelected(s_s_CheckBox, (shuju.xz[npc.s.."_"..v] and shuju.xz[npc.s.."_"..v] == 1) or (shuju.xz[npc.s.."_"..v.."_"..vv] and shuju.xz[npc.s.."_"..v.."_"..vv] == 1))
                            GUI:CheckBox_addOnEvent(s_s_CheckBox, function(self)
                                shuju.xz[npc.s.."_"..v.."_"..vv] = GUI:CheckBox_isSelected(self) and 1 or nil
                                SL:SendLuaNetMsg(101, 2, 2, 0, npc.s.."_"..v.."_"..vv)
                                if shuju.xz[npc.s.."_"..v] and shuju.xz[npc.s.."_"..v] == 1 then
                                    shuju.xz[npc.s.."_"..v] = nil
                                    SL:SendLuaNetMsg(101, 2, 2, 0, npc.s.."_"..v)
                                end
                            end)
                            local s_s_wz = GUI:Text_Create(s_s_btn, "wz", 70, 17, 17, "#44DDFF", kk.name)
                            GUI:setAnchorPoint(s_s_wz, 0.5, 0.5)
                            GUI:Text_enableOutline(s_s_wz, "#150800", 2)
                            if vv == 1 then
                                GUI:Text_enableUnderline(s_s_wz)
                                if SL:GetMetaValue("WINPLAYMODE") and false then
                                    GUI:addMouseMoveEvent(s_s_btn, {onEnterFunc = function()
                                        local xjm_parent = GUI:GetWindow(nil, "hs_xjm")
                                        if xjm_parent then
                                            GUI:removeAllChildren(xjm_parent)
                                            GUI:setPosition(xjm_parent, 0, 0)
                                        else
                                            xjm_parent = GUI:Win_Create("hs_xjm", 0, 0, 0, 0, false, false, true, true, true, npcid, 1)
                                        end
                                        local pos = GUI:getWorldPosition(s_s_btn)
                                        npc.hs_xbj = GUI:Image_Create(xjm_parent, "bj", pos.x + GUI:getContentSize(s_s_btn).width, pos.y + 35, "res/private/item_tips/bg_tipszy_05.png")
                                        GUI:setAnchorPoint(npc.hs_xbj, 0, 1)
                                        GUI:setTouchEnabled(npc.hs_xbj, true)
                                        GUI:setContentSize(npc.hs_xbj, GUI:getContentSize(s_s_btn).width + 10,5 * (35 + 10))
                                        local x_close = GUI:Button_Create(npc.hs_xbj, 'close', GUI:getContentSize(s_s_btn).width + 10, 5 * (35 + 10), 'res/public/1900000511.png')
                                        GUI:setAnchorPoint(x_close, 0, 1)
                                        GUI:addOnClickEvent(x_close, function()
                                            GUI:Win_Close(xjm_parent)
                                        end)
                                        local s_s_s_list = GUI:ListView_Create(npc.hs_xbj, "s_s_s_list", 0, 3, GUI:getContentSize(s_s_btn).width + 10, 5 * (35 + 10) - 6, 1)
                                        GUI:ListView_setGravity(s_s_s_list, 2)
                                        GUI:ListView_setItemsMargin(s_s_s_list, 10)
                                        for vvv,kkk in pairs(kk.l)  do
                                            local s_s_s_btn = GUI:Image_Create(s_s_s_list, "s_s_s_btn"..vvv, 0, 0, "res/wy/public/new_kuang.png")
                                            local s_s_s_CheckBox = GUI:CheckBox_Create(s_s_s_btn, "CheckBox",GUI:getContentSize(s_s_s_btn).width - 40, 3, "res/wy/public/new_check_0.png", "res/wy/public/new_check_1.png")
                                            GUI:CheckBox_setSelected(s_s_s_CheckBox, (shuju.xz[npc.s.."_"..v] and shuju.xz[npc.s.."_"..v] == 1) or (shuju.xz[npc.s.."_"..v.."_"..vv] and shuju.xz[npc.s.."_"..v.."_"..vv] == 1) or (shuju.xz[""..vvv] and shuju.xz[""..vvv] == 1))
                                            GUI:CheckBox_addOnEvent(s_s_s_CheckBox, function(self)
                                                shuju.xz[""..vvv] = GUI:CheckBox_isSelected(self) and 1 or nil
                                                SL:SendLuaNetMsg(101, 2, 2, 0, vvv)
                                                if shuju.xz[npc.s.."_"..v] and shuju.xz[npc.s.."_"..v] == 1 then
                                                    shuju.xz[npc.s.."_"..v] = nil
                                                    SL:SendLuaNetMsg(101, 2, 2, 0, npc.s.."_"..v)
                                                end
                                                if shuju.xz[npc.s.."_"..v.."_"..vv] and shuju.xz[npc.s.."_"..v.."_"..vv] == 1 then
                                                    shuju.xz[npc.s.."_"..v.."_"..vv] = nil
                                                    SL:SendLuaNetMsg(101, 2, 2, 0, npc.s.."_"..v.."_"..vv)
                                                end
                                            end)
                                            local s_s_s_wz = GUI:RichText_Create(s_s_s_btn, "s_s_s_wz", 77, 17,  "<a href='jump#item_tips#"..vvv.."'>"..kkk[3].."</a>", 500, 17, "#f7f7de", 3,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})
                                            GUI:setAnchorPoint(s_s_s_wz, 0.5, 0.5)
                                        end
                                    end, onLeaveFunc = function()
                                    end})
                                else
                                    GUI:setTouchEnabled(s_s_btn, true)
                                    GUI:addOnClickEvent(s_s_btn, function()
                                        local xjm_parent = GUI:GetWindow(nil, "hs_xjm")
                                        if xjm_parent then
                                            GUI:removeAllChildren(xjm_parent)
                                            GUI:setPosition(xjm_parent, 0, 0)
                                        else
                                            xjm_parent = GUI:Win_Create("hs_xjm", 0, 0, 0, 0, false, false, true, true, true, npcid, 1)
                                        end
                                        local pos = GUI:getWorldPosition(s_s_btn)
                                        npc.hs_xbj = GUI:Image_Create(xjm_parent, "bj", pos.x + GUI:getContentSize(s_s_btn).width, pos.y + 35, "res/private/item_tips/bg_tipszy_05.png")
                                        GUI:setAnchorPoint(npc.hs_xbj, 0, 1)
                                        GUI:setTouchEnabled(npc.hs_xbj, true)
                                        GUI:setContentSize(npc.hs_xbj, GUI:getContentSize(s_s_btn).width + 10,5 * (35 + 10))

                                        local x_close = GUI:Button_Create(npc.hs_xbj, 'close', GUI:getContentSize(s_s_btn).width + 10, 5 * (35 + 10), 'res/public/1900000511.png')
                                        GUI:setAnchorPoint(x_close, 0, 1)
                                        GUI:addOnClickEvent(x_close, function()
                                            GUI:Win_Close(xjm_parent)
                                        end)


                                        local s_s_s_list = GUI:ListView_Create(npc.hs_xbj, "s_s_s_list", 0, 3, GUI:getContentSize(s_s_btn).width + 10, 5 * (35 + 10) - 6, 1)
                                        GUI:ListView_setGravity(s_s_s_list, 2)
                                        GUI:ListView_setItemsMargin(s_s_s_list, 10)
                                        for vvv,kkk in pairs(kk.l)  do
                                            local s_s_s_btn = GUI:Image_Create(s_s_s_list, "s_s_s_btn"..vvv, 0, 0, "res/wy/public/new_kuang.png")
                                            local s_s_s_CheckBox = GUI:CheckBox_Create(s_s_s_btn, "CheckBox",GUI:getContentSize(s_s_s_btn).width - 40, 3, "res/wy/public/new_check_0.png", "res/wy/public/new_check_1.png")
                                            GUI:CheckBox_setSelected(s_s_s_CheckBox, (shuju.xz[npc.s.."_"..v] and shuju.xz[npc.s.."_"..v] == 1) or (shuju.xz[npc.s.."_"..v.."_"..vv] and shuju.xz[npc.s.."_"..v.."_"..vv] == 1) or (shuju.xz[""..vvv] and shuju.xz[""..vvv] == 1))
                                            GUI:CheckBox_addOnEvent(s_s_s_CheckBox, function(self)
                                                shuju.xz[""..vvv] = GUI:CheckBox_isSelected(self) and 1 or nil
                                                SL:SendLuaNetMsg(101, 2, 2, 0, vvv)
                                                if shuju.xz[npc.s.."_"..v] and shuju.xz[npc.s.."_"..v] == 1 then
                                                    shuju.xz[npc.s.."_"..v] = nil
                                                    SL:SendLuaNetMsg(101, 2, 2, 0, npc.s.."_"..v)
                                                end
                                                if shuju.xz[npc.s.."_"..v.."_"..vv] and shuju.xz[npc.s.."_"..v.."_"..vv] == 1 then
                                                    shuju.xz[npc.s.."_"..v.."_"..vv] = nil
                                                    SL:SendLuaNetMsg(101, 2, 2, 0, npc.s.."_"..v.."_"..vv)
                                                end
                                            end)
                                            local s_s_s_wz = GUI:RichText_Create(s_s_s_btn, "s_s_s_wz", 77, 17,  "<a href='jump#item_tips#"..vvv.."'>"..kkk[3].."</a>", 500, 17, "#f7f7de", 3,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})
                                            GUI:setAnchorPoint(s_s_s_wz, 0.5, 0.5)
                                        end
                                    end)
                                end
                            end
                        end
                    else
                        for vv,kk in pairs(k)  do
                            for vvv,kkk in pairs(kk.l)  do
                                if SL:GetMetaValue("ITEM_COUNT", vvv) > 0 then
                                end
                            end
                        end
                    end
                end
                local hs_zdhs = GUI:Image_Create(jm_node, 'hs_zdhs', 450, 60, 'res/wy/public/huishou/hs_zdhs.png')
                local CheckBox_zdhs = GUI:CheckBox_Create(hs_zdhs, "CheckBox_zdhs",GUI:getContentSize(hs_zdhs).width + 2, -2, "res/wy/public/xz0.png", "res/wy/public/xz1.png")
                GUI:setAnchorPoint(CheckBox_zdhs, 1, 0)
                GUI:CheckBox_setSelected(CheckBox_zdhs, shuju.kg[4] == 1)
                GUI:CheckBox_addOnEvent(CheckBox_zdhs, function(self)
                    SL:SendLuaNetMsg(101, 2, 4, 4, GUI:CheckBox_isSelected(self) and 1 or 0)
                end)


                local zidong2 = GUI:Image_Create(jm_node, 'zidong2', 250, 80, 'res/wy/public/hsan_122.png')
                local zidong3 = GUI:Image_Create(jm_node, 'zidong3', 250, 40, 'res/wy/public/hsan_123.png')

                local CheckBox2 = GUI:CheckBox_Create(zidong2, "kaiguan2",107, 0, "res/wy/public/xz0.png", "res/wy/public/xz1.png")
                GUI:CheckBox_setSelected(CheckBox2, shuju.kg[1] == 1)
                GUI:CheckBox_addOnEvent(CheckBox2, function(self)
                    SL:SendLuaNetMsg(101, 2, 4, 1, GUI:CheckBox_isSelected(self) and 1 or 0)
                end)
                local CheckBox3 = GUI:CheckBox_Create(zidong3, "kaiguan3",107, 0, "res/wy/public/xz0.png", "res/wy/public/xz1.png")
                GUI:CheckBox_setSelected(CheckBox3, shuju.kg[2] == 1)
                GUI:CheckBox_addOnEvent(CheckBox3, function(self)
                    SL:SendLuaNetMsg(101, 2, 4, 2, GUI:CheckBox_isSelected(self) and 1 or 0)
                end)
            elseif npc.s == 3 then
                local s_list = GUI:ListView_Create(jm_node, "s_list", 225.00, 128.00, 650.00, 340.00, 1)
                GUI:ListView_setItemsMargin(s_list, 10)
                for v,k in pairs(cogin.hs.clfj)  do
                    if v == 1 and false then
                    elseif dl_sz(v) then
                        local btn = GUI:Button_Create(s_list, "wz"..v, 0, 0, "res/wy/public/new_kuang.png")
                        GUI:addOnClickEvent(btn, function()
                            npc.s_s = v
                            new_hs_update()
                        end)
                        local CheckBox = GUI:CheckBox_Create(btn, "CheckBox",GUI:getContentSize(btn).width - 40, 3, "res/wy/public/new_check_0.png", "res/wy/public/new_check_1.png")
                        GUI:CheckBox_setSelected(CheckBox, shuju.xz[npc.s.."_"..v] and shuju.xz[npc.s.."_"..v] == 1)
                        GUI:CheckBox_addOnEvent(CheckBox, function(self)
                            if shuju.xz[npc.s.."_"..v] and shuju.xz[npc.s.."_"..v] == 1 then
                                shuju.xz[npc.s.."_"..v] = nil
                            else
                                shuju.xz[npc.s.."_"..v] = 1
                            end
                            SL:SendLuaNetMsg(101, 2, 2, 0, npc.s.."_"..v)
                            new_hs_update()
                        end)
                        local wz = GUI:Text_Create(btn, "wz", 77, 17, 17, "#FFFF00", teshudata.sjjt_x[v][4])
                        GUI:setAnchorPoint(wz, 0.5, 0.5)
                        GUI:Text_enableOutline(wz, "#150800", 2)
                        if npc.s_s == v or true then
                            local s_s_list = GUI:Layout_Create(s_list, "s_s_list"..v, 0, 0, 650, math.floor(#k.l/3) *  45.00, false)

                            for vv,kk in pairs(k.l)  do
                                local s_s_btn = GUI:Image_Create(s_s_list, "s_s_s_btn"..vv, 0, 0, "res/wy/public/new_kuang.png")
                                if SL:GetMetaValue("ITEM_COUNT", vv) > 0 then
                                    GUI:Image_Create(s_s_btn, "star", 0, 0, "res/wy/public/new_star.png")
                                    if not GUI:ui_delegate(btn).star then GUI:Image_Create(btn, "star", 0, 0, "res/wy/public/new_star.png") end
                                end
                                local s_s_CheckBox = GUI:CheckBox_Create(s_s_btn, "CheckBox",GUI:getContentSize(btn).width - 40, 3, "res/wy/public/new_check_0.png", "res/wy/public/new_check_1.png")
                                GUI:CheckBox_setSelected(s_s_CheckBox, (shuju.xz[npc.s.."_"..v] and shuju.xz[npc.s.."_"..v] == 1) or (shuju.xz[""..vv] and shuju.xz[""..vv] == 1))
                                GUI:CheckBox_addOnEvent(s_s_CheckBox, function(self)
                                    shuju.xz[""..vv] = GUI:CheckBox_isSelected(self) and 1 or nil
                                    SL:SendLuaNetMsg(101, 2, 2, 0, vv)
                                    if shuju.xz[npc.s.."_"..v] and shuju.xz[npc.s.."_"..v] == 1 then
                                        shuju.xz[npc.s.."_"..v] = nil
                                        SL:SendLuaNetMsg(101, 2, 2, 0, npc.s.."_"..v)
                                    end
                                end)
                                local s_s_wz = GUI:RichText_Create(s_s_btn, "s_s_s_wz", 77, 17,  "<a href='jump#item_tips#"..vv.."'>"..kk[3].."</a>", 500, 17, "#f7f7de", 3,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})
                                GUI:setAnchorPoint(s_s_wz, 0.5, 0.5)
                            end
                            GUI:UserUILayout(s_s_list, {dir=3,addDir=1,gap = {x=5, y=5}})
                            GUI:Image_Create(s_list, "fgx"..v, 0, 0, "res/wy/public/npc_518_fgx.png")
                        else
                            for vv,kk in pairs(k.l)  do
                                if SL:GetMetaValue("ITEM_COUNT", vv) > 0 then
                                    if not GUI:ui_delegate(btn).star then GUI:Image_Create(btn, "star", 0, 0, "res/wy/public/new_star.png") end
                                end
                            end
                        end
                    end
                end
                local hs_zdhs = GUI:Image_Create(jm_node, 'hs_zdhs', 450, 60, 'res/wy/public/huishou/hs_zdhs.png')
                local CheckBox_zdhs = GUI:CheckBox_Create(hs_zdhs, "CheckBox_zdhs",GUI:getContentSize(hs_zdhs).width + 2, -2, "res/wy/public/xz0.png", "res/wy/public/xz1.png")
                GUI:setAnchorPoint(CheckBox_zdhs, 1, 0)
                GUI:CheckBox_setSelected(CheckBox_zdhs, shuju.kg[4] == 1)
                GUI:CheckBox_addOnEvent(CheckBox_zdhs, function(self)
                    SL:SendLuaNetMsg(101, 2, 4, 4, GUI:CheckBox_isSelected(self) and 1 or 0)
                end)
            elseif npc.s == 4 then
                local s_list = GUI:ListView_Create(jm_node, "s_list", 225.00, 128.00, 250.00, 340.00, 1)
                GUI:ListView_setItemsMargin(s_list, 10)
                for v,k in pairs(cogin.hs.fzfj)  do
                    local btn = GUI:Button_Create(s_list, "wz"..v, 0, 0, "res/wy/public/new_kuang.png")
                    GUI:addOnClickEvent(btn, function()
                        npc.s_s = v
                        new_hs_update()
                    end)
                    local CheckBox = GUI:CheckBox_Create(btn, "CheckBox",GUI:getContentSize(btn).width - 40, 3, "res/wy/public/new_check_0.png", "res/wy/public/new_check_1.png")
                    GUI:CheckBox_setSelected(CheckBox, shuju.xz[npc.s.."_"..v] and shuju.xz[npc.s.."_"..v] == 1)
                    GUI:CheckBox_addOnEvent(CheckBox, function(self)
                        if shuju.xz[npc.s.."_"..v] and shuju.xz[npc.s.."_"..v] == 1 then
                            shuju.xz[npc.s.."_"..v] = nil
                        else
                            shuju.xz[npc.s.."_"..v] = 1
                        end
                        SL:SendLuaNetMsg(101, 2, 2, 0, npc.s.."_"..v)
                        new_hs_update()
                    end)
                    local wz = GUI:Text_Create(btn, "wz", 77, 17, 17, "#FFFF00", cogin.hs.fzfj_bj[v])
                    GUI:setAnchorPoint(wz, 0.5, 0.5)
                    GUI:Text_enableOutline(wz, "#150800", 2)
                    if npc.s_s == v then
                        GUI:Image_Create(btn, "new_jiantou", 150, 0, "res/wy/public/new_jiantou.png")
                        local s_s_list = GUI:ListView_Create(jm_node, "s_s_list", 225.00 + 200, 128.00, 250.00, 340.00, 1)
                        GUI:ListView_setItemsMargin(s_s_list, 10)
                        for vv,kk in pairs(k)  do
                            local s_s_btn = GUI:Button_Create(s_s_list, "s_s_btn"..vv, 0, 0, "res/wy/public/new_kuang.png")
                            GUI:addOnClickEvent(s_s_btn, function()
                                npc.s_s_s = vv
                                new_hs_update()
                            end)
                            local s_s_CheckBox = GUI:CheckBox_Create(s_s_btn, "CheckBox",GUI:getContentSize(btn).width - 40, 3, "res/wy/public/new_check_0.png", "res/wy/public/new_check_1.png")
                            GUI:CheckBox_setSelected(s_s_CheckBox, (shuju.xz[npc.s.."_"..v] and shuju.xz[npc.s.."_"..v] == 1) or (shuju.xz[npc.s.."_"..v.."_"..vv] and shuju.xz[npc.s.."_"..v.."_"..vv] == 1))
                            GUI:CheckBox_addOnEvent(s_s_CheckBox, function(self)
                                shuju.xz[npc.s.."_"..v.."_"..vv] = GUI:CheckBox_isSelected(self) and 1 or nil
                                SL:SendLuaNetMsg(101, 2, 2, 0, npc.s.."_"..v.."_"..vv)
                                if shuju.xz[npc.s.."_"..v] and shuju.xz[npc.s.."_"..v] == 1 then
                                    shuju.xz[npc.s.."_"..v] = nil
                                    SL:SendLuaNetMsg(101, 2, 2, 0, npc.s.."_"..v)
                                end
                                new_hs_update()
                            end)
                            local s_s_wz = GUI:Text_Create(s_s_btn, "wz", 77, 17, 17, "#FFFF00", kk.name)
                            GUI:setAnchorPoint(s_s_wz, 0.5, 0.5)
                            GUI:Text_enableOutline(s_s_wz, "#150800", 2)
                            if npc.s_s_s == vv then
                                GUI:Image_Create(s_s_btn, "new_jiantou", 150, 0, "res/wy/public/new_jiantou.png")
                                local s_s_s_list = GUI:ListView_Create(jm_node, "s_s_s_list", 225.00 + 200 + 200, 128.00, 250.00, 340.00, 1)
                                GUI:ListView_setItemsMargin(s_s_s_list, 10)
                                for vvv,kkk in pairs(kk.l)  do
                                    local s_s_s_btn = GUI:Image_Create(s_s_s_list, "s_s_s_btn"..vvv, 0, 0, "res/wy/public/new_kuang.png")
                                    if SL:GetMetaValue("ITEM_COUNT", vvv) > 0 then
                                        GUI:Image_Create(s_s_s_btn, "star", 0, 0, "res/wy/public/new_star.png")
                                        if not GUI:ui_delegate(s_s_btn).star then GUI:Image_Create(s_s_btn, "", 0, 0, "res/wy/public/new_star.png") end
                                        if not GUI:ui_delegate(btn).star then GUI:Image_Create(btn, "star", 0, 0, "res/wy/public/new_star.png") end
                                    end
                                    local s_s_s_CheckBox = GUI:CheckBox_Create(s_s_s_btn, "CheckBox",GUI:getContentSize(btn).width - 40, 3, "res/wy/public/new_check_0.png", "res/wy/public/new_check_1.png")
                                    GUI:CheckBox_setSelected(s_s_s_CheckBox, (shuju.xz[npc.s.."_"..v] and shuju.xz[npc.s.."_"..v] == 1) or (shuju.xz[npc.s.."_"..v.."_"..vv] and shuju.xz[npc.s.."_"..v.."_"..vv] == 1) or (shuju.xz[""..vvv] and shuju.xz[""..vvv] == 1))
                                    GUI:CheckBox_addOnEvent(s_s_s_CheckBox, function(self)
                                        shuju.xz[""..vvv] = GUI:CheckBox_isSelected(self) and 1 or nil
                                        SL:SendLuaNetMsg(101, 2, 2, 0, vvv)
                                        if shuju.xz[npc.s.."_"..v] and shuju.xz[npc.s.."_"..v] == 1 then
                                            shuju.xz[npc.s.."_"..v] = nil
                                            SL:SendLuaNetMsg(101, 2, 2, 0, npc.s.."_"..v)
                                        end
                                        if shuju.xz[npc.s.."_"..v.."_"..vv] and shuju.xz[npc.s.."_"..v.."_"..vv] == 1 then
                                            shuju.xz[npc.s.."_"..v.."_"..vv] = nil
                                            SL:SendLuaNetMsg(101, 2, 2, 0, npc.s.."_"..v.."_"..vv)
                                        end
                                        new_hs_update()
                                    end)
                                    local s_s_s_wz = GUI:RichText_Create(s_s_s_btn, "s_s_s_wz", 77, 17,  "<a href='jump#item_tips#"..vvv.."'>"..kkk[3].."</a>", 500, 17, "#f7f7de", 3,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})
                                    GUI:setAnchorPoint(s_s_s_wz, 0.5, 0.5)
                                end
                            else
                                for vvv,kkk in pairs(kk.l)  do
                                    if SL:GetMetaValue("ITEM_COUNT", vvv) > 0 then
                                        if not GUI:ui_delegate(s_s_btn).star then GUI:Image_Create(s_s_btn, "", 0, 0, "res/wy/public/new_star.png") end
                                        if not GUI:ui_delegate(btn).star then GUI:Image_Create(btn, "star", 0, 0, "res/wy/public/new_star.png") end
                                    end
                                end
                            end
                        end
                    else
                        for vv,kk in pairs(k)  do
                            for vvv,kkk in pairs(kk.l)  do
                                if SL:GetMetaValue("ITEM_COUNT", vvv) > 0 then
                                    if not GUI:ui_delegate(btn).star then GUI:Image_Create(btn, "star", 0, 0, "res/wy/public/new_star.png") end
                                end
                            end
                        end
                    end
                end
                local hs_zdhs = GUI:Image_Create(jm_node, 'hs_zdhs', 450, 60, 'res/wy/public/huishou/hs_zdhs.png')
                local CheckBox_zdhs = GUI:CheckBox_Create(hs_zdhs, "CheckBox_zdhs",GUI:getContentSize(hs_zdhs).width + 2, -2, "res/wy/public/xz0.png", "res/wy/public/xz1.png")
                GUI:setAnchorPoint(CheckBox_zdhs, 1, 0)
                GUI:CheckBox_setSelected(CheckBox_zdhs, shuju.kg[4] == 1)
                GUI:CheckBox_addOnEvent(CheckBox_zdhs, function(self)
                    SL:SendLuaNetMsg(101, 2, 4, 4, GUI:CheckBox_isSelected(self) and 1 or 0)
                end)
            elseif npc.s == 5 then
                npc.bbzs = GUI:ListView_Create(jm_node, "bbzs", 15 + 272, -350  + 113+ 400, 500, 300, 1)
                GUI:ListView_setBackGroundImage(npc.bbzs, 'res/wy/public/500-300.png')
                xiaohui_update()
                GUI:Image_Create(jm_node, 'hs_wz', 15 + 272, -430  + 113+ 400, 'res/wy/public/huishou/hs_wz.png')
            end
        end
        npc.s = 1
        npc.s_s = 1
        npc.s_s_s = 1
        npc.hs_btn = {}
        for ii = 1, 5 do
            npc.hs_btn["s_"..ii] = GUI:Button_Create(l_list, "san"..ii, 0, 0, "res/wy/public/huishou/hsan_nsan_"..ii..".png")
            GUI:addOnClickEvent(npc.hs_btn["s_"..ii], function()
                GUI:Button_loadTextureNormal(npc.hs_btn["s_"..npc.s], "res/wy/public/huishou/hsan_nsan_"..npc.s..".png")
                npc.s = ii
                npc.s_s = 1
                npc.s_s_s = 1
                GUI:Button_loadTextureNormal(npc.hs_btn["s_"..npc.s], "res/wy/public/huishou/hsan_lsan_"..npc.s..".png")
                new_hs_update()
            end)
        end
        GUI:Button_loadTextureNormal(npc.hs_btn["s_"..npc.s], "res/wy/public/huishou/hsan_lsan_"..npc.s..".png")
        new_hs_update()

        npc.yjcz = GUI:Button_Create(npc.bg, 'yjcz', 700, 30, 'res/wy/public/hsan_11.png')

        GUI:addOnClickEvent(npc.yjcz, function()
            if npc.s == 1 or  npc.s == 2 or npc.s == 3 or npc.s == 4 then
                local item = SL:GetMetaValue("BAG_DATA")
                local hs = {}
                local huishou_jc_list = cogin.huishou_jc_list
                for k, v in pairs(item) do
                    if huishou_jc_list[v.Index] and (
                            (huishou_jc_list[v.Index].gl == 1 and (shuju.xz["1_"..huishou_jc_list[v.Index][1]] or shuju.xz["1_"..huishou_jc_list[v.Index][1].."_"..huishou_jc_list[v.Index][2]])) or
                                    (huishou_jc_list[v.Index].gl == 2 and (shuju.xz["2_"..huishou_jc_list[v.Index][1]] or shuju.xz["2_"..huishou_jc_list[v.Index][1].."_"..huishou_jc_list[v.Index][2]])) or
                                    (huishou_jc_list[v.Index].gl == 3 and shuju.xz["3_"..huishou_jc_list[v.Index][1]]) or
                                    (huishou_jc_list[v.Index].gl == 4 and (shuju.xz["4_"..huishou_jc_list[v.Index][1]] or shuju.xz["4_"..huishou_jc_list[v.Index][1].."_"..huishou_jc_list[v.Index][2]])) or
                                    shuju.xz[""..v.Index]) then
                            table.insert(hs, k)
                    end
                end
                if #hs > 0 then
                    SL:SendLuaNetMsg(101, 2, 5, 1, SL:JsonEncode(hs,false))
                    SL:ShowSystemTips("<font color='#00ff00'>一键回收执行完成</font>")
                else
                    SL:ShowSystemTips("<font color='#ff0000'>未发现可分解物品</font>")
                end
            elseif npc.s == 5 then
                if #npc.hs > 0 then
                    SL:SendLuaNetMsg(101, 2, 6, 0, SL:JsonEncode(npc.hs,false))
                    SL:ShowSystemTips("<font color='#00ff00'>一键回收执行完成</font>")
                else
                    SL:ShowSystemTips("<font color='#ff0000'>未发现可分解物品</font>")
                end
            end
        end)
    elseif p2 == 4 then  --刷新
        xiaohui_update()
    end
    SL:RegisterLUAEvent(LUA_EVENT_CLOSEWIN, "关闭界面", function(self)
        if self == "npc_huishou"  then
            SL:UnRegisterLUAEvent(LUA_EVENT_CLOSEWIN, "关闭界面")
            local xjm_parent = GUI:GetWindow(nil, "hs_xjm")
            if xjm_parent then
                GUI:Win_Close(xjm_parent)
            end
        end
    end)
end
---世界地图
npc[4] = function(p2, p3, msgData) -- 世界地图
    local parent = GUI:GetWindow(nil, "npc_sjdt")
    if parent then
        GUI:removeAllChildren(parent)
    else
        parent = GUI:Win_Create("npc_sjdt",cogin.w/2, cogin.h/2,0,0,false,false,false,true,true,0,1)
    end
    local bjt = GUI:Image_Create(parent, "bjt", 0, 0, "res/public/1900000651_1.png")
	GUI:setAnchorPoint(bjt, 0.5, 0.5)
	GUI:setContentSize(bjt, cogin.w + 100, cogin.h + 100)
    GUI:addMouseOverTips(bjt, "", {x = 0, y = 0}, {x = 0, y = 0})

    npc.bg = GUI:Image_Create(parent, "bg", 0, 0, "res/wy/public/anniu_4_blue_bj.png")
    GUI:setAnchorPoint(npc.bg, 0.5, 0.5)
    GUI:setContentSize(npc.bg, cogin.w, cogin.h)
    GUI:setTouchEnabled(npc.bg, true)
    GUI:Timeline_Window3(npc.bg)

    local close1 = GUI:Button_Create(npc.bg, "close", cogin.w - 160, cogin.h - 170, "res/wy/public/anniu_4_close.png")
    GUI:setLocalZOrder(close1, 99)
    GUI:addOnClickEvent(close1, function()
        GUI:Win_Close(parent)
        local x_parent = GUI:GetWindow(nil, "npc_x_sjdt")
        if x_parent then
            GUI:Win_Close(x_parent)
        end
    end)
end
---伏妖录任务
----任务名,npcid,任务类型（1为主线任务,2为支线任务）,任务检测（1数字型,2数组型,3称号型）,任务结束标志和进度标志,任务传送地点,任务传送限制（{1,10}等级,{2,10}转生,{3,”称号“}所需称号）
npc.xyl = {
    --二大陆任务
    {
         --第一章
        {
            jq = {
                { "扫荡野火帮（剧）",id = 999, jl = {{"剧情点",100}},fwdjy = function(play) return true end ,khdjy = function() return true end,yd = {1,"剑门外门",166,109,83} ,desc = "<核心/FCOLOR=249>完成二大陆转职\\(<提升核心属性/FCOLOR=250>)" },
                { "剿灭恶徒（剧）",id = 999, jl = {{"剧情点",100}},fwdjy = function(play) return true end ,khdjy = function() return true end,yd = {1,"剑门外门",166,109,83} ,desc = "<核心/FCOLOR=249>完成二大陆转职\\(<提升核心属性/FCOLOR=250>)" },
                { "天书强化",id = 999, jl = {{"剧情点",100}},fwdjy = function(play) return true end ,khdjy = function() return true end,yd = {1,"剑门外门",166,109,83} ,desc = "<核心/FCOLOR=249>完成二大陆转职\\(<提升核心属性/FCOLOR=250>)" },
                { "初识仙法",id = 999, jl = {{"剧情点",100}},fwdjy = function(play) return true end ,khdjy = function() return true end,yd = {1,"剑门外门",166,109,83} ,desc = "<核心/FCOLOR=249>完成二大陆转职\\(<提升核心属性/FCOLOR=250>)" },
            },
            --需求
            jqd = 0,
            jl = {{"绑定元宝",1000000},{"绑定灵符",100000}}
        },
        --第二章
        {
            jq = {
                { "杀伐之路（剧）",id = 999, jl = {{"剧情点",100}},fwdjy = function(play) return true end ,khdjy = function() return true end,yd = {1,"剑门外门",166,109,83} ,desc = "<核心/FCOLOR=249>完成二大陆转职\\(<提升核心属性/FCOLOR=250>)" },
                { "讨伐夜魔（剧）",id = 999, jl = {{"剧情点",100}},fwdjy = function(play) return true end ,khdjy = function() return true end,yd = {1,"剑门外门",166,109,83} ,desc = "<核心/FCOLOR=249>完成二大陆转职\\(<提升核心属性/FCOLOR=250>)" },
                { "装备强化",id = 999, jl = {{"剧情点",100}},fwdjy = function(play) return true end ,khdjy = function() return true end,yd = {1,"剑门外门",166,109,83} ,desc = "<核心/FCOLOR=249>完成二大陆转职\\(<提升核心属性/FCOLOR=250>)" },
                { "喂养灵根",id = 999, jl = {{"剧情点",100}},fwdjy = function(play) return true end ,khdjy = function() return true end,yd = {1,"剑门外门",166,109,83} ,desc = "<核心/FCOLOR=249>完成二大陆转职\\(<提升核心属性/FCOLOR=250>)" },
            },
            jqd = 400,
            jl = {{"绑定元宝",1000000},{"绑定灵符",100000}}
        },
        --第三章
        {
            jq = {
                { "修复轩辕剑（剧）",id = 999, jl = {{"剧情点",100}},fwdjy = function(play) return true end ,khdjy = function() return true end,yd = {1,"剑门外门",166,109,83} ,desc = "<核心/FCOLOR=249>完成二大陆转职\\(<提升核心属性/FCOLOR=250>)" },
                { "深入野火（剧）",id = 999, jl = {{"剧情点",100}},fwdjy = function(play) return true end ,khdjy = function() return true end,yd = {1,"剑门外门",166,109,83} ,desc = "<核心/FCOLOR=249>完成二大陆转职\\(<提升核心属性/FCOLOR=250>)" },
                { "守护森林（剧）",id = 999, jl = {{"剧情点",100}},fwdjy = function(play) return true end ,khdjy = function() return true end,yd = {1,"剑门外门",166,109,83} ,desc = "<核心/FCOLOR=249>完成二大陆转职\\(<提升核心属性/FCOLOR=250>)" },
                { "兵道之谜（剧）",id = 999, jl = {{"剧情点",100}},fwdjy = function(play) return true end ,khdjy = function() return true end,yd = {1,"剑门外门",166,109,83} ,desc = "<核心/FCOLOR=249>完成二大陆转职\\(<提升核心属性/FCOLOR=250>)" },
                { "幸运增幅",id = 999, jl = {{"剧情点",100}},fwdjy = function(play) return true end ,khdjy = function() return true end,yd = {1,"剑门外门",166,109,83} ,desc = "<核心/FCOLOR=249>完成二大陆转职\\(<提升核心属性/FCOLOR=250>)" },
                { "气运占卜",id = 999, jl = {{"剧情点",100}},fwdjy = function(play) return true end ,khdjy = function() return true end,yd = {1,"剑门外门",166,109,83} ,desc = "<核心/FCOLOR=249>完成二大陆转职\\(<提升核心属性/FCOLOR=250>)" },
                { "转生·二",id = 999, jl = {{"剧情点",100}},fwdjy = function(play) return true end ,khdjy = function() return true end,yd = {1,"剑门外门",166,109,83} ,desc = "<核心/FCOLOR=249>完成二大陆转职\\(<提升核心属性/FCOLOR=250>)" },

            },
            jqd = 800,
            jl = {{"绑定元宝",1000000},{"绑定灵符",100000}}
        },
    },

}
npc[11] = function(p2, p3, Data) -- 异闻录
	if p2 == 0 then
        --错的 要改为er  接受数据集
		npc.data = SL:JsonDecode(Data, false)
		local parent = GUI:GetWindow(nil, "npc_ywl")
		if parent then
			GUI:removeAllChildren(parent)
			GUI:setPosition(parent, cogin.w / 2, cogin.h / 2)
		else
			parent = GUI:Win_Create("npc_ywl", cogin.w / 2, cogin.h / 2, 0, 0, false, false, true, true, true, 0, 1)
		end
		local bjt = GUI:Image_Create(parent, "bjt", 0, 0, "res/public/1900000651_1.png")
		GUI:setAnchorPoint(bjt, 0.5, 0.5)
		GUI:setContentSize(bjt, cogin.w + 100, cogin.h + 100)
		GUI:setTouchEnabled(bjt, true)
		GUI:addOnClickEvent(bjt, function()
			GUI:Win_Close(parent)
		end)

        npc.bg = GUI:Image_Create(parent, "bj", 0, 0, 'res/custom/ywl/ywl_bj.png')
        GUI:setAnchorPoint(npc.bg, 0.5, 0.5)
        GUI:setTouchEnabled(npc.bg, true)
        GUI:Image_Create(npc.bg, "lbj", 120, 70, 'res/custom/ywl/ywl_lbj.png')

        local close = GUI:Button_Create(npc.bg, 'close', 960, 560, 'res/wy/public/close.png')
        GUI:addOnClickEvent(close, function()
            GUI:Win_Close(parent)
        end)

        local tt = GUI:Frames_Create(npc.bg, "tt", -20, 0, "res/custom/ywl/ywl_tt_", ".png", 1, 54, {speed = 50,count = 54,loop = -1,finishhide = false})
        npc.scdk = true


		function main_ru()
            function new_ziyemian(id)
                GUI:removeAllChildren(npc.node)
                GUI:Image_Create(npc.node, "anniu_23_img_2", 308, 70, 'res/custom/ywl/anniu_23_img_'.. 2 ..'.png')
                GUI:Image_Create(npc.node, "anniu_23_img_4", 308, 550, 'res/custom/ywl/anniu_23_img_'.. 4 ..'.png')

                GUI:Text_Create(npc.node, "TMONEY", 730 - 383, 580 - 100, 26, "#F7F7DE", "当前剧情点："..SL:GetMetaValue("TMONEY", "剧情点").."点")

                -- 当前章节配置，兼容新的 npc.xyl 结构（支持 jq 字段）
                local l  = npc.l or 1
                local zj = npc.zj or 1

                local lCfg  = npc.xyl[l]
                local zjCfg = lCfg and lCfg[zj]
                if not zjCfg then
                    return
                end

                local tasks = zjCfg.jq or zjCfg
                local taskCount = #tasks
                local _wc_num = 0

                local ScrollView_content = GUI:ScrollView_Create(npc.node, "ScrollView_content", 310,143, 647.00, 300, 2)
                GUI:ScrollView_setInnerContainerSize(ScrollView_content, taskCount * 210, 300)

                local Layout1 = GUI:Layout_Create(ScrollView_content, "Layout1", 0,0, taskCount * 200, 300, false)
                for v,k in ipairs(tasks) do
                    local bj = GUI:Image_Create(Layout1, "bj"..v, 0, 0, 'res/custom/ywl/anniu_23_zj_rw_n_3.png')
                    GUI:setContentSize(bj, 200, 300)

                    local rwtt = GUI:Text_Create(bj, "rwtt", 200/2, 200, 26, "#F7F7DE", k[1])
                    GUI:Text_setFontName(rwtt,"fonts/502.ttf")
                    GUI:setAnchorPoint(rwtt, 0.5, 0)

                    GUI:setAnchorPoint(GUI:RichTextFCOLOR_Create(bj, "desc", 200/2, 180, "任务描述:".. (k.desc or "可在任务界面查看"), 150, 16, "#00FFFF", 1,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})
                    , 0.5, 1)

                    if k.jl then
                        local jl_node =  ItemNumByTable_img(k.jl, nil,bj)
                        GUI:setPosition(jl_node, 40, 55)
                    end

                    if (npc.data.ywl["jl_"..npc.l.."_"..npc.zj] and npc.data.ywl["jl_"..npc.l.."_"..npc.zj] == 1) or
                            (npc.data.ywl["jl_"..npc.l.."_"..npc.zj.."_"..v] and npc.data.ywl["jl_"..npc.l.."_"..npc.zj.."_"..v] == 1) then
                        GUI:Image_Create(bj, "wc", 200/2, 40, 'res/wy/public/4.png')
                        GUI:Image_loadTexture(bj, 'res/wy/public/ywl/anniu_23_zj_rw_l_'..v..'.png')
                        _wc_num = _wc_num + 1
                    else
                        local enable = false
                        if k.id == 999 then
                            if k.fwdjy() then
                                enable = true
                            end
                
                            -- 统一按钮创建与点击事件
                            local btn = GUI:Button_Create(bj, "btn_", 200/2, 30,
                                    enable and 'res/custom/ywl/anniu_23_zj_cs_lq.png' or 'res/custom/ywl/anniu_23_zj_cs_an.png')
                            GUI:setAnchorPoint(btn, 0.5, 0.5)
                            GUI:addOnClickEvent(btn, function()
                                SL:SendLuaNetMsg(101, 11, enable and 3 or 1, 0,
                                        '{"i":' .. (npc.l or 1) .. ',"j":' .. (npc.zj or 1) .. ',"k":0,"z":' .. v .. '}')
                            end)
                        end
                    end
                end
                GUI:UserUILayout(Layout1, {dir=2,addDir=1,gap = {x=10}})

                if zjCfg.jl then
                    GUI:setPosition(ItemNumByTable_img(zjCfg.jl, nil,npc.node), 450, 80)
                end

                if npc.data.ywl["jl_"..npc.l.."_"..npc.zj] and npc.data.ywl["jl_"..npc.l.."_"..npc.zj] == 1 then
                    GUI:Image_Create(npc.node, "wc", 730, 60, 'res/wy/public/7_1.png')
                else
                    npc.jl = GUI:Button_Create(npc.node, "an", 730, 55, 'res/wy/public/an_lqjl.png')
                    GUI:addOnClickEvent(npc.jl, function()
                        SL:SendLuaNetMsg(101, 11, 2, 0,
                                '{"i":' .. (npc.l or 1) .. ',"j":' .. (npc.zj or 1) .. ',"k":0}')
                    end)
                end
            end
		end
        main_ru()
        npc.l = (npc.l and npc.l < 10) and npc.l or 1
        npc.zj = npc.zj or 1 
        npc.ywl_an = {}
        npc.l_an = {}
        npc.node = GUI:Node_Create(npc.bg, "node", 0, 0)

        npc.ywl_list = GUI:ListView_Create(npc.bg, "List", 110, 70, 200.00, 520.00, 1,false)
        GUI:ListView_setGravity(npc.ywl_list, 2)

        local function UI_l_updata() --界面渲染
            GUI:removeAllChildren(npc.ywl_list)
            for i = 1, #npc.xyl, 1 do
                npc.ywl_an[i] = GUI:Layout_Create(npc.ywl_list, "l_node_"..i, 0, 520 - (i) * 80, 200, 78, false)
                local ywl_an = GUI:Layout_Create(npc.ywl_an[i],"ywl_an_"..i,25,0,200,78,false)
                GUI:setTouchEnabled(ywl_an, true)
                GUI:Image_Create(ywl_an, "tt", -15, 15, 'res/wy/public/dl_'..i..'.png')
                GUI:addOnClickEvent(ywl_an, function()
                    if not dl_sz(i) then
                        SL:ShowSystemTips("<font color='#FF0000'>还未解锁该大陆...</font>")
                        return
                    end
                end)
                if i == npc.l then
                    GUI:setLocalZOrder(GUI:Image_Create(npc.ywl_an[npc.l], "kuang", 0, 0, 'res/custom/ywl/anniu_23_l_kuang.png')
                    , -1)
    
                    for i = 1 , #npc.xyl[npc.l], 1 do
                        local Button= GUI:Button_Create(npc.ywl_list, "Button"..i, 0, 0, "res/public/1900000660.png")
                        GUI:Button_setTitleText(Button, "第"..i.."章")
                        GUI:Button_setTitleFontSize(Button, 14)

                        GUI:addOnClickEvent(Button, function()
                            npc.zj = i
                            UI_l_updata()
                            new_ziyemian()
                        end)
                    end
                end
            end
        end
        UI_l_updata()
        new_ziyemian(0)

		SL:RegisterLUAEvent(LUA_EVENT_CLOSEWIN, "关闭界面", function(self)
			if self == "npc_ywl" then
				SL:UnRegisterLUAEvent(LUA_EVENT_CLOSEWIN, "关闭界面")
			end
		end)
	elseif p2 == 2 then
        npc.data.ywl["jl_"..p3] = 1
        GUI:Image_Create(GUI:getParent(npc.jl), 'wc', 515, 5, 'res/wy/public/7_1.png')
        GUI:removeFromParent(npc.jl)
    elseif p2 == 3 then
        npc.data = SL:JsonDecode(Data, false)
        npc.scdk = true
        new_ziyemian(0)
    elseif p2 == 100 then

	end
end
---活动提示
npc[12] = function(p2, p3, Data) -- 活动提示
    if p2 == 1 then
        npc.hd_data = SL:JsonDecode(Data, false)
        if npc.hdan then
            GUI:removeFromParent(npc.hdan)
            npc.hdan = nil
        end
        if cogin.isWin32 then
            npc.hdan = GUI:Button_Create(npc.RightTop, "hdan", -367, -260, "res/wy/icon/hd_l_"..p3..".png")
            GUI:addOnClickEvent(npc.hdan, function()
                SL:SendLuaNetMsg(101, 507, npc.hd_data.kf, npc.hd_data.idx, "")
            end)
            npc.djs = GUI:Text_Create(npc.hdan, "djs", 32 + 130, 19, 16, "#F7F7DE", npc.hd_data.sk*60)
            GUI:setAnchorPoint(npc.djs, 0.5, 0.5)
            GUI:Text_COUNTDOWN(npc.djs, npc.hd_data.sk*60,function()
                if npc.hdan then
                    GUI:removeFromParent(npc.hdan)
                    local parent = GUI:GetWindow(nil, "npc_hdtb_bj")
                    if parent then
                        GUI:Win_Close(parent)
                    end
                    npc.hdan = nil
                end
            end)
        else
            npc.hdan = GUI:Button_Create(npc.RightTop, "hdan", -390 - 125 + 226 - 55, -240  - 61 -31, "res/wy/icon/hd_l_"..p3..".png")
            GUI:addOnClickEvent(npc.hdan, function()
                SL:SendLuaNetMsg(101, 507, npc.hd_data.kf, npc.hd_data.idx, "")
            end)
            npc.djs = GUI:Text_Create(npc.hdan, "djs", 32 + 130, 19, 16, "#F7F7DE", npc.hd_data.sk*60)
            GUI:setAnchorPoint(npc.djs, 0.5, 0.5)
            GUI:Text_COUNTDOWN(npc.djs, npc.hd_data.sk*60,function()
                if npc.hdan then
                    GUI:removeFromParent(npc.hdan)
                    local parent = GUI:GetWindow(nil, "npc_hdtb_bj")
                    if parent then
                        GUI:Win_Close(parent)
                    end
                    npc.hdan = nil
                end
            end)
        end
    elseif p2 == 4 then
        if npc.hdan then
            GUI:removeFromParent(npc.hdan)
            npc.hdan = nil
            local parent = GUI:GetWindow(nil, "npc_hdtb_bj")
            if parent then
                GUI:Win_Close(parent)
            end
        end
    end
end
---记忆传送
npc[13] = function(p2, p3, msgData) -- 记录石
    if p2 == 0 then
        SL:SendLuaNetMsg(101, 13, 0, 0, "")
    elseif p2 == 1 then
        npc.jls = SL:JsonDecode(msgData, false)
        local parent = GUI:GetWindow(nil, "npc_jilushi")
        if parent then
            GUI:removeAllChildren(parent)
        else
            parent = GUI:Win_Create("npc_jilushi",cogin.w/2, cogin.h/2,0,0,false,false,false,true,true,0,1)
        end
        local bjt = GUI:Image_Create(parent, "bjt", 0, 0, "res/public/1900000651_1.png")
        GUI:setAnchorPoint(bjt, 0.5, 0.5)
        GUI:setContentSize(bjt, cogin.w + 100, cogin.h + 100)
        GUI:setTouchEnabled(bjt, true)
        GUI:addOnClickEvent(bjt, function()
            GUI:Win_Close(parent)
        end)
        npc.bg = GUI:Image_Create(parent, "img_bj", 0.00, 0.00, "res/wy/public/jys_bj.png")
        GUI:setAnchorPoint(npc.bg, 0.5, 0.5)
        GUI:setTouchEnabled(npc.bg, true)
        GUI:Timeline_Window3(npc.bg)
        local close = GUI:Button_Create(npc.bg, 'close', 467, 449, 'res/wy/public/close.png')
        GUI:addOnClickEvent(close, function()
            GUI:Win_Close(parent)
        end)
        local ScrollView_content = GUI:ScrollView_Create(npc.bg, "ScrollView_content", 6.00, 57.00, 458.00, 341.00, 1)
        GUI:ScrollView_setInnerContainerSize(ScrollView_content, 458, 495)
        local bj = GUI:Image_Create(ScrollView_content, "bj", 0.00, 0.50, "res/wy/public/jys_wz.png")
        local butt_jl,butt_cs = {},{}
        npc.jlswb = {}
        for i = 1, 10, 1 do
            local xsmc = ""
            if npc.jls and npc.jls["dtm"..i] then
                xsmc = npc.jls["dtm"..i][2].."("..npc.jls["dtm"..i][3]..","..npc.jls["dtm"..i][4]..")"
            else
                xsmc = "暂未记录"
            end
            npc.jlswb[i] = GUI:Text_Create(bj, "Text_"..i, 164.00, 524-i*50, 16, "#ffffff",xsmc)
            GUI:setAnchorPoint(npc.jlswb[i], 0.50, 0.50)
            GUI:Text_enableOutline(npc.jlswb[i], "#000000", 1)
            local xhtxt = GUI:Text_Create(bj, "xhtxt"..i, 40.00, 524-i*50, 16, "#ffffff",i)
            GUI:setAnchorPoint(xhtxt, 0.50, 0.50)
            GUI:Text_enableOutline(xhtxt, "#000000", 1)
            butt_jl[i] = GUI:Button_Create(bj, 'butt_jl_'..i, 271.00, 504-i*50, "res/wy/public/jys_jl.png")
            GUI:addOnClickEvent(butt_jl[i], function()
                SL:OpenCommonTipsPop({str="是否要记录该地图点位？会替换原有记录！",btnType=2,callback=function(atype,param)
                    if atype == 1 then
                        SL:SendLuaNetMsg(101, 13, 1, i, "")
                    end
                end})
            end)
            butt_cs[i] = GUI:Button_Create(bj, 'butt_cs'..i, 369.00, 504-i*50, "res/wy/public/jys_cs.png")
            GUI:addOnClickEvent(butt_cs[i], function()
                if npc.jls["dtm"..i] then
                    SL:SendLuaNetMsg(101, 13, 2, i, "")
                else
                    SL:ShowSystemTips("<font color='#ff0000'>未进行记录无法传送...</font>")
                end
            end)
        end
    elseif p2 == 2 then
        if p3 > 0 and p3 < 8 then
            npc.jls = SL:JsonDecode(msgData, false)
            GUI:Text_setString(npc.jlswb[p3],npc.jls["dtm"..p3][2].."("..npc.jls["dtm"..p3][3]..","..npc.jls["dtm"..p3][4]..")")
        end
    elseif p2 == 3 then
        GUI:Win_CloseByID("npc_jilushi")
    end
end
---实力提升
npc[17] = function(p2, p3, Data)  --实力提升

end
---新手礼包
npc[18] = function(p2, p3, Data)  --新手礼包
    local function UI_updata(node) --界面渲染
        GUI:removeAllChildren(node)

        local Button= GUI:Button_Create(node, "Button", 750, 100.00, "res/public/1900000660.png")
        GUI:Button_setTitleText(Button, "领取新手礼包")
        GUI:Button_setTitleFontSize(Button, 14)

        GUI:addOnClickEvent(Button, function()
            SL:SendLuaNetMsg(101, 18, 1, 0, "")
        end)
    end

    if p2 == 0 then
        local parent = GUI:GetWindow(nil, "npc_xslb")
        npc.data_18 = not Data and {} or SL:JsonDecode(Data, false)
        if parent then
            GUI:removeAllChildren(parent)
            GUI:setPosition(parent, cogin.w / 2, cogin.h / 2)
        else
            parent = GUI:Win_Create("npc_sclb", cogin.w / 2, cogin.h / 2, 0, 0, false, false, true, true, true, 0, 1)
        end
        local bjt = GUI:Image_Create(parent, "bjt", 0, 0, "res/public/1900000651_1.png")
        GUI:setAnchorPoint(bjt, 0.5, 0.5)
        GUI:setContentSize(bjt, cogin.w + 100, cogin.h + 100)
        GUI:setTouchEnabled(bjt, true)
        GUI:addOnClickEvent(bjt, function()
            GUI:Win_Close(parent)
        end)
        npc.bg = GUI:Image_Create(parent, "img_bj", 0, 0, 'res/wy/public/jiaozhu_0.png')
        GUI:setAnchorPoint(npc.bg, 0.5, 0.5)
        GUI:setTouchEnabled(npc.bg, true)
        GUI:Timeline_Window1(npc.bg)

        local close = GUI:Button_Create(npc.bg, 'close', 930, 480, 'res/wy/public/close.png')
        GUI:addOnClickEvent(close, function()
            GUI:Win_Close(parent)
        end)
        npc.node = GUI:Node_Create(npc.bg, "node", 0, 0)
        UI_updata(npc.node)
    end
end
---飞剑
npc[19] = function(p2, p3, Data)  --飞剑

    local state_info = {
        [1] = {
            color = "#FF0000", -- 红色
            text = "未激活"
        },
        [2] = {
            color = "#00FF00", -- 绿色
            text = "已激活"
        }
    }

    local function UI_updata(node) --界面渲染
        GUI:removeAllChildren(node)

        for v,k in pairs(cogin.teshudata["anniu_19"].details) do
            local kuang = GUI:Image_Create(node, "kuang"..v, 100 + (v-1) * 100, 250, "res/wy/public/70_70_k.png")
            local contentSize = kuang:getContentSize()
            local itemShow = GUI:ItemShow_Create(kuang, "item", contentSize.width / 2, contentSize.height / 2, { index = SL:GetMetaValue("ITEM_INDEX_BY_NAME",k.name), look = true, bgVisible = false })
            itemShow:setAnchorPoint(cc.p(0.5, 0.5))
            GUI:Text_Create(kuang, "name",30,50, 20, "#FF0000", k.name)
            local jh = 1
            if v == 1 then
                if SL:GetMetaValue("RELEVEL") >= 1 then
                    jh = 2
                end
            elseif v == 2 then
                if npc.data_19.T_data.ratio then
                    jh = 2
                end
            elseif v == 3 then
                if npc.data_19.T_data.cd then
                    jh = 2
                end
            elseif v == 4 then
                if npc.data_19.T_data.num and npc.data_19.T_data.num >= cogin.teshudata["anniu_19"].num then
                    jh = 2
                end
                GUI:Text_Create(kuang, "jd",100,0, 20, "#FF0000", (npc.data_19.T_data.num or 0)..'/'..cogin.teshudata["anniu_19"].num)
            end
            GUI:Text_Create(kuang, "jh",30,0, 20, state_info[jh].color, state_info[jh].text)


        end

        local Button= GUI:Button_Create(node, "Button1", 750, 200.00, "res/public/1900000660.png")
        GUI:Button_setTitleText(Button, "飞剑激活")
        GUI:Button_setTitleFontSize(Button, 14)

        GUI:addOnClickEvent(Button, function()
            SL:SendLuaNetMsg(101, 19, 1, 0, "")
        end)
        Button= GUI:Button_Create(node, "Button2", 750, 100.00, "res/public/1900000660.png")
        GUI:Button_setTitleText(Button, "飞剑取消")
        GUI:Button_setTitleFontSize(Button, 14)

        GUI:addOnClickEvent(Button, function()
            SL:SendLuaNetMsg(101, 19, 3, 0, "")
        end)
    end

    if p2 == 0 then
        local parent = GUI:GetWindow(nil, "npc_19")
        npc.data_19 = not Data and {} or SL:JsonDecode(Data, false)
        if parent then
            GUI:removeAllChildren(parent)
            GUI:setPosition(parent, cogin.w / 2, cogin.h / 2)
        else
            parent = GUI:Win_Create("npc_19", cogin.w / 2, cogin.h / 2, 0, 0, false, false, true, true, true, 0, 1)
        end
        local bjt = GUI:Image_Create(parent, "bjt", 0, 0, "res/public/1900000651_1.png")
        GUI:setAnchorPoint(bjt, 0.5, 0.5)
        GUI:setContentSize(bjt, cogin.w + 100, cogin.h + 100)
        GUI:setTouchEnabled(bjt, true)
        GUI:addOnClickEvent(bjt, function()
            GUI:Win_Close(parent)
        end)
        npc.bg = GUI:Image_Create(parent, "img_bj", 0, 0, 'res/wy/public/jiaozhu_0.png')
        GUI:setAnchorPoint(npc.bg, 0.5, 0.5)
        GUI:setTouchEnabled(npc.bg, true)
        GUI:Timeline_Window1(npc.bg)

        local close = GUI:Button_Create(npc.bg, 'close', 930, 480, 'res/wy/public/close.png')
        GUI:addOnClickEvent(close, function()
            GUI:Win_Close(parent)
        end)
        npc.node = GUI:Node_Create(npc.bg, "node", 0, 0)
        UI_updata(npc.node)
    elseif p2 == 1 then
        npc.data_19_tmp = not Data and {} or SL:JsonDecode(Data, false)
        SL:onLUAEvent(LUA_EVENT_PASSIVE_SKILL_DATA, { type = p3 ,count = npc.data_19_tmp.count ,psData = npc.data_19_tmp.psData})
    end
end
---天人之战面板
npc[498] = function(p2, p3, Data) -- 天人之战
    if p2 == 0 then
        npc.tyecsj = SL:JsonDecode(Data, false)
        if GUI:getChildByName(MainAssist._ui["Panel_hide"], "tyec_bj") then
            GUI:removeChildByName(MainAssist._ui["Panel_hide"], "tyec_bj")
        end
        npc.tyec = GUI:Image_Create(MainAssist._ui["Panel_hide"], "tyec_bj", 18, 0.00, "res/wy/public/tycccc.png")
	    GUI:setContentSize(npc.tyec, 260, 185)
        local zb = GUI:getContentSize(npc.tyec)
        GUI:setPositionY(npc.tyec, zb.height)
        GUI:runAction(npc.tyec, GUI:ActionMoveBy(0.3, 0, -zb.height))
        local Text = GUI:Text_Create(npc.tyec, "Text", 70.00, 164.00, 14, "#d6a573", [[排名数据/10s刷新]])
        GUI:Text_enableOutline(Text, "#000000", 1)
        local Text_1 = GUI:Text_Create(npc.tyec, "Text_1", 72.00, 6.00, 14, "#d6a573", [[当前个人积分:]])
        GUI:Text_enableOutline(Text_1, "#000000", 1)
        npc.tyecgr = GUI:Text_Create(Text_1, "Textxx", 92.00, 0.00, 14, "#d6a573",npc.tyecsj.grjf)
        GUI:Text_enableOutline(npc.tyecgr, "#000000", 1)
        local Live = GUI:ListView_Create(npc.tyec, "ListView", 0.00, 29.00, 261.00, 135.00, 1)
        GUI:ListView_setItemsMargin(Live, 2)
        local sft,mc = {},1
        npc.tyecpmm,npc.tyecpmf = {},{}
        for i = 1, 5, 1 do
            sft[i] = GUI:Image_Create(Live, "sft_"..i, 0,0, "res/wy/public/guang.png")
            GUI:setContentSize(sft[i], 260, 25)
            GUI:Text_Create(sft[i], "Text", 10.00, 3.00, 14, "#d6a573","NO."..i.."　　")
            GUI:Text_enableOutline(Text, "#000000", 1)
            npc.tyecpmm[i] = GUI:Text_Create(sft[i], "Text_1", 55.00, 3.00, 14, "#d6a573", "")
            GUI:Text_enableOutline(npc.tyecpmm[i], "#000000", 1)
            npc.tyecpmf[i] = GUI:Text_Create(sft[i], "Text_2"..i, 200.00, 3.00, 14, "#d6a573", "")
            GUI:Text_enableOutline(npc.tyecpmf[i], "#000000", 1)
            if npc.tyecsj.pmsj and npc.tyecsj.pmsj[i*2] and npc.tyecsj.pmsj[i*2] > 0 then
                GUI:Text_setString(npc.tyecpmm[i], npc.tyecsj.pmsj[mc])
                GUI:Text_setString(npc.tyecpmf[i], npc.tyecsj.pmsj[i*2])
            end
            mc = mc + 2
        end
    elseif p2 == 1 then
        npc.tyecsj = SL:JsonDecode(Data, false)
        if npc.tyec then
            local mc = 1
            for i = 1, 5, 1 do
                if npc.tyecsj.pmsj and npc.tyecsj.pmsj[i*2] and npc.tyecsj.pmsj[i*2] > 0 then
                    GUI:Text_setString(npc.tyecpmm[i], npc.tyecsj.pmsj[mc])
                    GUI:Text_setString(npc.tyecpmf[i], npc.tyecsj.pmsj[i*2])
                    mc = mc +2
                else
                    break
                end
            end
            GUI:Text_setString(npc.tyecgr, npc.tyecsj.grjf)
        else
            if GUI:getChildByName(MainAssist._ui["Panel_hide"], "tyec_bj") then
                GUI:removeChildByName(MainAssist._ui["Panel_hide"], "tyec_bj")
            end
            npc.tyec = GUI:Image_Create(MainAssist._ui["Panel_hide"], "tyec_bj", 18, 0.00, "res/wy/public/tycccc.png")
            GUI:setContentSize(npc.tyec, 260, 185)
            local zb = GUI:getContentSize(npc.tyec)
            GUI:setPositionY(npc.tyec, zb.height)
            GUI:runAction(npc.tyec, GUI:ActionMoveBy(0.3, 0, -zb.height))
            local Text = GUI:Text_Create(npc.tyec, "Text", 70.00, 164.00, 14, "#d6a573", [[排名数据/10s刷新]])
            GUI:Text_enableOutline(Text, "#000000", 1)
            local Text_1 = GUI:Text_Create(npc.tyec, "Text_1", 72.00, 6.00, 14, "#d6a573", [[当前个人积分:]])
            GUI:Text_enableOutline(Text_1, "#000000", 1)
            npc.tyecgr = GUI:Text_Create(Text_1, "Textxx", 92.00, 0.00, 14, "#d6a573",npc.tyecsj.grjf)
            GUI:Text_enableOutline(npc.tyecgr, "#000000", 1)
            local Live = GUI:ListView_Create(npc.tyec, "ListView", 0.00, 29.00, 261.00, 135.00, 1)
            GUI:ListView_setItemsMargin(Live, 2)
            local sft,mc = {},1
            npc.tyecpmm,npc.tyecpmf = {},{}
            for i = 1, 5, 1 do
                sft[i] = GUI:Image_Create(Live, "sft_"..i, 0,0, "res/wy/public/guang.png")
                GUI:setContentSize(sft[i], 260, 25)
                GUI:Text_Create(sft[i], "Text", 10.00, 3.00, 14, "#d6a573","NO."..i.."　　")
                GUI:Text_enableOutline(Text, "#000000", 1)
                npc.tyecpmm[i] = GUI:Text_Create(sft[i], "Text_1", 55.00, 3.00, 14, "#d6a573", "")
                GUI:Text_enableOutline(npc.tyecpmm[i], "#000000", 1)
                npc.tyecpmf[i] = GUI:Text_Create(sft[i], "Text_2"..i, 200.00, 3.00, 14, "#d6a573", "")
                GUI:Text_enableOutline(npc.tyecpmf[i], "#000000", 1)
                if npc.tyecsj.pmsj and npc.tyecsj.pmsj[i*2] and npc.tyecsj.pmsj[i*2] > 0 then
                    GUI:Text_setString(npc.tyecpmm[i], npc.tyecsj.pmsj[mc])
                    GUI:Text_setString(npc.tyecpmf[i], npc.tyecsj.pmsj[i*2])
                end
                mc = mc + 2
            end
        end

    elseif p2 == 2 then
        GUI:removeChildByName(MainAssist._ui["Panel_hide"], "tyec_bj")
        npc.tyec = nil
    end
end

---首冲礼包
npc[501] = function(p2, p3, Data) -- 首冲礼包
    local function UI_updata(node) --界面渲染
        GUI:removeAllChildren(node)

        GUI:setAnchorPoint(
                GUI:RichText_Create(node, "desc", 200, 430,
                        "<font color='#00FF00' size='20' >当前开服天数："..npc.data_501.time_data.."</font>\n"..
                                "<font color='#00FF00' size='20' >第一天奖励："..((npc.data_501.T_data["首充"] and npc.data_501.T_data["首充"] == 1 and npc.data_501.T_data._lb and npc.data_501.T_data._lb >= 1) and "已领取" or "未领取").."</font>\n"..
                                "<font color='#00FF00' size='20' >第二天奖励："..((npc.data_501.T_data["首充"] and npc.data_501.T_data["首充"] == 1 and npc.data_501.T_data._lb and npc.data_501.T_data._lb >= 2) and "已领取" or "未领取").."</font>\n"..
                                "<font color='#00FF00' size='20' >第三天奖励："..((npc.data_501.T_data["首充"] and npc.data_501.T_data["首充"] == 1 and npc.data_501.T_data._lb and npc.data_501.T_data._lb >= 3) and "已领取" or "未领取").."</font>\n"..
                                "<font color='#00FF00' size='20' >三天之后购买的奖励："..((npc.data_501.T_data["补充"] and npc.data_501.T_data["补充"] == 1 and npc.data_501.T_data._lb and npc.data_501.T_data._lb == 1) and "已领取" or "未领取").."</font>\n"
                , 500, 20, "#f7f7de", 3,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})
        , 0, 1)


        local Button= GUI:Button_Create(node, "Button", 750, 100.00, "res/public/1900000660.png")
        GUI:Button_setTitleText(Button, "领取奖励")
        GUI:Button_setTitleFontSize(Button, 14)

        GUI:addOnClickEvent(Button, function()
            SL:SendLuaNetMsg(101, 501, 1, 0, "")
        end)
    end

    if p2 == 0 then
        local parent = GUI:GetWindow(nil, "npc_sclb")
        npc.data_501 = not Data and {} or SL:JsonDecode(Data, false)
        if parent then
            GUI:removeAllChildren(parent)
            GUI:setPosition(parent, cogin.w / 2, cogin.h / 2)
        else
            parent = GUI:Win_Create("npc_sclb", cogin.w / 2, cogin.h / 2, 0, 0, false, false, true, true, true, 0, 1)
        end
        local bjt = GUI:Image_Create(parent, "bjt", 0, 0, "res/public/1900000651_1.png")
        GUI:setAnchorPoint(bjt, 0.5, 0.5)
        GUI:setContentSize(bjt, cogin.w + 100, cogin.h + 100)
        GUI:setTouchEnabled(bjt, true)
        GUI:addOnClickEvent(bjt, function()
            GUI:Win_Close(parent)
        end)
        npc.bg = GUI:Image_Create(parent, "img_bj", 0, 0, 'res/wy/public/jiaozhu_0.png')
        GUI:setAnchorPoint(npc.bg, 0.5, 0.5)
        GUI:setTouchEnabled(npc.bg, true)
        GUI:Timeline_Window1(npc.bg)

        local close = GUI:Button_Create(npc.bg, 'close', 930, 480, 'res/wy/public/close.png')
        GUI:addOnClickEvent(close, function()
            GUI:Win_Close(parent)
        end)
        npc.node = GUI:Node_Create(npc.bg, "node", 0, 0)
        UI_updata(npc.node)
    end
end
---在线充值
npc[502] = function(p2, p3, Data) -- 在线充值
    local function UI_updata(node) --界面渲染
        GUI:removeAllChildren(node)


        local Input = GUI:TextInput_Create(node, "Input",180.00, 50.00, 100.00, 25.00, 18)
        GUI:TextInput_setPlaceHolder(Input, "输入(最少10)")
        GUI:setTouchEnabled(Input, true)

        local cz_an = GUI:Button_Create(node, "cz_an", 300, 38, "res/public/1900000660.png")
        GUI:Button_setTitleText(cz_an, "充值")
        GUI:addOnClickEvent(cz_an, function()
            local msg = tonumber(GUI:TextInput_getString(Input))
            if msg then
                SL:SendLuaNetMsg(101, 502, 0, 3, msg)
            end
        end)



        for i=1,6 do
            --
            local Button = GUI:Image_Create(node, "img_lf"..i,  100 + (i < 4 and i or i-3) * 200, 100 + (i > 3 and 0 or 150), "res/wy/public/500-300.png")
            GUI:setTouchEnabled(Button, true)
            GUI:setContentSize(Button, 200, 150)

            GUI:Text_Create(Button, "wz",30,100, 20, "#FF0000", teshudata["anniu_502"].fj[i].."元")

            local richText = GUI:RichTextFCOLOR_Create(Button, "rich0", 10, 10, "<非绑仙玉/FCOLOR=250><*"..(teshudata["anniu_502"].fj[i] * 100).."/FCOLOR=149>   <绑定仙玉/FCOLOR=250><*"..(teshudata["anniu_502"].fj[i] * 100).."/FCOLOR=149>", 400, 13, "#f7f7de", 3,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})
            --GUI:setAnchorPoint(richText, 0.5, 1)
            GUI:addOnClickEvent(Button, function()
                SL:SendLuaNetMsg(101, 502, 0, 2, teshudata["anniu_502"].fj[i])
            end)




        end

    end

    if p2 == 0 then
        local parent = GUI:GetWindow(nil, "npc_zxcz")
        npc.data_502 = not Data and {} or SL:JsonDecode(Data, false)
        if parent then
            GUI:removeAllChildren(parent)
            GUI:setPosition(parent, cogin.w / 2, cogin.h / 2)
        else
            parent = GUI:Win_Create("npc_zxcz", cogin.w / 2, cogin.h / 2, 0, 0, false, false, true, true, true, 0, 1)
        end
        local bjt = GUI:Image_Create(parent, "bjt", 0, 0, "res/public/1900000651_1.png")
        GUI:setAnchorPoint(bjt, 0.5, 0.5)
        GUI:setContentSize(bjt, cogin.w + 100, cogin.h + 100)
        GUI:setTouchEnabled(bjt, true)
        GUI:addOnClickEvent(bjt, function()
            GUI:Win_Close(parent)
        end)
        npc.bg = GUI:Image_Create(parent, "img_bj", 0, 0, 'res/wy/public/jiaozhu_0.png')
        GUI:setAnchorPoint(npc.bg, 0.5, 0.5)
        GUI:setTouchEnabled(npc.bg, true)
        GUI:Timeline_Window1(npc.bg)

        local close = GUI:Button_Create(npc.bg, 'close', 930, 480, 'res/wy/public/close.png')
        GUI:addOnClickEvent(close, function()
            GUI:Win_Close(parent)
        end)
        npc.node = GUI:Node_Create(npc.bg, "node", 0, 0)
        UI_updata(npc.node)
    end
end
---小充值面板
npc[999] = function(p2, p3, Data) -- 小充值面板
    local parent = GUI:GetWindow(nil, "npc_czxz")
    if parent then
        GUI:removeAllChildren(parent)
        GUI:setPosition(parent, cogin.w / 2, cogin.h / 2)
    else
        parent = GUI:Win_Create("npc_czxz", cogin.w / 2, cogin.h / 2, 0, 0, false, false, true, true, true, 0, 1)
    end
    local bjt = GUI:Image_Create(parent, "bjt", 0, 0, "res/public/1900000651_1.png")
    GUI:setAnchorPoint(bjt, 0.5, 0.5)
    GUI:setContentSize(bjt, cogin.w + 100, cogin.h + 100)
    GUI:setTouchEnabled(bjt, true)
    GUI:addOnClickEvent(bjt, function()
        GUI:Win_Close(parent)
    end)
    local bg = GUI:Image_Create(parent, "img_bj", 0.00, 0.00, "res/wy/public/anniu_999_bj.png")
    GUI:setAnchorPoint(bg, 0.5, 0.5)
    GUI:setTouchEnabled(bg, true)
    GUI:Timeline_Window3(bg)
    local close = GUI:Button_Create(bg, 'close', 585, 290, 'res/wy/public/20.png')
    GUI:addOnClickEvent(close, function()
        GUI:Win_Close(parent)
    end)
    GUI:Image_Create(bg, "wz1", 160.00, 250.00, "res/wy/public/anniu_999_wz1.png")
    GUI:Image_Create(bg, "wz2", 160.00, 91.00, "res/wy/public/anniu_999_wz2.png")

    local txt = GUI:Text_Create(bg, "txt", 380.00, 91.00, 20, "#ffffff", p2)
    local Button = {}
    for i = 1, 3, 1 do
        Button[i] = GUI:Button_Create(bg, "Button_" .. i, 90 + (i - 1) * 160, 155.00, "res/wy/public/cz_" .. i .. "1.png")
        GUI:addOnClickEvent(Button[i], function()
            if Data == "1" then
                SL:RequestPay(i, p3, p2, 0)
            else
                SL:RequestPay(i, p3, p2, 0)
            end
            SL:SendLuaNetMsg(101, 502, i, 1, "")
        end)
    end
end
---解绑特权
npc[504] = function(p2, p3, Data) -- 解绑特权
    local function UI_updata(node) --界面渲染
        GUI:removeAllChildren(node)


        local give = deepCopy(teshudata["anniu_504"].give)

        table.insert(give, {teshudata["anniu_504"].ch .."[称号]",1})

        local give_show = ItemNumByTable_img(give, nil,GUI:Node_Create(node, "give", 0, 0))
        GUI:setPosition(give_show, 200, 300)



        local Button= GUI:Button_Create(node, "Button", 750, 100.00, "res/public/1900000660.png")
        GUI:Button_setTitleText(Button, "开通")
        GUI:Button_setTitleFontSize(Button, 14)

        GUI:addOnClickEvent(Button, function()
            SL:SendLuaNetMsg(101, 504, 1, 0, "")
        end)

    end

    if p2 == 0 then
        local parent = GUI:GetWindow(nil, "npc_jbtq")
        npc.data_504 = not Data and {} or SL:JsonDecode(Data, false)
        if parent then
            GUI:removeAllChildren(parent)
            GUI:setPosition(parent, cogin.w / 2, cogin.h / 2)
        else
            parent = GUI:Win_Create("npc_jbtq", cogin.w / 2, cogin.h / 2, 0, 0, false, false, true, true, true, 0, 1)
        end
        local bjt = GUI:Image_Create(parent, "bjt", 0, 0, "res/public/1900000651_1.png")
        GUI:setAnchorPoint(bjt, 0.5, 0.5)
        GUI:setContentSize(bjt, cogin.w + 100, cogin.h + 100)
        GUI:setTouchEnabled(bjt, true)
        GUI:addOnClickEvent(bjt, function()
            GUI:Win_Close(parent)
        end)
        npc.bg = GUI:Image_Create(parent, "img_bj", 0, 0, 'res/wy/public/jiaozhu_0.png')
        GUI:setAnchorPoint(npc.bg, 0.5, 0.5)
        GUI:setTouchEnabled(npc.bg, true)
        GUI:Timeline_Window1(npc.bg)

        local close = GUI:Button_Create(npc.bg, 'close', 930, 480, 'res/wy/public/close.png')
        GUI:addOnClickEvent(close, function()
            GUI:Win_Close(parent)
        end)
        npc.node = GUI:Node_Create(npc.bg, "node", 0, 0)
        UI_updata(npc.node)
    end
end
---巡航挂机
local guaji_ms = {"挂机时被攻击 自动随机（60秒冷却）", "挂机时未击杀 切换地图（120秒触发）", "挂机死亡或者回城后60秒随机下图","每20分钟自动切换地图"}
npc[505] = function(p2, p3, Data) -- 巡航挂机
	if p2 == 1 then
		npc.data = SL:JsonDecode(Data, false)
		local parent = GUI:GetWindow(nil, "npc_mrtq")
		if parent then
			GUI:removeAllChildren(parent)
			GUI:setPosition(parent, cogin.w / 2, cogin.h / 2)
		else
			parent = GUI:Win_Create("npc_mrtq", cogin.w / 2, cogin.h / 2, 0, 0, false, false, true, true, true, 0, 1)
		end
		local bjt = GUI:Image_Create(parent, "bjt", 0, 0, "res/public/1900000651_1.png")
		GUI:setAnchorPoint(bjt, 0.5, 0.5)
		GUI:setContentSize(bjt, cogin.w + 100, cogin.h + 100)
		GUI:setTouchEnabled(bjt, true)
		GUI:addOnClickEvent(bjt, function()
			GUI:Win_Close(parent)
		end)
		local npc_bg = GUI:Image_Create(parent, "npc_bg", 0.00, 0.00, "res/wy/public/emzm_xsbj.png")
        GUI:Image_setScale9Slice(npc_bg, 50, 50, 50, 50)
        GUI:setContentSize(npc_bg, 697, 418)
		GUI:setAnchorPoint(npc_bg, 0.5, 0.5)
		GUI:setTouchEnabled(npc_bg, true)
		GUI:Timeline_Window3(npc_bg)

        local ImageView_1 = GUI:Image_Create(npc_bg, "ImageView_1", 22.00, 19.00, "res/public/1900000651_1.png")
        GUI:Image_setScale9Slice(ImageView_1, 20, 20, 20, 20)
        GUI:setContentSize(ImageView_1, 652, 381)

		local close = GUI:Button_Create(npc_bg, 'close', 697, 380, 'res/wy/public/20.png')
		GUI:addOnClickEvent(close, function()
			GUI:Win_Close(parent)
		end)
		npc.ksgj = GUI:Button_Create(npc_bg, "ksgj", 439.00, 22.00, "res/public/1900000660.png")
		GUI:Button_setTitleText(npc.ksgj, npc.data.gjkg and "停止挂机" or "开始挂机")
		GUI:Button_setTitleColor(npc.ksgj, "#ffffff")
		GUI:Button_setTitleFontSize(npc.ksgj, 14)
		GUI:Button_titleEnableOutline(npc.ksgj, "#000000", 1)
		GUI:setTouchEnabled(npc.ksgj, true)
		GUI:addOnClickEvent(npc.ksgj, function()
			SL:SendLuaNetMsg(101, 505, 4, 0, "")
		end)
		local ListView = GUI:ListView_Create(npc_bg, "ListView", 26.00, 22.00, 300.00, 372.00, 1)
		GUI:ListView_setGravity(ListView, 5)
		GUI:setTouchEnabled(ListView, true)
		GUI:ListView_setItemsMargin(ListView, 10)
		local zhu_gx, Button = {}, {}
		npc.dtwb = {}
		npc.fu_gx = {}
        local zb = 0
		for i, v in ipairs(guaji_ms) do
			zhu_gx[i] = GUI:CheckBox_Create(npc_bg, "zhu_gx" .. i, 345.00, 340 - (i - 1) * 80, "res/public/btn_sifud_04.png", "res/public/btn_sifud_05.png")
			GUI:setTouchEnabled(zhu_gx[i], true)
			GUI:CheckBox_setSelected(zhu_gx[i], npc.data["zgx" .. (i == 3 and 4 or i == 4 and 5 or i)])
			GUI:Text_Create(zhu_gx[i], "Text", 48.00, 15.00, 16, "#ffffff", v)
			GUI:CheckBox_addOnEvent(zhu_gx[i], function()
				SL:SendLuaNetMsg(101, 505, 5, i == 3 and 4 or i == 4 and 5 or i, "")
			end)
		end
		for i = 1, 10, 1 do
			Button[i] = GUI:Button_Create(ListView, "Button" .. i, 0.00, 335.00, "res/public/bg_bti_07.png")
			GUI:setContentSize(Button[i], 300, 50)
			npc.fu_gx[i] = GUI:CheckBox_Create(Button[i], "fu_gx" .. i, 4.00, 0, "res/public/btn_sifud_04.png", "res/public/btn_sifud_05.png")
			GUI:CheckBox_setSelected(npc.fu_gx[i], npc.data["fgx" .. i])
			GUI:setTouchEnabled(npc.fu_gx[i], true)
			npc.dtwb[i] = GUI:Text_Create(npc.fu_gx[i], "dtmz" .. i, 50.00, 15.00, 16, "#ffffff", "当前记录地图：" .. (npc.data["dt" .. i] or "点击记录"))
			GUI:addOnClickEvent(Button[i], function()
				SL:SendLuaNetMsg(101, 505, 2, i, "")
			end)
			GUI:CheckBox_addOnEvent(npc.fu_gx[i], function()
				SL:SendLuaNetMsg(101, 505, 3, i, "")
			end)
		end
	elseif p2 == 2 then
		GUI:Text_setString(npc.dtwb[p3], "当前记录地图：" .. Data)
	elseif p2 == 3 then
		npc.data = SL:JsonDecode(Data, false)
		GUI:CheckBox_setSelected(npc.fu_gx[p3], npc.data["fgx" .. p3])
	elseif p2 == 4 then
		npc.data = SL:JsonDecode(Data, false)
		GUI:Button_setTitleText(npc.ksgj, npc.data.gjkg and "停止挂机" or "开始挂机")
	end
end
---天选之人
npc[506] = function(p2, p3, Data) -- 天选之人
	if p3 == 0 then
		local parent = GUI:GetWindow(nil, "npc_txzz")
		local data = not Data and {} or SL:JsonDecode(Data, false)
		if parent then
			GUI:removeAllChildren(parent)
			GUI:setPosition(parent, cogin.w / 2, cogin.h / 2)
		else
			parent = GUI:Win_Create("npc_txzz", cogin.w / 2, cogin.h / 2, 0, 0, false, false, true, true, true, 0, 1)
		end
		local bjt = GUI:Image_Create(parent, "bjt", 0, 0, "res/public/1900000651_1.png")
		GUI:setAnchorPoint(bjt, 0.5, 0.5)
		GUI:setContentSize(bjt, cogin.w + 100, cogin.h + 100)
		GUI:setTouchEnabled(bjt, true)
		GUI:addOnClickEvent(bjt, function()
			GUI:Win_Close(parent)
		end)
        npc.bg = GUI:Image_Create(parent, "bg", 0.00, 0.00, "res/wy/public/anniu_506_bj.png")
        GUI:setAnchorPoint(npc.bg, 0.5, 0.5)
        GUI:setTouchEnabled(npc.bg, true)
        GUI:Timeline_Window3(npc.bg)
        local close = GUI:Button_Create(npc.bg, 'close', 800, 400, 'res/wy/public/close.png')
        GUI:addOnClickEvent(close, function()
            GUI:Win_Close(parent)
        end)
        local dq = 1
        local Node = GUI:Node_Create(npc.bg,"Node",0,0)
        function updata_506()
            GUI:removeAllChildren(Node)
            GUI:setAnchorPoint(GUI:Text_Create(Node, "ds", 450 + 360, 27 + 100, 20, "#E317B3", data.T_txzr[dq])
            , 0.50, 0.50)
            GUI:setAnchorPoint(GUI:Text_Create(Node, "kqfz", 450 + 360,100, 20, "#E317B3", data.kqsj.."分钟")
            , 0.50, 0.50)
            local djs = GUI:Text_Create(Node, "djs", 450 + 360,100 - 27, 20, "#E317B3", 0)
            GUI:setAnchorPoint(djs, 0.50, 0.50)
            GUI:Text_COUNTDOWN(djs,((data.G_txzz_2 + 1) * 20 - data.kqsj) * 60)
            for i = 1, 10, 1 do
                GUI:setAnchorPoint(GUI:RichText_Create(Node, "jl"..i, 440, 360-(i-1)*22,  ItemNumByTable({{cogin.teshudata["anniu_506"][i],1}}), 500, 14, "#f7f7de", 3,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})
                , 0.50, 0.50)

                local Text = GUI:Text_Create(Node, "Text1"..i, 440 + 160, 360-(i-1)*22, 14, "#E317B3",
                        (data.A_txzz and data.A_txzz["md"..dq])
                                and (data.A_txzz["md"..dq][i] and data.A_txzz["md"..dq][i][1] or "---")
                                or "未开奖")
                GUI:setAnchorPoint(Text, 0.50, 0.50)
                GUI:Text_enableOutline(Text, "#000000", 1)
                local ds = GUI:Text_Create(Node, "ds"..i, 440 + 320, 360-(i-1)*22, 14, "#E317B3",
                        (data.A_txzz and data.A_txzz["md"..dq] )
                                and (data.A_txzz["md"..dq][i] and data.A_txzz["md"..dq][i][2] or "---")
                                or "0")
                GUI:setAnchorPoint(ds, 0.50, 0.50)
                GUI:Text_enableOutline(ds, "#000000", 1)
            end
        end
        for i = 1, 4, 1 do
            local btn = GUI:Button_Create(npc.bg, 'btn'..i, 200 + (i-1)*150, 400, "res/wy/public/anniu_506_l_"..i..".png")
            if i == 1 then
                npc.kuang = GUI:Image_Create(btn, "kuang", 0, 0, "res/wy/public/003.png")
                GUI:setContentSize(npc.kuang, 147, 112)
            end
            GUI:addOnClickEvent(btn, function()
                if i~=dq then
                    dq = i
                    GUI:removeFromParent(npc.kuang)
                    npc.kuang = GUI:Image_Create(btn, "kuang", 0, 0, "res/wy/public/003.png")
                    GUI:setContentSize(npc.kuang, 147, 112)
                    updata_506()
                end
            end)
        end
        updata_506()
	end
end
---游戏活动
npc[507] = function(p2, p3, Data) -- 游戏活动
    local function UI_updata(node) --界面渲染
        GUI:removeAllChildren(node)
        local titles = {"天选之人", "土城跑酷","随机夺宝","武林盟主"}


        for i = 1, #titles do
            local cbl_item = GUI:Button_Create(node, "item" .. i, 100+(i-1)*120, 50, "res/public/1900000660.png")
            GUI:Button_setTitleText(cbl_item, titles[i])
            GUI:Button_setTitleFontSize(cbl_item, 14)
            GUI:addOnClickEvent(cbl_item, function()
                SL:SendLuaNetMsg(101, 507, 1, i, "")
            end)
        end
    end

    if p2 == 0 then
        local parent = GUI:GetWindow(nil, "npc_hd")
        npc.data_507 = not Data and {} or SL:JsonDecode(Data, false)
        if parent then
            GUI:removeAllChildren(parent)
            GUI:setPosition(parent, cogin.w / 2, cogin.h / 2)
        else
            parent = GUI:Win_Create("npc_hd", cogin.w / 2, cogin.h / 2, 0, 0, false, false, true, true, true, 0, 1)
        end
        local bjt = GUI:Image_Create(parent, "bjt", 0, 0, "res/public/1900000651_1.png")
        GUI:setAnchorPoint(bjt, 0.5, 0.5)
        GUI:setContentSize(bjt, cogin.w + 100, cogin.h + 100)
        GUI:setTouchEnabled(bjt, true)
        GUI:addOnClickEvent(bjt, function()
            GUI:Win_Close(parent)
        end)
        npc.bg = GUI:Image_Create(parent, "img_bj", 0, 0, 'res/wy/public/jiaozhu_0.png')
        GUI:setAnchorPoint(npc.bg, 0.5, 0.5)
        GUI:setTouchEnabled(npc.bg, true)
        GUI:Timeline_Window1(npc.bg)

        local close = GUI:Button_Create(npc.bg, 'close', 930, 480, 'res/wy/public/close.png')
        GUI:addOnClickEvent(close, function()
            GUI:Win_Close(parent)
        end)
        npc.node = GUI:Node_Create(npc.bg, "node", 0, 0)
        UI_updata(npc.node)
    end
end
---福利大厅
npc[511] = function(p2, p3, Data) -- 福利大厅


    local function sort_by_state(grss)
        table.sort(grss, function(a, b)
            -- 自定义 state 优先级
            local order = { [1] = 1, [0] = 2, [2] = 3 }

            local a_order = order[a.state] or 99
            local b_order = order[b.state] or 99

            if a_order == b_order then
                return a.idx < b.idx  -- state 优先级相同，按 idx 排
            else
                return a_order < b_order  -- 按 state 优先级排序
            end
        end)
    end

    local state_info = {
        [1] = {
            color = "#FF0000", -- 红色
            text = "可领取"
        },
        [0] = {
            color = "#FFFF00", -- 黄色
            text = "未达成"
        },
        [2] = {
            color = "#00FF00", -- 绿色
            text = "已领取"
        }
    }


    local function GUI_createLabel(Label_node,idx)
        GUI:removeAllChildren(Label_node)
        if idx == 1 then
            local Label_list = GUI:ListView_Create(Label_node, "Label_list", 85 + 200, 50, 700, 500, 1)
            GUI:ListView_setItemsMargin(Label_list, 10)

            for v,k in ipairs(teshudata["fldt"]["7rqd"]) do
                local l = GUI:Image_Create(Label_list, "img_bj_l_"..v, 0, 0, 'res/wy/public/500-200.png')
                GUI:setContentSize(l, 500, 70)

                GUI:Text_Create(l, "wz",10,30, 20, "#FF0000", string.format("第%d天登录奖励",v))


                local give = ItemNumByTable_img(k.jl, nil,GUI:Node_Create(l, "give", 0, 0))
                GUI:setPosition(give, 200, 10)

                local Button= GUI:Button_Create(l, "Button", 400, 20, "res/public/1900000660.png")
                GUI:Button_setTitleText(Button, "领取")
                GUI:Button_setTitleFontSize(Button, 14)

                GUI:addOnClickEvent(Button, function()
                    SL:SendLuaNetMsg(101, 511, 1, 1, '{"7rqd":'..v..'}')
                end)
            end
        elseif idx == 2 then
            local Label_list = GUI:ListView_Create(Label_node, "Label_list", 85 + 200, 50, 700, 500, 1)
            GUI:ListView_setItemsMargin(Label_list, 10)

            for v,k in ipairs(teshudata["fldt"]["zxjl"]) do
                local l = GUI:Image_Create(Label_list, "img_bj_l_"..v, 0, 0, 'res/wy/public/500-200.png')
                GUI:setContentSize(l, 500, 70)

                GUI:Text_Create(l, "wz",10,30, 20, "#FF0000", string.format("在线时间%d分钟",k.time))


                local give = ItemNumByTable_img(k.jl, nil,GUI:Node_Create(l, "give", 0, 0))
                GUI:setPosition(give, 200, 10)

                local Button= GUI:Button_Create(l, "Button", 400, 20, "res/public/1900000660.png")
                GUI:Button_setTitleText(Button, "领取")
                GUI:Button_setTitleFontSize(Button, 14)

                GUI:addOnClickEvent(Button, function()
                    SL:SendLuaNetMsg(101, 511, 1, 2, '{"zxjl":'..v..'}')
                end)
            end
        elseif idx == 3 then
            local Label_list = GUI:ListView_Create(Label_node, "Label_list", 85 + 200, 50, 700, 500, 1)
            GUI:ListView_setItemsMargin(Label_list, 10)

            for v,k in ipairs(teshudata["fldt"]["sgjl"]) do
                local l = GUI:Image_Create(Label_list, "img_bj_l_"..v, 0, 0, 'res/wy/public/500-200.png')
                GUI:setContentSize(l, 500, 70)

                GUI:Text_Create(l, "wz",10,30, 20, "#FF0000", string.format("杀怪数量%d",k.num))


                local give = ItemNumByTable_img(k.jl, nil,GUI:Node_Create(l, "give", 0, 0))
                GUI:setPosition(give, 200, 10)

                local Button= GUI:Button_Create(l, "Button", 400, 20, "res/public/1900000660.png")
                GUI:Button_setTitleText(Button, "领取")
                GUI:Button_setTitleFontSize(Button, 14)

                GUI:addOnClickEvent(Button, function()
                    SL:SendLuaNetMsg(101, 511, 1, 2, '{"sgjl":'..v..'}')
                end)
            end
        elseif idx == 4 then
            local Label_list = GUI:ListView_Create(Label_node, "Label_list", 85 + 200, 50, 700, 500, 1)
            GUI:ListView_setItemsMargin(Label_list, 2)
            local grss = {}

            for v,k in pairs(teshudata["fldt"]["grss"]) do
                if npc.ts_data[""..v] == nil then
                    table.insert(grss, {idx = v, state = 0,name = k.name})
                else
                    table.insert(grss, {idx = v, state = npc.ts_data[""..v],name = teshudata["fldt"]["grss"][tonumber(v)].name})
                end
            end




            sort_by_state(grss)


            for i = (npc.sign-1)*10 + 1, (npc.sign-1)*10 + 10 do
                if not grss[i] then break end
                local v = grss[i]
                local l = GUI:Image_Create(Label_list, "img_bj_l_"..i, 0, 0, 'res/wy/public/500-200.png')
                GUI:setContentSize(l, 500, 40)

                GUI:Text_Create(l, "wz",10,5, 20, "#FF0000", v.name)

                GUI:Text_Create(l, "state",300,5, 20, state_info[v.state].color, state_info[v.state].text)
                GUI:RichText_Create(l, "jl", 150, 5,  ItemNumByTable(teshudata["fldt"]["grss"][v.idx].give), 500, 18, "#f7f7de", 3,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})


                local Button= GUI:Button_Create(l, "Button", 400, 0, "res/public/1900000660.png")
                GUI:Button_setTitleText(Button, "领取")
                GUI:Button_setTitleFontSize(Button, 14)

                GUI:addOnClickEvent(Button, function()
                    SL:SendLuaNetMsg(101, 511, 1, 4, '{"grss":"'..(v.idx)..'"}')
                end)
            end

            local Button= GUI:Button_Create(Label_node, "next", 800, 50, "res/public/1900000660.png")
            GUI:setAnchorPoint(Button, 0.5, 0)
            GUI:Button_setTitleText(Button, "下一页")
            GUI:Button_setTitleFontSize(Button, 14)
            GUI:addOnClickEvent(Button, function()
                if npc.sign == math.ceil(#grss/10) then
                    SL:ShowSystemTips("已经是最后一页了！！！")
                    return
                end
                npc.sign = npc.sign + 1
                GUI_createLabel(npc.Label,npc.titles_sign)
            end)
            Button= GUI:Button_Create(Label_node, "shangyiy", 600, 50, "res/public/1900000660.png")
            GUI:setAnchorPoint(Button, 0.5, 0)
            GUI:Button_setTitleText(Button, "上一页")
            GUI:Button_setTitleFontSize(Button, 14)
            GUI:addOnClickEvent(Button, function()
                if npc.sign == 1 then
                    SL:ShowSystemTips("已经是第一页了！！！")
                    return
                end
                npc.sign = npc.sign - 1
                GUI_createLabel(npc.Label,npc.titles_sign)
            end)
            GUI:setAnchorPoint(
                    GUI:Text_Create(Label_node, "state",700,50, 20, "#ffffff", string.format("第%d页/共%d页",npc.sign,math.ceil(#grss/10)))
            , 0.5, 0)


        elseif idx == 5 then
            local Label_list = GUI:ListView_Create(Label_node, "Label_list", 85 + 200, 50, 700, 500, 1)
            GUI:ListView_setItemsMargin(Label_list, 2)
            local grsb = {}

            for v,k in pairs(teshudata["fldt"]["grsb"]) do
                if npc.ts_data[""..v] == nil then
                    table.insert(grsb, {idx = v, state = 0,name = k.name})
                else
                    table.insert(grsb, {idx = v, state = npc.ts_data[""..v],name = teshudata["fldt"]["grsb"][tonumber(v)].name})
                end
            end




            sort_by_state(grsb)


            for i = (npc.sign-1)*10 + 1, (npc.sign-1)*10 + 10 do
                if not grsb[i] then break end
                local v = grsb[i]
                local l = GUI:Image_Create(Label_list, "img_bj_l_"..i, 0, 0, 'res/wy/public/500-200.png')
                GUI:setContentSize(l, 500, 40)

                GUI:Text_Create(l, "wz",10,5, 20, "#FF0000", v.name)

                GUI:Text_Create(l, "state",300,5, 20, state_info[v.state].color, state_info[v.state].text)
                GUI:RichText_Create(l, "jl", 150, 5,  ItemNumByTable(teshudata["fldt"]["grsb"][v.idx].give), 500, 18, "#f7f7de", 3,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})

                local Button= GUI:Button_Create(l, "Button", 400, 0, "res/public/1900000660.png")
                GUI:Button_setTitleText(Button, "领取")
                GUI:Button_setTitleFontSize(Button, 14)

                GUI:addOnClickEvent(Button, function()
                    SL:SendLuaNetMsg(101, 511, 1, 5, '{"grsb":"'..(v.idx)..'"}')
                end)
            end

            local Button= GUI:Button_Create(Label_node, "next", 800, 50, "res/public/1900000660.png")
            GUI:setAnchorPoint(Button, 0.5, 0)
            GUI:Button_setTitleText(Button, "下一页")
            GUI:Button_setTitleFontSize(Button, 14)
            GUI:addOnClickEvent(Button, function()
                if npc.sign == math.ceil(#grsb/10) then
                    SL:ShowSystemTips("已经是最后一页了！！！")
                    return
                end
                npc.sign = npc.sign + 1
                GUI_createLabel(npc.Label,npc.titles_sign)
            end)
            Button= GUI:Button_Create(Label_node, "shangyiy", 600, 50, "res/public/1900000660.png")
            GUI:setAnchorPoint(Button, 0.5, 0)
            GUI:Button_setTitleText(Button, "上一页")
            GUI:Button_setTitleFontSize(Button, 14)
            GUI:addOnClickEvent(Button, function()
                if npc.sign == 1 then
                    SL:ShowSystemTips("已经是第一页了！！！")
                    return
                end
                npc.sign = npc.sign - 1
                GUI_createLabel(npc.Label,npc.titles_sign)
            end)
            GUI:setAnchorPoint(
                    GUI:Text_Create(Label_node, "state",700,50, 20, "#ffffff", string.format("第%d页/共%d页",npc.sign,math.ceil(#grsb/10)))
            , 0.5, 0)
        elseif idx == 6 then
            local Label_list = GUI:ListView_Create(Label_node, "Label_list", 85 + 200, 50, 700, 500, 1)
            GUI:ListView_setItemsMargin(Label_list, 2)
            local qqsb = {}

            for v,k in pairs(teshudata["fldt"]["qqsb"]) do
                if npc.ts_data[""..v] == nil then
                    table.insert(qqsb, {idx = v, state = 0,name = k.name})
                else
                    table.insert(qqsb, {idx = v, state = npc.ts_data[""..v],name = teshudata["fldt"]["qqsb"][tonumber(v)].name})
                end
            end




            sort_by_state(qqsb)


            for i = (npc.sign-1)*10 + 1, (npc.sign-1)*10 + 10 do
                if not qqsb[i] then break end
                local v = qqsb[i]
                local l = GUI:Image_Create(Label_list, "img_bj_l_"..i, 0, 0, 'res/wy/public/500-200.png')
                GUI:setContentSize(l, 500, 40)

                GUI:Text_Create(l, "wz",10,5, 20, "#FF0000", v.name)

                GUI:Text_Create(l, "state",300,5, 20, state_info[v.state].color, state_info[v.state].text)
                GUI:RichText_Create(l, "jl", 150, 5,  ItemNumByTable(teshudata["fldt"]["qqsb"][v.idx].give), 500, 18, "#f7f7de", 3,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})

                local Button= GUI:Button_Create(l, "Button", 400, 0, "res/public/1900000660.png")
                GUI:Button_setTitleText(Button, "领取")
                GUI:Button_setTitleFontSize(Button, 14)

                GUI:addOnClickEvent(Button, function()
                    SL:SendLuaNetMsg(101, 511, 1, 6, '{"qqsb":"'..(v.idx)..'"}')
                end)
            end

            local Button= GUI:Button_Create(Label_node, "next", 800, 50, "res/public/1900000660.png")
            GUI:setAnchorPoint(Button, 0.5, 0)
            GUI:Button_setTitleText(Button, "下一页")
            GUI:Button_setTitleFontSize(Button, 14)
            GUI:addOnClickEvent(Button, function()
                if npc.sign == math.ceil(#qqsb/10) then
                    SL:ShowSystemTips("已经是最后一页了！！！")
                    return
                end
                npc.sign = npc.sign + 1
                GUI_createLabel(npc.Label,npc.titles_sign)
            end)
            Button= GUI:Button_Create(Label_node, "shangyiy", 600, 50, "res/public/1900000660.png")
            GUI:setAnchorPoint(Button, 0.5, 0)
            GUI:Button_setTitleText(Button, "上一页")
            GUI:Button_setTitleFontSize(Button, 14)
            GUI:addOnClickEvent(Button, function()
                if npc.sign == 1 then
                    SL:ShowSystemTips("已经是第一页了！！！")
                    return
                end
                npc.sign = npc.sign - 1
                GUI_createLabel(npc.Label,npc.titles_sign)
            end)
            GUI:setAnchorPoint(
                    GUI:Text_Create(Label_node, "state",700,50, 20, "#ffffff", string.format("第%d页/共%d页",npc.sign,math.ceil(#qqsb/10)))
            , 0.5, 0)

        end
    end

    local function UI_updata(node) --界面渲染
        GUI:removeAllChildren(node)



        npc.cbl_list = GUI:ListView_Create(node, "cbl_list", 85, 50, 150, 500, 1)
        GUI:ListView_setGravity(npc.cbl_list, 2)
        GUI:ListView_setItemsMargin(npc.cbl_list, 4)
        npc.Label = GUI:Node_Create(node, "Label", 0, 0)

        local titles = {"七日登录", "在线奖励", "杀怪奖励", "怪物首杀", "个人首爆", "全区首爆"}
        npc.titles_sign = 1
        for i = 1, #titles do
            local cbl_item = GUI:Button_Create(npc.cbl_list, "item" .. i, 0, 0, "res/public/1900000660.png")
            GUI:Button_setTitleText(cbl_item, titles[i])
            GUI:Button_setTitleFontSize(cbl_item, 14)
            GUI:addOnClickEvent(cbl_item, function()
                if i >= 4 then
                    SL:SendLuaNetMsg(101, 511, 2, i, "")
                    npc.sign = 1
                else
                    npc.titles_sign = i
                    GUI_createLabel(npc.Label,i)
                end
            end)

        end

    end

    if p2 == 0 then
        local parent = GUI:GetWindow(nil, "npc_fldt")
        npc.fldt_data = not Data and {} or SL:JsonDecode(Data, false)
        if parent then
            GUI:removeAllChildren(parent)
            GUI:setPosition(parent, cogin.w / 2, cogin.h / 2)
        else
            parent = GUI:Win_Create("npc_fldt", cogin.w / 2, cogin.h / 2, 0, 0, false, false, true, true, true, 0, 1)
        end
        local bjt = GUI:Image_Create(parent, "bjt", 0, 0, "res/public/1900000651_1.png")
        GUI:setAnchorPoint(bjt, 0.5, 0.5)
        GUI:setContentSize(bjt, cogin.w + 100, cogin.h + 100)
        GUI:setTouchEnabled(bjt, true)
        GUI:addOnClickEvent(bjt, function()
            GUI:Win_Close(parent)
        end)
        npc.bg = GUI:Image_Create(parent, "img_bj", 0, 0, 'res/wy/public/jiaozhu_0.png')
        GUI:setAnchorPoint(npc.bg, 0.5, 0.5)
        GUI:setTouchEnabled(npc.bg, true)
        GUI:Timeline_Window1(npc.bg)


        npc.node = GUI:Node_Create(npc.bg, "node", 0, 0)

        local close = GUI:Button_Create(npc.bg, 'close', 930, 480, 'res/wy/public/close.png')
        GUI:addOnClickEvent(close, function()
            GUI:Win_Close(parent)
        end)
        UI_updata(npc.node)
    elseif p2 == 2 then
        npc.ts_data = not Data and {} or SL:JsonDecode(Data, false)
        npc.titles_sign = p3
        GUI_createLabel(npc.Label,p3)
    end

end
---游戏攻略
npc[512] = function(p2, p3, Data) -- 游戏攻略
    local function UI_updata(node) --界面渲染
        GUI:removeAllChildren(node)

    end

    if p2 == 0 then
        local parent = GUI:GetWindow(nil, "npc_yxgl")
        npc.data_512 = not Data and {} or SL:JsonDecode(Data, false)
        if parent then
            GUI:removeAllChildren(parent)
            GUI:setPosition(parent, cogin.w / 2, cogin.h / 2)
        else
            parent = GUI:Win_Create("npc_yxgl", cogin.w / 2, cogin.h / 2, 0, 0, false, false, true, true, true, 0, 1)
        end
        local bjt = GUI:Image_Create(parent, "bjt", 0, 0, "res/public/1900000651_1.png")
        GUI:setAnchorPoint(bjt, 0.5, 0.5)
        GUI:setContentSize(bjt, cogin.w + 100, cogin.h + 100)
        GUI:setTouchEnabled(bjt, true)
        GUI:addOnClickEvent(bjt, function()
            GUI:Win_Close(parent)
        end)
        npc.bg = GUI:Image_Create(parent, "img_bj", 0, 0, 'res/wy/public/jiaozhu_0.png')
        GUI:setAnchorPoint(npc.bg, 0.5, 0.5)
        GUI:setTouchEnabled(npc.bg, true)
        GUI:Timeline_Window1(npc.bg)

        local close = GUI:Button_Create(npc.bg, 'close', 930, 480, 'res/wy/public/close.png')
        GUI:addOnClickEvent(close, function()
            GUI:Win_Close(parent)
        end)
        npc.node = GUI:Node_Create(npc.bg, "node", 0, 0)
        UI_updata(npc.node)
    end
end
---世界地图
npc[514] = function(p2, p3, Data) -- 世界地图
    local function UI_updata(node) --界面渲染
        GUI:removeAllChildren(node)
        local dbLayout = GUI:Layout_Create(node, "dbLayout", 100, 0, 500, 500)
        for i = 1, 9 do
            local btn = GUI:Button_Create(dbLayout, 'btn' .. i, 0, 0, 'res/public/1900000660.png')
            GUI:Button_setTitleText(btn, teshudata["sjdt"][500+i][1])
            GUI:Button_setTitleFontSize(btn, 14)

            GUI:addOnClickEvent(btn, function()
                SL:SendLuaNetMsg(100, 500+i, 1, 0, "")
            end)
        end
        GUI:UserUILayout(dbLayout, {dir=3,addDir=1,gap = {x=5, y=5}})


    end

    if p2 == 0 then
        local parent = GUI:GetWindow(nil, "npc_sjdt")
        if parent then
            GUI:removeAllChildren(parent)
            GUI:setPosition(parent, cogin.w / 2, cogin.h / 2)
        else
            parent = GUI:Win_Create("npc_sjdt", cogin.w / 2, cogin.h / 2, 0, 0, false, false, true, true, true, 0, 1)
        end
        local bjt = GUI:Image_Create(parent, "bjt", 0, 0, "res/public/1900000651_1.png")
        GUI:setAnchorPoint(bjt, 0.5, 0.5)
        GUI:setContentSize(bjt, cogin.w + 100, cogin.h + 100)
        GUI:setTouchEnabled(bjt, true)
        GUI:addOnClickEvent(bjt, function()
            GUI:Win_Close(parent)
        end)
        npc.bg = GUI:Image_Create(parent, "img_bj", 0, 0, 'res/wy/public/jiaozhu_0.png')
        GUI:setAnchorPoint(npc.bg, 0.5, 0.5)
        GUI:setTouchEnabled(npc.bg, true)
        GUI:Timeline_Window1(npc.bg)

        local close = GUI:Button_Create(npc.bg, 'close', 930, 480, 'res/wy/public/close.png')
        GUI:addOnClickEvent(close, function()
            GUI:Win_Close(parent)
        end)
        npc.node = GUI:Node_Create(npc.bg, "node", 0, 0)
        UI_updata(npc.node)
    end
end

---仙途奇缘（成就）
npc[515] = function(p2, p3, Data) -- 世界地图
    local function UI_updata(node) --界面渲染
        GUI:removeAllChildren(node)

        local dbLayout = GUI:Layout_Create(node, "dbLayout", 100,50, 500, 400)
        for k,v in ipairs(teshudata["anniu_515"].details) do
            local Button= GUI:Button_Create(dbLayout, "Button"..k, 0, 0.00, "res/public/1900000660.png")
            GUI:Button_setTitleText(Button, v.tt)
            GUI:Button_setTitleFontSize(Button, 14)
            GUI:Button_setTitleColor(Button, npc.data_515.T_data[""..k] and "#00FF00" or "#FF0000")
            GUI:addOnClickEvent(Button, function()
                GUI:removeChildByName(node,"desc")
                local desc = GUI:RichText_Create(node, "desc", 600, 430,
                        "<font color='#00FF00' size='20' >奇遇名称："..v.tt.."</font>\n"..
                                "<font color='#00FF00' size='20' >奇遇条件："..v.wz.."</font>\n"..
                                "<font color='#00FF00' size='20' >奇遇文字："..v.tip.."</font>\n"
                , 500, 20, "#f7f7de", 3,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})
                GUI:setAnchorPoint(desc, 0, 1)
            end)
        end
        GUI:UserUILayout(dbLayout, {dir=3,addDir=1,gap = {x=5, y=5}})
    end

    if p2 == 0 then
        npc.data_515 = not Data and {} or SL:JsonDecode(Data, false)
        local parent = GUI:GetWindow(nil, "npc_qy")
        if parent then
            GUI:removeAllChildren(parent)
            GUI:setPosition(parent, cogin.w / 2, cogin.h / 2)
        else
            parent = GUI:Win_Create("npc_qy", cogin.w / 2, cogin.h / 2, 0, 0, false, false, true, true, true, 0, 1)
        end
        local bjt = GUI:Image_Create(parent, "bjt", 0, 0, "res/public/1900000651_1.png")
        GUI:setAnchorPoint(bjt, 0.5, 0.5)
        GUI:setContentSize(bjt, cogin.w + 100, cogin.h + 100)
        GUI:setTouchEnabled(bjt, true)
        GUI:addOnClickEvent(bjt, function()
            GUI:Win_Close(parent)
        end)
        npc.bg = GUI:Image_Create(parent, "img_bj", 0, 0, 'res/wy/public/jiaozhu_0.png')
        GUI:setAnchorPoint(npc.bg, 0.5, 0.5)
        GUI:setTouchEnabled(npc.bg, true)
        GUI:Timeline_Window1(npc.bg)

        local close = GUI:Button_Create(npc.bg, 'close', 930, 480, 'res/wy/public/close.png')
        GUI:addOnClickEvent(close, function()
            GUI:Win_Close(parent)
        end)
        npc.node = GUI:Node_Create(npc.bg, "node", 0, 0)
        UI_updata(npc.node)
    end
end
--免费赞助
npc[516] = function(p2, p3, Data)
    local function UI_updata(node) --界面渲染
        GUI:removeAllChildren(node)
        local  list = GUI:ListView_Create( node, "list", 100,50, 800, 400,2)
        GUI:ListView_setItemsMargin(list,5)
        for k,v in ipairs(teshudata["anniu_516"].details) do
            local item = GUI:Image_Create(list, "item"..k, 0, 0, 'res/wy/public/500-200.png')
            GUI:setContentSize(item,200,500)

            GUI:Text_Create(item, "wz",10,400, 20, "#FF0000", v.ch)
            GUI:Text_Create(item, "sgsl",10,300, 20, "#FF0000", "需要击杀数量："..v.sgsl)


            local Button= GUI:Button_Create(item, "Button", 10, 100.00, "res/public/1900000660.png")
            GUI:Button_setTitleText(Button, "领取")
            GUI:Button_setTitleFontSize(Button, 14)

            GUI:addOnClickEvent(Button, function()
                SL:SendLuaNetMsg(101, 516, 1, k, "")
            end)

        end


    end

    if p2 == 0 then
        npc.data_516 = not Data and {} or SL:JsonDecode(Data, false)
        local parent = GUI:GetWindow(nil, "npc_anniu_516")
        if parent then
            GUI:removeAllChildren(parent)
            GUI:setPosition(parent, cogin.w / 2, cogin.h / 2)
        else
            parent = GUI:Win_Create("npc_anniu_516", cogin.w / 2, cogin.h / 2, 0, 0, false, false, true, true, true, 0, 1)
        end
        local bjt = GUI:Image_Create(parent, "bjt", 0, 0, "res/public/1900000651_1.png")
        GUI:setAnchorPoint(bjt, 0.5, 0.5)
        GUI:setContentSize(bjt, cogin.w + 100, cogin.h + 100)
        GUI:setTouchEnabled(bjt, true)
        GUI:addOnClickEvent(bjt, function()
            GUI:Win_Close(parent)
        end)
        npc.bg = GUI:Image_Create(parent, "img_bj", 0, 0, 'res/wy/public/jiaozhu_0.png')
        GUI:setAnchorPoint(npc.bg, 0.5, 0.5)
        GUI:setTouchEnabled(npc.bg, true)
        GUI:Timeline_Window1(npc.bg)

        local close = GUI:Button_Create(npc.bg, 'close', 930, 480, 'res/wy/public/close.png')
        GUI:addOnClickEvent(close, function()
            GUI:Win_Close(parent)
        end)
        npc.node = GUI:Node_Create(npc.bg, "node", 0, 0)
        UI_updata(npc.node)
    end
end

--聚宝盆
npc[517] = function(p2, p3, Data)
    local function UI_updata(node) --界面渲染
        GUI:removeAllChildren(node)

        local config = teshudata["anniu_517"].details[npc.data_517.T_data.level]


        GUI:Text_Create(node, "wz1",200,400, 20, "#FF0000", "当前聚宝盆等级："..(npc.data_517.T_data.level or 0).."级")
        GUI:Text_Create(node, "wz2",200,400 - 30, 20, "#FF0000", "领取次数："..(npc.data_517.cs or 0).."/"..config.maxcs)
        GUI:Text_Create(node, "wz3",200,400 - 60, 20, "#FF0000", "当前积分："..(npc.data_517.jf or 0))
        GUI:Text_Create(node, "wz4",200,400 - 90, 20, "#FF0000", "当前领取所需积分"..(config.jf or 0))


        GUI:Text_Create(node, "wz5",200,400 - 120, 20, "#FF0000", "奖励:")
        local give_show = ItemNumByTable_img(config.give, nil,GUI:Node_Create(node, "give", 0, 0))
        GUI:setPosition(give_show, 200, 200)


        local Button= GUI:Button_Create(node, "Button1", 750, 300.00, "res/public/1900000660.png")
        GUI:Button_setTitleText(Button, "升级当前聚宝盆")
        GUI:Button_setTitleFontSize(Button, 14)

        GUI:addOnClickEvent(Button, function()
            SL:SendLuaNetMsg(101, 517, 1, 0, '')
        end)

        Button= GUI:Button_Create(node, "Button2", 750, 150.00, "res/public/1900000660.png")
        GUI:Button_setTitleText(Button, "领取奖励")
        GUI:Button_setTitleFontSize(Button, 14)

        GUI:addOnClickEvent(Button, function()
            SL:SendLuaNetMsg(101, 517, 2, 0, '')
        end)


    end

    if p2 == 0 then
        npc.data_517 = not Data and {} or SL:JsonDecode(Data, false)
        local parent = GUI:GetWindow(nil, "npc_anniu_517")
        if parent then
            GUI:removeAllChildren(parent)
            GUI:setPosition(parent, cogin.w / 2, cogin.h / 2)
        else
            parent = GUI:Win_Create("npc_anniu_517", cogin.w / 2, cogin.h / 2, 0, 0, false, false, true, true, true, 0, 1)
        end
        local bjt = GUI:Image_Create(parent, "bjt", 0, 0, "res/public/1900000651_1.png")
        GUI:setAnchorPoint(bjt, 0.5, 0.5)
        GUI:setContentSize(bjt, cogin.w + 100, cogin.h + 100)
        GUI:setTouchEnabled(bjt, true)
        GUI:addOnClickEvent(bjt, function()
            GUI:Win_Close(parent)
        end)
        npc.bg = GUI:Image_Create(parent, "img_bj", 0, 0, 'res/wy/public/jiaozhu_0.png')
        GUI:setAnchorPoint(npc.bg, 0.5, 0.5)
        GUI:setTouchEnabled(npc.bg, true)
        GUI:Timeline_Window1(npc.bg)

        local close = GUI:Button_Create(npc.bg, 'close', 930, 480, 'res/wy/public/close.png')
        GUI:addOnClickEvent(close, function()
            GUI:Win_Close(parent)
        end)
        npc.node = GUI:Node_Create(npc.bg, "node", 0, 0)
        UI_updata(npc.node)
    elseif p2 == 1 then
        npc.data_517.T_data.level = npc.data_517.T_data.level + 1
        UI_updata(npc.node)
    elseif p2 == 2 then
        UI_updata(npc.node)
    end
end


local xlxl = {
    {"元宝","灵符","绑定元宝","绑定灵符","仙玉","绑定仙玉","累计充值","礼包积分","一合充值","二合充值","三合后充值"},
    {"充值18","充值38","充值68","充值128","充值288","充值588","充值888","充值1188","充值1588","充值1888"},
    {{"个人变量",105,178},{"个人标识",225,178},{"个人Buff",105,144},{"全局变量",225,144}},
    {"快人一步","前三天首冲","三天后首冲"},
}
npc[998] = function(p2, p3, Data)
    local parent = GUI:GetWindow(nil, "npc_hhhh")
    npc.data_998 = not Data and {} or SL:JsonDecode(Data, false)
	if parent then
		GUI:removeAllChildren(parent)
		GUI:setPosition(parent, cogin.w / 2, cogin.h / 2)
	else
		parent = GUI:Win_Create("npc_hhhh", cogin.w / 2, cogin.h / 2, 0, 0, false, false, true, true, true, 0, 1)
	end
	npc.bg = GUI:Image_Create(parent, "img_bj", 0.00, 0.00, "res/wy/public/jiaozhu_0.png")
	GUI:setAnchorPoint(npc.bg, 0.5, 0.5)
	GUI:setTouchEnabled(npc.bg, true)
	GUI:Timeline_Window3(npc.bg)
    local close = GUI:Button_Create(npc.bg, 'close', 970, 550, 'res/wy/public/close.png')
    GUI:addOnClickEvent(close, function()
        GUI:Win_Close(parent)
    end)
    local ImageView = GUI:Image_Create(npc.bg, "ImageView", 118.00, 495.00, "res/wy/public/input.png")
    local mingzi_sr = GUI:TextInput_Create(ImageView, "mingzi_sr", 0.00, 0.00, 155.00, 30.00, 16)
    GUI:TextInput_setPlaceHolder(mingzi_sr,"玩家名字")
    GUI:setTouchEnabled(mingzi_sr, true)
	local an_mz = GUI:Button_Create(npc.bg, "an_mz", 293.00, 493.00, "res/public/1900000660.png")
	GUI:Button_setTitleText(an_mz, "是否在线")
	GUI:Button_setTitleColor(an_mz, "#28ef01")
	GUI:Button_setTitleFontSize(an_mz, 14)
	GUI:Button_titleEnableOutline(an_mz, "#000000", 1)
    GUI:addOnClickEvent(an_mz, function()
        local shuru = GUI:TextInput_getString(mingzi_sr)
        if shuru == "" then
            SL:ShowSystemTips("<outline color='#000000' size='1'><font color='#FF0000'>请正确输入玩家名字</font></outline>")
        else
            SL:SendLuaNetMsg(101,998, 1, 0,shuru)
        end
    end)

    local an_txx,han_zb = {},{{493,"踢下线"},{440,"加入列表"},{383,"去除列表"},{323,"显示列表"}}
    for i, v in ipairs(han_zb) do
        an_txx[i] = GUI:Button_Create(npc.bg, "an_txx"..i, 410.00, v[1], "res/public/1900000660.png")
        GUI:Button_setTitleText(an_txx[i], v[2])
        GUI:Button_setTitleColor(an_txx[i], "#ff0500")
        GUI:Button_setTitleFontSize(an_txx[i], 14)
        GUI:Button_titleEnableOutline(an_txx[i], "#000000", 1)
        GUI:addOnClickEvent(an_txx[i], function()
            local shuru = GUI:TextInput_getString(mingzi_sr)
            if shuru == "" and i ~= 4 then
                SL:ShowSystemTips("<outline color='#000000' size='1'><font color='#FF0000'>请正确输入玩家名字</font></outline>")
            else
                SL:SendLuaNetMsg(101,998, 4, i,shuru)
            end
        end)
    end

	local an_huobi = GUI:Image_Create(npc.bg, "an_huobi", 120.00, 445.00, "res/wy/public/input.png")
	local Text_huobi = GUI:Text_Create(an_huobi, "Text_huobi", 71.00, 14.00, 16, "#ffffff", [[货币种类]])
	GUI:setAnchorPoint(Text_huobi, 0.50, 0.50)
	GUI:Text_enableOutline(Text_huobi, "#000000", 1)

    GUI:setTouchEnabled(an_huobi, true)
    GUI:addOnClickEvent(an_huobi, function()
        local zb = GUI:getWorldPosition(an_huobi)
        SL:OpenSelectListUI(xlxl[1],{x=zb.x,y=zb.y},156,30,function(iiid)
            GUI:Text_setString(Text_huobi, xlxl[1][iiid])
        end)
    end)
	local ImageView_1 = GUI:Image_Create(npc.bg, "ImageView_1", 118.00, 355.00, "res/wy/public/input.png")
	local huobi_sr = GUI:TextInput_Create(ImageView_1, "huobi_sr", 0.00, 0.00, 155.00, 30.00, 16)
	GUI:TextInput_setPlaceHolder(huobi_sr,"修改数值")
	GUI:setTouchEnabled(huobi_sr, true)
	local an_huobicha = GUI:Button_Create(npc.bg, "an_huobicha", 293.00, 440.00, "res/public/1900000660.png")
	GUI:Button_setTitleText(an_huobicha, "货币查询")
	GUI:Button_setTitleColor(an_huobicha, "#28ef01")
	GUI:Button_setTitleFontSize(an_huobicha, 14)
	GUI:Button_titleEnableOutline(an_huobicha, "#000000", 1)
	GUI:setTouchEnabled(an_huobicha, true)
    GUI:addOnClickEvent(an_huobicha,function()
        local mz = GUI:TextInput_getString(mingzi_sr)
        if mz == "" then
            SL:ShowSystemTips("<outline color='#000000' size='1'><font color='#FF0000'>请正确输入玩家名字</font></outline>")
        else
            local hb = GUI:Text_getString(Text_huobi)
            if hb == "货币种类" or hb == "" then
                SL:ShowSystemTips("<outline color='#000000' size='1'><font color='#FF0000'>请正确选择货币名字</font></outline>")
            else
                local id = 0
                for k, v in pairs(xlxl[1]) do
                    if v == hb then
                        id = k
                    end
                end
                SL:SendLuaNetMsg(101,998, 1, 1,'{"mz":"'..mz..'","hb":'..id..'}')
            end
        end
    end)

	local an_huobigai = GUI:Button_Create(npc.bg, "an_huobigai", 293.00, 383.00, "res/public/1900000660.png")
	GUI:Button_setTitleText(an_huobigai, "货币修改")
	GUI:Button_setTitleColor(an_huobigai, "#28ef01")
	GUI:Button_setTitleFontSize(an_huobigai, 14)
	GUI:Button_titleEnableOutline(an_huobigai, "#000000", 1)
	GUI:setTouchEnabled(an_huobigai, true)
    GUI:addOnClickEvent(an_huobigai,function()
        local mz = GUI:TextInput_getString(mingzi_sr)
        local hb = GUI:Text_getString(Text_huobi)
        if mz == "" then
            SL:ShowSystemTips("<outline color='#000000' size='1'><font color='#FF0000'>请正确输入玩家名字</font></outline>")
        elseif hb == "货币种类" or hb == "" then
                SL:ShowSystemTips("<outline color='#000000' size='1'><font color='#FF0000'>请正确选择货币名字</font></outline>")
        else
            local sl = tonumber(GUI:TextInput_getString(huobi_sr))
            if not sl then
                SL:ShowSystemTips("<outline color='#000000' size='1'><font color='#FF0000'>请输入数量</font></outline>")
            else
                local id = 0
                for k, v in pairs(xlxl[1]) do
                    if v == hb then
                        id = k
                    end
                end
                SL:SendLuaNetMsg(101,998, 1, 2,'{"mz":"'..mz..'","hb":'..id..',"sl":'..sl..'}')
            end
        end
    end)
	local an_hbzj = GUI:Button_Create(npc.bg, "an_hbzj", 293.00, 323.00, "res/public/1900000660.png")
	GUI:Button_setTitleText(an_hbzj, "货币增加")
	GUI:Button_setTitleColor(an_hbzj, "#28ef01")
	GUI:Button_setTitleFontSize(an_hbzj, 14)
	GUI:Button_titleEnableOutline(an_hbzj, "#000000", 1)
	GUI:setTouchEnabled(an_hbzj, true)
    GUI:addOnClickEvent(an_hbzj,function()
        local mz = GUI:TextInput_getString(mingzi_sr)
        local hb = GUI:Text_getString(Text_huobi)
        if mz == "" then
            SL:ShowSystemTips("<outline color='#000000' size='1'><font color='#FF0000'>请正确输入玩家名字</font></outline>")
        elseif hb == "货币种类" or hb == "" then
                SL:ShowSystemTips("<outline color='#000000' size='1'><font color='#FF0000'>请正确选择货币名字</font></outline>")
        else
            local sl = tonumber(GUI:TextInput_getString(huobi_sr))
            if not sl then
                SL:ShowSystemTips("<outline color='#000000' size='1'><font color='#FF0000'>请输入数量</font></outline>")
            else
                local id = 0
                for k, v in pairs(xlxl[1]) do
                    if v == hb then
                        id = k
                    end
                end
                SL:SendLuaNetMsg(101,998, 1, 3,'{"mz":"'..mz..'","hb":'..id..',"sl":'..sl..'}')
            end
        end
    end)

	local an_libao = GUI:Image_Create(npc.bg, "an_libao", 550.00, 495.00, "res/wy/public/input.png")
	local Text_libao = GUI:Text_Create(an_libao, "Text_libao", 75.00, 15.00, 16, "#ffffff", [[礼包种类]])
	GUI:setAnchorPoint(Text_libao, 0.50, 0.50)
	GUI:Text_enableOutline(Text_libao, "#000000", 1)
    GUI:setTouchEnabled(an_libao, true)
    GUI:addOnClickEvent(an_libao, function()
        local zb = GUI:getWorldPosition(an_libao)
        SL:OpenSelectListUI(xlxl[2],{x=zb.x,y=zb.y},156,30,function(iiid)
            GUI:Text_setString(Text_libao, xlxl[2][iiid])
        end)
    end)

	local an_lb = GUI:Button_Create(npc.bg, "an_lb", 724.00, 491.00, "res/public/1900000660.png")
	GUI:Button_setTitleText(an_lb, "增加礼包")
	GUI:Button_setTitleColor(an_lb, "#00ffff")
	GUI:Button_setTitleFontSize(an_lb, 14)
	GUI:Button_titleEnableOutline(an_lb, "#000000", 1)
	GUI:setTouchEnabled(an_lb, true)
    GUI:addOnClickEvent(an_lb,function()
        local mz = GUI:TextInput_getString(mingzi_sr)
        if mz == "" then
            SL:ShowSystemTips("<outline color='#000000' size='1'><font color='#FF0000'>请正确输入玩家名字</font></outline>")
        else
            local hb = GUI:Text_getString(Text_libao)
            if hb == "礼包种类" or hb == "" then
                SL:ShowSystemTips("<outline color='#000000' size='1'><font color='#FF0000'>请正确选择礼包种类</font></outline>")
            else
                local id = 0
                for k, v in pairs(xlxl[2]) do
                    if v == hb then
                        id = k
                    end
                end
                SL:SendLuaNetMsg(101,998, 1, 4,'{"mz":"'..mz..'","hb":'..id..'}')
            end
        end
    end)
    local an_libao_ts = GUI:Image_Create(npc.bg, "an_libao_ts", 550.00, 455.00, "res/wy/public/input.png")
    local Text_libao_ts = GUI:Text_Create(an_libao_ts, "Text_libao_ts", 75.00, 15.00, 16, "#ffffff", [[礼包种类]])
    GUI:setAnchorPoint(Text_libao_ts, 0.50, 0.50)
    GUI:Text_enableOutline(Text_libao_ts, "#000000", 1)
    GUI:setTouchEnabled(an_libao_ts, true)
    GUI:addOnClickEvent(an_libao_ts, function()
        local zb = GUI:getWorldPosition(an_libao_ts)
        SL:OpenSelectListUI(xlxl[4],{x=zb.x,y=zb.y},156,30,function(iiid)
            GUI:Text_setString(Text_libao_ts, xlxl[4][iiid])
        end)
    end)


    local huobi_sr_je = GUI:TextInput_Create(npc.bg, "huobi_sr_je", 550.00, 411.00, 115,30.00, 16)
    GUI:TextInput_setPlaceHolder(huobi_sr_je,"金额")
    GUI:setTouchEnabled(huobi_sr_je, true)

    local an_lb_ts_je = GUI:Button_Create(npc.bg, "an_lb_ts_je", 724.00, 411.00, "res/public/1900000660.png")
    GUI:Button_setTitleText(an_lb_ts_je, "金额充值")
    GUI:addOnClickEvent(an_lb_ts_je,function()
        local mz = GUI:TextInput_getString(mingzi_sr)
        if mz == "" then
            SL:ShowSystemTips("<outline color='#000000' size='1'><font color='#FF0000'>请正确输入玩家名字</font></outline>")
        else
            SL:SendLuaNetMsg(101,998, 5, 0,'{"mz":"'..mz..'","hb":'..GUI:TextInput_getString(huobi_sr_je)..'}')
        end
    end)


    local an_lb_ts = GUI:Button_Create(npc.bg, "an_lb_ts", 724.00, 451.00, "res/public/1900000660.png")
    GUI:Button_setTitleText(an_lb_ts, "增加礼包(特殊)")
    GUI:Button_setTitleColor(an_lb_ts, "#00ffff")
    GUI:Button_setTitleFontSize(an_lb_ts, 14)
    GUI:Button_titleEnableOutline(an_lb_ts, "#000000", 1)
    GUI:setTouchEnabled(an_lb_ts, true)
    GUI:addOnClickEvent(an_lb_ts,function()
        local mz = GUI:TextInput_getString(mingzi_sr)
        if mz == "" then
            SL:ShowSystemTips("<outline color='#000000' size='1'><font color='#FF0000'>请正确输入玩家名字</font></outline>")
        else
            local hb = GUI:Text_getString(Text_libao_ts)
            if hb == "礼包种类" or hb == "" then
                SL:ShowSystemTips("<outline color='#000000' size='1'><font color='#FF0000'>请正确选择礼包种类</font></outline>")
            else
                local id = 0
                for k, v in pairs(xlxl[4]) do
                    if v == hb then
                        id = k
                    end
                end
                SL:SendLuaNetMsg(101,998, 1, 5,'{"mz":"'..mz..'","hb":'..id..'}')
            end
        end
    end)
    local ImageView_2_1 = GUI:Image_Create(npc.bg, "ImageView_2_1", 91.00, 261.00, "res/wy/public/input.png")
    local wpmz_sr = GUI:TextInput_Create(ImageView_2_1, "wpmz_sr", 0.00, 0.00, 155.00, 30.00, 16)
    GUI:TextInput_setPlaceHolder(wpmz_sr,"物品名称")
    local ImageView_2_1_1 = GUI:Image_Create(npc.bg, "ImageView_2_1_1", 258.00, 261.00, "res/wy/public/input.png")
    GUI:setContentSize(ImageView_2_1_1, 50, 31)
    local wpsl_sr = GUI:TextInput_Create(ImageView_2_1_1, "wpsl_sr", 0.00, 0.00, 50.00, 30.00, 16)
    GUI:TextInput_setPlaceHolder(wpsl_sr,"数量")
	local CheckBox_wp = GUI:CheckBox_Create(ImageView_2_1_1, "CheckBox_wp", 76.00, 4.00, "res/public/1900000550.png", "res/public/1900000551.png")
	GUI:CheckBox_setSelected(CheckBox_wp, false)
	GUI:setTouchEnabled(CheckBox_wp, true)
	local Text = GUI:Text_Create(CheckBox_wp, "Text", 33.00, 3.00, 16, "#ffffff", [[勾选后绑定]])
	GUI:Text_enableOutline(Text, "#000000", 1)

    local an_wpk = GUI:Button_Create(npc.bg, "an_wpk", 95.00, 210.00, "res/public/1900000660.png")
    GUI:Button_setTitleText(an_wpk, "增加")
    GUI:Button_setTitleColor(an_wpk, "#00ffff")
    GUI:Button_setTitleFontSize(an_wpk, 14)
    GUI:Button_titleEnableOutline(an_wpk, "#000000", 1)
    GUI:addOnClickEvent(an_wpk,function()
        local mz,wp,sl = GUI:TextInput_getString(mingzi_sr),GUI:Text_getString(wpmz_sr),tonumber(GUI:Text_getString(wpsl_sr))
        if mz == "" then
            SL:ShowSystemTips("<outline color='#000000' size='1'><font color='#FF0000'>请正确输入玩家名字</font></outline>")
        elseif wp == "" then
                SL:ShowSystemTips("<outline color='#000000' size='1'><font color='#FF0000'>请正确输入物品名字</font></outline>")
        elseif not sl then
                SL:ShowSystemTips("<outline color='#000000' size='1'><font color='#FF0000'>请正确输入数量</font></outline>")
        else
            local zt = 0
            if GUI:CheckBox_isSelected(CheckBox_wp) then
                zt = 1 
            else
                zt = 0
            end
            SL:SendLuaNetMsg(101,998, 2, 1,'{"mz":"'..mz..'","wp":"'..wp..'","sl":'..sl..',"lx":'..zt..'}')
        end
    end)

    local an_wpj = GUI:Button_Create(npc.bg, "an_wpj", 232.00, 210.00, "res/public/1900000660.png")
    GUI:Button_setTitleText(an_wpj, "扣除")
    GUI:Button_setTitleColor(an_wpj, "#00ffff")
    GUI:Button_setTitleFontSize(an_wpj, 14)
    GUI:Button_titleEnableOutline(an_wpj, "#000000", 1)
    GUI:addOnClickEvent(an_wpj,function()
        local mz,wp,sl = GUI:TextInput_getString(mingzi_sr),GUI:Text_getString(wpmz_sr),tonumber(GUI:Text_getString(wpsl_sr))
        if mz == "" then
            SL:ShowSystemTips("<outline color='#000000' size='1'><font color='#FF0000'>请正确输入玩家名字</font></outline>")
        elseif wp == "" then
                SL:ShowSystemTips("<outline color='#000000' size='1'><font color='#FF0000'>请正确输入物品名字</font></outline>")
        elseif not sl then
                SL:ShowSystemTips("<outline color='#000000' size='1'><font color='#FF0000'>请正确输入数量</font></outline>")
        else
            SL:SendLuaNetMsg(101,998, 2, 2,'{"mz":"'..mz..'","wp":"'..wp..'","sl":'..sl..'}')
        end
    end)

    local an_wpj = GUI:Button_Create(npc.bg, "an_wpfs", 369.00, 210.00, "res/public/1900000660.png")
    GUI:Button_setTitleText(an_wpj, "发射")
    GUI:Button_setTitleColor(an_wpj, "#00ffff")
    GUI:Button_setTitleFontSize(an_wpj, 14)
    GUI:Button_titleEnableOutline(an_wpj, "#000000", 1)
    GUI:addOnClickEvent(an_wpj,function()
        local mz,wp,sl = GUI:TextInput_getString(mingzi_sr),GUI:Text_getString(wpmz_sr),tonumber(GUI:Text_getString(wpsl_sr))
        if mz == "" then
            SL:ShowSystemTips("<outline color='#000000' size='1'><font color='#FF0000'>请正确输入玩家名字</font></outline>")
        elseif wp == "" then
                SL:ShowSystemTips("<outline color='#000000' size='1'><font color='#FF0000'>请正确输入物品名字</font></outline>")
        elseif not sl then
                SL:ShowSystemTips("<outline color='#000000' size='1'><font color='#FF0000'>请正确输入数量</font></outline>")
        else
            SL:SendLuaNetMsg(101,998, 2, 3,'{"mz":"'..mz..'","wp":"'..wp..'","sl":'..sl..'}')
        end
    end)

    local an_ch = GUI:Button_Create(npc.bg, "an_chfs", 500.00, 210.00, "res/public/1900000660.png")
    GUI:Button_setTitleText(an_ch, "发送或者收回称号")
    GUI:Button_setTitleColor(an_ch, "#00ffff")
    GUI:Button_setTitleFontSize(an_ch, 14)
    GUI:Button_titleEnableOutline(an_ch, "#000000", 1)
    GUI:addOnClickEvent(an_ch,function()
        local mz,wp,sl = GUI:TextInput_getString(mingzi_sr),GUI:Text_getString(wpmz_sr),tonumber(GUI:Text_getString(wpsl_sr))
        if mz == "" then
            SL:ShowSystemTips("<outline color='#000000' size='1'><font color='#FF0000'>请正确输入玩家名字</font></outline>")
        elseif wp == "" then
            SL:ShowSystemTips("<outline color='#000000' size='1'><font color='#FF0000'>请正确输入称号名字</font></outline>")
        else
            SL:SendLuaNetMsg(101,998, 2, 4,'{"mz":"'..mz..'","ch":"'..wp..'"}')
        end
    end)
    local an_sbk = GUI:Button_Create(npc.bg, "an_sbk", 630.00, 210.00, "res/public/1900000660.png")
    GUI:Button_setTitleText(an_sbk, "设置沙巴克归属,名字处填入行会名")
    GUI:Button_setTitleColor(an_sbk, "#00ffff")
    GUI:Button_setTitleFontSize(an_sbk, 14)
    GUI:Button_titleEnableOutline(an_sbk, "#000000", 1)
    GUI:addOnClickEvent(an_sbk,function()
        local mz,wp,sl = GUI:TextInput_getString(mingzi_sr),GUI:Text_getString(wpmz_sr),tonumber(GUI:Text_getString(wpsl_sr))
        if mz == "" then
            SL:ShowSystemTips("<outline color='#000000' size='1'><font color='#FF0000'>请正确输入行会名</font></outline>")
        else
            SL:SendLuaNetMsg(101,998, 2, 5,'{"mz":"'..mz..'","wp":"'..wp..'"}')
        end
    end)

    local bl_fxk = {}
    for i, v in ipairs(xlxl[3]) do
        bl_fxk[i] = GUI:CheckBox_Create(npc.bg, "bl_fxk_"..i, v[2], v[3], "res/public/1900000550.png", "res/public/1900000551.png")
        GUI:CheckBox_setSelected(bl_fxk[i], false)
        GUI:setTouchEnabled(bl_fxk[i], true)
        local Text = GUI:Text_Create(bl_fxk[i], "Text", 33.00, 3.00, 16, "#ffffff", v[1])
        GUI:Text_enableOutline(Text, "#000000", 1)
        GUI:CheckBox_addOnEvent(bl_fxk[i], function(self)
            GUI:CheckBox_setSelected(bl_fxk[1],i==1)
            GUI:CheckBox_setSelected(bl_fxk[2],i==2)
            GUI:CheckBox_setSelected(bl_fxk[3],i==3)
            GUI:CheckBox_setSelected(bl_fxk[4],i==4)
        end)
    end
    GUI:CheckBox_setSelected(bl_fxk[1],true)

	local blmz = GUI:Image_Create(npc.bg, "blmz", 99.00, 98.00, "res/wy/public/input.png")
    GUI:setContentSize(blmz, 100, 31)
	local bianliang_sr = GUI:TextInput_Create(blmz, "bianliang_sr", 0.00, 0.00, 100.00, 30.00, 16)
    GUI:TextInput_setPlaceHolder(bianliang_sr,"变量名")
	local bl_xg = GUI:Image_Create(npc.bg, "bl_xg", 236.00, 98.00, "res/wy/public/input.png")
	GUI:setContentSize(bl_xg, 100, 31)
	local bianliang_xg = GUI:TextInput_Create(bl_xg, "bianliang_xg", 0.00, 0.00, 100.00, 30.00, 16)
	GUI:TextInput_setPlaceHolder(bianliang_xg,"修改值")
	local an_blc = GUI:Button_Create(npc.bg, "an_blc", 95.00, 44.00, "res/public/1900000660.png")
	GUI:Button_setTitleText(an_blc, "查询")
	GUI:Button_setTitleColor(an_blc, "#00ffff")
	GUI:Button_setTitleFontSize(an_blc, 14)
	GUI:Button_titleEnableOutline(an_blc, "#000000", 1)
    GUI:addOnClickEvent(an_blc,function()
        local mz,bl,lx = GUI:TextInput_getString(mingzi_sr),GUI:Text_getString(bianliang_sr),0
        for i = 1, 4, 1 do
            if GUI:CheckBox_isSelected(bl_fxk[i]) then
                lx = i
                break
            end
        end
        if mz == "" and lx ~= 4 then
            SL:ShowSystemTips("<outline color='#000000' size='1'><font color='#FF0000'>请正确输入玩家名字</font></outline>")
        elseif bl == "" then
            SL:ShowSystemTips("<outline color='#000000' size='1'><font color='#FF0000'>请正确输入变量名字</font></outline>")
        else
            SL:SendLuaNetMsg(101,998, 3,1,'{"mz":"'..mz..'","bl":"'..bl..'","lx":'..lx..'}')
        end
    end)
	local an_blg = GUI:Button_Create(npc.bg, "an_blg", 232.00, 44.00, "res/public/1900000660.png")
	GUI:Button_setTitleText(an_blg, "修改")
	GUI:Button_setTitleColor(an_blg, "#00ffff")
	GUI:Button_setTitleFontSize(an_blg, 14)
	GUI:Button_titleEnableOutline(an_blg, "#000000", 1)
    GUI:addOnClickEvent(an_blg,function()
        local mz,bl,lx,zhi = GUI:TextInput_getString(mingzi_sr),GUI:Text_getString(bianliang_sr),0,GUI:Text_getString(bianliang_xg)
        for i = 1, 4, 1 do
            if GUI:CheckBox_isSelected(bl_fxk[i]) then
                lx = i
                break
            end
        end
        if mz == "" and lx ~= 4 then
            SL:ShowSystemTips("<outline color='#000000' size='1'><font color='#FF0000'>请正确输入玩家名字</font></outline>")
        elseif bl == "" then
            SL:ShowSystemTips("<outline color='#000000' size='1'><font color='#FF0000'>请正确输入变量名字</font></outline>")
        elseif zhi == "" then
            SL:ShowSystemTips("<outline color='#000000' size='1'><font color='#FF0000'>请正确输入修改值</font></outline>")
        else
            SL:SendLuaNetMsg(101,998, 3, 2,'{"mz":"'..mz..'","bl":"'..bl..'","lx":'..lx..',"zhi":'..zhi..'}')
        end
    end)
end

---主城跑酷面板
npc[1000] = function(p2, p3, Data) -- 跑酷
    if p2 == 1 then
        local parent = GUI:GetWindow(nil, "npc_pkxjm")
		if parent then
			GUI:removeAllChildren(parent)
			GUI:setPosition(parent, cogin.w / 2, cogin.h / 2)
		else
			parent = GUI:Win_Create("npc_pkxjm", cogin.w -350, cogin.h / 2, 0, 0, false, false, true, false, true, 0, 1)
		end
        npc.bg = GUI:Image_Create(parent, "img_bj", 0.00, 0.00, "res/wy/icon/hdtb_3.png")
		GUI:setAnchorPoint(npc.bg, 0.5, 0.5)
		GUI:setTouchEnabled(npc.bg, true)
		GUI:Timeline_Window3(npc.bg)
        local txt = GUI:Text_Create(npc.bg, "Text", 10, -22, 14, "#ffffff","勾选自动跑酷")
        GUI:Text_enableOutline(txt, "#000000", 1)
        local CheckBox = GUI:CheckBox_Create(npc.bg, "CheckBox", -20, -22, "res/public/1900000550.png", "res/public/1900000551.png")
        GUI:CheckBox_addOnEvent(CheckBox, function(self)
            if GUI:CheckBox_isSelected(self) then
                if SL:GetMetaValue("MAP_ID") == "xtc" then
                    SL:SetMetaValue("BATTLE_MOVE_BEGIN", "xtc", math.random(128, 146), math.random(129, 147))
                    SL:RegisterLUAEvent(LUA_EVENT_AUTOMOVEEND, "跑酷寻路结束", function()
                        SL:SetMetaValue("BATTLE_MOVE_BEGIN", "xtc", math.random(128, 146), math.random(129, 147))
                    end, parent)
                else
                    GUI:CheckBox_setSelected(self, false)
                    SL:ShowSystemTips("<outline color='#000000' size='1'><font color='#ff0500'>只能在土城才能使用</font></outline>")
                end
            else
                SL:UnRegisterLUAEvent(LUA_EVENT_AUTOMOVEEND, "跑酷寻路结束")
                SL:SetMetaValue("BATTLE_MOVE_END")
            end
        end)
        SL:RegisterLUAEvent(LUA_EVENT_CLOSEWIN, "界面关闭_npc_paoku", function(winID)
            if winID and winID == "npc_pkxjm" then
                SL:UnRegisterLUAEvent(LUA_EVENT_AUTOMOVEEND, "跑酷寻路结束")
                SL:UnRegisterLUAEvent(LUA_EVENT_CLOSEWIN, "界面关闭_npc_paoku")
            end
        end)
    elseif p2 == 2 then
        GUI:Win_CloseByID("npc_pkxjm")
    end
end
---地图切换 --变暗
npc[1002] = function(p2, p3, msgData) -- 地图切换
    local parent = GUI:GetWindow(nil, "npc_qhdt")
    if parent then
        GUI:removeAllChildren(parent)
        GUI:setPosition(parent, cogin.w / 2, cogin.h / 2)
    else
        parent = GUI:Win_Create("npc_qhdt", cogin.w / 2, cogin.h / 2, 0, 0, false, false, true, false, true, 0, 1)
    end
    local bjt = GUI:Image_Create(parent, "bjt", 0, 0, "res/public/1900000651_1.png")
    GUI:setAnchorPoint(bjt, 0.5, 0.5)
    GUI:setContentSize(bjt, cogin.w + 100, cogin.h + 100)
    local bg = GUI:Image_Create(bjt, "bg", cogin.w -200, cogin.h / 2+50, "res/wy/public/dtxs/"..msgData..".png")
    GUI:setAnchorPoint(bg, 0.5, 0.5)

    GUI:Timeline_FadeOut(bjt, 1)
    GUI:Timeline_FadeOut(bg, 2)
end
npc[1004] = function(p2, p3, msgData) -- 查看他人
    cogin.onther_shuju = SL:JsonDecode(msgData,false)
    cogin.onther_zdl = cogin.onther_shuju.zdl
    SL:RequestLookPlayer(""..cogin.onther_shuju.userid, true)
end
npc[1005] = function(p2, p3, msgData) -- 查看他人
    UiTools.playSucAnimation(msgData)
end
npc[9999] = function(p2, p3, msgData) -- 通用关闭
    local parent = GUI:GetWindow(nil, msgData)
    if parent then
        GUI:Win_Close(parent)
    end
end
return npc
