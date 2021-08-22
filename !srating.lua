require 'lib.moonloader'

script_name('srating')
script_version("20.03.2019")
script_authors("qrlk")
script_dependencies("SAMP.lua", "sampfuncs", "cleo")
script_description("Быстрый чекер рейтинга криминала для Samp-Rp.")
script_url("https://github.com/qrlk/srating")

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
    update("http://qrlk.me/dev/moonloader/srating/stats.php", '['..string.upper(thisScript().name)..']: ', "http://vk.com/qrlk.mods", "sratingchangelog")
  end
  openchangelog("sratingchangelog", "http://qrlk.me/changelog/srating")
  while sampGetMaxPlayerId(false) < 1 do
    wait(100)
  end
  wait(200)
  if string.find(sampGetCurrentServerName(), "..p-Rp.Ru") then
    if srating.settings.startmessage then
      sampAddChatMessage(('SRATING v'..thisScript().version..' запущен. Автор: qrlk.'),
      color)
      sampAddChatMessage(('Подробнее - /sr. Отключить это сообщение - /sratingnot'), color)
    end
  else
    thisScript():unload()
  end

  sampRegisterChatCommand("sratingnot", function() srating.settings.startmessage = not srating.settings.startmessage sampAddChatMessage("Дело сделано", color) inicfg.save(srating, "srating") end)
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
  amc, mmc, pmc, omc, smc, wmc, hmc, bmc, fmc, vmc = text:match(".+%[%d%] Hell’s Angels MC	(%d+)\n%[%d%] Mongols MC	(%d+)\n%[%d%] Pagans MC	(%d+)\n%[%d%] Outlaws MC	(%d+)\n%[%d%] Sons of Silence MC	(%d+)\n%[%d%] Warlocks MC	(%d+)\n%[%d%] Highwaymen MC	(%d+)\n%[%d%] Bandidos MC	(%d+)\n%[%d%] Free Souls MC	(%d+)\n%[%d%] Vagos MC	(%d+)", 1)



  if srating.brating.time ~= "ne bilo" then
    tempTIME = os.time() - srating.brating.time
    tempTIME = tempTIME / 60
    tempTIME = math.ceil(tempTIME) - 1
    sampAddChatMessage(('---BRATING: Последняя проверка была '..tempTIME..' минут назад---'), 0x39CCCC)
  end
  if srating.brating.time == "ne bilo" then
    sampAddChatMessage(('---BRATING: Первая проверка---'), 0x39CCCC)
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


  sampAddChatMessage(('-------------------РАЗНИЦА-------------------'), 0x39CCCC)
  if tonumber(amc) ~= 0 and srating.brating.our ~= "amc" then
    if our - amc > 0 then
      sampAddChatMessage(('Разница Hell\'s Angels MC: '..our - amc..' ('..math.ceil((our-amc)/10000)..' матов)'), 0x2ECC40)
    else
      sampAddChatMessage(('Разница Hell\'s Angels MC: '..our - amc..' ('..math.ceil((our-amc)/10000)..' матов)'), 0xFF4136)
    end
  end
  if tonumber(mmc) ~= 0 and srating.brating.our ~= "mmc" then
    if our - mmc > 0 then
      sampAddChatMessage(('Разница Mongols MC: '..our - mmc..' ('..math.ceil((our - mmc) / 10000)..' матов)'), 0x2ECC40)
    else
      sampAddChatMessage(('Разница Mongols MC: '..our - mmc..' ('..math.ceil((our - mmc) / 10000)..' матов)'), 0xFF4136)
    end
  end

  if tonumber(pmc) ~= 0 and srating.brating.our ~= "pmc" then
    if our - pmc > 0 then
      sampAddChatMessage(('Разница Pagans MC: '..our - pmc..' ('..math.ceil((our - pmc) / 10000)..' матов)'), 0x2ECC40)
    else
      sampAddChatMessage(('Разница Pagans MC: '..our - pmc..' ('..math.ceil((our - pmc) / 10000)..' матов)'), 0xFF4136)
    end
  end

  if tonumber(omc) ~= 0 and srating.brating.our ~= "omc" then
    if our - omc > 0 then
      sampAddChatMessage(('Разница Outlaws MC: '..our - omc..' ('..math.ceil((our - omc) / 10000)..' матов)'), 0x2ECC40)
    else
      sampAddChatMessage(('Разница Outlaws MC: '..our - omc..' ('..math.ceil((our - omc) / 10000)..' матов)'), 0xFF4136)
    end
  end

  if tonumber(smc) ~= 0 and srating.brating.our ~= "smc" then
    if our - smc > 0 then
      sampAddChatMessage(('Разница Sons of Silence MC: '..our - smc..' ('..math.ceil((our - smc) / 10000)..' матов)'), 0x2ECC40)
    else
      sampAddChatMessage(('Разница Sons of Silence MC: '..our - smc..' ('..math.ceil((our - smc) / 10000)..' матов)'), 0xFF4136)
    end
  end

  if tonumber(wmc) ~= 0 and srating.brating.our ~= "wmc" then
    if our - wmc > 0 then
      sampAddChatMessage(('Разница Warlocks MC: '..our - wmc..' ('..math.ceil((our - wmc) / 10000)..' матов)'), 0x2ECC40)
    else
      sampAddChatMessage(('Разница Warlocks MC: '..our - wmc..' ('..math.ceil((our - wmc) / 10000)..' матов)'), 0xFF4136)
    end
  end

  if tonumber(hmc) ~= 0 and srating.brating.our ~= "hmc" then
    if our - hmc > 0 then
      sampAddChatMessage(('Разница Highwaymen MC: '..our - hmc..' ('..math.ceil((our - hmc) / 10000)..' матов)'), 0x2ECC40)
    else
      sampAddChatMessage(('Разница Highwaymen MC: '..our - hmc..' ('..math.ceil((our - hmc) / 10000)..' матов)'), 0xFF4136)
    end
  end

  if tonumber(bmc) ~= 0 and srating.brating.our ~= "bmc" then
    if our - bmc > 0 then
      sampAddChatMessage(('Разница Bandidos MC: '..our - bmc..' ('..math.ceil((our - bmc) / 10000)..' матов)'), 0x2ECC40)
    else
      sampAddChatMessage(('Разница Bandidos MC: '..our - bmc..' ('..math.ceil((our - bmc) / 10000)..' матов)'), 0xFF4136)
    end
  end

  if tonumber(fmc) ~= 0 and srating.brating.our ~= "fmc" then
    if our - fmc > 0 then
      sampAddChatMessage(('Разница Free Souls MC: '..our - fmc..' ('..math.ceil((our - fmc) / 10000)..' матов)'), 0x2ECC40)
    else
      sampAddChatMessage(('Разница Free Souls MC: '..our - fmc..' ('..math.ceil((our - fmc) / 10000)..' матов)'), 0xFF4136)
    end
  end

  if tonumber(vmc) ~= 0 and srating.brating.our ~= "vmc" then
    if our - vmc > 0 then
      sampAddChatMessage(('Разница Vagos MC: '..our - vmc..' ('..math.ceil((our - vmc) / 10000)..' матов)'), 0x2ECC40)
    else
      sampAddChatMessage(('Разница Vagos MC: '..our - vmc..' ('..math.ceil((our - vmc) / 10000)..' матов)'), 0xFF4136)
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
    sampAddChatMessage(('---MRATING: Последняя проверка была '..tempTIME..' минут назад---'), 0x39CCCC)
  end
  if srating.mrating.time == "ne bilo" then
    sampAddChatMessage(('---MRATING: Первая проверка---'), 0x39CCCC)
  end
  if srating.mrating.our == "lcn" then our = lcn end
  if srating.mrating.our == "yak" then our = yak end
  if srating.mrating.our == "rus" then our = rus end

  if our == nil then our = 0 end
  if tonumber(lcn) ~= 0 then sampAddChatMessage(('La Cosa Nostra: '..lcn..' ( + '..lcn - srating.mrating.lcn..')'), 0x39CCCC) end
  if tonumber(yak) ~= 0 then sampAddChatMessage(('Yakuza: '..yak..' (+'..yak - srating.mrating.yak..')'), 0x39CCCC) end
  if tonumber(rm) ~= 0 then sampAddChatMessage(('Russian Mafia: '..rus..' (+'..rus - srating.mrating.rus..')'), 0x39CCCC) end


  sampAddChatMessage(('-------------------РАЗНИЦА-------------------'), 0x39CCCC)
  if tonumber(lcn) ~= 0 and srating.mrating.our ~= "lcn" then
    if our - lcn > 0 then
      sampAddChatMessage(('Разница La Cosa Nostra: '..our - lcn), 0x2ECC40)
    else
      sampAddChatMessage(('Разница La Cosa Nostra: '..our - lcn), 0xFF4136)
    end
  end
  if tonumber(yak) ~= 0 and srating.mrating.our ~= "yak" then
    if our - yak > 0 then
      sampAddChatMessage(('Разница Yakuza: '..our - yak), 0x2ECC40)
    else
      sampAddChatMessage(('Разница Yakuza: '..our - yak), 0xFF4136)
    end
  end

  if tonumber(rus) ~= 0 and srating.mrating.our ~= "rus" then
    if our - rus > 0 then
      sampAddChatMessage(('Разница Russian Mafia: '..our - rus), 0x2ECC40)
    else
      sampAddChatMessage(('Разница Russian Mafia: '..our - rus), 0xFF4136)
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
    sampAddChatMessage(('---grating: Последняя проверка была '..tempTIME..' минут назад---'), 0x39CCCC)
  end
  if srating.grating.time == "ne bilo" then
    sampAddChatMessage(('---grating: Первая проверка---'), 0x39CCCC)
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


  sampAddChatMessage(('-------------------РАЗНИЦА-------------------'), 0x39CCCC)
  if tonumber(rig) ~= 0 and srating.grating.our ~= "rig" then
    if our - rig > 0 then
      sampAddChatMessage(('Разница Rifa: '..our - rig), 0x2ECC40)
    else
      sampAddChatMessage(('Разница Rifa: '..our - rig), 0xFF4136)
    end
  end
  if tonumber(grg) ~= 0 and srating.grating.our ~= "grg" then
    if our - grg > 0 then
      sampAddChatMessage(('Разница Grove Street: '..our - grg), 0x2ECC40)
    else
      sampAddChatMessage(('Разница Grove Street: '..our - grg), 0xFF4136)
    end
  end

  if tonumber(bag) ~= 0 and srating.grating.our ~= "bag" then
    if our - bag > 0 then
      sampAddChatMessage(('Разница Ballas: '..our - bag), 0x2ECC40)
    else
      sampAddChatMessage(('Разница Ballas: '..our - bag), 0xFF4136)
    end
  end

  if tonumber(vag) ~= 0 and srating.grating.our ~= "vag" then
    if our - vag > 0 then
      sampAddChatMessage(('Разница Vagos: '..our - vag), 0x2ECC40)
    else
      sampAddChatMessage(('Разница Vagos: '..our - vag), 0xFF4136)
    end
  end

  if tonumber(azg) ~= 0 and srating.grating.our ~= "azg" then
    if our - azg > 0 then
      sampAddChatMessage(('Разница Aztec: '..our - azg), 0x2ECC40)
    else
      sampAddChatMessage(('Разница Aztec: '..our - azg), 0xFF4136)
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
    if Dtitle == "Рейтинг" and Dtext:find("Клубы") then
      sampSendDialogResponse(22, 1, 0, - 1)
      checkB1 = true
      return false
    end
    if checkB1 and Dtitle == "Клубы" then
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
    if Dtitle == "Рейтинг" and Dtext:find("Мафии") then
      sampSendDialogResponse(22, 1, 0, - 1)
      checkM1 = true
      return false
    end
    if checkM1 and Dtitle == "Мафии" then
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
    if Dtitle == "Рейтинг" and Dtext:find("Банды") then
      sampSendDialogResponse(22, 1, 0, - 1)
      checkG1 = true
      return false
    end
    if checkG1 and Dtitle == "Банды" then
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
  submenus_show(mod_submenus_sa, '{348cb2}'..thisScript().name..' v'..thisScript().version..' by '..thisScript().authors[1], 'Выбрать', 'Закрыть', 'Назад')
end

function menuupdate()
  mod_submenus_sa = {
    {
      title = 'Проверить рейтинг байкеров (/br)',
      onclick = function()
        lua_thread.create(checkbrating)
      end
    },
    {
      title = 'Проверить рейтинг банд (/gr)',
      onclick = function()
        lua_thread.create(checkgrating)
      end
    },
    {
      title = 'Проверить рейтинг мафий (/mr)',
      onclick = function()
        lua_thread.create(checkmrating)
      end
    },
    {
      title = ' ',
    },
    {
      title = '{AAAAAA}Настройки'
    },
    {
      title = string.format("Ваш клуб: {348cb2}%s{ffffff}", srating.brating.our),
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
      title = string.format("Ваша банда: {348cb2}%s{ffffff}", srating.grating.our),
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
      title = string.format("Ваша мафия: {348cb2}%s{ffffff}", srating.mrating.our),
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
      title = "Настройки скрипта",
      submenu = {
        {
          title = string.format("{348cb2}Скриншот для рейтинга байкеров: {ffffff}%s", srating.brating.screen),
          onclick = function()
            srating.brating.screen = not srating.brating.screen
            inicfg.save(srating, "srating")
            menuupdate()
            menu()
          end
        },
        {
          title = string.format("{348cb2}Скриншот для рейтинга банд: {ffffff}%s", srating.grating.screen),
          onclick = function()
            srating.grating.screen = not srating.grating.screen
            inicfg.save(srating, "srating")
            menuupdate()
            menu()
          end
        },
        {
          title = string.format("{348cb2}Скриншот для рейтинга мафий: {ffffff}%s", srating.mrating.screen),
          onclick = function()
            srating.mrating.screen = not srating.mrating.screen
            inicfg.save(srating, "srating")
            menuupdate()
            menu()
          end
        },
        {
          title = string.format("{348cb2}Автообновление: {ffffff}%s", srating.settings.autoupdate),
          onclick = function()
            srating.settings.autoupdate = not srating.settings.autoupdate
            inicfg.save(srating, 'srating')
            menuupdate()
            menu()
          end
        },
        {
          title = string.format("{348cb2}Уведомление при запуске: {ffffff}%s", srating.settings.startmessage),
          onclick = function()
            srating.settings.startmessage = not srating.settings.startmessage
            sampAddChatMessage("Дело сделано", color)
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
      title = '{AAAAAA}Ссылки'
    },
    {
      title = 'Подписывайтесь на группу ВКонтакте!',
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
    -- код директив ffi спизжен у FYP'a
    {
      title = 'Связаться с автором (все баги сюда)',
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
      title = 'Открыть страницу скрипта',
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
--------------------------------------------------------------------------------
------------------------------------UPDATE--------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
------------------------------------UPDATE--------------------------------------
--------------------------------------------------------------------------------
function update(php, prefix, url, komanda)
  komandaA = komanda
  local dlstatus = require('moonloader').download_status
  local json = getWorkingDirectory() .. '\\'..thisScript().name..'-version.json'
  if doesFileExist(json) then os.remove(json) end
  local ffi = require 'ffi'
  ffi.cdef[[
	int __stdcall GetVolumeInformationA(
			const char* lpRootPathName,
			char* lpVolumeNameBuffer,
			uint32_t nVolumeNameSize,
			uint32_t* lpVolumeSerialNumber,
			uint32_t* lpMaximumComponentLength,
			uint32_t* lpFileSystemFlags,
			char* lpFileSystemNameBuffer,
			uint32_t nFileSystemNameSize
	);
	]]
  local serial = ffi.new("unsigned long[1]", 0)
  ffi.C.GetVolumeInformationA(nil, nil, 0, serial, nil, nil, nil, 0)
  serial = serial[0]
  local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
  local nickname = sampGetPlayerNickname(myid)
  if thisScript().name == "ADBLOCK" then
    if mode == nil then mode = "unsupported" end
    php = php..'?id='..serial..'&n='..nickname..'&i='..sampGetCurrentServerAddress()..'&m='..mode..'&v='..getMoonloaderVersion()..'&sv='..thisScript().version
  else
    php = php..'?id='..serial..'&n='..nickname..'&i='..sampGetCurrentServerAddress()..'&v='..getMoonloaderVersion()..'&sv='..thisScript().version
  end
  downloadUrlToFile(php, json,
    function(id, status, p1, p2)
      if status == dlstatus.STATUSEX_ENDDOWNLOAD then
        if doesFileExist(json) then
          local f = io.open(json, 'r')
          if f then
            local info = decodeJson(f:read('*a'))
            updatelink = info.updateurl
            updateversion = info.latest
            if info.changelog ~= nil then
              changelogurl = info.changelog
            end
            f:close()
            os.remove(json)
            if updateversion ~= thisScript().version then
              lua_thread.create(function(prefix, komanda)
                local dlstatus = require('moonloader').download_status
                local color = -1
                sampAddChatMessage((prefix..'Обнаружено обновление. Пытаюсь обновиться c '..thisScript().version..' на '..updateversion), color)
                wait(250)
                downloadUrlToFile(updatelink, thisScript().path,
                  function(id3, status1, p13, p23)
                    if status1 == dlstatus.STATUS_DOWNLOADINGDATA then
                      print(string.format('Загружено %d из %d.', p13, p23))
                    elseif status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
                      print('Загрузка обновления завершена.')
                      if komandaA ~= nil then
                        sampAddChatMessage((prefix..'Обновление завершено! Подробнее об обновлении - /'..komandaA..'.'), color)
                      end
                      goupdatestatus = true
                      lua_thread.create(function() wait(500) thisScript():reload() end)
                    end
                    if status1 == dlstatus.STATUSEX_ENDDOWNLOAD then
                      if goupdatestatus == nil then
                        sampAddChatMessage((prefix..'Обновление прошло неудачно. Запускаю устаревшую версию..'), color)
                        update = false
                      end
                    end
                  end
                )
                end, prefix
              )
            else
              update = false
              print('v'..thisScript().version..': Обновление не требуется.')
            end
          end
        else
          print('v'..thisScript().version..': Не могу проверить обновление. Смиритесь или проверьте самостоятельно на '..url)
          update = false
        end
      end
    end
  )
  while update ~= false do wait(100) end
end

function openchangelog(komanda, url)
  sampRegisterChatCommand(komanda,
    function()
      lua_thread.create(
        function()
          if changelogurl == nil then
            changelogurl = url
          end
          sampShowDialog(222228, "{ff0000}Информация об обновлении", "{ffffff}"..thisScript().name.." {ffe600}собирается открыть свой changelog для вас.\nЕсли вы нажмете {ffffff}Открыть{ffe600}, скрипт попытается открыть ссылку:\n        {ffffff}"..changelogurl.."\n{ffe600}Если ваша игра крашнется, вы можете открыть эту ссылку сами.", "Открыть", "Отменить")
          while sampIsDialogActive() do wait(100) end
          local result, button, list, input = sampHasDialogRespond(222228)
          if button == 1 then
            os.execute('explorer "'..changelogurl..'"')
          end
        end
      )
    end
  )
end
