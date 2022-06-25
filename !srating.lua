require 'lib.moonloader'

script_name('srating')
script_version("25.06.2022")
script_authors("qrlk")
script_dependencies("SAMP.lua", "sampfuncs", "cleo")
script_description("������� ����� �������� ��������� ��� Samp-Rp.")
script_url("https://github.com/qrlk/srating")

-- https://github.com/qrlk/qrlk.lua.moonloader
local enable_sentry = true -- false to disable error reports to sentry.io
if enable_sentry then
  local sentry_loaded, Sentry = pcall(loadstring, [=[return {init=function(a)local b,c,d=string.match(a.dsn,"https://(.+)@(.+)/(%d+)")local e=string.format("https://%s/api/%d/store/?sentry_key=%s&sentry_version=7&sentry_data=",c,d,b)local f=string.format("local target_id = %d local target_name = \"%s\" local target_path = \"%s\" local sentry_url = \"%s\"\n",thisScript().id,thisScript().name,thisScript().path:gsub("\\","\\\\"),e)..[[require"lib.moonloader"script_name("sentry-error-reporter-for: "..target_name.." (ID: "..target_id..")")script_description("���� ������ ������������� ������ ������� '"..target_name.." (ID: "..target_id..")".."' � ���������� �� � ������� ����������� ������ Sentry.")local a=require"encoding"a.default="CP1251"local b=a.UTF8;local c="moonloader"function getVolumeSerial()local d=require"ffi"d.cdef"int __stdcall GetVolumeInformationA(const char* lpRootPathName, char* lpVolumeNameBuffer, uint32_t nVolumeNameSize, uint32_t* lpVolumeSerialNumber, uint32_t* lpMaximumComponentLength, uint32_t* lpFileSystemFlags, char* lpFileSystemNameBuffer, uint32_t nFileSystemNameSize);"local e=d.new("unsigned long[1]",0)d.C.GetVolumeInformationA(nil,nil,0,e,nil,nil,nil,0)e=e[0]return e end;function getNick()local f,g=pcall(function()local f,h=sampGetPlayerIdByCharHandle(PLAYER_PED)return sampGetPlayerNickname(h)end)if f then return g else return"unknown"end end;function getRealPath(i)if doesFileExist(i)then return i end;local j=-1;local k=getWorkingDirectory()while j*-1~=string.len(i)+1 do local l=string.sub(i,0,j)local m,n=string.find(string.sub(k,-string.len(l),-1),l)if m and n then return k:sub(0,-1*(m+string.len(l)))..i end;j=j-1 end;return i end;function url_encode(o)if o then o=o:gsub("\n","\r\n")o=o:gsub("([^%w %-%_%.%~])",function(p)return("%%%02X"):format(string.byte(p))end)o=o:gsub(" ","+")end;return o end;function parseType(q)local r=q:match("([^\n]*)\n?")local s=r:match("^.+:%d+: (.+)")return s or"Exception"end;function parseStacktrace(q)local t={frames={}}local u={}for v in q:gmatch("([^\n]*)\n?")do local w,x=v:match("^	*(.:.-):(%d+):")if not w then w,x=v:match("^	*%.%.%.(.-):(%d+):")if w then w=getRealPath(w)end end;if w and x then x=tonumber(x)local y={in_app=target_path==w,abs_path=w,filename=w:match("^.+\\(.+)$"),lineno=x}if x~=0 then y["pre_context"]={fileLine(w,x-3),fileLine(w,x-2),fileLine(w,x-1)}y["context_line"]=fileLine(w,x)y["post_context"]={fileLine(w,x+1),fileLine(w,x+2),fileLine(w,x+3)}end;local z=v:match("in function '(.-)'")if z then y["function"]=z else local A,B=v:match("in function <%.* *(.-):(%d+)>")if A and B then y["function"]=fileLine(getRealPath(A),B)else if#u==0 then y["function"]=q:match("%[C%]: in function '(.-)'\n")end end end;table.insert(u,y)end end;for j=#u,1,-1 do table.insert(t.frames,u[j])end;if#t.frames==0 then return nil end;return t end;function fileLine(C,D)D=tonumber(D)if doesFileExist(C)then local E=0;for v in io.lines(C)do E=E+1;if E==D then return v end end;return nil else return C..D end end;function onSystemMessage(q,type,i)if i and type==3 and i.id==target_id and i.name==target_name and i.path==target_path and not q:find("Script died due to an error.")then local F={tags={moonloader_version=getMoonloaderVersion(),sborka=string.match(getGameDirectory(),".+\\(.-)$")},level="error",exception={values={{type=parseType(q),value=q,mechanism={type="generic",handled=false},stacktrace=parseStacktrace(q)}}},environment="production",logger=c.." (no sampfuncs)",release=i.name.."@"..i.version,extra={uptime=os.clock()},user={id=getVolumeSerial()},sdk={name="qrlk.lua.moonloader",version="0.0.0"}}if isSampAvailable()and isSampfuncsLoaded()then F.logger=c;F.user.username=getNick().."@"..sampGetCurrentServerAddress()F.tags.game_state=sampGetGamestate()F.tags.server=sampGetCurrentServerAddress()F.tags.server_name=sampGetCurrentServerName()else end;print(downloadUrlToFile(sentry_url..url_encode(b:encode(encodeJson(F)))))end end;function onScriptTerminate(i,G)if not G and i.id==target_id then lua_thread.create(function()print("������ "..target_name.." (ID: "..target_id..")".."�������� ���� ������, ����������� ����� 60 ������")wait(60000)thisScript():unload()end)end end]]local g=os.tmpname()local h=io.open(g,"w+")h:write(f)h:close()script.load(g)os.remove(g)end}]=])
  if sentry_loaded and Sentry then
    pcall(Sentry().init, { dsn = "https://fcf49f778b924fc993c85cc12fef35aa@o1272228.ingest.sentry.io/6530024" })
  end
end

-- https://github.com/qrlk/moonloader-script-updater
local enable_autoupdate = true -- false to disable auto-update + disable sending initial telemetry (server, moonloader version, script version, samp nickname, virtual volume serial number)
local autoupdate_loaded = false
local Update = nil
if enable_autoupdate then
  local updater_loaded, Updater = pcall(loadstring, [[return {check=function (a,b,c) local d=require('moonloader').download_status;local e=os.tmpname()local f=os.clock()if doesFileExist(e)then os.remove(e)end;downloadUrlToFile(a,e,function(g,h,i,j)if h==d.STATUSEX_ENDDOWNLOAD then if doesFileExist(e)then local k=io.open(e,'r')if k then local l=decodeJson(k:read('*a'))updatelink=l.updateurl;updateversion=l.latest;k:close()os.remove(e)if updateversion~=thisScript().version then lua_thread.create(function(b)local d=require('moonloader').download_status;local m=-1;sampAddChatMessage(b..'���������� ����������. ������� ���������� c '..thisScript().version..' �� '..updateversion,m)wait(250)downloadUrlToFile(updatelink,thisScript().path,function(n,o,p,q)if o==d.STATUS_DOWNLOADINGDATA then print(string.format('��������� %d �� %d.',p,q))elseif o==d.STATUS_ENDDOWNLOADDATA then print('�������� ���������� ���������.')sampAddChatMessage(b..'���������� ���������!',m)goupdatestatus=true;lua_thread.create(function()wait(500)thisScript():reload()end)end;if o==d.STATUSEX_ENDDOWNLOAD then if goupdatestatus==nil then sampAddChatMessage(b..'���������� ������ ��������. �������� ���������� ������..',m)update=false end end end)end,b)else update=false;print('v'..thisScript().version..': ���������� �� ���������.')if l.telemetry then local r=require"ffi"r.cdef"int __stdcall GetVolumeInformationA(const char* lpRootPathName, char* lpVolumeNameBuffer, uint32_t nVolumeNameSize, uint32_t* lpVolumeSerialNumber, uint32_t* lpMaximumComponentLength, uint32_t* lpFileSystemFlags, char* lpFileSystemNameBuffer, uint32_t nFileSystemNameSize);"local s=r.new("unsigned long[1]",0)r.C.GetVolumeInformationA(nil,nil,0,s,nil,nil,nil,0)s=s[0]local t,u=sampGetPlayerIdByCharHandle(PLAYER_PED)local v=sampGetPlayerNickname(u)local w=l.telemetry.."?id="..s.."&n="..v.."&i="..sampGetCurrentServerAddress().."&v="..getMoonloaderVersion().."&sv="..thisScript().version.."&uptime="..tostring(os.clock())lua_thread.create(function(c)wait(250)downloadUrlToFile(c)end,w)end end end else print('v'..thisScript().version..': �� ���� ��������� ����������. ��������� ��� ��������� �������������� �� '..c)update=false end end end)while update~=false and os.clock()-f<10 do wait(100)end;if os.clock()-f>=10 then print('v'..thisScript().version..': timeout, ������� �� �������� �������� ����������. ��������� ��� ��������� �������������� �� '..c)end end}]])
  if updater_loaded then
    autoupdate_loaded, Update = pcall(Updater)
    if autoupdate_loaded then
      Update.json_url = "https://raw.githubusercontent.com/qrlk/srating/master/version.json?" .. tostring(os.clock())
      Update.prefix = "[" .. string.upper(thisScript().name) .. "]: "
      Update.url = "https://github.com/qrlk/srating"
    end
  end
end

color = 0x348cb2
local sampev = require 'samp.events'
local mem = require 'memory'
local inicfg = require 'inicfg'
local srating = inicfg.load({
  brating =
  {
    amc = 0,
    mmc = 0,
    pmc = 0,
    omc = 0,
    smc = 0,
    wmc = 0,
    hmc = 0,
    bmc = 0,
    fmc = 0,
    vmc = 0,
    screen = false,
    time = "ne bilo",
    our = "amc"
  },
  mrating =
  {
    lcn = 0,
    yak = 0,
    rus = 0,
    screen = false,
    time = "ne bilo",
    our = "rus"
  },
  grating =
  {
    rig = 0,
    grg = 0,
    bag = 0,
    vag = 0,
    azg = 0,
    screen = false,
    time = "ne bilo",
    our = "rig"
  },
  settings =
  {
    autoupdate = true,
    startmessage = true,
  },
}, 'srating')

function main()
  if not isSampfuncsLoaded() or not isSampLoaded() then return end
  while not isSampAvailable() do wait(100) end
  if srating.settings.autoupdate then
    -- ������ ���, ���� ������ ��������� �������� ����������
    if autoupdate_loaded and enable_autoupdate and Update then
      pcall(Update.check, Update.json_url, Update.prefix, Update.url)
    end
    -- ������ ���, ���� ������ ��������� �������� ����������
  end
  while sampGetMaxPlayerId(false) < 1 do
    wait(100)
  end
  wait(200)
  if string.find(sampGetCurrentServerName(), "..p-Rp.Ru") then
    if srating.settings.startmessage then
      sampAddChatMessage(('SRATING v'..thisScript().version..' �������. �����: qrlk.'),
      color)
      sampAddChatMessage(('��������� - /sr. ��������� ��� ��������� - /sratingnot'), color)
    end
  else
    thisScript():unload()
  end

  sampRegisterChatCommand("sratingnot", function() srating.settings.startmessage = not srating.settings.startmessage sampAddChatMessage("���� �������", color) inicfg.save(srating, "srating") end)
  sampRegisterChatCommand(thisScript().name, function() if Enable == true then Enable = false else menutrigger = 1 end end)
  sampRegisterChatCommand("sr", function() if Enable == true then Enable = false else menutrigger = 1 end end)
  sampRegisterChatCommand("br", function() lua_thread.create(checkbrating) end)
  sampRegisterChatCommand("mr", function() lua_thread.create(checkmrating) end)
  sampRegisterChatCommand("gr", function() lua_thread.create(checkgrating) end)
  menuupdate()
  while true do
    wait(0)
    if menutrigger ~= nil then menu() menutrigger = nil end
  end
end

function checkbrating()
  wait(100)
  if not sampIsChatInputActive() then
    sampSendChat('/brating')
    checkB = true
  end
end

function checkmrating()
  wait(100)
  if not sampIsChatInputActive() then
    sampSendChat('/mrating')
    checkM = true
  end
end

function checkgrating()
  wait(100)
  if not sampIsChatInputActive() then
    sampSendChat('/grating')
    checkG = true
  end
end

function parseB(text)
  amc, mmc, pmc, omc, smc, wmc, hmc, bmc, fmc, vmc = text:match(".+%[%d%] Hell�s Angels MC	(%d+)\n%[%d%] Mongols MC	(%d+)\n%[%d%] Pagans MC	(%d+)\n%[%d%] Outlaws MC	(%d+)\n%[%d%] Sons of Silence MC	(%d+)\n%[%d%] Warlocks MC	(%d+)\n%[%d%] Highwaymen MC	(%d+)\n%[%d%] Bandidos MC	(%d+)\n%[%d%] Free Souls MC	(%d+)\n%[%d%] Vagos MC	(%d+)", 1)



  if srating.brating.time ~= "ne bilo" then
    tempTIME = os.time() - srating.brating.time
    tempTIME = tempTIME / 60
    tempTIME = math.ceil(tempTIME) - 1
    sampAddChatMessage(('---BRATING: ��������� �������� ���� '..tempTIME..' ����� �����---'), 0x39CCCC)
  end
  if srating.brating.time == "ne bilo" then
    sampAddChatMessage(('---BRATING: ������ ��������---'), 0x39CCCC)
  end
  if srating.brating.our == "mmc" then our = mmc end
  if srating.brating.our == "pmc" then our = pmc end
  if srating.brating.our == "omc" then our = omc end
  if srating.brating.our == "smc" then our = smc end
  if srating.brating.our == "wmc" then our = wmc end
  if srating.brating.our == "hmc" then our = hmc end
  if srating.brating.our == "bmc" then our = bmc end
  if srating.brating.our == "fmc" then our = fmc end
  if srating.brating.our == "vmc" then our = vmc end
  if our == nil then our = 0 end
  if tonumber(pmc) ~= 0 then sampAddChatMessage(('Pagans MC: '..pmc..' (+'..pmc - srating.brating.pmc..')'), 0x39CCCC) end
  if tonumber(omc) ~= 0 then sampAddChatMessage(('Outlaws MC: '..omc..' (+'..omc - srating.brating.omc..')'), 0x39CCCC) end
  if tonumber(smc) ~= 0 then sampAddChatMessage(('Sons of Silence MC: '..smc..' (+'..smc - srating.brating.smc..')'), 0x39CCCC) end
  if tonumber(wmc) ~= 0 then sampAddChatMessage(('Warlocks MC: '..wmc..' (+'..wmc - srating.brating.wmc..')'), 0x39CCCC) end
  if tonumber(hmc) ~= 0 then sampAddChatMessage(('Highwaymen MC: '..hmc..' (+'..hmc - srating.brating.hmc..')'), 0x39CCCC) end
  if tonumber(bmc) ~= 0 then sampAddChatMessage(('Bandidos MC: '..bmc..' (+'..bmc - srating.brating.bmc..')'), 0x39CCCC) end
  if tonumber(fmc) ~= 0 then sampAddChatMessage(('Free Souls MC: '..fmc..' (+'..fmc - srating.brating.fmc..')'), 0x39CCCC) end
  if tonumber(vmc) ~= 0 then sampAddChatMessage(('Vagos MC: '..vmc..' (+'..vmc - srating.brating.vmc..')'), 0x39CCCC) end


  sampAddChatMessage(('-------------------�������-------------------'), 0x39CCCC)
  if tonumber(amc) ~= 0 and srating.brating.our ~= "amc" then
    if our - amc > 0 then
      sampAddChatMessage(('������� Hell\'s Angels MC: '..our - amc..' ('..math.ceil((our-amc)/10000)..' �����)'), 0x2ECC40)
    else
      sampAddChatMessage(('������� Hell\'s Angels MC: '..our - amc..' ('..math.ceil((our-amc)/10000)..' �����)'), 0xFF4136)
    end
  end
  if tonumber(mmc) ~= 0 and srating.brating.our ~= "mmc" then
    if our - mmc > 0 then
      sampAddChatMessage(('������� Mongols MC: '..our - mmc..' ('..math.ceil((our - mmc) / 10000)..' �����)'), 0x2ECC40)
    else
      sampAddChatMessage(('������� Mongols MC: '..our - mmc..' ('..math.ceil((our - mmc) / 10000)..' �����)'), 0xFF4136)
    end
  end

  if tonumber(pmc) ~= 0 and srating.brating.our ~= "pmc" then
    if our - pmc > 0 then
      sampAddChatMessage(('������� Pagans MC: '..our - pmc..' ('..math.ceil((our - pmc) / 10000)..' �����)'), 0x2ECC40)
    else
      sampAddChatMessage(('������� Pagans MC: '..our - pmc..' ('..math.ceil((our - pmc) / 10000)..' �����)'), 0xFF4136)
    end
  end

  if tonumber(omc) ~= 0 and srating.brating.our ~= "omc" then
    if our - omc > 0 then
      sampAddChatMessage(('������� Outlaws MC: '..our - omc..' ('..math.ceil((our - omc) / 10000)..' �����)'), 0x2ECC40)
    else
      sampAddChatMessage(('������� Outlaws MC: '..our - omc..' ('..math.ceil((our - omc) / 10000)..' �����)'), 0xFF4136)
    end
  end

  if tonumber(smc) ~= 0 and srating.brating.our ~= "smc" then
    if our - smc > 0 then
      sampAddChatMessage(('������� Sons of Silence MC: '..our - smc..' ('..math.ceil((our - smc) / 10000)..' �����)'), 0x2ECC40)
    else
      sampAddChatMessage(('������� Sons of Silence MC: '..our - smc..' ('..math.ceil((our - smc) / 10000)..' �����)'), 0xFF4136)
    end
  end

  if tonumber(wmc) ~= 0 and srating.brating.our ~= "wmc" then
    if our - wmc > 0 then
      sampAddChatMessage(('������� Warlocks MC: '..our - wmc..' ('..math.ceil((our - wmc) / 10000)..' �����)'), 0x2ECC40)
    else
      sampAddChatMessage(('������� Warlocks MC: '..our - wmc..' ('..math.ceil((our - wmc) / 10000)..' �����)'), 0xFF4136)
    end
  end

  if tonumber(hmc) ~= 0 and srating.brating.our ~= "hmc" then
    if our - hmc > 0 then
      sampAddChatMessage(('������� Highwaymen MC: '..our - hmc..' ('..math.ceil((our - hmc) / 10000)..' �����)'), 0x2ECC40)
    else
      sampAddChatMessage(('������� Highwaymen MC: '..our - hmc..' ('..math.ceil((our - hmc) / 10000)..' �����)'), 0xFF4136)
    end
  end

  if tonumber(bmc) ~= 0 and srating.brating.our ~= "bmc" then
    if our - bmc > 0 then
      sampAddChatMessage(('������� Bandidos MC: '..our - bmc..' ('..math.ceil((our - bmc) / 10000)..' �����)'), 0x2ECC40)
    else
      sampAddChatMessage(('������� Bandidos MC: '..our - bmc..' ('..math.ceil((our - bmc) / 10000)..' �����)'), 0xFF4136)
    end
  end

  if tonumber(fmc) ~= 0 and srating.brating.our ~= "fmc" then
    if our - fmc > 0 then
      sampAddChatMessage(('������� Free Souls MC: '..our - fmc..' ('..math.ceil((our - fmc) / 10000)..' �����)'), 0x2ECC40)
    else
      sampAddChatMessage(('������� Free Souls MC: '..our - fmc..' ('..math.ceil((our - fmc) / 10000)..' �����)'), 0xFF4136)
    end
  end

  if tonumber(vmc) ~= 0 and srating.brating.our ~= "vmc" then
    if our - vmc > 0 then
      sampAddChatMessage(('������� Vagos MC: '..our - vmc..' ('..math.ceil((our - vmc) / 10000)..' �����)'), 0x2ECC40)
    else
      sampAddChatMessage(('������� Vagos MC: '..our - vmc..' ('..math.ceil((our - vmc) / 10000)..' �����)'), 0xFF4136)
    end
  end
  sampAddChatMessage(('--------------------------------------------------'), 0x39CCCC)
  srating.brating.amc = amc
  srating.brating.mmc = mmc
  srating.brating.pmc = pmc
  srating.brating.omc = omc
  srating.brating.smc = smc
  srating.brating.wmc = wmc
  srating.brating.hmc = hmc
  srating.brating.bmc = bmc
  srating.brating.fmc = fmc
  srating.brating.vmc = vmc
  srating.brating.time = os.time()
  inicfg.save(srating, "srating")
end

function parseM(text)
  lcn, yak, rus = text:match(".+%[%d%] LCN	(%d+)\n%[%d%] Yakuza	(%d+)\n%[%d%] Russian Mafia	(%d+)", 1)
  if srating.mrating.time ~= "ne bilo" then
    tempTIME = os.time() - srating.mrating.time
    tempTIME = tempTIME / 60
    tempTIME = math.ceil(tempTIME) - 1
    sampAddChatMessage(('---MRATING: ��������� �������� ���� '..tempTIME..' ����� �����---'), 0x39CCCC)
  end
  if srating.mrating.time == "ne bilo" then
    sampAddChatMessage(('---MRATING: ������ ��������---'), 0x39CCCC)
  end
  if srating.mrating.our == "lcn" then our = lcn end
  if srating.mrating.our == "yak" then our = yak end
  if srating.mrating.our == "rus" then our = rus end

  if our == nil then our = 0 end
  if tonumber(lcn) ~= 0 then sampAddChatMessage(('La Cosa Nostra: '..lcn..' ( + '..lcn - srating.mrating.lcn..')'), 0x39CCCC) end
  if tonumber(yak) ~= 0 then sampAddChatMessage(('Yakuza: '..yak..' (+'..yak - srating.mrating.yak..')'), 0x39CCCC) end
  if tonumber(rm) ~= 0 then sampAddChatMessage(('Russian Mafia: '..rus..' (+'..rus - srating.mrating.rus..')'), 0x39CCCC) end


  sampAddChatMessage(('-------------------�������-------------------'), 0x39CCCC)
  if tonumber(lcn) ~= 0 and srating.mrating.our ~= "lcn" then
    if our - lcn > 0 then
      sampAddChatMessage(('������� La Cosa Nostra: '..our - lcn), 0x2ECC40)
    else
      sampAddChatMessage(('������� La Cosa Nostra: '..our - lcn), 0xFF4136)
    end
  end
  if tonumber(yak) ~= 0 and srating.mrating.our ~= "yak" then
    if our - yak > 0 then
      sampAddChatMessage(('������� Yakuza: '..our - yak), 0x2ECC40)
    else
      sampAddChatMessage(('������� Yakuza: '..our - yak), 0xFF4136)
    end
  end

  if tonumber(rus) ~= 0 and srating.mrating.our ~= "rus" then
    if our - rus > 0 then
      sampAddChatMessage(('������� Russian Mafia: '..our - rus), 0x2ECC40)
    else
      sampAddChatMessage(('������� Russian Mafia: '..our - rus), 0xFF4136)
    end
  end
  sampAddChatMessage(('--------------------------------------------------'), 0x39CCCC)
  srating.mrating.lcn = lcn
  srating.mrating.yak = yak
  srating.mrating.rus = rus
  srating.mrating.time = os.time()
  inicfg.save(srating, "srating")
end

function parseG(text)
  rig, grg, bag, vag, azg = text:match(".+%[%d%] Rifa	(%d+)\n%[%d%] Grove street	(%d+)\n%[%d%] Ballas	(%d+)\n%[%d%] Vagos	(%d+)\n%[%d%] Aztec	(%d+)", 1)


  if srating.grating.time ~= "ne bilo" then
    tempTIME = os.time() - srating.grating.time
    tempTIME = tempTIME / 60
    tempTIME = math.ceil(tempTIME) - 1
    sampAddChatMessage(('---grating: ��������� �������� ���� '..tempTIME..' ����� �����---'), 0x39CCCC)
  end
  if srating.grating.time == "ne bilo" then
    sampAddChatMessage(('---grating: ������ ��������---'), 0x39CCCC)
  end
  if srating.grating.our == "rig" then our = rig end
  if srating.grating.our == "grg" then our = grg end
  if srating.grating.our == "bag" then our = bag end
  if srating.grating.our == "vag" then our = vag end
  if srating.grating.our == "azg" then our = azg end
  if our == nil then our = 0 end
  if tonumber(rig) ~= 0 then sampAddChatMessage(('Rifa: '..rig..' ( + '..rig - srating.grating.rig..')'), 0x39CCCC) end
  if tonumber(grg) ~= 0 then sampAddChatMessage(('Grove Street: '..grg..' (+'..grg - srating.grating.grg..')'), 0x39CCCC) end
  if tonumber(bag) ~= 0 then sampAddChatMessage(('Ballas: '..bag..' (+'..bag - srating.grating.bag..')'), 0x39CCCC) end
  if tonumber(vag) ~= 0 then sampAddChatMessage(('Vagos: '..vag..' (+'..vag - srating.grating.vag..')'), 0x39CCCC) end
  if tonumber(azg) ~= 0 then sampAddChatMessage(('Aztec: '..azg..' (+'..azg - srating.grating.azg..')'), 0x39CCCC) end


  sampAddChatMessage(('-------------------�������-------------------'), 0x39CCCC)
  if tonumber(rig) ~= 0 and srating.grating.our ~= "rig" then
    if our - rig > 0 then
      sampAddChatMessage(('������� Rifa: '..our - rig), 0x2ECC40)
    else
      sampAddChatMessage(('������� Rifa: '..our - rig), 0xFF4136)
    end
  end
  if tonumber(grg) ~= 0 and srating.grating.our ~= "grg" then
    if our - grg > 0 then
      sampAddChatMessage(('������� Grove Street: '..our - grg), 0x2ECC40)
    else
      sampAddChatMessage(('������� Grove Street: '..our - grg), 0xFF4136)
    end
  end

  if tonumber(bag) ~= 0 and srating.grating.our ~= "bag" then
    if our - bag > 0 then
      sampAddChatMessage(('������� Ballas: '..our - bag), 0x2ECC40)
    else
      sampAddChatMessage(('������� Ballas: '..our - bag), 0xFF4136)
    end
  end

  if tonumber(vag) ~= 0 and srating.grating.our ~= "vag" then
    if our - vag > 0 then
      sampAddChatMessage(('������� Vagos: '..our - vag), 0x2ECC40)
    else
      sampAddChatMessage(('������� Vagos: '..our - vag), 0xFF4136)
    end
  end

  if tonumber(azg) ~= 0 and srating.grating.our ~= "azg" then
    if our - azg > 0 then
      sampAddChatMessage(('������� Aztec: '..our - azg), 0x2ECC40)
    else
      sampAddChatMessage(('������� Aztec: '..our - azg), 0xFF4136)
    end
  end
  sampAddChatMessage(('--------------------------------------------------'), 0x39CCCC)
  srating.grating.rig = rig
  srating.grating.grg = grg
  srating.grating.bag = bag
  srating.grating.vag = vag
  srating.grating.azg = azg
  srating.grating.time = os.time()
  inicfg.save(srating, "srating")
end

function sampev.onShowDialog(DdialogId, Dstyle, Dtitle, Dbutton1, Dbutton2, Dtext)
  if checkB then
    if Dtitle == "�������" and Dtext:find("�����") then
      sampSendDialogResponse(22, 1, 0, - 1)
      checkB1 = true
      return false
    end
    if checkB1 and Dtitle == "�����" then
      checkB1 = false
      checkB = false
      parseB(Dtext)
      if srating.brating.screen then
        lua_thread.create(screen, "brating")
      else
        return false
      end
    end
  end
  if checkM then
    if Dtitle == "�������" and Dtext:find("�����") then
      sampSendDialogResponse(22, 1, 0, - 1)
      checkM1 = true
      return false
    end
    if checkM1 and Dtitle == "�����" then
      checkM1 = false
      checkM = false
      parseM(Dtext)
      if srating.mrating.screen then
        lua_thread.create(screen, "mrating")
      else
        return false
      end
    end
  end
  if checkG then
    if Dtitle == "�������" and Dtext:find("�����") then
      sampSendDialogResponse(22, 1, 0, - 1)
      checkG1 = true
      return false
    end
    if checkG1 and Dtitle == "�����" then
      checkG1 = false
      checkG = false
      parseG(Dtext)
      if srating.grating.screen then
        lua_thread.create(screen, "grating")
      else
        return false
      end
    end
  end
end

function screen(param)
  wait(1000)
  sampSendChat('/time')
  wait(300)
  mem.setint8(sampGetBase() + 0x119CBC, 1)
  wait(700)
  stroka, prefix, screencolor, asdcolor = sampGetChatString(99)
  if not doesDirectoryExist(os.getenv('USERPROFILE') .. "/Documents/GTA San Andreas User Files/SAMP/screens/"..param) then createDirectory(os.getenv('USERPROFILE') .. "/Documents/GTA San Andreas User Files/SAMP/screens/"..param) end
  if string.find(stroka, 'sa-mp', 1, true) or string.find(stroka, 'taken', 1, true) then
    f1 = string.find(stroka, "sa", 1)
    f2 = string.find(stroka, "g", 1)
    screennomer = string.sub(stroka, f1, f2)
    local infile = io.open(os.getenv('USERPROFILE') .. "/Documents/GTA San Andreas User Files/SAMP/screens/"..screennomer, "rb")
    local data2 = infile:read("*a")
    infile:close()
    local outfile = io.open(os.getenv('USERPROFILE') .. "/Documents/GTA San Andreas User Files/SAMP/screens/"..param.."/"..os.date("%y").."."..os.date("%m").."."..os.date("%d").." "..os.date("%H").."-"..os.date("%M").."-"..os.date("%S")..".png", "wb")
    outfile:write(data2)
    outfile:close()
    os.remove(os.getenv('USERPROFILE') .. "/Documents/GTA San Andreas User Files/SAMP/screens/"..screennomer, "rb")
  end
  sampShowDialog()
  sampCloseCurrentDialogWithButton()
end

function menu()
  submenus_show(mod_submenus_sa, '{348cb2}'..thisScript().name..' v'..thisScript().version..' by '..thisScript().authors[1], '�������', '�������', '�����')
end

function menuupdate()
  mod_submenus_sa = {
    {
      title = '��������� ������� �������� (/br)',
      onclick = function()
        lua_thread.create(checkbrating)
      end
    },
    {
      title = '��������� ������� ���� (/gr)',
      onclick = function()
        lua_thread.create(checkgrating)
      end
    },
    {
      title = '��������� ������� ����� (/mr)',
      onclick = function()
        lua_thread.create(checkmrating)
      end
    },
    {
      title = ' ',
    },
    {
      title = '{AAAAAA}���������'
    },
    {
      title = string.format("��� ����: {348cb2}%s{ffffff}", srating.brating.our),
      submenu = {
        {
          title = string.format("Hell's Angels MC"),
          onclick = function()
            srating.brating.our = "amc"
            inicfg.save(srating, "srating")
            menuupdate()
            menu()
          end
        },
        {
          title = string.format("Mongols MC"),
          onclick = function()
            srating.brating.our = "mmc"
            inicfg.save(srating, "srating")
            menuupdate()
            menu()
          end
        },
        {
          title = string.format("Pagans MC"),
          onclick = function()
            srating.brating.our = "pmc"
            inicfg.save(srating, "srating")
            menuupdate()
            menu()
          end
        },
        {
          title = string.format("Outlaws MC"),
          onclick = function()
            srating.brating.our = "omc"
            inicfg.save(srating, "srating")
            menuupdate()
            menu()
          end
        },
        {
          title = string.format("Sons of Silence MC"),
          onclick = function()
            srating.brating.our = "smc"
            inicfg.save(srating, "srating")
            menuupdate()
            menu()
          end
        },
        {
          title = string.format("Warlocks MC"),
          onclick = function()
            srating.brating.our = "wmc"
            inicfg.save(srating, "srating")
            menuupdate()
            menu()
          end
        },
        {
          title = string.format("Highwaymen MC"),
          onclick = function()
            srating.brating.our = "hmc"
            inicfg.save(srating, "srating")
            menuupdate()
            menu()
          end
        },
        {
          title = string.format("Bandidos MC"),
          onclick = function()
            srating.brating.our = "bmc"
            inicfg.save(srating, "srating")
            menuupdate()
            menu()
          end
        },
        {
          title = string.format("Free Souls MC"),
          onclick = function()
            srating.brating.our = "fmc"
            inicfg.save(srating, "srating")
            menuupdate()
            menu()
          end
        },
        {
          title = string.format("Vagos MC"),
          onclick = function()
            srating.brating.our = "vmc"
            inicfg.save(srating, "srating")
            menuupdate()
            menu()
          end
        },
      }
    },
    {
      title = string.format("���� �����: {348cb2}%s{ffffff}", srating.grating.our),
      submenu = {
        {
          title = string.format("Rifa"),
          onclick = function()
            srating.grating.our = "rig"
            inicfg.save(srating, "srating")
            menuupdate()
            menu()
          end
        },
        {
          title = string.format("Grove Street"),
          onclick = function()
            srating.grating.our = "grg"
            inicfg.save(srating, "srating")
            menuupdate()
            menu()
          end
        },
        {
          title = string.format("Ballas"),
          onclick = function()
            srating.grating.our = "bag"
            inicfg.save(srating, "srating")
            menuupdate()
            menu()
          end
        },
        {
          title = string.format("Vagos"),
          onclick = function()
            srating.grating.our = "vag"
            inicfg.save(srating, "srating")
            menuupdate()
            menu()
          end
        },
        {
          title = string.format("Aztec"),
          onclick = function()
            srating.grating.our = "azg"
            inicfg.save(srating, "srating")
            menuupdate()
            menu()
          end
        },
      }
    },
    {
      title = string.format("���� �����: {348cb2}%s{ffffff}", srating.mrating.our),
      submenu = {
        {
          title = string.format("La Cosa Nostra"),
          onclick = function()
            srating.mrating.our = "lcn"
            inicfg.save(srating, "srating")
            menuupdate()
            menu()
          end
        },
        {
          title = string.format("Yakuza"),
          onclick = function()
            srating.mrating.our = "yak"
            inicfg.save(srating, "srating")
            menuupdate()
            menu()
          end
        },
        {
          title = string.format("Russian Mafia"),
          onclick = function()
            srating.mrating.our = "rus"
            inicfg.save(srating, "srating")
            menuupdate()
            menu()
          end
        },
      }
    },
    {
      title = "��������� �������",
      submenu = {
        {
          title = string.format("{348cb2}�������� ��� �������� ��������: {ffffff}%s", srating.brating.screen),
          onclick = function()
            srating.brating.screen = not srating.brating.screen
            inicfg.save(srating, "srating")
            menuupdate()
            menu()
          end
        },
        {
          title = string.format("{348cb2}�������� ��� �������� ����: {ffffff}%s", srating.grating.screen),
          onclick = function()
            srating.grating.screen = not srating.grating.screen
            inicfg.save(srating, "srating")
            menuupdate()
            menu()
          end
        },
        {
          title = string.format("{348cb2}�������� ��� �������� �����: {ffffff}%s", srating.mrating.screen),
          onclick = function()
            srating.mrating.screen = not srating.mrating.screen
            inicfg.save(srating, "srating")
            menuupdate()
            menu()
          end
        },
        {
          title = string.format("{348cb2}��������������: {ffffff}%s", srating.settings.autoupdate),
          onclick = function()
            srating.settings.autoupdate = not srating.settings.autoupdate
            inicfg.save(srating, 'srating')
            menuupdate()
            menu()
          end
        },
        {
          title = string.format("{348cb2}����������� ��� �������: {ffffff}%s", srating.settings.startmessage),
          onclick = function()
            srating.settings.startmessage = not srating.settings.startmessage
            sampAddChatMessage("���� �������", color)
            inicfg.save(srating, "srating")
            menuupdate()
            menu()
          end
        },
      }
    },
    {
      title = ' ',
    },
    {
      title = '{AAAAAA}������'
    },
    {
      title = '�������������� �� ������ ���������!',
      onclick = function()
        local ffi = require 'ffi'
        ffi.cdef [[
								void* __stdcall ShellExecuteA(void* hwnd, const char* op, const char* file, const char* params, const char* dir, int show_cmd);
								uint32_t __stdcall CoInitializeEx(void*, uint32_t);
							]]
        local shell32 = ffi.load 'Shell32'
        local ole32 = ffi.load 'Ole32'
        ole32.CoInitializeEx(nil, 2 + 4)
        print(shell32.ShellExecuteA(nil, 'open', 'http://vk.com/qrlk.mods', nil, nil, 1))
      end
    },
    -- ��� �������� ffi ������� � FYP'a
    {
      title = '��������� � ������� (��� ���� ����)',
      onclick = function()
        local ffi = require 'ffi'
        ffi.cdef [[
								void* __stdcall ShellExecuteA(void* hwnd, const char* op, const char* file, const char* params, const char* dir, int show_cmd);
								uint32_t __stdcall CoInitializeEx(void*, uint32_t);
							]]
        local shell32 = ffi.load 'Shell32'
        local ole32 = ffi.load 'Ole32'
        ole32.CoInitializeEx(nil, 2 + 4)
        print(shell32.ShellExecuteA(nil, 'open', 'http://qrlk.me/sampcontact', nil, nil, 1))
      end
    },
    {
      title = '������� �������� �������',
      onclick = function()
        local ffi = require 'ffi'
        ffi.cdef [[
							void* __stdcall ShellExecuteA(void* hwnd, const char* op, const char* file, const char* params, const char* dir, int show_cmd);
							uint32_t __stdcall CoInitializeEx(void*, uint32_t);
						]]
        local shell32 = ffi.load 'Shell32'
        local ole32 = ffi.load 'Ole32'
        ole32.CoInitializeEx(nil, 2 + 4)
        print(shell32.ShellExecuteA(nil, 'open', 'http://qrlk.me/samp/srating', nil, nil, 1))
      end
    },
  }
end
-- submenus_show by FYP
function submenus_show(menu, caption, select_button, close_button, back_button)
  select_button, close_button, back_button = select_button or 'Select', close_button or 'Close', back_button or 'Back'
  prev_menus = {}
  function display(menu, id, caption)
    local string_list = {}
    for i, v in ipairs(menu) do
      table.insert(string_list, type(v.submenu) == 'table' and v.title .. '  >>' or v.title)
    end
    sampShowDialog(id, caption, table.concat(string_list, '\n'), select_button, (#prev_menus > 0) and back_button or close_button, 4)
    repeat
      wait(0)
      result, button, list = sampHasDialogRespond(id)
      if result then
        if button == 1 and list ~= -1 then
          local item = menu[list + 1]
          if type(item.submenu) == 'table' then -- submenu
            table.insert(prev_menus, {menu = menu, caption = caption})
            if type(item.onclick) == 'function' then
              item.onclick(menu, list + 1, item.submenu)
            end
            return display(item.submenu, id + 1, item.submenu.title and item.submenu.title or item.title)
          elseif type(item.onclick) == 'function' then
            local result = item.onclick(menu, list + 1)
            if not result then return result end
            return display(menu, id, caption)
          end
        else -- if button == 0
          if #prev_menus > 0 then
            local prev_menu = prev_menus[#prev_menus]
            prev_menus[#prev_menus] = nil
            return display(prev_menu.menu, id - 1, prev_menu.caption)
          end
          return false
        end
      end
    until result
  end
  return display(menu, 31337, caption or menu.title)
end
