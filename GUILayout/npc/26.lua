local npc = {}

npc._config = teshudata["npc_26"]



local WINDOW_OPTS = {
    background = {skin = "res/custom/two_city/qyzb/bg.png", eff = false},
    closeButton = {x = 850, y = 450,},
}
function npc.main(npcid, p2, p3, msgData)
    local SLOT_POSITIONS = {
        {x = 50, y = 170},
        {x = 240, y = 170},
        {x = 430, y = 170},
        {x = 620, y = 170},
        {x = 810, y = 170},
    }
    local ANIM_DELAYS = {0.05, 0.05, 0.06, 0.06, 0.07, 0.08, 0.10, 0.12, 0.15, 0.18, 0.22, 0.26}


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

    local function getCurrentTitleIndex()
        for idx, titleName in ipairs(npc._config.details or {}) do
            local titleID = SL:GetMetaValue("ITEM_INDEX_BY_NAME", titleName)
            if titleID and SL:GetMetaValue("TITLE_DATA_BY_ID", titleID) then
                return idx
            end
        end
        return 0
    end

    local function getSlotCenter(slotNode)
        if not slotNode then
            return nil
        end
        local size = slotNode:getContentSize()
        return {
            x = GUI:getPositionX(slotNode) + size.width / 2,
            y = GUI:getPositionY(slotNode) + size.height / 2,
        }
    end

    local function UI_updata(node, opts) --界面渲染
        if not node then
            return
        end
        opts = opts or {}
        local isFirstFree = tonumber(npc.data and npc.data.U_num or 0) <= 0

        GUI:removeAllChildren(node)
        for v,k in ipairs(npc._config.details) do
            local kuang = GUI:Image_Create(node, "kuang"..v, 50 + (v-1)*190, 170, "res/custom/two_city/qyzb/"..v..".png")
            -- UiTools.showItemData(kuang, SL:GetMetaValue("ITEM_DATA",SL:GetMetaValue("ITEM_INDEX_BY_NAME",k)))
            if (not opts.hideActiveFrame) and SL:GetMetaValue("TITLE_DATA_BY_ID", SL:GetMetaValue("ITEM_INDEX_BY_NAME",k)) then
                local contentSize = kuang:getContentSize()
                GUI:setAnchorPoint(GUI:Image_Create(kuang, "kuang", contentSize.width / 2, contentSize.height / 2, "res/custom/two_city/qyzb/kuang.png")
                , 0.5, 0.5)
            end
        end
        npc._lastTitleIndex = getCurrentTitleIndex()

        -- local cost = ItemNumByTable_img(npc._config.cost, nil,GUI:Node_Create(node, "cost", 0, 0))
        -- GUI:setPosition(cost, 800, 200)
        
        GUI:Text_setFontName(GUI:Text_Create(node, "U_num",860,55, 25, "#00FF95", npc.data.U_num or 0)
        , "fonts/500.ttf")

        local guaranteeText = "[占卜65次必出帝王]"
        if SL:GetMetaValue("TITLE_DATA_BY_ID", SL:GetMetaValue("ITEM_INDEX_BY_NAME",npc._config.details[5])) then
            guaranteeText = "已获得帝王之姿"
        end
        local guaranteeLabel = GUI:Text_Create(node, "guarantee_text", 48 + 668, 115, 25, "#F7DE91", guaranteeText)
        GUI:setAnchorPoint(guaranteeLabel, 0, 0.5)
        GUI:Text_setFontName(guaranteeLabel, "fonts/font4.ttf")
        GUI:Text_enableOutline(guaranteeLabel, "#000000", 2)

            
        GUI:setAnchorPoint(GUI:Image_Create(node, "wz", 520, 120.00, "res/custom/two_city/qyzb/wz.png")
        , 0.5, 0.5)
        if SL:GetMetaValue("TITLE_DATA_BY_ID", SL:GetMetaValue("ITEM_INDEX_BY_NAME",npc._config.details[5])) then
            GUI:setAnchorPoint(GUI:Image_Create(node, "Button", 520, 60.00, "res/wy/public/15.png"), 0.5, 0.5)
        else
            local Button= GUI:Button_Create(node, "Button", 520, 60.00, "res/custom/two_city/qyzb/btn.png")
            GUI:setAnchorPoint(Button, 0.5, 0.5)
            GUI:addOnClickEvent(Button, function()
                SL:SendLuaNetMsg(100, npcid, 1, 0, "")
            end)

            if isFirstFree or checkItemNum(npc._config.cost) then
                NPC_UI_HELPER.redpoint_create(Button,{x = 185,y = 47,autoScale = 1})
                NPC_UI_HELPER.tryStartXylGuide(npc, Button, node, "fortune_divination", {
                    taskName = "气运占卜",
                    dir = 5,
                    desc = "点击进行气运占卜",
                })
            end

            if isFirstFree then
                local freeLabel = GUI:Text_Create(node, "free_label", 250, 80, 25, "#FF0000", "第一次占卜是免费的哦！！！")
                GUI:setAnchorPoint(freeLabel, 0.5, 0.5)
                GUI:Text_setFontName(freeLabel, "fonts/font4.ttf")
                GUI:Text_enableOutline(freeLabel, "#000000", 2)
            end 
            
            
        end

        

    end

    local function playDivinationUnlockAnim(node, targetIndex)
        if not node then
            return
        end
        local slotCount = #(npc._config.details or {})
        if slotCount <= 0 then
            UI_updata(node)
            return
        end
        local previousIndex = tonumber(npc._lastTitleIndex or 1) or 1
        if previousIndex < 1 or previousIndex > slotCount then
            previousIndex = 1
        end
        targetIndex = tonumber(targetIndex or 0) or 0
        if targetIndex <= 0 then
            targetIndex = getCurrentTitleIndex()
        end
        if targetIndex <= 0 then
            targetIndex = previousIndex
        end
        targetIndex = math.max(1, math.min(targetIndex, slotCount))

        UI_updata(node, {hideActiveFrame = true})

        local selector = GUI:Image_Create(node, "anim_selector", 0, 0, "res/custom/two_city/qyzb/kuang.png")
        GUI:setAnchorPoint(selector, 0.5, 0.5)
        local startIndex = tonumber(npc._lastAnimIndex or previousIndex or 1) or 1
        if startIndex < 1 or startIndex > slotCount then
            startIndex = 1
        end

        local function moveSelectorTo(index)
            local slotNode = GUI:getChildByName(node, "kuang" .. tostring(index))
            local center = getSlotCenter(slotNode)
            if center then
                GUI:setPosition(selector, center.x, center.y)
            else
                local fallback = SLOT_POSITIONS[index]
                if fallback then
                    GUI:setPosition(selector, fallback.x + 82, fallback.y + 97)
                end
            end
        end

        moveSelectorTo(startIndex)

        local totalSteps = slotCount * 2 + targetIndex
        if totalSteps < 8 then
            totalSteps = 8 + targetIndex
        end

        local currentIndex = startIndex
        local currentStep = 0
        local function stepAnim()
            if not node then
                return
            end
            currentStep = currentStep + 1
            currentIndex = currentIndex + 1
            if currentIndex > slotCount then
                currentIndex = 1
            end
            moveSelectorTo(currentIndex)
            npc._lastAnimIndex = currentIndex

            if currentStep >= totalSteps and currentIndex == targetIndex then
                UI_updata(node)
                return
            end

            local delayIdx = math.min(currentStep + 1, #ANIM_DELAYS)
            SL:scheduleOnce(node, stepAnim, ANIM_DELAYS[delayIdx])
        end

        SL:scheduleOnce(node, stepAnim, ANIM_DELAYS[1])
    end


    if p2 == 0 then--界面
        npc.data = SL:JsonDecode(msgData,false)
        ensureWindow(npcid)
        UI_updata(npc.node)
    elseif p2 == 1 then
        npc.data.U_num = npc.data.U_num + 1
        playDivinationUnlockAnim(npc.node, getCurrentTitleIndex())
    end 
end

return npc
