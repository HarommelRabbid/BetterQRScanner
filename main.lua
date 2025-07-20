white, black, blue = color.new(255, 255, 255), color.new(0, 0, 0), color.new(0, 0, 255)

function LifeLuaNetworkDownload(read, wrote, size, speed)
draw.text(10, 10, read.." B read & wrote", white)
draw.text(10, 30, math.floor((wrote*100)/size).."% downloaded", white)
draw.text(10, 50, size.." B total", white)
draw.gradientrect(0, 544-39, (wrote*960)/size, 39, white, blue, white, blue)
draw.swapbuffers()
end

menu_res = os.message("Better QR Scanner by Harommel OddSock",
SCE_MSG_DIALOG_BUTTON_TYPE_3BUTTONS, "Scan QR Codes", SCE_MSG_DIALOG_FONT_SIZE_DEFAULT, "Generate QR Code", SCE_MSG_DIALOG_FONT_SIZE_DEFAULT, "Exit", SCE_MSG_DIALOG_FONT_SIZE_DEFAULT)

if menu_res == "Scan QR Codes" then
camera.start(SCE_CAMERA_DEVICE_BACK, SCE_CAMERA_RESOLUTION_640_480)
local mode = 1
while true do
camera.output():display(480-(640/2), 272-(480/2))
controls.update()
if controls.released(SCE_CTRL_ACCEPT) then
local res = camera.output():qrscan()
if res then
if res:find("^https://") or res:find("^http://") then 
local res1 = os.message(res, SCE_MSG_DIALOG_BUTTON_TYPE_3BUTTONS, "Open URL", SCE_MSG_DIALOG_FONT_SIZE_DEFAULT, "Download URL", SCE_MSG_DIALOG_FONT_SIZE_DEFAULT, "Close", SCE_MSG_DIALOG_FONT_SIZE_DEFAULT)

if res1 == "Open URL" then os.uri(res, 0x20000)
elseif res1 == "Download URL" then
local path = os.keyboard("Path where to save (including filename)", "ux0:downloads", SCE_IME_DIALOG_TYPE_DEFAULT, SCE_IME_DIALOG_TEXTBOX_MODE_WITH_CLEAR, SCE_IME_OPTION_NO_AUTO_CAPITALIZATION)
if path then network.download(res, path) end
end
else os.message(res) end
end
end
if controls.released(SCE_CTRL_SELECT) then
if mode == 1 then
camera.stop()
camera.start(SCE_CAMERA_DEVICE_FRONT, SCE_CAMERA_RESOLUTION_640_480)
mode = 2
elseif mode == 2 then
camera.stop()
camera.start(SCE_CAMERA_DEVICE_BACK, SCE_CAMERA_RESOLUTION_640_480)
mode = 1
end
end
if controls.released(SCE_CTRL_START) then camera.stop() dofile("main.lua") end
draw.swapbuffers()
end
elseif menu_res == "Generate QR Code" then
local text = os.keyboard("Text for the QR code")
if not text then dofile("main.lua") end
local r = tonumber(os.keyboard("Red color intensity", 0, SCE_IME_TYPE_NUMBER)) or 0
local g = tonumber(os.keyboard("Green color intensity", 0, SCE_IME_TYPE_NUMBER)) or 0
local b = tonumber(os.keyboard("Blue color intensity", 0, SCE_IME_TYPE_NUMBER)) or 0
local border = tonumber(os.keyboard("Border size", 0, SCE_IME_TYPE_NUMBER)) or 2
local qr = image.qr{text=text, fg_color=color.new(r, g, b), border = border}
while true do
qr:scaledisplay(480-(qr:width()/2)*2, 272-(qr:height()/2)*2, 2, 2)
controls.update()
if controls.released(SCE_CTRL_START) then dofile("main.lua") end
if controls.released(SCE_CTRL_CROSS) then os.screenshotcapture() end
draw.swapbuffers()
end
elseif menu_res == "Exit" then
os.exit()
end
