local npc = {}

---顶部图标显示
npc.iconpx = {
    {
        {15, "天天省钱",509,1}, {3, "福利大厅",511,2}, {17, "游戏攻略",512,3},{4, "活动大厅",507,4},{14, "首充礼包",501,5},{16, "仙途奇缘",515,15},{18, "飞剑",19,15}
    },
    {
        {19, "在线充值", 502,11}, {5, "交易行",510,12},{2, "解绑特权",504,13},{7, "狂暴之力",513,14},{12, "世界地图",514,15},{10, "免费赞助",516,16},{6, "聚宝盆",517,17}
    }
}
npc.LeftTop = GUI:Attach_LeftTop() -- 左上
npc.RightTop = GUI:Attach_RightTop() -- 右上
npc.RightBottom = GUI:Attach_RightBottom() -- 右下
npc.qiehuan = GUI:Win_FindParent(109)--手机端切换
npc.xinjn = GUI:Win_FindParent(1104)--主界面最顶右下
npc.xinjn32 = GUI:Win_FindParent(1003)--主界面最顶右下

-- 顶部按钮缓存，用于红点/引导等后续逻辑
npc.db_anniu = {} --按钮
---特殊任务描述
npc.rw = {

}  --任务描述

-- UIHelper 预设：统一管理不同窗口的默认皮肤 / 行为
local WINDOW_STYLE = {
    reward = {       -- 奖励展示
        windowName = "npc_jiangli",
        overlay = {skin = "res/public/1900000651_1.png"},
        background = {skin = "res/wy/public/01.png"},
        closeButton = false,
    },
    recycle = {      -- 装备回收
        windowName = "npc_huishou",
        overlay = {skin = "res/public/1900000651_1.png"},
        background = {skin = "res/wy/public/hs_bj.png"},
        closeButton = {x = 840 - 293, y = 490 - 150, skin = "res/wy/public/red_close.png"},
    },
    welfare = {      -- 福利大厅
        windowName = "npc_fldt",
        overlay = {skin = "res/public/1900000651_1.png"},
        background = {skin = "res/wy/public/tongyong_0.png"},
        closeButton = {x = 740, y = 460, skin = "res/wy/public/close_red_big.png"},
        title = {x = 56, y = 464, skin = "res/custom/fulitating/title.png"},
    },
    strategy = {     -- 游戏攻略
        windowName = "npc_yxgl",
        overlay = {skin = "res/public/1900000651_1.png"},
        background = {skin = "res/custom/strategy/bg_0.png"},
        closeButton = {x = 740, y = 460, skin = "res/wy/public/close_red_big.png"},
        title = {x = 56, y = 464, skin = "res/custom/strategy/title.png"},
    },
    firstCharge = {  -- 首充礼包
        windowName = "npc_sclb",
        overlay = {skin = "res/public/1900000651_1.png"},
        background = {skin = "res/custom/top/shochong/bg.png"},
        closeButton = {x = 740 - 114, y = 460 - 181, skin = "res/wy/public/close_red_big.png"},
    },
    onlineRecharge = { -- 在线充值
        windowName = "npc_zxcz",
        overlay = {skin = "res/public/1900000651_1.png"},
        background = {skin = "res/custom/chongzhi/bg.png", eff = true},
        closeButton = {x = 740, y = 460, skin = "res/wy/public/close_red_big.png"},
        title = {x = 56, y = 464, skin = "res/custom/chongzhi/title.png"},
    },
    unbind = {       -- 解绑特权
        windowName = "npc_jbtq",
        overlay = {skin = "res/public/1900000651_1.png"},
        background = {skin = "res/wy/public/tongyong_0.png"},
        closeButton = {x = 740, y = 460, skin = "res/wy/public/close_red_big.png"},
    },
    patrol = {       -- 巡航挂机
        windowName = "npc_mrtq",
        overlay = {skin = "res/public/1900000651_1.png"},
        background = {skin = "res/wy/public/tongyong_0.png"},
        closeButton = {x = 740, y = 460, skin = "res/wy/public/close_red_big.png"},
    },
    chosen = {       -- 天选之人
        windowName = "npc_txzz",
        overlay = {skin = "res/public/1900000651_1.png"},
        background = {skin = "res/wy/public/anniu_506_bj.png"},
        closeButton = {x = 800, y = 400, skin = "res/wy/public/close_red_big.png"},
    },
    activity = {     -- 游戏活动
        windowName = "npc_hd",
        overlay = {skin = "res/public/1900000651_1.png"},
        background = {skin = "res/custom/activity/bg.png"},
        closeButton = {x = 780, y = 460, skin = "res/wy/public/close_red_big.png"},
        title = {x = 56, y = 464, skin = "res/custom/activity/title.png"},

    },
    recordStone = {  -- 记录石
        windowName = "npc_jilushi",
        overlay = {skin = "res/public/1900000651_1.png"},
        background = {skin = "res/wy/public/jys_bj.png"},
        closeButton = {x = 467, y = 449, skin = "res/wy/public/close_red_big.png"},
    },
    storyLog = {     -- 异闻录
        windowName = "npc_ywl",
        overlay = {skin = "res/public/1900000651_1.png"},
        background = {skin = "res/custom/ywl/bg.png"},
        closeButton = {x = 900, y = 500, skin = "res/wy/public/close_red_big.png"},
    },
    newbieGift = {   -- 新手礼包
        windowName = "npc_xslb",
        overlay = {skin = "res/public/1900000651_1.png"},
        background = {skin = "res/custom/xinshoulibao/bg.png"},
        closeButton = {x = 740, y = 300, skin = "res/wy/public/close_red_big.png"},
    },
    worldMap = {     -- 世界地图
        windowName = "npc_sjdt",
        overlay = {skin = "res/public/1900000651_1.png"},
        background = {skin = "res/wy/public/102.png"},
        closeButton = {x = 330, y = 180, skin = "res/wy/public/close_red_big.png"},
    },
    fairyFate = {    -- 仙途奇缘
        windowName = "npc_qy",
        overlay = {skin = "res/public/1900000651_1.png"},
        background = {skin = "res/custom/fairyFate/bg.png", eff = true},
        closeButton = {x = 740, y = 460, skin = "res/wy/public/close_red_big.png"},
        title = {x = 56, y = 464, skin = "res/custom/fairyFate/title.png"},

    },
    freeSponsor = {  -- 免费赞助
        windowName = "npc_anniu_516",
        overlay = {skin = "res/public/1900000651_1.png"},
        background = {skin = "res/custom/mfzz/bg.png"},
        closeButton = {x = 740 + 176, y = 440, skin = "res/wy/public/close_red_big.png"},
    },
    treasureBasin = { -- 聚宝盆
        windowName = "npc_anniu_517",
        overlay = {skin = "res/public/1900000651_1.png"},
        background = {skin = "res/wy/public/*.png"},
        closeButton = {x = 330, y = 180, skin = "res/wy/public/close_red_big.png"},
    },
    flyingSword = { -- 飞剑
        windowName = "npc_19",
        overlay = {skin = "res/public/1900000651_1.png"},
        background = {skin = "res/custom/feijian/bg.png", timeline = true},
        closeButton = {x = 950, y = 470, skin = "res/wy/public/close_red_big.png"},
    }
}

-- windowCache[name]：保存 UIHelper 返回引用，避免重复创建
local windowCache = {}

-- 工具：深拷贝 table，避免直接修改 WINDOW_STYLE
local function cloneTable(src)
    local dst = {}
    for k, v in pairs(src or {}) do
        dst[k] = type(v) == "table" and cloneTable(v) or v
    end
    return dst
end

-- 工具：合并默认窗口配置 + 额外参数
local function mergeOptions(base, extra)
    local opts = cloneTable(base)
    for k, v in pairs(extra or {}) do
        if type(v) == "table" then
            opts[k] = cloneTable(v)
        else
            opts[k] = v
        end
    end
    return opts
end

-- 工具：封装 UIHelper.ensureWindow，内部维护缓存
local function ensureWindow(name, npcid, extraOpts)
    local opts = mergeOptions(WINDOW_STYLE[name], extraOpts)
    windowCache[name] = NPC_UI_HELPER.ensureWindow(windowCache[name], npcid or 0, opts)
    return windowCache[name]
end

-- 工具：创建顶部快捷按钮
local function createShortcutButton(container, cfg, order, prefix)
    local btnName = string.format("%s_%d", prefix, order)
    local button = GUI:Button_Create(container, btnName, 498 - 80 * order, 0, "res/wy/icon/top_" .. cfg[1] .. ".png")
    -- GUI:Text_Create(button, "tt", 0, 14, 14, "#ffffff", cfg[2])
    GUI:addOnClickEvent(button, function()
        SL:SendLuaNetMsg(101, cfg[3], 0, 0, "")
    end)
    npc.db_anniu[""..cfg[4]] = button
    return button
end

-- 根据 iconpx 配置重建顶部两排按钮
local function rebuildShortcutButtons(filterKey)
    if not npc.dbLayout then
        return
    end
    GUI:removeAllChildren(npc.dbLayout)
    npc.dbrqs = GUI:Layout_Create(npc.dbLayout, "Layout_s", 0.00, 70.00, 490.00, 80.00, false)
    npc.dbrqx = GUI:Layout_Create(npc.dbLayout, "Layout_x", 0.00, -10.00, 490.00, 80.00, false)

    local function renderRow(list, container, prefix)
        local order = 1
        for _, cfg in ipairs(list) do
            createShortcutButton(container, cfg, order, prefix)
            order = order + 1
        end
    end

    renderRow(npc.iconpx[1], npc.dbrqs, "anniu_1")
    renderRow(npc.iconpx[2], npc.dbrqx, "anniu_2")
end

local zbz = {}
if cogin.isWin32 then
    zbz = {-700, -150, 200, -180, -60}
else
    zbz = {-700, -150, 200, -160, -60}
end

-- ===== 指引/寻路相关工具 =====
local function ensureTopPanelExpanded()
    if npc.dbshousuo and GUI:getFlippedX(npc.dbshousuo) then
        GUI:setFlippedX(npc.dbshousuo, false)
        GUI:setPosition(npc.dbLayout, zbz[1], zbz[2])
    end
end

local function startGuideOnButton(data)
    ensureTopPanelExpanded()
    local target = npc.db_anniu[tostring(data.an)]
    if not target then
        return
    end
    SL:StartGuide({
        dir = data.fx,
        guideWidget = target,
        guideParent = npc.dbLayout,
        guideDesc = data.ms,
        isForce = false,
    })
end

local function triggerNavigate(point, meta)
    local rwxx = SL:GetMetaValue("ACTOR_MAP_X", SL:GetMetaValue("MAIN_ACTOR_ID"))
    local safeX = (point.x == rwxx) and (point.x + 1) or point.x
    SL:SetMetaValue("BATTLE_MOVE_BEGIN", point.map or point.x, safeX, point.y, meta, 1)
end

local function openBagGuide(desc, pcWidget, mobileWidget)
    SL:RefreshBagPos()
    if cogin.isWin32 then
        SL:StartGuide({dir = 1, guideWidget = pcWidget, guideParent = MainProperty._ui.Panel_act, guideDesc = desc, isForce = false})
        GUI:Timeline_FadeIn(pcWidget, 0.2)
    else
        SL:StartGuide({dir = 1, guideWidget = mobileWidget, guideParent = npc.RightTop, guideDesc = desc, isForce = false})
    end
end

local function openRoleGuide()
    if cogin.isWin32 then
        SL:StartGuide({dir = 2, guideWidget = MainProperty._ui.Button_role, guideParent = MainProperty._ui.Panel_act, guideDesc = "打开人物界面", isForce = false})
        GUI:Timeline_FadeIn(MainProperty._ui.Button_role, 0.2)
    else
        SL:StartGuide({dir = 1, guideWidget = npc.jueshe, guideParent = npc.RightTop, guideDesc = "打开人物界面", isForce = false})
    end
end

local guideDispatch = {
    [1] = function(data)-- 指定引导上面按钮
        startGuideOnButton(data)
    end,
    [2] = function(data) -- 指定寻路
        triggerNavigate({map = data.npcdt, x = data.xx, y = data.yy}, {type = 1, index = data.npcid})
    end,
    [3] = function(data)--指定背包引导
        openBagGuide("打开背包", MainProperty._ui.Button_bag, npc.sjbeibao)
        if data.rwid then
            cogin.sjtb.zxrwid = data.rwid
        end
    end,
    [4] = function(data)-- 指定引路到指定位置
        triggerNavigate({map = data.yd[1], x = data.yd[2], y = data.yd[3]}, {type = 0})
    end,
    [14] = function() ---打开人物界面
        openRoleGuide()
    end,
}


npc[0] = function(p2, p3, msgData) -- 任务处理
    if p2 == 1 then
        local zysj = SL:JsonDecode(msgData,false)
        local handler = guideDispatch[zysj.lx]
        if handler then
            handler(zysj)
        end
    elseif p2 == 9 then
        local da = SL:JsonDecode(msgData,false)
        -- 使用 UIHelper 构建奖励弹窗（windowCache.reward  --不再使用）
        local rewardWindow = ensureWindow("reward", 0, {titleText = "奖励预览",background = {skin = "res/wy/public/0-"..(p3 == 1000 and 2 or 1)..".png"},})
        local parent = rewardWindow.bg
        GUI:removeAllChildren(parent)

        local Layout1 = GUI:Layout_Create(parent, "Layout1", 831.00/2, 170, #da.item * 71, 60.00, false)
        GUI:setAnchorPoint(Layout1, 0.5, 0)
        for k, v in ipairs(da.item) do
            local k = GUI:Image_Create(Layout1, "item"..k, 0.00, 0.00, "res/wy/public/555.png")
            GUI:ItemShow_Create(k, "kuang", 20, 20, {index=SL:GetMetaValue("ITEM_INDEX_BY_NAME", v[1]),look=true,count=v[2]})
        end
        GUI:UserUILayout(Layout1, {dir=2,addDir=2,interval=1,gap = {x=20}})
        local Button = GUI:Button_Create(parent, "Button", 831.00/2, 80, "res/wy/public/0-1_an.png")
        GUI:setAnchorPoint(Button, 0.5, 0)
        GUI:addOnClickEvent(Button, function() 
            GUI:Win_Close(rewardWindow.parent)  
        end)
        GUI:setScaleX(parent, 0)
        GUI:Timeline_ScaleTo(parent, 1, 0.2)
    end
end

npc[1] = function(p2, p3, msgData) -- 初始化按钮
    --预渲染
    if p2 == 0 then
        if p3 == 0 then
            local guaji = {}
            if cogin.isWin32 then
                guaji[1] = GUI:Button_Create(npc.RightBottom, "guaji", -80, 500, "res/wy/icon/base.png")
                -- local dalucs = GUI:Button_Create(npc.RightBottom, "dalucs", -120, 500, "res/wy/icon/sjdt.png")
                -- GUI:addOnClickEvent(dalucs, function()
                --     Npclib["anniu"][4](0)
                -- end)

                ---暂时隐藏一下
                -- GUI:setVisible(guaji[1],false)
                -- GUI:setVisible(dalucs,false)

                ---测试使用
                local Button_1 = GUI:Button_Create(npc.RightBottom, "Button_1", -150, 340 + 100, "res/private/player_main_layer_ui/player_main_layer_ui_win32/1900015011.png")
                GUI:Button_setTitleText(Button_1, "测试")
                GUI:addOnClickEvent(Button_1, function()
                    SL:SendLuaNetMsg(105, 9999, 9999, 0, "")
                end)
                npc.an_cbl = GUI:Button_Create(npc.RightBottom, "an_cbl", -86, 320, "res/private/main/bottom/1900012580.png")
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
                if SL:GetMetaValue("IS_SHOW_MAUNAL_SERVICE") or true then
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
                --醉酒狂魔舞
                local zjkmw = GUI:Button_Create(npc.RightBottom, "zjkmw", -80, 550 - 135, "res/custom/five_city/zjkmw/img.png")
                GUI:addOnClickEvent(zjkmw, function()

                    if GUI:getChildByName(zjkmw, "img_bj") then
                        GUI:removeChildByName(zjkmw, "img_bj")
                        return
                    end

                    npc.bg = GUI:Image_Create(zjkmw, "img_bj", 100, 0, "res/custom/five_city/zjkmw/bg.png")
                    GUI:setTouchEnabled(npc.bg, true)
                    GUI:setAnchorPoint(npc.bg, 1, 0.5)
                    GUI:setOpacity(npc.bg, 0)
                    GUI:runAction(npc.bg, GUI:ActionSpawn(GUI:ActionMoveTo(0.3, 0, 0), GUI:ActionFadeIn(0.3)))
                    npc.node = GUI:Node_Create(npc.bg, "node", 0, 0)

                    local buff = SL:GetMetaValue("ACTOR_BUFF_DATA_BY_ID",SL:GetMetaValue("MAIN_ACTOR_ID"),20103)

                    local Button = GUI:Button_Create(npc.node, "Button", 0, 10.00, "res/custom/five_city/zjkmw/btn_"..(buff and 2 or 1)..".png")
                    GUI:addOnClickEvent(Button, function()
                        SL:SendLuaNetMsg(100, 70, 2, 0, "")
                        -- if buff then
                        --     GUI:Button_loadTextures(Button, "res/custom/five_city/zjkmw/btn_1.png")
                        -- end
                    end)

                    SL:RegisterLUAEvent(LUA_EVENT_MAINBUFFUPDATE, "主玩家buff刷新", function(data)
                        if data.buffID == 20103 then
                            local buff = SL:GetMetaValue("ACTOR_BUFF_DATA_BY_ID",SL:GetMetaValue("MAIN_ACTOR_ID"),20103)
                            GUI:Button_loadTextures(Button, "res/custom/five_city/zjkmw/btn_"..(buff and 2 or 1)..".png")
                            if buff then
                                GUI:Frames_Create(zjkmw, "eff", 0, 0, "res/custom/five_city/zjkmw/eff/eff_", ".png", 1, 75,
                                { speed = 75, count = 75, loop = 0})
                            else
                                GUI:removeChildByName(zjkmw, "eff")
                            end
                            
                        end
                    end)

                end)
            else
                npc.sjbeibao = GUI:Button_Create(npc.RightTop, "beibao", -160, -230, "res/private/main/bottom/bag.png")
                npc.jueshe = GUI:Button_Create(npc.RightTop, "jueshe", -240, -230, "res/private/main/bottom/js.png")
                GUI:addOnClickEvent(npc.sjbeibao, function()
                    SL:OpenBagUI()
                end)
                GUI:addOnClickEvent(npc.jueshe, function()
                    SL:OpenMyPlayerUI()
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
            rebuildShortcutButtons("")
        elseif p3 == 1 then
            rebuildShortcutButtons(msgData or "")
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
        shuju.xz = shuju.xz or {}

        -- 工具：重用/创建指定窗口，避免重复的 Win_Create
        local recycleWindow = ensureWindow("recycle", 2, {titleText = "装备回收"})
        local parent = recycleWindow.parent
        npc.bg = recycleWindow.bg
        GUI:setTouchEnabled(npc.bg, true)
        GUI:Win_SetDrag(parent, npc.bg)
        GUI:Win_SetZPanel(parent, npc.bg)
        GUI:removeChildByName(parent, "bjt")

        -- 工具：同步勾选状态到服务器并记录本地表
        local function syncSelection(key, isSelected)
            shuju.xz[key] = isSelected and 1 or nil
            SL:SendLuaNetMsg(101, 2, 2, 0, key)
        end

        -- 工具：如果父级/分组处于选中，则清除并通知服务器
        local function clearSelectionIfNeeded(key)
            if key and shuju.xz[key] and shuju.xz[key] == 1 then
                syncSelection(key, false)
            end
        end


        local hs_tab_map = {
            [1] = "zzhs",
            [2] = "zsfj",
            [3] = "sqhs",
            [4] = "gwfj",
            [5] = "ssfj",
            [6] = "clfj",
            [7] = "teshuhuihsou",
        }

        local function hasGroupSelection(config)
            if not config or not config.gl or not config[1] then
                return false
            end
            local prefix = tostring(config.gl) .. "_" .. tostring(config[1])
            if shuju.xz[prefix] then
                return true
            end
            if config[2] and shuju.xz[prefix .. "_" .. tostring(config[2])] then
                return true
            end
            return false
        end


        -- 列表刷新：根据背包数据生成回收选择槽
        function xiaohui_update()
            GUI:removeAllChildren(npc.bbzs)
            local rowLayouts = {}
            local bagItems = SL:GetMetaValue("BAG_DATA")
            npc.hs = {}
            local rowIndex = 0
            local slotIndex = 1
            local inRecycle = {}
            local itemWidgets = {}
            local huishou_jc_list = cogin.huishou_jc_list

            -- 移除指定道具索引，保持 npc.hs 与 UI 状态一致
            local function removeFromRecycleList(index)
                for idx = #npc.hs, 1, -1 do
                    if npc.hs[idx] == index then
                        table.remove(npc.hs, idx)
                        break
                    end
                end
            end

            -- 设置道具选中/取消状态，同时驱动高亮
            local function setRecycleSelection(index, shouldSelect)
                local widget = itemWidgets[index]
                if not widget then
                    return
                end
                GUI:ItemShow_setItemShowChooseState(widget, shouldSelect)
                if shouldSelect then
                    if not inRecycle[index] then
                        table.insert(npc.hs, index)
                    end
                    inRecycle[index] = true
                else
                    if inRecycle[index] then
                        removeFromRecycleList(index)
                    end
                    inRecycle[index] = false
                end
            end

            local function toggleRecycleSelection(index)
                setRecycleSelection(index, not inRecycle[index])
            end

            for bagIndex, bagItem in pairs(bagItems) do
                if slotIndex > 12 * rowIndex then
                    rowIndex = rowIndex + 1
                    rowLayouts[rowIndex] = GUI:Layout_Create(npc.bbzs, "h" .. rowIndex, 0, 0, 500, 41 ,false)
                end
                local config = huishou_jc_list[bagItem.Index]
                if config then
                    local slot = GUI:Image_Create(rowLayouts[rowIndex], "kuang" .. slotIndex, ((((slotIndex - 1) % 12)) * 41) + 4, 0, "res/wy/public/40-40.png")
                    local itemShow = GUI:ItemShow_Create(slot, "item" .. slotIndex, 20, 20, {itemData = bagItem, count = bagItem.Count, look = true, bgVisible = false})
                    if not cogin.isWin32 then
                        GUI:setScale(itemShow, 0.7)
                    end
                    GUI:setAnchorPoint(itemShow, 0.5, 0.5)
                    GUI:setTouchEnabled(slot, true)

                    itemWidgets[bagIndex] = itemShow
                    inRecycle[bagIndex] = false

                    GUI:addOnClickEvent(slot, function()
                        toggleRecycleSelection(bagIndex)
                    end)
                    GUI:ItemShow_addReplaceClickEvent(itemShow, function()
                        toggleRecycleSelection(bagIndex)
                    end)

                    local shouldSelect = hasGroupSelection(config) or shuju.xz["" .. bagItem.Index]

                    if shouldSelect then
                        setRecycleSelection(bagIndex, true)
                    end
                    slotIndex = slotIndex + 1
                end
            end
        end
        local ty_node = GUI:Node_Create(recycleWindow.node,"ty_node",0,0)
        local jm_node = GUI:Node_Create(recycleWindow.node,"jm_node",0,0)

        


        -- 刷新分类区域（左侧标签 + 右侧选项）并重置悬浮窗口
        local function new_hs_update()
            GUI:removeAllChildren(jm_node)

            local category_key = hs_tab_map[npc.s]
            if not category_key then
                return
            end

            local function sorted_pairs(tbl)
                local keys = {}
                for key in pairs(tbl or {}) do
                    keys[#keys + 1] = key
                end
                table.sort(keys, function(a, b)
                    if type(a) == "number" and type(b) == "number" then
                        return a < b
                    end
                    return tostring(a) < tostring(b)
                end)
                local idx = 0
                return function()
                    idx = idx + 1
                    local key = keys[idx]
                    if key ~= nil then
                        return key, tbl[key]
                    end
                end
            end

            local function normalize_category_data()
                local source = cogin.hs[category_key]
                if type(source) ~= "table" then
                    return {}
                end

                if category_key == "zzhs" then
                    local merged = {}
                    for k, v in pairs(source) do
                        merged[k] = v
                    end
                    for k, v in pairs(cogin.hs.fzfj or {}) do
                        merged[k] = v
                    end
                    return merged
                end

                local by_tab = source[npc.s]
                if type(by_tab) == "table" then
                    if by_tab.l then
                        return {[npc.s] = {by_tab}}
                    end
                    return {[npc.s] = by_tab}
                end

                if source.l then
                    return {[npc.s] = {source}}
                end

                if category_key == "teshuhuihsou" then
                    local group_idx = npc.s
                    for _, cfg in pairs(source) do
                        if type(cfg) == "table" and cfg[1] then
                            group_idx = cfg[1]
                            break
                        end
                    end
                    return {[group_idx] = {{name = "teshuhuihsou", l = source}}}
                end

                for k, v in pairs(source) do
                    if type(v) == "table" and type(v.l) == "table" then
                        return {[k] = {v}}
                    end
                end

                return source
            end

            local category_data = normalize_category_data()
            local subgroup_count = 0
            for _, group_data in pairs(category_data) do
                if type(group_data) == "table" then
                    for _, subgroup in pairs(group_data) do
                        if type(subgroup) == "table" and type(subgroup.l) == "table" then
                            subgroup_count = subgroup_count + 1
                        end
                    end
                end
            end
            subgroup_count = math.max(subgroup_count, 1)

            local list_height = math.max(230, 32 * math.ceil(subgroup_count / 3))
            local ScrollView = GUI:ScrollView_Create(jm_node, "ScrollView", 120.00, 108.00, 463.00, 230.00, 1)
            GUI:ScrollView_setInnerContainerSize(ScrollView, 463, list_height)
            GUI:setTouchEnabled(ScrollView, true)
            GUI:ScrollView_setBounceEnabled(ScrollView, true)
            local s_list = GUI:Layout_Create(ScrollView, "s_list", 0.00, 0.00, 463.00, list_height)

            local function open_subgroup_popup(anchor_btn, group_key, subgroup_key, subgroup_cfg)
                local xjm_parent = npc.hs_xbj
                if xjm_parent then
                    GUI:removeFromParent(xjm_parent)
                    npc.hs_xbj = nil
                end

                local pos = GUI:getWorldPosition(anchor_btn)
                npc.hs_xbj = GUI:Image_Create(jm_node, "bj", pos.x - 265, 35 + pos.y - 229, "res/private/item_tips/bg_tipszy_05.png")
                GUI:setAnchorPoint(npc.hs_xbj, 0, 1)
                GUI:setTouchEnabled(npc.hs_xbj, true)
                GUI:setContentSize(npc.hs_xbj, GUI:getContentSize(anchor_btn).width + 10, 5 * (35 + 10))
                GUI:Win_SetZPanel(jm_node, npc.hs_xbj)
                GUI:setLocalZOrder(npc.hs_xbj, 99)

                local x_close = GUI:Button_Create(npc.hs_xbj, "close", GUI:getContentSize(anchor_btn).width + 10, 5 * (35 + 10), "res/public/1900000511.png")
                GUI:setAnchorPoint(x_close, 0, 1)
                GUI:addOnClickEvent(x_close, function()
                    GUI:removeFromParent(npc.hs_xbj)
                    npc.hs_xbj = nil
                end)

                local s_s_s_list = GUI:ListView_Create(npc.hs_xbj, "s_s_s_list", 0, 3, GUI:getContentSize(anchor_btn).width + 10, 5 * (35 + 10) - 6, 1)
                GUI:ListView_setGravity(s_s_s_list, 2)
                GUI:ListView_setItemsMargin(s_s_s_list, 10)

                for item_idx, item_cfg in sorted_pairs(subgroup_cfg.l) do
                    local s_s_s_btn = GUI:Image_Create(s_s_s_list, "s_s_s_btn" .. item_idx, 0, 0, "res/wy/public/new_kuang.png")
                    local s_s_s_CheckBox = GUI:CheckBox_Create(s_s_s_btn, "CheckBox", GUI:getContentSize(s_s_s_btn).width - 40, 3, "res/wy/public/new_check_0.png", "res/wy/public/new_check_1.png")
                    GUI:CheckBox_setSelected(
                        s_s_s_CheckBox,
                        (shuju.xz[group_key] and shuju.xz[group_key] == 1)
                            or (shuju.xz[subgroup_key] and shuju.xz[subgroup_key] == 1)
                            or (shuju.xz[tostring(item_idx)] and shuju.xz[tostring(item_idx)] == 1)
                    )
                    GUI:CheckBox_addOnEvent(s_s_s_CheckBox, function(self)
                        syncSelection(tostring(item_idx), GUI:CheckBox_isSelected(self))
                        clearSelectionIfNeeded(group_key)
                        clearSelectionIfNeeded(subgroup_key)
                    end)
                    local item_name = item_cfg and item_cfg[3] or tostring(item_idx)
                    local s_s_s_wz = GUI:RichText_Create( s_s_s_btn, "s_s_s_wz", 77, 17, "<a href='jump#item_tips#" .. item_idx .. "'>" .. item_name .. "</a>", 500, 17, "#f7f7de", 3, nil, nil, {outlineSize = 2, outlineColor = SL:ConvertColorFromHexString("#100808")})
                    GUI:setAnchorPoint(s_s_s_wz, 0.5, 0.5)
                end
            end

            for v, group_data in sorted_pairs(category_data) do
                if type(group_data) == "table" then
                    for vv, subgroup_cfg in sorted_pairs(group_data) do
                        if type(subgroup_cfg) == "table" and type(subgroup_cfg.l) == "table" then
                            local s_s_btn = GUI:Image_Create(s_list, "s_s_btn" .. tostring(v) .. "_" .. tostring(vv), 0, 0, "res/wy/public/new_kuang.png")
                            local s_s_CheckBox = GUI:CheckBox_Create(s_s_btn, "CheckBox", GUI:getContentSize(s_s_btn).width - 40, 3, "res/wy/public/new_check_0.png", "res/wy/public/new_check_1.png")

                            local group_key = npc.s .. "_" .. tostring(v)
                            local subgroup_key = group_key .. "_" .. tostring(vv)

                            GUI:CheckBox_setSelected(
                                s_s_CheckBox,
                                (shuju.xz[group_key] and shuju.xz[group_key] == 1)
                                    or (shuju.xz[subgroup_key] and shuju.xz[subgroup_key] == 1)
                            )
                            GUI:CheckBox_addOnEvent(s_s_CheckBox, function(self)
                                local selected = GUI:CheckBox_isSelected(self)
                                syncSelection(subgroup_key, selected)
                                if selected then
                                    clearSelectionIfNeeded(group_key)
                                end
                            end)

                            local group_name = subgroup_cfg.name or ("分组" .. tostring(vv))
                            local s_s_wz = GUI:Text_Create(s_s_btn, "wz", 70, 17, 17, "#44DDFF", group_name)
                            GUI:setAnchorPoint(s_s_wz, 0.5, 0.5)
                            GUI:Text_enableOutline(s_s_wz, "#150800", 2)
                            GUI:Text_enableUnderline(s_s_wz)

                            GUI:setTouchEnabled(s_s_btn, true)
                            GUI:addOnClickEvent(s_s_btn, function()
                                open_subgroup_popup(s_s_btn, group_key, subgroup_key, subgroup_cfg)
                            end)
                        end
                    end
                end
            end

            GUI:UserUILayout(s_list, {dir = 3, addDir = 1, colnum = 3, gap = {x = -5, y = 0}})
        end

        npc.s = 1
        npc.s_s = 1
        npc.s_s_s = 1
        npc.hs_btn = {}
        
        
        local l_list = GUI:ListView_Create(ty_node, "ListView", 15.00, 15.00, 120.00, 325.00, 1)
        GUI:ListView_setItemsMargin(l_list, 8)
        GUI:ListView_setGravity(l_list, 2)
        for ii = 1,7 do
            GUI:Image_Create(l_list, "fgx"..ii, 0, 0, "res/wy/public/huishou/hsan_fgx.png")
            npc.hs_btn["s_"..ii] = GUI:Button_Create(l_list, "san"..ii, 0, 0, "res/wy/public/huishou/hsan_nsan_"..ii..".png")
            GUI:addOnClickEvent(npc.hs_btn["s_"..ii], function()
                GUI:Button_loadTextureNormal(npc.hs_btn["s_"..npc.s], "res/wy/public/huishou/hsan_nsan_"..npc.s..".png")
                 GUI:removeChildByName(GUI:ui_delegate(l_list)["fgx"..npc.s], "kuang")
                npc.s = ii
                npc.s_s = 1
                npc.s_s_s = 1
                GUI:Button_loadTextureNormal(npc.hs_btn["s_"..npc.s], "res/wy/public/huishou/hsan_lsan_"..npc.s..".png")
                GUI:Image_Create(GUI:ui_delegate(l_list)["fgx"..npc.s], "kuang", -5, -43, "res/wy/public/huishou/hsan_kuang.png")
                new_hs_update()
            end)
        end
        GUI:Button_loadTextureNormal(npc.hs_btn["s_"..npc.s], "res/wy/public/huishou/hsan_lsan_"..npc.s..".png")
        GUI:Image_Create(GUI:ui_delegate(l_list)["fgx"..npc.s], "kuang", -5, -43, "res/wy/public/huishou/hsan_kuang.png")
        local CheckBox_zdhs = GUI:CheckBox_Create(ty_node, "kaiguan1",380, 30, "res/wy/public/xz0.png", "res/wy/public/xz1.png")
        GUI:CheckBox_setSelected(CheckBox_zdhs, shuju.kg[4] == 1)
        GUI:CheckBox_addOnEvent(CheckBox_zdhs, function(self)
            SL:SendLuaNetMsg(101, 2, 4, 4, GUI:CheckBox_isSelected(self) and 1 or 0)
        end)

        local CheckBox2 = GUI:CheckBox_Create(ty_node, "kaiguan2",250, 30, "res/wy/public/xz0.png", "res/wy/public/xz1.png")
        GUI:CheckBox_setSelected(CheckBox2, shuju.kg[3] == 1)
        GUI:CheckBox_addOnEvent(CheckBox2, function(self)
            SL:SendLuaNetMsg(101, 2, 4, 3, GUI:CheckBox_isSelected(self) and 1 or 0)
        end)
        local CheckBox3 = GUI:CheckBox_Create(ty_node, "kaiguan3",250, 65, "res/wy/public/xz0.png", "res/wy/public/xz1.png")
        GUI:CheckBox_setSelected(CheckBox3, shuju.kg[2] == 1)
        GUI:CheckBox_addOnEvent(CheckBox3, function(self)
            SL:SendLuaNetMsg(101, 2, 4, 1, GUI:CheckBox_isSelected(self) and 1 or 0)
            SL:SendLuaNetMsg(101, 2, 4, 2, GUI:CheckBox_isSelected(self) and 1 or 0)
        end)

        npc.yjcz = GUI:Button_Create(ty_node, 'yjcz', 430, 20, 'res/wy/public/hsan_11.png')
        GUI:addOnClickEvent(npc.yjcz, function()
            if npc.s >= 1 and npc.s <= 7 then
                local item = SL:GetMetaValue("BAG_DATA")
                local hs = {}
                local huishou_jc_list = cogin.huishou_jc_list
                for k, v in pairs(item) do
                    if huishou_jc_list[v.Index] and (hasGroupSelection(huishou_jc_list[v.Index]) or shuju.xz["" .. v.Index]) then
                        table.insert(hs, k)
                    end
                end
                if #hs > 0 then
                    SL:SendLuaNetMsg(101, 2, 5, 1, SL:JsonEncode(hs,false))
                    SL:ShowSystemTips("<font color='#00ff00'>一键回收执行完成</font>")
                else
                    SL:ShowSystemTips("<font color='#ff0000'>未发现可分解物品</font>")
                end
            end
        end)

        new_hs_update()
    elseif p2 == 4 then  -- refresh
        if npc.bbzs then
            xiaohui_update()
        end
    end
    SL:RegisterLUAEvent(LUA_EVENT_CLOSEWIN, "recycle_close", function(self)
        if self == "npc_huishou"  then
            SL:UnRegisterLUAEvent(LUA_EVENT_CLOSEWIN, "recycle_close")
            local xjm_parent = npc.hs_xbj
            if xjm_parent then
                GUI:removeFromParent(xjm_parent)
                npc.hs_xbj = nil
            end
        end
    end)
end
---伏妖录任务
----任务名,npcid,任务类型（1为主线任务,2为支线任务）,任务检测（1数字型,2数组型,3称号型）,任务结束标志和进度标志,任务传送地点,任务传送限制（{1,10}等级,{2,10}转生,{3,”称号“}所需称号）
npc.xyl = SL:Require("GUILayout/Data/xyl.lua", true)
---异闻录：章节任务界面（UIHelper 统一窗口）
npc[11] = function(p2, p3, Data)
    if p2 == 0 then
        npc.data = Data and SL:JsonDecode(Data, false) or {}
        npc.l = npc.l or 2  -- 当前大章节
        npc.zj = npc.zj or 1 -- 当前小节

        local win = ensureWindow("storyLog", 11, { titleText = "异闻录" })
        npc.bg = win.bg
        npc.node_11 = win.node

        -- 左侧章节列表
        local chapterList = GUI:ListView_Create(npc.bg, "chapter_list", 25, 23, 230, 520 - 23, 1, false)
        GUI:ListView_setGravity(chapterList, 2)
        GUI:ListView_setItemsMargin(chapterList, 3)
        npc.ywl_list = chapterList

        -- 渲染右侧任务/奖励卡片
        local function renderTasks(node)
            GUI:removeAllChildren(node)

            local lCfg = npc.xyl[npc.l]
            if not lCfg then return end
            npc.zj = math.min(npc.zj, #lCfg)
            local zjCfg = lCfg[npc.zj]
            if not zjCfg then return end
            local tasks = zjCfg.jq or zjCfg
            local taskCount = #tasks
            local curJqd = tonumber(SL:GetMetaValue("TMONEY", "剧情点")) or 0
            local lockedByJqd = zjCfg.jqd and curJqd < zjCfg.jqd
            
            if lockedByJqd then
                GUI:Image_Create(node, "500-300", 250, 108, 'res/wy/public/500-300.png')
                GUI:Image_Create(node, "lock", 250, 100, 'res/wy/public/xz_img.png')
                GUI:setContentSize(GUI:ui_delegate(node)["lock"], 675, 414)
                GUI:setContentSize(GUI:ui_delegate(node)["500-300"], 675, 414)

                local need = tonumber(zjCfg.jqd) or 0
                local tip = string.format("剧情点不足：%d/%d", curJqd, need)
                local tipText = GUI:Text_Create(node, "lock_tip", 588, 150, 24, "#FFFFFF", tip)
                GUI:Text_setFontName(tipText, "fonts/500.ttf")
                GUI:Text_enableOutline(tipText, "#000000", 2)
                GUI:setAnchorPoint(tipText, 0.5, 0.5)
            else
                
                local scroll = GUI:ScrollView_Create(node, "task_scroll", 250, 120, 675, 414, 2)
                GUI:ScrollView_setBounceEnabled(scroll, true)
                GUI:ScrollView_setInnerContainerSize(scroll, taskCount * (232 + 0 ), 414)
                local layout = GUI:Layout_Create(scroll, "task_layout", 0, 0, taskCount * (232 + 10), 414, false)


                local function _ywl_vertical_text(text)
                    if not text then
                        return ""
                    end
                    local s = tostring(text)
                    local out = {}
                    local i = 1
                    while i <= #s do
                        local c = string.byte(s, i)
                        local len = 1
                        if c >= 0xF0 then
                            len = 4
                        elseif c >= 0xE0 then
                            len = 3
                        elseif c >= 0xC0 then
                            len = 2
                        end
                        local ch = string.sub(s, i, i + len - 1)
                        if ch == "（" or ch == "(" then
                            local close = (ch == "（") and "）" or ")"
                            local j = i + len
                            while j <= #s do
                                local cb = string.byte(s, j)
                                local clen = 1
                                if cb >= 0xF0 then
                                    clen = 4
                                elseif cb >= 0xE0 then
                                    clen = 3
                                elseif cb >= 0xC0 then
                                    clen = 2
                                end
                                local cj = string.sub(s, j, j + clen - 1)
                                if cj == close then
                                    j = j + clen
                                    break
                                end
                                j = j + clen
                            end
                            i = j
                        else
                            table.insert(out, ch)
                            i = i + len
                        end
                    end
                    return table.concat(out, "\n")
                end

                for idx, task in ipairs(tasks) do
                    local card = GUI:Image_Create(layout, "card" .. idx, 0, 0, 'res/custom/ywl/kuang.png')
                    -- GUI:setPosition(card, 232, 414)
                    local img = GUI:Image_Create(card, "img", 214/2, 410/2 - 20, 'res/custom/ywl/kuang1.png')
                    GUI:setAnchorPoint(img, 0.5, 0.5)
                    GUI:setTouchEnabled(img, true)
                    GUI:addOnClickEvent(img, function()
                        -- 创建遮盖层，动态从上到下，再次点击收回
                        local ui = GUI:ui_delegate(img)
                        local size = GUI:getContentSize(img)
                        local startY = size.height + size.height / 2
                        local endY = size.height / 2 + 20
                        local cover = ui.cover
                        local function toggleCover()
                            cover = ui.cover
                            if not cover then
                                return
                            end
                            if ui.cover_anim then
                                return
                            end
                            if not ui.cover_open then
                                ui.cover_anim = true
                                if ui.cover_hidden then
                                    for _, child in ipairs(ui.cover_hidden) do
                                        GUI:setVisible(child, false)
                                    end
                                end
                                GUI:setVisible(cover, true)
                                GUI:runAction(cover, GUI:ActionSequence(
                                        GUI:ActionMoveTo(0.2, size.width / 2, endY),
                                        GUI:CallFunc(function()
                                            ui.cover_open = true
                                            ui.cover_anim = false
                                            -- GUI:setTouchEnabled(img, false)
                                        end)
                                ))
                            else
                                ui.cover_anim = true
                                GUI:runAction(cover, GUI:ActionSequence(
                                        GUI:ActionMoveTo(0.2, size.width / 2, startY),
                                        GUI:CallFunc(function()
                                            -- GUI:setVisible(cover, false)
                                            GUI:removeFromParent(cover)
                                            if ui.cover_hidden then
                                                for _, child in ipairs(ui.cover_hidden) do
                                                    GUI:setVisible(child, true)
                                                end
                                            end
                                            ui.cover_open = false
                                            ui.cover_anim = false
                                            -- GUI:setTouchEnabled(img, true)
                                        end)
                                ))
                            end
                        end
                        if not cover then
                            local children = GUI:getChildren(img) or {}
                            ui.cover_hidden = {}
                            for _, child in ipairs(children) do
                                if child ~= cover then
                                    table.insert(ui.cover_hidden, child)
                                end
                            end
                            cover = GUI:Image_Create(img, "cover", size.width / 2, startY, "res/wy/public/500-300.png")
                            GUI:setContentSize(cover, size.width - 40, size.height - 60)
                            GUI:setAnchorPoint(cover, 0.5, 0.5)
                            GUI:setTouchEnabled(cover, true)
                            GUI:addOnClickEvent(cover, toggleCover)
                            ui.cover = cover
                            ui.cover_open = false

                            local title = GUI:Text_Create(cover, "title_wz",10, 300, 30, "#FFFFFF", "任务名称:")
                            -- GUI:Text_enableUnderline(title)
                            GUI:Text_setFontName(title, "fonts/448.ttf")
                            GUI:Text_enableOutline(title, "#000000", 2)
                            GUI:Text_Create(cover, "title",10, 300 - 25, 18, "#FF00FF", task[1] or task.title or "任务")

                            local jl = GUI:Text_Create(cover, "jl_wz",10, 220, 30, "#FFFFFF", "完成奖励")
                            GUI:Text_enableUnderline(jl)
                            GUI:Text_setFontName(jl, "fonts/448.ttf")
                            GUI:Text_enableOutline(jl, "#000000", 2)
                            
                            GUI:setPosition(ItemNumByTable_img_new(task.jl, nil,jl), 0, -60)

                            local desc = GUI:Text_Create(cover, "desc_wz",10, 100, 30, "#FFFFFF", "任务简介")
                            GUI:Text_enableUnderline(desc)
                            GUI:Text_setFontName(desc, "fonts/448.ttf")
                            GUI:Text_enableOutline(desc, "#000000", 2)

                            GUI:setAnchorPoint(GUI:RichText_Create(desc, "desc", 0, -5,  task.desc, 170, 17, "#f7f7de", 3,nil,nil)
                            , 0, 1)

                        end
                        toggleCover()
                    end)

                    
                    
                    local title = GUI:Text_Create(GUI:Image_Create(img, "name_kuang", 150, 200, "res/custom/ywl/name_kuang.png"), "title",38, 190, 30, "#FFFFFF", _ywl_vertical_text(task[1] or task.title or "任务"))
                    GUI:setLocalZOrder(title, 100)
                    GUI:setAnchorPoint(title, 0.5, 1)
                    GUI:Text_setFontName(title, "fonts/448.ttf")
                    GUI:Text_enableOutline(title, "#000000", 2)
                    -- GUI:setAnchorPoint(GUI:RichText_Create(card, "desc", 100, 180, "任务描述:" .. (task.desc or "可在任务界面查看"), 150, 16, "#00FFFF", 1, nil, nil, { outlineSize = 2, outlineColor = SL:ConvertColorFromHexString("#100808") }), 0.5, 1)

                    -- if task.jl then
                    --     local jlNode = ItemNumByTable_img(task.jl, nil, card)
                    --     GUI:setPosition(jlNode, 40, 55)
                    -- end

                    local enable = false
                    if task.id == 999 and task.khdjy then
                        enable = task.khdjy(task)
                    end
                    -- enable = true
                    if (npc.data and npc.data.ywl and npc.data.ywl["jl_" .. npc.l .. "_" .. npc.zj .. "_" .. idx] and npc.data.ywl["jl_" .. npc.l .. "_" .. npc.zj .. "_" .. idx] == 1) or 
                        (npc.data and npc.data.ywl and npc.data.ywl["jl_" .. npc.l .. "_" .. npc.zj] == 1)
                    then
                        GUI:setAnchorPoint(GUI:Image_Create(img, "ylq", 232/2, 90, 'res/custom/ywl/ylq.png')
                        , 0.5, 0.5)
                    else
                        if lockedByJqd then
                            local lockText = GUI:Text_Create(img, "lock", 232/2, 90, 22, "#FF3B30", "未解锁")
                            GUI:setAnchorPoint(lockText, 0.5, 0.5)
                        else
                            local btnSkin = enable and 'res/custom/ywl/btn_1.png' or 'res/custom/ywl/btn_2.png'
                            local goBtn = GUI:Button_Create(img, "goBtn", 232/2, 90, btnSkin)
                            GUI:setAnchorPoint(goBtn, 0.5, 0.5)
                            GUI:addOnClickEvent(goBtn, function()
                                SL:SendLuaNetMsg(101, 11, enable and 3 or 1, 0,
                                    string.format('{"i":%d,"j":%d,"k":0,"z":%d}', npc.l, npc.zj, idx))
                            end)
                        end
                    end
                    GUI:Image_Create(node, "wz", 340, 110, 'res/custom/ywl/wz.png')
                    
                end
                GUI:UserUILayout(layout, { dir = 2, addDir = 1, gap = { x = 0 + 18 } })

                if zjCfg.jl then
                    GUI:setPosition(ItemNumByTable_img(zjCfg.jl, nil, node), 560, 40)
                end

                if npc.data and npc.data.ywl and npc.data.ywl["jl_" .. npc.l .. "_" .. npc.zj] == 1 then
                    GUI:Image_Create(node, "done", 750, 40, 'res/wy/public/rwjd_3.png')
                else
                    npc.jl = GUI:Button_Create(node, "btn_reward", 710, 0, 'res/custom/ywl/btn_3.png')
                    GUI:addOnClickEvent(npc.jl, function()
                        SL:SendLuaNetMsg(101, 11, 2, 0, string.format('{"i":%d,"j":%d,"k":0}', npc.l, npc.zj))
                    end)
                end
            end

            
            local TMONEY = GUI:Text_Create(node, "TMONEY",50 + 278,40 + 9, 25, "#FF0000", SL:GetMetaValue("TMONEY", "剧情点"))
            GUI:Text_setFontName(TMONEY, "fonts/500.ttf")
            GUI:setAnchorPoint(TMONEY, 0.5, 0.5)

        end

        -- 渲染章节列表
        local function renderChapterList()
            GUI:removeAllChildren(chapterList)
            for i = 2, #npc.xyl do
                local btn = GUI:Button_Create(chapterList, "chap_" .. i, 0, 0, 'res/custom/ywl/list/dl_' .. i .. '.png')
                GUI:addOnClickEvent(btn, function()
                    if dl_sz and not dl_sz(i) then
                        SL:ShowSystemTips("<font color='#FF0000'>还未解锁该大章节</font>")
                        return
                    end
                    npc.l = i
                    npc.zj = 1
                    renderChapterList()
                    renderTasks(npc.node_11)
                end)
                if i == npc.l then
                    for y = 1, #npc.xyl[npc.l] do
                        local x_chap = GUI:Layout_Create(chapterList, "x_chap_" .. y, 0, 0, 84, 40, false)
                        
                        local x_btn = GUI:Button_Create(x_chap, "x_chap", 84/2, 40/2, 'res/custom/ywl/list/xz.png')
                        GUI:setAnchorPoint(x_btn, 0.5, 0.5)
                        local zj_name = GUI:Text_Create(x_chap, "wz", 84/2, 40/2, 23, "#FFFFFF", npc.xyl[npc.l][y].name)
                        GUI:Text_setFontName(zj_name, "fonts/500.ttf")
                        GUI:Text_enableOutline(zj_name, "#000000", 2)
                        GUI:setAnchorPoint(zj_name, 0.5, 0.5)
                        GUI:addOnClickEvent(x_btn, function()
                            GUI:Text_setTextColor(GUI:ui_delegate(GUI:ui_delegate(chapterList)["x_chap_" .. npc.zj]).wz, "#FFFFFF")
                            npc.zj = y
                            -- renderChapterList()
                            GUI:Text_setTextColor(GUI:ui_delegate(GUI:ui_delegate(chapterList)["x_chap_" .. npc.zj]).wz, "#FF0000")
                            
                            -- GUI:setAnchorPoint(GUI:Image_Create(x_btn, "xz", 84/2, 20/2, 'res/custom/ywl/list/xz.png')
                            -- , 0.5, 0.5)
                            -- GUI:Image_Create(x_btn, "xz_wz", 0, 0, 'res/custom/ywl/list/x_1_' .. y .. '.png')
                            renderTasks(npc.node_11)
                        end)
                        if y == npc.zj then
                            GUI:Text_setTextColor(GUI:ui_delegate(GUI:ui_delegate(chapterList)["x_chap_" .. npc.zj]).wz, "#FF0000")
                            -- GUI:setAnchorPoint(GUI:Image_Create(x_btn, "xz", 84/2, 20/2, 'res/custom/ywl/list/xz.png')
                            -- , 0.5, 0.5)
                            -- GUI:Image_Create(x_btn, "xz_wz", 0, 0, 'res/custom/ywl/list/x_1_' .. y .. '.png')
                        end

                    end
                end
            end
        end

        renderChapterList()
        renderTasks(npc.node_11)

        SL:RegisterLUAEvent(LUA_EVENT_CLOSEWIN, "关闭界面", function(self)
            if self == "npc_ywl" then
                SL:UnRegisterLUAEvent(LUA_EVENT_CLOSEWIN, "关闭界面")
            end
        end)

    elseif p2 == 2 then
        local data = SL:JsonDecode(Data, false)
        if p3 == 1 then
        elseif p3 == 2 then
            npc.data.ywl["jl_" .. data.i .. "_" .. data.j] = 1
            GUI:removeChildByName(npc.node_11,"btn_reward")
            GUI:Image_Create(npc.node_11, "done", 750, 40, 'res/wy/public/rwjd_3.png')
        elseif p3 == 3 then
            npc.data.ywl["jl_" .. data.i .. "_" .. data.j .. "_" .. data.z] = 1
            local img  = GUI:ui_delegate(GUI:ui_delegate(npc.node_11)["card" .. data.z]).img
            GUI:removeChildByName(img,"goBtn")
            GUI:setAnchorPoint(GUI:Image_Create(img, "ylq", 232/2, 90, 'res/custom/ywl/ylq.png')
            , 0.5, 0.5)
        end
        -- if npc.data and npc.data.ywl then
        --     npc.data.ywl["jl_" .. p3] = 1
        -- end
        -- if npc.jl then
        --     GUI:Image_Create(GUI:getParent(npc.jl), 'wc', 515, 5, 'res/wy/public/7_1.png')
        --     GUI:removeFromParent(npc.jl)
        -- end
    elseif p2 == 3 then
        npc.data = SL:JsonDecode(Data, false)
        npc[11](0, 0, Data)
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
---记忆传送：记录石（使用 UIHelper 标准窗口）
npc[13] = function(p2, p3, msgData)
    if p2 == 0 then
        SL:SendLuaNetMsg(101, 13, 0, 0, "")
        return
    end

    local function renderRecordStone(records)
        local win = ensureWindow("recordStone", 13, { titleText = "记录石" })
        local node = win.node
        GUI:removeAllChildren(node)

        npc.recordStoneLabels = {}
        local scroll = GUI:ScrollView_Create(node, "scroll", 6, 57, 458, 341, 1)
        GUI:ScrollView_setInnerContainerSize(scroll, 458, 495)
        local content = GUI:Image_Create(scroll, "content", 0, 0.5, "res/wy/public/jys_wz.png")

        for i = 1, 10 do
            local slot = records and records["dtm" .. i]
            local text = slot and (slot[2] .. "(" .. slot[3] .. "," .. slot[4] .. ")") or "暂未记录"
            npc.recordStoneLabels[i] = GUI:Text_Create(content, "pos_" .. i, 164, 524 - i * 50, 16, "#ffffff", text)
            GUI:setAnchorPoint(npc.recordStoneLabels[i], 0.5, 0.5)
            GUI:Text_enableOutline(npc.recordStoneLabels[i], "#000000", 1)

            local idxLabel = GUI:Text_Create(content, "idx_" .. i, 40, 524 - i * 50, 16, "#ffffff", i)
            GUI:setAnchorPoint(idxLabel, 0.5, 0.5)
            GUI:Text_enableOutline(idxLabel, "#000000", 1)

            local saveBtn = GUI:Button_Create(content, "btn_save_" .. i, 271, 504 - i * 50, "res/wy/public/jys_jl.png")
            GUI:addOnClickEvent(saveBtn, function()
                SL:OpenCommonTipsPop({
                    str = "是否记录该地图点位？将覆盖原有记录。",
                    btnType = 2,
                    callback = function(atype)
                        if atype == 1 then
                            SL:SendLuaNetMsg(101, 13, 1, i, "")
                        end
                    end
                })
            end)

            local gotoBtn = GUI:Button_Create(content, "btn_goto_" .. i, 369, 504 - i * 50, "res/wy/public/jys_cs.png")
            GUI:addOnClickEvent(gotoBtn, function()
                if records and records["dtm" .. i] then
                    SL:SendLuaNetMsg(101, 13, 2, i, "")
                else
                    SL:ShowSystemTips("<font color='#ff0000'>未记录该位置，无法传送！</font>")
                end
            end)
        end
    end

    if p2 == 1 then
        npc.jls = SL:JsonDecode(msgData, false)
        renderRecordStone(npc.jls)
    elseif p2 == 2 then
        if p3 and p3 > 0 and p3 <= 10 then
            npc.jls = SL:JsonDecode(msgData, false)
            if npc.recordStoneLabels and npc.jls["dtm" .. p3] then
                GUI:Text_setString(
                    npc.recordStoneLabels[p3],
                    npc.jls["dtm" .. p3][2] .. "(" .. npc.jls["dtm" .. p3][3] .. "," .. npc.jls["dtm" .. p3][4] .. ")"
                )
            end
        end
    elseif p2 == 3 then
        GUI:Win_CloseByID("npc_jilushi")
    end
end
---实力提升
npc[17] = function(p2, p3, Data)  --实力提升

end
---新手礼包
npc[18] = function(p2, p3, Data)
    local function renderNewbieGift(node)
        GUI:removeAllChildren(node)

        local Layout1 = GUI:Layout_Create(node, "Layout1", 429, 186, 100, 60.00, false)
        for i = 1,4 do
            GUI:setContentSize(GUI:Image_Create(Layout1, "skill"..i, 0.00, 0.00, "res/custom/xinshoulibao/skill_"..i..".png")
            , 42, 42)

        end
        GUI:UserUILayout(Layout1, {dir=2,addDir=1,gap = {x=23}})

        local jl_itme = {{"复活戒指",1},{"麻痹戒指",1},{"斗笠",1},{"攻速之镰[lv1]",1}, {"切割之斧[lv1]",1}}
        Layout1 = GUI:Layout_Create(node, "Layout2", 400, 100, 100, 60.00, false)
        for i = 1,5 do
            GUI:ItemShow_Create(Layout1, "itme"..i, 0, 0, {index=SL:GetMetaValue("ITEM_INDEX_BY_NAME", jl_itme[i][1]),look=true})
        end
        GUI:UserUILayout(Layout1, {dir=2,addDir=1,gap = {x = 23 + 10}})



        -- 主按钮：申请领取新手礼包
        
        local btn = GUI:Button_Create(node, "btn_get_gift", 420, 0, "res/custom/xinshoulibao/btn.png")
        GUI:addOnClickEvent(btn, function()
            SL:SendLuaNetMsg(101, 18, 1, 0, "")
        end)
    end

    if p2 == 0 then
        npc.data_18 = Data and SL:JsonDecode(Data, false) or {}
        local win = ensureWindow("newbieGift", 18, { titleText = "新手礼包" })
        renderNewbieGift(win.node)
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
            local kuang = GUI:Image_Create(node, "kuang"..v, 100 + (v-1) * 216, 50, "res/custom/feijian/itme_"..v.."_0.png")
            -- local contentSize = kuang:getContentSize()
            -- local itemShow = GUI:ItemShow_Create(kuang, "item", contentSize.width / 2, contentSize.height / 2, { index = SL:GetMetaValue("ITEM_INDEX_BY_NAME",k.name), look = true, bgVisible = false })
            -- itemShow:setAnchorPoint(cc.p(0.5, 0.5))
            -- GUI:Text_Create(kuang, "name",30,50, 20, "#FF0000", k.name)
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

            end
            local jian = GUI:Image_Create(kuang, "jian"..v, 0, 0, "res/custom/feijian/itme_"..v.."_1.png")
            GUI:Text_Create(kuang, "jh",150,130, 18, state_info[jh].color, state_info[jh].text)
            GUI:Image_Create(kuang, "jian_Wz"..v, 0, 0, "res/custom/feijian/itme_"..v.."_2.png")
            if jh == 1 then
                GUI:setGrey(jian, true)
            end
            

            if v == 4 then
                local jd = GUI:Text_Create(kuang, "jd",40,105, 21, "#d1e3ec", "累计飞剑攻击：")
                GUI:Text_setFontName(jd, "fonts/502.ttf")
                GUI:Text_enableOutline(jd, "#081800", 1)

                local num = GUI:RichText_Create(kuang, "num", 226/2, 100,
                    SetCompletionProgress((npc.data_19.T_data.num or 0), cogin.teshudata["anniu_19"].num)
                , 500, 30, "#f7f7de", 3,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})
                GUI:setAnchorPoint(num, 0.5, 0.5)
            end

             

        end

        -- local Button= GUI:Button_Create(node, "Button1", 750, 200.00, "res/public/1900000660.png")
        -- GUI:Button_setTitleText(Button, "飞剑激活")
        -- GUI:Button_setTitleFontSize(Button, 14)

        -- GUI:addOnClickEvent(Button, function()
        --     SL:SendLuaNetMsg(101, 19, 1, 0, "")
        -- end)
        -- Button= GUI:Button_Create(node, "Button2", 750, 100.00, "res/public/1900000660.png")
        -- GUI:Button_setTitleText(Button, "飞剑取消")
        -- GUI:Button_setTitleFontSize(Button, 14)

        -- GUI:addOnClickEvent(Button, function()
        --     SL:SendLuaNetMsg(101, 19, 3, 0, "")
        -- end)
    end

    if p2 == 0 then
        npc.data_19 = not Data and {} or SL:JsonDecode(Data, false)
        local win = ensureWindow("flyingSword", 19, {titleText = "飞剑"})
        npc.bg = win.bg
        npc.node = win.node
        UI_updata(npc.node)
    elseif p2 == 1 then
        npc.data_19_tmp = not Data and {} or SL:JsonDecode(Data, false)
        SL:onLUAEvent(LUA_EVENT_PASSIVE_SKILL_DATA, { type = p3 ,count = npc.data_19_tmp.count ,psData = npc.data_19_tmp.psData})
    end
end
---神石
npc[20] = function(p2, p3, Data)  --神石

   
    local function UI_updata(node,idx) --界面渲染
        GUI:removeAllChildren(node)
        local dbLayout = GUI:Layout_Create(node, "dbLayout", 23, 13, 300, 150)
        for i = 1, 8 do
            if idx == 0 then
                local EquipShow = GUI:EquipShow_Create(dbLayout, "EquipShow"..i, 0,0, 102 + i, false, {look = true, movable = true, bgVisible = false, doubleTakeOff = true})
                GUI:EquipShow_setAutoUpdate(EquipShow)
            elseif idx == 1 then
                GUI:ItemShow_Create(dbLayout, "EquipShow"..i, 0,0, {itemData = SL:GetMetaValue("L.M.EQUIP_DATA", 102 + i),look=true})
            end
        end
        if idx == 0 then
            GUI:UserUILayout(dbLayout, {dir=3,addDir=1,colnum = 4,gap = {x=11, y=5}})
        elseif idx == 1 then
            GUI:setPosition(dbLayout, 40, 0)
            GUI:UserUILayout(dbLayout, {dir=3,addDir=1,colnum = 4,gap = {x=42, y=42}})
        end

    end

    if p2 == 0 then
        local logg
        if p3 == 0 then
            logg = PlayerSuperEquip.gzd
        elseif p3 == 1 then
            logg = PlayerSuperEquip_Look.gzd
        end
        if not logg then
            SL:ShowSystemTips("<font color='#FF0000'>神石数据异常，请稍后再试...</font>")
            return
        end
        --如果有就关闭
        if GUI:getChildByName(logg, "img_bj") then
            GUI:removeChildByName(logg, "img_bj")
            return
        end

        npc.bg = GUI:Image_Create(logg, "img_bj", 0, 0, 'res/wy/public/bg_shenshi.png')
        GUI:setTouchEnabled(npc.bg, true)
        GUI:setOpacity(npc.bg, 0)
        GUI:runAction(npc.bg, GUI:ActionSpawn(GUI:ActionMoveTo(0.3, -300, 0), GUI:ActionFadeIn(0.3)))
        npc.node = GUI:Node_Create(npc.bg, "node", 0, 0)
        UI_updata(npc.node, p3)

    end
end

---古玩
npc[21] = function(p2, p3, Data)  --古玩

   
    local function UI_updata(node,idx) --界面渲染
        GUI:removeAllChildren(node)

        local dbLayout = GUI:Layout_Create(node, "dbLayout", 33, 13, 300, 150)
        for i = 1, 6 do
            if idx == 0 then
                local EquipShow = GUI:EquipShow_Create(dbLayout, "EquipShow"..i, 0,0, 110 + i, false, {look = true, movable = true, bgVisible = false, doubleTakeOff = true})
                GUI:EquipShow_setAutoUpdate(EquipShow)
            elseif idx == 1 then
                GUI:ItemShow_Create(dbLayout, "EquipShow"..i, 0,0, {itemData = SL:GetMetaValue("L.M.EQUIP_DATA", 110 + i),look=true})
            end
        end
        if idx == 0 then
            GUI:UserUILayout(dbLayout, {dir=3,addDir=1,colnum = 3,gap = {x=19, y=5}})
        elseif idx == 1 then
            GUI:setPosition(dbLayout, 50, 0)
            GUI:UserUILayout(dbLayout, {dir=3,addDir=1,colnum = 3,gap = {x=50, y=42}})
        end


    end

    if p2 == 0 then
        local logg
        if p3 == 0 then
            logg = PlayerSuperEquip.gzd
        elseif p3 == 1 then
            logg = PlayerSuperEquip_Look.gzd
        end
        if not logg then
            SL:ShowSystemTips("<font color='#FF0000'>古玩数据异常，请稍后再试...</font>")
            return
        end
        --如果有就关闭
        if GUI:getChildByName(logg, "img_bj") then
            GUI:removeChildByName(logg, "img_bj")
            return
        end

        npc.bg = GUI:Image_Create(logg, "img_bj", 0, 0, 'res/wy/public/bg_guwan.png')
        GUI:setTouchEnabled(npc.bg, true)
        GUI:setOpacity(npc.bg, 0)
        GUI:runAction(npc.bg, GUI:ActionSpawn(GUI:ActionMoveTo(0.3, -270, 0), GUI:ActionFadeIn(0.3)))
        npc.node = GUI:Node_Create(npc.bg, "node", 0, 0)
        UI_updata(npc.node, p3)

    end
end

---法宝
npc[22] = function(p2, p3, Data)  --法宝
-- 时光之杖[未激活]
-- 首切法宝[未激活]
-- 秘宝·万鬼啸【鬼】[未激活]
-- 秘宝·破龙吟【兵】[未激活]
-- 酒仙剑[未激活]


   
    local function UI_updata(node,idx) --界面渲染
        GUI:removeAllChildren(node)

        local metaKey = idx == 1 and "L.M.EQUIP_DATA" or "EQUIP_DATA"
        local items = {
            {id = 71, x = 138, y = 131, name = "时光之杖[未激活]"},
            {id = 72, x = 246, y = 94, name = "首切法宝[未激活]"},
            {id = 73, x = 65, y = 60, name = "秘宝·万鬼啸【鬼】[未激活]"},
            {id = 74, x = 65, y = 131, name = "秘宝·破龙吟【兵】[未激活]"},
            {id = 75, x = 138, y = 60, name = "酒仙剑[未激活]"},
        }

        for _, cfg in ipairs(items) do
            local item = SL:GetMetaValue(metaKey, cfg.id)
            if item then
                local EquipShow = GUI:EquipShow_Create(node, "EquipShow"..cfg.id, cfg.x, cfg.y, cfg.id, false, {look = true, movable = true, bgVisible = false, doubleTakeOff = true})
                GUI:EquipShow_setAutoUpdate(EquipShow)
                GUI:setAnchorPoint(EquipShow, 0.5, 0.5)
            else
                local EquipShow = GUI:ItemShow_Create(node, "EquipShow"..cfg.id, cfg.x, cfg.y, {index = SL:GetMetaValue("ITEM_INDEX_BY_NAME", cfg.name), look = true})
                GUI:ItemShow_setIconGrey(EquipShow, true)
                GUI:setAnchorPoint(EquipShow, 0.5, 0.5)
            end
        end
    end

    if p2 == 0 then
        local logg
        if p3 == 0 then
            logg = PlayerEquip.gzd
        elseif p3 == 1 then
            logg = PlayerEquip_Look.gzd
        end
        if not logg then
            SL:ShowSystemTips("<font color='#FF0000'>法宝数据异常，请稍后再试...</font>") 
            return
        end
        --如果有就关闭
        if GUI:getChildByName(logg, "img_bj") then
            GUI:removeChildByName(logg, "img_bj")
            return
        end

        npc.bg = GUI:Image_Create(logg, "img_bj", 0, 0, 'res/wy/public/bg_fabao.png')
        GUI:setTouchEnabled(npc.bg, true)
        GUI:setOpacity(npc.bg, 0)
        GUI:runAction(npc.bg, GUI:ActionSpawn(GUI:ActionMoveTo(0.3, -340, 0), GUI:ActionFadeIn(0.3)))
        npc.node = GUI:Node_Create(npc.bg, "node", 0, 0)
        UI_updata(npc.node,p3)

    end
end

---砍树系统
npc[30] = function(p2, p3, Data)
    local function btn_updata_1_xjm() --界面渲染
        local config = teshudata["anniu_30"]
        npc.xjm_window = NPC_UI_HELPER.ensureWindow(nil, 30, {
            windowName = "npc_anniu_30_xjm",
            background = {skin = "res/custom/three_city/xianfu/kanshu/updata_1/bg.png"},
            closeButton = {x = 650, y = 320},
        })
        npc.xjm_node = npc.xjm_window.node

        GUI:setAnchorPoint(GUI:Image_Create(npc.xjm_node, "level_1", 210, 235, "res/custom/three_city/xianfu/kanshu/updata_1/level_"..npc.data_30.T_data.axe..".png"), 0.5, 0.5)
        GUI:setAnchorPoint(GUI:Image_Create(npc.xjm_node, "wz_1", 210, 150, "res/custom/three_city/xianfu/kanshu/updata_1/wz_"..npc.data_30.T_data.axe..".png"), 0.5, 0.5)

        GUI:Text_setFontName(GUI:Text_Create(npc.xjm_node, "cost", 370, 105, 30, "#FFFFFF", config.updata[1].details[npc.data_30.T_data.axe].cost[1][2])
        , "fonts/501.ttf")
        if npc.data_30.T_data.axe >= config.updata[1].max_level then
            GUI:setAnchorPoint(GUI:Button_Create(npc.xjm_node, "btn", 364, 10, "res/wy/public/15.png"), 0.5, 0)
        else
            GUI:setAnchorPoint(GUI:Image_Create(npc.xjm_node, "level_2", 488, 235, "res/custom/three_city/xianfu/kanshu/updata_1/level_"..(npc.data_30.T_data.axe + 1)..".png"), 0.5, 0.5)
            GUI:setAnchorPoint(GUI:Image_Create(npc.xjm_node, "wz_2", 488, 150, "res/custom/three_city/xianfu/kanshu/updata_1/wz_"..(npc.data_30.T_data.axe + 1)..".png"), 0.5, 0.5)

            local btn = GUI:Button_Create(npc.xjm_node, "btn", 364, 10, "res/custom/three_city/xianfu/kanshu/updata_1/btn.png")
            GUI:setAnchorPoint(btn, 0.5, 0)
            GUI:addOnClickEvent(btn, function()  SL:SendLuaNetMsg(101, 30, 1, 1, '')  end)
        end

        

    end
    local function btn_updata_2_xjm() --界面渲染
        local config = teshudata["anniu_30"]
        npc.xjm_window = NPC_UI_HELPER.ensureWindow(nil, 30, {
            windowName = "npc_anniu_30_xjm",
            background = {skin = "res/custom/three_city/xianfu/kanshu/updata_2/bg.png"},
            closeButton = {x = 650, y = 320},
        })
        npc.xjm_node = npc.xjm_window.node

        GUI:setAnchorPoint(GUI:Image_Create(npc.xjm_node, "level_1", 420, 350, "res/custom/three_city/xianfu/kanshu/updata_2/level_"..npc.data_30.T_data.auto..".png"), 0.5, 0.5)
        GUI:Text_setFontName(GUI:Text_Create(npc.xjm_node, "cost", 370, 105, 30, "#FFFFFF", config.updata[2].details[npc.data_30.T_data.auto].cost[1][2])
        , "fonts/501.ttf")

        if npc.data_30.T_data.auto >= config.updata[2].max_level then
            GUI:setAnchorPoint(GUI:Button_Create(npc.xjm_node, "btn", 364, 10, "res/wy/public/15.png"), 0.5, 0)
        else
            local btn = GUI:Button_Create(npc.xjm_node, "btn", 364, 10, "res/custom/three_city/xianfu/kanshu/updata_2/btn.png")
            GUI:setAnchorPoint(btn, 0.5, 0)
            GUI:addOnClickEvent(btn, function()  SL:SendLuaNetMsg(101, 30, 1, 2, '')  end)
        end

        

    end
    local function btn_buy_xjm() --界面渲染
        local config = teshudata["anniu_30"]
        npc.xjm_window = NPC_UI_HELPER.ensureWindow(nil, 30, {
            windowName = "npc_anniu_30_xjm",
            background = {skin = "res/custom/three_city/xianfu/kanshu/buy/bg.png"},
            closeButton = {x = 600, y = 260},
        })
        npc.xjm_node = npc.xjm_window.node
        GUI:Text_setFontName(GUI:Text_Create(npc.xjm_node, "cost", 422, 100, 30, "#FFFFFF", (npc.data_30.T_data.dh_num + 1) > #config.dh.details and config.dh.cost[1][2] or config.dh.details[npc.data_30.T_data.dh_num + 1].cost[1][2])
        , "fonts/501.ttf")
        GUI:setAnchorPoint(GUI:ItemShow_Create(npc.xjm_node, "item1", 250,196, {index=SL:GetMetaValue("ITEM_INDEX_BY_NAME","仙府币"),count = 1,look= true}), 0.5, 0.5)
        GUI:setAnchorPoint(GUI:ItemShow_Create(npc.xjm_node, "item2", 490,196, {index=SL:GetMetaValue("ITEM_INDEX_BY_NAME","砍树盲盒"),count = 1,look= true}), 0.5, 0.5)

        local btn = GUI:Button_Create(npc.xjm_node, "btn", 364, 10, "res/custom/three_city/xianfu/kanshu/buy/btn.png")
        GUI:setAnchorPoint(btn, 0.5, 0)
        GUI:addOnClickEvent(btn, function()  SL:SendLuaNetMsg(101, 30, 4, 0, '')  end)

    end
    if p2 == 0 then
        npc.data_30 = not Data and {} or SL:JsonDecode(Data, false)
        npc.data_30.T_data.axe = npc.data_30.T_data.axe or 1
        npc.data_30.T_data.auto = npc.data_30.T_data.auto or 0
        npc.data_30.T_data.num = npc.data_30.T_data.num or 0
        npc.data_30.T_data.dh_num = npc.data_30.T_data.dh_num or 0
        local config = teshudata["anniu_30"]
        local parent = GUI:GetWindow(nil, "anniu_30")
        if parent then
            GUI:removeAllChildren(parent)
        else
            parent = GUI:Win_Create("anniu_30", 0, 0, 0, 0, false, false, true, true, true, nil, 1)
        end
        local bjt = GUI:Image_Create(parent, "bjt", cogin.w / 2, cogin.h / 2, "res/custom/three_city/xianfu/kanshu/bg_1/eff_1.png")
        GUI:setAnchorPoint(bjt, 0.5, 0.5)
        GUI:setContentSize(bjt, cogin.w, cogin.h)
        GUI:setTouchEnabled(bjt, true)
        GUI:addMouseOverTips(bjt, "", {x = 0, y = 0}, {x = 0, y = 0})

        local bg = GUI:Frames_Create(bjt, "bg", cogin.w/2,  cogin.h/2, "res/custom/three_city/xianfu/kanshu/bg_"..npc.data_30.T_data.axe.."/eff_", ".png", 1, 75,
                { speed = 75, count = 75, loop = -1})
        GUI:setContentSize(bg, cogin.w, cogin.h)
        GUI:setAnchorPoint(bg, 0.5, 0.5)

        local closeBtn = GUI:Button_Create(bg, 'close', cogin.w - 100,  cogin.h - 150, 'res/wy/public/anniu_4_x_close.png')
        GUI:addOnClickEvent(closeBtn, function()
            GUI:Win_Close(parent)
        end)

        local heidi = GUI:Image_Create(bg, "heidi", 0, cogin.h, "res/custom/three_city/xianfu/kanshu/heidi.png")
        GUI:setAnchorPoint(heidi, 0, 1)
        GUI:setContentSize(heidi, cogin.w, GUI:getContentSize(heidi).height)
        local tip_wz = GUI:Image_Create(heidi, "tip_wz", cogin.w / 2, 30, "res/custom/three_city/xianfu/kanshu/tip_wz.png")
        GUI:setAnchorPoint(tip_wz, 0.5, 0.5)
        local lz_wz = GUI:Image_Create(bg, "lz_wz", 0, cogin.h - 200, "res/custom/three_city/xianfu/kanshu/lz_wz.png")
        GUI:setAnchorPoint(lz_wz, 0, 1)

        local re_wz = GUI:Image_Create(bg, "re_wz", cogin.w, 0, "res/custom/three_city/xianfu/kanshu/re_wz.png")
        GUI:setAnchorPoint(re_wz, 1, 0)

        local btn_knashu = GUI:Frames_Create(bg, "eff1", 400,  450, "res/custom/three_city/xianfu/kanshu/btn/eff_", ".png", 1, 75,
                { speed = 75, count = 75, loop = -1})
        GUI:setAnchorPoint(btn_knashu, 0.5, 0.5)
        GUI:setTouchEnabled(btn_knashu, true)
        GUI:addOnClickEvent(btn_knashu, function()
            SL:SendLuaNetMsg(101, 30, 2, 2, '')
        end)
        npc.node = GUI:Node_Create(bg, "node", 0, 0)

        -- SL:dump((config.updata[1].details[npc.data_30.T_data.axe].ratio * config.updata[2].details[npc.data_30.T_data.auto].ratio * config.base_time))

        SL:schedule(npc.node, function() SL:SendLuaNetMsg(101, 30, 2, 1, '') end, (config.updata[1].details[npc.data_30.T_data.axe].ratio * config.updata[2].details[math.max(npc.data_30.T_data.auto,1)].ratio * config.base_time))
        npc.wz1 = GUI:Text_Create(re_wz, "wz1", 133, 483, 20, "#FFFFFF", npc.data_30.T_data.num)
        npc.wz2 = GUI:Text_Create(re_wz, "wz2", 133, 449, 20, "#FFFFFF", npc.data_30.T_data.dh_num)

        local btn_updata_2 = GUI:Button_Create(re_wz, "btn_updata_2", 278 / 2, 300 - 210, "res/custom/three_city/xianfu/kanshu/btn_updata_2.png")
        local btn_buy = GUI:Button_Create(re_wz, "btn_buy", 278 / 2, 300 - 70, "res/custom/three_city/xianfu/kanshu/btn_buy.png")
        local btn_tip = GUI:Button_Create(re_wz, "btn_tip", 278 / 2, 300, "res/custom/three_city/xianfu/kanshu/btn_tip.png")
        local btn_updata_1 = GUI:Button_Create(re_wz, "btn_updata_", 278 / 2, 300 - 140, "res/custom/three_city/xianfu/kanshu/btn_updata_1.png")
        GUI:setAnchorPoint(btn_updata_2, 0.5, 0.5)
        GUI:setAnchorPoint(btn_buy, 0.5, 0.5)
        GUI:setAnchorPoint(btn_tip, 0.5, 0.5)
        GUI:setAnchorPoint(btn_updata_1, 0.5, 0.5)

        GUI:addOnClickEvent(btn_updata_2, function()  btn_updata_2_xjm()  end)
        GUI:addOnClickEvent(btn_buy, function()  
            btn_buy_xjm()
        end)
        GUI:addOnClickEvent(btn_tip, function()  
            npc.xjm_window = NPC_UI_HELPER.ensureWindow(nil, 30, {
                windowName = "npc_anniu_30_xjm",
                background = {skin = "res/custom/three_city/xianfu/kanshu/tip/bg.png"},
                closeButton = {x = 200, y = 10, skin = "res/custom/three_city/xianfu/kanshu/tip/btn.png"},
            })
        end)
        GUI:addOnClickEvent(btn_updata_1, function()  btn_updata_1_xjm()  end)

        if npc.data_30.T_data.auto == 0 then
            local open_auto = GUI:Button_Create(re_wz, "open_auto", -100, 300 - 210, "res/wy/public/an_tongyong.png")
            GUI:setAnchorPoint(open_auto, 0.5, 0.5)
            local Button_wz = GUI:Text_Create(open_auto, "desc",116,52, 25, "#FFFBF0", "开启自动砍树")
            GUI:setAnchorPoint(Button_wz, 0.5, 0.5)
            GUI:Text_setFontName(Button_wz, "fonts/500.ttf")
            GUI:Text_enableOutline(Button_wz, "#CA352C", 2)
            NPC_UI_HELPER.redpoint_create(open_auto)
            GUI:addOnClickEvent(open_auto, function()  SL:SendLuaNetMsg(101, 30, 3, 1, '')  end)
            GUI:setVisible(btn_updata_2, false)
        end

       
       
       

        
    elseif p2 == 1 then
        npc.data_30 = not Data and {} or SL:JsonDecode(Data, false)
        npc.data_30.T_data.axe = npc.data_30.T_data.axe or 1
        npc.data_30.T_data.auto = npc.data_30.T_data.auto or 0
        npc.data_30.T_data.num = npc.data_30.T_data.num or 0
        npc.data_30.T_data.dh_num = npc.data_30.T_data.dh_num or 0
        GUI:Text_setString(npc.wz1, npc.data_30.T_data.num)
        GUI:Text_setString(npc.wz2, npc.data_30.T_data.dh_num)
    elseif p2 == 2 then
        npc.data_30 = not Data and {} or SL:JsonDecode(Data, false)
        if p3 == 1 then
            btn_updata_1_xjm()
        elseif p3 == 2 then
            btn_updata_2_xjm()
        end
    
    elseif p2 == 3 then
        npc.json = SL:JsonDecode(Data,false) or {}
        for i= 1, #npc.json do
            local btn = GUI:ItemShow_Create(npc.node, "item"..os.clock(), math.random(300, 400),math.random(300, 400), {index=SL:GetMetaValue("ITEM_INDEX_BY_NAME",npc.json[i][1]),count = 1,look= true})
            local endPos = GUI:p(math.random(100, 500),math.random(100, 50))
            local controlPoint_1 = GUI:p(300, 600)
            local controlPoint_2 = GUI:p(300, 600)
            local endPosition = endPos
            local bezier = GUI:ActionBezierTo(0.5, controlPoint_1, controlPoint_2, endPosition)
            GUI:runAction(btn,  GUI:ActionSequence(bezier,GUI:DelayTime(10),GUI:CallFunc(function()GUI:removeFromParent(btn)  end)))
            GUI:Timeline_DelayTime(btn, 100, function()
                GUI:removeFromParent(btn)
            end)
        end
    elseif p2 == 4 then
        npc.data_30 = not Data and {} or SL:JsonDecode(Data, false)
        btn_buy_xjm()
    
    end
end



---天人之战面板
---天人之战
npc[498] = function(p2, p3, Data)
    -- 创建天人之战排行榜面板，并完成基本 UI 布局
    local function createRankingWindow()
        if GUI:getChildByName(MainAssist._ui["Panel_hide"], "tyec_bj") then
            GUI:removeChildByName(MainAssist._ui["Panel_hide"], "tyec_bj")
        end
        npc.tyec = GUI:Image_Create(MainAssist._ui["Panel_hide"], "tyec_bj", 18, 0.00, "res/wy/public/tycccc.png")
        GUI:setContentSize(npc.tyec, 260, 185)
        local height = GUI:getContentSize(npc.tyec).height
        GUI:setPositionY(npc.tyec, height)
        GUI:runAction(npc.tyec, GUI:ActionMoveBy(0.3, 0, -height))
        local desc = GUI:Text_Create(npc.tyec, "Text", 70.00, 164.00, 14, "#d6a573", "排名数据/10s刷新")
        GUI:Text_enableOutline(desc, "#000000", 1)
        local scoreLabel = GUI:Text_Create(npc.tyec, "Text_1", 72.00, 6.00, 14, "#d6a573", "当前个人积分:")
        GUI:Text_enableOutline(scoreLabel, "#000000", 1)
        npc.tyecgr = GUI:Text_Create(scoreLabel, "Textxx", 92.00, 0.00, 14, "#d6a573", "0")
        GUI:Text_enableOutline(npc.tyecgr, "#000000", 1)
        local list = GUI:ListView_Create(npc.tyec, "ListView", 0.00, 29.00, 261.00, 135.00, 1)
        GUI:ListView_setItemsMargin(list, 2)
        npc.tyecpmm = {}
        npc.tyecpmf = {}
        for i = 1, 5 do
            local row = GUI:Image_Create(list, "rank_row_" .. i, 0, 0, "res/wy/public/guang.png")
            GUI:setContentSize(row, 260, 25)
            local prefix = GUI:Text_Create(row, "rank_prefix", 10.00, 3.00, 14, "#d6a573", string.format("NO.%d    ", i))
            GUI:Text_enableOutline(prefix, "#000000", 1)
            npc.tyecpmm[i] = GUI:Text_Create(row, "player_" .. i, 55.00, 3.00, 14, "#d6a573", "")
            GUI:Text_enableOutline(npc.tyecpmm[i], "#000000", 1)
            npc.tyecpmf[i] = GUI:Text_Create(row, "score_" .. i, 200.00, 3.00, 14, "#d6a573", "")
            GUI:Text_enableOutline(npc.tyecpmf[i], "#000000", 1)
        end
    end

    local function updateRankingWidgets(data)
        local mc = 1
        for i = 1, 5 do
            if data.pmsj and data.pmsj[i * 2] and data.pmsj[i * 2] > 0 then
                GUI:Text_setString(npc.tyecpmm[i], data.pmsj[mc])
                GUI:Text_setString(npc.tyecpmf[i], data.pmsj[i * 2])
                mc = mc + 2
            else
                GUI:Text_setString(npc.tyecpmm[i], "")
                GUI:Text_setString(npc.tyecpmf[i], "")
            end
        end
        GUI:Text_setString(npc.tyecgr, data.grjf or 0)
    end

    if p2 == 0 then
        npc.tyecsj = SL:JsonDecode(Data, false)
        createRankingWindow()
        updateRankingWidgets(npc.tyecsj)
    elseif p2 == 1 then
        npc.tyecsj = SL:JsonDecode(Data, false)
        if not npc.tyec then
            createRankingWindow()
        end
        updateRankingWidgets(npc.tyecsj)
    elseif p2 == 2 then
        GUI:removeChildByName(MainAssist._ui["Panel_hide"], "tyec_bj")
        npc.tyec = nil
    end
end

---首冲礼包
npc[501] = function(p2, p3, Data) -- 首冲礼包
    local function get_501_state()
        local cfg = teshudata["anniu_501"] or {}
        local T_data = (npc.data_501 and npc.data_501.T_data) or {}
        local time_data = tonumber((npc.data_501 and npc.data_501.time_data) or 0) or 0
        local endtime = tonumber(cfg.endtime or 0) or 0
        local ok = T_data["ok"] == 1
        local max = (cfg.details and cfg.details["首充"] and #cfg.details["首充"]) or 0
        local buy_day = T_data["buy_day"] or time_data
        local cur_idx = (time_data - buy_day) + 1
        if cur_idx < 1 then cur_idx = 1 end
        if max > 0 and cur_idx > max then cur_idx = max end
        return cfg, T_data, time_data, endtime, ok, max, cur_idx
    end

    local function UI_updata_1(node) --界面渲染
        GUI:removeAllChildren(node)

        -- GUI:setAnchorPoint(
        --         GUI:RichText_Create(node, "desc", 200, 430,
        --                 "<font color='#00FF00' size='20' >当前开服天数："..npc.data_501.time_data.."</font>\n"..
        --                         "<font color='#00FF00' size='20' >第一天奖励："..((npc.data_501.T_data["首充"] and npc.data_501.T_data["首充"] == 1 and npc.data_501.T_data._lb and npc.data_501.T_data._lb >= 1) and "已领取" or "未领取").."</font>\n"..
        --                         "<font color='#00FF00' size='20' >第二天奖励："..((npc.data_501.T_data["首充"] and npc.data_501.T_data["首充"] == 1 and npc.data_501.T_data._lb and npc.data_501.T_data._lb >= 2) and "已领取" or "未领取").."</font>\n"..
        --                         "<font color='#00FF00' size='20' >第三天奖励："..((npc.data_501.T_data["首充"] and npc.data_501.T_data["首充"] == 1 and npc.data_501.T_data._lb and npc.data_501.T_data._lb >= 3) and "已领取" or "未领取").."</font>\n"..
        --                         "<font color='#00FF00' size='20' >三天之后购买的奖励："..((npc.data_501.T_data["补充"] and npc.data_501.T_data["补充"] == 1 and npc.data_501.T_data._lb and npc.data_501.T_data._lb == 1) and "已领取" or "未领取").."</font>\n"
        --         , 500, 20, "#f7f7de", 3,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})
        -- , 0, 1)
        local cfg, T_data, time_data, endtime, ok, max, cur_idx = get_501_state()
        npc.idx_501 = npc.idx_501 or 1
        if max > 0 and npc.idx_501 > max then
            npc.idx_501 = max
        end
        
        GUI:Image_Create(node, "wz_2", 200, 230, "res/custom/top/shochong/wz_2.png")

        GUI:setAnchorPoint(
                GUI:RichText_Create(node, "desc", 200, 430,
                        "<font color='#00FF00' size='20' >当前开服天数："..time_data.."</font>\n"..
                        "<font color='#00FF00' size='20' >当前可领取：第"..cur_idx.."天</font>"
                , 500, 20, "#f7f7de", 3,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})
        , 0, 1)

        for i = 1, 3 do --天数按钮
            local btn = GUI:Button_Create(node, "btn_"..i, 313 + (i-1)*90, 195, "res/custom/top/shochong/list/"..(npc.idx_501 == i and "l" or "n").."/"..i..".png")
            GUI:addOnClickEvent(btn, function()
                npc.idx_501 = i
                UI_updata_1(node)
            end)
            
        end
        local jl = {}
        if cfg.details and cfg.details["首充"] then
            jl = cfg.details["首充"][npc.idx_501].show or {}
        end
        for j=1,#jl do
            local itme = GUI:Image_Create(node, "itme"..j,  311 + (j-1)*70, 300 - 160, "dev/res/wy/public/50-50.png")
            local show = GUI:ItemShow_Create(itme, "item", 50/2, 50/2, {index=SL:GetMetaValue("ITEM_INDEX_BY_NAME",jl[j][1]),look= true})
            GUI:setAnchorPoint(show, 0.5, 0.5)
            
            GUI:setAnchorPoint(GUI:Text_Create(itme, "count", 60/2, 5, 13, "#FFFFFF", SL:GetSimpleNumber(jl[j][2],0)), 0.5, 0.5)
        end


        local claimed = (T_data["首充"] == 1) and ((T_data["other_lb"] or 0) >= npc.idx_501)
        local canClaim = ok and (T_data["首充"] == 1) and (time_data <= endtime) and (npc.idx_501 == cur_idx) and not claimed
        if canClaim then
            local Button= GUI:Button_Create(node, "Button", 750 - 460, 0.00, "res/custom/all_story_mission/2/btn_give.png")
            GUI:addOnClickEvent(Button, function()
                SL:SendLuaNetMsg(101, 501, 1, 0, "")
            end)
        else
            local stateText = claimed and "已经领取" or "还不能领取哦~"
            local stateColor = claimed and "#00FF00" or "#ff0500"
            local stateLabel = GUI:Text_Create(node, "claim_state", 750 - 460 + 80, 35, 26, stateColor, stateText)
            GUI:setAnchorPoint(stateLabel, 0.5, 0.5)
            GUI:Text_setFontName(stateLabel, "fonts/502.ttf")
            GUI:Text_enableOutline(stateLabel, "#000000", 2)
        end
    end
    local function UI_updata_2(node) --界面渲染
        GUI:removeAllChildren(node)

        local cfg, T_data, time_data, endtime, ok = get_501_state()
        GUI:setAnchorPoint(
                GUI:RichText_Create(node, "desc", 200, 430,
                        "<font color='#00FF00' size='20' >当前开服天数："..time_data.."</font>\n"..
                        "<font color='#00FF00' size='20' >补充礼包</font>"
                , 500, 20, "#f7f7de", 3,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})
        , 0, 1)


        local desc = GUI:Text_Create(node, "need_xxz",313,195, 25, "#FFFFFF", "可以领取丰厚的奖励")
        GUI:Text_setFontName(desc, "fonts/502.ttf")
        GUI:Text_enableOutline(desc, "#000000", 2)

        local jl = {}
        if cfg.details and cfg.details["补充"] then
            jl = cfg.details["补充"][1] or {}
        end
        for j=1,#jl do
            local itme = GUI:Image_Create(node, "itme_bc"..j,  311 + (j-1)*70, 300 - 160, "dev/res/wy/public/50-50.png")
            local show = GUI:ItemShow_Create(itme, "item", 50/2, 50/2, {index=SL:GetMetaValue("ITEM_INDEX_BY_NAME",jl[j][1]),look= true})
            GUI:setAnchorPoint(show, 0.5, 0.5)
            GUI:setAnchorPoint(GUI:Text_Create(itme, "count", 60/2, 5, 13, "#FFFFFF", SL:GetSimpleNumber(jl[j][2],0)), 0.5, 0.5)
        end

        local claimed = T_data["bc_ok"] == 1
        local canClaim = ok and (T_data["补充"] == 1) and (time_data > endtime) and not claimed
        if canClaim then
            local Button= GUI:Button_Create(node, "Button", 750 - 460, 0.00, "res/custom/all_story_mission/2/btn_give.png")
            GUI:addOnClickEvent(Button, function()
                SL:SendLuaNetMsg(101, 501, 1, 0, "")
            end)
        else
            local stateText = claimed and "已经领取" or "不能领取"
            local stateColor = claimed and "#00FF00" or "#ff0500"
            local stateLabel = GUI:Text_Create(node, "claim_state_bc", 750 - 460 + 80, 35, 26, stateColor, stateText)
            GUI:setAnchorPoint(stateLabel, 0.5, 0.5)
            GUI:Text_setFontName(stateLabel, "fonts/502.ttf")
            GUI:Text_enableOutline(stateLabel, "#000000", 2)
        end
    end

    if p2 == 0 then
        npc.data_501 = not Data and {} or SL:JsonDecode(Data, false)
        local firstChargeWin = ensureWindow("firstCharge", 501, {titleText = "首充礼包"})
        npc.bg = firstChargeWin.bg
        npc.node = firstChargeWin.node
        local cfg, T_data, time_data, endtime = get_501_state()
        local buy_day = tonumber(T_data["buy_day"] or time_data) or time_data
        local in_first3 = time_data <= endtime
        local bought_in_first3 = (T_data["首充"] == 1) and (buy_day <= endtime)
        if in_first3 or bought_in_first3 then -- 首充：开服前三天 或前三天有过首冲
            UI_updata_1(npc.node)
        else -- 补充
            UI_updata_2(npc.node)
        end
        
    end
end
---在线充值
npc[502] = function(p2, p3, Data) -- 在线充值
    -- 界面渲染：自定义金额 + 多档快速充值按钮
    local function UI_updata(node)
        if not node then
            return
        end
        GUI:removeAllChildren(node)


        local Input = GUI:TextInput_Create(node, "Input",180.00 + 324, 50.00 + 363, 50.00, 20.00, 13)
        GUI:TextInput_setPlaceHolder(Input, "最少10")
        GUI:setTouchEnabled(Input, true)

        local num = GUI:Text_Create(node, "num", 180.00 + 324 + 30, 80.00 + 363, 20, "#FFFFFF", SL:GetThousandSepString(SL:GetMetaValue("TMONEY", "累计充值")))
        GUI:setAnchorPoint(num, 0.5, 0.5)

        num = GUI:TextAtlas_Create(npc.bg, "num1", 690,30, SL:GetThousandSepString(SL:GetMetaValue("TMONEY", "真充积分")), "res/custom/public/text1.png", 14, 30, ".")
        GUI:setAnchorPoint(num, 0, 0.5)

        local cz_an = GUI:Button_Create(node, "cz_an", 300 + 274, 38 + 350, "res/custom/chongzhi/btn.png")
        GUI:addOnClickEvent(cz_an, function()
            local msg = tonumber(GUI:TextInput_getString(Input))
            if msg then
                SL:SendLuaNetMsg(101, 502, 0, 3, msg)
            end
        end)
        for i=1,3 do
            GUI:Image_Create(node, "way_"..i,  180 + (i-1)*30, 38 + 350 + 32, "res/custom/chongzhi/way_"..i..".png")
        end

        local ScrollView = GUI:ScrollView_Create(node, "ScrollView", 30, 50, 720, 350, 1)
        GUI:ScrollView_setInnerContainerSize(ScrollView, 720, 185 + (234 * 2))


        local dbLayout = GUI:Layout_Create(ScrollView, "dbLayout", 0,185, 108*4, (234 * 2))
        for i=1,8 do
            --
            local Button = GUI:Image_Create(dbLayout, "img_lf"..i,  0, 0, "res/custom/chongzhi/"..teshudata["anniu_502"].fj[i]..".png")
            GUI:setTouchEnabled(Button, true)
            if npc.data_502["cz502_"..teshudata["anniu_502"].fj[i]] and npc.data_502["cz502_"..teshudata["anniu_502"].fj[i]] == 1 then
                
            else
                GUI:Image_Create(Button, "double",  100, 100, "res/custom/chongzhi/double.png")
                local list = GUI:Layout_Create(Button, "list", 10,35, 40*4, 42)
                for j=1,#teshudata["anniu_502"].jl[i].give do
                    local itme = GUI:Image_Create(list, "itme"..j,  0, 0, "dev/res/wy/public/40-42.png")
                    local show = GUI:ItemShow_Create(itme, "item", 40/2, 42/2, {index=SL:GetMetaValue("ITEM_INDEX_BY_NAME",teshudata["anniu_502"].jl[i].give[j][1]),look= true})
                    GUI:setAnchorPoint(show, 0.5, 0.5)
                    
                    GUI:setAnchorPoint(GUI:Text_Create(itme, "count", 40/2, 5, 13, "#FFFFFF", SL:GetSimpleNumber(teshudata["anniu_502"].jl[i].give[j][2],0)), 0.5, 0.5)
                end
                if teshudata["anniu_502"].jl[i].ch then
                    local itme = GUI:Image_Create(list, "ch",  0, 0, "dev/res/wy/public/40-42.png")
                    local show = GUI:ItemShow_Create(itme, "item", 40/2, 42/2, {index=SL:GetMetaValue("ITEM_INDEX_BY_NAME",teshudata["anniu_502"].jl[i].ch.."[称号]"),look= true})
                    GUI:setAnchorPoint(show, 0.5, 0.5)
                end
                if teshudata["anniu_502"].jl[i].skill then
                    local itme = GUI:Image_Create(list, "skill",  0, 0, "dev/res/wy/public/40-42.png")
                    local show = GUI:ItemShow_Create(itme, "item", 40/2, 42/2, {index=SL:GetMetaValue("ITEM_INDEX_BY_NAME",teshudata["anniu_502"].jl[i].skill),look= true})
                    GUI:setAnchorPoint(show, 0.5, 0.5)
                end
                GUI:UserUILayout(list, {dir=3,addDir=1,colnum = 4,gap = {x=0, y=0}})
            end
            
            
            -- GUI:Text_Create(Button, "wz",30,100, 20, "#FF0000", teshudata["anniu_502"].fj[i].."元")

            -- local richText = GUI:RichTextFCOLOR_Create(Button, "rich0", 10, 10, "<非绑灵石/FCOLOR=250><*"..(teshudata["anniu_502"].fj[i] * 100).."/FCOLOR=149>   <绑定灵石/FCOLOR=250><*"..(teshudata["anniu_502"].fj[i] * 100).."/FCOLOR=149>", 400, 13, "#f7f7de", 3,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})
            -- --GUI:setAnchorPoint(richText, 0.5, 1)
            GUI:addOnClickEvent(Button, function()
                SL:SendLuaNetMsg(101, 502, 0, 2, teshudata["anniu_502"].fj[i])
            end)

        end
        GUI:UserUILayout(dbLayout, {dir=3,addDir=1,colnum = 4,gap = {x=0, y=0}})
        GUI:Image_Create(ScrollView, "k_1",  0, 0, "res/custom/chongzhi/k_1.png")
    end

    if p2 == 0 then
        npc.data_502 = not Data and {} or SL:JsonDecode(Data, false)
        local rechargeWin = ensureWindow("onlineRecharge", 502, {titleText = "在线充值"})
        npc.bg = rechargeWin.bg
        npc.node = rechargeWin.node
        UI_updata(npc.node)
    elseif p2 == 1 then
        npc.data_502 = not Data and {} or SL:JsonDecode(Data, false)
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
    -- 界面渲染：展示奖励列表 + 开通按钮
    if p2 == 0 then
        npc.kryb =  SL:JsonDecode(Data, false)
		local parent = GUI:GetWindow(nil, "npc_sclb")
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
        npc.bg = GUI:Frames_Create(parent, "bg", 0, 0, "res/wy/eff/city/gm_bj", ".png", 1, 60, {speed = 50, count = 60, loop = -1})
		GUI:setAnchorPoint(npc.bg, 0.5, 0.5)
		GUI:setTouchEnabled(npc.bg, true)

        GUI:Image_Create(npc.bg, "img_1", 150, 400, "res/custom/top/kryb/img_1.png")
        GUI:Image_Create(npc.bg, "img_2", 0, 300, "res/custom/top/kryb/img_2.png")
        GUI:Image_Create(npc.bg, "img_3", 0, 130, "res/custom/top/kryb/img_3.png")
        GUI:Image_Create(npc.bg, "img_4", 150, 20, "res/custom/top/kryb/img_4.png")
        -- GUI:Image_Create(npc.bg, "anniu_504_5", 800, 0, "res/wy/public/anniu_504_5.png")

        -- local jl_node = ItemNumByTable_img(npc.s_show[504].show,nil,npc.bg)
        -- GUI:setPosition(jl_node, 500, 130)

        local close = GUI:Button_Create(npc.bg, 'close', 850, 450, 'res/wy/public/close.png')
        GUI:addOnClickEvent(close, function()
            GUI:Win_Close(parent)
        end)

        if npc.kryb.mztq == 0 then
            npc.Button = GUI:Button_Create(npc.bg, "Button", 470, 20, "res/custom/top/kryb/btn.png")
            GUI:addOnClickEvent(npc.Button, function()
                SL:SendLuaNetMsg(101, 504, 1, 0, "")
            end)
        else
            GUI:Image_Create(npc.bg, "img_bj1", 457, 46, "res/wy/public/6.png")
        end
	end
end

---巡航挂机
local guaji_ms = {"挂机时被攻击 自动随机传送（30秒冷却）", "挂机时未击杀 切换地图（120秒触发）", "挂机死亡或者回城后60秒随机下图","每10分钟自动切换地图"}
npc._patrolRefs = npc._patrolRefs or {}
local patrolRefs = npc._patrolRefs
npc[505] = function(p2, p3, Data) -- 巡航挂机
    local function buildPatrolUI(data)
        local win = ensureWindow("patrol", 505, {titleText = "巡航挂机"})
        local panel = win.node
        GUI:setPosition(panel, 150, 50)

        npc.ksgj = GUI:Button_Create(panel, "ksgj", 439.00, 22.00, "res/public/1900000660.png")
        GUI:Button_setTitleText(npc.ksgj, data.gjkg and "停止挂机" or "开始挂机")
        GUI:Button_setTitleColor(npc.ksgj, "#ffffff")
        GUI:Button_setTitleFontSize(npc.ksgj, 14)
        GUI:Button_titleEnableOutline(npc.ksgj, "#000000", 1)
        GUI:addOnClickEvent(npc.ksgj, function()
            SL:SendLuaNetMsg(101, 505, 4, 0, "")
        end)

        local listView = GUI:ListView_Create(panel, "ListView", 26.00, 22.00, 300.00, 372.00, 1)
        GUI:ListView_setGravity(listView, 5)
        GUI:ListView_setItemsMargin(listView, 10)
        npc.fu_gx = {}
        npc.dtwb = {}
        for i = 1, 10 do
            local btn = GUI:Button_Create(listView, "Button" .. i, 0.00, 0.00, "res/public/bg_bti_07.png")
            GUI:setContentSize(btn, 300, 50)
            local check = GUI:CheckBox_Create(btn, "fu_gx" .. i, 4.00, 0, "res/public/btn_sifud_04.png", "res/public/btn_sifud_05.png")
            GUI:CheckBox_setSelected(check, data["fgx" .. i])
            GUI:addOnClickEvent(btn, function() SL:SendLuaNetMsg(101, 505, 2, i, "") end)
            GUI:CheckBox_addOnEvent(check, function() SL:SendLuaNetMsg(101, 505, 3, i, "") end)
            npc.fu_gx[i] = check
            npc.dtwb[i] = GUI:Text_Create(check, "dtmz" .. i, 50.00, 15.00, 16, "#ffffff", "当前记录地图：" .. (data["dt" .. i] or "点击记录"))
        end

        for i, label in ipairs(guaji_ms) do
            local toggle = GUI:CheckBox_Create(panel, "zhu_gx" .. i, 345.00, 340 - (i - 1) * 80, "res/public/btn_sifud_04.png", "res/public/btn_sifud_05.png")
            GUI:CheckBox_setSelected(toggle, data["zgx" .. (i == 3 and 4 or i == 4 and 5 or i)])
            GUI:Text_Create(toggle, "Text", 48.00, 15.00, 16, "#ffffff", label)
            GUI:CheckBox_addOnEvent(toggle, function()
                SL:SendLuaNetMsg(101, 505, 5, i == 3 and 4 or i == 4 and 5 or i, "")
            end)
        end
    end

    if p2 == 1 then
        npc.data = SL:JsonDecode(Data, false)
        buildPatrolUI(npc.data)
    elseif p2 == 2 then
        if npc.dtwb and npc.dtwb[p3] then
            GUI:Text_setString(npc.dtwb[p3], "当前记录地图：" .. (Data or ""))
        end
    elseif p2 == 3 then
        npc.data = SL:JsonDecode(Data, false)
        if npc.fu_gx and npc.fu_gx[p3] then
            GUI:CheckBox_setSelected(npc.fu_gx[p3], npc.data["fgx" .. p3])
        end
    elseif p2 == 4 then
        npc.data = SL:JsonDecode(Data, false)
        if npc.ksgj then
            GUI:Button_setTitleText(npc.ksgj, npc.data.gjkg and "停止挂机" or "开始挂机")
        end
    end
end

---天选之人
npc[506] = function(p2, p3, Data)
    local function renderChosenUI(payload)
        local win = ensureWindow("chosen", 506, {titleText = "天选之人"})
        npc.bg = win.bg
        npc.node = win.node
        GUI:removeAllChildren(npc.node)

        local bg = npc.bg

        local dq = 1
        local Node = GUI:Node_Create(bg, "Node", 0, 0)
        local function updatePage()
            GUI:removeAllChildren(Node)
            GUI:setAnchorPoint(GUI:Text_Create(Node, "ds", 810, 127, 20, "#E317B3", payload.T_txzr[dq]), 0.50, 0.50)
            GUI:setAnchorPoint(GUI:Text_Create(Node, "kqfz", 810,100, 20, "#E317B3", payload.kqsj .. "分钟"), 0.50, 0.50)
            local djs = GUI:Text_Create(Node, "djs", 810,73, 20, "#E317B3", 0)
            GUI:setAnchorPoint(djs, 0.50, 0.50)
            GUI:Text_COUNTDOWN(djs, ((payload.G_txzz_2 + 1) * 20 - payload.kqsj) * 60)
            for i = 1, 10 do
                GUI:setAnchorPoint(GUI:RichText_Create(Node, "jl"..i, 440, 360-(i-1)*22,  ItemNumByTable({{cogin.teshudata["anniu_506"][i],1}}), 500, 14, "#f7f7de", 3,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")}), 0.50, 0.50)
                local name = (payload.A_txzz and payload.A_txzz["md"..dq] and payload.A_txzz["md"..dq][i] and payload.A_txzz["md"..dq][i][1]) or "未开"
                local value = (payload.A_txzz and payload.A_txzz["md"..dq] and payload.A_txzz["md"..dq][i] and payload.A_txzz["md"..dq][i][2]) or "0"
                local nameLabel = GUI:Text_Create(Node, "name"..i, 600, 360-(i-1)*22, 14, "#E317B3", name)
                GUI:setAnchorPoint(nameLabel, 0.5, 0.5)
                GUI:Text_enableOutline(nameLabel, "#000000", 1)
                local valLabel = GUI:Text_Create(Node, "value"..i, 760, 360-(i-1)*22, 14, "#E317B3", value)
                GUI:setAnchorPoint(valLabel, 0.5, 0.5)
                GUI:Text_enableOutline(valLabel, "#000000", 1)
            end
        end

        for i = 1, 4 do
            local btn = GUI:Button_Create(bg, 'btn'..i, 200 + (i-1)*150, 400, "res/wy/public/anniu_506_l_"..i..".png")
            GUI:addOnClickEvent(btn, function()
                if i ~= dq then
                    dq = i
                    updatePage()
                end
            end)
        end
        updatePage()
    end

    if p3 == 0 then
        npc.txzz_data = not Data and {} or SL:JsonDecode(Data, false)
        renderChosenUI(npc.txzz_data)
    elseif p3 == 1 and npc.txzz_data then
        npc.txzz_data = SL:JsonDecode(Data, false)
        renderChosenUI(npc.txzz_data)
    end
end

---游戏活动
npc[507] = function(p2, p3, Data)
    local function GUI_createLabel_507(label,i)
        GUI:removeAllChildren(label)
        GUI:Image_Create(label, "img_bj", 0, 350, "res/custom/activity/img/img_"..i..".png")

        local btn = GUI:Button_Create(label, "btn", 350, 20, "res/custom/activity/btn.png")
        GUI:addOnClickEvent(btn, function()
            SL:SendLuaNetMsg(101, 507, 1, i, "")
        end)
        local cfg = {
            title = "活动名称",
            map = "活动地图",
            jl = {{"金币",1},{"天工之锤",1} ,{"金币",1},{"天工之锤",1} },
            time = "活动时间",
            tip = "活动具体规则说明",
        }

        local desc = GUI:RichText_Create(label, "time", 60, 180,
                            "<font color='#00FF00' size='20' >"..cfg.time.."</font>\n"
            , 500, 20, "#f7f7de", 3,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})
            GUI:setAnchorPoint(desc, 0.5, 1)

        local tip = GUI:RichText_Create(label, "tip", 60, 260,
                            "<font color='#00FF00' size='20' >"..cfg.tip.."</font>\n"
            , 500, 20, "#f7f7de", 3,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})
            GUI:setAnchorPoint(desc, 0, 1)

        local jl = ItemNumByTable_img(cfg.jl, nil,GUI:Node_Create(label, "jl", 0, 0))
            GUI:setPosition(jl, 90, 30)
    
    end
    local titles = {"天选之人", "土城跑酷","随机夺宝","武林盟主"}
    local function renderActivity(node)
        GUI:removeAllChildren(node)



        npc.cbl_list = GUI:ListView_Create(node, "cbl_list", -20, 50, 300, 420, 1)
        GUI:ListView_setGravity(npc.cbl_list, 2)
        npc.Label = GUI:Node_Create(node, "Label", 250, 15)

        npc.titles_sign = 1
        for i = 1, 14 do
            local cbl_item = GUI:Button_Create(npc.cbl_list, "item" .. i, 0, 0, "res/custom/activity/list/"..(npc.titles_sign == i and "l" or "n").."/"..(npc.titles_sign == i and "l_" or "n_")..i..".png")
            GUI:setContentSize(cbl_item, GUI:getContentSize(cbl_item).width * 0.8, GUI:getContentSize(cbl_item).height * 0.8)
            GUI:addOnClickEvent(cbl_item, function()
                GUI:Button_loadTextureNormal(GUI:ui_delegate(npc.cbl_list)["item" .. npc.titles_sign], "res/custom/activity/list/n/n_"..npc.titles_sign..".png")
                npc.titles_sign = i
                GUI_createLabel_507(npc.Label,i)

                GUI:Button_loadTextureNormal(GUI:ui_delegate(npc.cbl_list)["item" .. npc.titles_sign], "res/custom/activity/list/l/l_"..npc.titles_sign..".png")
            end)
        end
    end

    if p2 == 0 then
        npc.data_507 = not Data and {} or SL:JsonDecode(Data, false)
        local win = ensureWindow("activity", 507, {titleText = "游戏活动"})
        npc.bg = win.bg
        npc.node = win.node
        npc.title = win.title
        -- GUI:setLocalZOrder(npc.title, 99)
        
        renderActivity(npc.node)
        GUI_createLabel_507(npc.Label,1)
    end
end

---福利大厅
npc[511] = function(p2, p3, Data) -- 福利大厅
    local fldt_data_cfg = teshudata["fldt"] or {}
    local fldt_cfg_table = fldt_data_cfg["fldt_cfg"]
    local fldt_seven_cfg = (fldt_cfg_table and fldt_cfg_table.seven_login) or {}
    local fldt_online_limit = fldt_seven_cfg.online_limit or 10

    local function fldt_decode_json(raw)
        if type(raw) == "table" then
            return raw
        end
        if not raw or raw == "" then
            return {}
        end
        return SL:JsonDecode(raw, false) or {}
    end

    local function fldt_get_state()
        npc.fldt_data = npc.fldt_data or {}
        npc.ts_data = npc.ts_data or {}
        npc.sign = npc.sign or 1
        npc.fldt_data.T_qrbq = npc.fldt_data.T_qrbq or {}
        return npc.fldt_data.T_qrbq
    end

    local function fldt_get_flip_digits()
        local fp = fldt_get_state()["7rqd_fp"]
        if type(fp) ~= "table" then
            fp = {}
        end
        return fp
    end
    
    local function fldt_calc_flip_value(fp)
        local total = 0
        if type(fp) ~= "table" then
            return total
        end
        for i = 1, 7 do
            local value = fp[i]
            if value == nil then
                value = fp[tostring(i)]
            end
            total = total + (tonumber(value) or 0) * (10 ^ (i - 1))
        end
        return total
    end

    local function fldt_format_digits(fp)
        local seq = {}
        for i = 7, 1, -1 do
            local v = fp[i] or fp[tostring(i)]
            seq[#seq + 1] = v ~= nil and tostring(v) or "?"
        end
        return table.concat(seq, " ")
    end

    local function sort_by_state(grss)
        table.sort(grss, function(a, b)
            -- 自定义 state 优先级
            local order = { [1] = 1, [0] = 2, [2] = 3 }

            local a_order = order[a.state] or 99
            local b_order = order[b.state] or 99

            if a_order == b_order then
                return a.idx < b.idx  -- 状态比较：state 优先级相同，按 idx 排
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
        GUI:Image_Create(Label_node, "bg", 0, 0, "res/custom/fulitating/bg_"..idx..".png")
        npc.fldt_data = npc.fldt_data or {}
        if idx == 1 then
            local base = npc.fldt_data
            base.T_qrbq = base.T_qrbq or {}
            local tqrbq = base.T_qrbq
            local loginDays = tonumber(base.U_dlts) or 0
            local onlineMinutes = tonumber(base.J_zxsj) or 0
            local claimed = tonumber(tqrbq["7rqd"]) or 0
            local flipDigits = fldt_get_flip_digits()
            local digitDisplay = fldt_format_digits(flipDigits)
            local finalSum = tonumber(tqrbq["7rqd_final_yb"]) or fldt_calc_flip_value(flipDigits)
            local finalMultiple = tonumber(tqrbq["7rqd_final_mul"]) or 1
            local finalAward = tonumber(tqrbq["7rqd_final_award"]) or 0

            -- GUI:Text_Create(Label_node, "seven_login_days", 260 + 365, 440 - 290, 20, "#FFD56F",
            --     string.format("累计登录：%d天   已领取：%d/7天", loginDays, math.min(claimed, 7)))
            -- GUI:Text_Create(Label_node, "seven_online_minutes", 260 + 365, 415 - 290, 18, "#FFD56F",
            --     string.format("当前在线：%d分钟 / 每日领取需满%d分钟", onlineMinutes, fldt_online_limit))
            -- GUI:Text_Create(Label_node, "seven_digits", 260 + 365, 390 - 290, 18, "#00E4FF", "幸运号码：" .. digitDisplay)

            for i = 7, 1, -1 do
                local v = flipDigits[i] or flipDigits[tostring(i)]
                -- seq[#seq + 1] = v ~= nil and tostring(v) or "?"
                if v ~= nil then
                    GUI:setAnchorPoint(GUI:Image_Create(Label_node, "img_bj_l_" .. i, 47 - (i-7) * 82, 308, "res/custom/fulitating/num/"..v..".png")
                        , 0.5, 0.5)
                    local effwu = GUI:Frames_Create(Label_node, "effwu"..i, 47 - (i-7) * 82, 328, "res/custom/fulitating/eff/"..i.."/y_", ".png", 1, 15,
                        { speed = 75, count = 15, loop = 1, finishhide = false })
                    GUI:setAnchorPoint(effwu, 0.5, 0.5)
                else
                    GUI:setAnchorPoint(GUI:Image_Create(Label_node, "img_bj_l_" .. i, 47 - (i-7) * 82, 328, "res/custom/fulitating/eff/"..i.."/y_1.png")
                        , 0.5, 0.5)
                end
                    
                
            end

            -- local finalText
            -- if claimed >= 7 then
            --     if finalAward > 0 then
            --         finalText = string.format("翻牌合计：%d  倍率：x%d  已发绑定金币：%d", finalSum, finalMultiple, finalAward)
            --     else
            --         finalText = string.format("翻牌合计：%d  倍率：x%d  奖励发放中", finalSum, finalMultiple)
            --     end
            -- else
            --     finalText = string.format("翻牌合计：%d  倍率：x%d  完成七日自动发放", finalSum, finalMultiple)
            -- end
            -- GUI:Text_Create(Label_node, "seven_final", 260 + 365, 365 - 290, 18, "#FFFFFF", finalText)
            -- GUI:Text_Create(Label_node, "seven_tip", 260 + 365, 340 - 290, 16, "#FFA043", "提示：需要按顺序领取并满足在线时间才可翻牌。")
            local sevenRewards = fldt_data_cfg["7rqd"] or {}
            local totalDays = #sevenRewards
            local todayIdx = claimed + 1
            local todayCfg = sevenRewards[math.min(todayIdx, totalDays)]
            local canShow = todayCfg ~= nil
            local canClaimToday = canShow and loginDays >= todayIdx and todayIdx <= totalDays

            local dayLayout = GUI:Layout_Create(Label_node, "seven_day_layout", 150, 0, 620, 200)
            local card = GUI:Node_Create(dayLayout, "seven_card_today", 0, 0)
            -- GUI:Text_Create(card, "day_title", 10, 60, 20, "#FFE076", string.format("第%d天", todayIdx))
            -- local digitValue = flipDigits[todayIdx] or flipDigits[tostring(todayIdx)]
            -- local digitText = digitValue ~= nil and tostring(digitValue) or "?"
            -- GUI:Text_Create(card, "digit_today", 180, 60, 22, "#00F0FF", "翻牌号：" .. digitText)
            -- GUI:Text_Create(card, "state_today", 65, 60, 18, "#00FF7F", "状态：可领取")
            local rewardNode = GUI:Node_Create(card, "give_today", 0, 0)
            ItemNumByTable_img(todayCfg.jl, nil, rewardNode)
            GUI:setPosition(rewardNode, 10, 10)
            if canClaimToday then
                local claimButton = GUI:Button_Create(card, "Button_today", 240, -10, "res/custom/fulitating/btn_2.png")
                GUI:addOnClickEvent(claimButton, function()
                    SL:SendLuaNetMsg(101, 511, 1, 1, string.format('{"7rqd":%d}', todayIdx))
                end)
            else
                local tipText
                if not canShow or todayIdx > totalDays then
                    tipText = "七日登录奖励已全部领取"
                elseif loginDays < todayIdx then
                    tipText = string.format("今日奖励已经领取完毕，达到第%d天可继续领取", todayIdx)
                elseif onlineMinutes < fldt_online_limit then
                    tipText = string.format("今日在线满%d分钟后可领取奖励", fldt_online_limit)
                else
                    tipText = "今日暂无可领取奖励"
                end
                GUI:Text_Create(Label_node, "seven_state_tip", 200, 63, 18, "#FFA043", tipText)
            end
        elseif idx == 2 then
            local Label_list = GUI:ListView_Create(Label_node, "Label_list", 0, 0, 600, 330, 1)
            local tqrbq = fldt_get_state()
            local claimed = tonumber(tqrbq["zxjl"]) or 0
            local onlineMinutes = tonumber(npc.fldt_data and npc.fldt_data.J_zxsj) or 0

            GUI:Text_Create(Label_node, "online_desc", 260, 50 + 400, 18, "#FFD56F",
                string.format("当前在线：%d分钟", onlineMinutes))

            local onlineRewards = fldt_data_cfg["zxjl"] or {}
            for v, k in ipairs(onlineRewards) do
                local l = GUI:Image_Create(Label_list, "img_bj_l_" .. v, 0, 0, 'res/custom/fulitating/list_fgx_'..(v%2 == 1 and 1 or 2)..'.png')

                GUI:Text_Create(l, "wz", 30, 20, 20, "#FFEE8A", string.format("在线满%d分钟", k.time))

                local give = ItemNumByTable_img(k.jl, nil, GUI:Node_Create(l, "give", 0, 0))
                GUI:setPosition(give, 260, 5)

                local stateDesc = "未解锁"
                local btnText = "待解锁"
                local stateColor = "#FFFF66"
                local enable = false

                if v <= claimed then
                    stateDesc = "已领取"
                    btnText = "已领取"
                    stateColor = "#00FF7F"
                elseif v == claimed then
                    if onlineMinutes >= (k.time or 0) then
                        stateDesc = "可领取"
                        btnText = "领取"
                        stateColor = "#00FF7F"
                        enable = true
                    else
                        stateDesc = string.format("%d/%d分钟", onlineMinutes, k.time or 0)
                        btnText = stateDesc
                    end
                else
                    enable = true
                end

                -- GUI:Text_Create(l, "state", 260, 40, 18, stateColor, stateDesc)

                -- GUI:Button_setTitleText(Button, btnText)
                -- GUI:Button_setTitleFontSize(Button, 14)
                --TODO：正式时候要改回enable
                if enable then 
                    local Button = GUI:Button_Create(l, "Button", 440, 10, "res/custom/fulitating/btn_1.png")
                    GUI:addOnClickEvent(Button, function()
                        SL:SendLuaNetMsg(101, 511, 1, 2, '{"zxjl":' .. v .. '}')
                    end)
                else
                    GUI:Image_Create(l, "ylq", 440, 10, 'res/wy/public/4.png')
                end
            end
        elseif idx == 3 then
            local Label_list = GUI:ListView_Create(Label_node, "Label_list", 0, 0, 600, 330, 1)
            local tqrbq = fldt_get_state()
            local claimed = tonumber(tqrbq["sgjl"]) or 0
            local killCount = tonumber(npc.fldt_data and npc.fldt_data.U_sgsl) or 0

            GUI:Text_Create(Label_node, "online_desc", 260, 50 + 400, 18, "#FFD56F",
            string.format("今日已击杀：%d只", killCount))
            local killRewards = fldt_data_cfg["sgjl"] or {}
            for v, k in ipairs(killRewards) do
                local l = GUI:Image_Create(Label_list, "img_bj_l_" .. v, 0, 0, 'res/custom/fulitating/list_fgx_'..(v%2 == 1 and 1 or 2)..'.png')

                GUI:Text_Create(l, "wz", 30, 20, 20, "#FFEE8A", string.format("击杀%d只怪物", k.num))

                local give = ItemNumByTable_img(k.jl, nil, GUI:Node_Create(l, "give", 0, 0))
                GUI:setPosition(give, 260, 5)

                local stateDesc = "未解锁"
                local btnText = "待解锁"
                local stateColor = "#FFFF66"
                local enable = false

                if v <= claimed then
                    stateDesc = "已领取"
                    btnText = "已领取"
                    stateColor = "#00FF7F"
                elseif v == claimed then
                    if killCount >= (k.num or 0) then
                        stateDesc = "可领取"
                        btnText = "领取"
                        stateColor = "#00FF7F"
                        enable = true
                    else
                        stateDesc = string.format("%d/%d只", killCount, k.num or 0)
                        btnText = stateDesc
                    end
                else
                    enable = true
                end

                -- GUI:Text_Create(l, "state", 260, 40, 18, stateColor, stateDesc)

                if enable then 
                    local Button = GUI:Button_Create(l, "Button", 440, 10, "res/custom/fulitating/btn_1.png")
                    GUI:addOnClickEvent(Button, function()
                        SL:SendLuaNetMsg(101, 511, 1, 3, '{"sgjl":' .. v .. '}')                    
                        end)
                else
                    GUI:Image_Create(l, "ylq", 440, 10, 'res/wy/public/4.png')
                end
            end
        elseif idx == 4 then
            local Label_list = GUI:ListView_Create(Label_node, "Label_list", 0, 55, 600, 280, 1)
            local grss = {}

            for v,k in pairs(teshudata["fldt"]["grss"]) do
                if npc.ts_data[""..v] == nil then
                    table.insert(grss, {idx = v, state = 0,name = k.name})
                else
                    table.insert(grss, {idx = v, state = npc.ts_data[""..v],name = teshudata["fldt"]["grss"][tonumber(v)].name})
                end
            end

            sort_by_state(grss)


            for i = (npc.sign-1)*7 + 1, (npc.sign-1)*7 + 7 do
                if not grss[i] then break end
                local v = grss[i]
                local l = GUI:Image_Create(Label_list, "img_bj_l_"..i, 0, 0, 'res/custom/fulitating/list_fgx_'..(v.idx%2 == 1 and 1 or 2)..'.png')
                GUI:setContentSize(l, 500, 40)

                GUI:Text_Create(l, "wz",35,5, 20, "#FF0000", v.name)

                -- GUI:Text_Create(l, "state",300,5, 20, state_info[v.state].color, state_info[v.state].text)
                GUI:RichText_Create(l, "jl", 220, 5,  ItemNumByTable(teshudata["fldt"]["grss"][v.idx].give), 500, 18, "#f7f7de", 3,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})


                local Button= GUI:Button_Create(l, "Button", 436, -2, "res/public/1900000660.png")
                GUI:Button_setTitleText(Button, state_info[v.state].text)
                GUI:Button_setTitleColor(Button, state_info[v.state].color)
                GUI:Button_setTitleFontSize(Button, 14)

                GUI:addOnClickEvent(Button, function()
                    SL:SendLuaNetMsg(101, 511, 1, 4, '{"grss":"'..(v.idx)..'"}')
                end)
            end

            local Button_all = GUI:Button_Create(Label_node, "grss_all", 500, 0, "res/public/1900000660.png")
            GUI:setAnchorPoint(Button_all, 0.5, 0)
            GUI:Button_setTitleText(Button_all, "一键领取")
            GUI:Button_setTitleFontSize(Button_all, 14)
            GUI:addOnClickEvent(Button_all, function()
                SL:SendLuaNetMsg(101, 511, 1, 4, '{"isall":1}')
            end)

            local Button= GUI:Button_Create(Label_node, "next", 350, 0, "res/public/1900000660.png")
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
            Button= GUI:Button_Create(Label_node, "shangyiy", 100, 0, "res/public/1900000660.png")
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
                    GUI:Text_Create(Label_node, "state",225,20, 18, "#ffffff", string.format("第%d页/共%d页",npc.sign,math.ceil(#grss/10)))
            , 0.5, 0.5)


        elseif idx == 5 then
            local Label_list = GUI:ListView_Create(Label_node, "Label_list", 0, 55, 600, 280, 1)
            local grsb = {}

            for v,k in pairs(teshudata["fldt"]["grsb"]) do
                if npc.ts_data[""..v] == nil then
                    table.insert(grsb, {idx = v, state = 0,name = k.name})
                else
                    table.insert(grsb, {idx = v, state = npc.ts_data[""..v],name = teshudata["fldt"]["grsb"][tonumber(v)].name})
                end
            end

            sort_by_state(grsb)
            local totalPage = math.max(1, math.ceil(#grsb/7))

            for i = (npc.sign-1)*7 + 1, (npc.sign-1)*7 + 7 do
                if not grsb[i] then break end
                local v = grsb[i]
                local l = GUI:Image_Create(Label_list, "img_bj_l_"..i, 0, 0, 'res/custom/fulitating/list_fgx_'..(v.idx%2 == 1 and 1 or 2)..'.png')
                GUI:setContentSize(l, 500, 40)

                GUI:Text_Create(l, "wz",35,5, 20, "#FF0000", v.name)
                GUI:RichText_Create(l, "jl", 220, 5,  ItemNumByTable(teshudata["fldt"]["grsb"][v.idx].give), 500, 18, "#f7f7de", 3,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})

                local Button= GUI:Button_Create(l, "Button", 436, -2, "res/public/1900000660.png")
                GUI:Button_setTitleText(Button, state_info[v.state].text)
                GUI:Button_setTitleColor(Button, state_info[v.state].color)
                GUI:Button_setTitleFontSize(Button, 14)

                GUI:addOnClickEvent(Button, function()
                    SL:SendLuaNetMsg(101, 511, 1, 5, '{"grsb":"'..(v.idx)..'"}')
                end)
            end

            local Button_all = GUI:Button_Create(Label_node, "grsb_all", 500, 0, "res/public/1900000660.png")
            GUI:setAnchorPoint(Button_all, 0.5, 0)
            GUI:Button_setTitleText(Button_all, "一键领取")
            GUI:Button_setTitleFontSize(Button_all, 14)
            GUI:addOnClickEvent(Button_all, function()
                SL:SendLuaNetMsg(101, 511, 1, 5, '{"isall":1}')
            end)

            local Button= GUI:Button_Create(Label_node, "next", 350, 0, "res/public/1900000660.png")
            GUI:setAnchorPoint(Button, 0.5, 0)
            GUI:Button_setTitleText(Button, "下一页")
            GUI:Button_setTitleFontSize(Button, 14)
            GUI:addOnClickEvent(Button, function()
                if npc.sign == totalPage then
                    SL:ShowSystemTips("已经是最后一页了！！！")
                    return
                end
                npc.sign = npc.sign + 1
                GUI_createLabel(npc.Label,npc.titles_sign)
            end)
            Button= GUI:Button_Create(Label_node, "shangyiy", 100, 0, "res/public/1900000660.png")
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
                    GUI:Text_Create(Label_node, "state",225,20, 18, "#ffffff", string.format("第%d页/共%d页",npc.sign,totalPage))
            , 0.5, 0.5)
        elseif idx == 6 then
            local Label_list = GUI:ListView_Create(Label_node, "Label_list", 0, 55, 600, 280, 1)
            local qqsb = {}

            for v,k in pairs(teshudata["fldt"]["qqsb"]) do
                if npc.ts_data[""..v] == nil then
                    table.insert(qqsb, {idx = v, state = 0,name = k.name})
                else
                    table.insert(qqsb, {idx = v, state = npc.ts_data[""..v],name = teshudata["fldt"]["qqsb"][tonumber(v)].name})
                end
            end

            sort_by_state(qqsb)
            local totalPage = math.max(1, math.ceil(#qqsb/7))

            for i = (npc.sign-1)*7 + 1, (npc.sign-1)*7 + 7 do
                if not qqsb[i] then break end
                local v = qqsb[i]
                local l = GUI:Image_Create(Label_list, "img_bj_l_"..i, 0, 0, 'res/custom/fulitating/list_fgx_'..(v.idx%2 == 1 and 1 or 2)..'.png')
                GUI:setContentSize(l, 500, 40)

                GUI:Text_Create(l, "wz",35,5, 20, "#FF0000", v.name)
                GUI:RichText_Create(l, "jl", 220, 5,  ItemNumByTable(teshudata["fldt"]["qqsb"][v.idx].give), 500, 18, "#f7f7de", 3,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})

                local Button= GUI:Button_Create(l, "Button", 436, -2, "res/public/1900000660.png")
                GUI:Button_setTitleText(Button, state_info[v.state].text)
                GUI:Button_setTitleColor(Button, state_info[v.state].color)
                GUI:Button_setTitleFontSize(Button, 14)

                GUI:addOnClickEvent(Button, function()
                    SL:SendLuaNetMsg(101, 511, 1, 6, '{"qqsb":"'..(v.idx)..'"}')
                end)
            end

            local Button_all = GUI:Button_Create(Label_node, "qqsb_all", 500, 0, "res/public/1900000660.png")
            GUI:setAnchorPoint(Button_all, 0.5, 0)
            GUI:Button_setTitleText(Button_all, "一键领取")
            GUI:Button_setTitleFontSize(Button_all, 14)
            GUI:addOnClickEvent(Button_all, function()
                SL:SendLuaNetMsg(101, 511, 1, 6, '{"isall":1}')
            end)

            local Button= GUI:Button_Create(Label_node, "next", 350, 0, "res/public/1900000660.png")
            GUI:setAnchorPoint(Button, 0.5, 0)
            GUI:Button_setTitleText(Button, "下一页")
            GUI:Button_setTitleFontSize(Button, 14)
            GUI:addOnClickEvent(Button, function()
                if npc.sign == totalPage then
                    SL:ShowSystemTips("已经是最后一页了！！！")
                    return
                end
                npc.sign = npc.sign + 1
                GUI_createLabel(npc.Label,npc.titles_sign)
            end)
            Button= GUI:Button_Create(Label_node, "shangyiy", 100, 0, "res/public/1900000660.png")
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
                    GUI:Text_Create(Label_node, "state",225,20, 18, "#ffffff", string.format("第%d页/共%d页",npc.sign,totalPage))
            , 0.5, 0.5)

        end
    end

    local function UI_updata(node) --界面渲染
        GUI:removeAllChildren(node)



        npc.cbl_list = GUI:ListView_Create(node, "cbl_list", -5, 10, 170, 440, 1)
        GUI:ListView_setGravity(npc.cbl_list, 1)
        GUI:ListView_setItemsMargin(npc.cbl_list, 10)
        npc.Label = GUI:Node_Create(node, "Label", 170, 15)

        local titles = {"七日登录", "在线奖励", "杀怪奖励", "怪物首杀", "个人首爆", "全区首爆"}
        npc.titles_sign = 1
        for i = 1, #titles do
            local cbl_item = GUI:Button_Create(npc.cbl_list, "item" .. i, 0, 0, "res/custom/fulitating/list/"..(npc.titles_sign == i and "l" or "n").."/"..i..".png")
            -- GUI:Button_setTitleText(cbl_item, titles[i])
            -- GUI:Button_setTitleFontSize(cbl_item, 14)
            GUI:Image_Create(npc.cbl_list, "fgx"..i, 0, 0, "res/custom/fulitating/list/fgx.png")
            GUI:addOnClickEvent(cbl_item, function()
                GUI:Button_loadTextureNormal(GUI:ui_delegate(npc.cbl_list)["item" .. npc.titles_sign], "res/custom/fulitating/list/n/"..npc.titles_sign..".png")
                npc.titles_sign = i
                if i >= 4 then
                    SL:SendLuaNetMsg(101, 511, 2, i, "")
                    npc.sign = 1
                else
                    GUI_createLabel(npc.Label,i)
                end
                GUI:Button_loadTextureNormal(GUI:ui_delegate(npc.cbl_list)["item" .. npc.titles_sign], "res/custom/fulitating/list/l/"..npc.titles_sign..".png")
            end)
        end
        
        GUI:Image_Create(node, "bg_fgx", 0, 0, "res/custom/fulitating/bg_fgx.png")

    end

    if p2 == 0 then
        npc.fldt_data = fldt_decode_json(Data)
        npc.fldt_data.T_qrbq = npc.fldt_data.T_qrbq or {}
        npc.ts_data = npc.ts_data or {}
        local welfareWindow = ensureWindow("welfare", 511, {titleText = "福利大厅"})
        npc.bg = welfareWindow.bg
        npc.node = welfareWindow.node
        GUI:removeAllChildren(npc.node)
        UI_updata(npc.node)
        GUI_createLabel(npc.Label, npc.titles_sign or 1)
    elseif p2 == 1 then
        if p3 == 1 then
            npc.fldt_data = npc.fldt_data or {}
            npc.fldt_data.T_qrbq = fldt_decode_json(Data)
            if npc.Label and (npc.titles_sign or 1) <= 3 then
                GUI_createLabel(npc.Label, npc.titles_sign or 1)
            end
        end
    elseif p2 == 2 then
        npc.ts_data = fldt_decode_json(Data)
        npc.titles_sign = p3
        GUI_createLabel(npc.Label,p3)
    end

end
---游戏攻略
npc[512] = function(p2, p3, Data) -- 游戏攻略
    local function GUI_createLabel(Label_node,idx)
        GUI:removeAllChildren(Label_node)
        if idx == 1 then
        end
    end
    local function UI_updata(node) --界面渲染
        GUI:removeAllChildren(node)



        npc.cbl_list = GUI:ListView_Create(node, "cbl_list", -5, 10, 170, 440, 1)
        GUI:ListView_setGravity(npc.cbl_list, 1)
        GUI:ListView_setItemsMargin(npc.cbl_list, 10)
        npc.Label = GUI:Node_Create(node, "Label", 170, 15)

        npc.titles_sign = 1
        for i = 1, 6 do
            local cbl_item = GUI:Button_Create(npc.cbl_list, "item" .. i, 0, 0, "res/custom/strategy/list/"..(npc.titles_sign == i and "l" or "n").."/"..i..".png")
            -- GUI:Button_setTitleText(cbl_item, titles[i])
            -- GUI:Button_setTitleFontSize(cbl_item, 14)
            GUI:Image_Create(npc.cbl_list, "fgx"..i, 0, 0, "res/custom/strategy/list/fgx.png")
            GUI:addOnClickEvent(cbl_item, function()
                GUI:Button_loadTextureNormal(GUI:ui_delegate(npc.cbl_list)["item" .. npc.titles_sign], "res/custom/strategy/list/n/"..npc.titles_sign..".png")
                npc.titles_sign = i
                GUI_createLabel(npc.Label,i)
                GUI:Button_loadTextureNormal(GUI:ui_delegate(npc.cbl_list)["item" .. npc.titles_sign], "res/custom/strategy/list/l/"..npc.titles_sign..".png")
            end)
        end
        

    end

    if p2 == 0 then
        npc.data_512 = not Data and {} or SL:JsonDecode(Data, false)
        local strategyWindow = ensureWindow("strategy", 512, {titleText = "游戏攻略"})
        npc.bg = strategyWindow.bg
        npc.node = strategyWindow.node
        GUI:setContentSize(GUI:Frames_Create(npc.bg, "eff1", 0, 0, "res/wy/eff/city/tongyong_0_dx_1_", ".png", 1, 45,
        { speed = 75, count = 45, loop = -1}), GUI:getContentSize(npc.bg))
            GUI:setContentSize( GUI:Frames_Create(npc.bg, "eff2", 0, 0, "res/wy/eff/city/tongyong_0_dx_2_", ".png", 1, 45,
        { speed = 75, count = 45, loop = -1}), GUI:getContentSize(npc.bg))
        
        GUI:removeAllChildren(npc.node)
        UI_updata(npc.node)
        GUI_createLabel(npc.Label, npc.titles_sign or 1)
    end
end
---世界地图
---世界地图
npc[514] = function(p2, p3, Data)
    local pos = {
        {100 + 123,100 + 267},
        {200 + 211,100 + 354},
        {300 - 196,100 + 91},
        {400 + 79,100 + 268},
        {500 - 212,100 + 151},
        {600 - 48,100 + 363},
    }
    local function renderWorldMap(node)
        GUI:removeAllChildren(node)
        local bg = GUI:Frames_Create(node, "bg", 0, 0, "res/custom/sjdt/eff/eff_", ".png", 1, 8,
            { speed = 75, count = 8, loop = -1})
        GUI:setAnchorPoint(bg, 0.5, 0.5)
        
        for i = 1, 6 do
            local btn = GUI:Button_Create(bg, 'btn' .. i, pos[i][1], pos[i][2], 'res/custom/sjdt/dl/l/'..i..'.png')
            -- GUI:Button_setTitleText(btn, teshudata["sjdt"][500 + i][1])
            -- GUI:Button_setTitleFontSize(btn, 14)
            GUI:addOnClickEvent(btn, function()
                SL:SendLuaNetMsg(100, 500 + i, 1, 0, "")
            end)
        end
        
    end

    if p2 == 0 then
        local win = ensureWindow("worldMap", 514, {titleText = "世界地图"})
        renderWorldMap(win.node)
    end
end
---仙途奇缘（成就）
npc[515] = function(p2, p3, Data) -- 仙途奇缘
    local function UI_updata(node) --界面渲染
        GUI:removeAllChildren(node)
        local ScrollView = GUI:ScrollView_Create(node, "ScrollView", 30, 12, 670, 370, 1)
        GUI:ScrollView_setInnerContainerSize(ScrollView, 670, (146 * math.ceil(#teshudata["anniu_515"].details/4)))
        GUI:Image_Create(node, "sx_wz", 700, 20.00, "res/custom/fairyFate/sx_wz.png")
        GUI:Image_Create(node, "tip_wz", 20, 370.00, "res/custom/fairyFate/tip_wz.png")
        local dbLayout = GUI:Layout_Create(ScrollView, "dbLayout", 0,0, 670, (146 * math.ceil(#teshudata["anniu_515"].details/4)))
        for k,v in ipairs(teshudata["anniu_515"].details) do
            local Button= GUI:Image_Create(dbLayout, "Button"..k, 0, 0.00, "res/custom/fairyFate/kuang.png")
            local wz5 = GUI:Text_Create(Button, "wz5",166/2, 116, 18, "#FF0000", v.tt)
            GUI:setAnchorPoint(wz5, 0.5, 0.5)
            GUI:Text_setTextColor(wz5, npc.data_515.T_data[""..k] and "#00FF00" or "#FF0000")
            local desc = GUI:RichText_Create(Button, "desc", 166/2, 90,
                            "<font color='#00FF00' size='20' >"..v.tip.."</font>\n"
            , 130, 20, "#f7f7de", 3,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})
            GUI:setAnchorPoint(desc, 0.5, 1)


            -- GUI:Button_setTitleFontSize(Button, 14)
            -- GUI:Button_setTitleColor(Button, npc.data_515.T_data[""..k] and "#00FF00" or "#FF0000")
            -- GUI:addOnClickEvent(Button, function()
            --     GUI:removeChildByName(node,"desc")
            --     local desc = GUI:RichText_Create(node, "desc", 600, 430,
            --             "<font color='#00FF00' size='20' >奇遇名称："..v.tt.."</font>\n"..
            --                     "<font color='#00FF00' size='20' >奇遇条件："..v.wz.."</font>\n"..
            --                     "<font color='#00FF00' size='20' >奇遇文字："..v.tip.."</font>\n"
            --     , 500, 20, "#f7f7de", 3,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})
            --     GUI:setAnchorPoint(desc, 0, 1)
            -- end)
        end
        GUI:UserUILayout(dbLayout, {dir=3,addDir=1,gap = {x=0, y=0}})
    end

    if p2 == 0 then
        npc.data_515 = not Data and {} or SL:JsonDecode(Data, false)
        local win = ensureWindow("fairyFate", 515, {titleText = "仙途奇缘"})
        UI_updata(win.node)
    end
end
--免费赞助
npc[516] = function(p2, p3, Data)
    local function UI_updata(node) --界面渲染
        GUI:removeAllChildren(node)
        local list = GUI:ListView_Create(node, "list", 80,30, 800, 400,2)
        GUI:ListView_setItemsMargin(list,5)
        for k,v in ipairs(teshudata["anniu_516"].details) do
            local item = GUI:Image_Create(list, "item"..k, 0, 0, 'res/custom/mfzz/itme_'..k..'.png')

            -- GUI:Text_Create(item, "wz",10,400, 20, "#FF0000", v.ch)

            GUI:setAnchorPoint(GUI:RichText_Create(item, "attr_desc_next", 50,320,  Player:showEquipAttr(SL:GetMetaValue("ITEM_DATA",SL:GetMetaValue("ITEM_INDEX_BY_NAME",v.ch))), 200, 18, "#f7f7de", 3,nil,nil)
            , 0, 1)
            

            GUI:setAnchorPoint(GUI:Text_Create(item, "sgsl",228/2,130, 20, "#FF0000", "击杀怪物："..v.sgsl)
            , 0.5, 0.5)
            if npc.data_516.T_data["zzlb_"..k] then
                
                GUI:setAnchorPoint(GUI:Image_Create(item, "Button", 228/2, 80, 'res/wy/public/9.png'), 0.5, 0.5)
            else
                local Button= GUI:Button_Create(item, "Button", 228/2, 80, 'res/custom/mfzz/btn.png')
                GUI:setAnchorPoint(Button, 0.5, 0.5)
                GUI:addOnClickEvent(Button, function()
                    SL:SendLuaNetMsg(101, 516, 1, k, "")
                end)
            end

        end


    end

    if p2 == 0 then
        npc.data_516 = not Data and {} or SL:JsonDecode(Data, false)
        local win = ensureWindow("freeSponsor", 516, {titleText = "免费赞助"})
        npc.node_516 = win.node
        UI_updata(npc.node_516)
    elseif p2 == 1 then
        npc.data_516.T_data["zzlb_"..p3] = true
        local list = GUI:ui_delegate(npc.node_516)["list"]
        local item = GUI:ui_delegate(list)["item"..p3]
        GUI:removeChildByName(item,"Button")
        GUI:setAnchorPoint(GUI:Image_Create(item, "Button", 228/2, 80, 'res/wy/public/9.png'), 0.5, 0.5)
    end
end

--聚宝盆
npc[517] = function(p2, p3, Data)
    local function xjm_UI_updata(node) --界面渲染
        GUI:removeAllChildren(node)
        local no = GUI:Image_Create(node, "no", 20, 20, "res/custom/treasureBasin/itme_1.png")
        local config = teshudata["anniu_517"].details[npc.data_517.T_data.level]
       
        GUI:setAnchorPoint(GUI:RichText_Create(no, "jl", 205/2, 215,  ItemNumByTable(config.give), 500, 18, "#f7f7de", 3,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})
        , 0.5, 0.5)
        GUI:setAnchorPoint(GUI:RichText_Create(no, "tiaojian", 205/2, 127,  config.tiaojian, 500, 25, "#f7f7de", 3,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})
        , 0.5, 0.5)
        if npc.data_517.T_data.level >= #teshudata["anniu_517"].details then
            GUI:Text_Create(no, "wz1",400,50, 20, "#FF0000", "聚宝盆已满级")
            return
        end
        GUI:setAnchorPoint(GUI:Image_Create(node, "jt", 600/2, 398/2, "res/custom/treasureBasin/jt.png"), 0.5, 0.5)
        config = teshudata["anniu_517"].details[npc.data_517.T_data.level + 1]

        local nj = GUI:Image_Create(node, "nj", 375, 20, "res/custom/treasureBasin/itme_2.png")
        GUI:setAnchorPoint(GUI:RichText_Create(nj, "jl", 205/2, 215,  ItemNumByTable(config.give), 500, 18, "#f7f7de", 3,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})
        , 0.5, 0.5)
         GUI:setAnchorPoint(GUI:RichText_Create(nj, "tiaojian", 205/2, 127,  config.tiaojian, 500, 25, "#f7f7de", 3,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})
        , 0.5, 0.5)
        local Button= GUI:Button_Create(node, "Button1", 600/2, 80, "res/custom/treasureBasin/bnt_2.png")
        GUI:setAnchorPoint(Button, 0.5, 0.5)

        GUI:addOnClickEvent(Button, function()
            SL:SendLuaNetMsg(101, 517, 1, 0, '')
        end)
       
    end

    local function UI_updata(node) --界面渲染
        GUI:removeAllChildren(node)

        local config = teshudata["anniu_517"].details[npc.data_517.T_data.level]


        -- GUI:Text_Create(node, "wz1",200,400, 20, "#FF0000", "当前聚宝盆等级："..(npc.data_517.T_data.level or 0).."级")
        -- 
        -- GUI:Text_Create(node, "wz3",200,400 - 60, 20, "#FF0000", "当前积分："..(npc.data_517.jf or 0))
        -- GUI:Text_Create(node, "wz4",200,400 - 90, 20, "#FF0000", "当前领取所需积分"..(config.jf or 0))


        -- GUI:Text_Create(node, "wz5",200,400 - 120, 20, "#FF0000", "奖励:")
        -- local give_show = ItemNumByTable_img(config.give, nil,GUI:Node_Create(node, "give", 0, 0))
        -- GUI:setPosition(give_show, 200, 200)

        GUI:setAnchorPoint(GUI:Image_Create(node, "wz_1", -350, 0, "res/custom/treasureBasin/wz_1.png"), 0.5, 0.5)
        -- GUI:setAnchorPoint(GUI:Image_Create(node, "wz_2", 350, 0, "res/custom/treasureBasin/wz_2.png"), 0.5, 0.5)
        GUI:setAnchorPoint(GUI:Image_Create(node, "wz_3", -350, -100, "res/custom/treasureBasin/wz_3.png"), 0.5, 0.5)
        GUI:setAnchorPoint(GUI:Image_Create(node, "wz_4", 0, -200, "res/custom/treasureBasin/wz_4.png"), 0.5, 0.5)

        

        GUI:Text_setFontName(GUI:Text_Create(node, "wz_3_num",-350 + 30, -100 - 19, 30, "#FF0000", config.maxcs - (npc.data_517.cs or 0))
        , "fonts/500.ttf")

        GUI:RichText_Create(node, "jl", -350 - 69, 0 - 38,  ItemNumByTable(config.give), 500, 18, "#f7f7de", 3,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})
        -- if teshudata["anniu_517"].details[npc.data_517.T_data.level + 1] then
        --     GUI:RichText_Create(node, "jl_next", 350 - 69, 0 - 38,  ItemNumByTable(teshudata["anniu_517"].details[npc.data_517.T_data.level + 1].give), 500, 18, "#f7f7de", 3,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})
        -- else
        --     GUI:Text_Create(node, "jl_next_wz", 220, 30, 18, "#FF0000", "已满级")
        -- end 


        local jdt_k = GUI:Image_Create(node, "jdt_k", 0,-230, "res/custom/treasureBasin/jdt_k.png")
        GUI:setAnchorPoint(jdt_k, 0.5, 0.5)
        GUI:LoadingBar_setPercent(GUI:LoadingBar_Create(jdt_k, "jdt", 0,0,"res/custom/treasureBasin/jdt_m.png", 0)
        , npc.data_517.jf / (config.jf or 1) * 100)
        
        GUI:setAnchorPoint(GUI:Text_Create(jdt_k, "wz",337,12, 18, "#FF0000", "当前积分："..(npc.data_517.jf or 0).."/"..(config.jf or 0))
        , 0.5, 0.5)
        local Button= GUI:Button_Create(node, "Button1", 330, -280.00, "res/custom/treasureBasin/btn_up.png")
        GUI:addOnClickEvent(Button, function()
            -- SL:SendLuaNetMsg(101, 517, 1, 0, '')
                npc.xjm_window = NPC_UI_HELPER.ensureWindow(nil, npcid, {
                    windowName = "npc_anniu_517_xjm",
                    overlay = {skin = "res/custom/treasureBasin/x.png"},
                    background = {skin = "res/custom/treasureBasin/xjm_bg.png"},
                    closeButton = {x = 330 + 220, y = 180 + 180, skin = "res/wy/public/close_red_big.png"},
                })
                npc.xjm_node = npc.xjm_window.node
                xjm_UI_updata(npc.xjm_node)
        end)

        Button= GUI:Frames_Create(node, "Button2", 0, -50, "res/custom/treasureBasin/btn_eff/eff_", ".png", 1, 75,
            { speed = 75, count = 75, loop = -1})
        GUI:setAnchorPoint(Button, 0.5, 0.5)
        GUI:setTouchEnabled(Button, true)
        GUI:addOnClickEvent(Button, function()
            SL:SendLuaNetMsg(101, 517, 2, 0, '')
        end)


    end

    if p2 == 0 then
        npc.data_517 = not Data and {} or SL:JsonDecode(Data, false)
        local win = ensureWindow("treasureBasin", 517, {titleText = "聚宝盆"})
        npc.node_517 = win.node

        win.bg = GUI:Frames_Create(win.bg, "eff", 0, 0, "res/custom/treasureBasin/bg/eff_", ".png", 1, 75,
            { speed = 75, count = 75, loop = -1})
        GUI:setAnchorPoint(win.bg, 0.5, 0.5)
        GUI:setTouchEnabled(win.bg, true)
        GUI:setAnchorPoint(GUI:Image_Create(win.bg, "title", 500, 520, "res/custom/treasureBasin/title.png")
        , 0.5, 0.5)
        UI_updata(win.node)
        GUI:setLocalZOrder(win.node, 99)
    elseif p2 == 1 then
        npc.data_517.T_data.level = npc.data_517.T_data.level + 1
        xjm_UI_updata(npc.xjm_node)
    elseif p2 == 2 then
        npc.data_517.jf = 0
        npc.data_517.cs = (npc.data_517.cs or 0) + 1
        UI_updata(npc.node_517)
    end
end


-- GM 面板配置：货币/礼包/变量/首充说明表
local xlxl = {
    {"金币","元宝","绑定金币","绑定元宝","灵石","绑定灵石","累计充值","礼包积分","一合充值","二合充值","三合后充值"},
    {"充值10","充值30","充值68","充值128","充值198","充值328","充值648","充值998"},
    {{"个人变量",105,178},{"个人标识",225,178},{"个人Buff",105,144},{"全局变量",225,144}},
    {"快人一步","前三天首充","三天后首充"},
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
    local close = GUI:Button_Create(npc.bg, 'close', 970, 550, 'res/wy/public/close_red_big.png')
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

	local an_txx,han_zb = {},{{493,"踢下线"},{440,"加入列表"},{383,"去除列表"},{323,"显示列表"}}
	for i, v in ipairs(han_zb) do
	    an_txx[i] = GUI:Button_Create(npc.bg, "an_txx"..i, 410.00, v[1], "res/public/1900000660.png")
	    GUI:Button_setTitleText(an_txx[i], v[2])
	    GUI:Button_setTitleColor(an_txx[i], "#ff0500")
	    GUI:Button_setTitleFontSize(an_txx[i], 14)
	    GUI:Button_titleEnableOutline(an_txx[i], "#000000", 1)
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
	local an_huobigai = GUI:Button_Create(npc.bg, "an_huobigai", 293.00, 383.00, "res/public/1900000660.png")
	GUI:Button_setTitleText(an_huobigai, "货币修改")
	GUI:Button_setTitleColor(an_huobigai, "#28ef01")
	GUI:Button_setTitleFontSize(an_huobigai, 14)
	GUI:Button_titleEnableOutline(an_huobigai, "#000000", 1)
	GUI:setTouchEnabled(an_huobigai, true)
	local an_hbzj = GUI:Button_Create(npc.bg, "an_hbzj", 293.00, 323.00, "res/public/1900000660.png")
	GUI:Button_setTitleText(an_hbzj, "货币增加")
	GUI:Button_setTitleColor(an_hbzj, "#28ef01")
	GUI:Button_setTitleFontSize(an_hbzj, 14)
	GUI:Button_titleEnableOutline(an_hbzj, "#000000", 1)
	GUI:setTouchEnabled(an_hbzj, true)

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

    -- ===== GM 工具：输入校验 + 常用操作 =====
    local function showErrorTip(msg)
        SL:ShowSystemTips(string.format("<outline color='#000000' size='1'><font color='#FF0000'>%s</font></outline>", msg))
    end

    local function requirePlayerName()
        local name = GUI:TextInput_getString(mingzi_sr)
        if name == "" then
            showErrorTip("请正确输入玩家名字")
            return nil
        end
        return name
    end

    local function requireSelection(labelWidget, placeholder, tip)
        local text = GUI:Text_getString(labelWidget)
        if text == placeholder or text == "" then
            showErrorTip(tip)
            return nil
        end
        return text
    end

    local function requireNumber(inputWidget, tip)
        local value = tonumber(GUI:TextInput_getString(inputWidget))
        if not value then
            showErrorTip(tip or "请输入数字")
            return nil
        end
        return value
    end

    local function findIndexByLabel(list, label)
        for index, text in ipairs(list) do
            if text == label then
                return index
            end
        end
        return nil
    end

    local function handleCurrencyOp(opCode)
        local name = requirePlayerName()
        if not name then
            return
        end
        local currencyName = requireSelection(Text_huobi, "货币种类", "请正确选择货币名字")
        if not currencyName then
            return
        end
        local amount = requireNumber(huobi_sr, "请输入数量")
        if not amount then
            return
        end
        local currencyId = findIndexByLabel(xlxl[1], currencyName)
        if not currencyId then
            showErrorTip("未知货币类型，请重新选择")
            return
        end
        SL:SendLuaNetMsg(101,998, 1, opCode, string.format('{"mz":"%s","hb":%d,"sl":%d}', name, currencyId, amount))
    end

    local function handleGiftAdd()
        local name = requirePlayerName()
        if not name then
            return
        end
        local giftName = requireSelection(Text_libao, "礼包种类", "请正确选择礼包种类")
        if not giftName then
            return
        end
        local giftId = findIndexByLabel(xlxl[2], giftName)
        SL:release_print(giftId)
        SL:release_print(giftName)
        if not giftId then
            showErrorTip("未知礼包类型，请重新选择")
            return
        end
        SL:SendLuaNetMsg(101,998, 1, 4, string.format('{"mz":"%s","hb":%d}', name, giftId))
    end

    GUI:addOnClickEvent(an_mz, function()
        local name = requirePlayerName()
        if name then
            SL:SendLuaNetMsg(101,998, 1, 0, name)
        end
    end)

    for i, btn in ipairs(an_txx) do
        GUI:addOnClickEvent(btn, function()
            if i == 4 then
                SL:SendLuaNetMsg(101,998, 4, i, "")
                return
            end
            local name = requirePlayerName()
            if not name then
                return
            end
            SL:SendLuaNetMsg(101,998, 4, i, name)
        end)
    end

    GUI:addOnClickEvent(an_huobicha,function()
        local name = requirePlayerName()
        if not name then
            return
        end
        local currencyName = requireSelection(Text_huobi, "货币种类", "请正确选择货币名字")
        if not currencyName then
            return
        end
        local currencyId = findIndexByLabel(xlxl[1], currencyName)
        if not currencyId then
            showErrorTip("未知货币类型，请重新选择")
            return
        end
        SL:SendLuaNetMsg(101,998, 1, 1, string.format('{"mz":"%s","hb":%d}', name, currencyId))
    end)

    GUI:addOnClickEvent(an_huobigai,function()
        handleCurrencyOp(2)
    end)

    GUI:addOnClickEvent(an_hbzj,function()
        handleCurrencyOp(3)
    end)

    GUI:addOnClickEvent(an_lb,function()
        handleGiftAdd()
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





