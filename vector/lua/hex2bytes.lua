function hex2bytes(hex_string)
    local data = ''
    for i = 1, #hex_string, 2 do
        local byte_str = hex_string:sub(i, i + 1)
        local byte_val = tonumber(byte_str, 16)
        if byte_val then
            data = data .. string.char(byte_val)
        else
            -- Handle invalid hex characters
            return nil, "Invalid hex character at position " .. i
        end
    end
    return data
end
