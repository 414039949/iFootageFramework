local hex = {}

function hex.dump(buf)
  for byte=1, #buf, 16 do
    local chunk = buf:sub(byte, byte+15)
    io.write(string.format('%08X  ',byte-1))
    chunk:gsub('.', function (c) io.write(string.format('%02X ',string.byte(c))) end)
    io.write(string.rep(' ',3*(16-#chunk)))
    io.write(' ',chunk:gsub('%c','.'),"\n") 
  end
end

function hex.checksum(strPkt)
    local cs = 0
    string.gsub(strPkt, "(.)", function(c) cs = cs + string.byte(c) end)
    return cs & 0xff
end

return hex
