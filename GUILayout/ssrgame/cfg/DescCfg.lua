local ssrDescCfg = {}

ssrDescCfg.dir = {
    T   = {anchor={0.5, 1}, offset={x=0, y=-5}},        --上中
    B   = {anchor={0.5, 0}, offset={x=0, y=5}},         --下中
    L   = {anchor={0, 0.5}, offset={x=5, y=0}},         --左中
    R   = {anchor={1, 0.5}, offset={x=-5, y=0}},        --右中
    LT  = {anchor={0, 1},   offset={x=5, y=-5}},        --左上
    RT  = {anchor={1, 1},   offset={x=-5, y=-5}},       --右上
    LB  = {anchor={0, 0},   offset={x=5, y=5}},         --左下
    RB  = {anchor={1, 0},   offset={x=-5, y=5}},        --右下
}

return ssrDescCfg