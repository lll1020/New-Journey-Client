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
for v,k in pairs(cogin.hs.zzhs)  do
    for vv,kk in pairs(k)  do
        for vvv,kkk in pairs(kk.l)  do
            cogin.huishou_jc_list[vvv] = kkk
            cogin.huishou_jc_list[vvv].gl = 1
        end
    end
end
for v,k in pairs(cogin.hs.zsfj)  do
    for vv,kk in pairs(k.l)  do
        cogin.huishou_jc_list[vv] = kk
        cogin.huishou_jc_list[vv].gl = 2
    end
end
for v,k in pairs(cogin.hs.clfj)  do
    for vv,kk in pairs(k.l)  do
        cogin.huishou_jc_list[vv] = kk
        cogin.huishou_jc_list[vv].gl = 3
    end
end
for v,k in pairs(cogin.hs.kexiaohui)  do
    cogin.huishou_jc_list[v] = k
end
for v,k in pairs(cogin.hs.fzfj)  do
    for vv,kk in pairs(k)  do
        for vvv,kkk in pairs(kk.l)  do
            cogin.huishou_jc_list[vvv] = kkk
            cogin.huishou_jc_list[vvv].gl = 4
        end
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
    ["元宝"] = {3,1},--元宝
    ["灵符"] = {4,2},--灵符
    ["仙玉"] = {8,7}--仙玉
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
    GUI:ListView_setItemsMargin(cllist, 5)
    GUI:setTouchEnabled(cllist, false)
    for i,item in ipairs(t) do
        local idx,num = SL:GetMetaValue("ITEM_INDEX_BY_NAME",item[1]),item[2]
        if multiple then num=num*multiple end
        local kuang = GUI:Image_Create(cllist, "kuang"..i, 0, 0, "res/wy/public/50-50_k.png")
        GUI:ItemShow_Create(kuang, "item", 9, 9, {index=idx,count = num,look= true})
    end
    return Node
end
function dl_sz(i)
    if i == 0 then
        return true
    elseif i == 1 and cogin.sjtb.dljq and cogin.sjtb.rwid >= 8 then
        return true
    else
        return false
    end
    return true
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