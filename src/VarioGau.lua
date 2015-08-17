--[[ Vario Gauges - Altimeter, Vertical Speed, max + Min Height script
	by jenny gorton 
	Version 1.2 - 13 July 2015
	[url]http://rcsettings.com/index.php/viewdownload/13-lua-scripts/121-vario-telemetry-screen[/url]
]]

local Alt, Vspd, MaxAlt, MinAlt 

local function getTelemetryId(name)
	field = getFieldInfo(name)
	if field then
	  return field.id
	else
	  return -1
	end
end

local function init()
	ver = getVersion()
	if ver>="2.1.0" then
		Alt = getTelemetryId("Alt")
		Vspd = getTelemetryId("VSpd")
		MaxAlt  = getTelemetryId("Alt+")
		MinAlt = getTelemetryId("Alt-")
	else
		Alt = getFieldInfo("altitude").id
		Vspd = getFieldInfo("vertical-speed").id
		MaxAlt  = getFieldInfo("altitude-min").id
		MinAlt = getFieldInfo("altitude-max").id
	end

end

local function run(event)
	local x1 = 37
	local y1 = 32
	local angle
	local x2
	local y2
	lcd.clear()
-- background
	lcd.drawRectangle(7,2,62,62,0)
	for i=0, 9 do
		angle = math.rad((36*i)-90)
		x2 = 25 * math.cos(angle) + x1 
		y2 = 25 * math.sin(angle) + y1 	
		lcd.drawNumber(x2+4, y2-4, i, 0)
	end

--get and split up altitude
	local CurrentAlt = getValue(Alt)
	local tens=CurrentAlt/10
	local hundreds=CurrentAlt/100
	local thousands=CurrentAlt/1000

-- draw hands
	angle = math.rad((tens*360)-90)
	x2 = 30 * math.cos(angle) + x1 
	y2 = 30 * math.sin(angle) + y1 
	lcd.drawLine(x1, y1, x2, y2, SOLID, 0)

	angle = math.rad((hundreds*360)-90)
	x2 = 22 * math.cos(angle) + x1 
	y2 = 22 * math.sin(angle) + y1 
	lcd.drawLine(x1, y1, x2, y2, SOLID, 0)
	
	angle = math.rad((thousands*360)-90)
	x2 = 15 * math.cos(angle) + x1 
	y2 = 15 * math.sin(angle) + y1 
	lcd.drawLine(x1, y1, x2, y2, SOLID, 0)

  	--draw numerical Altitude in center
	lcd.drawNumber(44, 28, CurrentAlt, 0)


--Vertical Speed
-- background
	lcd.drawRectangle(75,2,62,62,0)
	x1=105
	for i=0, 10, 2 do
		angle = math.rad(-((17*i)-180))
		x2 = 25 * math.cos(angle) + x1 
		y2 = 25 * math.sin(angle) + y1 	
		lcd.drawNumber(x2+4, y2-4, i, 0)
		angle = math.rad(((17*i)-180))
		x2 = 25 * math.cos(angle) + x1 
		y2 = 25 * math.sin(angle) + y1 	
		lcd.drawNumber(x2+4, y2-4, i, 0)
	end
	
	local Vspeed = getValue(Vspd)--get vspeed in m/s
	local indicatedSpeed = 0
	if Vspeed>10 then
		indicatedSpeed=10
	elseif Vspeed<-10 then
		indicatedSpeed=-10
	else
		indicatedSpeed=Vspeed
	end
-- draw indicator
	angle = math.rad((indicatedSpeed*17)-180)
	x2 = 27 * math.cos(angle) + x1 
	y2 = 27 * math.sin(angle) + y1 
	lcd.drawLine(x1, y1, x2, y2, SOLID, 0)--GREY_DEFAULT)

	lcd.drawRectangle(143,2,62,62,0)
	lcd.drawText(145, 15, "Max", MIDSIZE)
	lcd.drawChannel(197, 15, MaxAlt,MIDSIZE) --display Max alt
	lcd.drawText(145, 40, "Min", MIDSIZE)
	lcd.drawChannel(197, 40, MinAlt, MIDSIZE) --display Min Alt

end

return { run=run, init=init}