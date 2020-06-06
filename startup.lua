--1.6.5
--Scoreboard system by KJO
function getLine( str, n )
  local i = 1
  for line in str:gmatch( "[^\r\n]+" ) do --#matches things that are not newline characters
    if i == n then --#if we're on the line you wanted
      return line --#return it
    end
    i = i + 1
  end
end
function SecondsToClock(seconds,minutesnozero)
  local seconds = tonumber(seconds)

  if seconds <= 0 then
    return "00:00";
  else
    hours = string.format("%02.f", math.floor(seconds/3600));
	if minutesnozero == 1 then
		mins = string.format("%d", math.floor(seconds/60 - (hours*60)));
	else
		mins = string.format("%02d", math.floor(seconds/60 - (hours*60)));
	end
   
    secs = string.format("%02d", math.floor(seconds - hours*3600 - mins *60));
    return mins..":"..secs
  end
end
local versionnumber = ""
print("Checking for latest version")
-- opening this file to check version of this file
local nfile = io.open( "startup.lua", "r" )
versionnumber = tostring(nfile:read("*l")):gsub("%^--", "") -- get version number of this file
nfile:close()
-- closing, starting to check gitgub
local mainfile = http.get("https://raw.githubusercontent.com/kristopherjone/kjscb/master/startup.lua") --This will make 'download' hold the contents of the file.
local handlemain = mainfile.readAll() --Reads everything in download
mainfile.close()
if tostring(getLine( handlemain, 1 )):gsub("%^--", "") ~= versionnumber then
	-- that will check version number
	print("Starting to download latest version")
	local file = fs.open("startup.lua","w") --opens the file 'startup' with the permissions to write.
	file.write(handlemain) --writes all the stuff in handle to the file 'startup'.
	file.close()
	print("Done. Rebooting")
	sleep(1)
	os.reboot()
end
print("You have latest version. Starting scoreboard")
sleep(1)
term.clear()
rs.setOutput("back",true)
local tablo = {}
tablo.homename = ""
tablo.guestname = ""
tablo.mianclocktime = 0
tablo.breakclocktime = 0

tablo.hscore = 0
tablo.gscore = 0
tablo.period = 0
tablo.runclock = 0
tablo.awaitstart = 0
tablo.breakstatus = 0
 
tablo.taim = 0
tablo.realclock = 0
tablo.htimeouttaken = 0
tablo.gtimeouttaken = 0

tablo.hp1p = 0
tablo.hp1time = 0

tablo.gp1p = 0
tablo.gp1time = 0

tablo.hp2p = 0
tablo.hp2time = 0

tablo.gp2p = 0
tablo.gp2time = 0

--
local monitors = {peripheral.find("monitor")} --# finding all of the monitors and putting them in a table
local mon = {} --# defining a table to store the functions we are about to create
 --# defining a table to store the functions we are about to create
for k,v in pairs(monitors[1]) do --# looping through the functions of the first monitor
  mon[k] = function(...) --# creates a new function in the mon table with the name k.  k is the name of one of the functions from the monitor we are looping through
        for i = 1, #monitors do --# looping through all of the monitors in the monitors table
          local w,h = (monitors[i]).getSize()
		  if h > 1 then
			monitors[i][k](...) --# executing the original function for each monitor with the original arguments
		  end
        end
		 
  end
end
local monitors = {peripheral.find("monitor")}
local smallmon = {}
for k,v in pairs(monitors[1]) do 
 smallmon[k] = function(...) --# creates a new function in the mon table with the name k.  k is the name of one of the functions from the monitor we are looping through
        for i = 1, #monitors do --# looping through all of the monitors in the monitors table
            local w,h = (monitors[i]).getSize()
		   if  h == 1 then
			monitors[i][k](...) --# executing the original function for each monitor with the original arguments
		  end
        end
		 
  end
end
smallmon.setCursorPos(1,1)
mon.setCursorPos(1,1)
mon.write("KJ SCOREBOARD SYSTEM")
smallmon.clear()
term.clear()
			print("|-----------KJ SCOREBOARD SYSTEM v".. versionnumber .."---------|")
			print("|                                               |")
			print("|Would you like to restore old game data?  y /n |")
			print("|                                               |")
			print("_________________________________________________") 	 
			local input
			input = read()
			if input == "y" then
				local file = io.open( "oldgame.txt", "r" )
				if file ~= nil then
					print("Starting restoring procedure...")
					local arr = textutils.unserialize(file:read("*a"))
					tablo = arr
					file:close()
				else
					print("Error! No old session file found! Continue with new game...")
					local nfile = io.open( "oldgame.txt", "w" )
					nfile:write(textutils.serialize({}))
					nfile:close()
				end
				 
			end
		 
 --
tablo.realclock = 0
print("Starting scoreboard")
sleep(1)
mon.clear()
term.clear()
function parladetablo()
	if tablo.realclock == 1 then
		local MCTicks = (os.time() * 1000 + 18000)%24000
		mon.setTextScale(5)
		smallmon.setTextScale(4)
		smallmon.setCursorPos(1,1)
		mon.setCursorPos(3,5) 
		local time = os.time()
		local formattedTime = textutils.formatTime(time, true)	
		mon.write("   ".. formattedTime .. "  ")
		smallmon.write(formattedTime)
	else
		mon.setTextScale(5)
		smallmon.setTextScale(4)
		smallmon.setCursorPos(1,1)
		mon.setCursorPos(1,1)
		mon.write(tostring(tablo.homename) .. "-" .. tablo.guestname)
		mon.setTextColor(colors.white)
		mon.setCursorPos(3,3)
		mon.write(string.format("%d",tablo.hscore))
		mon.setCursorPos(13,3)
		mon.write(string.format("%d",tablo.gscore)) 
		mon.setCursorPos(7,3)
		
		
		if tonumber(tablo.period) > 0 then
			mon.setTextColor(colors.yellow)
			local izdruka = string.format("%d",tablo.period)
			if tablo.htimeouttaken == 1 then
				izdruka = "*".. izdruka
			else
				izdruka = " ".. izdruka
			end
			
			if tablo.gtimeouttaken == 1 then
				izdruka = izdruka .. "*"
			
			else
				izdruka = izdruka .. " "
			end
			mon.write(izdruka)  
		else
			mon.write("    ")  
		end
		mon.setTextColor(colors.white)
		mon.setCursorPos(6,5) 
		if tablo.breakstatus == 0 then
			mon.setTextColor(colors.red)
			tablo.taim = SecondsToClock(tablo.mianclocktime)
		else
			mon.setTextColor(colors.green)
			tablo.taim = SecondsToClock(tablo.breakclocktime)
		end
		mon.write(tablo.taim)
		smallmon.write(tablo.taim)
		 -- penalty clocks
		mon.setCursorPos(1,7) 
		mon.setTextColor(colors.red)
		if tonumber(tablo.hp1time) > 0 then
			mon.write(string.format("%02d %s",tablo.hp1p,SecondsToClock(tablo.hp1time,1)))
		else
			mon.write("           ")  
		end
		mon.setCursorPos(1,8) 
		if tonumber(tablo.hp2time) > 0 then
			mon.write(string.format("%02d %s",tablo.hp2p,SecondsToClock(tablo.hp2time,1)))
		else
			mon.write("           ")  
		end
		mon.setCursorPos(10,7) 
		mon.setTextColor(colors.red)
		if tonumber(tablo.gp1time) > 0 then
			mon.write(string.format("%02d %s",tablo.gp1p,SecondsToClock(tablo.gp1time,1)))
		else
			mon.write("                ")  
		end
		mon.setCursorPos(10,8) 
		if tonumber(tablo.gp2time) > 0  then
			mon.write(string.format("%02d %s",tablo.gp2p,SecondsToClock(tablo.gp2time,1)))
		else
			mon.write("                ")  
		end
	end
end

 
function fixtime()
	while true do
	   if rs.getInput("left") then
			savedata()
			if tablo.breakstatus == 1 then
				tablo.breakstatus = 0 -- kills break time 
			end
			if tablo.runclock == 0 then
				tablo.runclock = 1
			else
				tablo.runclock = 0
			end	   
	   end
		if tablo.breakstatus == 0 and tablo.runclock == 1 then
			rs.setOutput("back",false)
			if tonumber(tablo.mianclocktime)  == 0 then
					if tablo.runclock == 1 then
						horn()
					end
				tablo.runclock = 0
			else
				tablo.mianclocktime = tablo.mianclocktime - 1
			end
			-- hp 1
			if tonumber(tablo.hp1time) > 0 then
				tablo.hp1time = tablo.hp1time - 1
			else
				tablo.hp1time = 0
			end
			--hp2
			if tonumber(tablo.hp2time) > 0 then
				tablo.hp2time = tablo.hp1time - 1
			else
				tablo.hp2time = 0
			end
			
			-- gp 1
			if tonumber(tablo.gp1time) > 0 then
				tablo.gp1time = tablo.gp1time - 1
			else
				tablo.gp1time = 0
			end
			--gp2
			if tonumber(tablo.gp2time) > 0 then
				tablo.gp2time = tablo.gp2time - 1
			else
				tablo.gp2time = 0
			end
			sleep(1)
		else
			rs.setOutput("back",true)
			if tonumber(tablo.breakclocktime)  == 0 then
				if tablo.breakstatus == 1 then
						horn()
					if tonumber(tablo.period) == 0 then
						tablo.period = 1 -- its pregame
					end
				end				 
				tablo.breakstatus = 0
				tablo.runclock = 0
			elseif tonumber(tablo.breakclocktime) > 0 then 
				tablo.breakclocktime = tablo.breakclocktime -1
			end
			sleep(1)
		end
	parladetablo()
	end
end
parladetablo()

-- This part rules commands
function main()
	while true do
		term.clear()

		term.setCursorPos(1,1)
		local input
		print("|-KJ SCOREBOARD SYSTEM v".. versionnumber .."---|")
		print("|                               |")
		print("|   INPUT COMMAND h for help    |")
		print("|                               |")
		print("---------------------------------")
		input = read()
		fields = {}
		sep = " "
		cc = 0
		for str in string.gmatch(input, "([^"..sep.."]+)") do
		   fields[cc] = str
			cc = cc + 1
		end
		if fields[0] == "hn" then --homenname 
			tablo.homename = fields[1]
			print("Home team name set")
		elseif fields[0] == "gn" then --guestnname 
			tablo.guestname = fields[1]
			print("Guest team name set")
		elseif fields[0] == "hs" then --homenname 
			tablo.hscore = fields[1]
			print("Home score set")
		elseif fields[0] == "gs" then --guestnname 
			tablo.gscore = fields[1]
			print("Guest score set")
		elseif fields[0] == "sp" then -- setperiod
			tablo.period = fields[1]
		elseif fields[0] == "st" then -- setperiod
			tablo.mianclocktime = (fields[1] * 60) +fields[2]	 
		elseif fields[0] == "bt" then -- breaktime
			tablo.breakstatus = 1
			tablo.breakclocktime = (fields[1] * 60) +fields[2]
		elseif fields[0] == "hto" then -- breaktime
			tablo.breakclocktime = 30
			tablo.breakstatus = 1
			tablo.htimeouttaken = 1
			 
		elseif fields[0] == "gto" then -- breaktime
			tablo.breakclocktime = 30
			tablo.breakstatus = 1
			tablo.gtimeouttaken = 1
			 
		elseif fields[0] == "hp" then -- hometeam first penalty
			if fields[1] ~= nil then
				if tonumber(fields[1]) == 1 then -- row
					tablo.hp1p = (fields[2] ~= nil) and fields[2] or 0
					tablo.hp1time = (fields[3] * 60) + fields[4]
				elseif tonumber(fields[1]) == 2 then
					tablo.hp2p = (fields[2] ~= nil) and fields[2] or 0
					tablo.hp2time = (fields[3] * 60) + fields[4]
				else
					print ("1 or 2 !!! ")
				end
				print ("Home team penalty for ".. tostring(fields[1]) .." row set, player #"..tostring(fields[2]).." penalty: "..tostring(fields[3]) .. ":"..tostring(fields[4]))
				sleep(2)
			else
				print ("You need to declare - first penaly or second")
				sleep(2)
			end
		elseif fields[0] == "gp" then -- hometeam first penalty
			if fields[1] ~= nil then
				if tonumber(fields[1]) == 1 then -- row
					tablo.gp1p = (fields[2] ~= nil) and fields[2] or 0
					tablo.gp1time = (fields[3] * 60) + fields[4]
				elseif tonumber(fields[1]) == 2 then
					tablo.gp2p = (fields[2] ~= nil) and fields[2] or 0
					tablo.gpt2ime = (fields[3] * 60) + fields[4] 
				else
					print ("1 or 2 !!! ")
				end
				print ("Guest team penalty for ".. tostring(fields[1]) .." row set, player #"..tostring(fields[2]).." penalty: "..tostring(fields[3]) .. ":"..tostring(fields[4]))
				sleep(2)
			else
				print ("You need to declare - first penaly or second")
				sleep(2)
			end
		elseif fields[0] == "dhp1" then -- setperiod
			tablo.hp1time = 0		 
		elseif fields[0] == "dhp2" then -- setperiod
			tablo.hp2time = 0		 
		elseif fields[0] == "dgp1" then -- setperiod
			tablo.gp1time = 0		 
		elseif fields[0] == "dgp2" then -- setperiod
			tablo.gp2time = 0		 
		elseif fields[0] == "realtime" then -- setperiod
			if tablo.realclock == 1 then
				tablo.realclock = 0
			else 
				tablo.realclock = 1
				mon.clear()
			end
			 
		elseif fields[0] == "horn" then -- setperiod
			horn()
		elseif fields[0] == "off" then -- setperiod
			term.clear()
			mon.clear()
			smallmon.clear()
			os.shutdown()
		elseif fields[0] == "default" then -- setperiod
			tablo.homename = "HOME"
			tablo.guestname = "GUEST"
			tablo.period = "1"
			tablo.clockm = 10
			tablo.clocks = 0
			 
		elseif fields[0] == "reset" then -- setperiod
			term.clear()
			print("Resetting")
			 tablo.homename = ""
			 tablo.guestname = ""
			 tablo.clockm = 0
			 tablo.clocks = 0
			 tablo.hscore = 0
			 tablo.gscore = 0
			 tablo.period = 0
			 tablo.runclock = 0
			 tablo.awaitstart = 0
			 tablo.breakstatus = 0
			 tablo.breakm = 0
			 tablo.breaks = 0
			 tablo.hp1p = 0
			 tablo.hp1m = 0
			 tablo.hp1s = 0		
			 tablo.gp1p = 0
			 tablo.gp1m = 0
			 tablo.gp1s = 0		
			 tablo.hp2p = 0
			 tablo.hp2m = 0
			 tablo.hp2s = 0		
			 tablo.gp2p = 0
			 tablo.gp2m = 0
			 tablo.gp2s = 0 
			sleep(1)
		else
			print("Wrong command!")
			sleep(2)
		end
	   parladetablo()
	   savedata()
	end
end

function savedata()
	local file = io.open( "oldgame.txt", "w" )
	file:write(textutils.serialize(tablo))
	file:close()
end
function horn()
	local speaker = peripheral.find("speaker")
	if speaker ~= nil then
		speaker.playNote("guitar",3,20)
		sleep(0.2)
		speaker.playNote("guitar",3,20)
		sleep(0.2)
		speaker.playNote("guitar",3,20)
	end
end
 
parallel.waitForAll(main, fixtime)