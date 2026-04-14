---@diagnostic disable: undefined-global
--local notf = require("notifications")
local res, version = pcall(getMoonloaderVersion)
if not res or version < 26 then
    print('Запуск скрипта невозможен. Скрипт работает на версии MoonLoader 0.26 или выше!')
end
local ava = nil
script_name('Arizona Helper')
script_author('ne ya')
script_version('0.0.1')
script_url('tg: @konoplya49')

require"lib.moonloader"
require"lib.sampfuncs"
local ffi = require("ffi")
local wm = require 'windows.message'
local memory = require('memory')
local json = require ('json')
local Matrix3X3 = require "matrix3x3"
local Vector3D = require "vector3d"
local font = renderCreateFont('Tahoma', 10, 4)
local enconing = require('encoding')
enconing.default = 'CP1251'
local u8 = enconing.UTF8

local _, id = nil, nil

local packet_incoming = 'Waiting for packet!'
local packet_outcoming = 'Waiting for packet!'

local rpc_incoming = 'Waiting for RPC!'
local rpc_outcoming = 'Waiting for RPC!'

if not doesDirectoryExist(main_dir) then
    createDirectory(main_dir)
end
local inicfg = require('inicfg')
local IniFilename = 'Default.ini'
local ini = inicfg.load({
    main = {
        serverTime = true,
        moneySeperator = true,
        calcOn = true,
        chat_nick = false,
        blockCode = false,
    },
    player = {
        fov = false,
        fovslider = 70.0,
        sbivAnimation = false,
        godmode = false,
        asp = false,
        wallhackNickname = false,
        whSkelet = false,
        autoDeltShar = false,
        infinityRun = false,
        hungryRun = false
    },
    helpers = {
        radiusTravki = false,
        narko = false,
    }
}, IniFilename)
inicfg.save(ini, '../boom/Default.ini')
inicfg.load(ini, '../boom/Default.ini')
if not doesFileExist('../boom/Default.ini') then
    inicfg.save(ini, '../boom/Default.ini')
end
local pendingSavePath = ''

ffi.cdef[[
    void EnableBlock();
    void DisableBlock();
]]

--local dll = ffi.load("C:\\arizona\\moonloader\\hello.dll")

---------------MIMGUI-----------------------
local imgui = require('mimgui')
local fa = require('fAwesome6_solid')

---------------окна MIMGUI-------------------
local renderWindow = imgui.new.bool()
local calculator = imgui.new.bool()
local packetsWindow = imgui.new.bool()
local acceptReset = imgui.new.bool()
local notification = imgui.new.bool()
local test = imgui.new.bool()
local auth = imgui.new.bool(1)
local tab = 1
local tabs = 0
local adminCheker = imgui.new.bool()
local M4 = imgui.new.bool()
local hungryRun = imgui.new.bool()
local information = imgui.new.bool()
local authMenu = imgui.new.bool()
local carInformation = imgui.new.bool()
local carMenu = imgui.new.bool()
local authCode = imgui.new.char[256]()
local textDrawId = imgui.new.bool()
local dialoId = imgui.new.bool()

local musorLovlya = false
local savedArg = nil
----------------Основное[1]-------------------
local settings = {
    main = {
        serverTime = imgui.new.bool(ini.main.serverTime),
        moneySeperator = imgui.new.bool(ini.main.moneySeperator),
        calcOn = imgui.new.bool(ini.main.calcOn),
        chat_nick = imgui.new.bool(ini.main.chat_nick)
    },
    player = {
        fov = imgui.new.bool(ini.player.fov),
        fovslider = imgui.new.float(ini.player.fovslider),
        sbivAnimation = imgui.new.bool(ini.player.sbivAnimation),
        godmode = imgui.new.bool(ini.player.godmode),
        asp = imgui.new.bool(ini.player.asp),
        wallhackNickname = imgui.new.bool(ini.player.wallhackNickname),
        whSkelet = imgui.new.bool(ini.player.whSkelet),
        autoDeltShar = imgui.new.bool(ini.player.autoDeltShar),
        infinityRun = imgui.new.bool(ini.player.infinityRun),
        hungryRun = imgui.new.bool(ini.player.hungryRun),

    },
    helpers = {
        radiusTravki = imgui.new.bool(ini.helpers.radiusTravki),
        narko = imgui.new.bool(ini.helpers.narko)
    }
}
local fastStop = imgui.new.bool()
local piss = imgui.new.bool()
local cjrun = imgui.new.bool()
local paydayMessage = imgui.new.bool()
local nofuel = imgui.new.bool()
local autoAzticket = imgui.new.bool()
local clickwarp = imgui.new.bool()
local autoFill = imgui.new.bool()
local autoBufferClear = imgui.new.bool()
local carFlip = imgui.new.bool()
local ticketOpened = false
local blockCode = false
keyToggle = VK_MBUTTON
keyApply = VK_LBUTTON
----------------Игрок[2]----------------------
local inputField = imgui.new.char[256]()
local aspInput = imgui.new.char[50]()
----------------Хелперы[3]--------------------
local ComboTest = imgui.new.int() -- создаём буфер для комбо
local item_list = {u8'Счастливая травка', u8'Рендер', u8'Транспорт', u8'Секонд Хенд', '4', '5'} -- создаём таблицу с содержимым списка
local ImItems = imgui.new['const char*'][#item_list](item_list)

-------------Настройки > изменение темы-----------------
local themeBufer = imgui.new.int()
local theme_list = {u8'Фиолетовая', u8'Серая', u8'Зеленая'}
local themeItems = imgui.new['const char*'][#theme_list](theme_list)

-- local radiusTravki = imgui.new.bool()
-- local narko = imgui.new.bool()
----------------Настройки[6]------------------
local configInput = imgui.new.char[256]()

----------------Для разработки-----------------
local devCombo = imgui.new.int() -- создаём буфер для комбо
local item_listTools = {u8'Главное', u8'Кастомные пакеты ARZ', u8'Пакеты/рпс', '3', '4', '5'} -- создаём таблицу с содержимым списка
local devItems = imgui.new['const char*'][#item_listTools](item_listTools)
local packetRpcLogger = imgui.new.bool()

local packets = {}
local resX, resY = getScreenResolution()

local imguiInferface = {
    --renderWindow = imgui.new.bool(false),
    
    fontData = {
        base, big = nil
    },
    
    AI_PAGE = {},
    AI_HEADERBUT = {},
    AI_TOGGLE = {},
    AI_PICTURE = {},
}
local menuItemsData = {
    currentPage = 1,

    menuButtons = {
        {name=u8('Основное'), icon=fa.HOUSE, i = 1},
        {name=u8('Игрок'), icon=fa.USER, i = 2},
        {name=u8('Визуалы'), icon=fa.TRASH, i = 3},
        {name=u8('Хелперы'), icon=fa.CIRCLE_INFO, i = 4},
        {name=u8('Афк фарм'), icon=fa.ADDRESS_BOOK, i = 5, release = 1},
        {name=u8('Настройки'), icon=fa.GEAR, i = 6},
        {name=u8('Для разработки'), icon=fa.ELLIPSIS, i = 7},
        {name=u8('Закрыть'), icon=fa.TOOLBOX, i = 8},
    }
}
local op = {
    h = {
        t = 0,
        b = false
    }
}
local selmenu = 1
local listop = {
	{
		flag = 0,
		title = "Основное",
		icon = fa.HOUSE,
		h = {
			t = 0,
			b = false
		}
	},
	{
		flag = 0,
		title = "Игрок",
		icon = fa.USER,
		h = {
			t = 0,
			b = false
		}
	},
	{
		flag = 0,
		title = "Визуалы",
		icon = fa.COMMENT_MEDICAL,
		h = {
			t = 0,
			b = false
		}
	},
	{
		flag = 0,
		title = "Хелперы",
		icon = fa.CIRCLE_INFO,
		h = {
			t = 0,
			b = false
		}
	},
    {
		flag = 4,
		title = "Афк фарм",
        soon = "В разработке..",
		icon = fa.ADDRESS_BOOK,
		h = {
			t = 0,
			b = false
		}
	},
    {
		flag = 0,
		title = "Настройки",
		icon = fa.GEAR,
		h = {
			t = 0,
			b = false
		}
	},
    {
		flag = 0,
		title = "Для разработки",
		icon = fa.ELLIPSIS,
		h = {
			t = 0,
			b = false
		}
	},
    {
		flag = 0,
		title = "Закрыть",
		icon = fa.TOOLBOX,
		h = {
			t = 0,
			b = false
		}
	},
}
--tim.timer = os.clock()
local fontsize = nil
local selInt = ''
local newFrame = imgui.OnFrame(
    function() return renderWindow[0] end,
    function (player)

        imgui.SetNextWindowPos(imgui.ImVec2(resX / 2, resY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(900, 500), imgui.Cond.FirstUseEver) -- 800 500     955 600
        imgui.Begin('qwe', renderWindow, imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoResize)
        imgui.PushFont(fontMenu)
        imgui.BeginChild('#Menu', imgui.ImVec2(200, -1), true)
            --Menu(menuItemsData.menuButtons)
            for iter_517_0, iter_517_1 in ipairs(listop) do
                if selMenuB(iter_517_1.title, iter_517_1.icon, iter_517_1.flag, iter_517_1.h, iter_517_0, iter_517_1.soon) then

                    if selmenu ~= iter_517_0 then
                        selmenu = iter_517_0
                    end
                end
            end
            imgui.EndChild()

            imgui.SameLine()
            if selmenu == 1 then
                imgui.SetCursorPosX(520)
                imgui.Text(u8'Основное')
                imgui.SetCursorPos(imgui.ImVec2(210, 23))
                imgui.BeginChild('qweqweewe', imgui.ImVec2(-1, 472), true)
                    if imgui.ToggleButton('Server time', settings.main.serverTime) then serverTime() end
                    imgui.ToggleButton('Money seperator', settings.main.moneySeperator)
                    imgui.ToggleButton('Calculator', settings.main.calcOn)
                    imgui.ToggleButton(u8'Цветные ники в чате', settings.main.chat_nick)
                    imgui.ToggleButton(u8'Авто шар/дельтаплан', settings.player.autoDeltShar)
                    imgui.ToggleButton(u8'Админ чекер', adminCheker)
                    imgui.ToggleButton(u8'piss на E', piss)
                    if imgui.ToggleButton('cj run', cjrun) then cmd_cjrun() end
                    imgui.ToggleButton(u8'Уведомление о PAYDAY', paydayMessage)
                    imgui.ToggleButton(u8'Auto open az ticket', autoAzticket)
                    imgui.ToggleButton(u8'Анти-далбаеб режим', test)
                    imgui.ToggleButton('clickwarp', clickwarp)
                    imgui.ToggleButton(u8'Очистка памяти стрима (очистка при 400мб)', autoBufferClear)
                imgui.EndChild()
            elseif selmenu == 2 then
                imgui.SetCursorPosX(520)
                imgui.Text(u8'Игрок')
                imgui.SetCursorPos(imgui.ImVec2(210, 23))
                imgui.BeginChild('qweqweewe', imgui.ImVec2(-1, 472), true)
                -- for iter_517_0, iter_517_1 in ipairs(listop) do
                --     if selMenuB(iter_517_1.title, iter_517_1.icon, iter_517_1.flag, iter_517_1.h, iter_517_0, iter_517_1.soon) then

                --         if listop ~= iter_517_0 then
                --             listop = iter_517_0
                --         end
                --     end
                -- end
                    --selMenuB('title', fa.HOUSE, 0, op.h, 1, false)
                    --selMenuB('title', fa.HOUSE, 0, op.h, 2, false)
                    if imgui.ToggleButton(u8'Сбив на E', settings.player.sbivAnimation) then sbivAnimation() end
                    replaceNickname = u8:decode(ffi.string(inputField))
                    if imgui.ToggleButton(u8'Бессмертие', settings.player.godmode) then godmode() end

                    imgui.SameLine()

                    imgui.TextQuestion(u8'Визуально меняет никнейм в чате')
                    imgui.ToggleButton(u8'Бесконечный бег', settings.player.infinityRun)
                    if imgui.ToggleButton(u8"Бег при голоде", hungryRun) then fhungryRun() end


                    imgui.PushItemWidth(150)
                    imgui.InputText(u8"", inputField, 256)
                    imgui.PopItemWidth()
                    imgui.SameLine()
                    if imgui.Button(u8'Сбросить', imgui.ImVec2(73, 25)) then
                        ffi.fill(inputField, 256, 0)
                        ffi.copy(inputField, nickname)
                    end

                imgui.EndChild()
            elseif selmenu == 3 then
                imgui.SetCursorPosX(520)
                imgui.Text(u8'Визуалы')
                imgui.SetCursorPos(imgui.ImVec2(210, 23))
                imgui.BeginChild('qwe213qweewe', imgui.ImVec2(-1, 472), true)
                    if imgui.ToggleButton('Fov', settings.player.fov) then fov() end
                        if settings.player.fov[0] then
                            imgui.SameLine()
                            imgui.PushItemWidth(140)
                            imgui.SliderFloat(u8'Поле зрения', settings.player.fovslider, 20.0, 125.0)
                            imgui.PopItemWidth()
                        end
                        
                    imgui.ToggleButton('asp', settings.player.asp)
                    if settings.player.asp[0] then
                        imgui.SameLine()
                        imgui.InputText('##1', aspInput, 50)
                        aspDecode = u8:decode(ffi.string(aspInput))
                        imgui.SameLine()
                        if imgui.Button(u8'Применить', imgui.ImVec2(73, 25)) then
                            arg = tonumber(aspDecode)
                            memory.setfloat(0xC3EFA4, arg, true)
                        end
                    else
                        --memory.setfloat(0xC3EFA4, 1.333, true)
                    end
                    if imgui.ToggleButton(u8'вх на ники', settings.player.wallhackNickname) then fWallhackNickname() end
                    if imgui.ToggleButton(u8'вх скелет', settings.player.whSkelet) then wallhackSkeletLox() end
                imgui.EndChild()
            elseif selmenu == 4 then
                imgui.SetCursorPosX(520)
                imgui.Text(u8'Хелперы')
                imgui.SetCursorPos(imgui.ImVec2(210, 23))
                imgui.BeginChild('qweqweewe', imgui.ImVec2(-1, 472), true)
                    imgui.Combo(u8'Список',ComboTest,ImItems, #item_list)
                    if ComboTest[0] == 0 then
                        imgui.ToggleButton(u8'Радиус травки', settings.helpers.radiusTravki)
                    elseif ComboTest[0] == 1 then
                        imgui.ToggleButton(u8'Наркотики', settings.helpers.narko)
                        imgui.Text(u8'Подарки')
                        imgui.Text(u8'Еще что-то')
                    elseif ComboTest[0] == 2 then
                        imgui.ToggleButton(u8'Бесконечная езда', nofuel)
                        imgui.ToggleButton(u8'Быстрый тормоз', fastStop)
                        imgui.ToggleButton(u8'Авто заправка', autoFill)
                        imgui.ToggleButton(u8'Флип машины', carFlip)
                        imgui.ToggleButton(u8'Информационное меню', carMenu)
                    elseif ComboTest[0] == 3 then
                        imgui.ToggleButton(u8'ВХ на одежду', test)
                        imgui.ToggleButton(u8'Автоматически покупать одежду', test)
                        imgui.ToggleButton(u8'Автоматически выбирать грязную одежду', test)
                        imgui.ToggleButton(u8'Информационная панель', test)
                    end
                imgui.EndChild()
            elseif selmenu == 6 then
                imgui.SetCursorPosX(520)
                imgui.Text(u8'Настройки')
                imgui.SetCursorPos(imgui.ImVec2(210, 23))
                imgui.BeginChild('222', imgui.ImVec2(200, 100), true)
                    local lfs = require 'lfs'
                    local file = ''
                    local basePath = getWorkingDirectory()..'\\boom'
                    for file in lfs.dir(basePath) do
                        if file ~= "." and file ~= ".." then
                            local fullPath = basePath..'\\'..file
                            if imgui.Selectable(tostring(u8(file)), selInt == fullPath) then
                                selInt = fullPath
                            end
                        end
                    end
                imgui.EndChild()
                imgui.SetCursorPosX(210)
                imgui.PushItemWidth(200)
                imgui.InputText(u8'##1', configInput, 256)
                imgui.PopItemWidth()

                --imgui.SetCursorPos(imgui.ImVec2(210, 164))
                imgui.SetCursorPosX(210)
                if imgui.Button(fa.DOWNLOAD .. u8' Save', imgui.ImVec2(98, 28)) then
                    local filename = u8:decode(ffi.string(configInput)):gsub('[\\/:*?"<>|]', ''):gsub('^%s*(.-)%s*$', '%1')
                    if filename ~= '' then
                        local path = '../boom/' .. filename .. '.ini'
                        if doesFileExist(getWorkingDirectory() .. '\\boom\\' .. filename .. '.ini') then
                            pendingSavePath = path
                            acceptReset[0] = true
                        else
                            save_config()
                            inicfg.save(ini, path)
                            ffi.fill(configInput, 256, 0)
                            sampAddChatMessage('Конфиг сохранён: ' .. filename .. '.ini', -1)
                        end
                    else
                        --push('Ошибка: имя конфигурации не задано!')
                    end
                end

                imgui.SameLine()

                if imgui.Button(fa.UPLOAD .. u8' Load', imgui.ImVec2(98, 28)) then
                    if selInt then
                        local filename = selInt:match("[^\\/]+$") or selInt
                        local loaded = inicfg.load(nil, selInt)
                        if loaded and loaded.main then
                            ini = loaded
                            load_config()
                            sampAddChatMessage('[ Arizona Helper ] {EEEEEE} Конфиг ' .. filename .. ' успешно применён', 13387077)
                        else
                            sampAddChatMessage('Ошибка при загрузке: ' .. filename, -1)
                        end
                    else
                        sampAddChatMessage('Выберите конфиг для загрузки!', -1)
                    end
                end

                imgui.SetCursorPosX(210)
                if imgui.Button(fa.TRASH .. u8' Del', imgui.ImVec2(98, 28)) then
                    if selInt and doesFileExist(selInt) then
                        local filename = selInt:match("[^\\/]+$") or selInt
                        local success = os.remove(selInt)
                        if success then
                            sampAddChatMessage('Конфиг удалён: ' .. filename, -1)
                            selInt = nil
                        else
                            sampAddChatMessage('Не удалось удалить конфиг: ' .. filename, -1)
                        end
                    else
                        sampAddChatMessage('Файл не найден или не выбран!', -1)
                    end
                end
                --imgui.NewLine()
                imgui.SetCursorPos(imgui.ImVec2(430, 28))
                imgui.PushItemWidth(140)
                imgui.Combo(u8'Тема', themeBufer, themeItems, #theme_list)
                imgui.PopItemWidth()
                if themeBufer[0] == 0 then
                PurpleTheme()
            elseif themeBufer[0] == 1 then
                GrayTheme()
            elseif themeBufer[0] == 2 then
                GreenTheme()
            end
            elseif selmenu == 7 then
                imgui.SetCursorPosX(520)
                imgui.Text(u8'Для разработки')
                imgui.SetCursorPos(imgui.ImVec2(210, 23))
                imgui.BeginChild('qwe213qweewe', imgui.ImVec2(-1, 472), true)
                    imgui.Combo(u8'Для разработки', devCombo, devItems, #item_listTools)
                    imgui.BeginChild('qwe', imgui.ImVec2(-1, -1), true)
                    if devCombo[0] == 0 then
                        imgui.ToggleButton(u8'ID textdraw', textDrawId)
                        imgui.ToggleButton(u8'ID dialog', dialoId)
                    elseif devCombo[0] == 1 then
                        if imgui.Button(u8'Очистить', imgui.ImVec2(400, 25)) then
                            packets = {}
                        end imgui.SameLine()
                        if imgui.Button('W', imgui.ImVec2(-1, 25)) then
                            renderWindow[0] = not renderWindow[0]
                            packetsWindow[0] = true
                        end
                        imgui.BeginChild('rwr', imgui.ImVec2(-1, -1), true)
                        -- for _, b in ipairs(packets) do
                        --     local colorTag = b.type == 'GET' and '{FF0000}' or '{00FF00}'
                        --     imgui.TextColoredRGB(string.format('%s%s: %s', colorTag, b.type, b.text))
                        -- end
                        for _, b in ipairs(packets) do
    local colorTag = b.type == 'GET' and '{FF0000}' or '{00FF00}'
    local text = string.format('%s%s: %s', colorTag, b.type, b.text)

    imgui.TextColoredRGB(text)

    if imgui.IsItemHovered() and imgui.IsMouseClicked(0) then
        imgui.SetClipboardText(b.text) -- копируем только текст пакета
        print('Copied:', b.text)
    end
end
                        imgui.EndChild()
                    elseif devCombo[0] == 2 then
                        if imgui.ToggleButton(u8'Отобразить на экране', packetRpcLogger) then fpacketRpcLogger() end
                        imgui.Text('INCOMING Packet: '..packet_incoming..'\nOUTCOMING Packet: '..packet_outcoming)
                        imgui.Text('INCOMING RPC: '..rpc_incoming..'\nOUTCOMING RPC: '..rpc_outcoming)
                    end
                imgui.EndChild()
            elseif selmenu == 8 then
                selmenu = 1
                renderWindow[0] = not renderWindow[0]
            end
            if listop == 1 then
                    imgui.Text('123')
                elseif listop == 2 then
                    imgui.Text('lox')
                end
        imgui.PopFont()
        imgui.End()
    end
)

imgui.OnFrame(
    function() return calculator[0] end,
        function(player)
            if settings.main.calcOn[0] then
                if sampIsChatInputActive() and ok then
                local chatcords = getStructElement(sampGetInputInfoPtr(), 0x8, 4)
                local windowPosX = getStructElement(chatcords, 0x8, 4)
                local windowPosY = getStructElement(chatcords, 0xC, 4) 
                    imgui.SetNextWindowPos(imgui.ImVec2(windowPosX, windowPosY + 100))
                    imgui.SetNextWindowSize(imgui.ImVec2(result:len()*10, 30))
                    imgui.PushStyleColor(imgui.Col.WindowBg, imgui.ImVec4(0.07, 0.07, 0.07, 1.00))
                    imgui.Begin('Solve', calculator, imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoScrollbar)
                    imgui.CenterText(u8(number_separator(result)) or u8'lol: '..number_separator((math.modf(tonumber(number)))))
                    imgui.PopStyleColor()
                    imgui.End()
                end
            end
end).HideCursor = true

imgui.OnFrame(
    function() return packetsWindow[0] end,
    function (player)
        imgui.SetNextWindowPos(imgui.ImVec2(resX / 2, resY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(1000, 400), imgui.Cond.FirstUseEver)
        imgui.Begin('packetsWindow', packetsWindow, imgui.WindowFlags.NoTitleBar)
        if imgui.Button(u8'Очистить', imgui.ImVec2(-1, 25)) then
            packets = {}
        end
            imgui.BeginChild('qwe', imgui.ImVec2(-1, -1), true)
                for _, b in ipairs(packets) do
                    local colorTag = b.type == 'GET' and '{FF0000}' or '{00FF00}'
                    imgui.TextColoredRGB(string.format('%s%s: %s', colorTag, b.type, b.text))
                    print(packets)
                end
        imgui.End()
    end
)

local newFrame = imgui.OnFrame(
    function() return acceptReset[0] end,
    function (player)

        imgui.SetNextWindowPos(imgui.ImVec2(resX / 2, resY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(283, 70), imgui.Cond.FirstUseEver)
        imgui.Begin('##qweew', acceptReset, imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoResize)
        imgui.TextWrapped(u8'Вы действительно хотите сохранить конфиг? Конфиг с таким названием уже существует!')
        if imgui.Button(u8'Да', imgui.ImVec2(130, 25)) then
            save_config()
            inicfg.save(ini, pendingSavePath)
            sampAddChatMessage('Конфиг перезаписан: ' .. pendingSavePath:match("[^\\/]+$"), -1)
            ffi.fill(inputField, 256, 0)
            acceptReset[0] = false
        end
        imgui.SameLine()
        if imgui.Button(u8'Нет', imgui.ImVec2(130, 25)) then
            acceptReset[0] = false
        end
        imgui.End()
        
    end
)
local newFramee = imgui.OnFrame(
    function() return information[0] end,
    function (player)

        imgui.SetNextWindowPos(imgui.ImVec2(resX / 2, resY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(330, 150), imgui.Cond.FirstUseEver)
        imgui.PushStyleColor(imgui.Col.WindowBg, imgui.ImVec4(0.07, 0.07, 0.10, 1.00))
        imgui.Begin('##information', information, imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoResize)
        imgui.Text(u8'/mus - включить ловлю предмета в мусорке')
        imgui.Text(u8'/musv - установить слот для ловли 0-150')
        imgui.Text(u8'/cstream - удалить игроков в зоне стрима')
        imgui.SetCursorPos(imgui.ImVec2(305, 0))
        if imgui.Button(fa.XMARK,imgui.ImVec2(20, 25)) then
            information[0] = not information[0]
        end
        imgui.PopStyleColor()
        imgui.End()
    end
)

local newFramee = imgui.OnFrame(
    function() return authMenu[0] end,
    function (player)

        imgui.SetNextWindowPos(imgui.ImVec2(resX / 2, resY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(330, 150), imgui.Cond.FirstUseEver)
        --imgui.PushStyleColor(imgui.Col.WindowBg, imgui.ImVec4(0.07, 0.07, 0.10, 1.00))
        imgui.Begin('##authMenu', authMenu, imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize)
        imgui.PushItemWidth(100)
        imgui.InputText(u8"", authCode, 256, imgui.InputTextFlags.Password)
        imgui.PopItemWidth()
        if imgui.Button(u8'Проверить', imgui.ImVec2(100, 25)) then
            local codeStr = u8:decode(ffi.string(authCode))
            local code = tonumber(codeStr)
            if code == 1337 then
                ffi.fill(authCode, 256, 0)
                blockCode = false
                test[0] = false
                authMenu[0] = false
                dll.DisableBlock()
                --inicfg.save(ini, '../boom/Default.ini')
            end
        end
        --imgui.PopStyleColor()
        imgui.End()
    end
)

imgui.OnFrame(
    function() return carInformation[0] end,
    function (player)

        imgui.SetNextWindowPos(imgui.ImVec2(resX / 2, resY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(330, 150), imgui.Cond.FirstUseEver)
        --imgui.PushStyleColor(imgui.Col.WindowBg, imgui.ImVec4(0.07, 0.07, 0.10, 1.00))
        imgui.Begin('##carInformation', carInformation, imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize)
        imgui.PushFont(fontMenu)
        if isCharInAnyCar(PLAYER_PED) then
            imgui.Text(fa["HEART_PULSE"] .. ' ' .. getCarHealth(storeCarCharIsInNoSave(PLAYER_PED)))
            imgui.Text(fa.DOOR_OPEN .. ' ' .. (getCarDoorLockStatus(storeCarCharIsInNoSave(PLAYER_PED)) == 0 and u8"Открыта" or u8"Закрыта"))
        end
        imgui.PopFont()
        imgui.End()
    end
).HideCursor = true

imgui.OnInitialize(function()
    imgui.GetIO().IniFilename = nil
    PurpleTheme()
    local glyph_ranges = imgui.GetIO().Fonts:GetGlyphRangesCyrillic()
    fontMenu = imgui.GetIO().Fonts:AddFontFromFileTTF(getFolderPath(0x14) .. '\\trebucbd.ttf', 17.0, nil, glyph_ranges)
    fa.Init(17)
    fontSoon = imgui.GetIO().Fonts:AddFontFromFileTTF(getFolderPath(0x14) .. '\\trebucbd.ttf', 12.0, nil, glyph_ranges)
    if doesFileExist(getWorkingDirectory()..'\\Arizona Tools\\ava.png') then -- находим необходимую картинку с названием example.png в папке moonloader/resource/
        ava = imgui.CreateTextureFromFile(getWorkingDirectory() .. '\\Arizona Tools\\ava.png') -- если найдена, то записываем в переменную хендл картинки
    end
    -- local glyph_ranges = imgui.GetIO().Fonts:GetGlyphRangesCyrillic()
    -- local config = imgui.ImFontConfig() -- Создаём новую пременную и присваиваем ей новый экземпляр класса ImFontConfig(). Этот класс используется для настройки параментров шрифта.
    -- config.MergeMode = true -- Ставим true, что означает, что шрифт будет объединён с другими шрифтами, если они уже были добавлены в Fonts
    -- config.PixelSnapH = true
    -- imguiInferface.fontData.big = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/resource/fonts/EagleSans Regular Regular.ttf', 64.0, nil, glyph_ranges)
    -- imgui.GetIO().Fonts:AddFontFromMemoryCompressedBase85TTF(fa.get_font_data_base85('solid'), 18, config, iconRanges)
    -- imguiInferface.fontData.base = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/resource/fonts/EagleSans Regular Regular.ttf', 18.0, nil, glyph_ranges)
    -- imgui.GetIO().Fonts:AddFontFromMemoryCompressedBase85TTF(fa.get_afont_data_base85('solid'), 18, config, iconRanges)
    fontsize = imgui.GetIO().Fonts:AddFontFromFileTTF(getFolderPath(0x14) .. '\\trebucbd.ttf', 30.0, nil, imgui.GetIO().Fonts:GetGlyphRangesCyrillic())
end)

function imgui.CenterText(text)
    local width = imgui.GetWindowWidth()
    local calc = imgui.CalcTextSize(text)
    imgui.SetCursorPosX( width / 2 - calc.x / 2 )
    imgui.Text(text)
end

function imgui.CenterTextY(text)
    local width = imgui.GetWindowWidth()
    local height = imgui.GetWindowHeight()
    local calc = imgui.CalcTextSize(text)
    imgui.SetCursorPosX( width / 2 - calc.x / 2 )
    imgui.SetCursorPosY( height / 2 - calc.y / 2 )
    imgui.Text(text)
end

function imgui.TextQuestion(text)
    imgui.TextDisabled("?")
    if imgui.IsItemHovered() then
        imgui.BeginTooltip()
        imgui.PushTextWrapPos(450)
        imgui.TextUnformatted(text)
        imgui.PopTextWrapPos()
        imgui.EndTooltip()
    end
end

function imgui.TextColoredRGB(text)
    local style = imgui.GetStyle()
    local colors = style.Colors
    local ImVec4 = imgui.ImVec4
    local explode_argb = function(argb)
        local a = bit.band(bit.rshift(argb, 24), 0xFF)
        local r = bit.band(bit.rshift(argb, 16), 0xFF)
        local g = bit.band(bit.rshift(argb, 8), 0xFF)
        local b = bit.band(argb, 0xFF)
        return a, r, g, b
    end
    local getcolor = function(color)
        if color:sub(1, 6):upper() == 'SSSSSS' then
            local r, g, b = colors[1].x, colors[1].y, colors[1].z
            local a = tonumber(color:sub(7, 8), 16) or colors[1].w * 255
            return ImVec4(r, g, b, a / 255)
        end
        local color = type(color) == 'string' and tonumber(color, 16) or color
        if type(color) ~= 'number' then return end
        local r, g, b, a = explode_argb(color)
        return imgui.ImVec4(r/255, g/255, b/255, a/255)
    end
    local render_text = function(text_)
        for w in text_:gmatch('[^\r\n]+') do
            local text, colors_, m = {}, {}, 1
            w = w:gsub('{(......)}', '{%1FF}')
            while w:find('{........}') do
                local n, k = w:find('{........}')
                local color = getcolor(w:sub(n + 1, k - 1))
                if color then
                    text[#text], text[#text + 1] = w:sub(m, n - 1), w:sub(k + 1, #w)
                    colors_[#colors_ + 1] = color
                    m = n
                end
                w = w:sub(1, n - 1) .. w:sub(k + 1, #w)
            end
            if text[0] then
                for i = 0, #text do
                    imgui.TextColored(colors_[i] or colors[1], u8(text[i]))
                    imgui.SameLine(nil, 0)
                end
                imgui.NewLine()
            else imgui.Text(u8(w)) end
        end
    end
    render_text(text)
end

function PageButton(bool, icon, name, but_wide, soon)
    local ToU32 = imgui.ColorConvertFloat4ToU32
	but_wide = but_wide or 190
	local duration = 0.25
	local DL = imgui.GetWindowDrawList()
	local p1 = imgui.GetCursorScreenPos()
	local p2 = imgui.GetCursorPos()
	local col = imgui.GetStyle().Colors[imgui.Col.ButtonActive]
    local function bringFloatTo(from, to, start_time, duration)
        local timer = os.clock() - start_time
        if timer >= 0.00 and timer <= duration then
            local count = timer / (duration / 100)
            return from + (count * (to - from) / 100), true
        end
        return (timer > duration) and to or from, false
    end
		
	if not imguiInferface.AI_PAGE[name] then
		imguiInferface.AI_PAGE[name] = { clock = nil }
	end
	local pool = imguiInferface.AI_PAGE[name]

	imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.00, 0.00, 0.00, 0.00))
    imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.00, 0.00, 0.00, 0.00))
    imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.00, 0.00, 0.00, 0.00))
    local result = imgui.InvisibleButton(name, imgui.ImVec2(but_wide, 35))
    if result and not bool then 
    	pool.clock = os.clock() 
    end
    local pressed = imgui.IsItemActive()
    imgui.PopStyleColor(3)
	if bool then
		--if pool.clock and (os.clock() - pool.clock) < duration then
			--local wide = (os.clock() - pool.clock) * (but_wide / duration)
			--DL:AddRectFilled(imgui.ImVec2(p1.x, p1.y), imgui.ImVec2((p1.x + 190) - wide, p1.y + 35), 0x10FFFFFF, 15, 10)
	       	--DL:AddRectFilled(imgui.ImVec2(p1.x, p1.y), imgui.ImVec2(p1.x + 5, p1.y + 35), ToU32(col))
			--DL:AddRectFilled(imgui.ImVec2(p1.x, p1.y), imgui.ImVec2(p1.x + wide, p1.y + 35), ToU32(imgui.ImVec4(col.x, col.y, col.z, 0.6)), 15, 10)
		--else
        if not soon then
			DL:AddRectFilled(imgui.ImVec2(p1.x, (pressed and p1.y + 3 or p1.y)), imgui.ImVec2(p1.x + 5, (pressed and p1.y + 32 or p1.y + 35)), ToU32(col))
			DL:AddRectFilled(imgui.ImVec2(p1.x, p1.y), imgui.ImVec2(p1.x + 190, p1.y + 35), ToU32(imgui.ImVec4(col.x, col.y, col.z, 0.6)), 15, 10)
		end
	else
		if imgui.IsItemHovered() or soon then
			DL:AddRectFilled(imgui.ImVec2(p1.x, p1.y), imgui.ImVec2(p1.x + 190, p1.y + 35), 0x10FFFFFF, 15, 10)
		end
	end
	imgui.SameLine(10); imgui.SetCursorPosY(p2.y + 8)
	if bool then
		imgui.Text((' '):rep(3) .. icon)
		imgui.SameLine(60)
		imgui.Text(name)
	else
		imgui.TextColored(imgui.ImVec4(0.60, 0.60, 0.60, 1.00), (' '):rep(3) .. icon)
		imgui.SameLine(60)
		imgui.TextColored(imgui.ImVec4(0.60, 0.60, 0.60, 1.00), name)
	end
	imgui.SetCursorPosY(p2.y + 40)
	return result
end

imgui.ToggleButton = {
	easing = "outCirc",
	duration = 0.3,
	padding = 4,
	pool = {}
}

function imgui.ToggleButton.render(arg_375_0, arg_375_1, arg_375_2, arg_375_3)
	local var_375_0 = imgui.GetWindowDrawList()
	local var_375_1 = imgui.GetCursorScreenPos()
	local var_375_2 = imgui.ImVec2(40, 20)

	if arg_375_0.pool[arg_375_1] == nil then
		arg_375_0.pool[arg_375_1] = {
			state = arg_375_2[0],
			value = arg_375_2[0] and 1 or 0,
			process = {}
		}
	end

	imgui.BeginGroup()

	local var_375_3 = imgui.InvisibleButton(arg_375_1, var_375_2)
	local var_375_4 = false

	if var_375_3 and not arg_375_3 then
		arg_375_2[0] = not arg_375_2[0]
		var_375_4 = true
	elseif arg_375_2[0] ~= arg_375_0.pool[arg_375_1].state then
		var_375_4 = true
	end

	if var_375_4 then
		arg_375_0.pool[arg_375_1].state = arg_375_2[0]

		if arg_375_0.pool[arg_375_1].process.dead == false then
			arg_375_0.pool[arg_375_1].process:terminate()
		end

		local var_375_5 = arg_375_2[0] and 1 or 0
		local var_375_6 = math.abs(var_375_5 - arg_375_0.pool[arg_375_1].value) * arg_375_0.duration

		arg_375_0.pool[arg_375_1].process = Ease(arg_375_0.pool[arg_375_1].value, var_375_5, os.clock(), var_375_6, arg_375_0.easing, function(arg_376_0)
			arg_375_0.pool[arg_375_1].value = arg_376_0
		end)
	end

	local var_375_7 = arg_375_1:gsub("##.*$", "")

	if #var_375_7 > 0 then
		imgui.SameLine()

		if arg_375_3 then
			imgui.TextDisabled(var_375_7)
		else
			imgui.Text(var_375_7)
		end
	end

	imgui.EndGroup()

	local var_375_8 = arg_375_0.pool[arg_375_1].value
	local var_375_9 = limit(0.4 + 0.6 * var_375_8, 0, imgui.GetStyle().Alpha)
	local var_375_10 = arg_375_3 and getColor("TextDisabled", 0.3) or getColor("ButtonActive", var_375_9)
	local var_375_11 = (var_375_2.y - arg_375_0.padding * 2) / 2
	local var_375_12 = var_375_1.x + arg_375_0.padding + var_375_11
	local var_375_13 = var_375_1.x + var_375_2.x - arg_375_0.padding - var_375_11
	local var_375_14 = imgui.ImVec2(var_375_12 + (var_375_13 - var_375_12) * var_375_8, var_375_1.y + var_375_2.y / 2)
	local var_375_15 = var_375_11 * (var_375_8 < 0.5 and var_375_8 or 1 - var_375_8)

	var_375_0:AddRect(var_375_1, imgui.ImVec2(var_375_1.x + var_375_2.x, var_375_1.y + var_375_2.y), var_375_10:u32(), 6, imgui.DrawCornerFlags.All, 1)
	var_375_0:AddRectFilled(imgui.ImVec2(var_375_14.x - var_375_11 - var_375_15, var_375_14.y - var_375_11 + var_375_15), imgui.ImVec2(var_375_14.x + var_375_11 + var_375_15, var_375_14.y + var_375_11 - var_375_15), var_375_10:u32(), 10, imgui.DrawCornerFlags.All)

	return var_375_3
end

setmetatable(imgui.ToggleButton, {
	__call = imgui.ToggleButton.render
})

-------------------Все для tooglebutton-------------
function limit(arg_368_0, arg_368_1, arg_368_2)
	arg_368_1 = arg_368_1 or 0
	arg_368_2 = arg_368_2 or 1

	return arg_368_0 < arg_368_1 and arg_368_1 or arg_368_2 < arg_368_0 and arg_368_2 or arg_368_0
end
function getColor(arg_1018_0, arg_1018_1)
	local var_1018_0

	if tonumber(arg_1018_0) then
		local var_1018_1, var_1018_2, var_1018_3, var_1018_4 = explode_argb(arg_1018_0)

		var_1018_0 = imgui.ImVec4(var_1018_2 / 255, var_1018_3 / 255, var_1018_4 / 255, var_1018_1 / 255)
	else
		var_1018_0 = imgui.ImVec4(imgui.GetStyle().Colors[imgui.Col[arg_1018_0]])
	end

	var_1018_0.w = arg_1018_1 or imgui.GetStyle().Alpha

	return {
		r = math.floor(var_1018_0.x * 255),
		g = math.floor(var_1018_0.y * 255),
		b = math.floor(var_1018_0.z * 255),
		a = math.floor(var_1018_0.w * 255),
		u32 = function(arg_1019_0)
			return imgui.ColorConvertFloat4ToU32(var_1018_0)
		end,
		vec4 = function(arg_1020_0)
			return var_1018_0
		end,
		tohex = function(arg_1021_0)
			local var_1021_0 = imgui.GetStyle().Colors[imgui.Col.WindowBg]
			local var_1021_1 = 1 - var_1018_0.w
			local var_1021_2 = math.floor((var_1018_0.z * var_1018_0.w + var_1021_0.z * var_1021_1) * 255)
			local var_1021_3 = bit.bor(var_1021_2, bit.lshift(math.floor((var_1018_0.y * var_1018_0.w + var_1021_0.y * var_1021_1) * 255), 8))
			local var_1021_4 = bit.bor(var_1021_3, bit.lshift(math.floor((var_1018_0.x * var_1018_0.w + var_1021_0.x * var_1021_1) * 255), 16))

			return ("{%.6X}"):format(var_1021_4)
		end
	}
end
function Ease(arg_361_0, arg_361_1, arg_361_2, arg_361_3, arg_361_4, arg_361_5)
	local var_361_0 = EasingFunctions[arg_361_4] or EasingFunctions.linear

	arg_361_2 = arg_361_2 or os.clock()

	local function var_361_1(arg_362_0, arg_362_1, arg_362_2, arg_362_3, arg_362_4)
		local var_362_0 = os.clock() - arg_362_2

		if var_362_0 >= 0 and var_362_0 <= arg_362_3 then
			local var_362_1 = 100 * arg_362_4(var_362_0 / arg_362_3)

			return arg_362_0 + (arg_362_1 - arg_362_0) / 100 * var_362_1, 1
		elseif arg_362_3 < var_362_0 then
			return arg_362_1, 2
		else
			return arg_362_0, 0
		end
	end

	if type(arg_361_5) == "function" then
		return lua_thread.create(function()
			while true do
				local var_363_0, var_363_1 = var_361_1(arg_361_0, arg_361_1, arg_361_2, arg_361_3, var_361_0)

				arg_361_5(var_363_0, var_363_1)

				if var_363_1 == 2 then
					break
				end

				wait(0)
			end
		end)
	end

	return var_361_1(arg_361_0, arg_361_1, arg_361_2, arg_361_3, var_361_0)
end
EasingFunctions = {
	linear = function(arg_330_0)
		return arg_330_0
	end,
	inSine = function(arg_331_0)
		return 1 - math.cos(arg_331_0 * math.pi / 2)
	end,
	outSine = function(arg_332_0)
		return math.sin(arg_332_0 * math.pi / 2)
	end,
	inOutSine = function(arg_333_0)
		return -(math.cos(math.pi * arg_333_0) - 1) / 2
	end,
	inQuad = function(arg_334_0)
		return arg_334_0^2
	end,
	outQuad = function(arg_335_0)
		return 1 - (1 - arg_335_0) * (1 - arg_335_0)
	end,
	inOutQuad = function(arg_336_0)
		return arg_336_0 < 0.5 and 2 * arg_336_0^2 or 1 - (-2 * arg_336_0 + 2)^2 / 2
	end,
	inCubic = function(arg_337_0)
		return arg_337_0^3
	end,
	outCubic = function(arg_338_0)
		return 1 - (1 - arg_338_0)^3
	end,
	inOutCubic = function(arg_339_0)
		return arg_339_0 < 0.5 and 4 * arg_339_0^3 or 1 - (-2 * arg_339_0 + 2)^3 / 2
	end,
	inQuart = function(arg_340_0)
		return arg_340_0^4
	end,
	outQuart = function(arg_341_0)
		return 1 - (1 - arg_341_0)^4
	end,
	inOutQuart = function(arg_342_0)
		return arg_342_0 < 0.5 and 8 * arg_342_0^4 or 1 - (-2 * arg_342_0 + 2)^4 / 2
	end,
	inQuint = function(arg_343_0)
		return arg_343_0^5
	end,
	outQuint = function(arg_344_0)
		return 1 - (1 - arg_344_0)^5
	end,
	inOutQuint = function(arg_345_0)
		return arg_345_0 < 0.5 and 16 * arg_345_0^5 or 1 - (-2 * arg_345_0 + 2)^5 / 2
	end,
	inExpo = function(arg_346_0)
		return arg_346_0 == 0 and 0 or 2^(10 * arg_346_0 - 10)
	end,
	outExpo = function(arg_347_0)
		return arg_347_0 == 1 and 1 or 1 - 2^(-10 * arg_347_0)
	end,
	inOutExpo = function(arg_348_0)
		if arg_348_0 == 0 then
			return 0
		elseif arg_348_0 == 1 then
			return 1
		else
			return arg_348_0 < 0.5 and 2^(20 * arg_348_0 - 10) / 2 or (2 - 2^(-20 * arg_348_0 + 10)) / 2
		end
	end,
	inCirc = function(arg_349_0)
		return 1 - math.sqrt(1 - arg_349_0^2)
	end,
	outCirc = function(arg_350_0)
		return math.sqrt(1 - (arg_350_0 - 1)^2)
	end,
	inOutCirc = function(arg_351_0)
		if arg_351_0 < 0.5 then
			return (1 - math.sqrt(1 - (2 * arg_351_0)^2)) / 2
		else
			return (math.sqrt(1 - (-2 * arg_351_0 + 2)^2) + 1) / 2
		end
	end,
	inBack = function(arg_352_0)
		local var_352_0 = 1.70158

		return (var_352_0 + 1) * arg_352_0^3 - var_352_0 * arg_352_0^2
	end,
	outBack = function(arg_353_0)
		local var_353_0 = 1.70158

		return 1 + (var_353_0 + 1) * (arg_353_0 - 1)^3 + var_353_0 * (arg_353_0 - 1)^2
	end,
	inOutBack = function(arg_354_0)
		local var_354_0 = 1.70158
		local var_354_1 = var_354_0 * 1.525

		if arg_354_0 < 0.5 then
			return (2 * arg_354_0)^2 * ((var_354_1 + 1) * 2 * arg_354_0 - var_354_1) / 2
		else
			return ((2 * arg_354_0 - 2)^2 * ((var_354_1 + 1) * (arg_354_0 * 2 - 2) + var_354_1) + 2) / 2
		end
	end,
	inElastic = function(arg_355_0)
		local var_355_0 = 2 * math.pi / 3

		if arg_355_0 == 0 then
			return 0
		elseif arg_355_0 == 1 then
			return 1
		else
			return -2^(10 * arg_355_0 - 10) * math.sin((arg_355_0 * 10 - 10.75) * var_355_0)
		end
	end,
	outElastic = function(arg_356_0)
		local var_356_0 = 2 * math.pi / 3

		if arg_356_0 == 0 then
			return 0
		elseif arg_356_0 == 1 then
			return 1
		else
			return 2^(-10 * arg_356_0) * math.sin((arg_356_0 * 10 - 0.75) * var_356_0) + 1
		end
	end,
	inOutElastic = function(arg_357_0)
		local var_357_0 = 2 * math.pi / 4.5

		if arg_357_0 == 0 then
			return 0
		elseif arg_357_0 == 1 then
			return 1
		elseif arg_357_0 < 0.5 then
			return -(2^(20 * arg_357_0 - 10) * math.sin((20 * arg_357_0 - 11.125) * var_357_0)) / 2
		else
			return 2^(-20 * arg_357_0 + 10) * math.sin((20 * arg_357_0 - 11.125) * var_357_0) / 2 + 1
		end
	end,
	inBounce = function(arg_358_0)
		return 1 - EasingFunctions.outBounce(1 - arg_358_0)
	end,
	outBounce = function(arg_359_0)
		local var_359_0 = 7.5625
		local var_359_1 = 2.75

		if arg_359_0 < 1 / var_359_1 then
			return var_359_0 * arg_359_0 * arg_359_0
		elseif arg_359_0 < 2 / var_359_1 then
			arg_359_0 = arg_359_0 - 1.5 / var_359_1

			return var_359_0 * arg_359_0 * arg_359_0 + 0.75
		elseif arg_359_0 < 2.5 / var_359_1 then
			arg_359_0 = arg_359_0 - 2.25 / var_359_1

			return var_359_0 * arg_359_0 * arg_359_0 + 0.9375
		else
			arg_359_0 = arg_359_0 - 2.625 / var_359_1

			return var_359_0 * arg_359_0 * arg_359_0 + 0.984375
		end
	end,
	inOutBounce = function(arg_360_0)
		if arg_360_0 < 0.5 then
			return (1 - EasingFunctions.outBounce(1 - 2 * arg_360_0)) / 2
		else
			return (1 + EasingFunctions.outBounce(2 * arg_360_0 - 1)) / 2
		end
	end
}

local timer = os.clock()
function selMenuB(arg_696_0, arg_696_1, arg_696_2, arg_696_3, arg_696_4, arg_696_5)
	local var_696_0 = imgui.GetWindowDrawList()
	local var_696_1 = {
		text = imgui.ImVec4(imgui.GetStyle().Colors[imgui.Col.Text]),
		idle = imgui.ImVec4(imgui.GetStyle().Colors[imgui.Col.Button]),
		hovr = imgui.ImVec4(imgui.GetStyle().Colors[imgui.Col.ButtonHovered]),
		actv = imgui.ImVec4(imgui.GetStyle().Colors[imgui.Col.ButtonActive])
	}
	local var_696_2 = selmenu == arg_696_4
	local var_696_3 = bit.band(arg_696_2, 2) == 2 or bit.band(arg_696_2, 4) == 4
	local var_696_4 = bit.band(arg_696_2, 4) == 4

	if var_696_3 then
		var_696_1.hovr = var_696_1.idle
		var_696_1.actv = var_696_1.idle
		var_696_1.text.w = 0.6
	end

	imgui.BeginGroup()

	local var_696_5 = imgui.GetCursorPos()
	local var_696_6 = imgui.GetCursorScreenPos()
	local var_696_7 = imgui.CalcTextSize(arg_696_1)
	local var_696_8 = imgui.ImVec2(178, 38)
	local var_696_9 = imgui.ImVec2(var_696_6.x + var_696_8.x / 2, var_696_6.y + var_696_8.y / 2)
	local var_696_10 = var_696_5.y + var_696_8.y / 2 - var_696_7.y / 2
	local var_696_11 = 5
	local var_696_12 = imgui.ButtonNoBg("##SelButton" .. arg_696_4, var_696_8) and not var_696_3
	local var_696_13 = imgui.IsItemHovered()
	local var_696_14 = imgui.IsItemActive()

	if not var_696_3 and arg_696_3.b ~= var_696_13 then
		arg_696_3.b = var_696_13
		arg_696_3.t = os.clock()
	end

	local var_696_15 = Ease(arg_696_3.b and 0 or 5, arg_696_3.b and 5 or 0, arg_696_3.t, 0.1, "outSine")
	local var_696_16 = Ease(var_696_8.y - var_696_11, var_696_8.y, timer, 1.5, "outElastic")

	if not var_696_3 then
		if var_696_2 then
			var_696_0:AddRectFilled(imgui.ImVec2(var_696_9.x - var_696_8.x / 2, var_696_9.y - var_696_16 / 2), imgui.ImVec2(var_696_9.x + var_696_8.x / 2, var_696_9.y + var_696_16 / 2), imgui.ColorConvertFloat4ToU32(var_696_1.actv), imgui.GetStyle().FrameRounding, 15)
			var_696_0:AddRectFilled(imgui.ImVec2(var_696_6.x + var_696_8.x - 3, var_696_9.y - var_696_16 / 2), imgui.ImVec2(var_696_6.x + var_696_8.x, var_696_9.y + var_696_16 / 2), imgui.ColorConvertFloat4ToU32(imgui.GetStyle().Colors[imgui.Col.Text]), imgui.GetStyle().FrameRounding, 6)
		elseif var_696_13 then
			var_696_0:AddRectFilled(imgui.ImVec2(var_696_9.x - var_696_8.x / 2, var_696_9.y - (var_696_8.y / 2 - var_696_11 / 2)), imgui.ImVec2(var_696_9.x + var_696_8.x / 2, var_696_9.y + (var_696_8.y / 2 - var_696_11 / 2)), imgui.ColorConvertFloat4ToU32(var_696_1.hovr), imgui.GetStyle().FrameRounding, 15)
		end
	end

	imgui.PushStyleColor(imgui.Col.Text, var_696_1.text)
	imgui.SetCursorPos(imgui.ImVec2(15 + var_696_15, var_696_10))
	imgui.Text(arg_696_1)
	imgui.SetCursorPos(imgui.ImVec2(50 + var_696_15, var_696_4 and var_696_10 - 5 or var_696_10))
	imgui.Text(u8(arg_696_0))

	if var_696_4 then
		imgui.PushFont(fontSoon)

		local var_696_17 = u8(arg_696_5 or "Скоро..")
		local var_696_18 = imgui.CalcTextSize(var_696_17).x

		imgui.SetCursorPos(imgui.ImVec2(50 + var_696_15, var_696_10 + 11))
		imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.3), var_696_17)
		imgui.PopFont()
	end

	imgui.PopStyleColor()
	imgui.EndGroup()

	return var_696_12
end

function imgui.ButtonNoBg(...)
	--imgui.PushStyleVar(imgui.StyleVar.Alpha, 0.4)
	imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0, 0, 0, 0))
	imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0, 0, 0, 0))
	imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0, 0, 0, 0))

	local var_690_0 = imgui.Button(...)

	imgui.PopStyleColor(3)
	--imgui.PopStyleVar()

	return var_690_0
end

function Menu(menuItems)
    for i=1, #menuItems do
        if PageButton(menuItemsData.currentPage == menuItems[i].i, menuItems[i].icon, menuItems[i].name, menuItems[i].release) then
            menuItemsData.currentPage= menuItems[i].i
        end
    end
end

---------------------Config-------------------
function save_config()
    ini.main.serverTime = tostring(settings.main.serverTime[0])
    ini.main.moneySeperator  = tostring(settings.main.moneySeperator[0])
    ini.main.calcOn = tostring(settings.main.calcOn[0])
    ini.main.chat_nick = tostring(settings.main.chat_nick[0])
    ini.player.fov = tostring(settings.player.fov[0])
    --ini.player.fovslider = settings.player.fovslider[0]
    ini.player.fovslider = tostring(settings.player.fovslider[0])
    ini.player.sbivAnimation = tostring(settings.player.sbivAnimation[0])
    ini.player.infinityRun = tostring(settings.player.infinityRun[0])
    ini.player.hungryRun = tostring(settings.player.hungryRun[0])
    ini.player.wallhackNickname = tostring(settings.player.wallhackNickname[0])
    ini.player.whSkelet = tostring(settings.player.whSkelet[0])
    ini.player.autoDeltShar = tostring(settings.player.autoDeltShar[0])
end

function load_config()
    settings.main.serverTime[0] = tostring(ini.main.serverTime) == 'true'
    settings.main.moneySeperator[0] = tostring(ini.main.moneySeperator) == 'true'
    settings.main.calcOn[0] = tostring(ini.main.calcOn) == 'true'
    settings.main.chat_nick[0] = tostring(ini.main.chat_nick) == 'true'
    settings.player.fov[0] = tostring(ini.player.fov) == 'true'
    settings.player.fovslider[0] = ini.player.fovslider
    fov()
    settings.player.sbivAnimation[0] = tostring(ini.player.sbivAnimation) == 'true'
    sbivAnimation()
    settings.player.infinityRun[0] = tostring(ini.player.infinityRun) == 'true'
    settings.player.hungryRun[0] = tostring(ini.player.hungryRun) == 'true'
    settings.player.wallhackNickname[0] = tostring(ini.player.wallhackNickname) == 'true'
    fWallhackNickname()
    settings.player.whSkelet[0] = tostring(ini.player.whSkelet) == 'true'
    wallhackSkeletLox()
    settings.player.autoDeltShar[0] = tostring(ini.player.autoDeltShar) == 'true'
end

----------------------MAIN---------------------
local sampev = require('samp.events')
local key = require('vkeys')

local state = false
local direct = getWorkingDirectory()
function main()
    while not isSampAvailable() do wait(0) end
    --repeat wait(0) until sampIsLocalPlayerSpawned()
    replaceNickname = sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)))
    nickname = sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)))
    ffi.copy(inputField, nickname)
    sampRegisterChatCommand('chec', cmd_json)
    lua_thread.create(function ()
        while true do
            connectPlayerisServer = sampIsPlayerConnected(PLAYER_PED)
            _, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
            wait(1000)
        end
    end)
    sampRegisterChatCommand('st', setWorldTime)
    sampRegisterChatCommand('sw', setWorldWeather)
    sampRegisterChatCommand('cstream', clear_stream)
    sampRegisterChatCommand('helper', function () renderWindow[0] = not renderWindow[0] end)
    sampRegisterChatCommand('info', function () information[0] = not information[0] end)
    sampRegisterChatCommand('mus', function() musorLovlya = not musorLovlya end)
    sampRegisterChatCommand('musv', function(arg) savedArg = tonumber(arg) sampAddChatMessage('Установлено значение слота ' .. savedArg,-1) end)
    sampAddChatMessage("[ Arizona Helper ] {EEEEEE}Открыть главное меню: /helper", 13387077)
    serverTime()
    fWallhackNickname()
    initializeRender()
    while true do
        if settings.player.infinityRun[0] then
            memory.setint8(0xB7CEE4, 1)
        else
            memory.setint8(0xB7CEE4, 0)
        end
        local pX, pY, pZ = getCharCoordinates(PLAYER_PED)
        -----asp----
        memory.fill(0x6FF452, 0x90, 6, true)
        ------------
        if isKeyJustPressed(key.VK_DELETE) then
            renderWindow[0] = not renderWindow[0]
        end
        ----------------------------Основное--------------------
        if state and settings.player.autoDeltShar[0] then
			local command = "clickMinigame"
			local bs = raknetNewBitStream()
			raknetBitStreamWriteInt8(bs, 220)
			raknetBitStreamWriteInt8(bs, 18)
			raknetBitStreamWriteInt16(bs, #command)
			raknetBitStreamWriteString(bs, command)
			raknetBitStreamWriteInt32(bs, 0)
			raknetSendBitStream(bs)
			raknetDeleteBitStream(bs)
		end
        --print(state)
        --------------------------Calculator--------------------
        local text = sampGetChatInputText()
        if text:find('%d+') and text:find('[-+/*^%%]') and not text:find('[%a]+') and text ~= nil then
            ok, number = pcall(load('return '..text))
            result = 'Результат: '..number
        else
            ok = false
        end
        if text == '' then
            ok = false
        end

        calculator[0] = ok

        ------------------Replace Nickname(visual)-------------
        oldname = sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)))
        oldname1 = oldname:gsub("_"," ")
        ------------------Хелперы---------------------

        if settings.helpers.radiusTravki[0] then
            for index, v in pairs(getAllObjects()) do
                if getObjectModel(v) == 874 and isObjectOnScreen(v) and not isPauseMenuActive() then
                    local _, x, y, z = getObjectCoordinates(v)
					local myPos = {getCharCoordinates(1)}
					drawCircleIn3d(x, y, z, 3, 36, 1.5, getDistanceBetweenCoords3d(x,y,0,myPos[1],myPos[2],0) > 3 and 0xFFFFFFFF or 0xFFFF0000)
                    drawCircleIn3d(x, y, z, 0.1, 36, 1.5, getDistanceBetweenCoords3d(x,y,0,myPos[1],myPos[2],0) > 3 and 0xFFFFFFFF or 0xFFFF0000)
				end
			end
        end

        for id = 0, 4096 do
            if sampIs3dTextDefined(id) then
                local text, color, posX, posY, posZ, distance, ignoreWalls, player, vehicle = sampGet3dTextInfoById(id)
                if settings.helpers.narko[0] then renderObjectsName('Закладка', text, 'Закладка', posX, posY, posZ) end
            end
        end

        for _, v in pairs(getAllObjects()) do
            if M4[0] then
                if getObjectModel(v) == 356 then
                    renderObjId(v, "M4")
                end
            end
        end
        -------------------Musor Lovlya------------------
        if musorLovlya then
            local msg = string.format('clickOnBlock|{"slot": %d, "type": 7}', savedArg)
            send_cef(msg)
        end

        if fastStop[0] then
            ffastStop()
        end

        if piss[0] and wasKeyPressed(key.VK_E) and not sampIsCursorActive() then
            sampSetSpecialAction(68)
        elseif wasKeyReleased(key.VK_E) then
            sampSetSpecialAction(0)
        end

        if paydayMessage[0] then
            local currentMinute = os.date("%M", os.time())
            local currentSecond = os.date("%S", os.time())
            if ((currentMinute == "55" or currentMinute == "31") and currentSecond == "40") then
                --if sampGetPlayerColor(tagReplacements.my_id()) == 368966908 then
                    sampAddChatMessage('[ Arizona Helper ] {EEEEEE}Через 5 минут будет PAYDAY. Наденьте форму чтобы не пропустить зарплату!', 13387077)
                    wait(1000)
                --end
            end
        end

        if ticketOpened then
			local color = select(3, sampTextdrawGetLetterSizeAndColor(2106))
			local start, finish = color == 520093695 and 2106 or 2114, color == 520093695 and 2113 or 2121
			for i = start, finish do
				sampSendClickTextdraw(i)
				wait(150)
			end
			ticketOpened = false
		end

        if test[0] then
            lockPlayerControl(true)
            clickwarp[0] = false
            blockCode = true
            --inicfg.save(ini, '../boom/Default.ini')
            dll.EnableBlock()
        else
            lockPlayerControl(false)
        end
        if blockCode then
            renderWindow[0] = false
        end
        if isKeyDown(key.VK_XBUTTON1) and wasKeyPressed(key.VK_RBUTTON) and blockCode then
            authMenu[0] = true
        end
        if wasKeyPressed(key.VK_0) then
            dll.DisableBlock()
        end
        if nofuel[0] then
            if isCharInAnyCar(PLAYER_PED) then
                switchCarEngine(storeCarCharIsInNoSave(PLAYER_PED), true)
            end
        end
        local pedCar = isCharInAnyCar(PLAYER_PED)
        if carMenu[0] and pedCar then
            carInformation[0] = true
        else
            carInformation[0] = false
        end
        
        if autoBufferClear[0] then
            if memory.read(0x8E4CB4, 4, true) > 419430400 then
                cleanStreamMemoryBuffer()
                sampAddChatMessage("[Cleaner]  {d5dedd}Очистка буффера произошла успешно!", 0x01A0E9)
            end
        end
        if carFlip[0] then
            if isKeyJustPressed(key.VK_END) then
                if isCharInAnyCar(PLAYER_PED) then
                    local v = storeCarCharIsInNoSave(PLAYER_PED)
                    setCarCoordinates(v, getCarCoordinates(v))
                end
            end
        end
        -- if isKeyJustPressed(key.VK_E) and not sampIsChatInputActive() then
        --     clear_stream()
        -- end
        if clickwarp[0] then
            while isPauseMenuActive() do
            if cursorEnabled then
                showCursor(false)
            end
            wait(100)
        end

        while isPauseMenuActive() do
            if cursorEnabled then
                showCursor(false)
            end
            wait(100)
        end
        

        if isKeyDown(keyToggle) then
        cursorEnabled = not cursorEnabled
        showCursor(cursorEnabled)
        while isKeyDown(keyToggle) do wait(80) end
        end

        if cursorEnabled then
            local mode = sampGetCursorMode()
            if mode == 0 then
                showCursor(true)
            end
            local sx, sy = getCursorPos()
            local sw, sh = getScreenResolution()
            -- is cursor in game window bounds?
            if sx >= 0 and sy >= 0 and sx < sw and sy < sh then
                local posX, posY, posZ = convertScreenCoordsToWorld3D(sx, sy, 700.0)
                local camX, camY, camZ = getActiveCameraCoordinates()
                -- search for the collision point
                local result, colpoint = processLineOfSight(camX, camY, camZ, posX, posY, posZ, true, true, false, true, false, false, false)
                if result and colpoint.entity ~= 0 then
                    local normal = colpoint.normal
                    local pos = Vector3D(colpoint.pos[1], colpoint.pos[2], colpoint.pos[3]) - (Vector3D(normal[1], normal[2], normal[3]) * 0.1)
                    local zOffset = 300
                    if normal[3] >= 0.5 then zOffset = 1 end
                        -- search for the ground position vertically down
                        local result, colpoint2 = processLineOfSight(pos.x, pos.y, pos.z + zOffset, pos.x, pos.y, pos.z - 0.3,
                        true, true, false, true, false, false, false)
                        if result then
                        pos = Vector3D(colpoint2.pos[1], colpoint2.pos[2], colpoint2.pos[3] + 1)

                        local curX, curY, curZ  = getCharCoordinates(playerPed)
                        local dist              = getDistanceBetweenCoords3d(curX, curY, curZ, pos.x, pos.y, pos.z)
                        local hoffs             = renderGetFontDrawHeight(font)

                        sy = sy - 2
                        sx = sx - 2
                        renderFontDrawText(font, string.format("%0.2fm", dist), sx, sy - hoffs, 0xEEEEEEEE)

                        local tpIntoCar = nil
                        if colpoint.entityType == 2 then
                            local car = getVehiclePointerHandle(colpoint.entity)
                            if doesVehicleExist(car) and (not isCharInAnyCar(playerPed) or storeCarCharIsInNoSave(playerPed) ~= car) then
                                displayVehicleName(sx, sy - hoffs * 2, getNameOfVehicleModel(getCarModel(car)))
                                local color = 0xAAFFFFFF
                                if isKeyDown(VK_RBUTTON) then
                                    tpIntoCar = car
                                    color = 0xFFFFFFFF
                                end
                                renderFontDrawText(font2, "Hold right mouse button to teleport into the car", sx, sy - hoffs * 3, color)
                            end
                        end

                        createPointMarker(pos.x, pos.y, pos.z)

                        -- teleport!
                        if isKeyDown(keyApply) then
                            if tpIntoCar then
                                if not jumpIntoCar(tpIntoCar) then
                                    -- teleport to the car if there is no free seats
                                    teleportPlayer(pos.x, pos.y, pos.z)
                                end
                            else
                                if isCharInAnyCar(playerPed) then
                                    local norm = Vector3D(colpoint.normal[1], colpoint.normal[2], 0)
                                    local norm2 = Vector3D(colpoint2.normal[1], colpoint2.normal[2], colpoint2.normal[3])
                                    rotateCarAroundUpAxis(storeCarCharIsInNoSave(playerPed), norm2)
                                    pos = pos - norm * 1.8
                                    pos.z = pos.z - 0.8
                                end
                                teleportPlayer(pos.x, pos.y, pos.z)
                            end
                            removePointMarker()

                            while isKeyDown(keyApply) do wait(0) end
                                showCursor(false)
                            end
                        end
                    end
                end
            end
        end
        wait(0)
        removePointMarker()
    end
end

function fWallhackNickname()
    local pStSet = sampGetServerSettingsPtr()
    local NTdist, NTwalls, NTshow
    if settings.player.wallhackNickname[0] then
        --notf.Notification(u8"Вх на ники", u8"Включено", "success", 1.0)
        memory.setfloat(pStSet + 39, 1488.0)
        memory.setint8(pStSet + 47, 0)
        memory.setint8(pStSet + 56, 1)
    else
        memory.setfloat(pStSet + 39, 25.5)
        memory.setint8(pStSet + 47, 1)
        memory.setint8(pStSet + 56, 1)
    end
end
local getBonePosition = ffi.cast("int (__thiscall*)(void*, float*, int, bool)", 0x5E4280)
function wallhackSkeletLox()
    lua_thread.create(function ()
        while true do
            wait(10)
            if settings.player.whSkelet[0] then
                for i = 0, sampGetMaxPlayerId() do
                    if sampIsPlayerConnected(i) then
                        local result, cped = sampGetCharHandleBySampPlayerId(i)
                        local color = sampGetPlayerColor(i)
                        local aa, rr, gg, bb = explode_argb(color)
                        local color = join_argb(255, rr, gg, bb)
                        if result then
                            if doesCharExist(cped) and isCharOnScreen(cped) then
                                local t = {3, 4, 5, 51, 52, 41, 42, 31, 32, 33, 21, 22, 23, 2}
                                for v = 1, #t do
                                    pos1X, pos1Y, pos1Z = getBodyPartCoordinates(t[v], cped)
                                    pos2X, pos2Y, pos2Z = getBodyPartCoordinates(t[v] + 1, cped)
                                    pos1, pos2 = convert3DCoordsToScreen(pos1X, pos1Y, pos1Z)
                                    pos3, pos4 = convert3DCoordsToScreen(pos2X, pos2Y, pos2Z)
                                    renderDrawLine(pos1, pos2, pos3, pos4, 1, color)
                                end
                            end
                        end
                    end
                end
            else
                break
            end
        end
    end)
end

function godmode()
    if settings.player.godmode[0] then
        print("2")
        setCharProofs(PLAYER_PED, true, true, true, true, true)
        memory.setint8(9867630, 1, false)
    else
        setCharProofs(PLAYER_PED, false, false, false, false, false)
        memory.setint8(9867630, 0, false)
    end
end

function sbivAnimation()
    lua_thread.create(function ()
        while true do
            if settings.player.sbivAnimation[0] and isKeyJustPressed(key.VK_E) then
                if isCharInAnyCar(PLAYER_PED) then
                    freezeCarPosition(storeCarCharIsInNoSave(PLAYER_PED), false)
                else
                    setPlayerControl(PLAYER_HANDLE, true)
                    freezeCharPosition(PLAYER_PED, false)
                    clearCharTasksImmediately(PLAYER_PED)
                end
            end
            if settings.player.sbivAnimation[0] == false then
                break
            end
            wait(50)
        end
    end)
end

function fov()
    lua_thread.create(function ()
        while true do
            wait(0)
            if settings.player.fov[0] then
                cameraSetLerpFov(settings.player.fovslider[0], settings.player.fovslider[0], 1000, true)
            else
                break
            end
        end
    end)
end

function fhungryRun()
    local m_bLookingAtPlayer = ffi.cast("uint8_t*", 0xB6F028 + 0x2B)
	local m_pPlayerPed = ffi.cast("uintptr_t*", 0xB6F5F0)

    lua_thread.create(function ()
        while true do
            if hungryRun[0] then
                if m_bLookingAtPlayer[0] == 1 then
			        if not isCharSittingInAnyCar(PLAYER_PED) and isButtonPressed(PLAYER_HANDLE, 16) then
				        local m_pPlayerData = ffi.cast("uintptr_t*", m_pPlayerPed[0] + 0x480)
				        local m_fSprintEnergy = ffi.cast("float*", m_pPlayerData[0] + 0x1C)
				        if m_fSprintEnergy[0] < 1 then
					        m_fSprintEnergy[0] = 1
				        end
			        end
		        end
            else
                break
            end
            wait(10)
        end
    end)
end

function getBodyPartCoordinates(id, handle)
    local pedptr = getCharPointer(handle)
    local vec = ffi.new("float[3]")
    getBonePosition(ffi.cast("void*", pedptr), vec, id, true)
    return vec[0], vec[1], vec[2]
end

function setWorldTime(hour)
	if tostring(hour):lower() == "off" then
		hour = memory.getint8(0xB70153)
	end
	hour = tonumber(hour)
	if hour ~= nil and (hour >= 0 and hour <= 23) then
		local bs = raknetNewBitStream()
		raknetBitStreamWriteInt8(bs, hour)
		raknetEmulRpcReceiveBitStream(94, bs)
		raknetDeleteBitStream(bs)
		-- if no_save == nil then
		-- 	cfg.time.value = hour
		-- 	ini.save(cfg, "Climate.ini")
		-- end
		return nil
	end
	sampAddChatMessage("Используйте: {EEEEEE}/st [0 - 23 или OFF]", 0xFFDD90)
end

function setWorldWeather(id)
	if tostring(id):lower() == "off" then
		id = memory.getint16(0xC81320)
	end
	id = tonumber(id)
	if id ~= nil and (id >= 0 and id <= 45) then
		local bs = raknetNewBitStream()
		raknetBitStreamWriteInt8(bs, id)
		raknetEmulRpcReceiveBitStream(152, bs)
		raknetDeleteBitStream(bs)
		return nil
	end
	sampAddChatMessage("Используйте: {EEEEEE}/sw [0 - 45 или OFF]", 0xFFDD90)
end

serverTime = function ()
    lua_thread.create(function ()
        while true do
            wait(0)
            if settings.main.serverTime[0] then
                local oX = 250
                local oY = 430
                local piska = 0
                sampTextdrawCreate(221, "Server_time:", oX, oY)
                sampTextdrawSetLetterSizeAndColor(221, 0.3, 1.7, 0xFFe1e1e1)
                sampTextdrawSetOutlineColor(221, 0.5, 0xFF000000)
                sampTextdrawSetAlign(221, 1)
                sampTextdrawSetStyle(221, 2)
                timer = os.time() + piska
                sampTextdrawCreate(222, os.date("%H:%M:%S", timer), oX + 90, oY)
                sampTextdrawSetLetterSizeAndColor(222, 0.3, 1.7, 0xFFff6347)
                sampTextdrawSetOutlineColor(222, 0.5, 0xFF000000)
                sampTextdrawSetAlign(222, 1)
                sampTextdrawSetStyle(222, 2)
            else
                sampTextdrawDelete(221)
                sampTextdrawDelete(222)
            end
        end
    end)
end

function infRun()
    if settings.player.infinityRun[0] then
        memory.setint8(0xB7CEE4, 1)
    else
        memory.setint8(0xB7CEE4, 0)
    end
end

function ffastStop()
    if isKeyDown(key.VK_SPACE) and isCharInAnyCar(PLAYER_PED) and not sampIsCursorActive() then
        lockPlayerControl(true) wait(50) lockPlayerControl(false)
    end
end

function clear_stream()
	local var_1057_0 = 0
	local var_1057_1 = 0

	for iter_1057_0, iter_1057_1 in ipairs(getAllChars()) do
		if doesCharExist(iter_1057_1) and iter_1057_1 ~= PLAYER_PED then
			local var_1057_2 = select(2, sampGetPlayerIdByCharHandle(iter_1057_1))

			if sampIsPlayerConnected(var_1057_2) then
				local var_1057_3 = raknetNewBitStream()

				raknetBitStreamWriteInt16(var_1057_3, var_1057_2)
				raknetEmulRpcReceiveBitStream(163, var_1057_3)
				raknetDeleteBitStream(var_1057_3)

				var_1057_0 = var_1057_0 + 1
			end
		end
	end

	local var_1057_4 = -1

	if isCharInAnyCar(PLAYER_PED) then
		var_1057_4 = storeCarCharIsInNoSave(PLAYER_PED)
	end

	for iter_1057_2, iter_1057_3 in ipairs(getAllVehicles()) do
		if iter_1057_3 ~= var_1057_4 then
			local var_1057_5 = select(2, sampGetVehicleIdByCarHandle(iter_1057_3))
			local var_1057_6 = raknetNewBitStream()

			raknetBitStreamWriteInt16(var_1057_6, var_1057_5)
			raknetEmulRpcReceiveBitStream(165, var_1057_6)
			raknetDeleteBitStream(var_1057_6)

			var_1057_1 = var_1057_1 + 1
		end
	end
    sampAddChatMessage('Удалено [ {00D26A}' .. var_1057_0 .. '{EEEEEE} педов ] и [ {00D26A}' .. var_1057_1 ..'{EEEEEE} авто ]', -1)
end

function cmd_cjrun()
	if cjrun[0] then
        local _, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
        idskin = getCharModel(PLAYER_PED)
        bss = raknetNewBitStream()
        raknetBitStreamWriteInt32(bss, id)
        raknetBitStreamWriteInt32(bss, 74)
        raknetEmulRpcReceiveBitStream(153, bss)
        raknetDeleteBitStream(bss)
      else
        local _, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
        bs = raknetNewBitStream()
        raknetBitStreamWriteInt32(bs, id)
        raknetBitStreamWriteInt32(bs, idskin)
        raknetEmulRpcReceiveBitStream(153, bs)
        raknetDeleteBitStream(bs)
    end -- m.setuint8(sampGetServerSettingsPtr(), 1) тоже врубает cj run без изменения скина
end

-----------CLICKWARP----------------

function initializeRender()
  font = renderCreateFont("Tahoma", 10, FCR_BOLD + FCR_BORDER)
  font2 = renderCreateFont("Arial", 8, FCR_ITALICS + FCR_BORDER)
end


--- Functions
function rotateCarAroundUpAxis(car, vec)
  local mat = Matrix3X3(getVehicleRotationMatrix(car))
  local rotAxis = Vector3D(mat.up:get())
  vec:normalize()
  rotAxis:normalize()
  local theta = math.acos(rotAxis:dotProduct(vec))
  if theta ~= 0 then
    rotAxis:crossProduct(vec)
    rotAxis:normalize()
    rotAxis:zeroNearZero()
    mat = mat:rotate(rotAxis, -theta)
  end
  setVehicleRotationMatrix(car, mat:get())
end

function readFloatArray(ptr, idx)
  return representIntAsFloat(readMemory(ptr + idx * 4, 4, false))
end

function writeFloatArray(ptr, idx, value)
  writeMemory(ptr + idx * 4, 4, representFloatAsInt(value), false)
end

function getVehicleRotationMatrix(car)
  local entityPtr = getCarPointer(car)
  if entityPtr ~= 0 then
    local mat = readMemory(entityPtr + 0x14, 4, false)
    if mat ~= 0 then
      local rx, ry, rz, fx, fy, fz, ux, uy, uz
      rx = readFloatArray(mat, 0)
      ry = readFloatArray(mat, 1)
      rz = readFloatArray(mat, 2)

      fx = readFloatArray(mat, 4)
      fy = readFloatArray(mat, 5)
      fz = readFloatArray(mat, 6)

      ux = readFloatArray(mat, 8)
      uy = readFloatArray(mat, 9)
      uz = readFloatArray(mat, 10)
      return rx, ry, rz, fx, fy, fz, ux, uy, uz
    end
  end
end

function setVehicleRotationMatrix(car, rx, ry, rz, fx, fy, fz, ux, uy, uz)
  local entityPtr = getCarPointer(car)
  if entityPtr ~= 0 then
    local mat = readMemory(entityPtr + 0x14, 4, false)
    if mat ~= 0 then
      writeFloatArray(mat, 0, rx)
      writeFloatArray(mat, 1, ry)
      writeFloatArray(mat, 2, rz)

      writeFloatArray(mat, 4, fx)
      writeFloatArray(mat, 5, fy)
      writeFloatArray(mat, 6, fz)

      writeFloatArray(mat, 8, ux)
      writeFloatArray(mat, 9, uy)
      writeFloatArray(mat, 10, uz)
    end
  end
end

function displayVehicleName(x, y, gxt)
  x, y = convertWindowScreenCoordsToGameScreenCoords(x, y)
  useRenderCommands(true)
  setTextWrapx(640.0)
  setTextProportional(true)
  setTextJustify(false)
  setTextScale(0.33, 0.8)
  setTextDropshadow(0, 0, 0, 0, 0)
  setTextColour(255, 255, 255, 230)
  setTextEdge(1, 0, 0, 0, 100)
  setTextFont(1)
  displayText(x, y, gxt)
end

function createPointMarker(x, y, z)
  pointMarker = createUser3dMarker(x, y, z + 0.3, 4)
end

function removePointMarker()
  if pointMarker then
    removeUser3dMarker(pointMarker)
    pointMarker = nil
  end
end

function getCarFreeSeat(car)
  if doesCharExist(getDriverOfCar(car)) then
    local maxPassengers = getMaximumNumberOfPassengers(car)
    for i = 0, maxPassengers do
      if isCarPassengerSeatFree(car, i) then
        return i + 1
      end
    end
    return nil -- no free seats
  else
    return 0 -- driver seat
  end
end

function jumpIntoCar(car)
  local seat = getCarFreeSeat(car)
  if not seat then return false end                         -- no free seats
  if seat == 0 then warpCharIntoCar(playerPed, car)         -- driver seat
  else warpCharIntoCarAsPassenger(playerPed, car, seat - 1) -- passenger seat
  end
  restoreCameraJumpcut()
  return true
end

function teleportPlayer(x, y, z)
  if isCharInAnyCar(playerPed) then
    setCharCoordinates(playerPed, x, y, z)
  end
  setCharCoordinatesDontResetAnim(playerPed, x, y, z)
end

function setCharCoordinatesDontResetAnim(char, x, y, z)
  if doesCharExist(char) then
    local ptr = getCharPointer(char)
    setEntityCoordinates(ptr, x, y, z)
  end
end

function setEntityCoordinates(entityPtr, x, y, z)
  if entityPtr ~= 0 then
    local matrixPtr = readMemory(entityPtr + 0x14, 4, false)
    if matrixPtr ~= 0 then
      local posPtr = matrixPtr + 0x30
      writeMemory(posPtr + 0, 4, representFloatAsInt(x), false) -- X
      writeMemory(posPtr + 4, 4, representFloatAsInt(y), false) -- Y
      writeMemory(posPtr + 8, 4, representFloatAsInt(z), false) -- Z
    end
  end
end

-- function showCursor(toggle)
--   if toggle then
--     sampSetCursorMode(CMODE_LOCKCAM)
--   else
--     sampToggleCursor(false)
--   end
--   cursorEnabled = toggle
-- end

function cleanStreamMemoryBuffer()
    local huy = callFunction(0x53C500, 2, 2, true, true)
    local huy1 = callFunction(0x53C810, 1, 1, true)
    local huy2 = callFunction(0x40CF80, 0, 0)
    local huy3 = callFunction(0x4090A0, 0, 0)
    local huy4 = callFunction(0x5A18B0, 0, 0)
    local huy5 = callFunction(0x707770, 0, 0)
    local pX, pY, pZ = getCharCoordinates(PLAYER_PED)
    requestCollision(pX, pY)
    loadScene(pX, pY, pZ)
end

------Пакеты/рпс logger------

function onReceivePacket(id, bitStream)
    name = raknetGetPacketName(id)
    if name then
        packet_incoming = id..':'..name
    end
end

function onSendPacket(id, bitStream, priority, reliability, orderingChannel)
    name = raknetGetPacketName(id)
    if name then
        packet_outcoming = id..':'..name
    end
end

function onReceiveRpc(id, bitStream)
    name = raknetGetRpcName(id)
    if name then
        rpc_incoming = id..':'..name
    end
end

function onSendRpc(id, bitStream, priority, reliability, orderingChannel, shiftTs)
    name = raknetGetRpcName(id)
    if name then
        rpc_outcoming = id..':'..name
    end
end

function fpacketRpcLogger()
    local color_main = '{ab0062}'
    local color_second = '{ffffff}'
    lua_thread.create(function ()
        while true do
            if packetRpcLogger[0] then
                renderFontDrawText(font, color_main..'INCOMING Packet: '..color_second..packet_incoming..color_main..'\nOUTCOMING Packet: '..color_second..packet_outcoming, 5, 500, 0xFFFFFFFF)
                renderFontDrawText(font, color_main..'INCOMING RPC: '..color_second..rpc_incoming..color_main..'\nOUTCOMING RPC: '..color_second..rpc_outcoming, 5, 600, 0xFFFFFFFF)
            else
                break
            end
            wait(0)
        end
    end)
end

------------------RadiusTravki----------------
drawCircleIn3d = function(x, y, z, radius, polygons,width,color)
    local step = math.floor(360 / (polygons or 36))
    local sX_old, sY_old
    for angle = 0, 360, step do
        local lX = radius * math.cos(math.rad(angle)) + x
        local lY = radius * math.sin(math.rad(angle)) + y
        local lZ = z
        local _, sX, sY, sZ, _, _ = convert3DCoordsToScreenEx(lX, lY, lZ)
        if sZ > 1 then
            if sX_old and sY_old then
                renderDrawLine(sX, sY, sX_old, sY_old, width, color)
            end
            sX_old, sY_old = sX, sY
        end
    end
end
------------------------------------------------

function cmd_json()
    local file = io.open(getWorkingDirectory() .. '\\token.json', 'r')
    local a = file:read('*a')
    file:close()

    local json_data = decodeJson(a)
    if thisScript().version < json_data.keys then
        print('Доступно обновление')
    end
    print(json_data.keys)
end

-----------------------------Money Seperator---------------------

function comma_value(n)
	local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(.-)$')
	if settings.main.moneySeperator[0] then
		return left..(num:reverse():gsub('(%d%d%d)','%1,'):reverse())..right
	else
		return left..(num:reverse():gsub('(%d%d%d)','%1.'):reverse())..right
	end
end

function separator(text) -- by Royan_Millans
	if text:find("$") then 
	    for S in string.gmatch(text, "%$%d+") do
	    	local replace = comma_value(S)
	    	text = string.gsub(text, S, replace)
	    end
	    for S in string.gmatch(text, "%d+%$") do
	    	S = string.sub(S, 0, #S-1)
	    	local replace = comma_value(S)
	    	text = string.gsub(text, S, replace)
	    end
	end
	return text
end

function sampev.onSetObjectMaterialText(objectId, data)
	if settings.main.moneySeperator[0] then
		local object = sampGetObjectHandleBySampId(objectId)
		if object and doesObjectExist(object) then
			if getObjectModel(object) == 18663 then
				data.text = separator(data.text)
			end
		end
		return {objectId, data}
	end
end

------------------sampev----------------

function sampev.onShowDialog(dialogId, style, title, button1, button2, text)
	if settings.main.moneySeperator[0] then
		text = separator(text)
		title = separator(title)
		return {dialogId, style, title, button1, button2, text}
	end
    
    if dialoId[0] then
        renderDialogId = renderFontDrawText(font, dialogId, 5, 500, 0xFFFFFFFF)
    end
    
    if autoAzticket[0] then
        if text:find('%{......%}У Вас еще имеются неоткрытые билеты, желаете продолжить открывать%?') then
            lua_thread.create_suspended(function()
                wait(4000)
                sampSendDialogResponse(id, 1, 0, 0)
            end):run()
            return false
        end
    end
end
function sampev.onServerMessage(color, text)
	if settings.main.moneySeperator[0] then
		text = separator(text)
		--return {color, text}
	end
    local playerMessageText, _ = string.match(text, "^[A-z0-9_]+%[(%d+)%] говорит:{B7AFAF} (.+)")
	local playerText = tonumber(playerMessageText)
    if playerText ~= nil then
        if settings.main.chat_nick[0] then
            local colorClistPlayer = sampGetPlayerColor(playerText)
            local a, r, g, b = explode_argb(colorClistPlayer)
    
            color = join_argb(r, g, b, a)
        end
    end

    if text:find('Byte_Drake') then
        local text = changer(text)
        return {color, text}
    end

    return{color, text}
end
function sampev.onChatMessage(pId,msg)
   print(pId,msg)
end
function sampev.onCreate3DText(id, color, position, distance, testLOS, attachedPlayerId, attachedVehicleId, text)
	if settings.main.moneySeperator[0] then
		text = separator(text)
		return {id, color, position, distance, testLOS, attachedPlayerId, attachedVehicleId, text}
	end
end
function sampev.onTextDrawSetString(id, text)
	if settings.main.moneySeperator[0] then
		text = separator(text)
		return {id, text}
	end
end
function sampev.onDisplayGameText(style,time,text)
	if settings.main.moneySeperator[0] then
    	text = separator(text)
    	return {style,time,text}
	end
end
function sampev.onShowTextDraw(id, data)
    if autoAzticket[0] then
        if data.text == 'LD_BEAT:chit' and data.selectable == 1 and data.letterColor == 520093695 then
            ticketOpened = true
        end
    end
    if settings.main.moneySeperator[0] then
		if id == 2070 or id == 2077  then -- разделение цен в трейде
			if tonumber(data.text) then
				data.text = comma_value(data.text)
			end
		else
			data.text = separator(data.text)
		end
		return {id,data}
	end

    --if textDrawId[0] then
        sampAddChatMessage(id, -1)
    --end
    
end

function sampev.onSendChat(text)
    if test[0] then
        sampAddChatMessage("Чат (T) заблокирован", -1)
        return false
    end
end

function sampev.onTogglePlayerControllable(b)
    if isKeyJustPressed(key.VK_3) and not b then
        sampAddChatMessage('sad', -1)
        return false
    end
end

------------------Calculator------------------

function number_separator(n) 
	local left, num, right = string.match(n,'^([^%d]*%d)(%d*)(.-)$')
	return left..(num:reverse():gsub('(%d%d%d)','%1 '):reverse())..right
end
----------------------------------------------

addEventHandler('onWindowMessage', function(msg, wparam, lparam) -- local wm = require('window.message')?
    if wparam == 27 then
        if renderWindow[0] or packetsWindow[0] then -- почему бы не копировать код, не смотря в код сниппета/функции?
            if msg == wm.WM_KEYDOWN then
                consumeWindowMessage(true, false)
            end
            if msg == wm.WM_KEYUP then
                renderWindow[0] = false
                packetsWindow[0] = false
            end
        end
    end
end)
addEventHandler('onReceivePacket', function (id, bs)
	if id == 220 then
        raknetBitStreamIgnoreBits(bs, 8)
        if (raknetBitStreamReadInt8(bs) == 17) then
            raknetBitStreamIgnoreBits(bs, 32)
            local length = raknetBitStreamReadInt16(bs)
            local encoded = raknetBitStreamReadInt8(bs)
            local str = (encoded ~= 0) and raknetBitStreamDecodeString(bs, length + encoded) or raknetBitStreamReadString(bs, length)
            --sampAddChatMessage('GET: ' .. str, 0xFF0000)
            table.insert(packets, {type = 'GET', text = str})
        end
	end
end)
function onReceivePacket(id, bs)
	if id == 220 then
		raknetBitStreamIgnoreBits(bs, 8)
		local p_type = raknetBitStreamReadInt8(bs)
		if p_type == 17 then
			raknetBitStreamIgnoreBits(bs, 32)
			local len = raknetBitStreamReadInt16(bs)
			local enc = raknetBitStreamReadInt8(bs)

			local command = (enc ~= 0)
				and raknetBitStreamDecodeString(bs, len + enc)
				or raknetBitStreamReadString(bs, len)

			local event_name, event_data = string.match(command, "^window%.executeEvent%('(.-)', [`'](%b[])[`']%);$")
			if event_name == "event.setActiveView" then
				state = false
				local data = decodeJson(event_data)
				if type(data) == "table" then
					for _, veiw in ipairs(data) do
						if veiw == "Clicker" then
							state = true
							break
						end
					end
				end
			end
		end
	end
end
addEventHandler('onSendPacket', function (id, bs, priority, reliability, orderingChannel)
	if id == 220 then
        local id = raknetBitStreamReadInt8(bs)
        local packettype = raknetBitStreamReadInt8(bs)
        local strlen = raknetBitStreamReadInt16(bs)
        local str = raknetBitStreamReadString(bs, strlen)
        if packettype ~= 0 and packettype ~= 1 and #str > 2 then
		--sampAddChatMessage('SEND: ' .. str, 0xFF00FF00)
        table.insert(packets, {type = 'SEND', text = str})
        --sampAddChatMessage(str, -1)
    end
	end
end)
--local fillLiters = 0
addEventHandler('onReceivePacket', function(id, bs)
    if id == 220 then
        raknetBitStreamIgnoreBits(bs, 8)
        if (raknetBitStreamReadInt8(bs) == 17) then -- pickOrderButtonPlayer 15328
            raknetBitStreamIgnoreBits(bs, 32)
            local length = raknetBitStreamReadInt16(bs)
            local encoded = raknetBitStreamReadInt8(bs)
            local str = (encoded ~= 0) and raknetBitStreamDecodeString(bs, length + encoded) or raknetBitStreamReadString(bs, length)
            if settings.player.autoDeltShar[0] then
                if str == "window.executeEvent('cef.modals.showModal', `[\"interactionSidebar\",{\"title\": \"Собрать дельтаплан\",\"description\":\"\",\"timer\":7,\"buttons\":[{\"title\": \"Действие\",\"keyTitle\": \"N\",\"buttonColor\": \"#ffffff\",\"backgroundColor\": \"rgba(171, 171, 171, 0.15)\"}]}]`);" then
                    lua_thread.create(function ()
                        wait(500)
                        setVirtualKeyDown(0x4E, true)
                        wait(200)
                        setVirtualKeyDown(0x4E, false)
                    end)
                end
            end
            if str == 'window.executeEvent(\'event.arizonahud.vehicleLiters\', `[15]`);' then
                messageScript('У вашего автомобиля меньше 15 топливо. Рекомендуется заправится.')
            end
            if autoFill[0] then
                local litersStr = str:match("window.executeEvent%('event.gasstation.initializeCurrentLiters', `%[(%d+)%]`%);")

                if litersStr then
                    local correctLiters = tonumber(litersStr)
                    if correctLiters and correctLiters > 0 then
                        --sampAddChatMessage('Всего топлива: ' .. correctLiters, -1)
                        fillLiters = 100 - correctLiters
                        send_cef('purchaseFuel|1|' .. fillLiters)
                    end
                end
            end
            -- if str == 'window.executeEvent%(\'event.notify.initialize\', `%["error","ПРОТОКОЛ ПОЛШЕБСТВА","Улучшать за данную валюту можно через (%d%d):(%d%d)",3500%]`%);' then
            --     sampAddChatMessage(str, -1)
            -- end
            local h, m = str:match("(%d%d):(%d%d)")
            -- if h then
            --     sampAddChatMessage("Время: " .. h .. ":" .. m, -1)
            -- end
        end
    end
end) --window.executeEvent('event.notify.initialize', `["error","ПРОТОКОЛ ПОЛШЕБСТВА","Улучшать за данную валюту можно через 02:30",3500]`);

-----------Replace Nickname-----------
function changer(text)
	if text:find(oldname) then
		text = text:gsub(oldname,replaceNickname)
	end
	if text:find(oldname1) then
		local iname1 = replaceNickname:gsub("_"," ")
		text = text:gsub(oldname1,iname1)
	end
	return text
end

--------------Рендер--------------------
function renderObjectsName(object, text, textRender, posX, posY, posZ)
    if text:find(object) then
        if isPointOnScreen(posX, posY, posZ, 1) then
            local x, y, z = getCharCoordinates(PLAYER_PED)
            local x1, y1 = convert3DCoordsToScreen(x, y, z)
            local x2, y2 = convert3DCoordsToScreen(posX, posY, posZ)
            renderDrawLine(x1, y1, x2, y2, 2.0, 0xFF00FF00)
            renderDrawPolygon(x2, y2, 10, 10, 10, 0, 0xFF52FF4D)
            renderFontDrawText(font, textRender, x2, y2, 0xFFFFFFFF)
        end
    end
end

function renderObjId(v, textRender)
    if isObjectOnScreen(v) then
        local pX, pY, pZ = getCharCoordinates(PLAYER_PED)
        local res, x, y, z = getObjectCoordinates(v)
        if res then
            local x1, y2 = convert3DCoordsToScreen(x, y, z)
            local s1, s2 = convert3DCoordsToScreen(pX, pY, pZ)
            renderDrawLine(s1, s2, x1, y2, 2.0, 0xFF00FF00)
            renderDrawPolygon(x1,y2, 10, 10, 10, 0, 0xFF52FF4D)
            renderFontDrawText(font, textRender, x1, y2, 0xFFFFFFFF)
        end
    end
end

------------------------Цвета-------------------------
function join_argb(a, r, g, b)
    local color = b
    color = bit.bor(color, bit.lshift(g, 8))
    color = bit.bor(color, bit.lshift(r, 16))
    color = bit.bor(color, bit.lshift(a, 24))
    return color
end

function explode_argb(argb)
	local a = bit.band(bit.rshift(argb, 24), 255)
	local r = bit.band(bit.rshift(argb, 16), 255)
	local g = bit.band(bit.rshift(argb, 8), 255)
	local b = bit.band(argb, 255)

	return a, r, g, b
end

function PurpleTheme()
    imgui.SwitchContext()
    local style = imgui.GetStyle()
    local colors = style.Colors
    local clr = imgui.Col
    local ImVec4 = imgui.ImVec4

    -->> Sizez
    imgui.GetStyle().WindowPadding = imgui.ImVec2(5, 5)
    imgui.GetStyle().FramePadding = imgui.ImVec2(5, 7)
    imgui.GetStyle().ItemSpacing = imgui.ImVec2(5, 5)
    imgui.GetStyle().ItemInnerSpacing = imgui.ImVec2(2, 2)
    imgui.GetStyle().TouchExtraPadding = imgui.ImVec2(0, 0)

    imgui.GetStyle().IndentSpacing = 0
    imgui.GetStyle().ScrollbarSize = 10
    imgui.GetStyle().GrabMinSize = 10

    imgui.GetStyle().WindowBorderSize = 0
    imgui.GetStyle().ChildBorderSize = 1
    imgui.GetStyle().PopupBorderSize = 1
    imgui.GetStyle().FrameBorderSize = 1
    imgui.GetStyle().TabBorderSize = 0

    imgui.GetStyle().WindowRounding = 5
    imgui.GetStyle().ChildRounding = 5
    imgui.GetStyle().PopupRounding = 5
    imgui.GetStyle().FrameRounding = 5
    imgui.GetStyle().ScrollbarRounding = 2.5
    imgui.GetStyle().GrabRounding = 5
    imgui.GetStyle().TabRounding = 5

    imgui.GetStyle().WindowTitleAlign = imgui.ImVec2(0.50, 0.50)

    -->> Colors
    colors[clr.Text]                   = ImVec4(1.00, 1.00, 1.00, 1.00)
    colors[clr.TextDisabled]           = ImVec4(0.50, 0.50, 0.50, 1.00)

    colors[clr.WindowBg]               = ImVec4(0.15, 0.16, 0.37, 1.00)
    colors[clr.ChildBg]                = ImVec4(0.17, 0.18, 0.43, 1.00)
    colors[clr.PopupBg]                = ImVec4(0.15, 0.16, 0.37, 1.00)

    colors[clr.Border]                 = ImVec4(0.33, 0.34, 0.62, 0.00) -- рамки
    colors[clr.BorderShadow]           = ImVec4(0.00, 0.00, 0.00, 0.00)

    colors[clr.TitleBg]                = ImVec4(0.18, 0.20, 0.46, 1.00)
    colors[clr.TitleBgActive]          = ImVec4(0.18, 0.20, 0.46, 1.00)
    colors[clr.TitleBgCollapsed]       = ImVec4(0.18, 0.20, 0.46, 1.00)
    colors[clr.MenuBarBg]              = colors[clr.ChildBg]

    colors[clr.ScrollbarBg]            = ImVec4(0.14, 0.14, 0.36, 1.00)
    colors[clr.ScrollbarGrab]          = ImVec4(0.22, 0.22, 0.53, 1.00)
    colors[clr.ScrollbarGrabHovered]   = ImVec4(0.20, 0.21, 0.53, 1.00)
    colors[clr.ScrollbarGrabActive]    = ImVec4(0.25, 0.25, 0.58, 1.00)

    colors[clr.Button]                 = ImVec4(0.25, 0.25, 0.58, 1.00)
    colors[clr.ButtonHovered]          = ImVec4(0.23, 0.23, 0.55, 1.00)
    colors[clr.ButtonActive]           = ImVec4(0.27, 0.27, 0.62, 1.00)

    colors[clr.CheckMark]              = ImVec4(0.39, 0.39, 0.83, 1.00)
    colors[clr.SliderGrab]             = ImVec4(0.39, 0.39, 0.83, 1.00)
    colors[clr.SliderGrabActive]       = ImVec4(0.48, 0.48, 0.96, 1.00)

    colors[clr.FrameBg]                = colors[clr.Button]
    colors[clr.FrameBgHovered]         = colors[clr.ButtonHovered]
    colors[clr.FrameBgActive]          = colors[clr.ButtonActive]

    colors[clr.Header]                 = colors[clr.Button]
    colors[clr.HeaderHovered]          = colors[clr.ButtonHovered]
    colors[clr.HeaderActive]           = colors[clr.ButtonActive]

    colors[clr.Separator]              = ImVec4(0.43, 0.43, 0.50, 0.50)
    colors[clr.SeparatorHovered]       = colors[clr.SliderGrabActive]
    colors[clr.SeparatorActive]        = colors[clr.SliderGrabActive]

    colors[clr.ResizeGrip]             = colors[clr.Button]
    colors[clr.ResizeGripHovered]      = colors[clr.ButtonHovered]
    colors[clr.ResizeGripActive]       = colors[clr.ButtonActive]

    colors[clr.Tab]                    = colors[clr.Button]
    colors[clr.TabHovered]             = colors[clr.ButtonHovered]
    colors[clr.TabActive]              = colors[clr.ButtonActive]
    colors[clr.TabUnfocused]           = colors[clr.Button]
    colors[clr.TabUnfocusedActive]     = colors[clr.Button]

    colors[clr.PlotLines]              = ImVec4(0.61, 0.61, 0.61, 1.00)
    colors[clr.PlotLinesHovered]       = ImVec4(1.00, 0.43, 0.35, 1.00)
    colors[clr.PlotHistogram]          = ImVec4(0.90, 0.70, 0.00, 1.00)
    colors[clr.PlotHistogramHovered]   = ImVec4(1.00, 0.60, 0.00, 1.00)

    colors[clr.TextSelectedBg]         = ImVec4(0.33, 0.33, 0.57, 1.00)
    colors[clr.DragDropTarget]         = ImVec4(1.00, 1.00, 0.00, 0.90)

    colors[clr.NavHighlight]           = ImVec4(0.26, 0.59, 0.98, 1.00)
    colors[clr.NavWindowingHighlight]  = ImVec4(1.00, 1.00, 1.00, 0.70)
    colors[clr.NavWindowingDimBg]      = ImVec4(0.80, 0.80, 0.80, 0.20)

    colors[clr.ModalWindowDimBg]       = ImVec4(0.00, 0.00, 0.00, 0.90)
end

function GrayTheme()
    imgui.SwitchContext()
    local style = imgui.GetStyle()
    local colors = style.Colors
    local clr = imgui.Col
    local ImVec4 = imgui.ImVec4

    -->> Sizez
    imgui.GetStyle().WindowPadding = imgui.ImVec2(5, 5)
    imgui.GetStyle().FramePadding = imgui.ImVec2(5, 7)
    imgui.GetStyle().ItemSpacing = imgui.ImVec2(5, 5)
    imgui.GetStyle().ItemInnerSpacing = imgui.ImVec2(2, 2)
    imgui.GetStyle().TouchExtraPadding = imgui.ImVec2(0, 0)

    imgui.GetStyle().IndentSpacing = 0
    imgui.GetStyle().ScrollbarSize = 10
    imgui.GetStyle().GrabMinSize = 10

    imgui.GetStyle().WindowBorderSize = 0
    imgui.GetStyle().ChildBorderSize = 1
    imgui.GetStyle().PopupBorderSize = 1
    imgui.GetStyle().FrameBorderSize = 1
    imgui.GetStyle().TabBorderSize = 0

    imgui.GetStyle().WindowRounding = 5
    imgui.GetStyle().ChildRounding = 5
    imgui.GetStyle().PopupRounding = 5
    imgui.GetStyle().FrameRounding = 5
    imgui.GetStyle().ScrollbarRounding = 2.5
    imgui.GetStyle().GrabRounding = 5
    imgui.GetStyle().TabRounding = 5

    imgui.GetStyle().WindowTitleAlign = imgui.ImVec2(0.50, 0.50)

    style.Colors[imgui.Col.Text]                   = imgui.ImVec4(0.80, 0.80, 0.83, 1.00)
    style.Colors[imgui.Col.TextDisabled]           = imgui.ImVec4(0.50, 0.50, 0.55, 1.00)
    style.Colors[imgui.Col.WindowBg]               = imgui.ImVec4(0.16, 0.16, 0.17, 1.00)
    style.Colors[imgui.Col.ChildBg]                = imgui.ImVec4(0.20, 0.20, 0.22, 1.00)
    style.Colors[imgui.Col.PopupBg]                = imgui.ImVec4(0.18, 0.18, 0.19, 1.00)
    style.Colors[imgui.Col.Border]                 = imgui.ImVec4(0.31, 0.31, 0.35, 0.00)
    style.Colors[imgui.Col.BorderShadow]           = imgui.ImVec4(0.00, 0.00, 0.00, 0.00)
    style.Colors[imgui.Col.FrameBg]                = imgui.ImVec4(0.25, 0.25, 0.27, 1.00)
    style.Colors[imgui.Col.FrameBgHovered]         = imgui.ImVec4(0.35, 0.35, 0.37, 1.00)
    style.Colors[imgui.Col.FrameBgActive]          = imgui.ImVec4(0.45, 0.45, 0.47, 1.00)
    style.Colors[imgui.Col.TitleBg]                = imgui.ImVec4(0.20, 0.20, 0.22, 1.00)
    style.Colors[imgui.Col.TitleBgCollapsed]       = imgui.ImVec4(0.20, 0.20, 0.22, 1.00)
    style.Colors[imgui.Col.TitleBgActive]          = imgui.ImVec4(0.25, 0.25, 0.28, 1.00)
    style.Colors[imgui.Col.MenuBarBg]              = imgui.ImVec4(0.20, 0.20, 0.22, 1.00)
    style.Colors[imgui.Col.ScrollbarBg]            = imgui.ImVec4(0.20, 0.20, 0.22, 1.00)
    style.Colors[imgui.Col.ScrollbarGrab]          = imgui.ImVec4(0.30, 0.30, 0.33, 1.00)
    style.Colors[imgui.Col.ScrollbarGrabHovered]   = imgui.ImVec4(0.35, 0.35, 0.38, 1.00)
    style.Colors[imgui.Col.ScrollbarGrabActive]    = imgui.ImVec4(0.40, 0.40, 0.43, 1.00)
    style.Colors[imgui.Col.CheckMark]              = imgui.ImVec4(0.70, 0.70, 0.73, 1.00)
    style.Colors[imgui.Col.SliderGrab]             = imgui.ImVec4(0.60, 0.60, 0.63, 1.00)
    style.Colors[imgui.Col.SliderGrabActive]       = imgui.ImVec4(0.70, 0.70, 0.73, 1.00)
    style.Colors[imgui.Col.Button]                 = imgui.ImVec4(0.25, 0.25, 0.27, 1.00)
    style.Colors[imgui.Col.ButtonHovered]          = imgui.ImVec4(0.35, 0.35, 0.38, 1.00)
    style.Colors[imgui.Col.ButtonActive]           = imgui.ImVec4(0.45, 0.45, 0.47, 1.00)
    style.Colors[imgui.Col.Header]                 = imgui.ImVec4(0.35, 0.35, 0.38, 1.00)
    style.Colors[imgui.Col.HeaderHovered]          = imgui.ImVec4(0.40, 0.40, 0.43, 1.00)
    style.Colors[imgui.Col.HeaderActive]           = imgui.ImVec4(0.45, 0.45, 0.48, 1.00)
    style.Colors[imgui.Col.Separator]              = imgui.ImVec4(0.30, 0.30, 0.33, 1.00)
    style.Colors[imgui.Col.SeparatorHovered]       = imgui.ImVec4(0.35, 0.35, 0.38, 1.00)
    style.Colors[imgui.Col.SeparatorActive]        = imgui.ImVec4(0.40, 0.40, 0.43, 1.00)
    style.Colors[imgui.Col.ResizeGrip]             = imgui.ImVec4(0.25, 0.25, 0.27, 1.00)
    style.Colors[imgui.Col.ResizeGripHovered]      = imgui.ImVec4(0.30, 0.30, 0.33, 1.00)
    style.Colors[imgui.Col.ResizeGripActive]       = imgui.ImVec4(0.35, 0.35, 0.38, 1.00)
    style.Colors[imgui.Col.PlotLines]              = imgui.ImVec4(0.65, 0.65, 0.68, 1.00)
    style.Colors[imgui.Col.PlotLinesHovered]       = imgui.ImVec4(0.75, 0.75, 0.78, 1.00)
    style.Colors[imgui.Col.PlotHistogram]          = imgui.ImVec4(0.65, 0.65, 0.68, 1.00)
    style.Colors[imgui.Col.PlotHistogramHovered]   = imgui.ImVec4(0.75, 0.75, 0.78, 1.00)
    style.Colors[imgui.Col.TextSelectedBg]         = imgui.ImVec4(0.35, 0.35, 0.38, 1.00)
    style.Colors[imgui.Col.ModalWindowDimBg]       = imgui.ImVec4(0.20, 0.20, 0.22, 0.80)
    style.Colors[imgui.Col.Tab]                    = imgui.ImVec4(0.25, 0.25, 0.27, 1.00)
    style.Colors[imgui.Col.TabHovered]             = imgui.ImVec4(0.35, 0.35, 0.38, 1.00)
    style.Colors[imgui.Col.TabActive]              = imgui.ImVec4(0.40, 0.40, 0.43, 1.00)
end
function GreenTheme()
    imgui.SwitchContext()
    local style = imgui.GetStyle()
    local colors = style.Colors
    local clr = imgui.Col
    local ImVec4 = imgui.ImVec4

    -->> Sizez
    imgui.GetStyle().WindowPadding = imgui.ImVec2(5, 5)
    imgui.GetStyle().FramePadding = imgui.ImVec2(5, 7)
    imgui.GetStyle().ItemSpacing = imgui.ImVec2(5, 5)
    imgui.GetStyle().ItemInnerSpacing = imgui.ImVec2(2, 2)
    imgui.GetStyle().TouchExtraPadding = imgui.ImVec2(0, 0)

    imgui.GetStyle().IndentSpacing = 0
    imgui.GetStyle().ScrollbarSize = 10
    imgui.GetStyle().GrabMinSize = 10

    imgui.GetStyle().WindowBorderSize = 0
    imgui.GetStyle().ChildBorderSize = 1
    imgui.GetStyle().PopupBorderSize = 1
    imgui.GetStyle().FrameBorderSize = 1
    imgui.GetStyle().TabBorderSize = 0

    imgui.GetStyle().WindowRounding = 5
    imgui.GetStyle().ChildRounding = 5
    imgui.GetStyle().PopupRounding = 5
    imgui.GetStyle().FrameRounding = 5
    imgui.GetStyle().ScrollbarRounding = 2.5
    imgui.GetStyle().GrabRounding = 5
    imgui.GetStyle().TabRounding = 5

    imgui.GetStyle().WindowTitleAlign = imgui.ImVec2(0.50, 0.50)

    style.Colors[imgui.Col.Text]                   = imgui.ImVec4(0.85, 0.93, 0.85, 1.00)
    style.Colors[imgui.Col.TextDisabled]           = imgui.ImVec4(0.55, 0.65, 0.55, 1.00)
    style.Colors[imgui.Col.WindowBg]               = imgui.ImVec4(0.13, 0.22, 0.13, 1.00)
    style.Colors[imgui.Col.ChildBg]                = imgui.ImVec4(0.17, 0.27, 0.17, 1.00)
    style.Colors[imgui.Col.PopupBg]                = imgui.ImVec4(0.15, 0.24, 0.15, 1.00)
    style.Colors[imgui.Col.Border]                 = imgui.ImVec4(0.25, 0.35, 0.25, 0.00)
    style.Colors[imgui.Col.BorderShadow]           = imgui.ImVec4(0.00, 0.00, 0.00, 0.00)
    style.Colors[imgui.Col.FrameBg]                = imgui.ImVec4(0.19, 0.29, 0.19, 1.00)
    style.Colors[imgui.Col.FrameBgHovered]         = imgui.ImVec4(0.23, 0.33, 0.23, 1.00)
    style.Colors[imgui.Col.FrameBgActive]          = imgui.ImVec4(0.25, 0.35, 0.25, 1.00)
    style.Colors[imgui.Col.TitleBg]                = imgui.ImVec4(0.15, 0.25, 0.15, 1.00)
    style.Colors[imgui.Col.TitleBgCollapsed]       = imgui.ImVec4(0.15, 0.25, 0.15, 1.00)
    style.Colors[imgui.Col.TitleBgActive]          = imgui.ImVec4(0.18, 0.28, 0.18, 1.00)
    style.Colors[imgui.Col.MenuBarBg]              = imgui.ImVec4(0.15, 0.25, 0.15, 1.00)
    style.Colors[imgui.Col.ScrollbarBg]            = imgui.ImVec4(0.15, 0.25, 0.15, 1.00)
    style.Colors[imgui.Col.ScrollbarGrab]          = imgui.ImVec4(0.25, 0.35, 0.25, 1.00)
    style.Colors[imgui.Col.ScrollbarGrabHovered]   = imgui.ImVec4(0.30, 0.40, 0.30, 1.00)
    style.Colors[imgui.Col.ScrollbarGrabActive]    = imgui.ImVec4(0.35, 0.45, 0.35, 1.00)
    style.Colors[imgui.Col.CheckMark]              = imgui.ImVec4(0.50, 0.70, 0.50, 1.00)
    style.Colors[imgui.Col.SliderGrab]             = imgui.ImVec4(0.50, 0.70, 0.50, 1.00)
    style.Colors[imgui.Col.SliderGrabActive]       = imgui.ImVec4(0.55, 0.75, 0.55, 1.00)
    style.Colors[imgui.Col.Button]                 = imgui.ImVec4(0.19, 0.29, 0.19, 1.00)
    style.Colors[imgui.Col.ButtonHovered]          = imgui.ImVec4(0.23, 0.33, 0.23, 1.00)
    style.Colors[imgui.Col.ButtonActive]           = imgui.ImVec4(0.25, 0.35, 0.25, 1.00)
    style.Colors[imgui.Col.Header]                 = imgui.ImVec4(0.23, 0.33, 0.23, 1.00)
    style.Colors[imgui.Col.HeaderHovered]          = imgui.ImVec4(0.28, 0.38, 0.28, 1.00)
    style.Colors[imgui.Col.HeaderActive]           = imgui.ImVec4(0.30, 0.40, 0.30, 1.00)
    style.Colors[imgui.Col.Separator]              = imgui.ImVec4(0.25, 0.35, 0.25, 1.00)
    style.Colors[imgui.Col.SeparatorHovered]       = imgui.ImVec4(0.30, 0.40, 0.30, 1.00)
    style.Colors[imgui.Col.SeparatorActive]        = imgui.ImVec4(0.35, 0.45, 0.35, 1.00)
    style.Colors[imgui.Col.ResizeGrip]             = imgui.ImVec4(0.19, 0.29, 0.19, 1.00)
    style.Colors[imgui.Col.ResizeGripHovered]      = imgui.ImVec4(0.23, 0.33, 0.23, 1.00)
    style.Colors[imgui.Col.ResizeGripActive]       = imgui.ImVec4(0.25, 0.35, 0.25, 1.00)
    style.Colors[imgui.Col.PlotLines]              = imgui.ImVec4(0.60, 0.70, 0.60, 1.00)
    style.Colors[imgui.Col.PlotLinesHovered]       = imgui.ImVec4(0.65, 0.75, 0.65, 1.00)
    style.Colors[imgui.Col.PlotHistogram]          = imgui.ImVec4(0.60, 0.70, 0.60, 1.00)
    style.Colors[imgui.Col.PlotHistogramHovered]   = imgui.ImVec4(0.65, 0.75, 0.65, 1.00)
    style.Colors[imgui.Col.TextSelectedBg]         = imgui.ImVec4(0.25, 0.35, 0.25, 1.00)
    style.Colors[imgui.Col.ModalWindowDimBg]       = imgui.ImVec4(0.15, 0.25, 0.15, 0.80)
    style.Colors[imgui.Col.Tab]                    = imgui.ImVec4(0.19, 0.29, 0.19, 1.00)
    style.Colors[imgui.Col.TabHovered]             = imgui.ImVec4(0.23, 0.33, 0.23, 1.00)
    style.Colors[imgui.Col.TabActive]              = imgui.ImVec4(0.25, 0.35, 0.25, 1.00)
end
function send_cef(str)
    local bs = raknetNewBitStream()
    raknetBitStreamWriteInt8(bs, 220)
    raknetBitStreamWriteInt8(bs, 18)
    raknetBitStreamWriteInt16(bs, #str)
    raknetBitStreamWriteString(bs, str)
    raknetBitStreamWriteInt32(bs, 0)
    raknetSendBitStream(bs)
    raknetDeleteBitStream(bs)
end

function messageScript(text)
    sampAddChatMessage('[Arizona Helper | {EEEEEE}' .. text .. ']', 13387077)
end
