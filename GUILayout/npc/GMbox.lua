local GMBoxOBJ = {}

GMBoxOBJ.__cname = "GMBoxOBJ"

local function selectListSplit(str)
    local selectList = {}
    local list = SL:Split(str, "|")
    for i, v in ipairs(list) do
        local value = SL:Split(v, "#")
        local index = value[1]
        selectList[tonumber(index)] = { select = SL:Split(value[2], "^"), show = SL:Split(value[3], "^") }
        -- SL:dump(value,"-拆分1-")
    end
    return selectList
end

local function defaultSplit(str)
    local default = {}
    local list = SL:Split(str, "|")
    for i, v in ipairs(list) do
        local value = SL:Split(v, "#")
        local index = tonumber(value[1]) or 0
        default[index] = value
        -- SL:dump(default,"-拆分2-")
    end
    return default
end

local function splitString(str)
    local result = {}
    for cmd in str.gmatch(str, "%S+") do
        result[#result + 1] = cmd
    end
    return result
end

local function insert(cfg, data, maxLength)
    maxLength = maxLength or 10
    table.insert(cfg, 1, data)
    local size = #cfg
    if size > maxLength then
        for i = size, maxLength, -1 do
            cfg[i] = nil
        end
    end
end

GMBoxOBJ.config = {}
GMBoxOBJ.config = GMBoxOBJ.cfg
GMBoxOBJ.dataTmp = { }
GMBoxOBJ.tmpI = 0
function GMBoxOBJ:OpenUI(arg1, arg2, arg3, data)
    self.tmpI = self.tmpI + 1
    table.insert(self.dataTmp,data)
    if self.tmpI == arg1 then
        GMBoxOBJ:main()
    end
end

function GMBoxOBJ:main()
    self.cfg = {}
    local _cfg = SL:JsonDecode(table.concat(self.dataTmp))
    self.dataTmp = {}
    self.tmpI = 0
    for _, v in ipairs(_cfg) do
        self.cfg[v.page] = self.cfg[v.page] or { title = v.pageName }
        self.cfg[v.page][#self.cfg[v.page] + 1] = {
            page = v.page,
            index = v.index,
            title = v.title,
            Command = v.Command,
            RegisterNetMsg = v.RegisterNetMsg,
            default = v.default and defaultSplit(v.default),
            selectList = v.selectList and selectListSplit(v.selectList),
        }
    end
    table.insert(self.cfg, 1, {})

    local parent = GUI:Win_Create(self.__cname, 0, 0, 0, 0, false, false, true, false)
    self._parent = parent
    self.btnName = "btn_switch_%d_%d"
    self.path = { [true] = "res/public/1900000657.png", [false] = "res/public/1900000656.png" }

    --加载UI
    GUI:LoadExport(parent, "A/GMBoxUI", function()
        self.ui = GUI:ui_delegate(parent)
        ssrSetWidgetPosition(parent, self.ui.FrameLayout, 2, 0)
        --界面拖拽
        GUI:Win_SetDrag(parent, self.ui.FrameLayout)

        --收藏/加星数据
        self.cfg[1] = {}
        local jsonStr = SL:GetLocalString(self.__cname)
        if jsonStr and string.len(jsonStr) > 0 then
            self.cfg[1] = SL:JsonDecode(jsonStr) or {}
        end
        self.cfg[1].title = "我的收藏"

        --收藏/加星数据增删
        GUI:addOnClickEvent(self.ui.star, function()
            local cfg = self.cfg[self.page1] and self.cfg[self.page1][self.page2]
            if cfg then
                local isStar = true
                for k, v in ipairs(self.cfg[1] or {}) do
                    if v.page == cfg.page and v.index == cfg.index then
                        table.remove(self.cfg[1], k)
                        isStar = false
                        break
                    end
                end
                if isStar then
                    insert(self.cfg[1], cfg, 50)
                end
                GUI:Button_loadTextureNormal(self.ui.star, self.path[isStar])
                SL:ShowSystemTips(isStar and "收藏成功" or "取消收藏")

                SL:scheduleOnce(self.ui.star, function()
                    GUI:setTouchEnabled(self.ui.star, true)
                    GUI:removeAllChildren(self.ui.star)
                end, 0.5)
                if self.page1 == 1 then
                    self.page1 = nil
                    self:createBtn()
                else
                    GUI:setTouchEnabled(self.ui.star, false)
                    GUI:setVisible(self.ui.star, false)
                    local posM = GUI:getPosition(self.ui.star)
                    --圆形进度条
                    local heroProgress = GUI:ProgressTimer_Create(self.ui.Panel_1, "heroProgress", posM.x, posM.y, self.path[isStar])
                    GUI:ProgressTimer_setPercentage(heroProgress, 0)
                    GUI:ProgressTimer_progressFromTo(heroProgress, 0.2, 0, 100, function()
                        GUI:removeFromParent(heroProgress)
                        GUI:setTouchEnabled(self.ui.star, true)
                        GUI:setVisible(self.ui.star, true)
                    end)
                end
            end
        end)

        --缓存命令
        local varName = self.__cname .. "_cmd"
        self.cmdList = {}
        jsonStr = SL:GetLocalString(varName)
        if jsonStr and string.len(jsonStr) > 0 then
            self.cmdList = SL:JsonDecode(jsonStr) or {}
        end
        --发送命令
        GUI:addOnClickEvent(self.ui.Button_send, function()
            if self.cacheCmd then
                insert(self.cmdList, self.cacheCmd)
                SL:Print("-cmd-", self.cacheCmd)
                SL:SendGMMsgToChat(self.cacheCmd)
                GUI:TextInput_setString(self.cacheInput, "")
                self.cmdIndex = nil
                self.cacheCmd = nil
                return
            end
            local cfg = self.cfg[self.page1] and self.cfg[self.page1][self.page2]
            if not cfg then
                return
            end
            local cmd = ""
            for i, str in ipairs(self.cmd) do
                str = tostring(str)
                if i == 1 then
                    cmd = str:gsub("@", "")
                else
                    cmd = cmd .. " " .. str:gsub(" ", "")
                end
            end
            if cfg.RegisterNetMsg and self.cmd[cfg.RegisterNetMsg] then
                --注册网络消息
                self:RegisterNetMsg(self.cmd[cfg.RegisterNetMsg])
            end

            insert(self.cmdList, cmd)
            self.cmdIndex = nil
            self.cacheCmd = nil
            --SL:Print("-cmd-",cmd)
            SL:SendGMMsgToChat(cmd)
        end)

        --关闭按钮
        GUI:addOnClickEvent(self.ui.CloseButton, function()
            GUI:Win_Close(self._parent)
            self.cfg[1].title = nil

            -- SL:SetLocalString(self.__cname,  SL:JsonEncode({}))              --清空收藏命令
            SL:SetLocalString(self.__cname, SL:JsonEncode(self.cfg[1]))        --更新收藏命令
            -- SL:SetLocalString(varName,  SL:JsonEncode({}))              --清空收藏命令
            SL:SetLocalString(varName, SL:JsonEncode(self.cmdList))       --更新缓存命令
        end)

        --隐藏模板组件
        GUI:setVisible(self.ui.template_1, false)
        GUI:setVisible(self.ui.template_2, false)
        GUI:setVisible(self.ui.template_Command, false)

        --创建滚动条
        GUI:SetScrollViewVerticalBar(self.ui.FrameLayout, {
            bgPic = "res/private/gui_edit/scroll/line.png", -- 背景图
            barPic = "res/private/gui_edit/scroll/p.png", -- 滑动按钮图片
            Arr1PicN = "res/private/gui_edit/scroll/t.png", -- 上（正常图）
            Arr1PicP = "res/private/gui_edit/scroll/t_1.png", -- 上（按下图）可不传
            Arr2PicN = "res/private/gui_edit/scroll/b.png", -- 下（正常图）
            Arr2PicP = "res/private/gui_edit/scroll/b_1.png", -- 下（按下图）可不传
            default = 0, -- 进度条值（默认是0）
            x = 333, -- 进度条坐标 x
            y = 35, -- 进度条坐标 y
            list = self.ui.ListView_2    -- 滚动的容器 list
        })

        --创建右侧title
        local scrollText = GUI:ScrollText_Create(self.ui.Panel_1, "scrollTitle", 213, 416, 340, 14, "#FFFFFF", "")
        GUI:ScrollText_setHorizontalAlignment(scrollText, 2)
        GUI:ScrollText_enableOutline(scrollText, "#111111", 1)
        GUI:setAnchorPoint(scrollText, 0.5, 0.5)

        --创建输入框
        self:createInput()

        --创建页签按钮
        self:createBtn()
    end)
end

--网络消息
function GMBoxOBJ:RegisterNetMsg(msgID)
    SL:RegisterLuaNetMsg(tonumber(msgID), function(_msgID, p1, p2, p3, msgData)
        SL:Print("接收到网络消息", _msgID, p1, p2, p3, msgData)
    end, self._parent)
end

--创建输入框
function GMBoxOBJ:createInput()
    --搜索框
    local Input = GUI:TextInput_Create(self.ui.Image_Input_bg, "Input_select", 0, 2.00, 156.00 + 64, 25.00, 15)
    self.selectInput = Input
    GUI:TextInput_setString(Input, "")
    GUI:TextInput_setPlaceHolder(Input, "请输入搜索内容")
    GUI:TextInput_setFontColor(Input, "#ffffff")
    GUI:setTouchEnabled(Input, true)
    GUI:TextInput_setInputMode(Input, 6)

    --搜索按钮
    GUI:addOnClickEvent(self.ui.selectButton, function()
        local key = GUI:TextInput_getString(self.selectInput)
        local cfg = {}
        for _, var in ipairs(self.config) do
            local temp_c = {}
            for _, v in ipairs(var) do
                if string.find(v.title, key) then
                    temp_c[#temp_c + 1] = v
                end
            end
            if next(temp_c) then
                cfg[#cfg + 1] = temp_c
                cfg[#cfg].title = var.title
            end
        end
        if next(cfg) then
            self.page1 = nil
            self.cfg = cfg
            self:createBtn()
        else
            SL:ShowSystemTips("搜索失败~")
        end
    end)

    --缓存命令输入框
    Input = GUI:TextInput_Create(self.ui.Image_sendInput_bg, "Input_cache", 0, 2.00, 156.00 + 64 + 70, 25.00, 15)
    self.cacheInput = Input
    GUI:TextInput_setString(Input, "")
    GUI:TextInput_setPlaceHolder(Input, "")
    GUI:TextInput_setFontColor(Input, "#ffffff")
    GUI:setTouchEnabled(Input, true)
    GUI:TextInput_setInputMode(Input, 6)
    GUI:TextInput_closeInput(Input)
    GUI:TextInput_addOnEvent(Input, function(sender)
        self.cmdIndex = nil
        self.cacheCmd = nil
        GUI:TextInput_setString(sender, "")

        if not next(self.cmdList) then
            return
        end

        local posM = GUI:getWorldPosition(sender)
        if not posM then
            return
        end
        posM.y = posM.y + 35 + #self.cmdList * 30
        SL:OpenSelectListUI(self.cmdList, posM, 283, 30, function(change)
            if self.cmdList[change] then
                self.cacheCmd = self.cmdList[change]
                GUI:TextInput_setString(self.cacheInput, "@" .. self.cmdList[change])
            end
        end)
    end)

    --缓存命令按钮
    GUI:addOnClickEvent(self.ui.Button_input_5, function()
        if not next(self.cmdList) then
            return
        end
        self.cmdIndex = self.cmdIndex and self.cmdIndex + 1 or 1
        if not self.cmdList[self.cmdIndex] then
            self.cmdIndex = 1
        end
        self.cacheCmd = self.cmdList[self.cmdIndex]
        GUI:TextInput_setString(self.cacheInput, "@" .. self.cacheCmd)
    end)
end

--获取配置信息
---@param hierarchy number 层级
function GMBoxOBJ:getConfig(hierarchy)
    if hierarchy == 1 then
        return self.cfg or {}
    elseif hierarchy == 2 then
        return self.cfg[self.page1] or {}
    end
end

--页签创建
---@param hierarchy? number 层级
---@param page? number 页数
function GMBoxOBJ:createBtn(hierarchy, page)
    hierarchy = hierarchy or 1
    page = page or 1
    local listView = self.ui["ListView_" .. hierarchy]
    if not listView then
        return
    end
    GUI:removeAllChildren(listView)
    GUI:setVisible(self.ui.Panel_1, false)
    self.ui = GUI:ui_delegate(self._parent)
    --克隆按钮
    for i, cfg in ipairs(self:getConfig(hierarchy) or {}) do
        local ui_item = GUI:Clone(self.ui["template_" .. hierarchy])
        GUI:setVisible(ui_item, true)
        GUI:ListView_pushBackCustomItem(listView, ui_item)
        GUI:setName(ui_item, "btn_switch_" .. hierarchy .. "_" .. i)
        GUI:addOnClickEvent(ui_item, function()
            self:updatePageBtn(hierarchy, i)
        end)
        if hierarchy == 1 then
            GUI:Button_setTitleText(ui_item, cfg.title or "其他")
        else
            local scrollText = GUI:ScrollText_Create(ui_item, "scrollText", 80, 15, 150, 12, "#FFFFFF", cfg.title or "未命名")
            GUI:ScrollText_setHorizontalAlignment(scrollText, 2)
            GUI:ScrollText_enableOutline(scrollText, "#111111", 1)
            GUI:setAnchorPoint(scrollText, 0.5, 0.5)
        end
        if i == page then
            self:updatePageBtn(hierarchy, page)
        end
    end
end

--页签点击
---@param hierarchy number 层级
---@param tag number 页数
function GMBoxOBJ:updatePageBtn(hierarchy, tag)
    local listView = self.ui["ListView_" .. hierarchy]
    local page = self["page" .. hierarchy]
    --上一次选择按钮
    if page then
        local ui_item = self.ui[self.btnName:format(hierarchy, page)]
        if ui_item then
            GUI:Button_setBrightEx(ui_item, true)
            GUI:Button_setTitleColor(ui_item, "#D2B48C")
        end
    end

    if tag == page then
        return
    end

    --这一次选择按钮
    self["page" .. hierarchy] = tag
    local ui_item = GUI:getChildByName(listView, self.btnName:format(hierarchy, tag))
    if ui_item then
        GUI:Button_setBrightEx(ui_item, false)
        GUI:Button_setTitleColor(ui_item, "#F7E6C6")
    end

    --是否还有下一层,没有就更新右侧UI
    hierarchy = hierarchy + 1
    if self.ui["ListView_" .. hierarchy] then
        self["page" .. hierarchy] = nil
        self:createBtn(hierarchy)
    else
        self:updateDescUI()
    end
end

--更新右侧UI
function GMBoxOBJ:updateDescUI()
    local cfg = self.cfg[self.page1] and self.cfg[self.page1][self.page2]
    if not cfg then
        return
    end
    --更新右侧收藏/加星
    local bool = false
    if self.page1 == 1 then
        bool = true
    else
        for _, v in ipairs(self.cfg[1]) do
            if v.page == cfg.page and v.index == cfg.index then
                bool = true
                break
            end
        end
    end
    GUI:Button_loadTextureNormal(self.ui.star, self.path[bool])

    GUI:setVisible(self.ui.Panel_1, true)
    GUI:ScrollText_setString(self.ui.scrollTitle, cfg.title)

    GUI:removeAllChildren(self.ui.Layout_RichText)
    local richText = GUI:RichText_Create(self.ui.Layout_RichText, "richText", 0, 15, ("<u><a href='%s'>%s</a></u>"):format(cfg.Command, cfg.Command), 9999, 14, "#f8e6c6", 0, function(...)
        SL:SetMetaValue("CLIPBOARD_TEXT", cfg.Command)
        SL:ShowSystemTips("复制成功")
    end)
    GUI:setAnchorPoint(richText, 0, 0.5)

    GUI:removeAllChildren(self.ui.Layout_Command)
    local cmds = splitString(cfg.Command)
    self.cmd = {}
    if #cmds == 1 then
        self.cmd[1] = cmds[1]
        local size = GUI:getContentSize(self.ui.Layout_Command)
        richText = GUI:RichText_Create(self.ui.Layout_Command, "richText", size.width / 2, size.height / 2, "*温馨提示本指令无需参数。请直接点击确定按钮执行*", 9999, 14, "#f8e6c6")
        GUI:setAnchorPoint(richText, 0.5, 0.5)
    else
        for i = 1, #cmds do
            self.cmd[i] = cmds[i]
            if i > 1 then
                self.cmd[i] = ""
                local ui_item = GUI:Clone(self.ui.template_Command)
                GUI:setVisible(ui_item, true)
                GUI:setName(ui_item, "command_" .. i - 1)
                GUI:addChild(self.ui.Layout_Command, ui_item)
                GUI:Win_SetParam(ui_item, i)

                local handle = GUI:getChildByName(ui_item, "Layout_RichText2")
                if handle then
                    local size = GUI:getContentSize(handle)
                    richText = GUI:RichText_Create(handle, "rich" .. i, 80 + 85, size.height / 2, cmds[i] .. ":", 9999, 16, "#f8e6c6")
                    GUI:setAnchorPoint(richText, 1, 0.5)
                end

                local Input = GUI:TextInput_Create(ui_item, "Input_demo" .. i, 90 + 85.6, 2.00, 156.00, 25.00, 15)
                local str = ""
                if cfg.default and cfg.default[i] then
                    local default = cfg.default[i]
                    if default[3] then
                        str = SL:GetMetaValue(default[3])
                    else
                        str = default[2] or ""
                    end
                    Input.isFirstCilck = true
                end
                self.cmd[i] = str
                GUI:Win_SetParam(Input, i)
                GUI:TextInput_setString(Input, str)
                GUI:TextInput_setPlaceHolder(Input, "请输入")
                GUI:TextInput_setFontColor(Input, "#ffffff")
                GUI:setTouchEnabled(Input, true)
                GUI:TextInput_setInputMode(Input, 6)
                GUI:TextInput_addOnEvent(Input, function(sender)
                    if sender.isFirstCilck then
                        GUI:TextInput_setString(sender, "")
                        Input.isFirstCilck = false
                        return
                    end
                    self.cmd[i] = GUI:TextInput_getString(sender)
                end)
                local Button_List = GUI:getChildByName(ui_item, "Button_List")

                local bool = cfg.selectList and cfg.selectList[i]
                GUI:setVisible(Button_List, bool and true or false)
                GUI:setTouchEnabled(Input, not bool and true or false)
                if bool then
                    local select = bool and cfg.selectList[i].select
                    local show = bool and cfg.selectList[i].show
                    --下拉框
                    GUI:Win_SetParam(Button_List, i)
                    GUI:addOnClickEvent(Button_List, function(send)
                        local posM = GUI:getWorldPosition(send)
                        if not posM then
                            return
                        end
                        posM.x = posM.x - 158
                        SL:OpenSelectListUI(show, posM, 150, 30, function(change)
                            if select[change] then
                                self.cmd[i] = select[change]
                                GUI:TextInput_setString(Input, select[change])
                            end
                        end)
                    end)
                end
            end
        end
        GUI:UserUILayout(self.ui.Layout_Command, {
            dir = 1,
            addDir = 2,
            interval = 0.1,
            gap = { y = 10 },
            sortfunc = function(lists)
                table.sort(lists, function(a, b)
                    return GUI:Win_GetParam(a) < GUI:Win_GetParam(b)
                end)
            end
        })
    end
end

return GMBoxOBJ