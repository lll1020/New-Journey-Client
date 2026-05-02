local ssrDescCfg = {}

ssrDescCfg.dir = {
    T   = {anchor={0.5, 1}, offset={x=0, y=-5}},        --涓婁腑
    B   = {anchor={0.5, 0}, offset={x=0, y=5}},         --涓嬩腑
    L   = {anchor={0, 0.5}, offset={x=5, y=0}},         --宸︿腑
    R   = {anchor={1, 0.5}, offset={x=-5, y=0}},        --鍙充腑
    LT  = {anchor={0, 1},   offset={x=5, y=-5}},        --宸︿笂
    RT  = {anchor={1, 1},   offset={x=-5, y=-5}},       --鍙充笂
    LB  = {anchor={0, 0},   offset={x=5, y=5}},         --宸︿笅
    RB  = {anchor={1, 0},   offset={x=-5, y=5}},        --鍙充笅
}

return ssrDescCfg