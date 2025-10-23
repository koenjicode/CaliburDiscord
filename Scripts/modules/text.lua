-- helper.lua
local Text = {}

-- Checks if a string is fully uppercase (ignores spaces, dashes, and numbers)
function Text.IsAllUppercase(name)
    local letters_only = name:gsub("[^%a]", "")
    return letters_only:upper() == letters_only and #letters_only > 0
end

-- Reformat a text with proper capitalization:
function Text.FormatText(name)
    -- lowercase everything first
    local formatted = string.lower(name)

    -- capitalize the first letter of each word
    formatted = formatted:gsub("(%a)([%w_']*)", function(first, rest)
        return string.upper(first) .. rest
    end)

    -- handle names with hyphens (e.g., "Mi-na" not "Mi-Na")
    formatted = formatted:gsub("%-(%l)", function(letter)
        return "-" .. string.lower(letter)
    end)

    return formatted
end

return Text