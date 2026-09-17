local npc = {}
local TreeCfg = SL:Require("GUILayout/Data/talent_tree_data", true) or {}

local ROOT_NAME = "npc_22_talent_tree"
local GEM_WINDOW_NAME = "npc_22_gem_window"
local RES = "res/custom/tj/"
local FONT = "fonts/506.ttf"
local BUTTON_SKIN = RES .. "tj_21.png"
local NODE_FRAME = RES .. "tj_19.png"
local NODE_CORE_SKIN = RES .. "tj_22.png"
local PANEL_FRAME = RES .. "tj_17.png"
local NODE_ROOT_BACK = "res/custom/linggen/bufi/icon_11.png"
local NODE_ROOT_BACK_SIZE = 180
local NODE_ACTIVE_BACK = "res/wy/public/itembg.png"
local LINK_ACTIVE_OVERLAY = "res/wy/public/fz_kt_33.png"
local UPGRADE_RES = "res/custom/linggen/new/updata/"
local UPGRADE_BG = UPGRADE_RES .. "upgrade_bg.png"
local UPGRADE_BUTTON = UPGRADE_RES .. "btn_upgrade.png"
local UPGRADE_COST_SLOT = UPGRADE_RES .. "cost_slot.png"
local UPGRADE_BOX_W = 564
local UPGRADE_BOX_H = 412
local UPGRADE_LEFT_SCROLL_X = 0 + 38
local UPGRADE_LEFT_SCROLL_Y = 0 + 58 - 42
local UPGRADE_RIGHT_X = 170 + 287
local UPGRADE_PREVIEW_Y = 94
local UPGRADE_COST_Y = -78 + 190
local UPGRADE_BUTTON_Y = 40
-- local PANEL_FRAME = RES .. "tj_17.png"
local LINK_SKIN = "res/wy/public/jdt_1.png"
local LINK_TEXTURE_WIDTH = 376
local LINK_VISIBLE_START = 24
local LINK_VISIBLE_END = 351
local LINK_VISIBLE_RATIO = (LINK_VISIBLE_END - LINK_VISIBLE_START) / LINK_TEXTURE_WIDTH
local BUFI_RES = "res/custom/linggen/bufi/"
local BUFI_DECORATIONS = {
    metal = {icons = {5, 10, 18}, scale = {0.6,0.8,1.3}, opacity = {100, 100, 150}, anchors = {"M5", "M12", "ultimate"}, offsets = {{x = -70 + 69, y = -16}, {x = 70 - 67, y = 16 - 37}, {x = -86 + 85, y = 30 - 45}}},
    wood = {icons = {18, 15, 4}, scale = {0.6,0.8,1.3}, opacity = {100, 100, 150}, anchors = {"M5", "M12", "ultimate"}, offsets = {{x = -70 + 69, y = -16}, {x = 70 - 67, y = 16 - 37}, {x = -86 + 85, y = 30 - 45}}},
    water = {icons = {14, 22, 23}, scale = {0.6,0.6,1.3}, opacity = {100, 150, 150}, anchors = {"M5", "M12", "ultimate"}, offsets = {{x = -70 + 69, y = -16}, {x = 70 - 67, y = 16 - 37}, {x = -86 + 85, y = 30 - 45}}},
    fire = {icons = {1, 5, 7}, scale = {0.6,0.9,1.3}, opacity = {100, 100, 150}, anchors = {"M5", "M12", "ultimate"}, offsets = {{x = -70 + 69, y = -16}, {x = 70 - 67, y = 16 - 37}, {x = -86 + 85, y = 30 - 45}}},
    earth = {icons = {19, 24, 16}, scale = {0.6,0.8,1.3}, opacity = {100, 100, 150}, anchors = {"M5", "M12", "ultimate"}, offsets = {{x = -72 + 59 + 14, y = 14 - 88 + 36}, {x = 72 - 66, y = 66 - 88 + 36}, {x = -86 + 85, y = 30 - 45}}},
}
local BUFI_DECORATION_Z = -5
local CANVAS_W = 2300 + 1000
local CANVAS_H = 2100 + 1000
local MIN_ZOOM = 0.20
local MAX_ZOOM = 1.00
local DEFAULT_ZOOM = 1.00
local ELEMENT_ORDER = {"metal", "water", "wood", "fire", "earth"}
local NODE_SIZE = {small = 30, medium = 40, large = 52, skill = 50, socket = 44, bridge = 34, root = 72}
local ATTR_NODE_ORIGINAL_SIZE = 80
local SKILL_NODE_ORIGINAL_SIZE = 68
local SKILL_NODE_SKIN_BY_ELEMENT = {
    metal = RES .. "1.png",
    wood = RES .. "2.png",
    water = RES .. "3.png",
    fire = RES .. "4.png",
    earth = RES .. "5.png",
}
local ATTR_NODE_SKINS = {
    RES .. "state1.png",
    RES .. "state2.png",
    RES .. "state3.png",
    RES .. "state4.png",
    RES .. "state5.png",
    RES .. "state6.png",
    RES .. "state7.png",
    RES .. "state8.png",
    RES .. "state9.png",
    RES .. "state10.png",
}
local ATTR_NODE_SKINS_BY_ELEMENT = {
    metal = {
        RES .. "state1_metal.png", RES .. "state2_metal.png", RES .. "state3_metal.png", RES .. "state4_metal.png", RES .. "state5_metal.png",
        RES .. "state6_metal.png", RES .. "state7_metal.png", RES .. "state8_metal.png", RES .. "state9_metal.png", RES .. "state10_metal.png",
    },
    wood = {
        RES .. "state1_wood.png", RES .. "state2_wood.png", RES .. "state3_wood.png", RES .. "state4_wood.png", RES .. "state5_wood.png",
        RES .. "state6_wood.png", RES .. "state7_wood.png", RES .. "state8_wood.png", RES .. "state9_wood.png", RES .. "state10_wood.png",
    },
    water = {
        RES .. "state1_water.png", RES .. "state2_water.png", RES .. "state3_water.png", RES .. "state4_water.png", RES .. "state5_water.png",
        RES .. "state6_water.png", RES .. "state7_water.png", RES .. "state8_water.png", RES .. "state9_water.png", RES .. "state10_water.png",
    },
    fire = {
        RES .. "state1_fire.png", RES .. "state2_fire.png", RES .. "state3_fire.png", RES .. "state4_fire.png", RES .. "state5_fire.png",
        RES .. "state6_fire.png", RES .. "state7_fire.png", RES .. "state8_fire.png", RES .. "state9_fire.png", RES .. "state10_fire.png",
    },
    earth = {
        RES .. "state1_earth.png", RES .. "state2_earth.png", RES .. "state3_earth.png", RES .. "state4_earth.png", RES .. "state5_earth.png",
        RES .. "state6_earth.png", RES .. "state7_earth.png", RES .. "state8_earth.png", RES .. "state9_earth.png", RES .. "state10_earth.png",
    },
}
local SKILL_NODE_SKINS = {
    RES .. "1.png",
    RES .. "2.png",
    RES .. "3.png",
    RES .. "4.png",
    RES .. "5.png",
}
local TREE_DRAG_THRESHOLD = 8
local TREE_EDGE_PADDING = 72
local TREE_EXTRA_PADDING = 1000
local TREE_LABEL_PAD_X = 110
local TREE_LABEL_PAD_Y = 64
-- Keep the source layout untouched. The display layout folds the long outer
-- branches inward and gives the middle of each branch a stronger arc.
local TREE_LAYOUT_RADIAL_SCALE = 0.86
local TREE_LAYOUT_COMPRESSION_START = 260
local TREE_LAYOUT_MIDDLE_TWIST_DEG = 24
-- The first 18 nodes are the visible trunk of each element. Keep their
-- adjustment independent from the outer flow branches so the dense trunk
-- does not pull the rest of the tree out of position.
local TREE_TRUNK_MAX_INDEX = 18
local TREE_TRUNK_RADIAL_SCALE = 0.80
local TREE_TRUNK_COMPRESSION_START = 180
local TREE_TRUNK_TWIST_DEG = 38
local TREE_TRUNK_SNAKE_DEG = 14
local TREE_TRUNK_SNAKE_CYCLES = 2
local TREE_TRUNK_MIN_RADIAL_STEP = 125
local TREE_BRIDGE_MIN_STEP = 115
local TREE_BRIDGE_CURVE = 80
local COLORS = {
    panel = "#17100D",
    panel2 = "#2B1D15",
    text = "#F4E6C0",
    muted = "#9BA7BB",
    green = "#69E695",
    line = "#695143",
    active_line = "#E2C16A",
}

local function valid(node)
    if not node then
        return false
    end
    if tolua and tolua.isnull then
        local ok, isNull = pcall(tolua.isnull, node)
        return ok and not isNull
    end
    return true
end

local function n(value, fallback)
    return tonumber(value) or fallback or 0
end

local function decode(data)
    if type(data) == "table" then
        return data
    end
    if type(data) == "string" and data ~= "" then
        return SL:JsonDecode(data, false) or {}
    end
    return {}
end

local function text(parent, name, x, y, size, color, value, ax, ay)
    local node = GUI:Text_Create(parent, name, x, y, size or 18, color or COLORS.text, tostring(value or ""))
    GUI:setAnchorPoint(node, ax == nil and 0.5 or ax, ay == nil and 0.5 or ay)
    GUI:Text_setFontName(node, FONT)
    GUI:Text_enableOutline(node, "#000000", 1)
    return node
end

local function panel(parent, name, x, y, width, height, color)
    local node = GUI:Layout_Create(parent, name, x, y, width, height, false)
    GUI:setAnchorPoint(node, 0.5, 0.5)
    GUI:setPosition(node, x or 0, y or 0)
    -- GUI:Layout_setBackGroundColorType(node, 1)
    -- GUI:Layout_setBackGroundColor(node, color or COLORS.panel)
    -- GUI:Layout_setBackGroundColorOpacity(node, 242)
    return node
end

local function centerNode(node)
    if not valid(node) then
        return
    end
    GUI:setAnchorPoint(node, 0.5, 0.5)
    GUI:setPosition(node, 0, 0)
end

local function createModalWindow(name)
    local win = GUI:GetWindow(nil, name)
    if win then
        GUI:removeAllChildren(win)
        GUI:setPosition(win, n(cogin and cogin.w, 1280) / 2, n(cogin and cogin.h, 720) / 2)
        GUI:setVisible(win, true)
        return win
    end
    return GUI:Win_Create(name, n(cogin and cogin.w, 1280) / 2, n(cogin and cogin.h, 720) / 2,
        0, 0, false, false, true, true, true, 22, 1000)
end

local function closeModalWindow(name)
    local win = GUI:GetWindow(nil, name)
    if valid(win) then
        GUI:Win_Close(win)
    end
    if name == "npc_22_rules_window" then
        npc.rulesWindow = nil
        npc.rulesBox = nil
    elseif name == "npc_22_upgrade_window" then
        npc.upgradeWindow = nil
        npc.upgradeBox = nil
    elseif name == GEM_WINDOW_NAME then
        npc.gemWindow = nil
        npc.gemBox = nil
        npc.gemList = nil
    end
end

local function closeOverlappedBaseWindows()
    local function safeClose(closeFn)
        if type(closeFn) == "function" then
            pcall(closeFn, SL)
        end
    end
    safeClose(SL and SL.CloseMyPlayerUI)
    safeClose(SL and SL.CloseBagUI)
end

local function setMainTreeVisible(visible)
    if valid(npc.header) then
        GUI:setVisible(npc.header, visible)
    end
    if valid(npc.infoPanel) then
        GUI:setVisible(npc.infoPanel, visible)
    end
    if valid(npc.infoFrame) then
        GUI:setVisible(npc.infoFrame, visible)
    end
    if valid(npc.zoomControl) then
        GUI:setVisible(npc.zoomControl, visible)
    end
    if valid(npc.treeScroll) then
        GUI:setVisible(npc.treeScroll, visible)
    end
    if valid(npc.treeFrame) then
        GUI:setVisible(npc.treeFrame, visible)
    end
    if valid(npc.mask) then
        GUI:setVisible(npc.mask, visible)
    end
    if valid(npc.bg) then
        GUI:setVisible(npc.bg, visible)
    end
end

local setInfoDrawer

local function imageFrame(parent, name, x, y, width, height, path, zorder)
    local node = GUI:Image_Create(parent, name, x, y, path)
    if not valid(node) then
        return nil
    end
    GUI:setAnchorPoint(node, 0.5, 0.5)
    GUI:setContentSize(node, width, height)
    if zorder ~= nil then
        GUI:setLocalZOrder(node, zorder)
    end
    return node
end

local function nodeSkinIndex(node, count)
    local source = tostring((node and node.id) or (node and node.name) or "")
    local sum = 0
    for i = 1, string.len(source) do
        sum = sum + string.byte(source, i)
    end
    return sum % count + 1
end

local function isSocketNode(node)
    return node and (node.kind == "socket" or node.slot_type == "X" or node.slot_type == "socket")
end

local function isSkillNode(node)
    if not node then
        return false
    end
    local slotType = tostring(node.slot_type or "")
    if node.kind == "skill" or slotType == "skill" or string.sub(slotType, 1, 1) == "J" then
        return true
    end
    local content = tostring(node.name or "") .. tostring(node.effect or "") .. tostring(node.desc or "")
    return string.find(content, "技能", 1, true) ~= nil
        or string.find(content, "强化", 1, true) ~= nil
        or string.find(content, "本命", 1, true) ~= nil
        or string.find(content, "终式", 1, true) ~= nil
end

local function nodeButtonSkin(node)
    if not node then
        return NODE_CORE_SKIN
    end
    if node.kind == "root" or isSocketNode(node) then
        return NODE_CORE_SKIN
    end
    if isSkillNode(node) then
        return SKILL_NODE_SKIN_BY_ELEMENT[node.element]
            or SKILL_NODE_SKINS[nodeSkinIndex(node, #SKILL_NODE_SKINS)]
    end
    local skins = ATTR_NODE_SKINS_BY_ELEMENT[node.element] or ATTR_NODE_SKINS
    return skins[nodeSkinIndex(node, #skins)]
end

local function shouldShowNodeFrame(node)
    return node and (node.kind == "root" or isSocketNode(node))
end

local function copyTreeNode(node)
    local copy = {}
    for key, value in pairs(node or {}) do
        copy[key] = value
    end
    return copy
end

local function getMainTrunkIndex(id)
    local element, index = string.match(tostring(id or ""), "^([%a]+)_M(%d+)$")
    index = tonumber(index)
    if not element or not index or index < 1 or index > TREE_TRUNK_MAX_INDEX then
        return nil
    end
    return index
end

local function buildTreePositionOverrides(sourceNodes)
    local sourcePositions = {}
    for _, node in ipairs(sourceNodes or {}) do
        sourcePositions[node.id] = {
            x = n(node.x),
            y = n(node.y),
        }
    end

    local overrides = {}
    local function position(id)
        return sourcePositions[id]
    end
    local function setPosition(id, value)
        if value then
            overrides[id] = {
                x = value.x,
                y = value.y,
            }
        end
    end

    -- Swap the first three positions of each flow with its side branch.
    -- The fourth flow node continues from the side branch's last position,
    -- because a flow has four nodes while the side branch has three.
    for _, element in ipairs(TreeCfg.elements or {}) do
        for flow = 1, 2 do
            local mainIds = {}
            local sideIds = {}
            for index = 1, 4 do
                mainIds[index] = tostring(element.id) .. "_F" .. tostring(flow) .. "_" .. tostring(index + 5)
            end
            for index = 1, 3 do
                sideIds[index] = tostring(element.id) .. "_F" .. tostring(flow) .. "_5a" .. tostring(index)
            end

            local mainPositions = {}
            local sidePositions = {}
            for index = 1, 4 do
                mainPositions[index] = position(mainIds[index])
            end
            for index = 1, 3 do
                sidePositions[index] = position(sideIds[index])
            end

            if mainPositions[1] and mainPositions[2] and mainPositions[3] and mainPositions[4]
                and sidePositions[1] and sidePositions[2] and sidePositions[3]
            then
                for index = 1, 3 do
                    setPosition(mainIds[index], sidePositions[index])
                    setPosition(sideIds[index], mainPositions[index])
                end

                local tailX = sidePositions[3].x + (sidePositions[3].x - sidePositions[2].x)
                local tailY = sidePositions[3].y + (sidePositions[3].y - sidePositions[2].y)
                setPosition(mainIds[4], {x = tailX, y = tailY})
            end
        end
    end

    return overrides
end

local function applyOuterFlowerLayout(resultMap)
    local root = resultMap and resultMap.root
    if not root then
        return
    end

    local elements = ELEMENT_ORDER
    local centers = {}
    for _, element in ipairs(elements) do
        local center = resultMap[element .. "_M18"]
        if center then
            centers[element] = {
                x = n(center.x),
                y = n(center.y),
            }
        end
    end

    local function setPoint(element, id, outward, tangent, x, y)
        local node = resultMap[element .. "_" .. id]
        local center = centers[element]
        if not node or not center then
            return
        end
        node.x = center.x + outward.x * x + tangent.x * y
        node.y = center.y + outward.y * x + tangent.y * y
    end

    local function direction(fromPoint, toPoint)
        local dx = n(toPoint and toPoint.x) - n(fromPoint and fromPoint.x)
        local dy = n(toPoint and toPoint.y) - n(fromPoint and fromPoint.y)
        local length = math.sqrt(dx * dx + dy * dy)
        if length <= 0 then
            return 1, 0, 0
        end
        return dx / length, dy / length, length
    end

    local function setFromAnchor(element, anchorId, id, radial, tangentOffset)
        local anchor = resultMap[element .. "_" .. anchorId]
        local node = resultMap[element .. "_" .. id]
        if not anchor or not node then
            return
        end
        local dx = n(anchor.x) - n(root.x)
        local dy = n(anchor.y) - n(root.y)
        local length = math.sqrt(dx * dx + dy * dy)
        if length <= 0 then
            return
        end
        local outward = {
            x = dx / length,
            y = dy / length,
        }
        local tangent = {
            x = -outward.y,
            y = outward.x,
        }
        node.x = n(anchor.x) + outward.x * radial + tangent.x * tangentOffset
        node.y = n(anchor.y) + outward.y * radial + tangent.y * tangentOffset
    end

    -- Rebuild the short branches around their real M5/M10/M15 parent instead
    -- of letting the source coordinates cut diagonally across the tree. M5a
    -- is intentionally opened toward the outer arc to match the main trunk.
    local sideBranches = {
        {anchor = "M5", prefix = "M5"},
        {anchor = "M10", prefix = "M10"},
        {anchor = "M15", prefix = "M15"},
    }
    for _, element in ipairs(elements) do
        for _, branch in ipairs(sideBranches) do
            if branch.prefix == "M5" then
                setFromAnchor(element, branch.anchor, branch.prefix .. "a1", 55, -145)
                setFromAnchor(element, branch.anchor, branch.prefix .. "a2", 125, -260)
            else
                setFromAnchor(element, branch.anchor, branch.prefix .. "a1", -70, -150)
                setFromAnchor(element, branch.anchor, branch.prefix .. "a2", -145, -220)
            end
            setFromAnchor(element, branch.anchor, branch.prefix .. "b1", -45, 112)
            setFromAnchor(element, branch.anchor, branch.prefix .. "b2", -90, 224)
        end
    end

    -- Keep the two flow lanes compact around M18. Each lane first grows
    -- outward, then bends back inward; the two mirrored paths never need to
    -- cross and their shared terminal stays inside the flower.
    local flowerUpper = {
        {140, 105},
        {265, 170},
        {390, 210},
        {510, 195},
        {625, 140},
        {575, 285},
        {500, 395},
        {400, 455},
        {290, 400},
    }
    local inwardSide = {
        {510, 75},
        {400, 55},
        {305, 95},
    }

    for index, element in ipairs(elements) do
        local center = centers[element]
        if center then
            local rootDx = center.x - n(root.x)
            local rootDy = center.y - n(root.y)
            local radius = math.sqrt(rootDx * rootDx + rootDy * rootDy)
            if radius <= 0 then
                radius = 1
            end
            local outward = {
                x = rootDx / radius,
                y = rootDy / radius,
            }
            local tangent = {
                x = -outward.y,
                y = outward.x,
            }

            -- Keep the socket off the two flow starts so it does not sit on
            -- top of the first pair of nodes.
            setPoint(element, "M18_X", outward, tangent, 0, -175)
            for flowIndex, offset in ipairs(flowerUpper) do
                setPoint(element, "F1_" .. tostring(flowIndex), outward, tangent, offset[1], offset[2])
                setPoint(element, "F2_" .. tostring(flowIndex), outward, tangent, offset[1], -offset[2])
            end

            -- Both side chains fold inward from F1/F2-5. Their last nodes
            -- meet the shared terminal from opposite sides without crossing.
            for sideIndex, offset in ipairs(inwardSide) do
                setPoint(element, "F1_5a" .. tostring(sideIndex), outward, tangent, offset[1], offset[2])
                setPoint(element, "F2_5a" .. tostring(sideIndex), outward, tangent, offset[1], -offset[2])
            end
            setPoint(element, "shared_F5a4", outward, tangent, 255, 0)

            local nextElement = elements[index % #elements + 1]
            local previousElement = elements[(index - 2) % #elements + 1]
            local nextCenter = centers[nextElement]
            local previousCenter = centers[previousElement]

            -- Draw the two bridge routes on opposite sides of the same
            -- boundary chord. This keeps the bridge nodes out of the flower
            -- and prevents the paired routes from crossing each other.
            if nextCenter then
                local dx, dy, coreDistance = direction(center, nextCenter)
                local step = math.min(150, math.max(TREE_BRIDGE_MIN_STEP, (coreDistance - 150) / 10))
                for bridgeIndex = 1, 5 do
                    local progress = step * bridgeIndex
                    local curve = math.sin((bridgeIndex / 6) * math.pi) * TREE_BRIDGE_CURVE
                    setPoint(element, "K2_" .. tostring(bridgeIndex),
                        {x = dx, y = dy},
                        {x = -dy, y = dx},
                        progress,
                        curve)
                end
            end
            if previousCenter then
                local dx, dy, coreDistance = direction(center, previousCenter)
                local step = math.min(150, math.max(TREE_BRIDGE_MIN_STEP, (coreDistance - 150) / 10))
                for bridgeIndex = 1, 5 do
                    local curve = -math.sin((bridgeIndex / 6) * math.pi) * TREE_BRIDGE_CURVE
                    setPoint(element, "K1_" .. tostring(bridgeIndex),
                        {x = dx, y = dy},
                        {x = -dy, y = dx},
                        step * bridgeIndex,
                        curve)
                end
            end
        end
    end

    -- Put each K2-6 exactly between the two terminal nodes it joins.
    for index, element in ipairs(elements) do
        local nextElement = elements[index % #elements + 1]
        local currentTerminal = resultMap[element .. "_K2_5"]
        local nextTerminal = resultMap[nextElement .. "_K1_5"]
        local shared = resultMap[element .. "_K2_6"]
        if currentTerminal and nextTerminal and shared then
            shared.x = (n(currentTerminal.x) + n(nextTerminal.x)) / 2
            shared.y = (n(currentTerminal.y) + n(nextTerminal.y)) / 2
        end
    end
end

local function enforceTrunkRadialSpacing(resultMap)
    local elements = ELEMENT_ORDER

    for _, element in ipairs(elements) do
        local previousRadius
        for index = 1, TREE_TRUNK_MAX_INDEX do
            local node = resultMap[element .. "_M" .. tostring(index)]
            if node then
                local dx = n(node.x) - n(resultMap.root and resultMap.root.x)
                local dy = n(node.y) - n(resultMap.root and resultMap.root.y)
                local radius = math.sqrt(dx * dx + dy * dy)
                local angle = math.atan2(dy, dx)

                -- Keep the trunk growing outward. Euclidean nudging can
                -- reverse a tight turn (especially around M6-M8), putting
                -- a later node back on top of an earlier one.
                if previousRadius and radius < previousRadius + TREE_TRUNK_MIN_RADIAL_STEP then
                    radius = previousRadius + TREE_TRUNK_MIN_RADIAL_STEP
                    node.x = n(resultMap.root.x) + math.cos(angle) * radius
                    node.y = n(resultMap.root.y) + math.sin(angle) * radius
                end
                previousRadius = radius
            end
        end
    end
end

local function swapElementTreePositions(resultMap, firstElement, secondElement)
    if not resultMap then
        return
    end

    local firstPrefix = tostring(firstElement or "") .. "_"
    local secondPrefix = tostring(secondElement or "") .. "_"
    local firstBySuffix = {}
    local secondBySuffix = {}

    for id, node in pairs(resultMap) do
        id = tostring(id)
        if string.sub(id, 1, #firstPrefix) == firstPrefix then
            firstBySuffix[string.sub(id, #firstPrefix + 1)] = node
        elseif string.sub(id, 1, #secondPrefix) == secondPrefix then
            secondBySuffix[string.sub(id, #secondPrefix + 1)] = node
        end
    end

    for suffix, firstNode in pairs(firstBySuffix) do
        local secondNode = secondBySuffix[suffix]
        if firstNode and secondNode then
            firstNode.x, secondNode.x = secondNode.x, firstNode.x
            firstNode.y, secondNode.y = secondNode.y, firstNode.y
        end
    end
end

local function buildTreeLayout()
    local sourceNodes = TreeCfg.nodes or {}
    local sourceRoot = TreeCfg.node_map and TreeCfg.node_map.root
    local rootX = n(sourceRoot and sourceRoot.x, CANVAS_W / 2)
    local rootY = n(sourceRoot and sourceRoot.y, CANVAS_H / 2)
    local positionOverrides = buildTreePositionOverrides(sourceNodes)
    local maxRadius = 1

    for _, node in ipairs(sourceNodes) do
        local position = positionOverrides[node.id] or node
        local dx = n(position.x) - rootX
        local dy = n(position.y) - rootY
        maxRadius = math.max(maxRadius, math.sqrt(dx * dx + dy * dy))
    end

    local result = {}
    local resultMap = {}
    for _, sourceNode in ipairs(sourceNodes) do
        local node = copyTreeNode(sourceNode)
        local position = positionOverrides[sourceNode.id] or sourceNode
        local dx = n(position.x) - rootX
        local dy = n(position.y) - rootY
        local radius = math.sqrt(dx * dx + dy * dy)
        local trunkIndex = getMainTrunkIndex(sourceNode.id)

        if sourceNode.kind == "root" then
            node.x = rootX
            node.y = rootY
        elseif radius > 0 then
            local compressedRadius
            local angle = math.atan2(dy, dx)
            if trunkIndex then
                -- Normalize by trunk depth instead of the whole tree. The
                -- outer branches are much longer, so using maxRadius here
                -- made the M1-M18 curve barely visible.
                local trunkRatio = (trunkIndex - 1) / (TREE_TRUNK_MAX_INDEX - 1)
                compressedRadius = radius
                if radius > TREE_TRUNK_COMPRESSION_START then
                    compressedRadius = TREE_TRUNK_COMPRESSION_START
                        + (radius - TREE_TRUNK_COMPRESSION_START) * TREE_TRUNK_RADIAL_SCALE
                end

                local arcWeight = math.sin(trunkRatio * math.pi)
                local arcTwist = math.rad(TREE_TRUNK_TWIST_DEG) * arcWeight
                local snake = math.rad(TREE_TRUNK_SNAKE_DEG)
                    * math.sin(trunkRatio * math.pi * TREE_TRUNK_SNAKE_CYCLES)
                angle = angle + arcTwist + snake
            else
                compressedRadius = radius
                if radius > TREE_LAYOUT_COMPRESSION_START then
                    compressedRadius = TREE_LAYOUT_COMPRESSION_START
                        + (radius - TREE_LAYOUT_COMPRESSION_START) * TREE_LAYOUT_RADIAL_SCALE
                end

                local radiusRatio = math.min(1, radius / maxRadius)
                local middleWeight = math.sin(radiusRatio * math.pi)
                local twist = math.rad(TREE_LAYOUT_MIDDLE_TWIST_DEG) * middleWeight
                angle = angle + twist
            end

            node.x = rootX + math.cos(angle) * compressedRadius
            node.y = rootY + math.sin(angle) * compressedRadius
        else
            node.x = rootX
            node.y = rootY
        end

        result[#result + 1] = node
        resultMap[node.id] = node
    end

    enforceTrunkRadialSpacing(resultMap)
    swapElementTreePositions(resultMap, "wood", "water")
    applyOuterFlowerLayout(resultMap)
    npc.layoutNodes = result
    npc.layoutNodeMap = resultMap
    return result, resultMap
end

local function getLayoutNode(id)
    return npc.layoutNodeMap and npc.layoutNodeMap[id]
        or (TreeCfg.node_map and TreeCfg.node_map[id])
end

local function createTreeDecorations(parent)
    for element, decoration in pairs(BUFI_DECORATIONS) do
        for index, icon in ipairs(decoration.icons or {}) do
            local anchorKey = decoration.anchors and decoration.anchors[index]
            local anchorId
            if anchorKey == "M5" or anchorKey == "M12" then
                anchorId = tostring(element) .. "_" .. anchorKey
            elseif anchorKey == "ultimate" then
                anchorId = tostring(element) .. "_shared_F5a4"
            else
                anchorId = tostring(anchorKey or "")
            end

            local anchor = getLayoutNode(anchorId)
            if anchor then
                local offset = decoration.offsets and decoration.offsets[index] or {}
                local image = GUI:Image_Create(parent, "bufi_" .. element .. "_" .. tostring(index),
                    n(anchor.x) + n(offset.x),
                    n(anchor.y) + n(offset.y),
                    BUFI_RES .. "icon_" .. tostring(icon) .. ".png")
                if valid(image) then
                    GUI:setAnchorPoint(image, 0.5, 0.5)
                    GUI:setScale(image, n(decoration.scale[index], 1))
                    GUI:setOpacity(image, n(decoration.opacity[index], 100))
                    GUI:setLocalZOrder(image, BUFI_DECORATION_Z)
                end
            end
        end
    end
end

local function nodeDisplaySize(node)
    if not node then
        return NODE_SIZE.small
    end
    if node.kind == "root" or isSocketNode(node) then
        return NODE_SIZE[node.kind] or NODE_SIZE.socket
    end
    if isSkillNode(node) then
        local skin = nodeButtonSkin(node)
        if skin == SKILL_NODE_SKIN_BY_ELEMENT.water then
            return 66
        end
        return SKILL_NODE_ORIGINAL_SIZE
    end
    return ATTR_NODE_ORIGINAL_SIZE
end

local function setNodeLinkState(link, active)
    if not valid(link) then
        return
    end
    GUI:setOpacity(link, 205)
    if GUI.Image_setGrey then
        GUI:Image_setGrey(link, false)
    else
        GUI:setGrey(link, false)
    end
    local activeOverlay = GUI:getChildByName(link, "active_overlay")
    if activeOverlay then
        GUI:setContentSize(link, GUI:getContentSize(activeOverlay).width, active and 16 or 8)
        GUI:setPosition(activeOverlay, 0, (active and 16 or 8)/2)
    end
end

local function createNodeLinkImage(parent, name, fromPoint, toPoint, opts)
    opts = opts or {}
    local fromX = n(fromPoint and fromPoint.x)
    local fromY = n(fromPoint and fromPoint.y)
    local toX = n(toPoint and toPoint.x)
    local toY = n(toPoint and toPoint.y)
    local dx = toX - fromX
    local dy = toY - fromY
    local length = math.sqrt(dx * dx + dy * dy)
    if length <= 1 then
        return nil
    end
    local angle = math.atan2(dy, dx)
    local link = GUI:Image_Create(parent, name, fromX, fromY, opts.skin or LINK_SKIN)
    GUI:setAnchorPoint(link, 0, 0.5)
    GUI:setLocalZOrder(link, opts.zorder or 0)
    GUI:setContentSize(link, length, opts.width or 4)
    -- GUI coordinates use the inverse mathematical Y direction for rotation.
    GUI:setRotation(link, -math.deg(angle))
    local activeOverlay = GUI:Image_Create(link, "active_overlay", 0, (opts.width or 4)/2, LINK_ACTIVE_OVERLAY)
    GUI:setAnchorPoint(activeOverlay, 0, 0.5)
    GUI:setContentSize(activeOverlay, length, math.max(opts.width or 4, 8))
    GUI:setOpacity(activeOverlay, 230)
    GUI:setLocalZOrder(activeOverlay, 1)
    setNodeLinkState(link, opts.active == true)
    return link
end

local function button(parent, name, x, y, title, callback, width, height, skin)
    local node = GUI:Button_Create(parent, name, x, y, skin or BUTTON_SKIN)
    GUI:Button_loadTexturePressed(node, skin or BUTTON_SKIN)
    GUI:setAnchorPoint(node, 0.5, 0.5)
    GUI:setContentSize(node, width or 132, height or 42)
    GUI:Button_setTitleText(node, title or "")
    GUI:Button_setTitleFontName(node, FONT)
    GUI:Button_setTitleFontSize(node, 18)
    GUI:Button_setTitleColor(node, "#F7E7B0")
    GUI:Button_titleEnableOutline(node, "#3B1708", 2)
    if tostring(title or "") ~= "" then
        local bw = width or 132
        local bh = height or 42
        local glow = GUI:Image_Create(node, "button_glow", bw / 2, math.max(7, bh * 0.23), RES .. "tj_12.png")
        if valid(glow) then
            GUI:setAnchorPoint(glow, 0.5, 0.5)
            GUI:setContentSize(glow, math.max(48, bw * 0.68), 3)
            GUI:setOpacity(glow, 130)
            GUI:setLocalZOrder(glow, 1)
        end
    end
    GUI:addOnClickEvent(node, callback)
    return node
end

local function costText(costs)
    local parts = {}
    for _, cost in ipairs(costs or {}) do
        parts[#parts + 1] = tostring(cost[1] or "") .. " × " .. tostring(cost[2] or 0)
    end
    return #parts > 0 and table.concat(parts, "、") or "无"
end

local function parseUpgradeAttr(attr)
    local rawText = tostring(attr and attr.text or "")
    local label, displayValue = rawText:match("^%s*(.-)%s*[+＋]%s*([%-%d%.]+)")
    label = label and label ~= "" and label or ("属性 " .. tostring(attr and attr.id or ""))
    displayValue = tonumber(displayValue)
    local unit = rawText:find("%", 1, true) and "%" or ""
    local rawValue = n(attr and attr.value)
    local scale = 1
    if displayValue and displayValue ~= 0 and rawValue ~= 0 then
        scale = math.abs(rawValue / displayValue)
    elseif unit == "%" and rawValue ~= 0 then
        scale = 100
    end
    return label, unit, scale
end

local function formatUpgradeAttrValue(value, unit, scale)
    local display = n(value) / math.max(1, n(scale, 1))
    if math.abs(display - math.floor(display)) < 0.001 then
        display = math.floor(display)
    end
    local prefix = display >= 0 and "+" or ""
    return prefix .. tostring(display) .. tostring(unit or "")
end

local function buildUpgradeAttrRows(currentLevel, nextLevel)
    local rows = {}
    local rowMap = {}
    local groups = {"hp", "attack", "defense", "cut", "recovery", "percent"}

    local function ensureRow(attr, group)
        local label, unit, scale = parseUpgradeAttr(attr)
        local key = tostring(group or "") .. "|" .. tostring(label) .. "|" .. tostring(unit)
        local row = rowMap[key]
        if not row then
            row = {
                label = label,
                unit = unit,
                scale = scale,
                current = 0,
                next = 0,
            }
            rowMap[key] = row
            rows[#rows + 1] = row
        elseif n(row.scale) == 1 and n(scale) ~= 1 then
            row.scale = scale
        end
        return row
    end

    for _, levelCfg in ipairs(TreeCfg.core_levels or {}) do
        local level = n(levelCfg.level)
        if level > nextLevel then
            break
        end
        for _, group in ipairs(groups) do
            for _, attr in ipairs(((levelCfg or {}).attrs or {})[group] or {}) do
                local row = ensureRow(attr, group)
                local value = n(attr.value)
                if level <= currentLevel then
                    row.current = row.current + value
                end
                row.next = row.next + value
            end
        end
    end

    local result = {}
    for _, row in ipairs(rows) do
        local delta = n(row.next) - n(row.current)
        if row.next ~= 0 or row.current ~= 0 or delta ~= 0 then
            result[#result + 1] = string.format("%s %s -> %s",
                row.label,
                formatUpgradeAttrValue(row.current, row.unit, row.scale),
                formatUpgradeAttrValue(row.next, row.unit, row.scale),
                formatUpgradeAttrValue(delta, row.unit, row.scale)
            )
        end
    end
    return result
end

local function cumulativeCorePointGain(level)
    local total = 0
    for _, levelCfg in ipairs(TreeCfg.core_levels or {}) do
        if n(levelCfg.level) <= n(level) then
            total = total + n(levelCfg.point_gain)
        end
    end
    return total
end

local function buildUpgradeTopRows(currentLevel, nextCfg)
    local rows = {}
    local nextLevel = nextCfg and n(nextCfg.level, currentLevel + 1) or currentLevel
    rows[#rows + 1] = string.format("天赋点 %s -> %s",
        formatUpgradeAttrValue(cumulativeCorePointGain(currentLevel), "", 1),
        formatUpgradeAttrValue(cumulativeCorePointGain(nextLevel), "", 1),
        formatUpgradeAttrValue(n(nextCfg and nextCfg.point_gain), "", 1)
    )

    local unlock = tostring(nextCfg and nextCfg.unlock or "")
    unlock = unlock:gsub("^%s*天赋点%s*[+＋]%s*%d+%s*", "")
    if unlock ~= "" then
        rows[#rows + 1] = "特殊效果：" .. unlock
    end
    return rows
end

local function renderUpgradeAttrScroll(box, state, nextCfg)
    local oldScroll = GUI:getChildByName(box, "upgrade_attr_scroll")
    if oldScroll then
        GUI:removeFromParent(oldScroll)
    end

    local scrollW = 312
    local scrollH = 258 + 42
    -- upgrade_box is centered. Keep the scroll view centered in the left
    -- panel instead of relying on the engine's default anchor.
    local scroll = GUI:ScrollView_Create(box, "upgrade_attr_scroll",
        UPGRADE_LEFT_SCROLL_X, UPGRADE_LEFT_SCROLL_Y, scrollW, scrollH, 1)
    GUI:ScrollView_setClippingEnabled(scroll, true)
    GUI:ScrollView_setBounceEnabled(scroll, true)

    local currentLevel = n(state.core_level)
    local nextLevel = nextCfg and n(nextCfg.level, currentLevel + 1) or currentLevel
    local topRows = nextCfg and buildUpgradeTopRows(currentLevel, nextCfg) or {}
    local attrs = nextCfg and buildUpgradeAttrRows(currentLevel, nextLevel) or {}
    local rowH = 35
    local totalRows = #topRows + #attrs
    local innerH = math.max(scrollH, 46 + math.max(1, totalRows) * rowH + 10 + 42)
    GUI:ScrollView_setInnerContainerSize(scroll, scrollW, innerH)
    local root = GUI:Layout_Create(scroll, "upgrade_attr_root", 0, 0, scrollW, innerH, false)
    GUI:setAnchorPoint(root, 0, 0)

    local levelTitle = GUI:RichText_Create(root, "upgrade_level_title", 8, innerH - 8,
        string.format("<font color='#6A8792'>当前核心</font> <font color='#344A58'>Lv.%d</font>"
            .. "  <font color='#B48A42'>→</font>  <font color='#2E8B57'>升级后 Lv.%d</font>",
            currentLevel, nextLevel),
        scrollW - 16, 17, "#344A58", 0, nil, nil,
        {outlineSize = 1, outlineColor = "#FFFFFF"})
    GUI:setAnchorPoint(levelTitle, 0, 1)

    if not nextCfg then
        local maxText = GUI:Text_Create(root, "upgrade_max_text", scrollW / 2, innerH / 2,
            18, "#2E8B57", "灵根核心已达到最高等级")
        GUI:setAnchorPoint(maxText, 0.5, 0.5)
        GUI:Text_setFontName(maxText, FONT)
        return
    end

    local renderRows = {}
    for _, line in ipairs(topRows) do
        renderRows[#renderRows + 1] = {text = line, top = true}
    end
    for _, line in ipairs(attrs) do
        renderRows[#renderRows + 1] = {text = line, top = false}
    end
    for index, item in ipairs(renderRows) do
        local row = GUI:Layout_Create(root, "upgrade_attr_row_" .. tostring(index), 6,
            innerH - 48 - index * rowH, scrollW - 12, rowH - 2, false)
        GUI:setAnchorPoint(row, 0, 0)
        GUI:setTouchEnabled(row, false)
        local dot = GUI:Text_Create(row, "dot", 8, (rowH - 2) / 2, 22, item.top and "#10FF00" or "#3C9A70", "◆")
        GUI:setAnchorPoint(dot, 0.5, 0.5)
        GUI:Text_setFontName(dot, "fonts/502.ttf")
        local value = GUI:Text_Create(row, "value", 24, (rowH - 2) / 2, item.top and 22 or 20,
            item.top and "#B48A42" or "#00FFFF", item.text)
        GUI:setAnchorPoint(value, 0, 0.5)
        GUI:Text_setFontName(value, "fonts/506.ttf")
    end
end

local function renderUpgradeCosts(box, nextCfg)
    local oldRoot = GUI:getChildByName(box, "upgrade_cost_root")
    if oldRoot then
        GUI:removeFromParent(oldRoot)
    end

    local costRoot = GUI:Node_Create(box, "upgrade_cost_root", UPGRADE_RIGHT_X, UPGRADE_COST_Y)
    GUI:setLocalZOrder(costRoot, 6)
    local costs = (nextCfg and nextCfg.cost) or {}
    local slotGap = 68 - 4
    local slotStartX = -((#costs - 1) * slotGap) / 2 - 4 
    for index, cost in ipairs(costs) do
        local slotX = slotStartX + (index - 1) * slotGap
        local slot = GUI:Image_Create(costRoot, "cost_slot_" .. tostring(index), slotX, 0, UPGRADE_COST_SLOT)
        GUI:setAnchorPoint(slot, 0.5, 0.5)
        local itemIndex = SL:GetMetaValue("ITEM_INDEX_BY_NAME", cost[1])
        if itemIndex then
            local item = GUI:ItemShow_Create(slot, "item", 25, 25, {
                index = itemIndex,
                count = cost[2],
                look = true,
                movable = false,
                bgVisible = false,
            })
            GUI:setAnchorPoint(item, 0.5, 0.5)
        end
        -- local name = GUI:Text_Create(slot, "cost_name", 0, -31, 13, "#344A58", cost[1] or "")
        -- GUI:setAnchorPoint(name, 0.5, 0.5)
        -- GUI:Text_setFontName(name, FONT)
        -- local count = GUI:Text_Create(slot, "cost_count", 0, -47, 14, "#B48A42",
        --     "×" .. tostring(cost[2] or 0))
        -- GUI:setAnchorPoint(count, 0.5, 0.5)
        -- GUI:Text_setFontName(count, FONT)
    end
end

local function closeResetConfirm()
    if valid(npc.resetConfirm) then
        GUI:removeFromParent(npc.resetConfirm)
    end
    if valid(npc.resetConfirmMask) then
        GUI:removeFromParent(npc.resetConfirmMask)
    end
    npc.resetConfirm = nil
    npc.resetConfirmMask = nil
end

local function stateActive(id)
    return n((npc.state.nodes or {})[tostring(id)] or 0) == 1
end

local function isM1Node(node)
    return node and (
        node.exclusive_group == "core_m1"
        or tostring(node.id or ""):match("^[^_]+_M1$")
    )
end

local function activeM1Node(excludeId)
    for _, node in ipairs(TreeCfg.nodes or {}) do
        if isM1Node(node)
            and tostring(node.id) ~= tostring(excludeId or "")
            and stateActive(node.id)
        then
            return node
        end
    end
end

local function activeTalentPointCount()
    local count = 0
    for id, value in pairs((npc.state and npc.state.nodes) or {}) do
        if tostring(id) ~= "root" and n(value) == 1 then
            local node = TreeCfg.node_map and TreeCfg.node_map[tostring(id)]
            count = count + math.max(0, n(node and node.point_cost, 1))
        end
    end
    return count
end

local function resetCostFor(resetType, selectedId)
    if resetType == "switch_m1" then
        return TreeCfg.m1_reset_cost or {{"灵石", 100}}
    end
    if resetType == "single" then
        local node = TreeCfg.node_map and TreeCfg.node_map[tostring(selectedId or "")]
        if isM1Node(node) then
            return TreeCfg.m1_reset_cost or {{"灵石", 100}}
        end
        return TreeCfg.single_reset_cost or {{"灵石", 20}}
    end
    local amount = activeTalentPointCount() * math.max(0, n(TreeCfg.talent_reset_point_cost, 20))
    return amount > 0 and {{"灵石", amount}} or {}
end

local function openResetConfirm(resetType)
    closeResetConfirm()
    local selectedId = npc.selectedId
    local costs = resetCostFor(resetType, selectedId)
    local title = resetType == "switch_m1" and "确认切换本命灵根"
        or (resetType == "single" and "确认退点" or "确认重置灵根")
    local action = resetType == "switch_m1" and "切换"
        or (resetType == "single" and "退点" or "重置")

    local mask = GUI:Layout_Create(npc.window, "reset_confirm_mask", 0, 0, 1, 1, false)
    GUI:setAnchorPoint(mask, 0.5, 0.5)
    GUI:setPosition(mask, 0, 0)
    GUI:setContentSize(mask, n(cogin and cogin.w, 1280), n(cogin and cogin.h, 720))
    GUI:Layout_setBackGroundColorType(mask, 1)
    GUI:Layout_setBackGroundColor(mask, "#000000")
    GUI:Layout_setBackGroundColorOpacity(mask, 90)
    GUI:setLocalZOrder(mask, 100)
    GUI:setTouchEnabled(mask, true)
    GUI:setSwallowTouches(mask, true)
    npc.resetConfirmMask = mask

    local confirm = GUI:Layout_Create(npc.window, "reset_confirm", 0, 0, 420, 220, false)
    GUI:setAnchorPoint(confirm, 0.5, 0.5)
    GUI:setPosition(confirm, 0, 0)
    GUI:Layout_setBackGroundColorType(confirm, 1)
    GUI:Layout_setBackGroundColor(confirm, "#18242D")
    GUI:Layout_setBackGroundColorOpacity(confirm, 248)
    GUI:setLocalZOrder(confirm, 101)
    GUI:setTouchEnabled(confirm, true)
    GUI:setSwallowTouches(confirm, true)
    npc.resetConfirm = confirm

    local bigkuang = GUI:Image_Create(confirm, "bigkuang", 420/2, 220/2, "res/wy/public/box.png")
    GUI:setAnchorPoint(bigkuang, 0.5, 0.5)
    GUI:setContentSize(bigkuang, 420 + 4, 220 + 4)
    GUI:setLocalZOrder(bigkuang, 99)

    text(confirm, "title", 0 + 210, 82 + 115, 22, "#F4D179", title, 0.5, 0.5)
    local desc = GUI:RichText_Create(confirm, "desc", -180 + 210, 52 + 115,
        "<font color='#E9F2F6'>本次操作需要消耗：</font><br/>"
            .. "<font color='#FFD66B'>" .. costText(costs) .. "</font><br/>"
            .. "<font color='#AAB5C8'>确认后才会提交操作。</font>",
        360, 16, "#E9F2F6", 0, nil, nil, {outlineSize = 1, outlineColor = "#000000"})
    GUI:setAnchorPoint(desc, 0, 1)

    local cancel = button(confirm, "cancel", -86 + 210, -78 + 115, "取消", closeResetConfirm, 112, 38)
    GUI:setLocalZOrder(cancel, 2)
    local confirmButton = button(confirm, "confirm", 86 + 210, -78 + 115, action, function()
        closeResetConfirm()
        if resetType == "single" then
            SL:SendLuaNetMsg(100, 22, 2, 0, SL:JsonEncode({id = selectedId}, false))
        elseif resetType == "switch_m1" then
            SL:SendLuaNetMsg(100, 22, 1, 0,
                SL:JsonEncode({id = selectedId, switch = true}, false))
        else
            SL:SendLuaNetMsg(100, 22, 3, 0, "")
        end
    end, 112, 38)
    GUI:setLocalZOrder(confirmButton, 2)
end

local function conflictingM1(node)
    if not node or node.exclusive_group ~= "core_m1" then
        return nil
    end
    for _, candidate in ipairs(TreeCfg.nodes or {}) do
        if candidate.exclusive_group == "core_m1" and candidate.id ~= node.id
            and stateActive(candidate.id) then
            return candidate
        end
    end
end

local function getMainlineRwid()
    local rwid = tonumber(cogin and cogin.sjtb and cogin.sjtb.rwid) or 0
    local zxrwid = tonumber(cogin and cogin.sjtb and cogin.sjtb.zxrwid) or 0
    rwid = math.max(rwid, zxrwid)
    if Player and type(Player.getServerVar) == "function" then
        rwid = math.max(rwid, tonumber(Player:getServerVar("U11") or 0) or 0)
        rwid = math.max(rwid, tonumber(Player:getServerVar("U_zxrw") or 0) or 0)
    end
    return rwid
end

local function isNodeLinkedToActive(node)
    if not node or node.kind == "root" then
        return false
    end
    for _, id in ipairs(node.requires or {}) do
        if stateActive(id) then
            return true
        end
    end
    for _, id in ipairs(node.requires_any or {}) do
        if stateActive(id) then
            return true
        end
    end
    for _, candidate in ipairs(TreeCfg.nodes or {}) do
        if tostring(candidate.id) ~= tostring(node.id) and stateActive(candidate.id) then
            for _, id in ipairs(candidate.requires or {}) do
                if tostring(id) == tostring(node.id) then
                    return true
                end
            end
            for _, id in ipairs(candidate.requires_any or {}) do
                if tostring(id) == tostring(node.id) then
                    return true
                end
            end
        end
    end
    return false
end

local MAINLINE_TALENT_CHOICE_IDS = {
    "metal_M1",
    "water_M1",
    "wood_M1",
    "fire_M1",
    "earth_M1",
}
local updateNodeVisual
local updateTalentChoiceGuidePosition

local function isMainlineTalentChoiceNode(nodeId)
    nodeId = tostring(nodeId or "")
    for _, id in ipairs(MAINLINE_TALENT_CHOICE_IDS) do
        if id == nodeId then
            return true
        end
    end
    return false
end

local function getMainlineTalentChoiceNodeIds()
    local result = {}
    for _, id in ipairs(MAINLINE_TALENT_CHOICE_IDS) do
        result[#result + 1] = id
    end
    return result
end

local function hasMainlineTalentChoiceActive()
    for _, id in ipairs(MAINLINE_TALENT_CHOICE_IDS) do
        if stateActive(id) then
            return true
        end
    end
    return false
end

local function requestMainlineGuide(marker, guideWidget, guideParent, desc, opts)
    if not (NPC_UI_HELPER and guideWidget and guideParent) then
        return false
    end
    opts = opts or {}
    local guideKey = string.format("%s_%s_%s", opts.keyPrefix or "mainline_linggen_talent", tostring(opts.rwid or getMainlineRwid()), tostring(marker or 0))
    npc._guide_key = guideKey
    return NPC_UI_HELPER.requestGuide("mainline", guideKey, {
        dir = opts.dir or 3,
        guideWidget = guideWidget,
        guideParent = guideParent,
        guideDesc = desc,
        isForce = opts.isForce == true,
        hideMask = opts.hideMask,
        priority = opts.priority,
    })
end

local function closeTalentChoiceGuide()
    if valid(npc.talentChoiceGuide) then
        GUI:removeFromParent(npc.talentChoiceGuide)
    end
    npc.talentChoiceGuide = nil
    npc.talentChoiceGuideNodeId = nil
    npc.talentChoiceGuideNodeIds = nil
    npc.talentChoiceGuideMarkers = nil
    npc.talentChoiceGuideTip = nil
end

local function guideLine(parent, name, x, y, width, height)
    local line = GUI:Layout_Create(parent, name, x, y, width, height, false)
    GUI:setAnchorPoint(line, 0.5, 0.5)
    GUI:Layout_setBackGroundColorType(line, 1)
    GUI:Layout_setBackGroundColor(line, "#E2C16A")
    GUI:Layout_setBackGroundColorOpacity(line, 230)
    GUI:setLocalZOrder(line, 3)
    return line
end

local function getNodeGuidePosition(nodeId)
    local view = npc.nodeViews and npc.nodeViews[tostring(nodeId or "")]
    if not (view and valid(view.holder) and valid(npc.treeCanvas)) then
        return nil
    end
    return GUI:getPosition(view.holder)
end

local function getTalentChoiceGuideSide(nodeId, node)
    local id = tostring(nodeId or node and node.id or "")
    local fixedSides = {
        fire_M1 = -1,
        earth_M1 = -1,
        metal_M1 = 1,
        wood_M1 = 1,
        water_M1 = 1,
    }
    if fixedSides[id] then
        return fixedSides[id]
    end
    local root = TreeCfg.node_map and TreeCfg.node_map.root
    return n(node and node.x) >= n(root and root.x) and 1 or -1
end

local function createTalentChoiceMarker(parent, name, node, nodeId)
    local marker = GUI:Node_Create(parent, name, 0, 0)
    GUI:setTouchEnabled(marker, false)
    GUI:setLocalZOrder(marker, 3)

    local choiceIntro = {
        metal_M1 = {title = "金刃破", desc = "穿刺剑气 斩杀增伤", color = "#F7D15B"},
        wood_M1 = {title = "蔓生种", desc = "枯萎持续 减速压制", color = "#6DEB8C"},
        water_M1 = {title = "冰棱弹", desc = "水蚀增伤 潮汐强化", color = "#76D9FF"},
        fire_M1 = {title = "星火术", desc = "灼烧叠层 死亡溅射", color = "#FF8060"},
        earth_M1 = {title = "土岩落", desc = "落石破防 岩盾护身", color = "#E8B35C"},
    }
    local intro = choiceIntro[tostring(nodeId or "")]
        or {title = node and node.name or "本命技能", desc = tostring(node and node.effect or ""), color = nodeColor(node)}
    local side = getTalentChoiceGuideSide(nodeId, node)
    local nodeHalf = math.max(32, nodeDisplaySize(node) / 2 + 8)
    local lineLen = 42
    local cardW = 172
    local cardH = 70
    local thick = 2
    local rectCenterX = side * (nodeHalf + lineLen + cardW / 2)
    local lineCenterX = side * (nodeHalf + lineLen / 2)

    guideLine(marker, "choice_line", lineCenterX, 0, lineLen, thick)
    local card = GUI:Image_Create(marker, "choice_card", rectCenterX, 0, RES .. "tj_5.png")
    GUI:setAnchorPoint(card, 0.5, 0.5)
    GUI:setContentSize(card, cardW, cardH)
    GUI:setOpacity(card, 238)
    GUI:setLocalZOrder(card, 4)

    local title = text(marker, "choice_title", rectCenterX, 14, 20, intro.color, intro.title, 0.5, 0.5)
    GUI:setLocalZOrder(title, 5)
    local desc = text(marker, "choice_desc", rectCenterX, -10, 18, "#E8D8B8", intro.desc, 0.5, 0.5)
    GUI:setLocalZOrder(desc, 5)
    return marker, rectCenterX, cardH / 2
end

updateTalentChoiceGuidePosition = function()
    if not valid(npc.talentChoiceGuide) or not npc.talentChoiceGuideNodeIds then
        return
    end
    local firstPos = nil
    local firstHalf = 46
    local visibleCount = 0
    for _, marker in ipairs(npc.talentChoiceGuideMarkers or {}) do
        local pos = getNodeGuidePosition(marker.nodeId)
        if pos and valid(marker.node) then
            GUI:setPosition(marker.node, pos.x, pos.y)
            GUI:setVisible(marker.node, true)
            visibleCount = visibleCount + 1
            if not firstPos then
                firstPos = pos
                firstHalf = marker.half or firstHalf
            end
        elseif valid(marker.node) then
            GUI:setVisible(marker.node, false)
        end
    end
    if visibleCount <= 0 then
        closeTalentChoiceGuide()
        return
    end
    if valid(npc.talentChoiceGuideTip) and firstPos then
        GUI:setPosition(npc.talentChoiceGuideTip, firstPos.x, firstPos.y + firstHalf + 62)
        GUI:setVisible(npc.talentChoiceGuideTip, true)
    end
end

local function showTalentChoiceGuide(candidateIds)
    if type(candidateIds) ~= "table" then
        candidateIds = { candidateIds }
    end
    local validIds = {}
    for _, nodeId in ipairs(candidateIds or {}) do
        local id = tostring(nodeId or "")
        local node = TreeCfg.node_map and TreeCfg.node_map[id]
        local view = node and npc.nodeViews and npc.nodeViews[node.id]
        if node and view and valid(view.holder) then
            validIds[#validIds + 1] = id
        end
    end
    if #validIds ~= #candidateIds or not valid(npc.treeCanvas) then
        return false
    end
    if NPC_UI_HELPER then
        NPC_UI_HELPER.closeGuideByDomain("mainline")
    end
    closeTalentChoiceGuide()

    local layer = GUI:Node_Create(npc.treeCanvas, "talent_choice_guide", 0, 0)
    GUI:setLocalZOrder(layer, 980)
    GUI:setTouchEnabled(layer, false)
    npc.talentChoiceGuide = layer
    npc.talentChoiceGuideNodeIds = validIds
    npc.talentChoiceGuideNodeId = validIds[1]
    npc.talentChoiceGuideMarkers = {}

    for index, id in ipairs(validIds) do
        local node = TreeCfg.node_map[id]
        local markerNode, offsetX, half = createTalentChoiceMarker(layer, "choice_marker_" .. tostring(index), node, id)
        npc.talentChoiceGuideMarkers[#npc.talentChoiceGuideMarkers + 1] = {
            nodeId = id,
            node = markerNode,
            offsetX = offsetX,
            half = half,
        }
    end
    npc.talentChoiceGuideTip = nil
    GUI:setVisible(npc.talentChoiceGuide, true)
    updateTalentChoiceGuidePosition()
    return true
end

local function tryStartMainlineCoreNodeGuide()
    if getMainlineRwid() ~= 22 then
        return false
    end
    local view = npc.nodeViews and npc.nodeViews.root
    if not (view and valid(view.button) and valid(view.holder)) then
        return false
    end
    return requestMainlineGuide("core_node", view.button, view.holder, "点击灵根核心", {
        rwid = 22,
        keyPrefix = "mainline_linggen_core",
        priority = 320,
    })
end

local function tryStartMainlineCoreUpgradeGuide()
    if getMainlineRwid() ~= 22 or not valid(npc.upgradeBox) then
        return false
    end
    local upgrade = GUI:getChildByName(npc.upgradeBox, "upgrade_core")
    if not valid(upgrade) then
        return false
    end
    return requestMainlineGuide("core_upgrade", upgrade, npc.upgradeBox, "点击升级核心", {
        rwid = 22,
        keyPrefix = "mainline_linggen_core",
        priority = 330,
        dir = 5
    })
end

local function tryStartMainlineTalentNodeGuide()
    if getMainlineRwid() ~= 23 then
        closeTalentChoiceGuide()
        return false
    end
    local candidateIds = getMainlineTalentChoiceNodeIds()
    if #candidateIds <= 0 then
        npc.mainlineTalentChoice = nil
        closeTalentChoiceGuide()
        if NPC_UI_HELPER then
            NPC_UI_HELPER.closeGuideByDomain("mainline")
        end
        return false
    end
    npc.mainlineTalentChoice = {}
    for _, id in ipairs(candidateIds) do
        npc.mainlineTalentChoice[id] = true
    end
    for _, id in ipairs(MAINLINE_TALENT_CHOICE_IDS) do
        updateNodeVisual(id)
    end
    local nodeId = candidateIds[1]
    local view = nodeId and npc.nodeViews and npc.nodeViews[nodeId]
    if not (view and valid(view.button) and valid(view.holder)) then
        closeTalentChoiceGuide()
        return false
    end
    return showTalentChoiceGuide(candidateIds)
end

local function tryStartMainlineTalentGuides()
    local rwid = getMainlineRwid()
    if rwid == 22 then
        npc.mainlineTalentChoice = nil
        if npc._waitMainlineTalentAfterCore then
            if NPC_UI_HELPER then
                NPC_UI_HELPER.closeGuideByDomain("mainline")
            end
            return false
        end
        if valid(npc.upgradeBox) then
            return tryStartMainlineCoreUpgradeGuide()
        end
        return tryStartMainlineCoreNodeGuide()
    elseif rwid == 23 then
        npc._waitMainlineTalentAfterCore = nil
        npc._mainlineGuideSyncRetry = nil
        closeModalWindow("npc_22_upgrade_window")
        setMainTreeVisible(true)
        if hasMainlineTalentChoiceActive() then
            npc.mainlineTalentChoice = nil
            closeTalentChoiceGuide()
            for _, id in ipairs(MAINLINE_TALENT_CHOICE_IDS) do
                updateNodeVisual(id)
            end
            if NPC_UI_HELPER then
                NPC_UI_HELPER.closeGuideByDomain("mainline")
            end
            return false
        end
        return tryStartMainlineTalentNodeGuide()
    end
    npc.mainlineTalentChoice = nil
    closeTalentChoiceGuide()
    npc._waitMainlineTalentAfterCore = nil
    npc._mainlineGuideSyncRetry = nil
    if NPC_UI_HELPER then
        NPC_UI_HELPER.closeGuideByDomain("mainline")
    end
    return false
end

local function scheduleMainlineGuideSync()
    if npc._mainlineGuideSyncScheduled then
        return
    end
    npc._mainlineGuideSyncScheduled = true
    local function syncGuide()
        npc._mainlineGuideSyncScheduled = nil
        if not valid(npc.window) then
            return
        end
        tryStartMainlineTalentGuides()
        if npc._waitMainlineTalentAfterCore and getMainlineRwid() == 22 then
            npc._mainlineGuideSyncRetry = n(npc._mainlineGuideSyncRetry) + 1
            if npc._mainlineGuideSyncRetry <= 8 then
                scheduleMainlineGuideSync()
            else
                npc._waitMainlineTalentAfterCore = nil
                npc._mainlineGuideSyncRetry = nil
                tryStartMainlineTalentGuides()
            end
        end
    end
    if SL and type(SL.ScheduleOnce) == "function" then
        SL:ScheduleOnce(syncGuide, 0.05)
    else
        syncGuide()
    end
end

local function currentSocketGem(nodeId)
    return tostring((npc.state.sockets or {})[tostring(nodeId)] or "")
end

local function refreshNodeSocketGem(nodeId)
    local view = npc.nodeViews and npc.nodeViews[tostring(nodeId)]
    local node = TreeCfg.node_map and TreeCfg.node_map[tostring(nodeId)]
    if not view or not node or not isSocketNode(node) or not valid(view.holder) then
        return
    end
    if valid(view.gemShow) then
        GUI:removeFromParent(view.gemShow)
        view.gemShow = nil
    end

    local gemName = currentSocketGem(nodeId)
    if gemName == "" then
        return
    end
    local gemIndex = n(SL:GetMetaValue("ITEM_INDEX_BY_NAME", gemName), 0)
    if gemIndex <= 0 then
        return
    end

    local gemShow = GUI:ItemShow_Create(view.holder, "socket_gem", 0, 0, {
        index = gemIndex,
        count = 1,
        look = true,
        movable = false,
        bgVisible = false,
    })
    GUI:setAnchorPoint(gemShow, 0.5, 0.5)
    GUI:setScale(gemShow, 0.68)
    GUI:setLocalZOrder(gemShow, 4)
    GUI:setTouchEnabled(gemShow, false)
    if GUI.ItemShow_setItemTouchSwallow then
        GUI:ItemShow_setItemTouchSwallow(gemShow, true)
    end
    view.gemShow = gemShow
end

local function gemAttrText(gem)
    local attrs = {}
    for _, attr in ipairs(gem and gem.attrs or {}) do
        attrs[#attrs + 1] = tostring(attr.text or ("属性 " .. tostring(attr.id or attr[1] or "")
            .. " +" .. tostring(attr.value or attr[2] or 0)))
    end
    return #attrs > 0 and table.concat(attrs, "、") or "属性由服务端配置"
end

local openGemWindow

local function buildGemWindowRow(parent, index, gem, nodeId)
    local rowH = 78
    local row = GUI:Layout_Create(parent, "gem_row_" .. tostring(index), 6, 0, 648, rowH, false)
    GUI:setAnchorPoint(row, 0, 0)
    GUI:setTouchEnabled(row, true)
    GUI:setSwallowTouches(row, true)
    local rowBg = GUI:Image_Create(row, "row_bg", 324, rowH / 2, PANEL_FRAME)
    GUI:setAnchorPoint(rowBg, 0.5, 0.5)
    GUI:setContentSize(rowBg, 644, rowH - 4)
    GUI:setOpacity(rowBg, 185)
    local frame = imageFrame(row, "item_frame", 42, rowH / 2, 66, 66, NODE_FRAME, 2)
    local item = GUI:ItemShow_Create(row, "item", 42, rowH / 2, {
        index = n(gem.idx),
        count = 1,
        look = true,
        movable = false,
        bgVisible = false,
    })
    GUI:setAnchorPoint(item, 0.5, 0.5)
    GUI:setLocalZOrder(item, 3)
    text(row, "gem_name", 88, 50, 18, "#F4E6C0", gem.name, 0, 0.5)
    text(row, "gem_level", 88, 25, 15, "#9FE2FF",
        "等级 " .. tostring(gem.level or 1) .. "    拥有 " .. tostring(gem.count or 0), 0, 0.5)
    -- text(row, "gem_attrs", 280, 38, 15, "#B9F6C5", gemAttrText(gem), 0, 0.5)
    local choose = button(row, "choose", 585, rowH / 2, "镶嵌", function()
        SL:SendLuaNetMsg(100, 22, 4, 0, SL:JsonEncode({
            id = nodeId,
            gem = gem.name,
        }, false))
    end, 92, 36)
    GUI:setLocalZOrder(choose, 4)
    return row
end

local function renderGemList(gemList, nodeId)
    if not valid(npc.gemBox) then
        return
    end
    local oldScroll = GUI:getChildByName(npc.gemBox, "gem_scroll")
    if oldScroll then
        GUI:removeFromParent(oldScroll)
    end
    gemList = type(gemList) == "table" and gemList or {}
    npc.gemList = gemList
    local scroll = GUI:ScrollView_Create(npc.gemBox, "gem_scroll", 40, 0, 660, 360, 1)
    GUI:ScrollView_setClippingEnabled(scroll, true)
    GUI:ScrollView_setBounceEnabled(scroll, true)
    local innerH = math.max(360, #gemList * 82 + 10)
    GUI:ScrollView_setInnerContainerSize(scroll, 660, innerH)
    local listRoot = GUI:Layout_Create(scroll, "gem_list_root", 0, 0, 660, innerH, false)
    for index, gem in ipairs(gemList) do
        local row = buildGemWindowRow(listRoot, index, gem, nodeId)
        GUI:setPosition(row, 6, innerH - index * 82 - 4)
    end
    if #gemList == 0 then
        text(listRoot, "empty", 330, innerH / 2, 18, "#FFB85A",
            "当前没有符合该槽位要求的宝石", 0.5, 0.5)
    end
end

openGemWindow = function()
    local nodeId = tostring(npc.selectedId or "")
    local node = TreeCfg.node_map and TreeCfg.node_map[nodeId]
    if not node or not isSocketNode(node) or not stateActive(nodeId) then
        return
    end
    local sw = n(cogin and cogin.w, 1280)
    local sh = n(cogin and cogin.h, 720)
    local boxW = math.min(760, sw - 80)
    local boxH = math.min(540, sh - 80)
    npc.gemWindow = createModalWindow(GEM_WINDOW_NAME)
    local mask = GUI:Image_Create(npc.gemWindow, "mask", 0, 0, "res/public/1900000651_1.png")
    GUI:setAnchorPoint(mask, 0.5, 0.5)
    GUI:setContentSize(mask, sw + 100, sh + 100)
    GUI:setTouchEnabled(mask, true)
    local box = GUI:Image_Create(npc.gemWindow, "gem_box", 0, 0, PANEL_FRAME)
    GUI:setAnchorPoint(box, 0.5, 0.5)
    GUI:setContentSize(box, boxW, boxH)
    GUI:setTouchEnabled(box, true)
    GUI:setSwallowTouches(box, true)

    local bigkuang = GUI:Image_Create(npc.gemWindow, "bigkuang", 0, 0, "res/wy/public/box.png")
    GUI:setAnchorPoint(bigkuang, 0.5, 0.5)
    GUI:setContentSize(bigkuang, boxW + 4, boxH + 4)


    npc.gemBox = box
    text(box, "gem_title", boxW/2, boxH - 20, 25, "#F1D176", "选择镶嵌宝石", 0.5, 0.5)
    text(box, "gem_hint", boxW/2, boxH - 40, 15, "#AAB5C8",
        "仅显示背包中拥有且符合当前槽位等级要求的宝石", 0.5, 0.5)
    local close = button(box, "gem_close", boxW - 48, boxH - 34, "", function()
        closeModalWindow(GEM_WINDOW_NAME)
    end, 60, 54,"res/wy/public/gjyj_x.png")
    local current = currentSocketGem(nodeId)
    text(box, "gem_current",  boxW/2, boxH/2 + 150, 25, "#FFD66B",
        current ~= "" and ("当前镶嵌：" .. current) or "当前未镶嵌宝石", 0.5, 0.5)
    renderGemList({}, nodeId)
    SL:SendLuaNetMsg(100, 22, 4, 0, SL:JsonEncode({id = nodeId}, false))
end

local function nodeColor(node)
    if node.kind == "root" then
        return "#F1D176"
    end
    local element = TreeCfg.element_map and TreeCfg.element_map[node.element]
    return element and element.color or "#B9C4D6"
end

local function getUnfilledSocketPrerequisite(node)
    if not node or stateActive(node.id) then
        return nil
    end
    local function findIn(list)
        for _, requiredId in ipairs(list or {}) do
            local required = TreeCfg.node_map and TreeCfg.node_map[tostring(requiredId)]
            local gemName = tostring((npc.state.sockets or {})[tostring(requiredId)] or "")
            if required and isSocketNode(required) and stateActive(requiredId) and gemName == "" then
                return required.name or tostring(requiredId)
            end
        end
        return nil
    end
    return findIn(node.requires) or findIn(node.requires_any)
end

local function attrLines(node)
    local result = {}
    local seen = {}
    for _, attr in ipairs(node.attrs or {}) do
        local line = attr.text or ("属性 " .. tostring(attr.id) .. " +" .. tostring(attr.value))
        if not seen[line] then
            seen[line] = true
            result[#result + 1] = line
        end
    end
    return result
end

local function isInternalNodeDesc(value)
    value = tostring(value or "")
    return value == ""
        or value:match("^M%d+：$") ~= nil
        or value == "流派A"
        or value == "流派B"
        or value == "本命技能"
        or value == "终极双流派共主技能"
        or value == "双流派共主终极技能"
        or value == "跨系通道节点。桥梁宝石槽不消耗天赋点，集群宝石不可镶嵌。"
end

local function displayNodeText(value)
    value = tostring(value or "")
    value = value:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")
    value = value:gsub("\r\n", "\n"):gsub("\r", "\n"):gsub("\n", "<br/>")
    return value
end

local function configuredDescLines(node)
    local result = {}
    local seen = {}
    local function add(value)
        value = tostring(value or "")
        local key = value:gsub("%s+", "")
        if key == "" or seen[key] or value:match("^M%d+：$") then
            return
        end
        seen[key] = true
        result[#result + 1] = value
    end

    local hasEffect = not isInternalNodeDesc(node.effect)
    -- Prefer the designed effect, including effects with no attribute binding.
    if hasEffect then
        add(node.effect)
    else
        for _, value in ipairs(attrLines(node)) do
            add(value)
        end
    end

    local special = node.special
    local element = TreeCfg.element_map and TreeCfg.element_map[node.element]
    if node.slot_type == "J-终极" and element and element.ultimate then
        local skill = element.ultimate
        add("技能设计：" .. tostring(skill.name or node.name)
            .. "（冷却 " .. tostring(skill.cd or "") .. "）")
        add(skill.desc)
    elseif special and (node.slot_type == "skill"
        or special.key == tostring(node.element) .. "_ultimate") then
        if not isInternalNodeDesc(node.desc) then
            add(node.desc)
        else
            add(special.name)
            add(special.desc)
        end
    elseif not hasEffect then
        if special and not isInternalNodeDesc(special.desc) then
            add(special.desc)
        elseif not isInternalNodeDesc(node.desc) then
            add(node.desc)
        end
    elseif isSocketNode(node) and not isInternalNodeDesc(node.desc) then
        add(node.desc)
    end
    return result
end

local function requirementText(node)
    if node.kind == "root" then
        return "无需前置节点"
    end
    local linked = {}
    local linkedSet = {}
    local function addLinked(id)
        local key = tostring(id)
        if not linkedSet[key] then
            linkedSet[key] = true
            local linkedNode = TreeCfg.node_map and TreeCfg.node_map[key]
            linked[#linked + 1] = linkedNode and linkedNode.name or key
        end
    end
    for _, id in ipairs(node.requires or {}) do
        addLinked(id)
    end
    for _, id in ipairs(node.requires_any or {}) do
        addLinked(id)
    end
    for _, candidate in ipairs(TreeCfg.nodes or {}) do
        if tostring(candidate.id) ~= tostring(node.id) then
            for _, id in ipairs(candidate.requires or {}) do
                if tostring(id) == tostring(node.id) then
                    addLinked(candidate.id)
                    break
                end
            end
            for _, id in ipairs(candidate.requires_any or {}) do
                if tostring(id) == tostring(node.id) then
                    addLinked(candidate.id)
                    break
                end
            end
        end
    end
    if #linked == 0 then
        return "暂无相连节点"
    end
    local socketName = getUnfilledSocketPrerequisite(node)
    if socketName then
        return "请先在" .. socketName .. "镶嵌宝石"
    end
    return "可从任一相连节点点亮：" .. table.concat(linked, "、")
end

local function buildInfoHtml(node)
    if not node then
        return ""
    end
    local lines = {}
    for _, value in ipairs(configuredDescLines(node)) do
        lines[#lines + 1] = "<font color='#D8C39A'>" .. displayNodeText(value) .. "</font>"
    end
    if isSocketNode(node) then
        local gemName = currentSocketGem(node.id)
        lines[#lines + 1] = "<font color='#FFD66B'>"
            .. displayNodeText(gemName ~= "" and ("当前镶嵌：" .. gemName) or "当前未镶嵌宝石")
            .. "</font>"
    end
    if #lines == 0 then
        lines[#lines + 1] = "<font color='#D8C39A'>" .. displayNodeText(node.name or "节点") .. "</font>"
    end
    if node.exclusive_group == "core_m1" then
        lines[#lines + 1] = "<font color='#FFD66B'>五系 M1 互斥，只能点亮其中一个。</font>"
        local other = conflictingM1(node)
        if other then
            lines[#lines + 1] = "<font color='#FF8585'>已选择：" .. displayNodeText(other.name) .. "</font>"
        end
    end
    lines[#lines + 1] = "<font color='#AAB5C8'>" .. displayNodeText(requirementText(node)) .. "</font>"
    lines[#lines + 1] = "<font color='#AAB5C8'>点数消耗："
        .. tostring(node.point_cost or 1) .. " 天赋点</font>"
    if node.cost and #node.cost > 0 then
        local costs = {}
        for _, cost in ipairs(node.cost) do
            costs[#costs + 1] = tostring(cost[1]) .. "×" .. tostring(cost[2])
        end
        lines[#lines + 1] = "<font color='#AAB5C8'>材料消耗："
            .. displayNodeText(table.concat(costs, "、")) .. "</font>"
    end
    if node.core_level and n(node.core_level) > 0 then
        lines[#lines + 1] = "<font color='#FFD66B'>需要灵根核心达到 "
            .. tostring(node.core_level) .. " 级</font>"
    end
    return table.concat(lines, "<br/>")
end

local function refreshZoomText()
    if valid(npc.zoomText) then
        GUI:Text_setString(npc.zoomText, "缩放 " .. tostring(math.floor((npc.zoom or DEFAULT_ZOOM) * 100)) .. "%")
    end
end

local function zoomToSliderPercent(zoom)
    return (n(zoom, DEFAULT_ZOOM) - MIN_ZOOM) / (MAX_ZOOM - MIN_ZOOM) * 100
end

local function sliderPercentToZoom(percent)
    return MIN_ZOOM + (MAX_ZOOM - MIN_ZOOM) * n(percent, zoomToSliderPercent(DEFAULT_ZOOM)) / 100
end

local function getNodeVisualRadius(node)
    local size = nodeDisplaySize(node)
    return size / 2 + 8
end

local function calculateTreeBounds()
    local minX, minY = math.huge, math.huge
    local maxX, maxY = -math.huge, -math.huge
    for _, node in ipairs(npc.layoutNodes or TreeCfg.nodes or {}) do
        local radius = getNodeVisualRadius(node)
        minX = math.min(minX, n(node.x) - radius - TREE_LABEL_PAD_X)
        minY = math.min(minY, n(node.y) - radius - TREE_LABEL_PAD_Y)
        maxX = math.max(maxX, n(node.x) + radius + TREE_LABEL_PAD_X)
        maxY = math.max(maxY, n(node.y) + radius)
    end
    if minX == math.huge then
        return {minX = 0, minY = 0, maxX = CANVAS_W, maxY = CANVAS_H}
    end
    return {minX = minX, minY = minY, maxX = maxX, maxY = maxY}
end

local function clampTreePosition(posX, posY)
    local viewW = n(npc.treeViewW, 0)
    local viewH = n(npc.treeViewH, 0)
    local zoom = n(npc.zoom, DEFAULT_ZOOM)
    local bounds = npc.treeBounds or {minX = 0, minY = 0, maxX = CANVAS_W, maxY = CANVAS_H}
    local contentW = (bounds.maxX - bounds.minX) * zoom
    local contentH = (bounds.maxY - bounds.minY) * zoom
    local dragPadding = TREE_EDGE_PADDING + TREE_EXTRA_PADDING
    local minX, maxX
    local minY, maxY
    if contentW <= viewW then
        minX = viewW / 2 - (bounds.minX + bounds.maxX) / 2 * zoom
        maxX = minX
    else
        minX = viewW - dragPadding - bounds.maxX * zoom
        maxX = dragPadding - bounds.minX * zoom
    end
    if contentH <= viewH then
        minY = viewH / 2 - (bounds.minY + bounds.maxY) / 2 * zoom
        maxY = minY
    else
        minY = viewH - dragPadding - bounds.maxY * zoom
        maxY = dragPadding - bounds.minY * zoom
    end
    posX = math.max(minX, math.min(maxX, n(posX, minX)))
    posY = math.max(minY, math.min(maxY, n(posY, minY)))
    return posX, posY
end

local function positionTreeCanvas(posX, posY)
    if not valid(npc.treeCanvas) then
        return
    end
    posX, posY = clampTreePosition(posX, posY)
    GUI:setPosition(npc.treeCanvas, posX, posY)
    npc.treeCanvasPos = {x = posX, y = posY}
    updateTalentChoiceGuidePosition()
end

local function centerTreeCanvas()
    local zoom = n(npc.zoom, DEFAULT_ZOOM)
    local viewW = n(npc.treeViewW, 0)
    local viewH = n(npc.treeViewH, 0)
    local root = TreeCfg.node_map and TreeCfg.node_map.root
    root = getLayoutNode(root and root.id or "root")
    local centerX = n(root and root.x, 900)
    local centerY = n(root and root.y, 650)
    positionTreeCanvas(viewW / 2 - centerX * zoom, viewH / 2 - centerY * zoom)
end

local function beginTreeGesture(sender)
    local touch = GUI:getTouchBeganPosition(sender)
    if not touch or not valid(npc.treeCanvas) then
        return
    end
    local canvas = GUI:getPosition(npc.treeCanvas)
    npc.treeGesture = {
        beginTouch = touch,
        beginCanvas = canvas,
        moved = false,
    }
    npc.treeDragging = false
    npc.suppressNodeClick = false
end

local function moveTreeGesture(sender)
    local gesture = npc.treeGesture
    local moveTouch = GUI:getTouchMovePosition(sender)
    if not gesture or not moveTouch then
        return
    end
    local dx = moveTouch.x - gesture.beginTouch.x
    local dy = moveTouch.y - gesture.beginTouch.y
    if math.abs(dx) >= TREE_DRAG_THRESHOLD or math.abs(dy) >= TREE_DRAG_THRESHOLD then
        gesture.moved = true
        npc.treeDragging = true
        npc.suppressNodeClick = true
        if setInfoDrawer and npc.infoDrawerOpen then
            setInfoDrawer(false, true)
        end
    end
    positionTreeCanvas((gesture.beginCanvas.x or 0) + dx, (gesture.beginCanvas.y or 0) + dy)
end

local function endTreeGesture(sender)
    npc.treeDragging = npc.treeGesture and npc.treeGesture.moved == true or false
    npc.treeGesture = nil
end

local function setZoom(value)
    local oldZoom = n(npc.zoom, DEFAULT_ZOOM)
    local oldPos = valid(npc.treeCanvas) and GUI:getPosition(npc.treeCanvas) or nil
    npc.zoom = math.max(MIN_ZOOM, math.min(MAX_ZOOM, n(value, DEFAULT_ZOOM)))
    if valid(npc.treeCanvas) then
        GUI:setScale(npc.treeCanvas, npc.zoom)
        local viewW = n(npc.treeViewW, 0)
        local viewH = n(npc.treeViewH, 0)
        local root = TreeCfg.node_map and TreeCfg.node_map.root
        root = getLayoutNode(root and root.id or "root")
        local rootX = n(root and root.x, 900)
        local rootY = n(root and root.y, 650)
        local oldX = oldPos and oldPos.x or (viewW / 2 - rootX * oldZoom)
        local oldY = oldPos and oldPos.y or (viewH / 2 - rootY * oldZoom)
        local worldX = (viewW / 2 - oldX) / oldZoom
        local worldY = (viewH / 2 - oldY) / oldZoom
        positionTreeCanvas(viewW / 2 - worldX * npc.zoom, viewH / 2 - worldY * npc.zoom)
    end
    if npc.zoomSlider and npc.zoomSlider.setPercent then
        npc.updatingZoomSlider = true
        npc.zoomSlider.setPercent(zoomToSliderPercent(npc.zoom))
        npc.updatingZoomSlider = false
    end
    refreshZoomText()
end

local function createZoomControl(sw, sh)
    local controlX = sw / 2 - (npc.infoW or 250) - 30
    local controlY = -10
    local controlH = math.min(360, math.max(250, sh - 210))
    local trackW = 18

    npc.zoomControl = GUI:Node_Create(npc.window, "zoom_control", controlX, controlY)
    npc.zoomControlOpenX = controlX
    npc.zoomControlClosedX = sw / 2 - 24
    GUI:setLocalZOrder(npc.zoomControl, 20)

    local track = panel(npc.zoomControl, "zoom_track", 0, 0, trackW, controlH, "#211812")
    GUI:setLocalZOrder(track, 1)
    local trackLine = GUI:Image_Create(npc.zoomControl, "zoom_track_line", 0, 0, RES .. "tj_24.png")
    GUI:setAnchorPoint(trackLine, 0.5, 0.5)
    GUI:setContentSize(trackLine, 13, controlH - 20)
    -- GUI:setRotation(trackLine, 90)
    GUI:setLocalZOrder(trackLine, 2)

    local thumb = GUI:Image_Create(npc.zoomControl, "zoom_thumb", 0, 0, "res/wy/public/anniu_25_close.png")
    GUI:setAnchorPoint(thumb, 0.5, 0.5)
    GUI:setContentSize(thumb, 40, 30)
    GUI:setLocalZOrder(thumb, 4)

    -- local topText = text(npc.zoomControl, "zoom_top", 30, controlH / 2 - 12, 12, COLORS.muted, "100%", 0, 0.5)
    -- local midText = text(npc.zoomControl, "zoom_mid", 30, 0, 12, COLORS.text, "100%", 0, 0.5)
    -- local bottomText = text(npc.zoomControl, "zoom_bottom", 30, -controlH / 2 + 12, 12, COLORS.muted, "10%", 0, 0.5)
    -- -- GUI:setLocalZOrder(topText, 3)
    -- -- GUI:setLocalZOrder(midText, 3)
    -- GUI:setLocalZOrder(bottomText, 3)
    npc.zoomText = text(npc.zoomControl, "zoom_text", 0, -controlH / 2 - 24, 13, COLORS.text, "", 0.5, 0.5)
    GUI:setLocalZOrder(npc.zoomText, 3)

    local touch = GUI:Layout_Create(npc.zoomControl, "zoom_touch", 0, 0, 72, controlH + 24, false)
    GUI:setAnchorPoint(touch, 0.5, 0.5)
    GUI:setLocalZOrder(touch, 10)
    GUI:setTouchEnabled(touch, true)
    GUI:setSwallowTouches(touch, true)

    local function updateFromTouch(sender)
        local pos = GUI:getTouchMovePosition(sender) or GUI:getTouchBeganPosition(sender)
        if not pos then
            return
        end
        local controlPos = GUI:getPosition(npc.zoomControl)
        local controlWorldY = sh / 2 + (controlPos.y or controlY)
        local localY = pos.y - controlWorldY
        local percent = math.max(0, math.min(100, (localY + controlH / 2) / controlH * 100))
        setZoom(sliderPercentToZoom(percent))
    end

    GUI:addOnTouchEvent(touch, function(sender, eventType)
        if eventType == SLDefine.TouchEventType.began
            or eventType == SLDefine.TouchEventType.moved
            or eventType == SLDefine.TouchEventType.ended then
            updateFromTouch(sender)
        end
    end)
    npc.zoomSlider = {
        track = track,
        thumb = thumb,
        controlH = controlH,
        setPercent = function(percent)
            local y = -controlH / 2 + controlH * math.max(0, math.min(100, percent)) / 100
            GUI:setPosition(thumb, 0, y)
        end,
    }
    npc.zoomSlider.setPercent(zoomToSliderPercent(DEFAULT_ZOOM))
    refreshZoomText()
end

setInfoDrawer = function(open, animate)
    if not valid(npc.window) then
        return
    end

    open = open == true
    local openX = n(npc.infoPanelOpenX, 0)
    local closedX = n(npc.infoPanelClosedX, openX)
    local targetX = open and openX or closedX
    local zoomOpenX = n(npc.zoomControlOpenX, openX)
    local zoomClosedX = n(npc.zoomControlClosedX, n(cogin and cogin.w, 1280) / 2 - 24)
    local zoomTargetX = open and zoomOpenX or zoomClosedX

    local function stopMove(node)
        if valid(node) and GUI and type(GUI.stopAllActions) == "function" then
            GUI:stopAllActions(node)
        end
    end

    local function snapNode(node, x)
        if not valid(node) then
            return
        end
        local pos = GUI:getPosition(node)
        GUI:setPosition(node, x, pos.y)
    end

    local function snapAll()
        snapNode(npc.infoPanel, targetX)
        snapNode(npc.infoFrame, targetX)
        snapNode(npc.zoomControl, zoomTargetX)
    end

    if npc.infoDrawerAnimating then
        if npc.infoDrawerTargetOpen == open then
            return
        end
        animate = false
    elseif npc.infoDrawerOpen == open and npc.infoDrawerTargetOpen == open then
        snapAll()
        return
    end

    npc.infoDrawerOpen = open
    npc.infoDrawerTargetOpen = open

    stopMove(npc.infoPanel)
    stopMove(npc.infoFrame)
    stopMove(npc.zoomControl)

    npc.infoDrawerToken = n(npc.infoDrawerToken, 0) + 1
    local token = npc.infoDrawerToken
    local duration = animate and 0.24 or 0
    if duration <= 0 then
        npc.infoDrawerAnimating = false
        snapAll()
        return
    end

    local function move(node, x)
        if not valid(node) then
            return
        end
        GUI:Timeline_EaseSineIn_MoveTo(node, {x = x, y = GUI:getPosition(node).y}, duration)
    end

    npc.infoDrawerAnimating = true
    move(npc.infoPanel, targetX)
    move(npc.infoFrame, targetX)
    move(npc.zoomControl, zoomTargetX)

    if SL and type(SL.ScheduleOnce) == "function" then
        SL:ScheduleOnce(function()
            if npc.infoDrawerToken ~= token then
                return
            end
            npc.infoDrawerAnimating = false
            snapAll()
        end, duration + 0.02)
    else
        npc.infoDrawerAnimating = false
        snapAll()
    end
end

local function updateInfo()
    local info = npc.infoPanel
    local node = TreeCfg.node_map and TreeCfg.node_map[npc.selectedId or "root"]
    if not valid(info) or not node then
        return
    end
    local active = stateActive(node.id)
    local kicker = GUI:getChildByName(info, "info_kicker")
    local infoTitle = GUI:getChildByName(info, "info_title")
    local effectTitle = GUI:getChildByName(info, "info_effect_title")
    local title = GUI:getChildByName(info, "node_title")
    local status = GUI:getChildByName(info, "node_status")
    local descScroll = GUI:getChildByName(info, "node_desc_scroll")
    local icon = GUI:getChildByName(info, "info_node_icon")
    if kicker then
        local laneText = node.kind == "root" and "CORE ROOT" or string.upper(tostring(node.lane or "NODE"))
        GUI:Text_setString(kicker, laneText)
    end
    if infoTitle then
        GUI:Text_setString(infoTitle, "天赋预览")
        GUI:Text_setTextColor(infoTitle, nodeColor(node))
    end
    if effectTitle then
        GUI:Text_setString(effectTitle, "天赋效果")
        GUI:Text_setTextColor(effectTitle, nodeColor(node))
    end
    if title then
        GUI:Text_setString(title, node.name or "")
        GUI:Text_setTextColor(title, nodeColor(node))
    end
    if status then
        GUI:Text_setString(status, node.kind == "root" and "核心节点" or (active and "已点亮" or "未点亮"))
        GUI:Text_setTextColor(status, active and COLORS.green or COLORS.muted)
    end
    if icon then
        GUI:setOpacity(icon, 255)
        GUI:setGrey(icon, false)
    end
    local html = buildInfoHtml(node)
    if descScroll and (npc.infoDescId ~= node.id or npc.infoDescHtml ~= html) then
        local desc = GUI:getChildByName(descScroll, "node_desc")
        if desc then
            GUI:removeFromParent(desc)
        end
        local viewSize = GUI:getContentSize(descScroll)
        GUI:ScrollView_setInnerContainerSize(descScroll, viewSize.width, viewSize.height)
        local newDesc = GUI:RichText_Create(descScroll, "node_desc", 0, 0, html, npc.infoDescW, 16,
            COLORS.text, 0, nil, nil, {outlineSize = 1, outlineColor = "#000000"})
        GUI:setAnchorPoint(newDesc, 0, 1)
        GUI:setTouchEnabled(newDesc, false)
        local innerH = math.max(viewSize.height, GUI:getContentSize(newDesc).height + 8)
        GUI:ScrollView_setInnerContainerSize(descScroll, viewSize.width, innerH)
        GUI:setPosition(newDesc, 0, innerH)
        npc.infoDescId = node.id
        npc.infoDescHtml = html
    end
    local action = GUI:getChildByName(info, "node_action")
    if action then
        local blockedSocket = not active and getUnfilledSocketPrerequisite(node)
        if node.kind == "root" then
            GUI:Button_setTitleText(action, "升级核心")
        elseif isSocketNode(node) and active then
            GUI:Button_setTitleText(action, "镶嵌")
        elseif blockedSocket then
            GUI:Button_setTitleText(action, "先镶嵌宝石")
        elseif active then
            GUI:Button_setTitleText(action, "退点")
        elseif conflictingM1(node) then
            GUI:Button_setTitleText(action, "切换本命")
        else
            GUI:Button_setTitleText(action, "点亮")
        end
    end
end

local function refreshUpgradeInfo()
    local box = npc.upgradeBox
    if not valid(box) then
        return
    end
    local state = npc.state or {}
    local nextCfg = TreeCfg.core_level_map and TreeCfg.core_level_map[n(state.core_level) + 1]
    renderUpgradeAttrScroll(box, state, nextCfg)

    local oldPreview = GUI:getChildByName(box, "upgrade_preview")
    if oldPreview then
        GUI:removeFromParent(oldPreview)
    end
    local preview = GUI:Node_Create(box, "upgrade_preview", UPGRADE_RIGHT_X, UPGRADE_PREVIEW_Y)
    GUI:setLocalZOrder(preview, 5)
    local coreNode = TreeCfg.node_map and TreeCfg.node_map.root
    local coreSkin = coreNode and nodeButtonSkin(coreNode) or NODE_CORE_SKIN
    -- local coreItem = GUI:Image_Create(preview, "core_item", 0, 0, coreSkin)
    -- GUI:setAnchorPoint(coreItem, 0.5, 0.5)
    -- GUI:setContentSize(coreItem, 74, 74)

    local core_frame = GUI:Image_Create(preview, "core_frame", -8 + 2, -68 + 247 + 7 + 7, NODE_ROOT_BACK)
    GUI:setAnchorPoint(core_frame, 0.5, 0.5)
    GUI:setContentSize(core_frame, 100, 100)
    local levelText = text(preview, "core_level", -8 + 2, -68 + 247 + 7 + 7 - 70, 25, "#FF0000",
    tostring(n(state.core_level)) .. "级", 0.5, 0.5)
    GUI:setLocalZOrder(levelText, 2)
    GUI:Text_setFontName(levelText, "fonts/502.ttf")

    renderUpgradeCosts(box, nextCfg)

    local action = GUI:getChildByName(box, "upgrade_core")
    if action then
        GUI:setGrey(action, not nextCfg)
    end
end

updateNodeVisual = function(nodeId)
    local item = npc.nodeViews and npc.nodeViews[nodeId]
    local cfg = TreeCfg.node_map and TreeCfg.node_map[nodeId]
    if not item or not cfg or not valid(item.button) then
        return
    end
    local active = stateActive(nodeId)
    local selected = npc.selectedId == nodeId
    local color = selected and nodeColor(cfg) or (active and nodeColor(cfg) or "#596273")
    -- if valid(item.halo) then
    --     GUI:Layout_setBackGroundColor(item.halo, color)
    --     GUI:Layout_setBackGroundColorOpacity(item.halo, selected and 255 or (active and 245 or 105))
    -- end
    for _, line in ipairs(item.lines or {}) do
        if valid(line) then
            setNodeLinkState(line, active)
        end
    end
    local isMainlineChoice = npc.mainlineTalentChoice
        and npc.mainlineTalentChoice[tostring(nodeId)]
    GUI:setGrey(item.button, false)
    if valid(item.activeBack) then
        GUI:setVisible(item.activeBack, active == true)
    end
    local stateText = GUI:getChildByName(item.button, "state")
    if stateText then
        GUI:Text_setString(stateText, selected and "◆" or (active and "●" or (isMainlineChoice and "◆" or "")))
        GUI:Text_setTextColor(stateText, selected and "#FFF3B0" or (active and COLORS.green or (isMainlineChoice and "#FFD66B" or COLORS.muted)))
    end
    refreshNodeSocketGem(nodeId)
end

local function updateAllNodeVisuals()
    for id in pairs(npc.nodeViews or {}) do
        updateNodeVisual(id)
    end
    updateInfo()
end

local function refreshChangedNodeVisuals(changedIds)
    local selectedChanged = false
    local selected = TreeCfg.node_map and TreeCfg.node_map[npc.selectedId]
    for id in pairs(changedIds or {}) do
        updateNodeVisual(id)
        if tostring(id) == tostring(npc.selectedId) then
            selectedChanged = true
        elseif selected and selected.exclusive_group == "core_m1" then
            local changed = TreeCfg.node_map[id]
            if changed and changed.exclusive_group == "core_m1" then
                selectedChanged = true
            end
        end
    end
    if selectedChanged then
        updateInfo()
    end
end

local function refreshTalentPointsText()
    if type(npc.state) ~= "table" or not valid(npc.header) then
        return
    end
    local remaining = math.max(0, n(npc.state.normal_points))
    local total = math.max(0, n(npc.state.normal_total))
    local used = math.min(total, math.max(0, total - remaining))
    local remainingValue = GUI:getChildByName(npc.header, "points_remaining_value")
    local usedValue = GUI:getChildByName(npc.header, "points_used_value")
    local points = GUI:getChildByName(npc.header, "points")
    if valid(remainingValue) then
        GUI:Text_setString(remainingValue, tostring(remaining))
    end
    if valid(usedValue) then
        GUI:Text_setString(usedValue, tostring(used))
    end
    if valid(points) then
        GUI:Text_setString(points, string.format(
            "剩余天赋点：%d\n已使用天赋点：%d",
            remaining, used
        ))
    end
end

local function applyClientConfigDefaults(state)
    state = type(state) == "table" and state or {}
    state.version = n(TreeCfg.version, state.version)
    state.core_max_level = 0
    for _, levelCfg in ipairs(TreeCfg.core_levels or {}) do
        state.core_max_level = math.max(state.core_max_level, n(levelCfg.level))
    end
    state.normal_point_limit = n(TreeCfg.normal_point_limit, 210)
    state.external_normal_point_limit = n(TreeCfg.external_normal_point_limit, 7)
    state.single_branch_limit = n(TreeCfg.single_branch_limit, 40)
    state.side_branch_limit = n(TreeCfg.side_branch_limit, 6)
    state.reset_cost = TreeCfg.reset_cost or {}
    state.single_reset_cost = TreeCfg.single_reset_cost or {}
    return state
end

local function refreshPayload(payload)
    payload = decode(payload)
    if payload.payload then
        payload = payload.payload
    end

    npc.state = applyClientConfigDefaults(npc.state)
    local oldCoreLevel = n(npc.state.core_level)
    local changedNodes = {}
    local socketChanged = false
    if type(payload.nodes) == "table" then
        local oldNodes = npc.state.nodes or {}
        local checked = {}
        for id, value in pairs(oldNodes) do
            checked[tostring(id)] = true
            if n(value) ~= n(payload.nodes[id]) then
                changedNodes[tostring(id)] = true
            end
        end
        for id, value in pairs(payload.nodes) do
            local key = tostring(id)
            if not checked[key] and n(value) ~= n(oldNodes[id]) then
                changedNodes[key] = true
            end
        end
        npc.state.nodes = payload.nodes
    end
    if type(payload.special) == "table" then
        npc.state.special = payload.special
    end
    if type(payload.sockets) == "table" then
        local oldSockets = npc.state.sockets or {}
        local checkedSockets = {}
        for id, value in pairs(oldSockets) do
            checkedSockets[tostring(id)] = true
            if tostring(value or "") ~= tostring(payload.sockets[id] or "") then
                changedNodes[tostring(id)] = true
                socketChanged = true
            end
        end
        for id, value in pairs(payload.sockets) do
            local key = tostring(id)
            if not checkedSockets[key] and tostring(value or "") ~= "" then
                changedNodes[key] = true
                socketChanged = true
            end
        end
        npc.state.sockets = payload.sockets
    end
    if type(payload.gem_list) == "table" then
        npc.gemList = payload.gem_list
        if valid(npc.gemBox) then
            renderGemList(payload.gem_list, tostring(payload.id or npc.selectedId or ""))
            local current = GUI:getChildByName(npc.gemBox, "gem_current")
            if current then
                local currentGem = currentSocketGem(tostring(payload.id or npc.selectedId or ""))
                GUI:Text_setString(current, currentGem ~= "" and ("当前镶嵌：" .. currentGem) or "当前未镶嵌宝石")
            end
        end
    end
    npc.state.normal_points = n(payload.normal_points, npc.state.normal_points)
    npc.state.normal_total = n(payload.normal_total, npc.state.normal_total)
    npc.state.core_level = n(payload.core_level, npc.state.core_level)
    npc.state.normal_external_total = n(payload.normal_external_total, npc.state.normal_external_total)
    applyClientConfigDefaults(npc.state)
    refreshTalentPointsText()
    refreshChangedNodeVisuals(changedNodes)
    if socketChanged then
        updateInfo()
    end
    if n(payload.socket_result, 0) == 1 then
        closeModalWindow(GEM_WINDOW_NAME)
    end
    if oldCoreLevel ~= n(npc.state.core_level) then
        refreshUpgradeInfo()
        if oldCoreLevel < n(npc.state.core_level) then
            npc._waitMainlineTalentAfterCore = true
            npc._mainlineGuideSyncRetry = 0
            if NPC_UI_HELPER then
                NPC_UI_HELPER.closeGuideByDomain("mainline")
            end
        end
        scheduleMainlineGuideSync()
    else
        for id in pairs(changedNodes) do
            if isMainlineTalentChoiceNode(id) and stateActive(id) then
                scheduleMainlineGuideSync()
                break
            end
        end
    end
end

local function drawLine(parent, name, fromNode, toNode)
    local isTrunk = fromNode.id == "root"
        or fromNode.lane == "main"
        or toNode.lane == "main"
    local lineWidth = isTrunk and 7 or (toNode.kind == "bridge" and 3 or 4)
    return createNodeLinkImage(parent, name, fromNode, toNode, {
        width = lineWidth,
        active = stateActive(toNode.id),
        skin = LINK_SKIN,
    })
end

local openUpgrade

local function selectNode(id)
    if npc.suppressNodeClick then
        npc.suppressNodeClick = false
        return
    end
    local isMainlineChoice = npc.mainlineTalentChoice
        and npc.mainlineTalentChoice[tostring(id)]
    -- Mainline choice guide stays visible after selecting a node.
    -- It is closed only after the server confirms the talent is lit.
    local previousId = npc.selectedId
    npc.selectedId = id
    if setInfoDrawer then
        setInfoDrawer(true, true)
    end
    updateNodeVisual(previousId)
    updateNodeVisual(id)
    if isMainlineChoice then
        for _, choiceId in ipairs(MAINLINE_TALENT_CHOICE_IDS) do
            if tostring(choiceId) ~= tostring(previousId) and tostring(choiceId) ~= tostring(id) then
                updateNodeVisual(choiceId)
            end
        end
    end
    updateInfo()
    if id == "root" then
        openUpgrade()
    end
end

local function createNodeView(parent, node)
    local size = nodeDisplaySize(node)
    local holder = GUI:Node_Create(parent, "holder_" .. node.id, node.x, node.y)
    local halo = GUI:Node_Create(holder, "halo", 0, 0)
    -- local halo = panel(holder, "halo", 0, 0, size + 10, size + 10, nodeColor(node))
    GUI:setLocalZOrder(halo, 1)
    if shouldShowNodeFrame(node) then
        imageFrame(holder, "archive_frame", 0, 0, size + 16, size + 16, NODE_FRAME, 2)
    end
    local rootBack
    if node.kind == "root" then
        rootBack = GUI:Image_Create(holder, "root_back", 0, 0, NODE_ROOT_BACK)
        if valid(rootBack) then
            GUI:setAnchorPoint(rootBack, 0.5, 0.5)
            GUI:setContentSize(rootBack, NODE_ROOT_BACK_SIZE, NODE_ROOT_BACK_SIZE)
            GUI:setLocalZOrder(rootBack, 99)
        end
    end
    local activeBack = GUI:Image_Create(holder, "active_back", 0, 0, NODE_ACTIVE_BACK)
    if valid(activeBack) then
        GUI:setAnchorPoint(activeBack, 0.5, 0.5)
        GUI:setLocalZOrder(activeBack, 2)
        GUI:setVisible(activeBack, false)
        GUI:setContentSize(activeBack, 78, 78)
    end
    local skin = nodeButtonSkin(node)
    local btn = GUI:Button_Create(holder, "button", 0, 0, skin)
    GUI:Button_loadTexturePressed(btn, skin)
    GUI:setAnchorPoint(btn, 0.5, 0.5)
    if node.kind == "root" or isSocketNode(node) then
        GUI:setContentSize(btn, size, size)
    end
    GUI:setLocalZOrder(btn, 3)
    GUI:addOnClickEvent(btn, function()
        selectNode(node.id)
    end)
    GUI:setTouchEnabled(btn, true)
    -- The viewport owns drag gestures. Keeping a second drag listener on each
    -- node causes short taps to compete with the button click callback.
    GUI:setSwallowTouches(btn, false)
    local label = text(holder, "label", 0, -size / 2 - 15, 18, nodeColor(node), node.name, 0.5, 1)
    GUI:setLocalZOrder(label, 6)
    local dot = text(btn, "state", size / 2, -6, 18, COLORS.green, "", 0.5, 0.5)
    GUI:setLocalZOrder(dot, 5)
    npc.nodeViews[node.id] = {
        holder = holder,
        halo = halo,
        rootBack = rootBack,
        activeBack = activeBack,
        button = btn,
        skin = skin,
        lines = npc.lineViews and npc.lineViews[node.id] or {},
    }
    refreshNodeSocketGem(node.id)
end

local function createTree()
    local sw = n(cogin and cogin.w, 1280)
    local sh = n(cogin and cogin.h, 720)
    local layoutNodes, layoutNodeMap = buildTreeLayout()
    -- The tree is the full-screen map; the detail panel is a floating overlay.
    local treeW = sw
    local treeH = sh
    local treeX = 0
    npc.treeX = treeX
    npc.treeViewW = treeW
    npc.treeViewH = treeH
    npc.treeBounds = calculateTreeBounds()
    npc.treeFrame = imageFrame(npc.window, "tree_frame", treeX, 0, treeW + 8, treeH + 8, RES .. "tj_31.png", 2)
    local viewport = GUI:Layout_Create(npc.window, "tree_viewport", treeX, 0, treeW, treeH, true)
    GUI:setAnchorPoint(viewport, 0.5, 0.5)
    -- GUI:Layout_setBackGroundColorType(viewport, 1)
    -- GUI:Layout_setBackGroundColor(viewport, "#110B08")
    -- GUI:Layout_setBackGroundColorOpacity(viewport, 135)
    GUI:setLocalZOrder(viewport, 3)
    GUI:Layout_setClippingEnabled(viewport, true)
    npc.treeScroll = viewport
    npc.treeCanvas = GUI:Node_Create(viewport, "tree_canvas", 0, 0)
    npc.nodeViews = {}
    npc.lineViews = {}
    createTreeDecorations(npc.treeCanvas)
    GUI:setTouchEnabled(viewport, true)
    GUI:setSwallowTouches(viewport, false)
    GUI:addOnTouchEvent(viewport, function(sender, eventType)
        if eventType == SLDefine.TouchEventType.began then
            beginTreeGesture(sender)
        elseif eventType == SLDefine.TouchEventType.moved then
            moveTreeGesture(sender)
        elseif eventType == SLDefine.TouchEventType.ended
            or eventType == SLDefine.TouchEventType.canceled then
            endTreeGesture(sender)
        end
    end)
    for _, node in ipairs(layoutNodes or {}) do
        for _, requiredId in ipairs(node.requires or {}) do
            local required = layoutNodeMap and layoutNodeMap[requiredId]
            if required then
                drawLine(npc.treeCanvas, "line_" .. node.id .. "_" .. requiredId, required, node)
                local line = GUI:getChildByName(npc.treeCanvas, "line_" .. node.id .. "_" .. requiredId)
                npc.lineViews[node.id] = npc.lineViews[node.id] or {}
                npc.lineViews[node.id][#npc.lineViews[node.id] + 1] = line
            end
        end
        for _, requiredId in ipairs(node.requires_any or {}) do
            local required = layoutNodeMap and layoutNodeMap[requiredId]
            if required then
                drawLine(npc.treeCanvas, "line_" .. node.id .. "_any_" .. requiredId, required, node)
                local line = GUI:getChildByName(npc.treeCanvas, "line_" .. node.id .. "_any_" .. requiredId)
                npc.lineViews[node.id] = npc.lineViews[node.id] or {}
                npc.lineViews[node.id][#npc.lineViews[node.id] + 1] = line
            end
        end
    end
    for _, node in ipairs(layoutNodes or {}) do
        createNodeView(npc.treeCanvas, node)
    end
    GUI:setScale(npc.treeCanvas, DEFAULT_ZOOM)
    npc.zoom = DEFAULT_ZOOM
    centerTreeCanvas()
    setZoom(DEFAULT_ZOOM)
end

local function openRules()
    local sw = n(cogin and cogin.w, 1280)
    local sh = n(cogin and cogin.h, 720)
    local boxW = math.min(620, sw - 40)
    local boxH = math.min(480, sh - 60)
    local boxX = math.max(0, sw / 2 - boxW / 2 - 20)
    npc.rulesWindow = createModalWindow("npc_22_rules_window")
    local mask = GUI:Image_Create(npc.rulesWindow, "mask", 0, 0, "res/public/1900000651_1.png")
    GUI:setAnchorPoint(mask, 0.5, 0.5)
    GUI:setContentSize(mask, sw + 100, sh + 100)
    GUI:setLocalZOrder(mask, 0)
    GUI:setTouchEnabled(mask, true)
    npc.rulesBox = GUI:Image_Create(npc.rulesWindow, "rules_box", 0, 0, PANEL_FRAME)
    GUI:setAnchorPoint(npc.rulesBox, 0.5, 0.5)
    GUI:setContentSize(npc.rulesBox, boxW, boxH)
    GUI:setLocalZOrder(npc.rulesBox, 10)
    GUI:setTouchEnabled(npc.rulesBox, true)
    GUI:setSwallowTouches(npc.rulesBox, true)
    local bigkuang = GUI:Image_Create(npc.rulesWindow, "bigkuang", 0, 0, "res/wy/public/box.png")
    GUI:setAnchorPoint(bigkuang, 0.5, 0.5)
    GUI:setContentSize(bigkuang, boxW + 4, boxH + 4)
    GUI:setLocalZOrder(bigkuang, 99)

    local box = npc.rulesBox
    local boxTop = boxH / 2
    local rulesLine = GUI:Image_Create(box, "rules_line", boxW / 2, boxH - 100, RES .. "tj_12.png")
    GUI:setAnchorPoint(rulesLine, 0.5, 0.5)
    GUI:setContentSize(rulesLine, math.max(260, boxW - 40), 12)
    GUI:setLocalZOrder(rulesLine, 3)
    local title = text(box, "rules_title", boxW / 2, boxH - 30, 28, "#F1D176", "天赋树规则", 0.5, 1)
    GUI:setLocalZOrder(title, 4)
    local rules = table.concat({
        "1. 五行主干从中心向外展开，主干节点可继续分出两条外扩支路。",
        "2. 小点提供固定属性，中点提供更高属性，大点提供特殊技能或机制效果。",
        "3. 点亮节点需要天赋点，并同时消耗服务端配置的货币与材料。",
        "4. 退点只能从末端节点开始；洗点会返还已消耗的天赋点、货币与材料。",
        "5. 每个灵根分支最多激活40点，侧枝最多激活6点；同一流派只能选择一条路线。",
        "6. 天赋点上限210点，核心最多40级；核心升级可获得33点，其他系统预留7点。",
        "7. 节点按连接关系判断，任意相连节点已激活即可从任意方向点亮。",
        "8. 跨系通道节点不消耗天赋点，但必须满足核心等级和相连节点条件。",
        "9. 五行相克共振：攻击怪物额外忽视30%防御，攻击玩家忽视5%防御；自身受到所有伤害提高20%。",
    }, "<br/>")
    local desc = GUI:RichText_Create(box, "rules_desc", boxW / 2, boxTop, rules,
        math.max(220, boxW - 40), 17, "#E5D8B8", 0, nil, nil, {outlineSize = 1, outlineColor = "#000000"})
    GUI:setAnchorPoint(desc, 0.5, 0.5)
    GUI:setLocalZOrder(desc, 4)
    local closeTop = button(box, "rules_close_top", boxW - 48, boxH - 30, "", function()
        closeModalWindow("npc_22_rules_window")
        setMainTreeVisible(true)
    end, 60, 54,"res/wy/public/gjyj_x.png")
    GUI:setLocalZOrder(closeTop, 6)
    -- local close = button(box, "rules_close", 0, -boxTop + 28, "返回天赋树", function()
    --     closeModalWindow("npc_22_rules_window")
    -- end, 150, 42)
    -- GUI:setLocalZOrder(close, 5)
end

openUpgrade = function()
    local sw = n(cogin and cogin.w, 1280)
    local sh = n(cogin and cogin.h, 720)
    local boxW = UPGRADE_BOX_W
    local boxH = UPGRADE_BOX_H
    npc.upgradeWindow = createModalWindow("npc_22_upgrade_window")
    local mask = GUI:Image_Create(npc.upgradeWindow, "mask", 0, 0, "res/public/1900000651_1.png")
    GUI:setAnchorPoint(mask, 0.5, 0.5)
    GUI:setContentSize(mask, sw + 100, sh + 100)
    GUI:setLocalZOrder(mask, 0)
    GUI:setTouchEnabled(mask, true)
    npc.upgradeBox = GUI:Image_Create(npc.upgradeWindow, "upgrade_box", 0, 0, UPGRADE_BG)
    GUI:setAnchorPoint(npc.upgradeBox, 0.5, 0.5)
    GUI:setLocalZOrder(npc.upgradeBox, 10)
    GUI:setTouchEnabled(npc.upgradeBox, true)
    GUI:setSwallowTouches(npc.upgradeBox, true)
    local box = npc.upgradeBox
    local boxTop = boxH / 2
    local closeTop = button(box, "upgrade_close_top", boxW / 2 - 34 + 282, boxTop - 30 + 172, "", function()
        closeModalWindow("npc_22_upgrade_window")
        setMainTreeVisible(true)
    end, 60, 54,"res/wy/public/gjyj_x.png")
    GUI:setLocalZOrder(closeTop, 6)
    local upgrade = GUI:Button_Create(box, "upgrade_core", UPGRADE_RIGHT_X, UPGRADE_BUTTON_Y, UPGRADE_BUTTON)
    GUI:Button_loadTexturePressed(upgrade, UPGRADE_BUTTON)
    GUI:setAnchorPoint(upgrade, 0.5, 0.5)
    GUI:addOnClickEvent(upgrade, function()
        if not (TreeCfg.core_level_map and TreeCfg.core_level_map[n(npc.state.core_level) + 1]) then
            return
        end
        SL:SendLuaNetMsg(100, 22, 6, 0, "")
    end)
    GUI:setLocalZOrder(upgrade, 5)
    refreshUpgradeInfo()
    tryStartMainlineCoreUpgradeGuide()
end

local function createHeader(sw, sh)
    -- The header is a top overlay, not a bottom status bar. Keep its children
    -- in the header's local coordinate system so the layout remains stable.
    local headerW = math.max(720, sw - 36)
    local headerH = 82
    npc.header = GUI:Node_Create(npc.window, "header",  - cogin.w/2, cogin.h/2)
    GUI:setLocalZOrder(npc.header, 10)
    local headerLine = GUI:Image_Create(npc.header, "header_line", 0, 0, RES .. "tj_23.png")
    GUI:setAnchorPoint(headerLine, 0, 1)
    GUI:setContentSize(headerLine, cogin.w, 80)

    -- local rootIcon = panel(npc.header, "root_icon", -headerW / 2 + 48, 0, 50, 50, "#14263A")
    -- GUI:setLocalZOrder(rootIcon, 3)
    -- local rootRing = GUI:Image_Create(rootIcon, "root_ring", 0, 0, RES .. "tj_14.png")
    -- GUI:setAnchorPoint(rootRing, 0.5, 0.5)
    -- GUI:setContentSize(rootRing, 50, 16)
    -- GUI:setRotation(rootRing, 90)
    -- text(rootIcon, "root_text", 0, 0, 23, "#F1D176", "根", 0.5, 0.5)

    -- local mark = GUI:Image_Create(npc.header, "brand_mark", brandX, layout.topY, "res/wy/public/itembg.png")
    -- GUI:setAnchorPoint(mark, 0.5, 0.5)
    -- GUI:setContentSize(mark, 50, 50)
    -- text(root, "brand_mark_text", brandX, layout.topY, 40, GOLD, "鉴", 0.5, 0.5)
    -- text(root, "brand_title", brandTextX, layout.topY, 30, GOLD, "万象图鉴", 0, 0.5)

    local leftX = 10
    text(npc.header, "title", leftX, -30, 25, "#F1D176", "灵根天赋树", 0, 0.5)
    text(npc.header, "subtitle", leftX, -60, 20, "#8FA6C0",
        "五行共振 · 主干成长 · 流派分支 · 宝石镶嵌", 0, 0.5)

    local pointsX = headerW / 2 + 150 + 50
    local pointsBg = imageFrame(npc.header, "points_bg", pointsX + 115, -46, 286, 58, RES .. "tj_19.png", 3)
    if valid(pointsBg) then
        GUI:setOpacity(pointsBg, 235)
    end
    -- local pointsLine = GUI:Image_Create(npc.header, "points_line", pointsX + 115, -46, RES .. "tj_12.png")
    -- if valid(pointsLine) then
    --     GUI:setAnchorPoint(pointsLine, 0.5, 0.5)
    --     GUI:setContentSize(pointsLine, 112, 3)
    --     GUI:setRotation(pointsLine, 90)
    --     GUI:setOpacity(pointsLine, 125)
    --     GUI:setLocalZOrder(pointsLine, 4)
    -- end
    local remainLabel = text(npc.header, "points_remaining_label", pointsX + 54, -36, 20, "#9FB4C8", "剩余天赋", 0.5, 0.5)
    local remainValue = text(npc.header, "points_remaining_value", pointsX + 54, -58, 22, "#7CFFAE", "0", 0.5, 0.5)
    local usedLabel = text(npc.header, "points_used_label", pointsX + 176, -36, 20, "#9FB4C8", "已用天赋", 0.5, 0.5)
    local usedValue = text(npc.header, "points_used_value", pointsX + 176, -58, 22, "#F4D17A", "0", 0.5, 0.5)
    GUI:setLocalZOrder(remainLabel, 5)
    GUI:setLocalZOrder(remainValue, 5)
    GUI:setLocalZOrder(usedLabel, 5)
    GUI:setLocalZOrder(usedValue, 5)
    refreshTalentPointsText()
    local upgrade = button(npc.header, "upgrade", 75, -100 - 10, "  升级核心", openUpgrade, 150, 50,"res/custom/linggen/new/main/itme3.png")
    local rules = button(npc.header, "rules",75, -150 - 10, "  查看规则", openRules, 150, 50,"res/custom/linggen/new/main/itme3.png")
    local reset = button(npc.header, "reset", 75, -200 - 10, "  重置灵根", function()
        openResetConfirm("all")
    end, 150, 50,"res/custom/linggen/new/main/itme3.png")

    -- dev/res/custom/tj/redo.png dev/res/custom/tj/align-right.png dev/res/custom/tj/angle-double-up.png
    GUI:setContentSize(GUI:Image_Create(upgrade, "upgrade_icon", 13, 15, RES .. "angle-double-up.png"), 20, 20)
    GUI:setContentSize(GUI:Image_Create(rules, "rules_icon", 13, 15, RES .. "align-right.png"), 20, 20)
    GUI:setContentSize(GUI:Image_Create(reset, "reset_icon", 13, 15, RES .. "redo.png"), 20, 20)
    GUI:Button_setTitleFontSize(upgrade, 22)
    GUI:Button_setTitleFontSize(rules, 22)
    GUI:Button_setTitleFontSize(reset, 22)
    button(npc.header, "close", headerW - 20, -50, "", function()
        local win = GUI:GetWindow(nil, ROOT_NAME)
        if win then
            GUI:Win_Close(win)
        end
    end, 60, 54,"res/wy/public/gjyj_x.png")
end

local function createInfoPanel(sw, sh)
    npc.infoW = 250
    npc.infoH = math.min(570, math.max(430, sh - 126))
    npc.infoDescW = math.max(205, npc.infoW - 48)

    -- The detail panel belongs to the main talent-tree window. Close any
    -- leftover window created by an older version before rebuilding it.
    local infoWindowName = "npc_22_info_window"
    local oldWindow = GUI:GetWindow(nil, infoWindowName)
    if oldWindow then
        GUI:Win_Close(oldWindow)
    end
    npc.infoWindow = nil

    -- npc.window is centered at the screen center, so this is a local
    -- right-side offset rather than a screen-space coordinate.
    local panelX = sw / 2 - npc.infoW / 2
    local panelY = -10

    npc.infoPanel = GUI:Image_Create(npc.window, "side_bg", panelX, cogin.h/2 - 80, RES .. "kk_bg.png")
    GUI:setAnchorPoint(npc.infoPanel, 0.5, 1)
    GUI:setContentSize(npc.infoPanel, npc.infoW, npc.infoH)
    GUI:setLocalZOrder(npc.infoPanel, 11)
    GUI:setTouchEnabled(npc.infoPanel, true)
    npc.infoPanelOpenX = panelX


    local bigkuang = GUI:Image_Create(npc.window, "bigkuang", panelX, cogin.h/2 - 80, "res/wy/public/box.png")
    GUI:setAnchorPoint(bigkuang, 0.5, 1)
    GUI:setContentSize(bigkuang, npc.infoW + 4, npc.infoH + 4)
    GUI:setLocalZOrder(bigkuang, 99)
    npc.infoFrame = bigkuang
    npc.infoPanelClosedX = sw / 2 + npc.infoW / 2 + 12

    local panelTop = npc.infoH
    local contentX = 20
    local contentRight = panelY - 20


    text(npc.infoPanel, "info_title", npc.infoW / 2, panelTop - 10, 22, "#F1D176", "天赋预览", 0.5, 1)
    local titleLine = GUI:Image_Create(npc.infoPanel, "info_title_line", npc.infoW / 2, panelTop - 34, RES .. "tj_12.png")
    if valid(titleLine) then
        GUI:setAnchorPoint(titleLine, 0.5, 0.5)
        GUI:setContentSize(titleLine, npc.infoW - 56, 3)
        GUI:setOpacity(titleLine, 150)
        GUI:setLocalZOrder(titleLine, 2)
    end
    text(npc.infoPanel, "node_status", npc.infoW - 10 , panelTop - 40, 20, COLORS.green, "", 1, 1)
    text(npc.infoPanel, "node_title", 10, panelTop - 40, 20, "#E8F1FF", "", 0, 1)
    text(npc.infoPanel, "info_effect_title", 10, panelTop - 90, 20, "#F1D176", "天赋效果", 0, 0.5)

    local descScroll = GUI:ScrollView_Create(npc.infoPanel, "node_desc_scroll", 10, 65,
        npc.infoDescW, panelTop - 165, 1)
    GUI:setAnchorPoint(descScroll, 0, 0)
    GUI:ScrollView_setClippingEnabled(descScroll, true)
    GUI:ScrollView_setBounceEnabled(descScroll, false)
    GUI:setTouchEnabled(descScroll, true)
    GUI:setSwallowTouches(descScroll, true)
    npc.infoDescId = nil
    npc.infoDescHtml = nil

    -- text(npc.infoPanel, "synergy_title", 10, panelTop - 354, 30, "#F1D176", "相生相克", 0, 0.5)
    -- local synergy = GUI:RichText_Create(npc.infoPanel, "synergy_desc", 10, panelTop - 378,
    --     "<font color='#FFB79E'>金克木：金系节点越深，木系回复效果越弱。</font>",
    --     npc.infoDescW, 14, "#E5D8B8", 0, nil, nil, {outlineSize = 1, outlineColor = "#000000"})
    -- GUI:setAnchorPoint(synergy, 0, 1)
    -- text(npc.infoPanel, "hint_title", 10, panelTop - 300, 15, "#F1D176", "构筑提示", 0, 0.5)
    -- local hint = GUI:RichText_Create(npc.infoPanel, "hint_desc", 10, -panelTop + 118,
    --     "主干节点默认按前置顺序点亮，宝石槽与技能强化节点会在外圈逐步解锁。",
    --     npc.infoDescW, 14, "#AAB5C8", 0, nil, nil, {outlineSize = 1, outlineColor = "#000000"})
    -- GUI:setAnchorPoint(hint, 0, 1)
    local actionY = 30
    local actionX = npc.infoW >= 300 and -90 or 0
    local ruleX = npc.infoW/2
    local actionLine = GUI:Image_Create(npc.infoPanel, "info_action_line", npc.infoW / 2, actionY + 38, RES .. "tj_12.png")
    if valid(actionLine) then
        GUI:setAnchorPoint(actionLine, 0.5, 0.5)
        GUI:setContentSize(actionLine, npc.infoW - 48, 3)
        GUI:setOpacity(actionLine, 115)
        GUI:setLocalZOrder(actionLine, 2)
    end
    local action = button(npc.infoPanel, "node_action", ruleX - 60, actionY, "点亮", function()
        local node = TreeCfg.node_map and TreeCfg.node_map[npc.selectedId or "root"]
        if not node then
            return
        end
        if node.kind == "root" then
            openUpgrade()
        elseif isSocketNode(node) and stateActive(node.id) then
            openGemWindow()
        elseif stateActive(node.id) then
            openResetConfirm("single")
        else
            local other = conflictingM1(node)
            if other then
                openResetConfirm("switch_m1")
                return
            end
            local socketName = getUnfilledSocketPrerequisite(node)
            if socketName then
                SL:ShowSystemTips("请先在" .. socketName .. "镶嵌宝石")
                return
            end
            SL:SendLuaNetMsg(100, 22, 1, 0, SL:JsonEncode({id = node.id}, false))
        end
    end, 90, 40)
    GUI:setLocalZOrder(action, 5)
    -- local rule = button(npc.infoPanel, "info_rule", ruleX + 60, actionY, "查看规则", openRules,
    --      90, 40)
    -- GUI:setLocalZOrder(rule, 5)

end

local function createWindow()
    closeOverlappedBaseWindows()

    local sw = n(cogin and cogin.w, 1280)
    local sh = n(cogin and cogin.h, 720)
    local win = GUI:GetWindow(nil, ROOT_NAME)
    if win then
        GUI:removeAllChildren(win)
        GUI:setPosition(win, sw / 2, sh / 2)
    else
        win = GUI:Win_Create(ROOT_NAME, sw / 2, sh / 2, 0, 0, false, false, true, true, true, 22, 999)
    end
    npc.window = win
    local mask = panel(win, "mask", 0, 0, sw + 80, sh + 80, "#080A0F")
    npc.mask = mask
    -- GUI:Layout_setBackGroundColorOpacity(mask, 238)
    GUI:setTouchEnabled(mask, true)
    local bg = GUI:Image_Create(win, "bg", 0, -5, "res/custom/tj/tj_31.png")
    npc.bg = bg
    GUI:setAnchorPoint(bg, 0.5, 0.5)
    GUI:setContentSize(bg, sw + 20, sh + 20)
    GUI:setLocalZOrder(bg, 1)
    GUI:addMouseOverTips(bg, "", {x = 0, y = 0}, {x = 0, y = 0})
    GUI:setLocalZOrder(mask, 0)
    createHeader(sw, sh)
    createInfoPanel(sw, sh)
    createZoomControl(sw, sh)
    createTree()
    npc.selectedId = nil
    updateAllNodeVisuals()
    setInfoDrawer(false, false)
    SL:ScheduleOnce(function()
        tryStartMainlineTalentGuides()
    end, 0)
end

function npc.main(npcid, p2, p3, msgData)
    local payload = decode(msgData)
    if p2 == 0 then
        npc.state = applyClientConfigDefaults(payload)
        createWindow()
        return
    end
    if not valid(npc.window) then
        npc.state = applyClientConfigDefaults(payload.payload or payload)
        createWindow()
        return
    end
    refreshPayload(payload)
    scheduleMainlineGuideSync()
end

return npc
