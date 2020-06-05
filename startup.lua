--1.5.1
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
local versionnumber = ""
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
print("You have latest version")
term.clear()
rs.setOutput("back",true)
local tablo = {}
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
tablo.tsep = ""
tablo.taim = 0
tablo.realclock = 0
tablo.htimeouttaken = 0
tablo.gtimeouttaken = 0

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
			print("|-----------KJ SCOREBOARD SYSTEM v".. versionhandle .."---------|")
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
		if tonumber(tablo.runclock) == 0 then
			tablo.tsep = "."
		else
			tablo.tsep = ":"
			if tablo.clocks % 2 == 0 then
				tablo.tsep = " "
			end
		end	
		if tablo.breakstatus == 0 then
			mon.setTextColor(colors.red)
			tablo.taim = string.format("%02d%s%02d",tablo.clockm,tablo.tsep,tablo.clocks)
		else
			mon.setTextColor(colors.green)
			tablo.taim = string.format("%02d%s%02d",tablo.breakm,tablo.tsep,tablo.breaks)
		end
		mon.write(tablo.taim)
		smallmon.write(tablo.taim)
		 -- penalty clocks
		mon.setCursorPos(1,7) 
		mon.setTextColor(colors.red)
		if tonumber(tablo.hp1m) > 0  or tonumber(tablo.hp1s) > 0 then
			mon.write(string.format("%02d %d:%02d",tablo.hp1p,tablo.hp1m,tablo.hp1s))
		else
			mon.write("           ")  
		end
		mon.setCursorPos(1,8) 
		if tonumber(tablo.hp2m) > 0  or tonumber(tablo.hp2s) > 0 then
			mon.write(string.format("%02d %d:%02d",tablo.hp2p,tablo.hp2m,tablo.hp2s))
		else
			mon.write("           ")  
		end 
		
		mon.setCursorPos(10,7) 
		mon.setTextColor(colors.red)
		if tonumber(tablo.gp1m) > 0  or tonumber(tablo.gp1s) > 0 then
			mon.write(string.format("%02d %d:%02d",tablo.gp1p,tablo.gp1m,tablo.gp1s))
		else
			mon.write("                ")  
		end
		mon.setCursorPos(10,8) 
		if tonumber(tablo.gp2m) > 0  or tonumber(tablo.gp2s) > 0 then
			mon.write(string.format("%02d %d:%02d",tablo.gp2p,tablo.gp2m,tablo.gp2s))
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
			if tonumber(tablo.clockm) == 0 and tonumber(tablo.clocks) == 0 then
					if tablo.runclock == 1 then
						horn()
					end
				tablo.runclock = 0
				 
			elseif tonumber(tablo.clocks) == 0 and  tonumber(tablo.clockm) > 0 then 
				tablo.clockm = tablo.clockm - 1
				tablo.clocks = 59
			else
				tablo.clocks = tablo.clocks - 1
			end
			-- hp 1
			if tonumber(tablo.hp1m) > 0 or tonumber(tablo.hp1s) > 0 then
				if tonumber(tablo.hp1s) == 0 and  tonumber(tablo.hp1m) > 0 then 
					tablo.hp1m = tablo.hp1m - 1
					tablo.hp1s = 59
				else
					tablo.hp1s = tablo.hp1s - 1
				end
			else
				tablo.hp1s = 0 
				tablo.hp1m = 0
			end
			--hp2
			if tonumber(tablo.hp2m) > 0 or tonumber(tablo.hp2s) > 0 then
				if tonumber(tablo.hp2s) == 0 and  tonumber(tablo.hp2m) > 0 then 
					tablo.hp2m = tablo.hp2m - 1
					tablo.hp2s = 59
				else
					tablo.hp2s = tablo.hp2s - 1
				end
			else
				tablo.hp2s = 0 
				tablo.hp2m = 0
			end
			
			-- gp 1
			if tonumber(tablo.gp1m) > 0 or tonumber(tablo.gp1s) > 0 then
				if tonumber(tablo.gp1s) == 0 and  tonumber(tablo.gp1m) > 0 then 
					tablo.gp1m = tablo.gp1m - 1
					tablo.gp1s = 59
				else
					tablo.gp1s = tablo.gp1s - 1
				end
			else
				tablo.gp1s = 0 
				tablo.gp1m = 0
			end
			--gp2
			if tonumber(tablo.gp2m) > 0 or tonumber(tablo.gp2s) > 0 then
				if tonumber(tablo.gp2s) == 0 and  tonumber(tablo.gp2m) > 0 then 
					tablo.gp2m = tablo.gp2m - 1
					tablo.gp2s = 59
				else
					tablo.gp2s = tablo.gp2s - 1
				end
			else
				tablo.gp2s = 0 
				tablo.gp2m = 0
			end
			sleep(1)
		else
			rs.setOutput("back",true)
			if tonumber(tablo.breakm) == 0 and tonumber(tablo.breaks) == 0 then
				if tablo.breakstatus == 1 then
						horn()
					if tonumber(tablo.period) == 0 then
						tablo.period = 1 -- its pregame
					end
				end
				 
				tablo.breakstatus = 0
				tablo.runclock = 0
			 
				 
			elseif tonumber(tablo.breaks) == 0 and  tonumber(tablo.breakm) > 0 then 
				tablo.breakm = tablo.breakm - 1
				tablo.breaks = 59
			else
				tablo.breaks = tablo.breaks - 1
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
		print("|-KJ SCOREBOARD SYSTEM v".. versionhandle .."---|")
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
			tablo.clockm = fields[1]
			tablo.clocks = fields[2]
			 
		elseif fields[0] == "bt" then -- breaktime
			tablo.breakm = fields[1]
			tablo.breaks = fields[2]
			tablo.breakstatus = 1
			 
		elseif fields[0] == "hto" then -- breaktime
			tablo.breakm = 0
			tablo.breaks = 30
			tablo.breakstatus = 1
			tablo.htimeouttaken = 1
			 
		elseif fields[0] == "gto" then -- breaktime
			tablo.breakm = 0
			tablo.breaks = 30
			tablo.breakstatus = 1
			tablo.gtimeouttaken = 1
			 
		elseif fields[0] == "hp" then -- hometeam first penalty
			if fields[1] ~= nil then
				if tonumber(fields[1]) == 1 then -- row
					tablo.hp1p = (fields[2] ~= nil) and fields[2] or 0
					tablo.hp1m = (fields[3] ~= nil) and fields[3] or 2 -- default - 2 mins
					tablo.hp1s = (fields[4] ~= nil) and fields[4] or 0
				elseif tonumber(fields[1]) == 2 then
					tablo.hp2p = (fields[2] ~= nil) and fields[2] or 0
					tablo.hp2m = (fields[3] ~= nil) and fields[3] or 2 -- default - 2 mins
					tablo.hp2s = (fields[4] ~= nil) and fields[4] or 0	 
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
					tablo.gp1m = (fields[3] ~= nil) and fields[3] or 2 -- default - 2 mins
					tablo.gp1s = (fields[4] ~= nil) and fields[4] or 0
				elseif tonumber(fields[1]) == 2 then
					tablo.gp2p = (fields[2] ~= nil) and fields[2] or 0
					tablo.gp2m = (fields[3] ~= nil) and fields[3] or 2 -- default - 2 mins
					tablo.gp2s = (fields[4] ~= nil) and fields[4] or 0	 
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
			tablo.hp1m = 0
			tablo.hp1s = 0
			 
		elseif fields[0] == "dhp2" then -- setperiod
			tablo.hp2m = 0
			tablo.hp2s = 0
			 
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