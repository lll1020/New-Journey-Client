Time = {}

local start = os.time({ year = 2001, month = 1, day = 1, hour = 0, min = 0, sec = 0 })
-- 获取当前日期
function Time.today()
    local d = os.date("*t")
    return os.time({ year = d.year, month = d.month, day = d.day, hour = 0, min = 0, sec = 0 })
end

-- 获取当前时间
function Time.now()
    return os.date()
end

function Time.utcTime()
    return os.time()
end

-- 将时间戳转换为日期时间
function Time.format(timestamp, format)
    return os.date(format, timestamp)
end

-- 将日期时间字符串转换为时间戳
function Time.totimestamp(Timestr, format)
    local pattern = format or "%Y-%m-%d %H:%M:%S"
    local t = os.date(pattern, start)
    local y, m, d, h, min, s = string.match(Timestr, "(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+)")
    if y and m and d and h and min and s then
        t.year = y
        t.month = m
        t.day = d
        t.hour = h
        t.min = min
        t.sec = s
    end
    return os.time(t)
end

-- 日期加减，支持加减年月日时分秒
function Time.add(Timestr, years, months, days, hours, mins, secs, format)
    local pattern = format or "%Y-%m-%d %H:%M:%S"
    local timestamp = Time.totimestamp(Timestr, pattern)
    local t = os.Time("*t", timestamp)
    if years then
        t.year = t.year + years
    end
    if months then
        t.month = t.month + months
    end
    if days then
        t.day = t.day + days
    end
    if hours then
        t.hour = t.hour + hours
    end
    if mins then
        t.min = t.min + mins
    end
    if secs then
        t.sec = t.sec + secs
    end
    return os.Time(pattern, os.time(t))
end

-- 比较两个日期大小，支持年月日时分秒比较
-- 返回值：1 表示 Time1 > Time2，0 表示 Time1 = Time2，-1 表示 Time1 < Time2
function Time.compare(Time1, Time2, format)
    local pattern = format or "%Y-%m-%d %H:%M:%S"
    local timestamp1 = Time.totimestamp(Time1, pattern)
    local timestamp2 = Time.totimestamp(Time2, pattern)
    if timestamp1 > timestamp2 then
        return 1
    elseif timestamp1 == timestamp2 then
        return 0
    else
        return -1
    end
end

function Time.getDays()
    return os.difftime(Time.today(), start) / (24 * 60 * 60)
end

---获取当前周几 从 1 开始计数
function Time.dayInWeek()
    local weekday = tonumber(os.date("%w"))
    -- 转换为从周一开始的星期编号
    return (weekday + 6) % 7 + 1
end

function Time.getNextDayStart()
    local now = os.time()
    local nextDay = now + 24 * 60 * 60
    local nextDayFirstDay = os.date("*t", nextDay)
    local nextDayFirstDayZero = os.time({
        year = nextDayFirstDay.year,
        month = nextDayFirstDay.month,
        day = nextDayFirstDay.day,
        hour = 0,
        minute = 0,
        second = 0,
    })
    return nextDayFirstDayZero
end

function Time.getNextWeekStart()
    local now = os.time()
    local nextWeek = now + 7 * 24 * 60 * 60
    local nextWeekFirstDay = os.date("*t", nextWeek)
    local nextWeekFirstDayZero = os.time({
        year = nextWeekFirstDay.year,
        month = nextWeekFirstDay.month,
        day = nextWeekFirstDay.day,
        hour = 0,
        minute = 0,
        second = 0,
    })
    return nextWeekFirstDayZero
end

return Time
