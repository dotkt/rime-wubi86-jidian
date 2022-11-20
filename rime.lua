--- 过滤器：单字在先
function single_char_first_filter(input)
    local l = {}
    for cand in input:iter() do
        if (utf8.len(cand.text) == 1) then
            yield(cand)
        else
            table.insert(l, cand)
        end
    end
    for cand in ipairs(l) do
        yield(cand)
    end
end

--- 计算器
--- @KyleBing 2022-01-17
function calculator(input, seg)
    if string.find(input, 'coco') ~= nil then -- 匹配 coco 开头的字符串
        local _, _, a, operation, b = string.find(input, "coco(%d+%.?%d*)([%+%-%*/])(%d+%.?%d*)")
        local result = 0
        if operation == '+' then
            result = a + b
        elseif operation == '-' then
            result = a - b
        elseif operation == '*' then
            result = a * b
        elseif operation == '/' then
            result = a / b
        end
        yield(Candidate("coco", seg.start, seg._end, result, "计算器"))
    end
end


function date_translator(input, seg)

    -- 日期格式说明：

    -- %a	abbreviated weekday name (e.g., Wed)
    -- %A	full weekday name (e.g., Wednesday)
    -- %b	abbreviated month name (e.g., Sep)
    -- %B	full month name (e.g., September)
    -- %c	date and time (e.g., 09/16/98 23:48:10)
    -- %d	day of the month (16) [01-31]
    -- %H	hour, using a 24-hour clock (23) [00-23]
    -- %I	hour, using a 12-hour clock (11) [01-12]
    -- %M	minute (48) [00-59]
    -- %m	month (09) [01-12]
    -- %p	either "am" or "pm" (pm)
    -- %S	second (10) [00-61]
    -- %w	weekday (3) [0-6 = Sunday-Saturday]
    -- %x	date (e.g., 09/16/98)
    -- %X	time (e.g., 23:48:10)
    -- %Y	full year (1998)
    -- %y	two-digit year (98) [00-99]
    -- %%	the character `%´

    -- 输入完整日期
    -- if (input == "datetime") then
        -- yield(Candidate("date", seg.start, seg._end, os.date("%Y-%m-%d %H:%M:%S"), ""))
    -- end

    -- 输入日期
    if (input == "date") then
        --- Candidate(type, start, end, text, comment)
        yield(Candidate("date", seg.start, seg._end, os.date("%Y-%m-%d"), ""))
        yield(Candidate("date", seg.start, seg._end, os.date("🛫 %Y-%m-%d 📅 %Y-%m-%d"), ""))
        yield(Candidate("date", seg.start, seg._end, os.date("%Y年%m月%d日"), ""))
        yield(Candidate("date", seg.start, seg._end, os.date("## %Y-%m-%d"), ""))
        yield(Candidate("date", seg.start, seg._end, os.date("✅ %Y-%m-%d"), ""))
        yield(Candidate("date", seg.start, seg._end, os.date("%m-%d-%Y"), ""))
        -- 📅 2022-10-06
        -- 🛫 2022-10-12 
    end

    -- 输入日期
    if (input == "todo") then
        --- Candidate(type, start, end, text, comment)
        yield(Candidate("todo", seg.start, seg._end, os.date("- [ ] "), ""))
        yield(Candidate("todo", seg.start, seg._end, os.date("- [ ] #todo "), ""))
        yield(Candidate("todo", seg.start, seg._end, os.date("#todo "), ""))
        yield(Candidate("todo", seg.start, seg._end, os.date("🛫 %Y-%m-%d 📅 %Y-%m-%d  "), ""))
        yield(Candidate("todo", seg.start, seg._end, os.date("- [ ] #todo 🛫 %Y-%m-%d 📅 %Y-%m-%d  "), ""))
        -- 📅 2022-10-06
        -- 🛫 2022-10-12 
    end

    -- 输入时间
    if (input == "time") then
        --- Candidate(type, start, end, text, comment)
		yield(Candidate("date", seg.start, seg._end, os.date("%Y-%m-%d %H:%M:%S"), ""))
        yield(Candidate("date", seg.start, seg._end, os.date("%Y-%m-%d %H-%M-%S"), ""))
        yield(Candidate("time", seg.start, seg._end, os.date("%H:%M"), ""))
        yield(Candidate("time", seg.start, seg._end, os.date("%Y%m%d%H%M%S"), ""))
        yield(Candidate("time", seg.start, seg._end, os.date("%H:%M:%S"), ""))
    end

    -- 输入星期
    -- -- @JiandanDream
    -- -- https://github.com/KyleBing/rime-wubi86-jidian/issues/54
    if (input == "week") then
        local weakTab = {'日', '一', '二', '三', '四', '五', '六'}
        yield(Candidate("week", seg.start, seg._end, "周"..weakTab[tonumber(os.date("%w")+1)], ""))
        yield(Candidate("week", seg.start, seg._end, "星期"..weakTab[tonumber(os.date("%w")+1)], ""))
        yield(Candidate("week", seg.start, seg._end, os.date("%A"), ""))
        yield(Candidate("week", seg.start, seg._end, os.date("%a"), "缩写"))
    end

    -- 输入月份英文
    if (input == "month") then
        yield(Candidate("month", seg.start, seg._end, os.date("%B"), ""))
        yield(Candidate("month", seg.start, seg._end, os.date("%b"), "缩写"))
    end
end


