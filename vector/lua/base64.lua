local base64_chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"

function base64_encode(data)
    local result = {}
    local i = 1
    while i <= #data do
        local b1 = data:byte(i)
        local b2 = data:byte(i + 1) or 0
        local b3 = data:byte(i + 2) or 0

        local char1 = base64_chars:sub(math.floor(b1 / 4) + 1, math.floor(b1 / 4) + 1)
        local char2 = base64_chars:sub(((b1 % 4) * 16) + math.floor(b2 / 16) + 1, ((b1 % 4) * 16) + math.floor(b2 / 16) + 1)
        local char3 = base64_chars:sub(((b2 % 16) * 4) + math.floor(b3 / 64) + 1, ((b2 % 16) * 4) + math.floor(b3 / 64) + 1)
        local char4 = base64_chars:sub((b3 % 64) + 1, (b3 % 64) + 1)

        table.insert(result, char1)
        table.insert(result, char2)
        table.insert(result, char3)
        table.insert(result, char4)

        i = i + 3
    end

    -- Handle padding
    local padding_needed = (#data % 3)
    if padding_needed == 1 then
        result[#result] = "="
        result[#result - 1] = "="
    elseif padding_needed == 2 then
        result[#result] = "="
    end

    return table.concat(result)
end
