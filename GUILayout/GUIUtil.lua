math.randomseed(tostring(os.time()):reverse():sub(1,6))--随机数种子

cogin = {}
cogin.w = SL:GetMetaValue("SCREEN_WIDTH")
cogin.h = SL:GetMetaValue("SCREEN_HEIGHT")
cogin.isWin32 = SL:GetMetaValue("WINPLAYMODE")  --客户端载体
cogin.actorID = SL:GetMetaValue("MAIN_ACTOR_ID")  --主玩家actorID
cogin.shubiaojiemian = nil
cogin.sshimingjiemian = nil
cogin.guajikawei = {0,0}
cogin.guaji = {}
cogin.sjtb = {}
cogin.iskf = false  --是否在跨服
Player = SL:Require("GUILayout/ssrgame/util/Player", true)                               --日志打印函数
SL:Require("GUILayout/ssrgame/util/uiEx", true)                                 --ui扩展
SL:Require("GUILayout/ssrgame/util/util", true)                                 --工具库
SL:Require("GUILayout/npc/ui_helper", true)                                 --npc通用ui辅助



cogin.hs = SL:Require("GUILayout/Data/huishou.lua", true)
cogin.teshudata = SL:Require("GUILayout/Data/teshudata.lua", true)

ssrConstCfg = SL:Require("GUILayout/ssrgame/cfg/ConstCfg", true)                --常量配置
DescCfg = SL:Require("GUILayout/ssrgame/cfg/DescCfg", true)                --常量配置
EventCfg = SL:Require("GUILayout/ssrgame/cfg/EventCfg", true)                --常量配置


-------------------ui设计-------------------
SL:Require("GUILayout/A/LeftAttrOBJ", true)
SL:Require("GUILayout/A/LeftTopOBJ", true)



---回收的数据初始化
cogin.huishou_jc_list = {}
local function append_huishou_group(source, gl)
    if type(source) ~= "table" then
        return
    end
    for itemIdx, cfg in pairs(source) do
        if type(cfg) == "table" then
            if type(cfg.l) == "table" then
                append_huishou_group(cfg.l, gl)
            elseif type(cfg[1]) == "number" then
                cogin.huishou_jc_list[itemIdx] = cfg
                cogin.huishou_jc_list[itemIdx].gl = gl
            else
                append_huishou_group(cfg, gl)
            end
        end
    end
end

append_huishou_group(cogin.hs.zzhs, 1)
append_huishou_group(cogin.hs.fzfj, 1)
append_huishou_group(cogin.hs.zsfj, 2)
append_huishou_group(cogin.hs.sqhs, 3)
append_huishou_group(cogin.hs.gwfj, 4)
append_huishou_group(cogin.hs.ssfj, 5)
append_huishou_group(cogin.hs.clfj, 6)
append_huishou_group(cogin.hs.teshuhuihsou, 7)

for itemIdx, cfg in pairs(cogin.hs.kexiaohui or {})  do
    if not cogin.huishou_jc_list[itemIdx] then
        cogin.huishou_jc_list[itemIdx] = cfg
    end
end

cogin.zhuangbeiwei = {
    [15] = {"头盔",4},
    [19] = {"项链",3},
    [20] = {"项链",3},
    [21] = {"项链",3},
    [22] = {"戒指",7},
    [23] = {"戒指",7},
    [24] = {"手镯",5},
    [26] = {"手镯",5},
    [64] = {"腰带",10},
    [62] = {"靴子",11},
    [5] = {"武器",1},
    [10] = {"衣服",0},
}
cogin.zbzb = {
    [1] = {"普通级","#C6C6CE"},
    [2] = {"稀有级","#63C64A"},
    [3] = {"史诗级","#7722CC"},
    [4] = {"传说级","#EF6B00"},
    [5] = {"神话级","#DE0000"},
    [6] = {"寂灭级","#FF00FF"},
}

cogin.texiaodaxiao = {
    [1] = {8,0,0,0,5,0,0,255},
    [2] = {8,7,5,7,8,0,0.04,255},
    [3] = {8,0,0,82,0,0,0,255},
    [4] = {8,59,32,59,0,0,0.16,255},
    [5] = {8,13,35,13,0,0,0.07,150},
    [6] = {8,55,38,55,0,0,0.18,150},
    [7] = {8,70,100,100,0,0,0.17,120},
    [8] = {8,70,80,100,0,0,0.15,150},
    [9] = {8,60,70,90,0,0,0.1,130},
    [10] = {10,55,200,55,0,0,0.32,150},
    [11] = {8,79,53,90,0,0,0.085,150},
    [12] = {8,80,52,90,0,0,0.085,150},
    [13] = {8,80,52,91,0,0,0.085,150},
    [14] = {8,81,50,88,0,0,0.085,100},
    [15] = {8,82,51,88,0,0,0.085,100},
    [16] = {8,49,31,56,0,0,0.046,100},
    [17] = {8,50,31,55,0,0,0.046,100},
    [18] = {10,5,5,5,5,0,0.046,100},
    [19] = {10,5,5,5,5,0,0.046,100},
    [20] = {10,5,5,5,5,0,0.046,100},
    [21] = {10,5,5,5,5,0,0.046,100},
    [24] = {10,48,38,48,0,0,0.07,255},
    [25] = {10,67,65,67,0,0,0.12,255},
    [26] = {10,70,74,70,0,0,0.131,255},
    [27] = {10,70,100,70,0,0.16,255},
    [28] = {14,0,0,0,0,0,0.16,100},
    [29] = {14,0,0,0,0,0,0.16,100},
    [30] = {6,80,77,73,0,0,0.16,150},
    [31] = {6,85,64,67,0,0,0.07,150},
    [32] = {6,66,60,54,0,0,0.16,150},
    [33] = {6,85,85,85,85,0,0,150},
}

function MainError(errinfo)
    if errinfo then
        SL:Print("--------------------------------------")
        SL:Print(errinfo)
        SL:Print("--------------------------------------")
    end
end

local function init()
    SL:Require("GUILayout/main", true)
end

local result, errinfo = pcall(init)
if not result then
    MainError(errinfo)
end

local function pressedCB()

    cogin.teshudata = SL:Require("GUILayout/Data/teshudata.lua", true)


    for k, _ in pairs(package.loaded) do
        if string.find(k, "^ssr/ssrgame/") or string.find(k, "^GUILayout") or string.find(k, "^GUIExport") then
            package.loaded[k] = nil
        end
    end
    local result, errinfo = pcall(init)
    if not result then
        MainError(errinfo)
    end
    SL:print("脚本加载成功")
end
local bind_money = {
    ["金币"] = {3,1},--金币 金币
    ["元宝"] = {4,2},--元宝 元宝
    ["灵石"] = {8,7},--灵石 灵石
    ["剧情点"] = {9}--剧情点
}
--检查 物品 货币 装备是否满足数量(数量不足返回不足物品的名字) --文型
function checkItemNumByTable(t, multiple)
    local str = ""
    for _,item in ipairs(t) do
        local idx,num = SL:GetMetaValue("ITEM_INDEX_BY_NAME",item[1]),item[2]
        if multiple then num=num*multiple end
        if bind_money[item[1]] then
            str = str .. "<a href='jump#item_tips#"..idx.."'>[<font color='#FFFF00'>"..item[1].."</font>]</a>" .. ((SL:GetMetaValue("ITEM_COUNT", bind_money[item[1]][1]) + SL:GetMetaValue("ITEM_COUNT", bind_money[item[1]][2])) >= num and "<font color='#4AE74A'>"..SL:GetSimpleNumber(SL:GetMetaValue("ITEM_COUNT", bind_money[item[1]][1]) + SL:GetMetaValue("ITEM_COUNT", bind_money[item[1]][2])).."</font>" or "<font color='#FB0000'>"..SL:GetSimpleNumber((SL:GetMetaValue("ITEM_COUNT", bind_money[item[1]][1]) + SL:GetMetaValue("ITEM_COUNT", bind_money[item[1]][2]))).."</font>") .."/"..SL:GetSimpleNumber(num)..'\n'
        else
            str = str .. "<a href='jump#item_tips#"..idx.."'>[<font color='#FFFF00'>"..item[1].."</font>]</a>" .. (SL:GetMetaValue("ITEM_COUNT", idx) >= num and "<font color='#4AE74A'>"..SL:GetSimpleNumber(SL:GetMetaValue("ITEM_COUNT", idx)).."</font>" or "<font color='#FB0000'>"..SL:GetSimpleNumber(SL:GetMetaValue("ITEM_COUNT", idx)).."</font>") .."/"..SL:GetSimpleNumber(num)..'\n'
        end
    end
    return str
end

function checkItemNumByTable_only(t, multiple)
    local str = ""
    for _,item in ipairs(t) do
        local idx,num = SL:GetMetaValue("ITEM_INDEX_BY_NAME",item[1]),item[2]
        if multiple then num=num*multiple end
        if bind_money[item[1]] then
            str = str .. "<a href='jump#item_tips#"..idx.."'>[<font color='#FFFF00'>"..item[1].."</font>]</a>" .. ((SL:GetMetaValue("ITEM_COUNT", bind_money[item[1]][1]) + SL:GetMetaValue("ITEM_COUNT", bind_money[item[1]][2])) >= num and "<font color='#4AE74A'>"..SL:GetSimpleNumber(SL:GetMetaValue("ITEM_COUNT", bind_money[item[1]][1]) + SL:GetMetaValue("ITEM_COUNT", bind_money[item[1]][2])).."</font>" or "<font color='#FB0000'>"..SL:GetSimpleNumber((SL:GetMetaValue("ITEM_COUNT", bind_money[item[1]][1]) + SL:GetMetaValue("ITEM_COUNT", bind_money[item[1]][2]))).."</font>") .."/"..SL:GetSimpleNumber(num)..''
        else
            str = str .. "<a href='jump#item_tips#"..idx.."'>[<font color='#FFFF00'>"..item[1].."</font>]</a>" .. (SL:GetMetaValue("ITEM_COUNT", idx) >= num and "<font color='#4AE74A'>"..SL:GetSimpleNumber(SL:GetMetaValue("ITEM_COUNT", idx)).."</font>" or "<font color='#FB0000'>"..SL:GetSimpleNumber(SL:GetMetaValue("ITEM_COUNT", idx)).."</font>") .."/"..SL:GetSimpleNumber(num)..''
        end
    end
    return str
end

--检查 物品 货币 装备是否满足数量(数量不足返回不足物品的名字)---图文型
function checkItemNumByTable_img(t, multiple,parent)
    local Node = GUI:Node_Create(parent, "Node_cl", 0.00, 0.00)
    local cllist = GUI:ListView_Create(Node, "cllist", 0, 0, 999, 50, 2)
    GUI:ListView_setClippingEnabled(cllist, false)
    GUI:setTouchEnabled(cllist, false)

    for i,item in ipairs(t) do
        local idx,num = SL:GetMetaValue("ITEM_INDEX_BY_NAME",item[1]),item[2]
        if multiple then num=num*multiple end
        GUI:Layout_Create(cllist, "itemkk"..i, 0, 0, 5, 50, 1)
        GUI:ItemShow_Create(cllist, "item"..i, 0, 0, {index=idx,look= true})
        if bind_money[item[1]] then
            GUI:Text_Create(cllist, "sl"..i, 0, 0, 16,
                    (SL:GetMetaValue("ITEM_COUNT", bind_money[item[1]][1]) + SL:GetMetaValue("ITEM_COUNT", bind_money[item[1]][2])) >= num and "#4AE74A" or "#FB0000"
            , SL:GetSimpleNumber((SL:GetMetaValue("ITEM_COUNT", bind_money[item[1]][1]) + SL:GetMetaValue("ITEM_COUNT", bind_money[item[1]][2])),0))
        else
            GUI:Text_Create(cllist, "sl"..i, 0, 0, 16, SL:GetMetaValue("ITEM_COUNT", idx) >= num and "#4AE74A" or "#FB0000", SL:GetSimpleNumber(SL:GetMetaValue("ITEM_COUNT",idx),2))

        end
        GUI:Text_Create(cllist, "xysl"..i, 0, 0, 16, "#FFFFFF", "/"..SL:GetSimpleNumber(num,2))
    end
    return Node
end


-- 物品 展示
function ItemNumByTable(t, multiple)
    local str = ""
    for _,item in ipairs(t) do
        local idx,num = SL:GetMetaValue("ITEM_INDEX_BY_NAME",item[1]),item[2]
        if multiple then num=num*multiple end
        str = str .. "<a href='jump#item_tips#"..idx.."'>["..item[1].."]</a>" .."*"..SL:GetSimpleNumber(num,2)..'\n'
    end
    return str
end

-- 物品 展示
function ItemNumByTable_img(t, multiple,parent)
    local Node = GUI:Node_Create(parent, "Node_cl_show", 0.00, 0.00)
    local cllist = GUI:ListView_Create(Node, "cllist", 0, 0, 999, 50, 2)
    GUI:ListView_setClippingEnabled(cllist, false)
    GUI:ListView_setItemsMargin(cllist, 10)
    GUI:setTouchEnabled(cllist, false)
    for i,item in ipairs(t) do
        local idx,num = SL:GetMetaValue("ITEM_INDEX_BY_NAME",item[1]),item[2]
        if multiple then num=num*multiple end
        local kuang = GUI:Image_Create(cllist, "kuang"..i, 0, 0, "res/wy/public/50-50_k.png")
        GUI:setLocalZOrder(kuang, 1)
        local itemLayer = GUI:Node_Create(kuang, "item_layer", 0, 0)
        GUI:setLocalZOrder(itemLayer, 20)
        local itemShow = GUI:ItemShow_Create(itemLayer, "item", 9, 9, {index=idx,count = num,look= true})
        GUI:setLocalZOrder(itemShow, 20)
    end
    return Node
end

-- 物品 展示
function ItemNumByTable_img_new(t, multiple,parent)
    local Node = GUI:Node_Create(parent, "Node_cl_show", 0.00, 0.00)
    local cllist = GUI:ListView_Create(Node, "cllist", 0, 0, 999, 50, 2)
    GUI:ListView_setClippingEnabled(cllist, false)
    GUI:ListView_setItemsMargin(cllist, 10)
    GUI:setTouchEnabled(cllist, false)
    GUI:setLocalZOrder(cllist, 99)
    for i,item in ipairs(t) do
        local idx,num = SL:GetMetaValue("ITEM_INDEX_BY_NAME",item[1]),item[2]
        if multiple then num=num*multiple end
        local kuang = GUI:Image_Create(cllist, "kuang"..i, 0, 0, "res/wy/public/58-60.png")
        GUI:setLocalZOrder(kuang, 1)
        local itemLayer = GUI:Node_Create(kuang, "item_layer", 0, 0)
        GUI:setLocalZOrder(itemLayer, 20)
        local itemShow = GUI:ItemShow_Create(itemLayer, "item", 58/2, 60/2, {index=idx,count = num,look= true})
        GUI:setAnchorPoint(itemShow, 0.5, 0.5)
        GUI:setLocalZOrder(itemShow, 20)
    end
    return Node
end

--检查 物品 货币 装备是否满足数量(数量不足返回不足物品的名字)---图文型
function checkItemNumByTable_img_kuang(t, multiple,parent)
    local Node = GUI:Node_Create(parent, "Node_cl", 0.00, 0.00)
    local cllist = GUI:ListView_Create(Node, "cllist", 0, 0, 999, 50, 2)
    GUI:ListView_setClippingEnabled(cllist, false)
    GUI:setTouchEnabled(cllist, false)
    GUI:ListView_setItemsMargin(cllist, 20)

    for i,item in ipairs(t) do
        local idx,num = SL:GetMetaValue("ITEM_INDEX_BY_NAME",item[1]),item[2]
        if multiple then num=num*multiple end
        GUI:Layout_Create(cllist, "itemkk"..i, 0, 0, 5, 50, 1)
        local kuang = GUI:Image_Create(cllist, "item_kuang_"..idx, 0.00, 0.00, "res/wy/public/58-60.png")
        GUI:setLocalZOrder(kuang, 1)
        local itemLayer = GUI:Node_Create(kuang, "item_layer", 0, 0)
        GUI:setLocalZOrder(itemLayer, 20)
        local itemShow = GUI:ItemShow_Create(itemLayer, "item"..i, 58/2, 60/2, {index=idx,look= true})
        GUI:setAnchorPoint(itemShow, 0.5, 0.5)
        GUI:setLocalZOrder(itemShow, 20)
        local currentText
        if bind_money[item[1]] then
            currentText = GUI:Text_Create(itemLayer, "sl"..i, 40, 0, 14,
                    (SL:GetMetaValue("ITEM_COUNT", bind_money[item[1]][1]) + SL:GetMetaValue("ITEM_COUNT", bind_money[item[1]][2])) >= num and "#4AE74A" or "#FB0000"
            , SL:GetSimpleNumber((SL:GetMetaValue("ITEM_COUNT", bind_money[item[1]][1]) + SL:GetMetaValue("ITEM_COUNT", bind_money[item[1]][2])),0))
        else
            currentText = GUI:Text_Create(itemLayer, "sl"..i, 40, 0, 14, SL:GetMetaValue("ITEM_COUNT", idx) >= num and "#4AE74A" or "#FB0000", SL:GetSimpleNumber(SL:GetMetaValue("ITEM_COUNT",idx),2))
        end
        GUI:setAnchorPoint(currentText, 1, 0)
        GUI:setLocalZOrder(currentText, 30)

        local needText = GUI:Text_Create(itemLayer, "xysl"..i, 40, 0, 14, "#FFFFFF", "/"..SL:GetSimpleNumber(num,2))
        GUI:setAnchorPoint(needText, 0, 0)
        GUI:setLocalZOrder(needText, 30)
    end
    return Node
end


-- tip通用
function tip_node(node, tip)
    if SL:GetMetaValue("WINPLAYMODE") then
        GUI:addMouseMoveEvent(node, {onEnterFunc = function()
            local pos = GUI:getWorldPosition(node)
            SL:OpenCommonDescTipsPop({str = tip, worldPos = {x = pos.x, y = pos.y}, anchorPoint = {x = 0, y = 0}, formatWay = 1})
        end, onLeaveFunc = function()
            SL:CloseCommonDescTipsPop()
        end})
    else
        GUI:setTouchEnabled(node, true)
        GUI:addOnTouchEvent(node, function(self)
            local pos = GUI:getWorldPosition(node)
            SL:OpenCommonDescTipsPop({str = tip, worldPos = {x = pos.x, y = pos.y}, anchorPoint = {x = 0, y = 0}, formatWay = 1})
        end)
    end
end

-- 备注：给弹层绑定拖动与位置记忆。
-- dragNode：响应拖动的控件。
-- rootNode：实际被移动的弹层根节点。
-- owner/cacheKey：位置缓存写回的位置表与字段名。
-- defaultPos：首次打开时的默认位置。
function bind_drag_popup_memory(dragNode, rootNode, owner, cacheKey, defaultPos)
    if not dragNode or not rootNode or type(owner) ~= "table" or type(cacheKey) ~= "string" then
        return
    end

    local pos = owner[cacheKey]
    if type(pos) ~= "table" then
        pos = defaultPos or {x = 0, y = 0}
    end
    GUI:setPosition(rootNode, tonumber(pos.x) or 0, tonumber(pos.y) or 0)
    owner[cacheKey] = {x = tonumber(pos.x) or 0, y = tonumber(pos.y) or 0}

    GUI:setTouchEnabled(dragNode, true)
    GUI:addOnTouchEvent(dragNode, function(sender, eventType)
        if eventType == SLDefine.TouchEventType.began then
            sender._drag_begin_touch = GUI:getTouchBeganPosition(sender)
            sender._drag_begin_root = GUI:getPosition(rootNode)
        elseif eventType == SLDefine.TouchEventType.moved then
            local beginTouch = sender._drag_begin_touch
            local beginRoot = sender._drag_begin_root
            local moveTouch = GUI:getTouchMovePosition(sender)
            if beginTouch and beginRoot and moveTouch then
                local moveX = math.floor((beginRoot.x or 0) + (moveTouch.x - beginTouch.x))
                local moveY = math.floor((beginRoot.y or 0) + (moveTouch.y - beginTouch.y))
                GUI:setPosition(rootNode, moveX, moveY)
                owner[cacheKey] = {x = moveX, y = moveY}
            end
        elseif eventType == SLDefine.TouchEventType.ended or eventType == SLDefine.TouchEventType.canceled then
            owner[cacheKey] = GUI:getPosition(rootNode)
        end
    end)
end

local function _dl_to_num(v, defaultValue)
    local n = tonumber(v)
    if n == nil then
        return defaultValue or 0
    end
    return n
end

local _dl_get_json

local function _dl_get_mainline_progress()
    local uNum = _dl_to_num(Player:getServerVar("U_zxrw"), 0)
    if uNum > 0 then
        return uNum
    end
    uNum = _dl_to_num(Player:getServerVar("U11"), 0)
    if uNum > 0 then
        return uNum
    end
    return 0
end

local _dl_xyl_cfg_cache
local function _dl_get_xyl_cfg()
    if _dl_xyl_cfg_cache ~= nil then
        return _dl_xyl_cfg_cache
    end
    local ok, cfg = pcall(function()
        return SL:Require("GUILayout/Data/xyl.lua", true)
    end)
    _dl_xyl_cfg_cache = (ok and type(cfg) == "table") and cfg or false
    return _dl_xyl_cfg_cache
end

local function _dl_get_story_point(task)
    local rewards = type(task) == "table" and task.jl or nil
    if type(rewards) ~= "table" then
        return 0
    end
    local total = 0
    for _, reward in ipairs(rewards) do
        if type(reward) == "table" and reward[1] == "剧情点" then
            total = total + _dl_to_num(reward[2], 0)
        end
    end
    return total
end

local function _dl_has_story_progress(continent, needPercent)
    local cfg = _dl_get_xyl_cfg()
    local chapters = type(cfg) == "table" and cfg[continent] or nil
    if type(chapters) ~= "table" then
        return false
    end
    local ywl = _dl_get_json("T26")
    local total = 0
    local received = 0
    for chapter_idx, chapter in ipairs(chapters) do
        local tasks = type(chapter) == "table" and chapter.jq or nil
        if type(tasks) == "table" then
            local chapter_key = "jl_" .. continent .. "_" .. chapter_idx
            local chapter_received = _dl_to_num(ywl[chapter_key], 0) == 1
            for task_idx, task in ipairs(tasks) do
                local point = _dl_get_story_point(task)
                total = total + point
                if point > 0 and (chapter_received or _dl_to_num(ywl[chapter_key .. "_" .. task_idx], 0) == 1) then
                    received = received + point
                end
            end
        end
    end
    if total <= 0 then
        return false
    end
    return received * 100 >= total * (_dl_to_num(needPercent, 100))
end

local function _dl_get_jqd()
    local count = _dl_to_num(Player:getServerVar("JQD"), 0)
    if count > 0 then
        return count
    end

    count = _dl_to_num(SL:GetMetaValue("ITEM_COUNT", 9), 0)
    if count > 0 then
        return count
    end

    count = _dl_to_num(SL:GetMetaValue("MONEY_ASSOCIATED", 9), 0)
    if count > 0 then
        return count
    end

    count = _dl_to_num(SL:GetMetaValue("TMONEY", "剧情点"), 0)
    if count > 0 then
        return count
    end

    return 0
end

local function _dl_get_zslv()
    local zslv = _dl_to_num(Player:getServerVar("U43"), 0)
    if zslv > 0 then
        return zslv
    end
    return _dl_to_num(SL:GetMetaValue("RELEVEL"), 0)
end

-- 大陆门槛：读取人物等级，四大陆起需要校验 150 级条件。
local function _dl_get_level()
    return _dl_to_num(SL:GetMetaValue("LEVEL"), 0)
end

-- 大陆门槛：读取服务端 JSON 变量，给灵根/命盘判定复用。
_dl_get_json = function(varName)
    return Player:JsonToTbl(Player:getServerVar(varName))
end

-- 大陆门槛：检查是否拥有指定称号。
local function _dl_has_title(titleName)
    if not titleName or titleName == "" then
        return false
    end
    local idx = _dl_to_num(SL:GetMetaValue("ITEM_INDEX_BY_NAME", titleName), 0)
    if idx <= 0 then
        return false
    end
    return SL:GetMetaValue("TITLE_DATA_BY_ID", idx) ~= nil
end

-- 大陆门槛：五大陆要求 10 种灵根均已激活。
local function _dl_has_all_linggen()
    local data = _dl_get_json("T41")
    local levels = type(data.level) == "table" and data.level or {}
    for i = 1, 10 do
        if _dl_to_num(levels[tostring(i)] or levels[i], 0) <= 0 then
            return false
        end
    end
    return true
end

-- 大陆门槛：六大陆要求完成天道命盘，客户端按 npc_74 的 all 计数判定。
local function _dl_has_all_destiny()
    local jqData = _dl_get_json("T13")
    local state = type(jqData["npc_74"]) == "table" and jqData["npc_74"] or {}
    local cfgList = (type(teshudata) == "table" and teshudata)
        or (cogin and type(cogin.teshudata) == "table" and cogin.teshudata)
        or {}
    local cfg = type(cfgList["npc_74"]) == "table" and cfgList["npc_74"] or {}
    local need = _dl_to_num(cfg.all, 4)
    return _dl_to_num(state.all, 0) >= need
end

local function _dl_is_all_unlocked()
    if cogin and cogin.sjtb and _dl_to_num(cogin.sjtb.dl_all_unlock, 0) >= 1 then
        return true
    end
    if _dl_get_zslv() >= 70 and _dl_get_level() >= 150 then
        return true
    end
    return _dl_to_num(Player:getServerVar("U_全大陆解锁"), 0) >= 1
end

local function _dl_check(dl)
    dl = _dl_to_num(dl, 0)
    if dl == 1 then
        return true
    end
    if _dl_is_all_unlocked() then
        return true
    end

    local zxrw = _dl_get_mainline_progress()
    local zslv = _dl_get_zslv()
    local jqd = _dl_get_jqd()
    local level = _dl_get_level()

    if dl == 2 then
        if zxrw >= 16 then
            return true
        end
        return false, "需完成主线引导后才可进入二大陆"
    elseif dl == 3 then
        if zxrw >= 35 then
            return true
        end
        return false, "需跟随主线引导后才可进入三大陆"
    elseif dl == 4 then
        if _dl_has_story_progress(3, 85) and zslv >= 30 and level >= 150 then
            return true
        end
        return false, "需三大陆剧情完成度达到85%、完成三大陆转生且人物等级达到150级后才可进入四大陆"
    elseif dl == 5 then
        if _dl_has_story_progress(4, 95) and zslv >= 40 and _dl_has_all_linggen() then
            return true
        end
        return false, "需四大陆剧情完成度达到95%、完成四大陆转生且激活全部灵根后才可进入五大陆"
    elseif dl == 6 then
        if _dl_has_story_progress(5, 95) and zslv >= 50 and _dl_has_all_destiny() then
            return true
        end
        return false, "需五大陆剧情完成度达到95%、完成五大陆转生且完成天道命盘后才可进入六大陆"
    elseif dl == 7 then
        if _dl_has_story_progress(6, 100) and zslv >= 60 and _dl_has_title("世界符文·[真我]") then
            return true
        end
        return false, "需六大陆剧情完成度达到100%、完成六大陆转生且获得世界符文·[真我]后才可进入七大陆"
    elseif dl == 8 then
        if zslv >= 70 then
            return true
        end
        return false, "需完成七大陆转生后才可进入八大陆"
    end

    return true
end
function dl_sz(i)
    local ok,opened = _dl_check(i)
    return ok
end
-- 0:不显示 1显示但是不可提升 2显示且可提升 3已经满级
function slts_jz(idx, idx_x)

end

function checkItemNum(t, multiple)
    for _,item in ipairs(t) do
        local idx,num = SL:GetMetaValue("ITEM_INDEX_BY_NAME",item[1]),item[2]
        if multiple then num=num*multiple end
        if bind_money[item[1]] then
            if (SL:GetMetaValue("ITEM_COUNT", bind_money[item[1]][1]) + SL:GetMetaValue("ITEM_COUNT", bind_money[item[1]][2])) < num then
                return false
            end
        else
            if SL:GetMetaValue("ITEM_COUNT", idx) < num then
                return false
            end
        end
    end
    return true
end


-- 深拷贝函数
function deepCopy(orig, copies)
    copies = copies or {}  -- 防止循环引用
    if type(orig) ~= "table" then
        return orig
    elseif copies[orig] then
        return copies[orig]
    end

    local copy = {}
    copies[orig] = copy
    for k, v in pairs(orig) do
        copy[deepCopy(k, copies)] = deepCopy(v, copies)
    end

    -- 如果想复制元表
    local mt = getmetatable(orig)
    if mt then
        setmetatable(copy, deepCopy(mt, copies))
    end

    return copy
end


-- 小地图怪物数据刷新
SL:RegisterLUAEvent(LUA_EVENT_MINIMAP_MONSTER, "GUIUtil", function ()
    local parent = GUI:GetWindow(GUI:Attach_SceneB(), "bossInfo")
    if parent then
        GUI:removeAllChildren(parent)
    else
        parent = GUI:Node_Create(GUI:Attach_SceneB(), "bossInfo", 0, 0)
    end
    local monsters = SL:GetMetaValue("MAP_GET_MONSTERS")
    for _, v in pairs(monsters) do
        local posM = SL:ConvertMapPos2WorldPos(tonumber(v.x) or 1, tonumber(v.y) or 1)
        local node = GUI:Node_Create(parent, string.format("boss_text%s_%s%s", v.name, posM.x, posM.y), posM.x, posM.y)
        GUI:Effect_Create(node, "effect", 0,0, 1, 220, 0, 0, 0, 1)
        local text = GUI:Text_Create(node, "bossName",-15,20, 16, "#FF00FF", v.name)
        GUI:Text_setTextAreaSize(text, {width = 100, height = 20})
        GUI:Text_setTextHorizontalAlignment(text, 1)
        text = GUI:Text_Create(node, "downTime",-15,0, 16, "#FF0000", "")
        GUI:Text_setTextAreaSize(text, {width = 100, height = 20})
        GUI:Text_setTextHorizontalAlignment(text, 1)
        GUI:Text_COUNTDOWN(text, v.time, function ()
            GUI:removeFromParent(node)
        end)
    end
end)

SL:RegisterLUAEvent(LUA_EVENT_MAPINFOCHANGE, "GUIUtil", function ()
    SL:RequestMiniMapMonsters()
end)

SL:RegisterLUAEvent(LUA_EVENT_MONSTER_DIE, "GUIUtil", function (data)
    if not data or not data.id then return end
    local boss_list = SL:GetMetaValue("MAP_GET_MONSTERS")
    local is_boss = false
    for _, v in pairs(boss_list) do
        if v.name == SL:GetMetaValue("ACTOR_NAME", data.id) then
            is_boss = true
            break
        end
    end
    if is_boss then
        SL:RequestMiniMapMonsters()
    end
end)


GUI:addKeyboardEvent({"KEY_CTRL","KEY_5"}, pressedCB)
