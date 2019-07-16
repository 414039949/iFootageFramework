local hex = require "hex"
--[[

	send_0x00_S1发送参数(用于升级 导轨节数的变化)
	a = 时间戳	（一般发送当前时间戳）
	b = 版本号	（更新时所要发送的版本号）
	c = 0o r 1	（1代表着强制更新 也就是开启更新）
	d = 升级版本的字节数
    e = 导轨拼接节数
]]

function send_0x00_S1(a, b, c, d, e, f)
	local info = string.pack(">HbLbbIbb",0xaaaf, 0x00, a, b, c, d, e, f)
	local sum = hex.checksum(info)
	return info .. string.char(sum)
end
--[[
手动模式
u16 data[3-4] 导轨速度 v*10+500



u8 data[10]   1 
]]
function send_0x01_S1(a,b)
	
    local info = string.pack(">HbHbIbL", 0xaaaf, 0x01,a,0, 0,b, 0)
	local sum = hex.checksum(info)
	return info .. string.char(sum)
end

--[[
u8 data[3] 0  1  2   3  4   5

u32 data[4-7]时间戳高32
u32 data[8-11]时间戳低32 ms

u8 data[18]  是否循环运行 1循环
]]
function send_0x02_S1(a,b,c)
	local info = string.pack(">HbbLIHb", 0xaaaf, 0x02,a,b,0, 0,c)
	local sum = hex.checksum(info)
	return info .. string.char(sum)
end
--[[
	
u16 data[3-4] Interval 
u16 data[5-6]  Exposure
u32 data[7-10] Frames
u8 data[11]   Mode
u8 data[12]  NumBezier
u16 data[13-14] Buffer_second
]]
function send_0x03_S1(a,b,c,d,e,f)
	local info = string.pack(">HbHHIbbHI", 0xaaaf, 0x03,a,b,c,d, e, f,0)
	local sum = hex.checksum(info)
	return info .. string.char(sum)
end
--[[u32 data[3-6]  Time
u8 data[12]  NumBezier
]]
function send_0x04_S1(a,b)
	local info = string.pack(">HbIIbbIH", 0xaaaf, 0x04,a,0,0,b, 0, 0)
	local sum = hex.checksum(info)
	return info .. string.char(sum)
end

--[[
u8 data[3] 0  1  2   3  4

u32 data[4-7]时间戳高32
u32 data[8-11]时间戳低32 ms
u32 data[12-15] Frame_Need
u16 data[16-17] 单次时间-ms
]]
function send_0x05_S1(a,b,c,d)
	local info = string.pack(">HbbLIHb", 0xaaaf, 0x05,a,b,c,d,0)
	local sum = hex.checksum(info)
	return info .. string.char(sum)
end
--[[
	
u8 data[3] 功能  1预览  0待机
float data[4-7] slider位置
                 保留到0.1mm
]]
function send_0x06_S1(a,b)
	local info = string.pack(">HbbILHb", 0xaaaf, 0x06,a,b, 0, 0, 0)
	local sum = hex.checksum(info)
	return info .. string.char(sum)
end

--[[u8 data[3] 0 1 5 6  7
u16 data[4-5]Slider速度*100+5000

u32 data[6-9] Slider位置mm*100（A）
u32 data[10-13] Slider位置mm*100（B）

u16 data[17-18] 总运行时间 秒]]
function send_0x09_S1(a,b,c,d,e)
	local info = string.pack(">HbbHIIHbh", 0xaaaf, 0x09,a,b,c,d,0,0,e)
	local sum = hex.checksum(info)
	return info .. string.char(sum)
end

--[[
u8 data[3] 0 1 2 3 4 
u8 data[4] 方向 1.向左 2.向右 3 自处理方向
u8 data[5] 0 1 循环标志 1循环
u16 data[6-7]  总运行时间 秒
u8 data[8]   淡入淡出等级  0 1 2 3 

u64 data[11-18] 时间戳 64位 ms
]]
function send_0x0A_S1(a,b,c,d,e,f)
	local info = string.pack(">HbbbbHbHL", 0xaaaf, 0x0a,a,b,c,d,e,0,f)
	local sum = hex.checksum(info)
	return info .. string.char(sum)
end
--[[
	u64 data[3-10]  时间戳 ms64位
]]
function send_0x0B_S1(a)
	local info = string.pack(">HbLL", 0xaaaf, 0x0B,a,0)
	local sum = hex.checksum(info)
	return info .. string.char(sum)
end
--[[u8 data[3] 0 1 2 3 4


u16 data[7-8]导轨速度 v+500 mm/s]]
function send_0x0C_S1(a,b)
	local info = string.pack(">HbbHbHLH", 0xaaaf, 0x0C,a,0,0,b,0,0)
	local sum = hex.checksum(info)
	return info .. string.char(sum)
end
--[[
	u64 data[3-10]  时间戳 ms64位
]]
function send_0x24_S1(a)
	local info = string.pack(">HbLL", 0xaaaf, 0x24,a,0)
	local sum = hex.checksum(info)
	return info .. string.char(sum)
end
--[[
	发送导轨贝塞尔曲线参数
]]
function send_0xAx_S1(a,b,c,d,e)
  local info
  if (a== 0) then
    info  = string.pack(">HBIIII", 0xaaaf, 0xa0,b,c,d,e)
  elseif(a == 1) then
    info  = string.pack(">HBIIII", 0xaaaf, 0xa1,b,c,d,e) 	
  elseif(a == 2) then
    info  = string.pack(">HBIIII", 0xaaaf, 0xa2,b,c,d,e)
  elseif(a == 3) then
    info  = string.pack(">HBIIII", 0xaaaf, 0xa3,b,c,d,e)
  elseif(a == 4) then
    info  = string.pack(">HBIIII", 0xaaaf, 0xa4,b,c,d,e)
  elseif(a == 5) then
    info  = string.pack(">HBIIII", 0xaaaf, 0xa5,b,c,d,e)
  elseif(a == 6) then
    info  = string.pack(">HBIIII", 0xaaaf, 0xa6,b,c,d,e)
  elseif(a == 7) then
    info  = string.pack(">HBIIII", 0xaaaf, 0xa7,b,c,d,e)
  elseif(a == 8) then
    info  = string.pack(">HBIIII", 0xaaaf, 0xa8,b,c,d,e)
  elseif(a == 9) then
    info  = string.pack(">HBIIII", 0xaaaf, 0xa9,b,c,d,e)
  elseif(a == 10) then
    info  = string.pack(">HBIIII", 0xaaaf, 0xaA,b,c,d,e)
  elseif(a == 11) then
    info  = string.pack(">HBIIII", 0xaaaf, 0xab,b,c,d,e)
  elseif(a == 12) then
    info  = string.pack(">HBIIII", 0xaaaf, 0xac,b,c,d,e)
  elseif(a == 13) then
    info  = string.pack(">HBIIII", 0xaaaf, 0xad,b,c,d,e)
  elseif(a == 14) then
    info  = string.pack(">HBIIII", 0xaaaf, 0xae,b,c,d,e)
  elseif(a == 15) then
    info  = string.pack(">HBIIII", 0xaaaf, 0xaf,b,c,d,e)
  end	
  local sum = hex.checksum(info)
  return info .. string.char(sum)
end

-- hex.dump(send_0xAx_S1(0x0f,2,3,4,5))

-- function send_0xAx_S1(a,b,c,d,e)
--
-- 	if(a == 0)
-- 	local info = string.pack(">HbLL", 0xaaaf, 0xa0,b,c,d,e)
-- 	local sum = hex.checksum(info)
-- 	return info .. string.char(sum)
-- -- else if (a == 1)
-- -- 	local info = string.pack(">HbLL", 0xaaaf, 0xa1,b,c,d,e)
-- -- 	local sum = hex.checksum(info)
-- -- 	return info .. string.char(sum)
-- end

--===========================================--

--[[
	0x00_SharkMini_X2发送参数
	a = 时间戳	（一般发送当前时间戳）
	b = 版本号	（更新时所要发送的版本号）
	c = 0o r 1	（1代表着强制更新 也就是开启更新）
	d = 升级版本的字节数
    e = nil
]]
function send_0x00_X2(a,b,c,d,e)
	local info = string.pack(">HbLbbIbb",0x555f, 0x00, a, b, c, d, 0,e)
	local sum = hex.checksum(info)
	return info .. string.char(sum)
end

--[[
	0x01_SharkMini_X2发送参数
	a =  pan速度    0.1°/s  *10 +300
	b =  tilt 速度  0.1°/s  *10 +300
	c =  pan lock 标志  0x01）
	d = tilt   lock  标志   0x01
    e =   回零点标志  为1 回零点 为1 时  云台回零点位置，若中途拨动摇杆，回零动作停止，并响应摇杆速度
]]
function send_0x01_X2(a,b,c,d,e)
	local info = string.pack(">Hb>H>HbbbbL", 0x555f, 0x01,a,b,c,d,0,e,0)
	print("len:" ,#info)

	local sum = hex.checksum(info)
	return info .. string.char(sum)
end

hex.dump(send_0x01_X2(300, 300, 0,0,0))
--
-- function AAAA(a,b,c)
-- 	local info = string.pack(">Hb>H>Hb", 0x555f, 0x01,a,b,c)
--
-- 	local sum = hex.checksum(info)
-- 	return info .. string.char(sum)
-- end
-- hex.dump(AAAA(1,2,3))





--[[
	0x01_SharkMini_X2发送运行指令
	a =   0 回起点  
         1 时间戳校准       
         2 开始时间的时间戳              
         3 暂停运行（配合时间戳，何时暂停）                         
         4 停止运行（导轨停止，清零参数）
         5 恢复运行（配合时间戳，何时恢复）
	b =  开始时间戳 64位
	c =  是否循环运行 1循环
]]	
function send_0x02_X2(a,b,c)
	local info = string.pack(">HbbIIIHb", 0x555f, 0x02,a,b,0,0,0,c)
	local sum = hex.checksum(info)
	return info .. string.char(sum)
end

--[[ 
	0x03_SharkMini_x2延时摄影参数设置
	a =   Interval 
	b =  Exposure
	c =  Frames
	d = Mode
    e =   NumBezier.Pan—Tilt
	f = Buffer_second
	(Interval 1-60 second
	Exposure 1-60 second
	Frames   照片总张数
	Mode   0 SMS/ 1 Continue
	MS_Running   SMS中一段运动的最大时间)
]]
function send_0x03_X2(a,b,c,d,e,f)
	local info = string.pack(">HbHHIbHHHb", 0x555f, 0x03,a,b,c,d, e, f,0,0)
	local sum = hex.checksum(info)
	return info .. string.char(sum)
end

--[[
	0x04_SharkMini_X2Video参数设置
	a = time 运行总时间
	b = pan 和 tilt的贝塞尔曲线数量
]]
function send_0x04_X2(a,b)
	local info = string.pack(">HbIIbHIb", 0x555f, 0x04,a,0,0,b,0,0)
	local sum = hex.checksum(info)
	return info .. string.char(sum)
end


--[[
	0x05_Shark_Mini StopMotion set
	a = mode 0 回起点  
     		1 时间戳校准       
      	   2 当前帧的时间戳              
      	   3 配合Frame_Need移动到相应位置                        
      	   4 停止运行（云台停止，清零参数）
	b = 时间戳
	c = frame_Need 当前帧
	d = time单次运行的时间
]]
function send_0x05_X2(a,b,c,d)
	local info = string.pack(">HbbLIHb", 0x555f, 0x05,a,b,c,d,0)
	local sum = hex.checksum(info)
	return info .. string.char(sum)
end







--[[
	0x06_Shark_Mini 预览preview 
	a = mode  功能  1预览  0待机
	b = pan的位置精度0.1
	c = tilt的位置精度0.1
]]
function send_0x06_X2(a,b,c)
	local info = string.pack(">HbbIIIHb", 0x555f, 0x06,a,b,c,0,0,0)
	local sum = hex.checksum(info)
	return info .. string.char(sum)
end

--[[
	0x07_Shark_Mini Panorama 环形矩阵
	a = mode ( 0 回起始点命令 
         1 预览起点  
         2 开始拍摄              
         3 暂停          6恢复                    
         4 放弃运行（云台停止，清零参数）
         5 Tilt设置)
	b = 单张照片的宽角度 * 100
	c = 起始角度*10(0-3600)
	d =  终止角度*10
	e = tilt速度 0.1°/s  *10+300
	f = Interval  秒 
]]
function send_0x07_X2(a,b,c,d,e,f)
	local info = string.pack(">HbbhhhhhIb", 0x555f, 0x07,a,b,c,d, 0,e, 0,f)
	local sum = hex.checksum(info)
	return info .. string.char(sum)
end


--[[
0x08_Shark_Mini 方形矩阵
a = data[3] 0 1 2 3 4 5 6 7
b =  data[4-5]单张宽角度*100
c =  data[6-7] 单张高角度*100 
d = data[8-9] Pan速度*100+3000
e =  data[10-11] Tilt速度*100+3000
f =  data[18] Interval  秒 
]]
function send_0x08_X2(a,b,c,d,e,f)
	local info = string.pack(">HbbHHHHHIb", 0x555f, 0x08,a,b,c,d, e,0,0,f)
	local sum = hex.checksum(info)
	return info .. string.char(sum)
end

--[[
u8 data[3] 0 1 5 6  7
u16 data[4-5]pan速度*100+3000
u16 data[6-7] tilt速度*100+3000 
u16 data[8-9] Pan角度*10+3600（A）
u16 data[10-11] Tilt角度*10+350（A）
u16 data[12-13] Pan角度*10+3600（B点）
u16 data[14-15] Tilt角度*10+350（B点）

u16 data[17-18] 总运行时间 秒
]]
function send_0x09_X2(a,b,c,d,e,f,g,h)
	local info = string.pack(">HbbHHHHHHbH", 0x555f, 0x09,a,b,c,d,e,f,g,0,h)
	local sum = hex.checksum(info)
	return info .. string.char(sum)
end

--[[
u8 data[3] 0 1 2 3 4 
u8 data[4] 方向 1.向左 2.向右  3 自处理方向
u8 data[5] 0 1 循环标志 1循环
u16 data[6-7]  总运行时间 秒 
u8 data[8]     淡入淡出等级  0 1 2 3 
u8 data[9]   聚焦、离散标志（1聚焦 0离散）
u64 data[11-18] 时间戳 64位 ms
]]
function send_0x0A_X2(a,b,c,d,e,f,g)
	local info = string.pack(">HbbbbHbbbL", 0x555f, 0x0a,a,b,c,d, e, f,0,g)
	local sum = hex.checksum(info)
	return info .. string.char(sum)
end

--[[
	
	u64 data[3-10]  时间戳 ms64位
]]
function send_0x0B_X2(a)
	local info = string.pack(">HbLL", 0x555f, 0x0b,a,0,0)
	local sum = hex.checksum(info)
	return info .. string.char(sum)
end

--[[
	u8 data[3] 0 1 2 3 4
]]
function send_0x0C_X2(a)
	local info = string.pack(">HbbHLIb", 0x555f, 0x0c,a,0,0,0,0)
	local sum = hex.checksum(info)
	return info .. string.char(sum)
end

--[[
	u64 data[3-10]  时间戳 ms64位
]]
function send_0x24_X2(a)
	local info = string.pack(">HbLL", 0x555f, 0x24,a,0,0)
	local sum = hex.checksum(info)
	return info .. string.char(sum)
end

--[[
	发送pan的贝塞尔曲线
]]
function send_0x5x_S1(a,b,c,d,e)
  local info
  if (a== 0) then
    info  = string.pack(">HBIIII", 0x555f, 0x50,b,c,d,e)
  elseif(a == 1) then
    info  = string.pack(">HBIIII", 0x555f, 0x51,b,c,d,e) 	
  elseif(a == 2) then
    info  = string.pack(">HBIIII", 0x555f, 0x52,b,c,d,e)
  elseif(a == 3) then
    info  = string.pack(">HBIIII", 0x555f, 0x53,b,c,d,e)
  elseif(a == 4) then
    info  = string.pack(">HBIIII", 0x555f, 0x54,b,c,d,e)
  elseif(a == 5) then
    info  = string.pack(">HBIIII", 0x555f, 0x55,b,c,d,e)
  elseif(a == 6) then
    info  = string.pack(">HBIIII", 0x555f, 0x56,b,c,d,e)
  elseif(a == 7) then
    info  = string.pack(">HBIIII", 0x555f, 0x57,b,c,d,e)
  elseif(a == 8) then
    info  = string.pack(">HBIIII", 0x555f, 0x58,b,c,d,e)
  elseif(a == 9) then
    info  = string.pack(">HBIIII", 0x555f, 0x59,b,c,d,e)
  elseif(a == 10) then
    info  = string.pack(">HBIIII", 0x555f, 0x5A,b,c,d,e)
  elseif(a == 11) then
    info  = string.pack(">HBIIII", 0x555f, 0x5b,b,c,d,e)
  elseif(a == 12) then
    info  = string.pack(">HBIIII", 0x555f, 0x5c,b,c,d,e)
  elseif(a == 13) then
    info  = string.pack(">HBIIII", 0x555f, 0x5d,b,c,d,e)
  elseif(a == 14) then
    info  = string.pack(">HBIIII", 0x555f, 0x5e,b,c,d,e)
  elseif(a == 15) then
    info  = string.pack(">HBIIII", 0x555f, 0x5f,b,c,d,e)
  end	
  local sum = hex.checksum(info)
  return info .. string.char(sum)
end

--[[发送Tilt的贝塞尔曲线]]
function send_0x6x_S1(a,b,c,d,e)
  local info
  if (a== 0) then
    info  = string.pack(">HBIIII", 0x555f, 0x60,b,c,d,e)
  elseif(a == 1) then
    info  = string.pack(">HBIIII", 0x555f, 0x61,b,c,d,e) 	
  elseif(a == 2) then
    info  = string.pack(">HBIIII", 0x555f, 0x62,b,c,d,e)
  elseif(a == 3) then
    info  = string.pack(">HBIIII", 0x555f, 0x63,b,c,d,e)
  elseif(a == 4) then
    info  = string.pack(">HBIIII", 0x555f, 0x64,b,c,d,e)
  elseif(a == 5) then
    info  = string.pack(">HBIIII", 0x555f, 0x65,b,c,d,e)
  elseif(a == 6) then
    info  = string.pack(">HBIIII", 0x555f, 0x66,b,c,d,e)
  elseif(a == 7) then
    info  = string.pack(">HBIIII", 0x555f, 0x67,b,c,d,e)
  elseif(a == 8) then
    info  = string.pack(">HBIIII", 0x555f, 0x68,b,c,d,e)
  elseif(a == 9) then
    info  = string.pack(">HBIIII", 0x555f, 0x69,b,c,d,e)
  elseif(a == 10) then
    info  = string.pack(">HBIIII", 0x555f, 0x6A,b,c,d,e)
  elseif(a == 11) then
    info  = string.pack(">HBIIII", 0x555f, 0x6b,b,c,d,e)
  elseif(a == 12) then
    info  = string.pack(">HBIIII", 0x555f, 0x6c,b,c,d,e)
  elseif(a == 13) then
    info  = string.pack(">HBIIII", 0x555f, 0x6d,b,c,d,e)
  elseif(a == 14) then
    info  = string.pack(">HBIIII", 0x555f, 0x6e,b,c,d,e)
  elseif(a == 15) then
    info  = string.pack(">HBIIII", 0x555f, 0x6f,b,c,d,e)
  end	
  local sum = hex.checksum(info)
  return info .. string.char(sum)
end
	
