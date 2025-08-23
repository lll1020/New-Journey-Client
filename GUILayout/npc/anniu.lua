local npc = {}

---顶部图标显示
npc.iconpx = {
    {{7, "ttsq",509,1}, {3, "fldt",511,4}, {1, "yxgl",512,10}},
    {{12, "zxcz", 502,9}, {2, "jyh",510,2}}
}
npc.LeftTop = GUI:Attach_LeftTop() -- 左上
npc.RightTop = GUI:Attach_RightTop() -- 右上
npc.RightBottom = GUI:Attach_RightBottom() -- 右下
npc.qiehuan = GUI:Win_FindParent(109)--手机端切换
npc.xinjn = GUI:Win_FindParent(1104)--主界面最顶右下
npc.xinjn32 = GUI:Win_FindParent(1003)--主界面最顶右下
---充值档位
npc.cz_data = {
    fj = {18,38,68,128,288,588,888,1188,1588,1888},
}
npc.db_anniu = {} --按钮
---特殊任务描述
npc.rw = {

}  --任务描述


npc[0] = function(p2, p3, msgData) -- 任务处理
    if p2 == 1 then
        local zysj = SL:JsonDecode(msgData,false)
        local zbz = {}
        if cogin.isWin32 then
            zbz = {-700, -150, 200, -200, -60}
        else
            zbz = {-670, -150, 200, -170, -60}
        end
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
                --if false then
                if (v[2] == "xthl" and not (cogin.sjtb.hqcs and cogin.sjtb.hqcs < 1 and not SL:GetMetaValue("TITLE_DATA_BY_ID", SL:GetMetaValue("ITEM_INDEX_BY_NAME","新服助力")))) or (v[2] == "sclb" and cogin.sjtb.sczt and cogin.sjtb.sczt == 1) or v[2] == sy or
                (v[2] == "mrhy" and not dl_sz(3)) or (v[2] == "tsqb" and ((cogin.sjtb.kqfz and cogin.sjtb.kqfz >= 60) or (cogin.sjtb.sczt and cogin.sjtb.sczt == 1))) or (v[2] == "txzr" and (cogin.sjtb.kqfz and cogin.sjtb.kqfz >= 90)) or (v[2] == "wyzz" and SL:GetMetaValue("TITLE_DATA_BY_ID",SL:GetMetaValue("ITEM_INDEX_BY_NAME","钻石赞助"))) or (v[2] == "kryb" and SL:GetMetaValue("TITLE_DATA_BY_ID",SL:GetMetaValue("ITEM_INDEX_BY_NAME","快人一步")))
                then

                else
                    npc.db_anniu[""..v[4]] = GUI:Button_Create(npc.dbrqs, "anniu_1" .. i, 498 - 80 * zbjs, 0, "res/wy/icon/" .. v[1] .. ".png")
                    GUI:addOnClickEvent(npc.db_anniu[""..v[4]], function()
                        SL:SendLuaNetMsg(101, v[3], 0, 0, "")
                        if GUI:ui_delegate(npc.db_anniu[""..v[4]]).ists then
                            GUI:removeFromParent(GUI:ui_delegate(npc.db_anniu[""..v[4]]).ists)
                        end
                    end)
                    zbjs = zbjs + 1
                end
            end
            zbjs = 1
            for i, v in ipairs(npc.iconpx[2]) do
                --if false then
                if (v[2] == "xthl" and not (cogin.sjtb.hqcs and cogin.sjtb.hqcs < 1 and not SL:GetMetaValue("TITLE_DATA_BY_ID", SL:GetMetaValue("ITEM_INDEX_BY_NAME","新服助力")))) or (v[2] == "sclb" and cogin.sjtb.sczt and cogin.sjtb.sczt == 1) or v[2] == sy or
                        (v[2] == "zzxl" and not dl_sz(3)) or (v[2] == "mrhy" and not dl_sz(3)) or (v[2] == "tsqb" and ((cogin.sjtb.kqfz and cogin.sjtb.kqfz >= 60) or (cogin.sjtb.sczt and cogin.sjtb.sczt == 1))) or (v[2] == "txzr" and (cogin.sjtb.kqfz and cogin.sjtb.kqfz >= 90)) or (v[2] == "wyzz" and SL:GetMetaValue("TITLE_DATA_BY_ID",SL:GetMetaValue("ITEM_INDEX_BY_NAME","钻石赞助"))) or (v[2] == "kryb" and SL:GetMetaValue("TITLE_DATA_BY_ID",SL:GetMetaValue("ITEM_INDEX_BY_NAME","快人一步")))
                then
                else
                    npc.db_anniu[""..v[4]] = GUI:Button_Create(npc.dbrqx, "anniu_2" .. i, 498 - 80 * zbjs, 0, "res/wy/icon/" .. v[1] .. ".png")
                    GUI:addOnClickEvent(npc.db_anniu[""..v[4]], function()
                        SL:SendLuaNetMsg(101, v[3], 0, 0, "")
                        if GUI:ui_delegate(npc.db_anniu[""..v[4]]).ists then
                            GUI:removeFromParent(GUI:ui_delegate(npc.db_anniu[""..v[4]]).ists)
                        end
                    end)
                    if v[2] == "tsqb" then
                        local time = GUI:Text_Create(npc.db_anniu[""..v[4]], "time", 65/2, -7, 14, "#4AE74A", [[]])
                        GUI:setAnchorPoint(time, 0.5, 0.5)
                        GUI:Text_COUNTDOWN(time, (60 - cogin.sjtb.kqfz)*60)
                    end
                    zbjs = zbjs +1
                end
            end
        end
        if p3 == 0 then
            local guaji = {}
            if cogin.isWin32 then
                guaji[1] = GUI:Button_Create(npc.RightBottom, "guaji", -80, 270, "res/wy/icon/base.png")
                local dalucs = GUI:Button_Create(npc.RightBottom, "dalucs", -80, 200, "res/wy/icon/sjdt.png")
                GUI:addOnClickEvent(dalucs, function() 
                    Npclib["anniu"][4](0)
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
            local zbz = {}
            if cogin.isWin32 then
                zbz = {-700, -150, 200, -180, -60}
            else
                zbz = {-670, -150, 200, -160, -60}
            end
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
    elseif p2 == 2 then
        local Layout = GUI:Layout_Create(npc.LeftTop, "zcsxz", 0, -400, 0.00, 150.00, false)


        local sq_jd_dt = GUI:Image_Create(npc.LeftTop, "sq_jd_dt", 0, -450, "res/wy/public/sq_jd_dt.png")
        local jdt_k = GUI:Image_Create(sq_jd_dt, "jdt_k", 65,33, "res/wy/public/sq_jd_jdt_k.png")
        GUI:setAnchorPoint(jdt_k, 0, 0.5)
        GUI:LoadingBar_setPercent(GUI:LoadingBar_Create(jdt_k, "jdt", 0,0,"res/wy/public/sq_jd_jdt.png", 0)
        , 0)
        GUI:Button_Create(sq_jd_dt, "sq_jd_an", 0, 0, "res/wy/public/sq_jd_an.png")
        GUI:setVisible(sq_jd_dt, false)


        local t2 = GUI:Text_Create(Layout, "t2", 25.00, 41.00, 20, "#F7F7DE", "打怪爆率：")
        local t3 = GUI:Text_Create(Layout, "t3", 25.00, 64.00, 20, "#FF0000", "对怪增伤：")
        local t4 = GUI:Text_Create(Layout, "t4", 25.00, 87.00, 20, "#FF7700", "打怪切割：")
        local t5 = GUI:Text_Create(Layout, "t5", 25.00, 110.00, 20, "#39B5EF", "复活状态：")
        GUI:Text_setFontName(t2,"fonts/502.ttf")
        GUI:Text_setFontName(t3,"fonts/502.ttf")
        GUI:Text_setFontName(t4,"fonts/502.ttf")
        GUI:Text_setFontName(t5,"fonts/502.ttf")
        for i = 1,4 do
            GUI:Image_Create(Layout, "tb"..i, 0.00, 113-(i-1)*23, "res/wy/icon/zct_"..i..".png")
        end
        local sx2 = GUI:Text_Create(t2, "txt", 95, 3, 16, "#00ff00", (SL:GetMetaValue("ATT_BY_TYPE", 242)/100).."%")
        local sx3 = GUI:Text_Create(t3, "txt", 95, 3, 16, "#00ff00", (SL:GetMetaValue("ATT_BY_TYPE", 245)/100).."%")
        local sx4 = GUI:Text_Create(t4, "txt", 95, 3, 16, "#00ff00", math.floor(SL:GetMetaValue("ATT_BY_TYPE", 244)*(1 + SL:GetMetaValue("ATT_BY_TYPE", 253)/10000)))
        local fuhuo = GUI:Text_Create(t5, "fuhuo", 95, 3, 16, "#00ff00", "")
        local function shuaxinshuxing(id)
            local rwid = SL:GetMetaValue("MAIN_ACTOR_ID")
            local hb16 = tonumber(SL:GetMetaValue("MONEY",16))
            local hb15 = tonumber(SL:GetMetaValue("MONEY",15))

            local buff = SL:GetMetaValue("ACTOR_BUFF_DATA_BY_ID",rwid,20078)
            if buff then
                GUI:removeAllChildren(fuhuo)
                GUI:Text_COUNTDOWN(GUI:Text_Create(fuhuo, "djs", 30, 0, 14, "#00ff00", "")
                ,buff.endTime - ssr.GetServerTime())
            else
                buff = SL:GetMetaValue("ACTOR_BUFF_DATA_BY_ID",rwid,20060)
                if buff then
                    GUI:removeAllChildren(fuhuo)
                    GUI:Text_COUNTDOWN(GUI:Text_Create(fuhuo, "djs", 30, 0, 14, "#00ff00", "")
                    ,buff.endTime - ssr.GetServerTime())
                end
            end
            GUI:Text_setString(fuhuo, ((SL:GetMetaValue("ACTOR_BUFF_DATA_BY_ID",rwid,20060) and 0 or hb16) + hb15).." 次")
        end
        SL:RegisterLUAEvent(LUA_EVENT_MONEYCHANGE, "货币变化", function(data)
            if data.id == 16 or data.id == 15 then
                shuaxinshuxing(1)
            end
        end)
        SL:RegisterLUAEvent(LUA_EVENT_MAINBUFFUPDATE, "主玩家buff刷新", function(data)
            if data.buffID == 20060 or data.buffID == 20078 then
                if data.type == 0 or data.type == 1 then
                    shuaxinshuxing(1)
                end
            end
        end)
        SL:RegisterLUAEvent(LUA_EVENT_ROLE_PROPERTY_CHANGE, "玩家属性变化时", function()
            GUI:Text_setString(sx2, (SL:GetMetaValue("ATT_BY_TYPE", 242)/100).."%")
            GUI:Text_setString(sx3, (SL:GetMetaValue("ATT_BY_TYPE", 245)/100).."%")
            GUI:Text_setString(sx4, math.floor(SL:GetMetaValue("ATT_BY_TYPE", 244)*(1 + SL:GetMetaValue("ATT_BY_TYPE", 253)/10000)))
        end)
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
                            local s_s_btn = GUI:Image_Create(s_s_list, "s_s_btn"..vv, 0, 0, "res/wy/public/huishou/new_kuang.png")
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
                            if vv == 2 then
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
                                            local s_s_s_btn = GUI:Image_Create(s_s_s_list, "s_s_s_btn"..vvv, 0, 0, "res/wy/public/huishou/new_kuang.png")
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
                                            local s_s_s_btn = GUI:Image_Create(s_s_s_list, "s_s_s_btn"..vvv, 0, 0, "res/wy/public/huishou/new_kuang.png")
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
                    if v == 1 and false then
                    elseif dl_sz(v) or k.name then
                        local btn = GUI:Button_Create(s_list, "wz"..v, 0, 0, "res/wy/public/huishou/new_kuang.png")
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
                        local wz = nil
                        if k.name then
                            wz = GUI:Text_Create(btn, "wz", 77, 17, 17, "#FFFF00", k.name)
                        else
                            wz = GUI:Text_Create(btn, "wz", 77, 17, 17, "#FFFF00", teshudata.sjjt_x[v + 1][4])
                        end
                        GUI:setAnchorPoint(wz, 0.5, 0.5)
                        GUI:Text_enableOutline(wz, "#150800", 2)
                        if npc.s_s == v or true then
                            local s_s_list = GUI:Layout_Create(s_list, "s_s_list"..v, 0, 0, 650, math.floor(#k.l/3) *  45.00, false)

                            for vv,kk in pairs(k.l)  do
                                if not cogin.zskg.zb[kk[3]] then
                                    local s_s_btn = GUI:Image_Create(s_s_list, "s_s_s_btn"..vv, 0, 0, "res/wy/public/huishou/new_kuang.png")
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
                                        --new_hs_update()
                                    end)
                                    local s_s_wz = GUI:RichText_Create(s_s_btn, "s_s_s_wz", 77, 17,  "<a href='jump#item_tips#"..vv.."'>"..kk[3].."</a>", 500, 17, cogin.zskg.zb[kk[3]] and "#FF0000" or "#f7f7de", 3,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})
                                    GUI:setAnchorPoint(s_s_wz, 0.5, 0.5)

                                end
                            end
                            for vv,kk in pairs(k.l)  do
                                if cogin.zskg.zb[kk[3]] then
                                    local s_s_btn = GUI:Image_Create(s_s_list, "s_s_s_btn"..vv, 0, 0, "res/wy/public/huishou/new_kuang.png")
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
                                        --new_hs_update()
                                    end)
                                    local s_s_wz = GUI:RichText_Create(s_s_btn, "s_s_s_wz", 77, 17,  "<a href='jump#item_tips#"..vv.."'>"..kk[3].."</a>", 500, 17, cogin.zskg.zb[kk[3]] and "#FF0000" or "#f7f7de", 3,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})
                                    GUI:setAnchorPoint(s_s_wz, 0.5, 0.5)
                                end
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
            elseif npc.s == 3 then
                local s_list = GUI:ListView_Create(jm_node, "s_list", 225.00, 128.00, 650.00, 340.00, 1)
                GUI:ListView_setItemsMargin(s_list, 10)
                for v,k in pairs(cogin.hs.clfj)  do
                    if v == 1 and false then
                    elseif dl_sz(v) then
                        local btn = GUI:Button_Create(s_list, "wz"..v, 0, 0, "res/wy/public/huishou/new_kuang.png")
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
                                local s_s_btn = GUI:Image_Create(s_s_list, "s_s_s_btn"..vv, 0, 0, "res/wy/public/huishou/new_kuang.png")
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
                    local btn = GUI:Button_Create(s_list, "wz"..v, 0, 0, "res/wy/public/huishou/new_kuang.png")
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
                            local s_s_btn = GUI:Button_Create(s_s_list, "s_s_btn"..vv, 0, 0, "res/wy/public/huishou/new_kuang.png")
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
                                    local s_s_s_btn = GUI:Image_Create(s_s_s_list, "s_s_s_btn"..vvv, 0, 0, "res/wy/public/huishou/new_kuang.png")
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
        if cogin.sjtb.rwid == 4 then
            SL:StartGuide({dir = 1 ,guideWidget = npc.yjcz ,guideParent=npc.bg,guideDesc="点击回收",isForce = false})
        end
        GUI:addOnClickEvent(npc.yjcz, function()
            if npc.s == 1 or  npc.s == 2 or npc.s == 3 or npc.s == 4 then
                local item = SL:GetMetaValue("BAG_DATA")
                local hs = {}
                local huishou_jc_list = cogin.huishou_jc_list
                for k, v in pairs(item) do
                    if huishou_jc_list[v.Index] and (
                            (huishou_jc_list[v.Index].gl == 1 and (shuju.xz["1_"..huishou_jc_list[v.Index][1]] or shuju.xz["1_"..huishou_jc_list[v.Index][1].."_"..huishou_jc_list[v.Index][2]])) or
                                    (huishou_jc_list[v.Index].gl == 2 and shuju.xz["2_"..huishou_jc_list[v.Index][1]]) or
                                    (huishou_jc_list[v.Index].gl == 3 and shuju.xz["3_"..huishou_jc_list[v.Index][1]]) or
                                    (huishou_jc_list[v.Index].gl == 4 and (shuju.xz["4_"..huishou_jc_list[v.Index][1]] or shuju.xz["4_"..huishou_jc_list[v.Index][1].."_"..huishou_jc_list[v.Index][2]])) or
                                    shuju.xz[""..v.Index]) then
                            table.insert(hs, k)
                    end
                end
                if #hs > 0 then
                    SL:SendLuaNetMsg(101, 2, 5, 1, SL:JsonEncode(hs,false))
                    SL:ShowSystemTips("<font color='#00ff00'>一键回收执行完成</font>")
                    if cogin.sjtb.rwid == 4 then
                        SL:CloseBagUI()
                        GUI:Win_Close(parent)
                    end
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
---兑换面板
npc[3] = function(p2, p3, msgData) -- 兑换
    if p2 == 0 then
        local sj = SL:JsonDecode(msgData,false)
        local parent = GUI:GetWindow(nil, "npc_duihuan")
        if parent then
            GUI:removeAllChildren(parent)
        else
            parent = GUI:Win_Create("npc_duihuan",cogin.w/2, cogin.h/2,0,0,false,false,false,true,true,0,1)
        end
        local bjt = GUI:Image_Create(parent, "bjt", 0, 0, "res/public/1900000651_1.png")
		GUI:setAnchorPoint(bjt, 0.5, 0.5)
		GUI:setContentSize(bjt, cogin.w + 100, cogin.h + 100)
		GUI:setTouchEnabled(bjt, true)
		GUI:addOnClickEvent(bjt, function()
			GUI:Win_Close(parent)
		end)
        npc.bg = GUI:Image_Create(parent, "img_bj", 0.00, 0.00, "res/wy/public/duihuan.png")
        GUI:setAnchorPoint(npc.bg, 0.5, 0.5)
        GUI:setTouchEnabled(npc.bg, true)
        GUI:Timeline_Window3(npc.bg)
		local close = GUI:Button_Create(npc.bg, 'close', 630 + 80, 210 + 135, 'res/private/bag_ui/bag_ui_win32/bg_beibao_02.png')
		GUI:addOnClickEvent(close, function()
			GUI:Win_Close(parent)
		end)


        GUI:Image_Create(npc.bg, "duihuan_wz1", 410.00, 135.00, "res/wy/public/duihuan_wz.png")
        GUI:Image_Create(npc.bg, "duihuan_wz2", 410.00, 80.00, "res/wy/public/duihuan_wz.png")
        GUI:Text_Create(npc.bg, "hbdh1", 410.00 + 160, 5+ 135.00, 20, "#ffffff", (10-sj.hbdh1).."次")
        GUI:Text_Create(npc.bg, "hbdh2", 410.00 + 160, 5+ 80.00, 20, "#ffffff", (10-sj.hbdh2).."次")
        local Button1 = GUI:Button_Create(npc.bg, "Button1", 470 + 200, 30+ 150 - 12, "res/wy/public/duihuan_an.png")
        local Button2 = GUI:Button_Create(npc.bg, "Button2", 470 + 200, 30+ 80, "res/wy/public/duihuan_an.png")
		GUI:addOnClickEvent(Button1, function()
            SL:SendLuaNetMsg(101, 1, 1, 0, "")
		end)
		GUI:addOnClickEvent(Button2, function()
            SL:SendLuaNetMsg(101, 1, 2, 0, "")
		end)

        local Button3 = GUI:Button_Create(npc.bg, "Button3", 325, 30+ 150 - 12, "res/wy/public/duihuan_an.png")
        local Button4 = GUI:Button_Create(npc.bg, "Button4", 325, 30+ 80, "res/wy/public/duihuan_an.png")
        GUI:addOnClickEvent(Button3, function()
            SL:SendLuaNetMsg(101, 1, 3, 0, "")
        end)
        GUI:addOnClickEvent(Button4, function()
            SL:SendLuaNetMsg(101, 1, 4, 0, "")
        end)



    elseif p2 == 1 then
        local sj = SL:JsonDecode(msgData,false)
        GUI:Text_setString(GUI:ui_delegate(npc.bg)["hbdh"..p3], (10-sj["hbdh"..p3]).."次")
    end
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


    local effwu = GUI:Frames_Create(parent, "effwu", 0, 0, "res/wy/eff/city/2_", ".png", 1, 15,
            { speed = 50, count = 15, loop = 1, finishhide = false })
    GUI:setContentSize(effwu, cogin.w, cogin.h)
    GUI:setAnchorPoint(effwu, 0.5, 0.5)
    GUI:setScale(effwu,1.5)

    npc.sjdta_idx = npc.sjdta_idx or 1

    local un_list = GUI:ListView_Create(npc.bg, "un_list", 0, 0, cogin.w, 80, 2)
    for v,k in pairs(cogin.teshudata.sjjt_x) do
        if dl_sz(v) then
            local btn = GUI:Button_Create(un_list, 'btn_'..v, 0, 0, "res/wy/public/anniu_4_un_l_"..v..".png")
            --GUI:setAnchorPoint(btn, 0.5, 0.5)
            GUI:addOnClickEvent(btn, function()
                SL:SendLuaNetMsg(100, k[1], 1, 0, "")
                GUI:Win_Close(parent)
            end)
        end
    end

    GUI:setContentSize(GUI:Image_Create(npc.bg, "yun", 0, 0, "res/wy/public/anniu_4_yun.png")
    , cogin.w, cogin.h)






end
---伏妖录任务
npc.xyl = {
    {
        ----任务名,npcid,任务类型（1为主线任务,2为支线任务）,任务检测（1数字型,2数组型,3称号型）,任务结束标志和进度标志,任务传送地点,任务传送限制（{1,10}等级,{2,10}转生,{3,”称号“}所需称号）
    },
    {
        {

        },
        {
            {
                { "进行转职",999,{3,3023}, yd = {1,"剑门外门",166,109,83} ,desc = "<核心/FCOLOR=249>完成二大陆转职\\(<提升核心属性/FCOLOR=250>)" },
                { "横断山脉杀怪",999,{3,3005}, yd = {1,"剑门外门",207,110,88},desc = "在横断山脉击杀15只怪物" },
                { "查看杀怪奖励",999,{4,3006},yd = {2,1,4} ,desc = "点击查看福利大厅中的<杀怪奖励/FCOLOR=250>" },
                { "横断山脉杀怪",999,{3,3007}, yd = {1,"剑门外门",207,110,88} ,desc = "横断山脉击杀5个精英" },
                jl = {hb = {{3,500000,"绑定元宝"},{4,20000,"绑定灵符"}},wp = {{"龙纹铜钱",2},{"1元真实充值",2}}}
            },
            {
                { "勋章升级",2,yz = {15,20006}, yd = {1,"剑门外门",160,99,97} ,desc = "勋章升级到LV5\\(<提升核心属性/FCOLOR=250>)" },
                { "剑魂遗迹杀怪",999,{3,3009}, yd = {1,"剑门外门",208,109,89} ,desc = "剑魂遗迹杀20只小怪" },
                { "剑魂遗迹杀怪",999,{3,3010}, yd = {1,"剑门外门",208,109,89} ,desc = "剑魂遗迹杀5只精英" },
                { "完成白长老的任务",1,yz = {2,"npc26",2},yd = {1,"剑门外门",208,109,89} },
                jl = {hb = {{3,200000,"绑定元宝"},{4,20000,"绑定灵符"}},wp = {{"龙纹铜钱",2},{"1元真实充值",2}}}
            },
            {
                { "修为提升",999,{3,3011}, yd = {3,14} ,desc = "修为提升10次\\(<提升核心属性/FCOLOR=250>)" },
                { "查看除魔天地间",999,{3,3012}, yd = {1,"剑门外门",21,106,78} ,desc = "查看<每日任务/FCOLOR=250>除魔天地间\\(<可以每日领取任务获得材料/FCOLOR=250>)" },
                { "完成李长老的任务",1,yz = {1,"npc27",2}, yd = {1,"剑门外门",209,109,90} },
                { "龙魂吊坠",999,{3,3013},yd = {1,"剑门外门",209,109,90} ,desc = "获得专属龙魂吊坠\\(<了解必爆功能/FCOLOR=249>)" },
                jl = {hb = {{3,200000,"绑定元宝"},{4,20000,"绑定灵符"}},wp = {{"龙纹铜钱",2},{"1元真实充值",2}}}
            },
            {
                { "查看每日副本",999,{3,3014}, yd = {1,"剑门外门",23,109,82} ,desc = "查看<每日/FCOLOR=249>每日副本\\(<可以每日挑战获得材料/FCOLOR=250>)" },
                { "剑鸣深渊杀怪",999,{3,3015}, yd = {1,"剑门外门",210,107,93} ,desc = "剑鸣深渊杀5只精英" },
                { "完成张长老的任务",1,yz = {1,"npc28",2}, yd = {1,"剑门外门",210,107,93} },
                { "王权圣戒",999,{3,3016},yd = {1,"剑门外门",210,107,93} ,desc = "获得专属王权圣戒" },
                jl = {hb = {{3,200000,"绑定元宝"},{4,20000,"绑定灵符"}},wp = {{"龙纹铜钱",2},{"1元真实充值",2}}}
            },
            {
                --{ "仙途豪礼",999,{3,3017}, yd = {2,1,4},desc = "点击查看福利大厅中的<仙途豪礼/FCOLOR=250>" },
                { "诡冥墨河杀怪",999,{3,3018}, yd = {1,"剑门外门",211,105,95} ,desc = "诡冥墨河杀5只精英" },
                { "完成王长老的任务",1,yz = {2,"npc29",2}, yd = {1,"剑门外门",211,105,95} },
                { "烈焰指环",999,{3,3019},yd = {1,"剑门外门",211,105,95} ,desc = "获得专属烈焰指环" },
                jl = {hb = {{3,200000,"绑定元宝"},{4,20000,"绑定灵符"}},wp = {{"龙纹铜钱",2},{"人灵丹",10}}}
            },
            {
                { "合成专属",999,{3,3020}, yd = {1,"剑门外门",175,102,78} ,desc = "<核心/FCOLOR=249>合成专属\\(<合成二大陆顶级专属/FCOLOR=250>)" },
                { "剑冢迷宫杀怪",999,{3,3021}, yd = {1,"剑门外门",212,104,96} ,desc = "剑冢迷宫杀5只精英" },
                { "完成徐长老的任务",1,yz = {1,"npc30",2}, yd = {1,"剑门外门",212,104,96} },
                { "完成转生",999,{3,3022},yd = {1,"剑门外门",54,98,82} ,desc = "<核心/FCOLOR=249>完成二大陆转生\\(<提升核心属性/FCOLOR=250>)" },
                jl = {hb = {{3,200000,"绑定元宝"},{4,20000,"绑定灵符"}},wp = {{"龙纹铜钱",2},{"1元真实充值",2}}}
            },
        },
        {
            { "大陆服饰"},
            { "除魔天地间"},
            { "剑门声望"},
            { "讨伐协修"},
            { "太虚幻境"},
        },
        {
            {"迷惘森林","龙魂吊坠"},
            {"剑鸣深渊","王权圣戒"},
            {"诡冥墨河","烈焰指环"},
        }
    },
    {
        {

        },
        {
            {
                { "提升八门",11, yd = {4,100,187,0,0},desc = "提升八门-惊门等级到10级" },
                { "查看每日活跃",999,{4,3024},yd = {2,1,16} ,desc = "查看<每日/FCOLOR=249>每日活跃\\(<可以每日挑战获得材料/FCOLOR=250>)" },
                { "完成刘长老的任务",1,yz = {1,"npc31",2}, yd = {1,"剑门内门",213,95,131} },
                { "傲孤寒",999,{4,3025}, yd = {1,"剑门内门",213,95,131},desc = "获得专属傲孤寒" },
                jl = {hb = {{3,300000,"绑定元宝"},{4,50000,"绑定灵符"}},wp = {{"龙纹铜钱",2},{"1元真实充值",3}}}
            },
            {
                { "强化斗笠",2,yz = {13,21093}, yd = {1,"剑门内门",159,108,106} ,desc = "强化斗笠到LV5\\(<提升核心属性/FCOLOR=250>)" },
                { "查看太虚幻境",999,{3,3026}, yd = {1,"剑门内门",135,100,112} ,desc = "查看<每日/FCOLOR=249>太虚幻境\\(<可以每日挑战获得核心材料/FCOLOR=249>)" },
                { "完成仙像祭祀",1,yz = {1,"npc42",2}, yd = {1,"虚剑洞天",42,24,39} },
                { "月华流影",999,{3,3027},yd = {1,"剑门内门",214,99,131} ,desc = "获得专属月华流影" },
                jl = {hb = {{3,300000,"绑定元宝"},{4,50000,"绑定灵符"}},wp = {{"龙纹铜钱",2},{"1元真实充值",3},{"技能书页",10}}}
            },
            {
                { "技能强化",999,{3,3028}, yd = {1,"剑门内门",43,103,109} ,desc = "技能强化一次\\(<提升核心属性/FCOLOR=250>)" },
                { "查看宗门禁地",999,{3,3029}, yd = {1,"剑门内门",39,115,117} ,desc = "查看宗门禁地\\(<会产出顶级装备/FCOLOR=250>)" },
                { "完成赤剑试炼",1,yz = {1,"npc530",2}, yd = {1,"赤剑山谷",530,32,42} },
                { "苍穹寂灭",999,{3,3030}, yd = {1,"剑门内门",215,103,131} ,desc = "获得专属苍穹寂灭" },
                jl = {hb = {{3,1500000,"绑定元宝"},{4,300000,"绑定灵符"}},wp = {{"龙纹铜钱",2},{"雕刻符文",10}}}
            },
            {
                { "合成啸风逐电",999,{3,3031}, yd = {1,"剑门外门",175,112,79},desc = "<核心/FCOLOR=249>合成啸风逐电\\(<合成三大陆顶级专属/FCOLOR=250>)" },
                { "装备雕刻",999,{3,3032}, yd = {1,"剑门内门",35,95,121} ,desc = "<核心/FCOLOR=249>装备雕刻一次\\(<提升核心属性/FCOLOR=250>)" },
                { "完成雷剑试炼",1,yz = {2,"npc531",2}, yd = {1,"雷剑神殿",531,70,29} },
                { "烬海残光",999,{3,3033}, yd = {1,"剑门内门",216,107,131} ,desc = "获得专属烬海残光" },
                jl = {hb = {{3,500000,"绑定元宝"},{4,10000,"绑定灵符"}},wp = {{"龙纹铜钱",2},{"1元真实充值",3},{"强化石",1}}}
            },
            {
                { "装备强化",999,{3,3034}, yd = {1,"剑门内门",78,95,127} ,desc = "<核心/FCOLOR=249>装备强化一次\\(<提升核心属性/FCOLOR=250>)" },
                { "奇门八阵",999,{3,3053}, yd = {3,14} ,desc = "查看奇门八阵\\(<有各种强力加成/FCOLOR=250>)" },
                { "查看邪修讨伐",999,{3,3035}, yd = {1,"剑门内门",22,101,109} ,desc = "查看邪修讨伐\\(<可获得大量材料货币/FCOLOR=250>)" },
                --{ "查看剑门地位",999,{3,3036}, yd = {1,"剑门内门",24,108,110} ,desc = "查看剑门地位\\(<提升属性,获得货币材料/FCOLOR=250>)" },
                { "惊雷震世",999,{3,3037},yd = {1,"剑门内门",243,111,131} ,desc = "获得专属惊雷震世" },

                jl = {hb = {{3,500000,"绑定元宝"},{4,10000,"绑定灵符"}},wp = {{"龙纹铜钱",2},{"地灵丹",10}}}
            },
            {
                { "完成三大陆转生",999,{3,3041},yd = {1,"剑门内门",76,95,129},desc = "<核心/FCOLOR=249>完成三大陆转生\\(<提升核心属性/FCOLOR=250>)" },
                { "雪隐残锋",999,{3,3039}, yd = {1,"剑门内门",244,115,131}  ,desc = "获得专属雪隐残锋" },
                { "合成龙鳞镇岳",999,{3,3040}, yd = {1,"剑门外门",175,112,79} ,desc = "<核心/FCOLOR=249>合成龙鳞镇岳\\(<合成三大陆顶级专属/FCOLOR=250>)" },
                { "英灵哀殿杀怪",999,{3,3038}, yd = {1,"剑门内门",244,115,131} ,desc = "英灵哀殿杀1只BOSS" },
                jl = {hb = {{3,300000,"绑定元宝"},{4,50000,"绑定灵符"}},wp = {{"龙纹铜钱",2},{"1元真实充值",3}}}
            },
        },
        {
            { "大陆服饰"},
            { "除魔天地间"},
            { "剑门声望"},
            { "讨伐协修"},
            { "太虚幻境"},
        },
        {
            {"灵剑之道","傲霜孤"},
            {"虚剑洞天","月华流影"},
            {"赤剑山谷","苍穹寂灭"},
            {"雷剑神殿","烬海残光"},
            {"云崖绝壁","惊雷震世"},
            {"英灵哀殿","雪隐残锋"},
        }
    },
    {
        {

        },
        {
            {
                { "盾牌强化",2,yz = {16,20111}, yd = {1,"中州城",158,648,178},jl = {wp = {{"1元真实充值",1}} } ,desc = "盾牌强化至LV10\\(<提升核心属性/FCOLOR=250>)" },
                { "猎魔前线-救治灵树",1,yz = {2,"npc401",2},yd = {1,"猎魔前线",401,33,27},jl = {wp = {{"1元真实充值",1}} } },
                { "猎魔前线-三相之力",1,yz = {2,"npc402",2},yd = {1,"血戮荒原",402,323,153},jl = {wp = {{"1元真实充值",1}} } },
                { "猎魔前线-祭拜苍天",1,yz = {2,"npc403",2},yd = {1,"魔息战场",403,117,26},jl = {wp = {{"1元真实充值",1}} } },
                { "猎魔前线-除魔问道",1,yz = {2,"npc404",2},yd = {1,"暗影哨所",404,252,67},jl = {wp = {{"1元真实充值",1}} } },
                jl = {hb = {{3,500000,"绑定元宝"},{4,50000,"绑定灵符"}},wp = {{"龙纹铜钱",3},{"1元真实充值",4}}}
            },
            {
                { "职业觉醒",3, yd = {1,"中州城",176,654,178},jl = {wp = {{"1元真实充值",1}} } ,desc = "完成职业一觉\\(<激活觉醒技能/FCOLOR=250>)" },
                { "上古丛林-全是好物",1,yz = {1,"npc407",2},yd = {1,"上古丛林",407,69,170},jl = {wp = {{"1元真实充值",1}} } },
                { "上古丛林-酒鬼老王",1,yz = {1,"npc408",2},yd = {1,"迷踪秘径",408,152,29},jl = {wp = {{"1元真实充值",1}} } },
                { "上古丛林-吉祥三宝",1,yz = {1,"npc409",2},yd = {1,"藤蔓荒谷",409,118,45},jl = {wp = {{"1元真实充值",1}} } },
                { "上古丛林-上古剑诀",1,yz = {1,"npc410",2},yd = {1,"古木幽庭",410,167,133},jl = {wp = {{"1元真实充值",1}} } },
                jl = {hb = {{3,500000,"绑定元宝"},{4,50000,"绑定灵符"}},wp = {{"开光符",10},{"1元真实充值",4}}}
            },
            {
                { "专属开光",999,{3,3043}, yd = {1,"中州城",183,652,175},jl = {wp = {{"1元真实充值",1}} } ,desc = "查看专属开光\\(<核心玩法，大幅提升属性/FCOLOR=250>)" },
                { "灵气矿场-矿场密宝",1,yz = {1,"npc413",2},yd = {1,"灵气矿场",413,277,27},jl = {wp = {{"1元真实充值",1}} } },
                { "灵气矿场-挖矿达人",1,yz = {1,"npc414",2},yd = {1,"晶尘之路",414,23,259},jl = {wp = {{"1元真实充值",1}} } },
                { "灵气矿场-协助老朽",1,yz = {1,"npc415",2},yd = {1,"灵岩矿井",415,280,55},jl = {wp = {{"1元真实充值",1}} } },
                { "灵气矿场-灵气起源",1,yz = {2,"npc416",2},yd = {1,"涌泉之脉",416,23,268},jl = {wp = {{"1元真实充值",1}} } },
                jl = {hb = {{3,500000,"绑定元宝"},{4,50000,"绑定灵符"}},wp = {{"龙纹铜钱",3},{"1元真实充值",4}}}
            },
            {
                { "中州城势力",999,{3,3044}, yd = {1,"中州城",45,652,175},jl = {wp = {{"1元真实充值",1}} } ,desc = "查看中州城传送阵\\(<加入中州城任意势力/FCOLOR=250>)" },
                { "不朽领域-不朽秘宝",1,yz = {1,"npc419",2},yd = {1,"不朽领域",419,35,352},jl = {wp = {{"1元真实充值",1}} } },
                { "不朽领域-老僧的烦恼",1,yz = {1,"npc420",2},yd = {1,"永生之塔",420,66,322},jl = {wp = {{"1元真实充值",1}} } },
                { "不朽领域-不玩虚的",1,yz = {2,"npc421",2},yd = {1,"不灭神坛",421,16,316},jl = {wp = {{"1元真实充值",1}} } },
                { "不朽领域-神秘宝箱",1,yz = {1,"npc422",2},yd = {1,"轮回圣殿",422,276,35},jl = {wp = {{"1元真实充值",1}} } },
                jl = {hb = {{3,500000,"绑定元宝"},{4,50000,"绑定灵符"}},wp = {{"龙纹铜钱",3},{"1元真实充值",4}}}
            },
            {
                { "勋章强化",2,yz = {15,20011}, yd = {4,100,160,0,0},jl = {wp = {{"1元真实充值",1}} } ,desc = "徽章强化至LV10\\(<提升核心属性/FCOLOR=250>)" },
                { "诡秘深渊-交个朋友",1,yz = {1,"npc425",2},yd = {1,"诡秘深渊",425,45,141},jl = {wp = {{"1元真实充值",1}} } },
                { "诡秘深渊-智慧之神",1,yz = {2,"npc426",2},yd = {1,"幽影峡谷",426,101,280},jl = {wp = {{"1元真实充值",1}} } },
                { "诡秘深渊-欢度元宵",1,yz = {2,"npc427",2},yd = {1,"邪魂之渊",427,185,200},jl = {wp = {{"1元真实充值",1}} } },
                { "诡秘深渊-上古恶魔",1,yz = {2,"npc428",2},yd = {1,"深渊幽宫",428,19,239},jl = {wp = {{"1元真实充值",1}} } },
                jl = {hb = {{3,500000,"绑定元宝"},{4,50000,"绑定灵符"}},wp = {{"龙纹铜钱",3},{"1元真实充值",4}}}
            },
            {
                { "完成四大陆转生",12,{4},yd = {1,"中州城",124,644,192},jl = {wp = {{"1元真实充值",1}} },desc = "<核心/FCOLOR=249>完成四大陆转生\\(<提升核心属性/FCOLOR=250>)" },
                { "北辰山脉-北辰秘宝",1,yz = {1,"npc431",2},yd = {1,"北辰山脉",431,441,220},jl = {wp = {{"1元真实充值",1}} } },
                { "北辰山脉-救济老朽",1,yz = {1,"npc432",2},yd = {1,"霜风雪岭",432,35,222},jl = {wp = {{"1元真实充值",1}} } },
                { "北辰山脉-神秘高人",1,yz = {1,"npc433",2},yd = {1,"极寒冰崖",433,233,38},jl = {wp = {{"1元真实充值",1}} } },
                { "北辰山脉-我摇人了",1,yz = {2,"npc434",2},yd = {1,"天霄之径",434,218,30},jl = {wp = {{"1元真实充值",1}} } },
                jl = {hb = {{3,500000,"绑定元宝"},{4,50000,"绑定灵符"}},wp = {{"龙纹铜钱",3},{"1元真实充值",4}}}
            },
        },
        {
            { "大陆服饰"},
            { "登神长阶"},
        },
        {
            {"猎魔前线","雷霆幻"},
            {"上古丛林","永恒星辰"},
            {"灵气矿场","霜雪之间"},
            {"不朽领域","烈焰焚天"},
            {"诡秘深渊","天罚雷击"},
            {"北辰山脉","炽焰灰烬"},
            {"轮回圣殿","深渊游行"},
            {"深渊幽宫","龙骨战魂"},
            {"天霄之径","寒鸦"},

        },
        {
            {"血戮荒原","阿修罗之眼"},
            {"迷踪秘径","扶摇上青天"},
            {"晶尘之路","桃李满天下"},
            {"永生之塔","狂风起苍穹"},
            {"幽影峡谷","霸天震九州"},
            {"霜风雪岭","狂风之力"},
            {"魔息战场","飞龙在天"},
            {"藤蔓荒谷","霸者傲天下"},
            {"灵岩矿井","死亡彗星"},
            {"不灭神坛","傲骨豪"},
            {"邪魂之渊","破天魂"},
            {"极寒冰崖","地狱火"},

        }
    },
    {
        {

        },
        {

            {
                { "群切强化",4,yd = {1,"天玄界",58,42,38},jl = {wp = {{"1元真实充值",1}} },desc = "<核心/FCOLOR=249>激活群切强化\\(<大幅提高打怪速度/FCOLOR=250>)" },
                { "幽冥邪宗-幽冥至宝",1,yz = {1,"npc437",2},yd = {1,"幽冥邪宗",437,34,39},jl = {wp = {{"1元真实充值",1}} } },
                { "幽冥邪宗-磨刀向恶魔",1,yz = {2,"npc438",2},yd = {1,"血池溅月",438,172,172},jl = {wp = {{"1元真实充值",1}} } },
                { "幽冥邪宗-血洗邪宗",1,yz = {2,"npc439",2},yd = {1,"邪影噬魂坛",439,24,91},jl = {wp = {{"1元真实充值",1}} } },
                { "幽冥邪宗-斩草除根",1,yz = {2,"npc440",2},yd = {1,"千目凝视之谷",440,23,89},jl = {wp = {{"1元真实充值",1}} } },
                jl = {hb = {{3,1000000,"绑定元宝"},{4,100000,"绑定灵符"}},wp = {{"龙纹铜钱",4},{"1元真实充值",5}}}
            },
            {
                { "根基洗炼",999,{3,3045}, yd = {1,"天玄界",57,51,38},jl = {wp = {{"1元真实充值",1}} } ,desc = "查看根基洗炼\\(<每日可以免费洗炼一次/FCOLOR=250>)" },
                { "边境之城-边境至宝",1,yz = {1,"npc442",2},yd = {1,"边境之城",442,37,67},jl = {wp = {{"1元真实充值",1}} } },
                { "边境之城-边境试炼",1,yz = {2,"npc443",2},yd = {1,"狼烟起",443,31,33},jl = {wp = {{"1元真实充值",1}} } },
                { "边境之城-寻宝神潭",1,yz = {2,"npc444",2},yd = {1,"孤军守残垒",444,33,179},jl = {wp = {{"1元真实充值",1}} } },
                { "边境之城-边境大使",1,yz = {1,"npc445",2},yd = {1,"铁壁营寨烽火天",445,16,141},jl = {wp = {{"1元真实充值",1}} } },
                jl = {hb = {{3,1000000,"绑定元宝"},{4,100000,"绑定灵符"}},wp = {{"龙纹铜钱",4},{"1元真实充值",5}}}
            },
            {
                { "职业升级",5,yd = {1,"天玄界",168,54,38},jl = {wp = {{"1元真实充值",1}} },desc = "<核心/FCOLOR=249>职业强化至LV100\\(<提升职业属性/FCOLOR=250>)" },
                { "无尽深渊-深渊夺宝",1,yz = {1,"npc447",2},yd = {1,"无尽深渊",447,84,111},jl = {wp = {{"1元真实充值",1}} } },
                { "无尽深渊-无尽神道",1,yz = {2,"npc448",2},yd = {1,"黑渊幽径",448,94,73},jl = {wp = {{"1元真实充值",1}} } },
                { "无尽深渊-深渊谜题",1,yz = {2,"npc449",2},yd = {1,"深海无声谷",449,85,37},jl = {wp = {{"1元真实充值",1}} } },
                { "无尽深渊-收集魔气",1,yz = {1,"npc450",2},yd = {1,"血肉风暴裂魂隙",450,93,97},jl = {wp = {{"1元真实充值",1}} } },
                jl = {hb = {{3,1000000,"绑定元宝"},{4,100000,"绑定灵符"}},wp = {{"觉醒书页",5},{"1元真实充值",5}}}
            },
            {
                { "仙府遗迹-仙府宝藏",1,yz = {1,"npc452",2},yd = {1,"仙府遗迹",452,121,122},jl = {wp = {{"1元真实充值",1}} } },
                { "仙府遗迹-光暗双生",1,yz = {2,"npc453",2},yd = {1,"仙池碧玉",453,208,208},jl = {wp = {{"1元真实充值",1}} } },
                { "仙府遗迹-无边业火",1,yz = {2,"npc454",2},yd = {1,"莲灯未冷时",454,217,227},jl = {wp = {{"1元真实充值",1}} } },
                { "仙府遗迹-控火导师",1,yz = {2,"npc455",2},yd = {1,"星陨回响天幕影",455,230,198},jl = {wp = {{"1元真实充值",1}} } },
                jl = {hb = {{3,1000000,"绑定元宝"},{4,100000,"绑定灵符"}},wp = {{"龙纹铜钱",4},{"1元真实充值",5}}}
            },
            {
                { "盾牌强化",2,yz = {16,20141}, yd = {1,"中州城",158,648,178},jl = {wp = {{"1元真实充值",1}} } ,desc = "盾牌强化至LV40\\(<提升核心属性/FCOLOR=250>)" },
                { "副装系统",999,{3,3054}, yd = {1,"天玄界",185,40,38},jl = {wp = {{"1元真实充值",1}} } ,desc = "核心玩法\\副装和转职的结合" },
                { "天妖山脉-天妖夺宝",1,yz = {1,"npc457",2},yd = {1,"天妖山脉",457,301,330},jl = {wp = {{"1元真实充值",1}} } },
                { "天妖山脉-天妖试炼",1,yz = {2,"npc458",2},yd = {1,"狂啸绝壁",458,35,35},jl = {wp = {{"1元真实充值",1}} } },
                { "天妖山脉-五行混沌体",1,yz = {2,"npc459",2},yd = {1,"血兽战吼山巅",459,51,368},jl = {wp = {{"1元真实充值",1}} } },
                { "天妖山脉-修行之路",1,yz = {1,"npc460",2},yd = {1,"妖骨盘涡毒息林",460,130,283},jl = {wp = {{"1元真实充值",1}} } },
                jl = {hb = {{3,1000000,"绑定元宝"},{4,100000,"绑定灵符"}},wp = {{"副装箱子",10},{"1元真实充值",5}}}
            },
            {
                { "完成五大陆转生",12,{5},yd = {1,"天玄界",143,39,45},jl = {wp = {{"1元真实充值",1}} },desc = "<核心/FCOLOR=249>完成五大陆转生\\(<提升核心属性/FCOLOR=250>)" },
                { "圣墟秘境-圣虚秘宝",1,yz = {1,"npc462",2},yd = {1,"圣墟秘境",462,30,28},jl = {wp = {{"1元真实充值",1}} } },
                { "圣墟秘境-神之恩赐",1,yz = {2,"npc463",2},yd = {1,"圣者归途",463,30,32},jl = {wp = {{"1元真实充值",1}} } },
                { "圣墟秘境-圣虚之主",1,yz = {2,"npc464",2},yd = {1,"光焰引路泉影照",464,251,272},jl = {wp = {{"1元真实充值",1}} } },
                { "圣墟秘境-兵神天狼",1,yz = {1,"npc465",2},yd = {1,"黄金遗冢",465,22,77},jl = {wp = {{"1元真实充值",1}} } },
                jl = {hb = {{3,1000000,"绑定元宝"},{4,100000,"绑定灵符"}},wp = {{"龙纹铜钱",4},{"1元真实充值",5}}}
            },
        },
        {

        },
        {
            {"幽冥邪宗","无尘"},
            {"边境之城","逐浪"},
            {"无尽深渊","追云"},
            {"仙府遗迹","苍狼"},
            {"天妖山脉","孤鸿"},
            {"圣墟秘境","焚息"},
            {"千目凝视之谷","归墟"},
            {"铁壁营寨烽火天","映月"},
            {"血肉风暴裂魂隙","霜魄"},
            {"星陨回响天幕影","风吟"},
            {"妖骨盘涡毒息林","墨影"},
            {"黄金遗冢","锁鳞"},
        },
        {
            {"血池溅月","霜之哀伤"},
            {"狼烟起","熱翔"},
            {"黑渊幽径","致命节奏"},
            {"仙池碧玉","玄武震天尊"},
            {"狂啸绝壁","无情铁御"},
            {"圣者归途","褪色者"},
            {"邪影噬魂坛","七日杀"},
            {"孤军守残垒","长生"},
            {"深海无声谷","狱門疆"},
            {"莲灯未冷时","伏魔御厨子"},
            {"血兽战吼山巅","嵌合暗翳庭"},
            {"光焰引路泉影照","诛伏赐死"},

        }
    },
    {
        {

        },
        {
            {
                { "迷城幻境-迷城秘宝",1,yz = {1,"npc467",2},yd = {1,"迷城幻境",467,62,66},jl = {wp = {{"1元真实充值",1}} } },
                { "迷城幻境-破妄之瞳",1,yz = {1,"npc468",2},yd = {1,"影火幽街",468,170,160},jl = {wp = {{"1元真实充值",1}} } },
                { "迷城幻境-迷城雾鬼",1,yz = {2,"npc469",2},yd = {1,"虚实难辨馆中影",469,140,174},jl = {wp = {{"1元真实充值",1}} } },
                { "迷城幻境-肉就完了",1,yz = {1,"npc470",2},yd = {1,"星屑回廊",470,67,219},jl = {wp = {{"1元真实充值",1}} } },
                jl = {hb = {{3,1500000,"绑定元宝"},{4,150000,"绑定灵符"}},wp = {{"龙纹铜钱",5},{"1元真实充值",6}}}
            },
            {
                { "隐仙居",7,yz = {0,"仙气之体"},yd = {1,"北境仙域",102,44,37},jl = {wp = {{"1元真实充值",1}} },desc = "在隐仙居中完成仙气转换\\(<将灵气转换为仙气/FCOLOR=250>)" },
                { "战歌要塞-要塞寻宝",1,yz = {1,"npc472",2},yd = {1,"战歌要塞",472,103,29},jl = {wp = {{"1元真实充值",1}} } },
                { "战歌要塞-战歌试炼",1,yz = {2,"npc473",2},yd = {1,"战鼓不息",473,28,186},jl = {wp = {{"1元真实充值",1}} } },
                { "战歌要塞-灵星起源",1,yz = {2,"npc474",2},yd = {1,"铁狮门楼风中望",474,14,30},jl = {wp = {{"1元真实充值",1}} } },
                { "战歌要塞-复仇的怒火",1,yz = {2,"npc475",2},yd = {1,"赤焰兵坊",475,209,228},jl = {wp = {{"1元真实充值",1}} } },
                jl = {hb = {{3,1500000,"绑定元宝"},{4,150000,"绑定灵符"}},wp = {{"龙纹铜钱",5},{"1元真实充值",6}}}
            },
            {
                { "斗笠强化",2,yz = {13,21108}, yd = {4,100,159,0,0},jl = {wp = {{"1元真实充值",1}} } ,desc = "斗笠强化至LV20\\(<提升核心属性/FCOLOR=250>)" },
                { "荒古战场-战场寻宝",1,yz = {1,"npc477",2},yd = {1,"荒古战场",477,249,22},jl = {wp = {{"1元真实充值",1}} } },
                { "荒古战场-荒古夺魁",1,yz = {2,"npc478",2},yd = {1,"血腥废墟",478,165,198},jl = {wp = {{"1元真实充值",1}} } },
                { "荒古战场-战场杀神",1,yz = {2,"npc479",2},yd = {1,"废土遗址",479,165,199},jl = {wp = {{"1元真实充值",1}} } },
                { "荒古战场-荒古战神令",1,yz = {1,"npc480",2},yd = {1,"英雄遗墟",480,356,341},jl = {wp = {{"1元真实充值",1}} } },
                jl = {hb = {{3,1500000,"绑定元宝"},{4,150000,"绑定灵符"}},wp = {{"龙纹铜钱",5},{"1元真实充值",6}}}
            },
            {
                { "护体罡气",7,yz = {0,"护体罡气"}, yd = {1,"北境仙域",79,47,37},jl = {wp = {{"1元真实充值",1}} } ,desc = "护体罡气强化至LV20\\(<提升核心属性/FCOLOR=250>)" },
                { "魁族蛮荒-蛮荒寻宝",1,yz = {1,"npc483",2},yd = {1,"魁族蛮荒",483,42,58},jl = {wp = {{"1元真实充值",1}} } },
                { "魁族蛮荒-平定蛮荒",1,yz = {2,"npc484",2},yd = {1,"蛮骨平原",484,25,91},jl = {wp = {{"1元真实充值",1}} } },
                { "魁族蛮荒-攻魔道",1,yz = {2,"npc485",2},yd = {1,"血牙山脉",485,38,141},jl = {wp = {{"1元真实充值",1}} } },
                { "魁族蛮荒-魁族谜题",1,yz = {2,"npc486",2},yd = {1,"荒灵沼泽",486,34,257},jl = {wp = {{"1元真实充值",1}} } },
                jl = {hb = {{3,1500000,"绑定元宝"},{4,150000,"绑定灵符"}},wp = {{"龙纹铜钱",5},{"1元真实充值",6}}}
            },
            {
                { "职业二觉",999,{3,3047}, yd = {1,"北境仙域",177,51,37},jl = {wp = {{"1元真实充值",1}} } ,desc = "职业二觉\\(<可以习得新的职业技能/FCOLOR=250>)" },
                { "苍穹之域-苍穹寻宝",1,yz = {1,"npc489",2},yd = {1,"苍穹之域",489,51,45},jl = {wp = {{"1元真实充值",1}} } },
                { "苍穹之域-苍穹神树",1,yz = {2,"npc490",2},yd = {1,"云阙天宫",490,48,357},jl = {wp = {{"1元真实充值",1}} } },
                { "苍穹之域-美味的菜肴",1,yz = {1,"npc491",2},yd = {1,"星轮天池",491,52,359},jl = {wp = {{"1元真实充值",1}} } },
                { "苍穹之域-苍穹水晶",1,yz = {2,"npc492",2},yd = {1,"玄霄浮岛",492,26,39},jl = {wp = {{"1元真实充值",1}} } },
                jl = {hb = {{3,1500000,"绑定元宝"},{4,150000,"绑定灵符"}},wp = {{"龙纹铜钱",5},{"1元真实充值",6}}}
            },
            {
                { "仙道赐福",7,yz = {0,"仙道赐福"}, yd = {1,"北境仙域",110,63,49},jl = {wp = {{"1元真实充值",1}} } ,desc = "进行50次仙道赐福\\(<获得大量材料和稀有奖励/FCOLOR=250>)" },
                { "混沌荒原-荒原寻宝",1,yz = {1,"npc495",2},yd = {1,"混沌荒原",495,132,60},jl = {wp = {{"1元真实充值",1}} } },
                { "混沌荒原-混沌真龙",1,yz = {1,"npc496",2},yd = {1,"破界荒墟",496,232,254},jl = {wp = {{"1元真实充值",1}} } },
                { "混沌荒原-复仇的怒火",1,yz = {2,"npc497",2},yd = {1,"湮灵断层",497,269,123},jl = {wp = {{"1元真实充值",1}} } },
                { "混沌荒原-不死金刚",1,yz = {1,"npc498",2},yd = {1,"裂魂战渊",498,236,252},jl = {wp = {{"1元真实充值",1}} } },
                jl = {hb = {{3,1500000,"绑定元宝"},{4,150000,"绑定灵符"}},wp = {{"龙纹铜钱",5},{"1元真实充值",6}}}
            },
        },
        {},
        {
            {"迷城幻境","破晓"},
            {"战歌要塞","潜锋"},
            {"荒古战场","飞霞"},
            {"魁族蛮荒","雷渊"},
            {"苍穹之域","玄冥"},
            {"混沌荒原","月痕"},
            {"虚实难辨馆中影","青衿"},
            {"铁狮门楼风中望","风绝"},
            {"废土遗址","烛阴"},
            {"血牙山脉","流岚"},
            {"星轮天池","云渡履"},
            {"湮灵断层","伏龙束"},
        },
        {
            {"影火幽街","暴怒の罪"},
            {"战鼓不息","色欲の罪"},
            {"血腥废墟","贪婪の罪"},
            {"蛮骨平原","傲慢の罪"},
            {"云阙天宫","暴食の罪"},
            {"破界荒墟","嫉妒の罪"},
            {"星屑回廊","怠惰の罪"},
            {"赤焰兵坊","自闭圆顿裹"},
            {"英雄遗墟","轮回之力"},
            {"荒灵沼泽","风王之瞳"},
            {"玄霄浮岛","君焰"},
            {"裂魂战渊","王权"},

        }
    },
    {
        {

        },
        {
            {
                { "切割之斧",2,yz = {12,20400}, yd = {4,100,41,0,0},jl = {wp = {{"1元真实充值",1}} } ,desc = "切割之斧强化至LV35\\(<提升核心属性/FCOLOR=250>)" },
                { "赤焰火洲-赤焰宝藏",1,yz = {1,"npc500",2},yd = {1,"赤焰火洲",500,277,281},jl = {wp = {{"1元真实充值",1}} } },
                { "赤焰火洲-炽焰之力",1,yz = {2,"npc501",2},yd = {1,"炎心古原",501,239,259},jl = {wp = {{"1元真实充值",1}} } },
                { "赤焰火洲-火焰之花",1,yz = {1,"npc502",2},yd = {1,"焰火炼狱",502,25,22},jl = {wp = {{"1元真实充值",1}} } },
                { "赤焰火洲-我全都要",1,yz = {2,"npc503",2},yd = {1,"燎原赤林",503,70,71},jl = {wp = {{"1元真实充值",1}} } },
                jl = {hb = {{3,2000000,"绑定元宝"},{4,200000,"绑定灵符"}},wp = {{"龙纹铜钱",10},{"1元真实充值",10}}}
            },
            {
                { "职业觉醒",8,yd = {1,"中央仙域",178,18,17},jl = {wp = {{"1元真实充值",1}} },desc = "<核心/FCOLOR=249>完成职业三觉\\(<激活三觉技能/FCOLOR=250>)" },
                { "海蓝天岛-天岛宝藏",1,yz = {1,"npc505",2},yd = {1,"海蓝天岛",505,87,61},jl = {wp = {{"1元真实充值",1}} } },
                { "海蓝天岛-阴阳双生",1,yz = {1,"npc506",2},yd = {1,"澜光浅湾",506,74,85},jl = {wp = {{"1元真实充值",1}} } },
                { "海蓝天岛-踏碎山河",1,yz = {2,"npc507",2},yd = {1,"云汐悬崖",507,91,189},jl = {wp = {{"1元真实充值",1}} } },
                { "海蓝天岛-突出重围",1,yz = {2,"npc508",2},yd = {1,"天镜湖心",508,93,300},jl = {wp = {{"1元真实充值",1}} } },
                jl = {hb = {{3,2000000,"绑定元宝"},{4,200000,"绑定灵符"}},wp = {{"龙纹铜钱",10},{"1元真实充值",10}}}
            },
            {
                { "群切强化",9,yd = {4,100,58,0,0},jl = {wp = {{"1元真实充值",1}} },desc = "<核心/FCOLOR=249>群切强化至LV20\\(<大幅提高打怪速度/FCOLOR=250>)" },
                { "禁忌之森-禁忌宝藏",1,yz = {1,"npc511",2},yd = {1,"禁忌之森",511,277,125},jl = {wp = {{"1元真实充值",1}} } },
                { "禁忌之森-百转轮回",1,yz = {2,"npc512",2},yd = {1,"幽藤迷径",512,212,195},jl = {wp = {{"1元真实充值",1}} } },
                --{ "禁忌之森-藏宝图",1,yz = {2,"npc513",2},yd = {1,"幽冥沼泽",513,39,92},jl = {wp = {{"1元真实充值",1}} } },
                { "禁忌之森-一剑开天",1,yz = {1,"npc514",2},yd = {1,"暗影秘境",514,209,216},jl = {wp = {{"1元真实充值",1}} } },
                jl = {hb = {{3,2000000,"绑定元宝"},{4,200000,"绑定灵符"}},wp = {{"龙纹铜钱",10},{"1元真实充值",10}}}
            },
            {
                { "盾牌强化",2,yz = {16,20121}, yd = {4,100,158,0,0},jl = {wp = {{"1元真实充值",1}} } ,desc = "盾牌强化至LV20\\(<提升核心属性/FCOLOR=250>)" },
                { "鬼嚎深渊-深渊寻宝",1,yz = {1,"npc517",2},yd = {1,"鬼嚎深渊",517,346,164},jl = {wp = {{"1元真实充值",1}} } },
                { "鬼嚎深渊-打碎枷锁",1,yz = {2,"npc518",2},yd = {1,"哀魂断口",518,302,37},jl = {wp = {{"1元真实充值",1}} } },
                { "鬼嚎深渊-荣誉之战",1,yz = {2,"npc519",2},yd = {1,"魍魉幽道",519,373,72},jl = {wp = {{"1元真实充值",1}} } },
                { "鬼嚎深渊-无极老人",1,yz = {2,"npc520",2},yd = {1,"死域祭坛",520,100,276},jl = {wp = {{"1元真实充值",1}} } },
                jl = {hb = {{3,2000000,"绑定元宝"},{4,200000,"绑定灵符"}},wp = {{"龙纹铜钱",10},{"1元真实充值",10}}}
            },
            {
                { "仙气萃取",999,{3,3049}, yd = {1,"中央仙域",170,21,17},jl = {wp = {{"1元真实充值",1}} } ,desc = "查看仙气萃取\\(<可以兑换仙气/FCOLOR=250>)" },

                { "无相领域-无相宝藏",1,yz = {1,"npc523",2},yd = {1,"无相领域",523,256,35},jl = {wp = {{"1元真实充值",1}} } },
                { "无相领域-祭拜苍天",1,yz = {2,"npc524",2},yd = {1,"虚轮镜界",524,273,245},jl = {wp = {{"1元真实充值",1}} } },
                { "无相领域-黄鹤归去",1,yz = {2,"npc525",2},yd = {1,"虚幻迷宫",525,264,251},jl = {wp = {{"1元真实充值",1}} } },
                { "无相领域-一诺千金",1,yz = {2,"npc526",2},yd = {1,"意识荒原",526,279,20},jl = {wp = {{"1元真实充值",1}} } },
                jl = {hb = {{3,2000000,"绑定元宝"},{4,200000,"绑定灵符"}},wp = {{"龙纹铜钱",10},{"1元真实充值",10}}}
            },
            {
                { "完成七大陆转生",12,{7},yd = {1,"中央仙域",162,19,22},jl = {wp = {{"1元真实充值",1}} },desc = "<核心/FCOLOR=249>完成七大陆转生\\(<提升核心属性/FCOLOR=250>)" },

                { "诡异裂缝-神魔惧我",1,yz = {1,"npc529",30},yd = {1,"诡异裂缝",529,122,58},jl = {wp = {{"1元真实充值",1}} } },
                { "诡异裂缝-夺命诡气",1,yz = {1,"npc527",2},yd = {1,"灵觉浮域",527,259,35},jl = {wp = {{"1元真实充值",1}} } },
                { "诡异裂缝-诡异之主",1,yz = {2,"npc528",2},yd = {1,"无名之殿",528,206,196},jl = {wp = {{"1元真实充值",1}} } },
                { "诡异裂缝-猩红之主",1,yz = {2,"npc522",2},yd = {1,"血腥深渊",522,79,177},jl = {wp = {{"1元真实充值",1}} } },
                jl = {hb = {{3,2000000,"绑定元宝"},{4,200000,"绑定灵符"}},wp = {{"龙纹铜钱",10},{"1元真实充值",10}}}
            },
        },
        {},
        {

            {"赤焰火洲","夜魇天冕"},
            {"海蓝天岛","流光仙索"},
            {"禁忌之森","断情遗世"},
            {"鬼嚎深渊","浮生梦痕"},
            {"无相领域","鸿蒙初启"},
            {"诡异裂缝","青冥幻影"},
            {"焰火炼狱","玄羽乘风"},
            {"云汐悬崖","锁天紫绦"},
            {"幽冥沼泽","裂星玄盔"},
            {"魍魉幽道","曜天灵珑"},
            {"虚幻迷宫","风云浩劫"},
            {"无名之殿","寂灭苍穹"},
        },
        {
            {"炎心古原","*归墟*"},
            {"澜光浅湾","湿婆业舞"},
            {"幽藤迷径","血系结罗"},
            {"哀魂断口","不朽"},
            {"虚轮镜界","黑日"},
            {"灵觉浮域","黑炎牢狱"},
            {"燎原赤林","血の恩赐"},
            {"天镜湖心","尼德霍格"},
            {"暗影秘境","耶梦加得"},
            {"死域祭坛","旧日支配者"},
            {"意识荒原","流明"},
            {"血腥深渊","死之藤蔓"},

        }
    },
    {
        {

        },
        {
            {
                { "魂卡激活",999,{3,3051}, yd = {1,"诡异位面",153,59,57},jl = {wp = {{"1元真实充值",1}} } ,desc = "查看魂卡激活\\(<boss魂卡激活/FCOLOR=250>)" },

                { "夜哭寒泉-猩红之月",1,yz = {1,"npc521",2},yd = {1,"夜哭寒泉",521,203,201},jl = {wp = {{"1元真实充值",1}} } },
                { "夜哭寒泉-女娲的试炼",1,yz = {2,"npc515",2},yd = {1,"死亡古洞",515,87,323},jl = {wp = {{"1元真实充值",1}} } },
                { "夜哭寒泉-禁忌之主",1,yz = {2,"npc516",2},yd = {1,"月光禁地",516,37,39},jl = {wp = {{"1元真实充值",1}} } },
                { "夜哭寒泉-海蓝之主",1,yz = {2,"npc510",2},yd = {1,"飓涛涌境",510,345,240},jl = {wp = {{"1元真实充值",1}} } },
                jl = {hb = {{3,3000000,"绑定元宝"},{4,300000,"绑定灵符"}},wp = {{"龙纹铜钱",15},{"1元真实充值",15}}}
            },
            {
                { "职业升华",10,yd = {1,"诡异位面",173,69,63},jl = {wp = {{"1元真实充值",1}} },desc = "<核心/FCOLOR=249>职业升华\\(<职业的最强形态/FCOLOR=250>)" },

                { "蓝珊瑚林-蚩尤的试炼",1,yz = {2,"npc509",2 },yd = {1,"蓝珊瑚林",509,80,134},jl = {wp = {{"1元真实充值",1}} } },
                { "蓝珊瑚林-他好像一条狗",1,yz = {2,"npc504",2 },yd = {1,"赤光熔坛",504,72,88},jl = {wp = {{"1元真实充值",1}} } },
                jl = {hb = {{3,3000000,"绑定元宝"},{4,300000,"绑定灵符"}},wp = {{"龙纹铜钱",15},{"1元真实充值",15}}}
            },
            {
                { "苍雷裂境-苍穹猎魔使",1,yz = {2,"npc493",2 },yd = {1,"苍雷裂境",493,23,27},jl = {wp = {{"1元真实充值",1}} } },
                { "苍雷裂境-我有一剑",1,yz = {2,"npc494",2 },yd = {1,"寂寥虚穹",494,40,254},jl = {wp = {{"1元真实充值",1}} } },
                { "苍雷裂境-世人皆笑我",1,yz = {2,"npc499",2 },yd = {1,"渊炎绝地",499,465,236},jl = {wp = {{"1元真实充值",1}} } },
                { "苍雷裂境-荒古之谜",1,yz = {1,"npc488",2 },yd = {1,"蛮神遗坛",488,45,35},jl = {wp = {{"1元真实充值",1}} } },
                jl = {hb = {{3,3000000,"绑定元宝"},{4,300000,"绑定灵符"}},wp = {{"龙纹铜钱",15},{"1元真实充值",15}}}
            },
            {
                { "归去来兮",1,yz = {2,"npc481",2 },yd = {1,"古代战堡",481,373,363},jl = {wp = {{"1元真实充值",1}} } },
                { "荒古密钥",1,yz = {2,"npc482",2 },yd = {1,"雷霆断崖",482,26,220},jl = {wp = {{"1元真实充值",1}} } },
                { "战意凭风起",1,yz = {2,"npc476",2 },yd = {1,"血焰石阵染疆场",476,44,28},jl = {wp = {{"1元真实充值",1}} } },
                jl = {hb = {{3,3000000,"绑定元宝"},{4,300000,"绑定灵符"}},wp = {{"龙纹铜钱",15},{"1元真实充值",15}}}

            },
            {
                { "肃清迷城",1,yz = {2,"npc471",2 },yd = {1,"幻纹石径迷途归",471,270,33},jl = {wp = {{"1元真实充值",1}} } },
                jl = {hb = {{3,3000000,"绑定元宝"},{4,300000,"绑定灵符"}},wp = {{"龙纹铜钱",15},{"1元真实充值",15}}}

            },
            {
                { "完成八大陆转生",12,{8},yd = {1,"诡异位面",163,59,63},jl = {wp = {{"1元真实充值",1}} },desc = "<核心/FCOLOR=249>完成八大陆转生\\(<提升核心属性/FCOLOR=250>)" },

                { "圣虚斩魔",1,yz = {2,"npc466",2 },yd = {1,"天启之门",466,42,85},jl = {wp = {{"1元真实充值",1}} } },
                { "掀翻它们",1,yz = {2,"npc461",2 },yd = {1,"万蛇洞窟",461,22,267},jl = {wp = {{"1元真实充值",1}} } },
                jl = {hb = {{3,3000000,"绑定元宝"},{4,300000,"绑定灵符"}},wp = {{"龙纹铜钱",15},{"1元真实充值",15}}}
            },
        },
        {},
        {
            {"夜哭寒泉","寂影孤魂"},
            {"蓝珊瑚林","长歌踏月"},
            {"苍雷裂境","九霄游风"},
            {"古代战堡","封魔镇狱"},
            {"幽梦之庭","炎凰冕盔"},
            {"天启之门","炽焰珠链"},
            {"月光禁地","火种之戒"},
            {"赤日神殿","赤焰戒"},
            {"渊炎绝地","火舞手镯"},
            {"血焰石阵染疆场","熔岩手镯"},
            {"梦魇之核噩梦醒","烈风之履"},
            {"万蛇洞窟","火龙束带"},
        },
        {
            {"死亡古洞","星空·道极"},
            {"赤光熔坛","命运之轮"},
            {"寂寥虚穹","弑序亲王"},
            {"雷霆断崖","特修斯の魔"},
            {"幻纹石径迷途归","王之蔑视"},
            {"幻沙古径","午夜虹吸"},
            {"飓涛涌境","世界树灵枝"},
            {"初劫之痕","流水无情"},
            {"蛮神遗坛","落花三千"},
            {"战士归骨","烟雨醉浮生"},
            {"圣血石林孤塔声","此上无人1"},
            {"巨爪绝崖魂断坠","此下众生1"},

        }
    },
    {
        {

        },
        {
            {
                { "清理门户",1,yz = {2,"npc456" ,2},yd = {1,"风雷禁阁",456,207,93},jl = {wp = {{"1元真实充值",1}} } },
                jl = {hb = {{3,5000000,"绑定元宝"},{4,500000,"绑定灵符"}},wp = {{"龙纹铜钱",20},{"1元真实充值",20}}}
            },
            {
                { "深渊之主",1,yz = {2,"npc451" ,2},yd = {1,"迷影石廊",451,25,72},jl = {wp = {{"1元真实充值",1}} } },
                jl = {hb = {{3,5000000,"绑定元宝"},{4,500000,"绑定灵符"}},wp = {{"龙纹铜钱",20},{"1元真实充值",20}}}

            },
            {
                { "我要这天",1,yz = {2,"npc446" ,2},yd = {1,"风沙埋骨镇",446,15,98},jl = {wp = {{"1元真实充值",1}} } },
                jl = {hb = {{3,5000000,"绑定元宝"},{4,500000,"绑定灵符"}},wp = {{"龙纹铜钱",20},{"1元真实充值",20}}}


            },
            {
                { "嗜血杀戮",1,yz = {2,"npc441" ,2},yd = {1,"幽火燃骨坛",441,59,289},jl = {wp = {{"1元真实充值",1}} } },
                jl = {hb = {{3,5000000,"绑定元宝"},{4,500000,"绑定灵符"}},wp = {{"龙纹铜钱",20},{"1元真实充值",20}}}


            },
            {
                { "妖魔作乱",1,yz = {2,"npc435" ,2},yd = {1,"白峰古道",435,359,44},jl = {wp = {{"1元真实充值",1}} } },
                { "初识虚渊界",1,yz = {1,"npc436" ,2},yd = {1,"凌云冰谷",436,185,208},jl = {wp = {{"1元真实充值",1}} } },
                jl = {hb = {{3,5000000,"绑定元宝"},{4,500000,"绑定灵符"}},wp = {{"龙纹铜钱",20},{"1元真实充值",20}}}

            },
            {

                { "杀戮舞曲",1,yz = {2,"npc429" ,2},yd = {1,"诡音回廊",429,44,44},jl = {wp = {{"1元真实充值",1}} } },
                { "证明自我",1,yz = {1,"npc430" ,2},yd = {1,"迷魂秘径",430,23,215},jl = {wp = {{"1元真实充值",1}} } },
                jl = {hb = {{3,5000000,"绑定元宝"},{4,500000,"绑定灵符"}},wp = {{"龙纹铜钱",20},{"1元真实充值",20}}}

            }
        },
        {},
        {
            {"獠牙石道","星辰冕冠"},
            {"灵虚之塔","无影梦链"},
            {"禁忌裂隙","冥炎之戒"},
            {"旧城血染街","破碎轮回"},
            {"黑棺地宫","幽灵步履"},
            {"诡音回廊","惊雷踏云"},
            {"风雷禁阁","疾风追星"},
            {"迷影石廊","九重苍带"},
            {"风沙埋骨镇","紫电"},
            {"幽火燃骨坛","幻梦池"},
            {"白峰古道","苍穹"},
            {"阴火祭坛","血焰"},
            {"黄泉尽头石门","寒夜霜"},
            {"凌云冰谷","雪影舞"},
            {"星陨之境","流云山"},
        }
    },
}
npc[11] = function(p2, p3, Data) -- 异闻录
	if p2 == -1 then
		GUI:Win_CloseByID("npc_ywl")
	elseif p2 == 0 then
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

        npc.bg = GUI:Image_Create(parent, "bj", 0, 0, 'res/wy/public/ywl/ywl_bj.png')
        GUI:setAnchorPoint(npc.bg, 0.5, 0.5)
        GUI:setTouchEnabled(npc.bg, true)
        GUI:Image_Create(npc.bg, "lbj", 120, 70, 'res/wy/public/ywl/ywl_lbj.png')

        local close = GUI:Button_Create(npc.bg, 'close', 960, 560, 'res/wy/public/close.png')
        GUI:addOnClickEvent(close, function()
            GUI:Win_Close(parent)
        end)

        local tt = GUI:Frames_Create(npc.bg, "tt", -20, 0, "res/wy/public/ywl/ywl_tt_", ".png", 1, 54, {speed = 50,count = 54,loop = -1,finishhide = false})
        npc.scdk = true


		function main_ru()
            function new_ziyemian(id)
                if npc.jm == 1 then
                    GUI:setVisible(npc.l_an[4], false)
                    if npc.l == 4 then
                        GUI:Button_loadTextureNormal(npc.l_an[npc.l], 'res/wy/public/ywl/anniu_23_ncd_'..npc.l..'.png')
                        npc.l = 1
                        GUI:Button_loadTextureNormal(npc.l_an[npc.l], 'res/wy/public/ywl/anniu_23_cd_'..npc.l..'.png')
                    end
                else
                    GUI:setVisible(npc.l_an[4], true)
                end
                GUI:removeAllChildren(npc.node)
                GUI:Image_Create(npc.node, "img", 308, 70, 'res/wy/public/ywl/anniu_23_img_'..npc.l..'.png')

                if npc.l == 2 then
                    for i = 1, #npc.xyl[npc.jm][npc.l], 1 do
                        if not (npc.data.ywl["jl_"..npc.jm.."_"..npc.l.."_"..i] and npc.data.ywl["jl_"..npc.jm.."_"..npc.l.."_"..i] == 1) and npc.zj <= 1 and npc.scdk then
                            npc.zj = i
                            npc.scdk = false
                        end
                    end
                    for i = 1, #npc.xyl[npc.jm][npc.l], 1 do
                        local btn = GUI:Button_Create(npc.node, "btn"..i, 310 + (i-1) * 107,135 + 350, npc.zj == i and  "res/wy/public/anniu_23_zj_l_"..i..".png" or "res/wy/public/anniu_23_zj_n_"..i..".png")
                        GUI:addOnClickEvent(btn, function()
                            if (npc.jm == 2 or npc.jm == 3) and i > 1 then
                                if not (npc.data.ywl["jl_"..npc.jm.."_"..npc.l.."_"..(i - 1)] and npc.data.ywl["jl_"..npc.jm.."_"..npc.l.."_"..(i - 1)] == 1) then
                                    SL:ShowSystemTips("<font color='#FF0000'>请先完成前置章节任务...</font>")
                                    return
                                end
                            end
                            if npc.zj ~= i then
                                npc.zj = i
                                new_ziyemian()
                            end
                        end)
                        if npc.data.ywl["jl_"..npc.jm.."_"..npc.l.."_"..i] and npc.data.ywl["jl_"..npc.jm.."_"..npc.l.."_"..i] == 1 then
                            GUI:Image_Create(btn, "dj", 50, 5, "res/wy/public/7_1_x.png")
                        end
                    end
                    local _wc_num = 0
                    local ScrollView_content = GUI:ScrollView_Create(npc.node, "ScrollView_content", 320,143, 650.00, (164.00 * 2) + 10, 1)
                    GUI:ScrollView_setInnerContainerSize(ScrollView_content, 650, math.ceil(#npc.xyl[npc.jm][npc.l][npc.zj]/2) * 169)
                    if math.ceil(#npc.xyl[npc.jm][npc.l][npc.zj]/2) > 2 then
                        GUI:Image_Create(npc.node, "sxhd", 320 + 650 - 35, 150, "res/wy/public/sxhd.png")
                    end


                    local Layout1 = GUI:Layout_Create(ScrollView_content, "Layout1", 0,0, 650.00, (164.00 * 2) + 10, false)
                    for v,k in pairs(npc.xyl[npc.jm][npc.l][npc.zj] or {}) do
                        if v == "jl" then
                            break
                        end
                        local bj = GUI:Image_Create(Layout1, "bj"..v, 0, 0, 'res/wy/public/ywl/anniu_23_zj_rw_n_'..v..'.png')
                        local rwtt = GUI:Text_Create(bj, "rwtt", 305/2, 100, 26, "#F7F7DE", k[1])
                        GUI:Text_setFontName(rwtt,"fonts/502.ttf")
                        GUI:setAnchorPoint(rwtt, 0.5, 0)

                        GUI:setAnchorPoint(GUI:RichTextFCOLOR_Create(bj, "desc", 305/2, 83, "任务描述:".. (k.desc or "可在任务界面查看"), 250, 16, "#00FFFF", 1,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})
                        , 0.5, 0.5)

                        if k.jl then
                            local num =GUI:Text_Create(bj, "jl", 30, 23, 18, "#FFFF00", "奖励：")
                            GUI:Text_enableOutline(num, "#150800", 2)
                            local jl_node =  ItemNumByTable_img({{k.jl.wp[1][1],k.jl.wp[1][2]}}, nil,num)
                            GUI:setPosition(jl_node, 60, -13)
                        end



                        if (npc.data.ywl["jl_"..npc.jm.."_"..npc.l.."_"..npc.zj] and npc.data.ywl["jl_"..npc.jm.."_"..npc.l.."_"..npc.zj] == 1) or
                                (npc.data.ywl["jl_"..npc.jm.."_"..npc.l.."_"..npc.zj.."_"..v] and npc.data.ywl["jl_"..npc.jm.."_"..npc.l.."_"..npc.zj.."_"..v] == 1) then
                            GUI:Image_Create(bj, "wc", 305/2, 40, 'res/wy/public/4.png')
                            GUI:Image_loadTexture(bj, 'res/wy/public/ywl/anniu_23_zj_rw_l_'..v..'.png')
                            _wc_num = _wc_num + 1
                        else
                            if k[2] == 999 then
                                if k[3][1] == 3 or k[3][1] == 4 then
                                    if npc.data.ywl["rw_"..k[3][2]] and npc.data.ywl["rw_"..k[3][2]] == 1 then
                                        local btn = GUI:Button_Create(bj, "btn_", 220, 30, 'res/wy/public/ywl/anniu_23_zj_cs_lq.png')
                                        GUI:setAnchorPoint(btn, 0.5, 0.5)
                                        GUI:addOnClickEvent(btn, function()
                                            SL:SendLuaNetMsg(101, 11, 3, 0, '{"i":' .. npc.jm .. ',"j":' .. npc.l .. ',"k":' .. npc.zj .. ',"z":' .. v..'}')
                                        end)
                                    else
                                        local btn = GUI:Button_Create(bj, "btn_", 220, 30, 'res/wy/public/ywl/anniu_23_zj_cs_an.png')
                                        GUI:setAnchorPoint(btn, 0.5, 0.5)
                                        GUI:addOnClickEvent(btn, function()
                                            SL:SendLuaNetMsg(101, 11, 1, 0, '{"i":' .. npc.jm .. ',"j":' .. npc.l .. ',"k":' .. npc.zj .. ',"z":' .. v..'}')
                                        end)
                                    end
                                end
                            elseif k[2] == 1 then
                                local yzType, yzKey, yzValue = k.yz[1], k.yz[2], k.yz[3]
                                local canClaim = (yzType == 1 and npc.data.dljq[yzKey] and npc.data.dljq[yzKey] >= yzValue)
                                        or (yzType == 2 and npc.data.dljq[yzKey] and npc.data.dljq[yzKey][1] >= yzValue)

                                local img  = canClaim and 'res/wy/public/ywl/anniu_23_zj_cs_lq.png' or 'res/wy/public/ywl/anniu_23_zj_cs_an.png'
                                local code = canClaim and 3 or 1
                                local btn  = GUI:Button_Create(bj, "btn_", 220, 30, img)
                                GUI:setAnchorPoint(btn, 0.5, 0.5)
                                GUI:addOnClickEvent(btn, function()
                                    SL:SendLuaNetMsg(101, 11, code, 0,
                                            '{"i":' .. npc.jm .. ',"j":' .. npc.l .. ',"k":' .. npc.zj .. ',"z":' .. v .. '}')
                                end)
                            else
                                local enable = false

                                if k[2] == 2 then
                                    local item = SL:GetMetaValue("EQUIP_DATA", k.yz[1])
                                    enable = item and item.Index >= k.yz[2]

                                elseif k[2] == 3 then -- 完成职业一觉
                                    local one_jue = cogin.sjtb.T_zzsj.one_jue
                                    enable = one_jue and one_jue["" .. cogin.sjtb.T_zzsj.dqzy] and one_jue["" .. cogin.sjtb.T_zzsj.dqzy] == 1

                                elseif k[2] == 4 then
                                    local item = SL:GetMetaValue("EQUIP_DATA", 104)
                                    local dj = item.ExAbil.abil[4].v[1][3] / 5
                                    enable = dj > 0
                                elseif k[2] == 5 then
                                    local zy_dj = cogin.sjtb.T_zzsj.zy_dj
                                    enable = cogin.sjtb.T_zzsj.dqzy and zy_dj and zy_dj["" .. cogin.sjtb.T_zzsj.dqzy] and zy_dj["" .. cogin.sjtb.T_zzsj.dqzy] >= 100
                                elseif k[2] == 6 then -- 完成职业二觉
                                    local two_jue = cogin.sjtb.T_zzsj.two_jue
                                    enable = cogin.sjtb.T_zzsj.dqzy and two_jue and two_jue["" .. cogin.sjtb.T_zzsj.dqzy] and two_jue["" .. cogin.sjtb.T_zzsj.dqzy] == 1
                                elseif k[2] == 7 then -- 在隐仙居中完成仙气转换
                                    enable = SL:GetMetaValue("TITLE_DATA_BY_ID", SL:GetMetaValue("ITEM_INDEX_BY_NAME",k.yz[2]))
                                elseif k[2] == 8 then -- 完成职业三觉
                                    local three_jue = cogin.sjtb.T_zzsj.three_jue
                                    enable = cogin.sjtb.T_zzsj.dqzy and three_jue and three_jue["" .. cogin.sjtb.T_zzsj.dqzy] and three_jue["" .. cogin.sjtb.T_zzsj.dqzy] == 1
                                elseif k[2] == 9 then
                                    local item = SL:GetMetaValue("EQUIP_DATA", 104)
                                    local dj = item.ExAbil.abil[4].v[1][3] / 5
                                    enable = dj >= 20
                                elseif k[2] == 10 then
                                    local sh = cogin.sjtb.T_zzsj.sh
                                    enable = cogin.sjtb.T_zzsj.dqzy and sh and sh["" .. cogin.sjtb.T_zzsj.dqzy] and sh["" .. cogin.sjtb.T_zzsj.dqzy] == 1
                                elseif k[2] == 11 then
                                    local item = SL:GetMetaValue("EQUIP_DATA", 72)
                                    local dj = item.ExAbil.abil[1 + 1].v[5 + 1][3]
                                    enable = dj >= 1000
                                elseif k[2] == 12 then ---转生
                                    enable = SL:GetMetaValue("RELEVEL") >= k[3][1]
                                end

                                -- 统一按钮创建与点击事件
                                local btn = GUI:Button_Create(bj, "btn_", 220, 30,
                                        enable and 'res/wy/public/ywl/anniu_23_zj_cs_lq.png' or 'res/wy/public/ywl/anniu_23_zj_cs_an.png')
                                GUI:setAnchorPoint(btn, 0.5, 0.5)
                                GUI:addOnClickEvent(btn, function()
                                    SL:SendLuaNetMsg(101, 11, enable and 3 or 1, 0,
                                            '{"i":' .. npc.jm .. ',"j":' .. npc.l .. ',"k":' .. npc.zj .. ',"z":' .. v .. '}')
                                end)
                            end
                        end
                    end
                    GUI:UserUILayout(Layout1, {dir=3,addDir=1,gap = {x=10,y=10}})

                    --GUI:Text_setFontName(GUI:Text_Create(npc.node, "jd", 510, 105, 30, "#F7F7DE", _wc_num ..'/'..#npc.xyl[npc.jm][npc.l])
                    --,"fonts/502.ttf")

                    GUI:Image_Create(npc.node, "anniu_23_zj_jl", 310, 70, 'res/wy/public/ywl/anniu_23_zj_jl.png')
                    --GUI:setPosition(ItemNumByTable_img(npc.xyl1[npc.jm][npc.l].jl.wp, nil,npc.node)
                    --, 610, 65)

                    local jll = {}
                    if npc.xyl[npc.jm][npc.l][npc.zj].jl then
                        if npc.xyl[npc.jm][npc.l][npc.zj].jl.hb then
                            for ii,vv in ipairs(npc.xyl[npc.jm][npc.l][npc.zj].jl.hb) do
                                table.insert(jll, {vv[3], vv[2]})
                            end
                        end
                        if npc.xyl[npc.jm][npc.l][npc.zj].jl.wp then
                            for ii,vv in ipairs(npc.xyl[npc.jm][npc.l][npc.zj].jl.wp) do
                                table.insert(jll, vv)
                            end
                        end
                    end
                    GUI:setPosition(ItemNumByTable_img(jll, nil,npc.node)
                    , 450, 80)

                    if npc.data.ywl["jl_"..npc.jm.."_"..npc.l.."_"..npc.zj] and npc.data.ywl["jl_"..npc.jm.."_"..npc.l.."_"..npc.zj] == 1 then
                        GUI:Image_Create(npc.node, "wc", 730, 60, 'res/wy/public/7_1.png')
                    else
                        local an = GUI:Button_Create(npc.node, "an", 730, 55, 'res/wy/public/an_lqjl.png')
                        GUI:addOnClickEvent(an, function()
                            SL:SendLuaNetMsg(101, 11, 2, 0, '{"i":' .. npc.jm .. ',"j":' .. npc.l .. ',"k":' .. npc.zj ..'}')
                        end)
                        if _wc_num >= #npc.xyl[npc.jm][npc.l][npc.zj] then
                            SL:StartGuide({dir = 3 ,guideWidget = an ,guideParent=npc.node,guideDesc="点击领取章节奖励",isForce = false})
                        end
                    end

                elseif npc.l == 3 then
                    local ListView = GUI:ListView_Create(npc.node, "rw_ListView", 310,75,650.00, 450.00, 1)
                    if #npc.xyl[npc.jm][npc.l] == 0 then
                        local rw = GUI:Layout_Create(ListView, "rw"..1, 0, 0, 650, 115, false)
                        local rwtt = GUI:Image_Create(rw, "rwtt", 0, 0, 'res/wy/public/ywl/此等传闻还未解锁.png')
                    else
                        for i = 1, #npc.xyl[npc.jm][npc.l] or 0 do
                            local rw = GUI:Layout_Create(ListView, "rw"..i, 0, 0, 650, 115, false)
                            local shuju = npc.xyl[npc.jm][npc.l][i]
                            local rwtt = GUI:Image_Create(rw, "rwtt", 0, 0, 'res/wy/public/ywl/'..shuju[1]..'.png')
                        end
                    end
                elseif npc.l == 4 then
                    GUI:Image_Create(npc.node, "img_1", 308, 70, 'res/wy/public/anniu_23_img_4.png')
                    local ListView = GUI:ListView_Create(npc.node, "rw_ListView", 310,120,650.00, 374.00, 1)
                    for v,k in pairs(npc.xyl[npc.jm][4] or {}) do
                        local rw = GUI:Layout_Create(ListView, "rw"..v, 0, 0, 650, 80, false)
                        local img = GUI:Image_Create(rw, "img"..v, 60, 5, 'res/wy/public/anniu_23_4_kuang.png')
                        GUI:setAnchorPoint(GUI:ItemShow_Create(img,"item", 69/2, 72/2, {index = SL:GetMetaValue("ITEM_INDEX_BY_NAME",k[2]),look=true})
                        , 0.5, 0.5)

                        local wz =GUI:Text_Create(rw, "wz", 250, 40, 30, "#FFFF00", k[1])
                        GUI:Text_enableOutline(wz, "#150800", 2)
                        GUI:setAnchorPoint(wz, 0.5, 0.5)
                        GUI:Text_setFontName(wz, "fonts/502.ttf")


                        if npc.data.T_tj.zs and npc.data.T_tj.zs[""..SL:GetMetaValue("ITEM_INDEX_BY_NAME",k[2])] and npc.data.T_tj.zs[""..SL:GetMetaValue("ITEM_INDEX_BY_NAME",k[2])] == 1 then
                            GUI:Image_Create(rw, "an", 350, 15, 'res/wy/public/rwjd_4.png')
                        end
                        local btn = GUI:Button_Create(rw, "an1", 490, 15, 'res/wy/public/ywl/anniu_23_4_an.png')
                        GUI:addOnClickEvent(btn, function()
                            SL:SendLuaNetMsg(101, 11, 5, 0, '{"i":' .. npc.jm .. ',"k":' .. v ..'}')
                        end)
                        GUI:Image_Create(ListView, "fgx"..v, 0, 0, 'res/wy/public/npc_516_fgx.png')
                    end
                elseif npc.l == 5 then
                    GUI:Image_Create(npc.node, "img_1", 308, 70, 'res/wy/public/anniu_23_img_4.png')
                    local ListView = GUI:ListView_Create(npc.node, "rw_ListView", 310,120,650.00, 374.00, 1)
                    if npc.xyl[npc.jm][5] then
                        for v,k in pairs(npc.xyl[npc.jm][5] or {}) do
                            local rw = GUI:Layout_Create(ListView, "rw"..v, 0, 0, 650, 80, false)
                            local img = GUI:Image_Create(rw, "img"..v, 60, 5, 'res/wy/public/anniu_23_4_kuang.png')
                            GUI:setAnchorPoint(GUI:ItemShow_Create(img,"item", 69/2, 72/2, {index = SL:GetMetaValue("ITEM_INDEX_BY_NAME",k[2]),look=true})
                            , 0.5, 0.5)

                            local wz =GUI:Text_Create(rw, "wz", 250, 40, 30, "#FFFF00", k[1])
                            GUI:Text_enableOutline(wz, "#150800", 2)
                            GUI:setAnchorPoint(wz, 0.5, 0.5)
                            GUI:Text_setFontName(wz, "fonts/502.ttf")


                            if npc.data.T_tj.zs and npc.data.T_tj.zs[""..SL:GetMetaValue("ITEM_INDEX_BY_NAME",k[2])] and npc.data.T_tj.zs[""..SL:GetMetaValue("ITEM_INDEX_BY_NAME",k[2])] == 1 then
                                GUI:Image_Create(rw, "an", 350, 15, 'res/wy/public/rwjd_4.png')
                            end
                            local btn = GUI:Button_Create(rw, "an1", 490, 15, 'res/wy/public/ywl/anniu_23_4_an.png')
                            GUI:addOnClickEvent(btn, function()
                                SL:SendLuaNetMsg(101, 11, 6, 0, '{"i":' .. npc.jm .. ',"k":' .. v ..'}')
                            end)
                            GUI:Image_Create(ListView, "fgx"..v, 0, 0, 'res/wy/public/npc_516_fgx.png')
                        end
                    else
                        GUI:Button_loadTextureNormal(npc.l_an[npc.l], 'res/wy/public/ywl/anniu_23_ncd_'..npc.l..'.png')
                        npc.l = 2
                        GUI:Button_loadTextureNormal(npc.l_an[npc.l], 'res/wy/public/ywl/anniu_23_cd_'..npc.l..'.png')
                        new_ziyemian()
                    end
                end
            end
		end
        main_ru()
        npc.jm = (npc.jm and npc.jm < 10) and npc.jm or 2
        npc.l = (npc.l and npc.l < 5) and npc.l or 2
        npc.xl = npc.xl or 0
        npc.zj = npc.zj or 1 npc.ywl_an = {}
        npc.l_an = {}
        npc.node = GUI:Node_Create(npc.bg, "node", 0, 0)
        --[[for i = 1, 4, 1 do
            npc.ywl_an[i] = GUI:Button_Create(npc.bg, "ywl_an_"..i, 175, 100, 'res/wy/public/ywl/ywl_lb_n.png')
            --动画
            GUI:Timeline_MoveTo(npc.ywl_an[i], {x = 175.00 + (i - 1) * 140, y = 100}, i/3)
            GUI:Image_Create(npc.ywl_an[i], "wz", 0, 0, 'res/wy/public/ywl/ywl_lb_wz_n_'..i..'.png')
            GUI:addOnClickEvent(npc.ywl_an[i], function()
                npc.jm = i
                GUI:Button_loadTextureNormal(npc.ywl_an[i], 'res/wy/public/ywl/ywl_lb_l.png')
                GUI:Image_loadTexture(GUI:ui_delegate(npc.ywl_an[i]).wz, 'res/wy/public/ywl/ywl_lb_wz_l_'..npc.jm..'.png')
                for j = 1, 4, 1 do
                    if npc.jm ~= j then
                        GUI:setVisible(npc.ywl_an[j], false)
                    end
                    GUI:setTouchEnabled(npc.ywl_an[j], false)
                end
                GUI:Timeline_MoveTo(npc.ywl_an[i], {x = 100.00, y = 100}, 0.5)
                new_ziyemian(npc.ywl_an[i])
            end)
        end]]
        npc.ywl_list = GUI:ListView_Create(npc.bg, "List", 110, 70, 200.00, 520.00, 1,false)
        GUI:ListView_setItemsMargin(npc.ywl_list, 80)
        GUI:Node_Create(npc.ywl_list, "l_node_0", 0, 0)

        for i = 2, 8, 1 do
            npc.ywl_an[i] = GUI:Node_Create(npc.ywl_list, "l_node_"..i, 0, 520 - (i) * 80)
            --
            local ywl_an = GUI:Layout_Create(npc.ywl_an[i],"ywl_an_"..i,25,0,200,78,false)
            GUI:setTouchEnabled(ywl_an, true)


            --GUI:setScale(GUI:Image_Create(ywl_an, "ywl_an", 70, 5, 'res/wy/public/ywl/anniu_23_l_'..i..'.png')
            --, 0.6)
            --GUI:Text_Create(npc.ywl_an[i], "wz", 0, 0, 10, "#F7F7DE", "——————————————————————————————")

            GUI:Image_Create(ywl_an, "tt", -15, 15, 'res/wy/public/dl_'..i..'.png')
            GUI:addOnClickEvent(ywl_an, function()
                    if not dl_sz(i) then
                        SL:ShowSystemTips("<font color='#FF0000'>还未解锁该大陆...</font>")
                        return
                    end
                    if npc.jm ~= i then
                        GUI:removeFromParent(GUI:ui_delegate(npc.ywl_an[npc.jm]).kuang)
                        npc.jm = i
                        npc.zj = 1
                        GUI:setLocalZOrder(GUI:Image_Create(npc.ywl_an[npc.jm], "kuang", 0, 0, 'res/wy/public/ywl/anniu_23_l_kuang.png')
                        , -1)
                        npc.xl = 0

                        if npc.xyl[npc.jm][5] then
                            GUI:setVisible(npc.l_an[5], true)
                        else
                            GUI:setVisible(npc.l_an[5], false)
                        end
                        new_ziyemian()
                    end
            end)
        end
        if npc.jm == 2 and npc.data.ywl["jl_2_2_6"] and npc.data.ywl["jl_2_2_6"] == 1 and not npc.data.ywl["jl_3_2_6"] then
            SL:StartGuide({dir = 3 ,guideWidget = GUI:ui_delegate(npc.ywl_an[3])["ywl_an_3"],guideParent=npc.ywl_an[3],autoExcute = 3,guideDesc="开始三大陆章节任务",isForce = false,hideMask = true})
            Npclib["anniu"][1](0,1,"")
        end
        for i = 2, 5, 1 do
            npc.l_an[i] = GUI:Button_Create(npc.bg, "ywl_l_"..i, 150 + (i-1)*160, 535, 'res/wy/public/ywl/anniu_23_ncd_'..i..'.png')
            GUI:addOnClickEvent(npc.l_an[i], function()
                if npc.l ~= i then
                    GUI:Button_loadTextureNormal(npc.l_an[npc.l], 'res/wy/public/ywl/anniu_23_ncd_'..npc.l..'.png')
                    npc.l = i
                    GUI:Button_loadTextureNormal(npc.l_an[npc.l], 'res/wy/public/ywl/anniu_23_cd_'..npc.l..'.png')
                    npc.xl = 0
                    new_ziyemian()
                end
            end)
        end
        if npc.xyl[npc.jm][5] then
            GUI:setVisible(npc.l_an[5], true)
        else
            GUI:setVisible(npc.l_an[5], false)
        end
        GUI:Button_loadTextureNormal(npc.l_an[npc.l], 'res/wy/public/ywl/anniu_23_cd_'..npc.l..'.png')
        GUI:setLocalZOrder(GUI:Image_Create(npc.ywl_an[npc.jm], "kuang", 0, 0, 'res/wy/public/ywl/anniu_23_l_kuang.png')
        , -1)
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
        npc.zj = 1
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
    if p2 == 0 then
        npc.data = SL:JsonDecode(Data,false)
        local parent = GUI:GetWindow(nil, "npc_slts")
        if parent then
            GUI:Win_Close(parent)
            return
        else
            parent = GUI:Win_Create("npc_slts", 0, 0, 0, 0, false, false, true, true, true, 0, 1)
        end

        local pos = GUI:getWorldPosition(GUI:ui_delegate(GUI:ui_delegate(MainAssist._ui["Panel_hide"]).xyl).slts)
        npc.bg = GUI:Image_Create(parent, "bj", pos.x + 100, pos.y + 70, "res/private/item_tips/bg_tipszy_05.png")
        GUI:Timeline_Window2(npc.bg)
        GUI:setContentSize(npc.bg, 243, 519)
        GUI:setAnchorPoint(npc.bg, 0, 1)
        GUI:setTouchEnabled(npc.bg, true)


        local close = GUI:Button_Create(npc.bg, 'close', 243, 519, 'res/public/1900000511.png')
        GUI:setAnchorPoint(close, 0, 1)
        GUI:addOnClickEvent(close, function()
            GUI:Win_Close(parent)
        end)

        npc.sltsan = {}
        npc.sltsxz = nil

        npc.sltsxz = 1
        npc.sltsxz_l = npc.sltsxz_l or 1
        npc.slts_hd = {}
        for idx = 1, #cogin.slts.l do
            for v,k in ipairs(cogin.slts.l[idx]) do
                npc.slts_hd[idx.."_"..v] = slts_jz(idx, v)
                if npc.slts_hd[idx.."_"..v] == 2 then
                    npc.slts_hd["dl_"..idx] = 1
                end
            end
        end

        local live = GUI:ListView_Create(npc.bg, "ListView", 3, 7, 236.00, 505.00, 1)
        GUI:ListView_setGravity(live, 2)
        GUI:ListView_setItemsMargin(live, 10)
        function slts_l_updata()
            GUI:removeAllChildren(live)
            for idx = 1, #cogin.slts.l do
                if dl_sz(idx) then
                    npc.sltsan["dl_"..idx] = GUI:Button_Create(live, "slts_dl_"..idx, 0.00, 0,
                            npc.sltsxz_l == idx and "res/wy/public/slts_dl_"..idx..".png" or "res/wy/public/slts_dln_"..idx..".png"
                    )
                    GUI:Button_loadTexturePressed(npc.sltsan["dl_"..idx], "res/wy/public/slts_dl_"..idx..".png")
                    GUI:Image_Create(npc.sltsan["dl_"..idx], "xia1", 160, 4,
                            npc.sltsxz_l == idx and 'res/wy/public/xyl_an_2.png' or 'res/wy/public/xyl_an_1.png'
                    )
                    GUI:addOnClickEvent(npc.sltsan["dl_"..idx], function()
                        if npc.sltsxz_l ~= idx then
                            npc.sltsxz_l = idx
                            npc.sltsxz = 1
                            slts_l_updata()
                        else
                            npc.sltsxz_l = 0
                            slts_l_updata()
                        end
                    end)
                    if npc.slts_hd["dl_"..idx] and npc.slts_hd["dl_"..idx] == 1 then
                        GUI:Image_Create(npc.sltsan["dl_"..idx], "ists", 195, 24, "res/public/ists.png")
                    end
                    for v,k in ipairs(cogin.slts.l[idx]) do
                        if idx == npc.sltsxz_l then
                            if npc.slts_hd[idx.."_"..v] and npc.slts_hd[idx.."_"..v] >= 1 then
                                if v ~= 1 then
                                    GUI:Image_Create(live, "fgx"..idx.."_"..v, 0, 0, "res/wy/public/yxgl_fgx.png")
                                end
                                npc.sltsan[idx.."_"..v] = GUI:Text_Create(live, "wz"..idx.."_"..v, 0, 0, 30, (npc.sltsxz == v and "#FFFF00" or "#44DDFF"), k.name)
                                GUI:Text_setFontName(npc.sltsan[idx.."_"..v],"fonts/502.ttf")

                                if not (npc.slts_hd[idx.."_"..v] == 3) then
                                    GUI:setTouchEnabled(npc.sltsan[idx.."_"..v], true)
                                    GUI:addOnClickEvent( npc.sltsan[idx.."_"..v], function()
                                        local net = cogin.slts.l[idx][v].net
                                        SL:SendLuaNetMsg(net[1],net[2],net[3], 0, "")
                                        GUI:Win_Close(parent)
                                    end)
                                end
                                if npc.slts_hd[idx.."_"..v] == 2 then
                                    GUI:setAnchorPoint(GUI:Image_Create(npc.sltsan[idx.."_"..v], "ists", GUI:getContentSize(npc.sltsan[idx.."_"..v]).width, GUI:getContentSize(npc.sltsan[idx.."_"..v]).height/2, "res/wy/public/upup.png")
                                    , 0, 0.5)
                                elseif npc.slts_hd[idx.."_"..v] == 3 then
                                    local wz =GUI:Text_Create(npc.sltsan[idx.."_"..v], "wz", GUI:getContentSize(npc.sltsan[idx.."_"..v]).width, GUI:getContentSize(npc.sltsan[idx.."_"..v]).height/2, 20, "#FFFF00", "[满]")
                                    GUI:setAnchorPoint(wz, 0, 0.5)
                                    GUI:Text_enableOutline(wz, "#150800", 2)
                                end
                            end

                        end
                    end
                end
            end
            if npc.sltsxz_l > 0 then
                GUI:ListView_jumpToItem(live, #cogin.slts.l[npc.sltsxz_l] + npc.sltsxz_l)
            end
        end
        slts_l_updata()
    elseif p2 == 1 then

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
---在线充值
npc[502] = function(p2, p3, Data) -- 在线充值
	if p2 == 0 then
		local parent = GUI:GetWindow(nil, "npc_zxcz")
        npc.data = SL:JsonDecode(Data, false)
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

		npc.bg = GUI:Image_Create(parent, "img_bj", 0.00, 0.00, "res/wy/public/czjm_bj.png")
		GUI:setAnchorPoint(npc.bg, 0.5, 0.5)
		GUI:setTouchEnabled(npc.bg, true)
		GUI:Timeline_Window3(npc.bg)

        local close = GUI:Button_Create(npc.bg, 'close', 950, 490, 'res/wy/public/close.png')
		GUI:addOnClickEvent(close, function()
			GUI:Win_Close(parent)
		end)

		 local lieeq = GUI:ListView_Create(npc.bg, "lieeq", 75, 93, 222 * 4 + 20, 200 * 2, 1)
		 GUI:ListView_setGravity(lieeq, 5)
		 GUI:setTouchEnabled(lieeq, true)

		local Input = GUI:TextInput_Create(npc.bg, "Input",180.00, 35.00, 100.00, 25.00, 18)
		GUI:TextInput_setPlaceHolder(Input, "输入(最少10)")
		GUI:setTouchEnabled(Input, true)

        local lbText = GUI:Text_Create(npc.bg, "lbText", 180.00, 63, 18, "#FFAA99", SL:GetMetaValue("MONEY", 22))
        GUI:Text_enableOutline(lbText, "#000000", 1)
        --npc.tsg_sj
        local ljcz = GUI:Button_Create(npc.bg, 'ljcz', 200, 540, 'res/wy/public/ljcz_btn.png')
        for i = 1,#cogin.teshudata[516][2] do
            if not (npc.tsg_sj and npc.tsg_sj["2_"..i] and npc.tsg_sj["2_"..i] == 1) and (tonumber(SL:GetMetaValue("MONEY", 20)) >= cogin.teshudata[516][2][i][1]) then
                GUI:setAnchorPoint(GUI:Image_Create(ljcz, "ists", 130, 40, "res/public/ists.png")
                , 0.5, 0.5)
                break
            end
        end
        GUI:addOnClickEvent(ljcz, function()
            local x_parent = GUI:GetWindow(nil, "npc_ljcz_bj")
            if x_parent then
                GUI:removeAllChildren(x_parent)
                GUI:setPosition(x_parent, cogin.w / 2, cogin.h / 2)
            else
                x_parent = GUI:Win_Create("npc_ljcz_bj", cogin.w / 2, cogin.h / 2, 0, 0, false, false, true, false, true, 0, 1)
            end
            local x_bjt = GUI:Image_Create(x_parent, "bjt", 0, 0, "res/public/1900000651_1.png")
            GUI:setAnchorPoint(x_bjt, 0.5, 0.5)
            GUI:setContentSize(x_bjt, cogin.w + 100, cogin.h + 100)
            GUI:setTouchEnabled(x_bjt, true)
            GUI:addOnClickEvent(x_bjt, function()
                GUI:Win_Close(x_parent)
            end)
            GUI:addMouseOverTips(x_bjt, "", {x = 0, y = 0}, {x = 0, y = 0})


            local x_bg = GUI:Image_Create(x_parent, "img_bj", 0.00, 0.00, 'res/wy/public/ljcz_bj.png')
            GUI:setAnchorPoint(x_bg, 0.5, 0.5)
            GUI:setTouchEnabled(x_bg, true)
            GUI:Timeline_Window3(x_bg)
            npc.ljcz_node = GUI:Node_Create(x_bg, "ljcz_node", 0, 0)
            npc.ljcz_l = 1
            function ljcz_update()
                GUI:removeAllChildren(npc.ljcz_node)
                local v = cogin.teshudata[516][2][npc.ljcz_l]
                local wz =GUI:Text_Create(npc.ljcz_node, "wz", 818/2 + 18, 25 + 325, 30, "#FFFF00", string.format("累计充值%s元",v[1]))
                GUI:setAnchorPoint(wz, 0.5, 0.5)
                GUI:Text_setFontName(wz, "fonts/500.ttf")
                GUI:Text_enableOutline(wz, "#150800", 3)

                for kk,vv in ipairs(v[2]) do
                    local k = GUI:Image_Create(npc.ljcz_node, "itme"..kk, 272 + (kk-1)*80, 210, "res/wy/public/70_70_k.png")

                    GUI:setAnchorPoint(GUI:ItemShow_Create(k, "item", 35, 35, {index=SL:GetMetaValue("ITEM_INDEX_BY_NAME",vv[1]),count = vv[2],look= true})
                    , 0.5, 0.5)

                end

                if npc.tsg_sj["2_"..npc.ljcz_l] and npc.tsg_sj["2_"..npc.ljcz_l] == 1 then
                    GUI:Image_Create(npc.ljcz_node, "ljl", 560.00 - 182, 13 + 90, "res/wy/public/7_2.png")
                else
                    local Button = GUI:Button_Create(npc.ljcz_node, "Button",818/2 + 18, 100, "res/wy/public/ljcz_an.png")
                    GUI:setAnchorPoint(Button, 0.5, 0.5)
                    GUI:addOnClickEvent(Button, function()
                        SL:SendLuaNetMsg(101, 502, npc.ljcz_l, 5,"")
                    end)

                    GUI:Image_Create(npc.ljcz_node, "ljcz_wz", 150, 130, "res/wy/public/ljcz_wz.png")
                    GUI:Text_Create(npc.ljcz_node, "num", 150 + 90, 137, 20, "#FFFF00", cogin.teshudata[516][2][npc.ljcz_l][1] - SL:GetMetaValue("ITEM_COUNT", 20))

                    local x_Button = GUI:Button_Create(npc.ljcz_node, "ljcz_close",650, 100, "res/wy/public/ljcz_close.png")
                    GUI:setAnchorPoint(x_Button, 0.5, 0.5)
                    GUI:addOnClickEvent(x_Button, function()
                        SL:SendLuaNetMsg(101, 502, 0, 3, cogin.teshudata[516][2][npc.ljcz_l][1] - SL:GetMetaValue("ITEM_COUNT", 20))
                    end)
                    if SL:GetMetaValue("ITEM_COUNT", 20) >= cogin.teshudata[516][2][npc.ljcz_l][1] then
                        GUI:setAnchorPoint(GUI:Image_Create(Button, "ists", 140, 40, "res/public/ists.png")
                        , 0.5, 0.5)
                    end
                end
            end
            for i = 1,#cogin.teshudata[516][2] do
                if not (npc.tsg_sj["2_"..i] and npc.tsg_sj["2_"..i] == 1) then
                    npc.ljcz_l = i
                    break
                end
            end

            local ljcz_y = GUI:Button_Create(x_bg, 'ljcz_y', 760, 200, 'res/wy/public/ljcz_y.png')
            GUI:addOnClickEvent(ljcz_y, function()
                if (tonumber(SL:GetMetaValue("MONEY", 20)) >= cogin.teshudata[516][2][npc.ljcz_l][1]) or (cogin.teshudata[516][2][npc.ljcz_l][1] <= 1288) or (cogin.teshudata[516][2][npc.ljcz_l - 1] and (tonumber(SL:GetMetaValue("MONEY", 20)) >= cogin.teshudata[516][2][npc.ljcz_l - 1][1]))
                then
                    npc.ljcz_l = npc.ljcz_l + 1
                end
                ljcz_update()
            end)
            local ljcz_z = GUI:Button_Create(x_bg, 'ljcz_z', -40, 200, 'res/wy/public/ljcz_z.png')
            GUI:addOnClickEvent(ljcz_z, function()
                npc.ljcz_l = npc.ljcz_l - 1
                if npc.ljcz_l < 1 then
                    npc.ljcz_l = 1
                end
                ljcz_update()
            end)


            ljcz_update()
            local x_close = GUI:Button_Create(x_bg, 'close', 707, 355, 'res/wy/public/close.png')
            GUI:addOnClickEvent(x_close, function()
                GUI:Win_Close(x_parent)
            end)
        end)

		local cz_an = GUI:Button_Create(npc.bg, "cz_an", 300, 38, "res/wy/public/czjm_an.png")
		GUI:addOnClickEvent(cz_an, function()
			local msg = tonumber(GUI:TextInput_getString(Input))
			if msg then
				SL:SendLuaNetMsg(101, 502, 0, 3, msg)
			end
		end)

		local Layout, Button, cs, rq,lfje = {}, {}, 1, 1,{}
		Layout[1] = GUI:Layout_Create(lieeq, "Layout_1", 0, 45.00, 222 * 4 + 20, 200.00, false)
		for i, v in ipairs(npc.cz_data.fj) do
			if cs == 5 then
				cs = 1
				rq = rq + 1
				Layout[rq] = GUI:Layout_Create(lieeq, "Layout_" .. rq, 0.00, 0.00, 222 * 4 + 20, 200.00, false)
			end
            if i == 7 and not (npc.data["cz6"] and npc.data["cz1"] and npc.data["cz2"] and npc.data["cz3"] and npc.data["cz4"] and npc.data["cz5"]) then
                local lcjl = GUI:Image_Create(Layout[rq], "czjmlf", (cs-1)*(222 + 5), 3, "res/wy/public/czjmlf.png")
                GUI:setAnchorPoint(GUI:ItemShow_Create(lcjl, "item1", 129, 85, {index=SL:GetMetaValue("ITEM_INDEX_BY_NAME",teshudata[502].lcjl[1][1]),count=1,look= true}), 0.5, 0.5)
                GUI:setAnchorPoint(GUI:ItemShow_Create(lcjl, "item2", 322, 85, {index=SL:GetMetaValue("ITEM_INDEX_BY_NAME",teshudata[502].lcjl[1][2]),count=100,look= true}), 0.5, 0.5)
                break
            end

			Button[i] = GUI:Image_Create(Layout[rq], "img_lf"..i,  (cs-1)*(222 + 5), 3, "res/wy/public/czjmlf_"..i..".png")

            GUI:setAnchorPoint(GUI:Image_Create(Button[i], "wz",  112, 140, "res/wy/public/czjmlf_wz_"..i..".png")
            , 0.5, 0.5)
            GUI:setTouchEnabled(Button[i], true)
            GUI:addOnClickEvent(Button[i], function()
                SL:SendLuaNetMsg(101, 502, 0, 2, npc.cz_data.fj[i])
            end)

            local richText = GUI:RichTextFCOLOR_Create(Button[i], "rich0", 110, 80, "<非绑仙玉/FCOLOR=250><*"..(npc.cz_data.fj[i] * 100).."/FCOLOR=149>   <绑定仙玉/FCOLOR=250><*"..(npc.cz_data.fj[i] * 100).."/FCOLOR=149>", 400, 13, "#f7f7de", 3,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})
            GUI:setAnchorPoint(richText, 0.5, 1)


            if not npc.data["cz"..i] then
                local jl = ItemNumByTable_img(teshudata[502].jl[i],nil,Button[i])
                GUI:setPosition(jl, 6, 10)
            else
                GUI:Image_Create(Button[i], "img_ylq", 50, 0, "res/wy/public/13.png")
            end


            if i == 10 then
                cs = cs + 1
                local lcjl = GUI:Image_Create(Layout[rq], "czjmlf", (cs-1)*(222 + 5), 3, "res/wy/public/czjmlf.png")
                GUI:setAnchorPoint(GUI:ItemShow_Create(lcjl, "item1", 129, 85, {index=SL:GetMetaValue("ITEM_INDEX_BY_NAME",teshudata[502].lcjl[2][1]),count=1,look= true}), 0.5, 0.5)
                GUI:setAnchorPoint(GUI:ItemShow_Create(lcjl, "item2", 322, 85, {index=SL:GetMetaValue("ITEM_INDEX_BY_NAME",teshudata[502].lcjl[2][2]),count=1,look= true}), 0.5, 0.5)

                if npc.data["cz7"] and npc.data["cz8"] and npc.data["cz9"] and npc.data["cz10"] then
                    GUI:Image_Create(lcjl, "wc1",129-40, 85-20, "res/wy/public/9.png")
                    GUI:Image_Create(lcjl, "wc2",322-40, 85-20, "res/wy/public/9.png")
                end
                break
            end
			cs = cs + 1
		end
        if npc.data["cz6"] and npc.data["cz1"] and npc.data["cz2"] and npc.data["cz3"] and npc.data["cz4"] and npc.data["cz5"] then
            GUI:ListView_jumpToItem(lieeq, 2)
        else
            GUI:Image_Create(npc.bg, "tip", 455.00, 38.00, "res/wy/public/czjm_tip.png")
        end
        if p3 == 1 then
            GUI:ListView_doLayout(lieeq)
            local ksyd  = SL:StartGuide({dir = 1 ,guideWidget = Button[1] ,guideParent=npc.bg,guideDesc="点击按钮" ,isForce = false })
            if ksyd then
                SL:ScheduleOnce(function ()
                    SL:CloseGuide(ksyd)
                end, 3)
            end
        end
    elseif p2 == 2 then
        npc.ljcz_l = npc.ljcz_l + 1
        ljcz_update()
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
---赞助礼包
npc[503] = function(p2, p3, Data) -- 赞助礼包
	if p2 == 0 then
        npc.data = SL:JsonDecode(Data, false)
		local parent = GUI:GetWindow(nil, "npc_zzlb")
		if parent then
			GUI:removeAllChildren(parent)
			GUI:setPosition(parent, cogin.w / 2, cogin.h / 2)
		else
			parent = GUI:Win_Create("npc_zzlb", cogin.w / 2, cogin.h / 2, 0, 0, false, false, true, true, true, 0, 1)
		end
        local bjt = GUI:Image_Create(parent, "bjt", 0, 0, "res/public/1900000651_1.png")
        GUI:setAnchorPoint(bjt, 0.5, 0.5)
        GUI:setContentSize(bjt, cogin.w + 100, cogin.h + 100)
        GUI:setTouchEnabled(bjt, true)
        GUI:addOnClickEvent(bjt, function()
            GUI:Win_Close(parent)
        end)
        --npc.bg = GUI:Image_Create(parent, "bj", 0, 0, 'res/wy/public/anniu_503_bj.png')
        npc.bg = GUI:Frames_Create(parent, "bj", 0, 0, "res/wy/eff/city/anniu_503_bj_", ".png", 1, 41, {speed = 50, count = 41, loop = -1})
        GUI:setAnchorPoint(npc.bg, 0.5, 0.5)
        GUI:setTouchEnabled(npc.bg, true)
        GUI:Timeline_Window3(npc.bg)

		local close = GUI:Button_Create(npc.bg, 'close', 820, 430, 'res/wy/public/close.png')
		GUI:addOnClickEvent(close, function()
			GUI:Win_Close(parent)
		end)
        npc.btn = {}
        npc.ists = false
        local zzch = {"黄金赞助","铂金赞助","钻石赞助"}
        for i = 1, 3, 1 do
            GUI:Image_Create(npc.bg, "bjt"..i, 234 + (i-1)*250 - 115, 337 - 279, "res/wy/public/anniu_503_l_"..i..".png")
            GUI:ItemShow_Create(npc.bg, "item"..i, 234 + (i-1)*250, 337, {index=SL:GetMetaValue("ITEM_INDEX_BY_NAME",zzch[i].."[称号]"),look=true})
            if i ~= 1 then
                GUI:setAnchorPoint(GUI:Image_Create(npc.bg, "tj"..i, 251 + (i-1)*252, 160, "res/wy/public/npc_503_l"..i..".png")
                , 0.5, 1)
            end

            if npc.data["zzlb"..i] and npc.data["zzlb"..i] > 0 then
                GUI:Image_Create(npc.bg, "lingqu"..i, 252 + (i-1)*252, 105, "res/wy/public/9.png")
            else
                npc.btn[i] = GUI:Button_Create(npc.bg, "Button"..i, 251 + (i-1)*252, 100, "res/wy/public/npc_503_an.png")
                GUI:setAnchorPoint(npc.btn[i], 0.5, 1)
                GUI:addOnClickEvent(npc.btn[i], function()
                    SL:SendLuaNetMsg(101, 503, 1, i, "")
                end)
                if p3 >= 50 * (i-1) then
                    GUI:setAnchorPoint(GUI:Image_Create(npc.btn[i], "ists", 213 - 36, 37, "res/public/ists.png")
                    , 0.5, 0.5)
                    if not npc.ists and i == 1 then
                        SL:StartGuide({dir = 1 ,guideWidget = npc.btn[i] ,guideParent=npc.bg,guideDesc="领取奖励",isForce = false})
                        npc.ists = true
                    end
                end
            end
        end
    elseif p2 == 1 then
        if npc.btn[p3] then
            GUI:removeFromParent(npc.btn[p3])
            GUI:Image_Create(npc.bg, "lingqu"..p3, 252 + (p3-1)*252, 105, "res/wy/public/9.png")
        end
    elseif p2 == 2 then
        local parent = GUI:GetWindow(nil, "npc_zzlb")
        if parent then
            GUI:Win_Close(parent)
        end
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
                GUI:setAnchorPoint(GUI:RichText_Create(Node, "jl"..i, 440, 360-(i-1)*22,  ItemNumByTable({{cogin.teshudata[506][i],1}}), 500, 14, "#f7f7de", 3,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})
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
end
---福利大厅
npc[511] = function(p2, p3, Data) -- 福利大厅
end
---游戏攻略
npc[512] = function(p2, p3, Data) -- 游戏攻略
	if p2 == 0 then
		local parent = GUI:GetWindow(nil, "npc_fldt")
        npc.fldtpz = not Data and {} or SL:JsonDecode(Data, false)
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
		npc.bg = GUI:Image_Create(parent, "img_bj", 0.00, 0.00, "res/wy/public/yxgl_bj.png")
		GUI:setAnchorPoint(npc.bg, 0.5, 0.5)
		GUI:setTouchEnabled(npc.bg, true)
		GUI:Timeline_Window3(npc.bg)

        npc.yxgly = GUI:Layout_Create(npc.bg, "Layout", 230.00, 21.00, 700.00, 500.00, true)
        local close = GUI:Button_Create(npc.bg, 'close', 870, 450, 'res/wy/public/close.png')
        GUI:addOnClickEvent(close, function()
            GUI:Win_Close(parent)
        end)
        GUI:Button_loadTextureNormal(npc.yxgl[npc.glxc], "res/wy/public/yxglan_".. 1 ..".png")

    end
end
local xlxl = {
    {"元宝","灵符","绑定元宝","绑定灵符","仙玉","绑定仙玉","累计充值","礼包积分","一合充值","二合充值","三合后充值"},
    {"充值18","充值38","充值68","充值128","充值288","充值588","充值888","充值1188","充值1588","充值1888"},
    {{"个人变量",105,178},{"个人标识",225,178},{"个人Buff",105,144},{"全局变量",225,144}},
    {"快人一步","弹射","月卡","终身卡","28元每日","58元每日","新服特惠","等级特权","98每日礼包"},
}
npc[998] = function(p2, p3, Data)
    local parent = GUI:GetWindow(nil, "npc_hhhh")
    npc.fldtpz = not Data and {} or SL:JsonDecode(Data, false)
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
npc[9999] = function(p2, p3, msgData) -- 通用关闭
    local parent = GUI:GetWindow(nil, msgData)
    if parent then
        GUI:Win_Close(parent)
    end
end
return npc