--[[
============================================================
  HUY PHAM HUB - Blox Fruits Script
  Author: Huy Pham Hub (@HuyPhamHub)
  Version: 1.0
  UI: Obsidian (Black & White)
============================================================
]]

print("[Huy Pham Hub] boot midnight...")

-- HUY PHAM HUB - SERVER KEY GATE
-- Sau khi deploy server, thay API_BASE bằng URL HTTPS thật của server.
-- Không đặt ADMIN_SECRET trong Lua/client.
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local API_BASE = "https://YOUR-DEPLOYED-SERVER.example" -- THAY BẰNG URL SERVER THẬT
local GET_KEY_URL = "https://realmakehub-cell.github.io/taokeyhuyphamhub/"
local verified = false

local function sendVerifyRequest(key)
    local body = HttpService:JSONEncode({key = key})
    local req = (syn and syn.request) or (http and http.request) or http_request or request
    if type(req) ~= "function" then
        return false, "Executor không hỗ trợ request HTTP"
    end
    local ok, response = pcall(function()
        return req({
            Url = API_BASE .. "/api/verify",
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = body
        })
    end)
    if not ok or type(response) ~= "table" then
        return false, "Không kết nối được máy chủ Key"
    end
    local statusCode = response.StatusCode or response.Status or 0
    local responseBody = response.Body or response.body or ""
    local parsedOk, data = pcall(function() return HttpService:JSONDecode(responseBody) end)
    if not parsedOk or type(data) ~= "table" then
        return false, "Phản hồi server không hợp lệ (HTTP " .. tostring(statusCode) .. ")"
    end
    if data.ok == true then return true, data end
    return false, data.error or "Key sai hoặc đã hết hạn"
end

local gui = Instance.new("ScreenGui")
gui.Name = "HuyPhamKeySystem"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
pcall(function() gui.Parent = game:GetService("CoreGui") end)
if not gui.Parent then gui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local function make(class, props, parent)
    local obj = Instance.new(class)
    for k,v in pairs(props) do obj[k] = v end
    obj.Parent = parent
    return obj
end
local function corner(obj, radius) make("UICorner", {CornerRadius=UDim.new(0,radius)}, obj) end
local function stroke(obj, color, thickness) make("UIStroke", {Color=color, Thickness=thickness or 1, Transparency=0.25}, obj) end
local black=Color3.fromRGB(7,9,12); local panel=Color3.fromRGB(13,16,20); local white=Color3.fromRGB(245,247,250); local muted=Color3.fromRGB(157,169,181)
local main=make("Frame",{Name="KeyWindow",AnchorPoint=Vector2.new(.5,.5),Position=UDim2.fromScale(.5,.5),Size=UDim2.fromOffset(720,420),BackgroundColor3=black,BorderSizePixel=0},gui); corner(main,16); stroke(main,Color3.fromRGB(85,95,106),1)
local scale=make("UIScale",{Scale=1},main)
local function resize()
    local cam=workspace.CurrentCamera
    if cam then scale.Scale=math.clamp(math.min(cam.ViewportSize.X/760,cam.ViewportSize.Y/460),0.58,1) end
end
resize(); if workspace.CurrentCamera then workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(resize) end
make("Frame",{Position=UDim2.new(0,0,0,74),Size=UDim2.new(1,0,0,1),BackgroundColor3=Color3.fromRGB(36,42,49),BorderSizePixel=0},main)
make("TextLabel",{BackgroundTransparency=1,Position=UDim2.fromOffset(24,12),Size=UDim2.fromOffset(48,48),Font=Enum.Font.GothamBlack,Text="♛",TextColor3=white,TextSize=42},main)
make("TextLabel",{BackgroundTransparency=1,Position=UDim2.fromOffset(82,12),Size=UDim2.fromOffset(330,32),Font=Enum.Font.GothamBold,Text="HUY PHAM HUB",TextColor3=white,TextSize=25,TextXAlignment=Enum.TextXAlignment.Left},main)
make("TextLabel",{BackgroundTransparency=1,Position=UDim2.fromOffset(83,43),Size=UDim2.fromOffset(250,20),Font=Enum.Font.Gotham,Text="Blox Fruits Script",TextColor3=muted,TextSize=14,TextXAlignment=Enum.TextXAlignment.Left},main)
local close=make("TextButton",{Position=UDim2.new(1,-48,0,15),Size=UDim2.fromOffset(32,32),BackgroundTransparency=1,Text="×",TextColor3=white,Font=Enum.Font.Gotham,TextSize=30},main)
close.MouseButton1Click:Connect(function() gui:Destroy() end)
local sidebar=make("Frame",{Position=UDim2.fromOffset(16,91),Size=UDim2.fromOffset(185,312),BackgroundColor3=panel,BorderSizePixel=0},main); corner(sidebar,10)
local nav=make("TextLabel",{BackgroundTransparency=1,Position=UDim2.fromOffset(16,15),Size=UDim2.new(1,-30,0,30),Text="◆   KEY SYSTEM",TextColor3=white,Font=Enum.Font.GothamBold,TextSize=16,TextXAlignment=Enum.TextXAlignment.Left},sidebar)
make("TextLabel",{BackgroundTransparency=1,Position=UDim2.fromOffset(16,56),Size=UDim2.new(1,-30,0,28),Text="●   Farm",TextColor3=Color3.fromRGB(80,87,95),Font=Enum.Font.Gotham,TextSize=15,TextXAlignment=Enum.TextXAlignment.Left},sidebar)
make("TextLabel",{BackgroundTransparency=1,Position=UDim2.fromOffset(16,91),Size=UDim2.new(1,-30,0,28),Text="●   Combat",TextColor3=Color3.fromRGB(80,87,95),Font=Enum.Font.Gotham,TextSize=15,TextXAlignment=Enum.TextXAlignment.Left},sidebar)
make("TextLabel",{BackgroundTransparency=1,Position=UDim2.fromOffset(16,126),Size=UDim2.new(1,-30,0,28),Text="●   Teleports",TextColor3=Color3.fromRGB(80,87,95),Font=Enum.Font.Gotham,TextSize=15,TextXAlignment=Enum.TextXAlignment.Left},sidebar)
make("TextLabel",{BackgroundTransparency=1,Position=UDim2.fromOffset(16,161),Size=UDim2.new(1,-30,0,28),Text="●   Player",TextColor3=Color3.fromRGB(80,87,95),Font=Enum.Font.Gotham,TextSize=15,TextXAlignment=Enum.TextXAlignment.Left},sidebar)
make("TextLabel",{BackgroundTransparency=1,Position=UDim2.fromOffset(16,196),Size=UDim2.new(1,-30,0,28),Text="●   Item",TextColor3=Color3.fromRGB(80,87,95),Font=Enum.Font.Gotham,TextSize=15,TextXAlignment=Enum.TextXAlignment.Left},sidebar)
make("TextLabel",{BackgroundTransparency=1,Position=UDim2.fromOffset(16,231),Size=UDim2.new(1,-30,0,28),Text="⚙   Settings",TextColor3=Color3.fromRGB(80,87,95),Font=Enum.Font.Gotham,TextSize=15,TextXAlignment=Enum.TextXAlignment.Left},sidebar)
make("TextLabel",{BackgroundTransparency=1,Position=UDim2.fromOffset(16,274),Size=UDim2.new(1,-30,0,24),Text="HUY PHAM HUB  •  V1.0",TextColor3=muted,Font=Enum.Font.Gotham,TextSize=10,TextXAlignment=Enum.TextXAlignment.Left},sidebar)
local content=make("Frame",{Position=UDim2.fromOffset(215,91),Size=UDim2.new(1,-231,1,-107),BackgroundColor3=panel,BorderSizePixel=0},main); corner(content,12); stroke(content,Color3.fromRGB(39,47,56),1)
make("TextLabel",{BackgroundTransparency=1,Position=UDim2.fromOffset(28,20),Size=UDim2.new(1,-50,0,36),Text="⚿   KEY SYSTEM",TextColor3=white,Font=Enum.Font.GothamBold,TextSize=25,TextXAlignment=Enum.TextXAlignment.Left},content)
make("TextLabel",{BackgroundTransparency=1,Position=UDim2.fromOffset(30,57),Size=UDim2.new(1,-50,0,24),Text="Vui lòng nhập Key để sử dụng script",TextColor3=muted,Font=Enum.Font.Gotham,TextSize=14,TextXAlignment=Enum.TextXAlignment.Left},content)
local getKey = make("TextButton",{Position=UDim2.new(1,-132,0,17),Size=UDim2.fromOffset(104,32),BackgroundColor3=Color3.fromRGB(30,36,43),Text="↗  LẤY KEY",TextColor3=white,Font=Enum.Font.GothamBold,TextSize=12},content); corner(getKey,7); stroke(getKey,Color3.fromRGB(79,91,103),1)
getKey.MouseButton1Click:Connect(function()
    local opened = pcall(function() game:GetService("GuiService"):OpenBrowserWindow(GET_KEY_URL) end)
    if not opened then
        local copied = pcall(function() if setclipboard then setclipboard(GET_KEY_URL) end end)
        status.Text = copied and "Đã thử sao chép link lấy key" or "Mở link lấy key: " .. GET_KEY_URL
        status.TextColor3 = Color3.fromRGB(170,205,255)
    end
end)
local input=make("TextBox",{Position=UDim2.fromOffset(28,103),Size=UDim2.new(1,-56,0,48),BackgroundColor3=Color3.fromRGB(8,11,15),Text="",PlaceholderText="Nhập key của bạn...",PlaceholderColor3=muted,TextColor3=white,Font=Enum.Font.Gotham,TextSize=15,ClearTextOnFocus=false},content); corner(input,8); stroke(input,Color3.fromRGB(79,91,103),1)
local verify=make("TextButton",{Position=UDim2.fromOffset(28,164),Size=UDim2.new(1,-56,0,48),BackgroundColor3=white,Text="✓   XÁC NHẬN",TextColor3=Color3.fromRGB(8,10,12),Font=Enum.Font.GothamBold,TextSize=16},content); corner(verify,8)
local info=make("Frame",{Position=UDim2.fromOffset(28,225),Size=UDim2.new(1,-56,0,55),BackgroundColor3=Color3.fromRGB(20,25,31),BorderSizePixel=0},content); corner(info,8)
make("TextLabel",{BackgroundTransparency=1,Position=UDim2.fromOffset(14,7),Size=UDim2.new(1,-25,0,22),Text="◷   Thời hạn key: 24 giờ",TextColor3=white,Font=Enum.Font.GothamBold,TextSize=14,TextXAlignment=Enum.TextXAlignment.Left},info)
make("TextLabel",{BackgroundTransparency=1,Position=UDim2.fromOffset(14,29),Size=UDim2.new(1,-25,0,18),Text="Lấy key tại nút LẤY KEY; xác minh cần server API.",TextColor3=muted,Font=Enum.Font.Gotham,TextSize=10,TextXAlignment=Enum.TextXAlignment.Left},info)
local status=make("TextLabel",{BackgroundTransparency=1,Position=UDim2.fromOffset(30,289),Size=UDim2.new(1,-60,0,22),Text="●  Đang chờ nhập Key",TextColor3=muted,Font=Enum.Font.Gotham,TextSize=12,TextXAlignment=Enum.TextXAlignment.Left},content)
local checking = false
local function validate()
    if checking then return false end
    local key = tostring(input.Text or ""):gsub("^%s+", ""):gsub("%s+$", "")
    if key == "" then
        status.Text = "✕  Vui lòng nhập Key trước"
        status.TextColor3 = Color3.fromRGB(255,105,105)
        return false
    end
    checking = true
    verify.Text = "ĐANG KIỂM TRA..."
    status.Text = "●  Đang xác minh với máy chủ..."
    status.TextColor3 = muted
    local valid, result = sendVerifyRequest(key)
    checking = false
    verify.Text = "✓   XÁC NHẬN"
    if valid then
        verified = true
        status.Text = "✓  Key hợp lệ! Đang mở menu..."
        status.TextColor3 = Color3.fromRGB(120,235,160)
        task.wait(0.65)
        if gui and gui.Parent then gui:Destroy() end
        return true
    end
    status.Text = "✕  " .. tostring(result)
    status.TextColor3 = Color3.fromRGB(255,105,105)
    input.Text = ""
    input.PlaceholderText = "Key sai/hết hạn, hãy nhập lại..."
    return false
end
local ok = false
verify.MouseButton1Click:Connect(function() if validate() then ok = true end end)
input.FocusLost:Connect(function(enterPressed) if enterPressed and validate() then ok = true end end)
repeat task.wait(0.1) until ok

-- Chỉ khởi tạo menu/script chính sau khi vượt qua Key Gate
loadstring(game:HttpGet("https://raw.githubusercontent.com/nyannos/Ui-Script/refs/heads/main/fps"))()

-- ============================================================
-- KHỞI TẠO BIẾN TOÀN CỤC
-- ============================================================
do
    ply = game.Players
    plr = ply.LocalPlayer or ply.PlayerAdded:Wait()
    local t0 = tick()
    while (not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart")) and tick() - t0 < 20 do
        task.wait(0.1)
    end
end

Root = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
replicated = game:GetService("ReplicatedStorage")
pcall(function()
    plr:WaitForChild("Data", 10)
    if plr:FindFirstChild("Data") then
        plr.Data:WaitForChild("Level", 5)
    end
end)
Lv = (plr:FindFirstChild("Data") and plr.Data:FindFirstChild("Level") and plr.Data.Level.Value) or 1

TeleportService = game:GetService("TeleportService")
TW = game:GetService("TweenService")
Lighting = game:GetService("Lighting")
Enemies = workspace:FindFirstChild("Enemies") or workspace

pcall(function() vim1 = game:GetService("VirtualInputManager") end)
pcall(function() vim2 = game:GetService("VirtualUser") end)

TeamSelf = plr.Team
RunSer = game:GetService("RunService")
Stats = game:GetService("Stats")

Energy = 0
pcall(function()
    if plr.Character and plr.Character:FindFirstChild("Energy") then
        Energy = plr.Character.Energy.Value
    end
end)

BringConnections = {}
BossList = {}
MaterialList = {}
NPCList = {}
shouldTween = false
SoulGuitar = false
KenTest = true
debug = false
Brazier1 = false
Brazier2 = false
Brazier3 = false
Sec = 0.1
ClickState = 0
Num_self = 25

pcall(function()
    plr.CharacterAdded:Connect(function(char)
        local hrp = char:WaitForChild("HumanoidRootPart", 10)
        if hrp then Root = hrp end
    end)
end)

-- Loading timeout
do
    local t0 = tick()
    repeat
        local loading = plr.PlayerGui and plr.PlayerGui:FindFirstChild("Main")
        loading = loading and loading:FindFirstChild("Loading")
        task.wait(0.1)
    until (game:IsLoaded() and not (loading and loading.Visible)) or (tick() - t0 > 20)
end
print("[Huy Pham Hub] game ready")

-- ============================================================
-- XÁC ĐỊNH WORLD
-- ============================================================
World1 = game.PlaceId == 2753915549 or game.PlaceId == 85211729168715
World2 = game.PlaceId == 4442272183 or game.PlaceId == 79091703265657
World3 = game.PlaceId == 7449423635 or game.PlaceId == 100117331123089

Marines = function()
    replicated.Remotes.CommF_:InvokeServer("SetTeam", "Marines")
end
Pirates = function()
    replicated.Remotes.CommF_:InvokeServer("SetTeam", "Pirates")
end

if World1 then
    BossList = {"The Gorilla King", "Bobby", "The Saw", "Yeti", "Mob Leader", "Vice Admiral", "Saber Expert", "Warden", "Chief Warden", "Swan", "Magma Admiral", "Fishman Lord", "Wysper", "Thunder God", "Cyborg", "Ice Admiral", "Greybeard"}
elseif World2 then
    BossList = {"Diamond", "Jeremy", "Orbitus", "Don Swan", "Smoke Admiral", "Awakened Ice Admiral", "Tide Keeper", "Darkbeard", "Cursed Captain", "Order"}
elseif World3 then
    BossList = {"Stone", "Hydra Leader", "Kilo Admiral", "Captain Elephant", "Beautiful Pirate", "Cake Queen", "Dough King", "Longma", "Soul Reaper", "rip_indra True Form", "Tyrant of the Skies"}
end

if World1 then
    MaterialList = {"Leather + Scrap Metal", "Angel Wings", "Magma Ore", "Fish Tail"}
elseif World2 then
    MaterialList = {"Leather + Scrap Metal", "Radioactive Material", "Ectoplasm", "Mystic Droplet", "Magma Ore", "Vampire Fang"}
elseif World3 then
    MaterialList = {"Scrap Metal", "Demonic Wisp", "Conjured Cocoa", "Dragon Scale", "Gunpowder", "Fish Tail", "Mini Tusk"}
end

local DungeonTables = {"Flame", "Ice", "Quake", "Light", "Dark", "String", "Rumble", "Magma", "Human: Buddha", "Sand", "Bird: Phoenix", "Dough"}
local RenMon = {"Snow Lurker", "Arctic Warrior", "Hidden Key", "Awakened Ice Admiral"}
local CursedTables = {["Mob"] = "Mythological Pirate", ["Mob2"] = "Cursed Skeleton", "Hell's Messenger", ["Mob3"] = "Cursed Skeleton", "Heaven's Guardian"}
local Past = {"Part", "SpawnLocation", "Terrain", "WedgePart", "MeshPart"}
local BartMon = {"Swan Pirate", "Jeremy"}
local CitizenTable = {"Forest Pirate", "Captain Elephant"}
local Human_v3_Mob = {"Fajita", "Jeremy", "Diamond"}
local AllBoats = {"Beast Hunter", "Lantern", "Guardian", "Grand Brigade", "Dinghy", "Sloop", "The Sentinel"}
local mastery1 = {"Cookie Crafter"}
local mastery2 = {"Reborn Skeleton"}

local PosMsList = {
    ["Pirate Millionaire"] = CFrame.new(-712.8272705078125, 98.5770492553711, 5711.9541015625),
    ["Pistol Billionaire"] = CFrame.new(-723.4331665039062, 147.42906188964844, 5931.9931640625),
    ["Dragon Crew Warrior"] = CFrame.new(7021.50439453125, 55.76270294189453, -730.1290893554688),
    ["Dragon Crew Archer"] = CFrame.new(6625, 378, 244),
    ["Female Islander"] = CFrame.new(4692.7939453125, 797.9766845703125, 858.8480224609375),
    ["Venomous Assailant"] = CFrame.new(4902, 670, 39),
    ["Marine Commodore"] = CFrame.new(2401, 123, -7589),
    ["Marine Rear Admiral"] = CFrame.new(3588, 229, -7085),
    ["Fishman Raider"] = CFrame.new(-10941, 332, -8760),
    ["Fishman Captain"] = CFrame.new(-11035, 332, -9087),
    ["Forest Pirate"] = CFrame.new(-13446, 413, -7760),
    ["Mythological Pirate"] = CFrame.new(-13510, 584, -6987),
    ["Jungle Pirate"] = CFrame.new(-11778, 426, -10592),
    ["Musketeer Pirate"] = CFrame.new(-13282, 496, -9565),
    ["Reborn Skeleton"] = CFrame.new(-8764, 142, 5963),
    ["Living Zombie"] = CFrame.new(-10227, 421, 6161),
    ["Demonic Soul"] = CFrame.new(-9579, 6, 6194),
    ["Posessed Mummy"] = CFrame.new(-9579, 6, 6194),
    ["Peanut Scout"] = CFrame.new(-1993, 187, -10103),
    ["Peanut President"] = CFrame.new(-2215, 159, -10474),
    ["Ice Cream Chef"] = CFrame.new(-877, 118, -11032),
    ["Ice Cream Commander"] = CFrame.new(-877, 118, -11032),
    ["Cookie Crafter"] = CFrame.new(-2021, 38, -12028),
    ["Cake Guard"] = CFrame.new(-2024, 38, -12026),
    ["Baking Staff"] = CFrame.new(-1932, 38, -12848),
    ["Head Baker"] = CFrame.new(-1932, 38, -12848),
    ["Cocoa Warrior"] = CFrame.new(95, 73, -12309),
    ["Chocolate Bar Battler"] = CFrame.new(647, 42, -12401),
    ["Sweet Thief"] = CFrame.new(116, 36, -12478),
    ["Candy Rebel"] = CFrame.new(47, 61, -12889),
    ["Ghost"] = CFrame.new(5251, 5, 1111)
}

-- ============================================================
-- REMOTES
-- ============================================================
local Remotes = { RFJobsRemoteFunction = nil, RFCraft = nil }
pcall(function()
    local mods = replicated:WaitForChild("Modules", 8)
    local net = mods and mods:WaitForChild("Net", 5)
    if net then
        Remotes.RFJobsRemoteFunction = net:FindFirstChild("RF/JobsRemoteFunction")
        Remotes.RFCraft = net:FindFirstChild("RF/Craft") or net:WaitForChild("RF/Craft", 3)
    end
end)

-- ============================================================
-- HÀM TIỆN ÍCH CƠ BẢN
-- ============================================================
EquipWeapon = function(text)
    if not text then return end
    if plr.Backpack:FindFirstChild(text) then
        plr.Character.Humanoid:EquipTool(plr.Backpack:FindFirstChild(text))
    end
end

weaponSc = function(weapon)
    for _, v in pairs(plr.Backpack:GetChildren()) do
        if v:IsA("Tool") and v.ToolTip == weapon then
            EquipWeapon(v.Name)
        end
    end
end

-- ============================================================
-- ATTACK MODULE
-- ============================================================
local Attack = {}
Attack.__index = Attack

Attack.Alive = function(model)
    if not model then return end
    local Humanoid = model:FindFirstChild("Humanoid")
    return Humanoid and Humanoid.Health > 0
end

Attack.Pos = function(model, dist)
    return (Root.Position - model.Position).Magnitude <= dist
end

Attack.Dist = function(model, dist)
    return (Root.Position - model:FindFirstChild("HumanoidRootPart").Position).Magnitude <= dist
end

Attack.DistH = function(model, dist)
    return (Root.Position - model:FindFirstChild("HumanoidRootPart").Position).Magnitude > dist
end

Attack.Kill = function(model, Succes)
    if model and Succes then
        if not model:GetAttribute("Locked") then
            model:SetAttribute("Locked", model.HumanoidRootPart.CFrame)
        end
        PosMon = model:GetAttribute("Locked").Position
        BringEnemy()
        EquipWeapon(_G.SelectWeapon)
        local Equipped = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
        if not Equipped then return end
        local ToolTip = Equipped.ToolTip
        if ToolTip == "Blox Fruit" then
            _tp(model.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0) * CFrame.Angles(0, math.rad(90), 0))
        else
            _tp(model.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0) * CFrame.Angles(0, math.rad(180), 0))
        end
        if RandomCFrame then
            wait(.5) _tp(model.HumanoidRootPart.CFrame * CFrame.new(0, 30, 25))
            wait(.5) _tp(model.HumanoidRootPart.CFrame * CFrame.new(25, 30, 0))
            wait(.5) _tp(model.HumanoidRootPart.CFrame * CFrame.new(-25, 30, 0))
            wait(.5) _tp(model.HumanoidRootPart.CFrame * CFrame.new(0, 30, 25))
            wait(.5) _tp(model.HumanoidRootPart.CFrame * CFrame.new(-25, 30, 0))
        end
    end
end

Attack.Kill2 = function(model, Succes)
    if model and Succes then
        if not model:GetAttribute("Locked") then
            model:SetAttribute("Locked", model.HumanoidRootPart.CFrame)
        end
        PosMon = model:GetAttribute("Locked").Position
        BringEnemy()
        EquipWeapon(_G.SelectWeapon)
        local Equipped = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
        if not Equipped then return end
        local ToolTip = Equipped.ToolTip
        if ToolTip == "Blox Fruit" then
            _tp(model.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0) * CFrame.Angles(0, math.rad(90), 0))
        else
            _tp(model.HumanoidRootPart.CFrame * CFrame.new(0, 30, 8) * CFrame.Angles(0, math.rad(180), 0))
        end
        if RandomCFrame then
            wait(0.1) _tp(model.HumanoidRootPart.CFrame * CFrame.new(0, 30, 25))
            wait(0.1) _tp(model.HumanoidRootPart.CFrame * CFrame.new(25, 30, 0))
            wait(0.1) _tp(model.HumanoidRootPart.CFrame * CFrame.new(-25, 30, 0))
            wait(0.1) _tp(model.HumanoidRootPart.CFrame * CFrame.new(0, 30, 25))
            wait(0.1) _tp(model.HumanoidRootPart.CFrame * CFrame.new(-25, 30, 0))
        end
    end
end

Attack.KillSea = function(model, Succes)
    if model and Succes then
        if not model:GetAttribute("Locked") then
            model:SetAttribute("Locked", model.HumanoidRootPart.CFrame)
        end
        PosMon = model:GetAttribute("Locked").Position
        BringEnemy()
        EquipWeapon(_G.SelectWeapon)
        local Equipped = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
        if not Equipped then return end
        local ToolTip = Equipped.ToolTip
        if ToolTip == "Blox Fruit" then
            _tp(model.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0) * CFrame.Angles(0, math.rad(90), 0))
        else
            notween(model.HumanoidRootPart.CFrame * CFrame.new(0, 50, 8))
            wait(.85)
            notween(model.HumanoidRootPart.CFrame * CFrame.new(0, 400, 0))
            wait(1)
        end
    end
end

Attack.Sword = function(model, Succes)
    if model and Succes then
        if not model:GetAttribute("Locked") then
            model:SetAttribute("Locked", model.HumanoidRootPart.CFrame)
        end
        PosMon = model:GetAttribute("Locked").Position
        BringEnemy()
        weaponSc("Sword")
        _tp(model.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
        if RandomCFrame then
            wait(0.1) _tp(model.HumanoidRootPart.CFrame * CFrame.new(0, 30, 25))
            wait(0.1) _tp(model.HumanoidRootPart.CFrame * CFrame.new(25, 30, 0))
            wait(0.1) _tp(model.HumanoidRootPart.CFrame * CFrame.new(-25, 30, 0))
            wait(0.1) _tp(model.HumanoidRootPart.CFrame * CFrame.new(0, 30, 25))
            wait(0.1) _tp(model.HumanoidRootPart.CFrame * CFrame.new(-25, 30, 0))
        end
    end
end

Attack.Mas = function(model, Succes)
    if model and Succes then
        if not model:GetAttribute("Locked") then
            model:SetAttribute("Locked", model.HumanoidRootPart.CFrame)
        end
        PosMon = model:GetAttribute("Locked").Position
        BringEnemy()
        if model.Humanoid.Health <= HealthM then
            _tp(model.HumanoidRootPart.CFrame * CFrame.new(0, 20, 0))
            Useskills("Blox Fruit", "Z")
            Useskills("Blox Fruit", "X")
            Useskills("Blox Fruit", "C")
        else
            weaponSc("Melee")
            _tp(model.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
        end
    end
end

Attack.Masgun = function(model, Succes)
    if model and Succes then
        if not model:GetAttribute("Locked") then
            model:SetAttribute("Locked", model.HumanoidRootPart.CFrame)
        end
        PosMon = model:GetAttribute("Locked").Position
        BringEnemy()
        if model.Humanoid.Health <= HealthM then
            _tp(model.HumanoidRootPart.CFrame * CFrame.new(0, 35, 8))
            Useskills("Gun", "Z")
            Useskills("Gun", "X")
        else
            weaponSc("Melee")
            _tp(model.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
        end
    end
end

-- ============================================================
-- STATS
-- ============================================================
statsSetings = function(Num, value)
    if not plr.Data or not plr.Data.Points then return end
    if plr.Data.Points.Value == 0 then return end
    if Num == "Melee" then
        replicated.Remotes.CommF_:InvokeServer("AddPoint", "Melee", value)
    elseif Num == "Defense" then
        replicated.Remotes.CommF_:InvokeServer("AddPoint", "Defense", value)
    elseif Num == "Sword" then
        replicated.Remotes.CommF_:InvokeServer("AddPoint", "Sword", value)
    elseif Num == "Gun" then
        replicated.Remotes.CommF_:InvokeServer("AddPoint", "Gun", value)
    elseif Num == "Devil" then
        replicated.Remotes.CommF_:InvokeServer("AddPoint", "Demon Fruit", value)
    end
end

-- ============================================================
-- BRING ENEMY (gom mob)
-- ============================================================
BringEnemy = function(Mon)
    if not _B then return end
    if not Mon then
        local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local closestDist = math.huge
        for _, enemy in ipairs(workspace.Enemies:GetChildren()) do
            local hum = enemy:FindFirstChildOfClass("Humanoid")
            local root = enemy:FindFirstChild("HumanoidRootPart")
            if hum and root and hum.Health > 0 then
                local dist = (root.Position - hrp.Position).Magnitude
                if dist < closestDist then
                    closestDist = dist
                    Mon = enemy
                end
            end
        end
        if not Mon then return end
    end
    local AreaMob = false
    local function Mobs(enemy)
        local hum = enemy:FindFirstChildOfClass("Humanoid")
        local root = enemy:FindFirstChild("HumanoidRootPart")
        return hum and root and hum.Health > 0, root, hum
    end
    local function Network(part)
        if isnetworkowner then return isnetworkowner(part) end
        return part.ReceiveAge == 0 and not part.Anchored and part.Velocity.Magnitude > 0
    end
    pcall(function()
        if sethiddenproperty then
            sethiddenproperty(plr, "SimulationRadius", math.huge)
        end
        local targetPos = Mon.HumanoidRootPart.Position
        for _, v in ipairs(workspace.Enemies:GetChildren()) do
            if v ~= Mon then
                local alive, root, hum = Mobs(v)
                if alive and v.Name == Mon.Name then
                    local distance = (root.Position - targetPos).Magnitude
                    if distance <= 3000 then
                        local bv = root:FindFirstChild("BodyVelocity")
                        if not bv then
                            bv = Instance.new("BodyVelocity")
                            bv.Name = "BodyVelocity"
                            bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
                            bv.Velocity = Vector3.zero
                            bv.Parent = root
                        end
                        if distance <= 10 then AreaMob = true end
                        if not AreaMob and Network(root) then
                            root.CFrame = CFrame.new(targetPos)
                        end
                        root.CanCollide = false
                        hum.WalkSpeed = 0
                        hum.JumpPower = 0
                    end
                end
            end
        end
        if Mon and Mon:FindFirstChild("HumanoidRootPart") then
            Mon.HumanoidRootPart.CanCollide = false
            Mon.Humanoid.WalkSpeed = 0
            Mon.Humanoid.JumpPower = 0
        end
    end)
end

-- ============================================================
-- USESKILLS
-- ============================================================
Useskills = function(weapon, skill)
    local keyMap = {Z = "Z", X = "X", C = "C", V = "V", F = "F", Y = "Y"}
    if not keyMap[skill] then return end
    if weapon == "Melee" or weapon == "Sword" or weapon == "Blox Fruit" or weapon == "Gun" then
        weaponSc(weapon)
    end
    if weapon == "nil" and skill ~= "Y" then return end
    pcall(function()
        vim1:SendKeyEvent(true, skill, false, game)
        vim1:SendKeyEvent(false, skill, false, game)
    end)
end

-- ============================================================
-- METATABLE HOOK (Aimbot / Farm Mastery)
-- ============================================================
local gg = getrawmetatable(game)
local old = gg.__namecall
setreadonly(gg, false)
gg.__namecall = newcclosure(function(...)
    local method = getnamecallmethod()
    local args = {...}
    if tostring(method) == "FireServer" then
        if tostring(args[1]) == "RemoteEvent" then
            if tostring(args[2]) ~= "true" and tostring(args[2]) ~= "false" then
                if (_G.FarmMastery_G and not SoulGuitar) or (_G.FarmMastery_Dev) or (_G.FarmBlazeEM) or (_G.Prehis_Skills) or (_G.SeaBeast1 or _G.FishBoat or _G.PGB or _G.Leviathan1 or _G.Complete_Trials) or (_G.AimMethod and ABmethod == "Aim Player") or (_G.AimMethod and ABmethod == "Nearest Aim") then
                    args[2] = MousePos
                    return old(unpack(args))
                end
            end
        end
    end
    return old(...)
end)

-- ============================================================
-- GET CONNECTION ENEMIES
-- ============================================================
GetConnectionEnemies = function(a)
    for i, v in pairs(replicated:GetChildren()) do
        if v:IsA("Model") and ((typeof(a) == "table" and table.find(a, v.Name)) or v.Name == a) and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
            return v
        end
    end
    for i, v in next, game.Workspace.Enemies:GetChildren() do
        if v:IsA("Model") and ((typeof(a) == "table" and table.find(a, v.Name)) or v.Name == a) and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
            return v
        end
    end
end

-- ============================================================
-- LOW CPU / GRAPHICS
-- ============================================================
LowCpu = function()
    local decalsyeeted = true
    local g = game
    local w = g.Workspace
    local l = g.Lighting
    local t = w.Terrain
    t.WaterWaveSize = 0
    t.WaterWaveSpeed = 0
    t.WaterReflectance = 0
    t.WaterTransparency = 0
    l.GlobalShadows = false
    l.FogEnd = 9e9
    l.Brightness = 0
    settings().Rendering.QualityLevel = "Level01"
    for i, v in pairs(g:GetDescendants()) do
        if v:IsA("Part") or v:IsA("Union") or v:IsA("CornerWedgePart") or v:IsA("TrussPart") then
            v.Material = "Plastic"
            v.Reflectance = 0
        elseif v:IsA("Decal") or v:IsA("Texture") and decalsyeeted then
            v.Transparency = 1
        elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
            v.Lifetime = NumberRange.new(0)
        elseif v:IsA("Explosion") then
            v.BlastPressure = 1
            v.BlastRadius = 1
        elseif v:IsA("Fire") or v:IsA("SpotLight") or v:IsA("Smoke") or v:IsA("Sparkles") then
            v.Enabled = false
        elseif v:IsA("MeshPart") then
            v.Material = "Plastic"
            v.Reflectance = 0
            v.TextureID = 10385902758728957
        end
    end
    for i, e in pairs(l:GetChildren()) do
        if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect") or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") then
            e.Enabled = false
        end
    end
end

-- ============================================================
-- CHECK FUNCTIONS
-- ============================================================
CheckF = function()
    if GetBP("Dragon-Dragon") or GetBP("Gas-Gas") or GetBP("Yeti-Yeti") or GetBP("Kitsune-Kitsune") or GetBP("T-Rex-T-Rex") then
        return true
    end
end

CheckBoat = function()
    for i, v in pairs(workspace.Boats:GetChildren()) do
        if tostring(v.Owner.Value) == tostring(plr.Name) then
            return v
        end
    end
    return false
end

CheckEnemiesBoat = function()
    for _, v in pairs(workspace.Enemies:GetChildren()) do
        if (v.Name == "FishBoat") and v:FindFirstChild("Health").Value > 0 then
            return true
        end
    end
    return false
end

CheckPirateGrandBrigade = function()
    for _, v in pairs(workspace.Enemies:GetChildren()) do
        if (v.Name == "PirateGrandBrigade" or v.Name == "PirateBrigade") and v:FindFirstChild("Health").Value > 0 then
            return true
        end
    end
    return false
end

CheckShark = function()
    for _, v in pairs(workspace.Enemies:GetChildren()) do
        if v.Name == "Shark" and Attack.Alive(v) then return true end
    end
    return false
end

CheckTerrorShark = function()
    for _, v in pairs(workspace.Enemies:GetChildren()) do
        if v.Name == "Terrorshark" and Attack.Alive(v) then return true end
    end
    return false
end

CheckPiranha = function()
    for _, v in pairs(workspace.Enemies:GetChildren()) do
        if v.Name == "Piranha" and Attack.Alive(v) then return true end
    end
    return false
end

CheckFishCrew = function()
    for _, v in pairs(workspace.Enemies:GetChildren()) do
        if (v.Name == "Fish Crew Member" or v.Name == "Haunted Crew Member") and Attack.Alive(v) then
            return true
        end
    end
    return false
end

CheckHauntedCrew = function()
    for _, v in pairs(workspace.Enemies:GetChildren()) do
        if v.Name == "Haunted Crew Member" and Attack.Alive(v) then return true end
    end
    return false
end

CheckSeaBeast = function()
    if workspace.SeaBeasts:FindFirstChild("SeaBeast1") then return true end
    return false
end

CheckLeviathan = function()
    if workspace.SeaBeasts:FindFirstChild("Leviathan") then return true end
    return false
end

-- ============================================================
-- INVENTORY HELPERS
-- ============================================================
UpdStFruit = function()
    for z, x in next, plr.Backpack:GetChildren() do
        local StoreFruit = x:FindFirstChild("EatRemote", true)
        if StoreFruit then
            replicated.Remotes.CommF_:InvokeServer("StoreFruit", StoreFruit.Parent:GetAttribute("OriginalName"), plr.Backpack:FindFirstChild(x.Name))
        end
    end
end

collectFruits = function(Succes)
    if Succes then
        local Character = plr.Character
        for _, v1 in pairs(workspace:GetChildren()) do
            if string.find(v1.Name, "Fruit") then
                v1.Handle.CFrame = Character.HumanoidRootPart.CFrame
            end
        end
    end
end

Getmoon = function()
    if World1 then return Lighting.FantasySky.MoonTextureId
    elseif World2 then return Lighting.FantasySky.MoonTextureId
    elseif World3 then return Lighting.Sky.MoonTextureId end
end

DropFruits = function()
    for _, v3 in next, plr.Backpack:GetChildren() do
        if string.find(v3.Name, "Fruit") then
            EquipWeapon(v3.Name)
            wait(.1)
            if plr.PlayerGui.Main.Dialogue.Visible then
                plr.PlayerGui.Main.Dialogue.Visible = false
            end
            EquipWeapon(v3.Name)
            plr.Character:FindFirstChild(v3.Name).EatRemote:InvokeServer("Drop")
        end
    end
    for a, b2 in pairs(plr.Character:GetChildren()) do
        if string.find(b2.Name, "Fruit") then
            EquipWeapon(b2.Name)
            wait(.1)
            if plr.PlayerGui.Main.Dialogue.Visible then
                plr.PlayerGui.Main.Dialogue.Visible = false
            end
            EquipWeapon(b2.Name)
            plr.Character:FindFirstChild(b2.Name).EatRemote:InvokeServer("Drop")
        end
    end
end

GetBP = function(v)
    return plr.Backpack:FindFirstChild(v) or plr.Character:FindFirstChild(v)
end

GetIn = function(Name)
    for _, v1 in pairs(replicated.Remotes.CommF_:InvokeServer("getInventory")) do
        if type(v1) == "table" then
            if v1.Name == Name or plr.Character:FindFirstChild(Name) or plr.Backpack:FindFirstChild(Name) then
                return true
            end
        end
    end
    return false
end

GetM = function(Name)
    for _, tab in pairs(replicated.Remotes.CommF_:InvokeServer("getInventory")) do
        if type(tab) == "table" and tab.Type == "Material" and tab.Name == Name then
            return tab.Count
        end
    end
    return 0
end

GetWP = function(nametool)
    for _, v4 in pairs(replicated.Remotes.CommF_:InvokeServer("getInventory")) do
        if type(v4) == "table" and v4.Type == "Sword" then
            if v4.Name == nametool or plr.Character:FindFirstChild(nametool) or plr.Backpack:FindFirstChild(nametool) then
                return true
            end
        end
    end
    return false
end

-- ============================================================
-- INFINITY ABILITY
-- ============================================================
getInfinity_Ability = function(Method, Var)
    if not Root then return end
    if Method == "Soru" and Var then
        for _, gc in next, getgc() do
            if plr.Character.Soru then
                if ((typeof(gc) == "function") and (getfenv(gc).script == plr.Character.Soru)) then
                    for _, v in next, getupvalues(gc) do
                        if (typeof(v) == "table") then
                            repeat wait(Sec) v.LastUse = 0 until not Var or (plr.Character.Humanoid.Health <= 0)
                        end
                    end
                end
            end
        end
    elseif Method == "Energy" and Var then
        plr.Character.Energy.Changed:connect(function()
            if Var then plr.Character.Energy.Value = Energy end
        end)
    elseif Method == "Observation" and Var then
        plr.VisionRadius.Value = math.huge
    end
end

-- ============================================================
-- HOP SERVER
-- ============================================================
Hop = function()
    pcall(function()
        for count = math.random(1, math.random(40, 75)), 100 do
            local remote = replicated.__ServerBrowser:InvokeServer(count)
            for _, v in next, remote do
                if tonumber(v['Count']) < 12 then
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, _)
                end
            end
        end
    end)
end

-- ============================================================
-- BLOCK TWEEN PART
-- ============================================================
local block = Instance.new("Part", workspace)
block.Size = Vector3.new(1, 1, 1)
block.Name = "HuyPhamHub_Block"
block.Anchored = true
block.CanCollide = false
block.CanTouch = false
block.Transparency = 1
local blockfind = workspace:FindFirstChild(block.Name)
if blockfind and blockfind ~= block then blockfind:Destroy() end

task.spawn(function()
    while task.wait() do
        getgenv().OnFarm = shouldTween and block and block.Parent == workspace
    end
end)

task.spawn(function()
    local a = game.Players.LocalPlayer
    repeat task.wait() until a.Character and a.Character.PrimaryPart
    block.CFrame = a.Character.PrimaryPart.CFrame
    while task.wait() do
        pcall(function()
            if getgenv().OnFarm then
                if block and block.Parent == workspace then
                    local b = a.Character and a.Character.PrimaryPart
                    if b and (b.Position - block.Position).Magnitude <= 200 then
                        b.CFrame = block.CFrame
                    else
                        block.CFrame = b.CFrame
                    end
                end
                local c = a.Character
                if c then
                    for d, e in pairs(c:GetChildren()) do
                        if e:IsA("BasePart") then e.CanCollide = false end
                    end
                end
            else
                local c = a.Character
                if c then
                    for d, e in pairs(c:GetChildren()) do
                        if e:IsA("BasePart") then e.CanCollide = true end
                    end
                end
            end
        end)
    end
end)

-- ============================================================
-- BIẾN TWEEN & CONFIG
-- ============================================================
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

sea1 = (game.PlaceId == 2753915549 or game.PlaceId == 85211729168715)
sea2 = (game.PlaceId == 4442272183 or game.PlaceId == 79091703265657)
sea3 = (game.PlaceId == 7449423635 or game.PlaceId == 100117331123089)

local Settings = {
    ["Tween Speed"] = 1.5,
    ["Bypass Teleport"] = false,
    ["Up Y"] = false,
    ["Up Y When Low Health"] = false,
    ["Same Y"] = false
}

local newdao = CFrame.new(10641.0918, -1953.92981, 9825.07031, -0.652825892, -9.2805891e-08, -0.757508039, -2.73638356e-08, 1, -9.89323823e-08, 0.757508039, -4.38572947e-08, -0.652825892)
local cframenpc = CFrame.new(-16271.126, 25.5847301, 1371.98755, 0.999396622, -5.78875188e-08, -0.0347310975, 5.52972779e-08, 1, -8.7544322e-08, 0.034731105, 8.28877091e-08, 0.999396741)

-- ============================================================
-- TWEEN HELPERS
-- ============================================================
function Convert_CFrame(x)
    if not x then return end
    if typeof(x) == "Vector3" then return CFrame.new(x)
    elseif typeof(x) == "CFrame" then return x
    elseif typeof(x) == "Model" then return x:GetPivot()
    elseif x.CFrame then return x.CFrame end
    return nil
end

function GetDistance(POS_1, POS_2, NO_Y)
    if POS_1 == nil then return 9e9 end
    local Character = LocalPlayer.Character
    if not Character then return 9e9 end
    local Humanoid = Character:FindFirstChild("Humanoid")
    if not Humanoid or Humanoid.Health <= 0 then return 9e9 end
    if POS_2 == nil then
        POS_2 = Character:FindFirstChild("HumanoidRootPart")
        if not POS_2 then return 9e9 end
    end
    local pos1 = Convert_CFrame(POS_1)
    local pos2 = Convert_CFrame(POS_2)
    if NO_Y then
        return (Vector3.new(pos1.X, 0, pos1.Z) - Vector3.new(pos2.X, 0, pos2.Z)).Magnitude
    else
        return (pos1.Position - pos2.Position).Magnitude
    end
end

function InArea(POS)
    local WorldOrigin = workspace:FindFirstChild("_WorldOrigin")
    if not WorldOrigin then return {Name = ""} end
    local pos = Convert_CFrame(POS)
    for i, v in next, WorldOrigin.Locations:GetChildren() do
        if v:FindFirstChild("Mesh") and (pos.Position - v.Position).Magnitude <= v.Mesh.Scale.X then
            return v
        end
    end
    return {Name = ""}
end

function GetSpawnPoint(x)
    local Spawns = workspace:FindFirstChild("_WorldOrigin") and workspace._WorldOrigin:FindFirstChild("PlayerSpawns") and workspace._WorldOrigin.PlayerSpawns:FindFirstChild("Pirates")
    if not Spawns then return end
    for i, v in next, Spawns:GetChildren() do
        if v:FindFirstChild("Part") and (v.Part.Position - x.Position).Magnitude <= 2500 then
            return v
        end
    end
end

function CheckLegendaryItems()
    local function CheckItem(ITEM_NAME)
        for i, v in next, LocalPlayer.Backpack:GetChildren() do
            if v:IsA('Tool') and (v.Name == ITEM_NAME or string.find(v.Name, ITEM_NAME)) then return v end
        end
        for i, v in next, LocalPlayer.Character:GetChildren() do
            if v:IsA('Tool') and (v.Name == ITEM_NAME or string.find(v.Name, ITEM_NAME)) then return v end
        end
    end
    if CheckItem("God's Chalice") or CheckItem("Fist of Darkness") or CheckItem("Sweet Chalice") or CheckItem("Hallow Essence") or CheckItem("Flower1") then
        return true
    end
    return false
end

function WaitForHumanoid()
    local Character = LocalPlayer.Character
    if not Character then return nil end
    local Humanoid = Character:FindFirstChild("Humanoid")
    if Humanoid then return Humanoid end
    local timeout = tick() + 5
    while tick() < timeout do
        Humanoid = Character:FindFirstChild("Humanoid")
        if Humanoid then return Humanoid end
        task.wait(0.1)
    end
    return nil
end

function checkinventory(v)
    if v then
        for i, vl in pairs(ReplicatedStorage.Remotes.CommF_:InvokeServer("getInventory")) do
            if vl.Name == v then return true end
        end
    end
    return false
end

function getdis(a, b)
    b = b or LocalPlayer.Character.HumanoidRootPart.CFrame
    local _a = CFrame.new(a.X, b.Y, a.Z)
    local _b = CFrame.new(b.X, b.Y, b.Z)
    return (_a.Position - _b.Position).Magnitude
end

function CanBypassTeleport(x)
    local AreaName = InArea(x).Name
    if AreaName == "" then return false end
    if not Settings["Bypass Teleport"] or AreaName:find("Dimension") or AreaName:find("Submerged") or AreaName == "Sealed Cavern" or AreaName:lower():find("under") or CheckLegendaryItems() then
        return false
    end
    if LocalPlayer.Data and LocalPlayer.Data.LastSpawnPoint and LocalPlayer.Data.LastSpawnPoint.Value == "SubmergedIsland" then
        return false
    end
    if GetDistance(x.Position) <= 3500 then return false end
    return true
end

function GetBypassCFrame(x)
    local Max = math.huge
    local Pos
    local Spawns = workspace._WorldOrigin.PlayerSpawns.Pirates:GetChildren()
    local HRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not HRP then return nil end
    for i, v in next, Spawns do
        if v:FindFirstChild("Part") then
            if (x.Position - HRP.Position).Magnitude >= 3000 and GetSpawnPoint(v.Part) ~= GetSpawnPoint(HRP) and (v.Part.Position - HRP.Position).Magnitude <= 10000 and (v.Part.Position - x.Position).Magnitude <= Max then
                Max = (v.Part.Position - x.Position).Magnitude
                Pos = v
            end
        end
    end
    return Pos
end

function BypassTP(Target)
    local Character = LocalPlayer.Character
    if not Character then return end
    local Humanoid = WaitForHumanoid()
    if not Humanoid or Humanoid.Health <= 0 then return end
    if CanBypassTeleport(Target) and GetBypassCFrame(Target) then
        local TargetTP = GetBypassCFrame(Target)
        if TargetTP and TargetTP:FindFirstChild("Part") then
            Character.LastSpawnPoint.Disabled = true
            ReplicatedStorage.Remotes.CommF_:InvokeServer("SetLastSpawnPoint", TargetTP.Name)
            ReplicatedStorage.Remotes.CommF_:InvokeServer("SetSpawnPoint")
            Character:PivotTo(TargetTP.Part.CFrame)
            Humanoid:ChangeState(15)
            repeat task.wait() until LocalPlayer.Character and WaitForHumanoid() and WaitForHumanoid().Health > 0
        end
    end
end

function totopofgreattree()
    if getdis(CFrame.new(28310.0234, 14895.1123, 109.456741)) > 1500 then
        ReplicatedStorage.Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(28310.0234, 14895.1123, 109.456741))
        wait(0.3)
    end
    local targetCF = CFrame.new(28607.5352, 14896.5449, 106.011726)
    _tp(targetCF)
    repeat wait() until getdis(targetCF) <= 5
    wait(0.5)
    for i = 1, 4 do
        ReplicatedStorage.Remotes.CommF_:InvokeServer("RaceV4Progress", "TeleportBack")
    end
end

function requestentrance(pos)
    local tb = {}
    local targetPos = pos
    if typeof(pos) == "CFrame" then targetPos = pos.Position end
    if sea1 then
        tb = {
            ["Sky3"] = Vector3.new(-7894, 5547, -380),
            ["Sky3Exit"] = Vector3.new(-4607, 874, -1667),
            ["UnderWater"] = Vector3.new(61163, 11, 1819),
            ["Underwater City"] = Vector3.new(61165.19140625, 0.18704631924629211, 1897.379150390625),
            ["Pirate Village"] = Vector3.new(-1242.4625244140625, 4.787059783935547, 3901.282958984375),
            ["UnderwaterExit"] = Vector3.new(4050, -1, -1814)
        }
    elseif sea2 then
        tb = {
            ["Swan Mansion"] = Vector3.new(-390, 332, 673),
            ["Swan Room"] = Vector3.new(2285, 15, 905),
            ["Cursed Ship"] = Vector3.new(923, 126, 32852),
            ["Zombie Island"] = Vector3.new(-6509, 83, -133)
        }
    else
        tb = {
            ["Hydra Island"] = Vector3.new(5657.88623046875, 1013.0790405273438, -335.4996337890625),
            ["Mansion"] = Vector3.new(-12462, 375, -7552),
            ["Castle"] = Vector3.new(-5036, 315, -3179),
            ["Temple of Time"] = Vector3.new(28286, 14897, 103),
            ["Greate Tree"] = Vector3.new(3024.1709, 2280.69434, -7325.12793)
        }
    end
    if not checkinventory("Valkyrie Helm") then return end
    local x, y = nil, math.huge
    for i, v in pairs(tb) do
        local distance = (typeof(v) == "Vector3" and (v - targetPos).Magnitude) or (v.Position - targetPos).Magnitude
        if distance < y then y = distance; x = v end
    end
    if x and y and y < getdis(pos) then
        pcall(function() if _G.TweenCache then _G.TweenCache:Cancel() end end)
        if typeof(x) == "Vector3" and x.X == 3024.1709 and x.Y == 2280.69434 and x.Z == -7325.12793 and ReplicatedStorage.Remotes.CommF_:InvokeServer("RaceV4Progress", "Check") >= 2 then
            totopofgreattree()
            wait(1)
        elseif y < getdis(pos) then
            local requestPos = typeof(x) == "Vector3" and x or x.Position
            ReplicatedStorage.Remotes.CommF_:InvokeServer("requestEntrance", requestPos)
            wait(1)
        end
    end
end

_tp = function(target)
    local gg
    if typeof(target) == "Vector3" then gg = CFrame.new(target)
    elseif typeof(target) == "CFrame" then gg = target
    else gg = target and target.CFrame end
    if not gg then return end
    local character = plr.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    local rootPart = character.HumanoidRootPart
    pcall(function()
        if CanBypassTeleport(gg) then
            BypassTP(gg)
            task.wait(0.5)
        end
    end)
    pcall(function() requestentrance(target) end)
    if sea3 and getdis(gg.Position, newdao.Position) < 2000 then
        local hrp = plr.Character.HumanoidRootPart
        if math.abs(newdao.Position.Y - hrp.CFrame.Y) > 1000 then
            repeat
                task.wait()
                old_tp(cframenpc)
                if getdis(cframenpc) < 10 then
                    local net = ReplicatedStorage.Modules.Net
                    net["RF/SubmarineWorkerSpeak"]:InvokeServer("AskKilledTikiBoss")
                    task.wait(0.5)
                    net["RF/SubmarineWorkerSpeak"]:InvokeServer("TravelToSubmergedIsland")
                end
            until getdis(gg.Position) < 2000
            task.wait(0.6)
            pcall(function()
                if hrp:FindFirstChild("BodyClip") then hrp.BodyClip:Destroy() end
            end)
        end
    end
    local distance = (gg.Position - rootPart.Position).Magnitude
    local tweenInfo = TweenInfo.new(distance / math.max(50, (Settings["Tween Speed"] or 1.5) * 100), Enum.EasingStyle.Linear)
    local tween = game:GetService("TweenService"):Create(block, tweenInfo, {CFrame = gg})
    if plr.Character.Humanoid.Sit then
        block.CFrame = CFrame.new(block.Position.X, gg.Y, block.Position.Z)
    end
    tween:Play()
    task.spawn(function()
        while tween.PlaybackState == Enum.PlaybackState.Playing do
            if not shouldTween then tween:Cancel(); break end
            task.wait(0.1)
        end
    end)
    return tween
end

old_tp = function(p)
    local char = plr.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = p
    end
end

TeleportToTarget = function(targetCFrame)
    _tp(targetCFrame)
end

notween = function(p)
    plr.Character.HumanoidRootPart.CFrame = p
end

-- ============================================================
-- SHOULD TWEEN MONITOR
-- ============================================================
spawn(function()
    while task.wait() do
        pcall(function()
            if _G.SailBoat_Hydra or _G.WardenBoss or _G.AutoFactory or _G.HighestMirage or _G.HCM or _G.PGB or _G.Leviathan1 or _G.UPGDrago or _G.Complete_Trials or _G.TpDrago_Prehis or _G.BuyDrago or _G.AutoFireFlowers or _G.DT_Uzoth or _G.AutoBerry or _G.Prefully or _G.Prehis_Find or _G.Prehis_Skills or _G.Prehis_DB or _G.Prehis_DE or _G.FarmBlazeEM or _G.Dojoo or _G.CollectPresent or _G.AutoLawKak or _G.TpLab or _G.AutoPhoenixF or _G.AutoFarmChest or _G.AutoHytHallow or _G.LongsWord or _G.BlackSpikey or _G.AutoHolyTorch or _G.TrainDrago or _G.AutoSaber or _G.FarmMastery_Dev or _G.CitizenQuest or _G.AutoEctoplasm or _G.KeysRen or _G.Auto_Rainbow_Haki or _G.obsFarm or _G.AutoBigmom or _G.Doughv2 or _G.AuraBoss or _G.Raiding or _G.Auto_Cavender or _G.TpPly or _G.Bartilo_Quest or _G.Level or _G.FarmEliteHunt or _G.AutoZou or _G.AutoFarm_Bone or getgenv().AutoMaterial or _G.CraftVM or _G.FrozenTP or _G.TPDoor or _G.AcientOne or _G.AutoFarmNear or _G.AutoRaidCastle or _G.DarkBladev3 or _G.AutoFarmRaid or _G.Auto_Cake_Prince or _G.Addealer or _G.TPNpc or _G.TwinHook or _G.FindMirage or _G.FarmChestM or _G.Shark or _G.TerrorShark or _G.Piranha or _G.MobCrew or _G.SeaBeast1 or _G.FishBoat or _G.AutoPole or _G.AutoPoleV2 or _G.Auto_SuperHuman or _G.AutoDeathStep or _G.Auto_SharkMan_Karate or _G.Auto_Electric_Claw or _G.AutoDragonTalon or _G.Auto_Def_DarkCoat or _G.Auto_God_Human or _G.Auto_Tushita or _G.AutoMatSoul or _G.AutoKenVTWO or _G.AutoSerpentBow or _G.AutoFMon or _G.Auto_Soul_Guitar or _G.TPGEAR or _G.AutoSaw or _G.AutoTridentW2 or _G.AutoEvoRace or _G.AutoGetQuestBounty or _G.MarinesCoat or _G.TravelDres or _G.Defeating or _G.DummyMan or _G.Auto_Yama or _G.Auto_SwanGG or _G.SwanCoat or _G.AutoEcBoss or _G.Auto_Mink or _G.Auto_Human or _G.Auto_Skypiea or _G.Auto_Fish or _G.CDK_TS or _G.CDK_YM or _G.CDK or _G.AutoFarmGodChalice or _G.AutoFistDarkness or _G.AutoMiror or _G.Teleport or _G.AutoKilo or _G.AutoGetUsoap or _G.Praying or _G.TryLucky or _G.AutoColShad or _G.AutoUnHaki or _G.Auto_DonAcces or _G.AutoRipIngay or _G.DragoV3 or _G.DragoV1 or _G.SailBoats or _G.FarmGodChalice or _G.IceBossRen or _G.Lvthan or _G.beasthunter or _G.DangerLV or _G.Relic123 or _G.tweenKitsune or _G.Collect_Ember or _G.AutofindKitIs or _G.snaguine or _G.TwFruits or _G.tweenKitShrine or _G.Tp_LgS or _G.Tp_MasterA or _G.tweenShrine or _G.FarmMastery_G or _G.FarmMastery_S or _G.FarmBoss or _G.AutoFarmAllBoss or _G.AutoFishSlap or _G.FarmTyrant or _G.FarmPhaBinh or _G.AutoSpawnCP or _G.AutoBerryH or _G.AutoChestBP or _G.FarmEliteHop or _G.AutoHop_Dough or _G.AutoDoughKing or _G.AutoAttackDoughKing or _G.AutoChipFruit or _G.AutoChipBeli or _G.StartEvent or _G.AutoMysticIsland or _G.AutoPlayerHunter or _G.SafeMode or _G.AutoKillMob or _G.AutoStartPrehistoric or _G.AutoAttackRipIndra or _G.AutoFarmIsland or _G.AutoFarmDungeon or _G.AutoFarmCandy or _G.TPFloor1 or _G.TPFloor2 or _G.TPFloor3 or _G.TPFloor4 then
                shouldTween = true
                if not plr.Character.HumanoidRootPart:FindFirstChild("BodyClip") then
                    local Noclip = Instance.new("BodyVelocity")
                    Noclip.Name = "BodyClip"
                    Noclip.Parent = plr.Character.HumanoidRootPart
                    Noclip.MaxForce = Vector3.new(100000, 100000, 100000)
                    Noclip.Velocity = Vector3.new(0, 0, 0)
                end
                if not plr.Character:FindFirstChild("highlight") then
                    local Test = Instance.new("Highlight")
                    Test.Name = "highlight"
                    Test.Enabled = true
                    Test.FillColor = Color3.fromRGB(255, 255, 255)
                    Test.OutlineColor = Color3.fromRGB(255, 255, 255)
                    Test.FillTransparency = 0.5
                    Test.OutlineTransparency = 0.2
                    Test.Parent = plr.Character
                end
                for _, no in pairs(plr.Character:GetDescendants()) do
                    if no:IsA("BasePart") then no.CanCollide = false end
                end
            else
                shouldTween = false
                if plr.Character.HumanoidRootPart:FindFirstChild("BodyClip") then
                    plr.Character.HumanoidRootPart:FindFirstChild("BodyClip"):Destroy()
                end
                if plr.Character:FindFirstChild('highlight') then
                    plr.Character:FindFirstChild('highlight'):Destroy()
                end
            end
        end)
    end
end)

-- ============================================================
-- END PHẦN 1
-- ============================================================
-- ============================================================
-- QUEST B (logic boss quest 3 world)
-- ============================================================
QuestB = function()
    if World1 then
        if _G.FindBoss == "The Gorilla King" then
            bMon = "The Gorilla King"; Qname = "JungleQuest"; Qdata = 3
            PosQBoss = CFrame.new(-1601.6553955078, 36.85213470459, 153.38809204102)
            PosB = CFrame.new(-1088.75977, 8.13463783, -488.559906, -0.707134247, 0, 0.707079291, 0, 1, 0, -0.707079291, 0, -0.707134247)
        elseif _G.FindBoss == "Bobby" then
            bMon = "Bobby"; Qname = "BuggyQuest1"; Qdata = 3
            PosQBoss = CFrame.new(-1140.1761474609, 4.752049446106, 3827.4057617188)
            PosB = CFrame.new(-1087.3760986328, 46.949409484863, 4040.1462402344)
        elseif _G.FindBoss == "The Saw" then
            bMon = "The Saw"
            PosB = CFrame.new(-784.89715576172, 72.427383422852, 1603.5822753906)
        elseif _G.FindBoss == "Yeti" then
            bMon = "Yeti"; Qname = "SnowQuest"; Qdata = 3
            PosQBoss = CFrame.new(1386.8073730469, 87.272789001465, -1298.3576660156)
            PosB = CFrame.new(1218.7956542969, 138.01184082031, -1488.0262451172)
        elseif _G.FindBoss == "Mob Leader" then
            bMon = "Mob Leader"
            PosB = CFrame.new(-2844.7307128906, 7.4180502891541, 5356.6723632813)
        elseif _G.FindBoss == "Vice Admiral" then
            bMon = "Vice Admiral"; Qname = "MarineQuest2"; Qdata = 2
            PosQBoss = CFrame.new(-5036.2465820313, 28.677835464478, 4324.56640625)
            PosB = CFrame.new(-5006.5454101563, 88.032081604004, 4353.162109375)
        elseif _G.FindBoss == "Saber Expert" then
            bMon = "Saber Expert"
            PosB = CFrame.new(-1458.89502, 29.8870335, -50.633564)
        elseif _G.FindBoss == "Warden" then
            bMon = "Warden"; Qname = "ImpelQuest"; Qdata = 1
            PosB = CFrame.new(5278.04932, 2.15167475, 944.101929, 0.220546961, -4.49946401e-06, 0.975376427, -1.95412576e-05, 1, 9.03162072e-06, -0.975376427, -2.10519756e-05, 0.220546961)
            PosQBoss = CFrame.new(5191.86133, 2.84020686, 686.438721, -0.731384635, 0, 0.681965172, 0, 1, 0, -0.681965172, 0, -0.731384635)
        elseif _G.FindBoss == "Chief Warden" then
            bMon = "Chief Warden"; Qname = "ImpelQuest"; Qdata = 2
            PosB = CFrame.new(5206.92578, 0.997753382, 814.976746, 0.342041343, -0.00062915677, 0.939684749, 0.00191645394, 0.999998152, -2.80422337e-05, -0.939682961, 0.00181045406, 0.342041939)
            PosQBoss = CFrame.new(5191.86133, 2.84020686, 686.438721, -0.731384635, 0, 0.681965172, 0, 1, 0, -0.681965172, 0, -0.731384635)
        elseif _G.FindBoss == "Swan" then
            bMon = "Swan"; Qname = "ImpelQuest"; Qdata = 3
            PosB = CFrame.new(5325.09619, 7.03906584, 719.570679, -0.309060812, 0, 0.951042235, 0, 1, 0, -0.951042235, 0, -0.309060812)
            PosQBoss = CFrame.new(5191.86133, 2.84020686, 686.438721, -0.731384635, 0, 0.681965172, 0, 1, 0, -0.681965172, 0, -0.731384635)
        elseif _G.FindBoss == "Magma Admiral" then
            bMon = "Magma Admiral"; Qname = "MagmaQuest"; Qdata = 3
            PosQBoss = CFrame.new(-5314.6220703125, 12.262420654297, 8517.279296875)
            PosB = CFrame.new(-5765.8969726563, 82.92064666748, 8718.3046875)
        elseif _G.FindBoss == "Fishman Lord" then
            bMon = "Fishman Lord"; Qname = "FishmanQuest"; Qdata = 3
            PosQBoss = CFrame.new(61122.65234375, 18.497442245483, 1569.3997802734)
            PosB = CFrame.new(61260.15234375, 30.950881958008, 1193.4329833984)
        elseif _G.FindBoss == "Wysper" then
            bMon = "Wysper"; Qname = "SkyExp1Quest"; Qdata = 3
            PosQBoss = CFrame.new(-7861.947265625, 5545.517578125, -379.85974121094)
            PosB = CFrame.new(-7866.1333007813, 5576.4311523438, -546.74816894531)
        elseif _G.FindBoss == "Thunder God" then
            bMon = "Thunder God"; Qname = "SkyExp2Quest"; Qdata = 3
            PosQBoss = CFrame.new(-7903.3828125, 5635.9897460938, -1410.923828125)
            PosB = CFrame.new(-7994.984375, 5761.025390625, -2088.6479492188)
        elseif _G.FindBoss == "Cyborg" then
            bMon = "Cyborg"; Qname = "FountainQuest"; Qdata = 3
            PosQBoss = CFrame.new(5258.2788085938, 38.526931762695, 4050.044921875)
            PosB = CFrame.new(6094.0249023438, 73.770050048828, 3825.7348632813)
        elseif _G.FindBoss == "Ice Admiral" then
            bMon = "Ice Admiral"; Qdata = nil
            PosQBoss = CFrame.new(1266.08948, 26.1757946, -1399.57678, -0.573599219, 0, -0.81913656, 0, 1, 0, 0.81913656, 0, -0.573599219)
            PosB = CFrame.new(1266.08948, 26.1757946, -1399.57678, -0.573599219, 0, -0.81913656, 0, 1, 0, 0.81913656, 0, -0.573599219)
        elseif _G.FindBoss == "Greybeard" then
            bMon = "Greybeard"; Qdata = nil
            PosQBoss = CFrame.new(-5081.3452148438, 85.221641540527, 4257.3588867188)
            PosB = CFrame.new(-5081.3452148438, 85.221641540527, 4257.3588867188)
        end
    end
    if World2 then
        if _G.FindBoss == "Diamond" then
            bMon = "Diamond"; Qname = "Area1Quest"; Qdata = 3
            PosQBoss = CFrame.new(-427.5666809082, 73.313781738281, 1835.4208984375)
            PosB = CFrame.new(-1576.7166748047, 198.59265136719, 13.724286079407)
        elseif _G.FindBoss == "Jeremy" then
            bMon = "Jeremy"; Qname = "Area2Quest"; Qdata = 3
            PosQBoss = CFrame.new(636.79943847656, 73.413787841797, 918.00415039063)
            PosB = CFrame.new(2006.9261474609, 448.95666503906, 853.98284912109)
        elseif _G.FindBoss == "Orbitus" then
            bMon = "Orbitus"; Qname = "MarineQuest3"; Qdata = 3
            PosQBoss = CFrame.new(-2441.986328125, 73.359344482422, -3217.5324707031)
            PosB = CFrame.new(-2172.7399902344, 103.32216644287, -4015.025390625)
        elseif _G.FindBoss == "Don Swan" then
            bMon = "Don Swan"
            PosB = CFrame.new(2286.2004394531, 15.177839279175, 863.8388671875)
        elseif _G.FindBoss == "Smoke Admiral" then
            bMon = "Smoke Admiral"; Qname = "IceSideQuest"; Qdata = 3
            PosQBoss = CFrame.new(-5429.0473632813, 15.977565765381, -5297.9614257813)
            PosB = CFrame.new(-5275.1987304688, 20.757257461548, -5260.6669921875)
        elseif _G.FindBoss == "Awakened Ice Admiral" then
            bMon = "Awakened Ice Admiral"; Qname = "FrostQuest"; Qdata = 3
            PosQBoss = CFrame.new(5668.9780273438, 28.519989013672, -6483.3520507813)
            PosB = CFrame.new(6403.5439453125, 340.29766845703, -6894.5595703125)
        elseif _G.FindBoss == "Tide Keeper" then
            bMon = "Tide Keeper"; Qname = "ForgottenQuest"; Qdata = 3
            PosQBoss = CFrame.new(-3053.9814453125, 237.18954467773, -10145.0390625)
            PosB = CFrame.new(-3795.6423339844, 105.88877105713, -11421.307617188)
        elseif _G.FindBoss == "Darkbeard" then
            bMon = "Darkbeard"; Qdata = nil
            PosQBoss = CFrame.new(3677.08203125, 62.751937866211, -3144.8332519531)
            PosB = CFrame.new(3677.08203125, 62.751937866211, -3144.8332519531)
        elseif _G.FindBoss == "Cursed Captain" then
            bMon = "Cursed Captain"; Qdata = nil
            PosQBoss = CFrame.new(916.928589, 181.092773, 33422)
            PosB = CFrame.new(916.928589, 181.092773, 33422)
        elseif _G.FindBoss == "Order" then
            bMon = "Order"; Qdata = nil
            PosQBoss = CFrame.new(-6217.2021484375, 28.047645568848, -5053.1357421875)
            PosB = CFrame.new(-6217.2021484375, 28.047645568848, -5053.1357421875)
        end
    end
    if World3 then
        if _G.FindBoss == "Stone" then
            bMon = "Stone"; Qname = "PiratePortQuest"; Qdata = 3
            PosQBoss = CFrame.new(-289.76705932617, 43.819011688232, 5579.9384765625)
            PosB = CFrame.new(-1027.6512451172, 92.404174804688, 6578.8530273438)
        elseif _G.FindBoss == "Hydra Leader" then
            bMon = "Hydra Leader"; Qname = "VenomCrewQuest"; Qdata = 3
            PosQBoss = CFrame.new(5211.021484375, 1004.35778859375, 758.1847534179688)
            PosB = CFrame.new(5821.89794921875, 1019.0950927734375, -73.71923065185547)
        elseif _G.FindBoss == "Kilo Admiral" then
            bMon = "Kilo Admiral"; Qname = "MarineTreeIsland"; Qdata = 3
            PosQBoss = CFrame.new(2179.3010253906, 28.731239318848, -6739.9741210938)
            PosB = CFrame.new(2764.2233886719, 432.46154785156, -7144.4580078125)
        elseif _G.FindBoss == "Captain Elephant" then
            bMon = "Captain Elephant"; Qname = "DeepForestIsland"; Qdata = 3
            PosQBoss = CFrame.new(-13232.682617188, 332.40396118164, -7626.01171875)
            PosB = CFrame.new(-13376.7578125, 433.28689575195, -8071.392578125)
        elseif _G.FindBoss == "Beautiful Pirate" then
            bMon = "Beautiful Pirate"; Qname = "DeepForestIsland2"; Qdata = 3
            PosQBoss = CFrame.new(-12682.096679688, 390.88653564453, -9902.1240234375)
            PosB = CFrame.new(5283.609375, 22.56223487854, -110.78285217285)
        elseif _G.FindBoss == "Cake Queen" then
            bMon = "Cake Queen"; Qname = "IceCreamIslandQuest"; Qdata = 3
            PosQBoss = CFrame.new(-819.376709, 64.9259796, -10967.2832, -0.766061664, 0, 0.642767608, 0, 1, 0, -0.642767608, 0, -0.766061664)
            PosB = CFrame.new(-678.648804, 381.353943, -11114.2012, -0.908641815, 0.00149294338, 0.41757378, 0.00837114919, 0.999857843, 0.0146408929, -0.417492568, 0.0167988986, -0.90852499)
        elseif _G.FindBoss == "Longma" then
            bMon = "Longma"; Qdata = nil
            PosQBoss = CFrame.new(-10238.875976563, 389.7912902832, -9549.7939453125)
            PosB = CFrame.new(-10238.875976563, 389.7912902832, -9549.7939453125)
        elseif _G.FindBoss == "Soul Reaper" then
            bMon = "Soul Reaper"; Qdata = nil
            PosQBoss = CFrame.new(-9524.7890625, 315.80429077148, 6655.7192382813)
            PosB = CFrame.new(-9524.7890625, 315.80429077148, 6655.7192382813)
        end
    end
end

QuestBeta = function()
    local Neta = QuestB()
    return {
        [0] = _G.FindBoss,
        [1] = bMon,
        [2] = Qdata,
        [3] = Qname,
        [4] = PosB,
        [5] = PosQBoss,
    }
end

-- ============================================================
-- QUEST HELPERS
-- ============================================================
local Quests = require(game:GetService("ReplicatedStorage"):WaitForChild("Quests"))
local GuideModule = require(game:GetService("ReplicatedStorage"):WaitForChild("GuideModule"))
local blacklistquest = { "MarineQuest", "BartiloQuest", "CitizenQuest", "Trainees" }

CheckSea = function(b)
    if (game.PlaceId == 2753915549 or game.PlaceId == 85211729168715) and b == 1 then return true
    elseif (game.PlaceId == 4442272183 or game.PlaceId == 79091703265657) and b == 2 then return true
    elseif (game.PlaceId == 7449423635 or game.PlaceId == 100117331123089) and b == 3 then return true end
    return false
end

GetQuestPointFromNPC = function(npcName)
    for _, npc in pairs(workspace.NPCs:GetChildren()) do
        if npc.Name == npcName and npc:FindFirstChild("HumanoidRootPart") then
            return npc.HumanoidRootPart.CFrame
        end
    end
    for _, npc in pairs(replicated.NPCs:GetChildren()) do
        if npc.Name == npcName and npc:FindFirstChild("HumanoidRootPart") then
            return npc.HumanoidRootPart.CFrame
        end
    end
    return nil
end

GetQuests = function()
    local lvl = plr.Data.Level.Value
    local LevelReq = 0
    local mmb = {}
    if lvl >= 700 and CheckSea(1) then
        mmb["Mob"] = "Galley Captain"; mmb["NameQuest"] = "FountainQuest"; mmb["ID"] = 2; mmb["LevelReq"] = 700
    elseif lvl >= 1500 and CheckSea(2) then
        mmb["Mob"] = "Water Fighter"; mmb["NameQuest"] = "ForgottenQuest"; mmb["ID"] = 2; mmb["LevelReq"] = 1450
    else
        for r, v in pairs(Quests) do
            for id, v1 in pairs(v) do
                local LvReq = v1.LevelReq
                for nguoi, tinh in pairs(v1.Task) do
                    if lvl >= LvReq and LevelReq <= LvReq and v1.Task[nguoi] > 1 and not table.find(blacklistquest, r) then
                        LevelReq = LvReq
                        mmb["Mob"] = nguoi; mmb["NameQuest"] = r; mmb["ID"] = id; mmb["LevelReq"] = LvReq
                    end
                end
            end
        end
    end
    return mmb
end

GetQuestPoint = function()
    if GuideModule and GuideModule.Data and GuideModule.Data.LastClosestNPC then
        return GetQuestPointFromNPC(GuideModule.Data.LastClosestNPC)
    end
    return nil
end

MaterialMon = function()
    local a = game.Players.LocalPlayer
    local b = a.Character and a.Character:FindFirstChild("HumanoidRootPart")
    if not b then return end
    shouldRequestEntrance = function(c, d)
        local e = (b.Position - c).Magnitude
        if e >= d then replicated.Remotes.CommF_:InvokeServer("requestEntrance", c) end
    end
    if World1 then
        if SelectMaterial == "Angel Wings" then
            MMon = {"Shanda", "Royal Squad", "Royal Soldier", "Wysper", "Thunder God"}
            MPos = CFrame.new(-4698, 845, -1912); SP = "Default"
            shouldRequestEntrance(Vector3.new(-4607.82275, 872.54248, -1667.55688), 10000)
        elseif SelectMaterial == "Leather + Scrap Metal" then
            MMon = {"Brute", "Pirate"}; MPos = CFrame.new(-1145, 15, 4350); SP = "Default"
        elseif SelectMaterial == "Magma Ore" then
            MMon = {"Military Soldier", "Military Spy", "Magma Admiral"}; MPos = CFrame.new(-5815, 84, 8820); SP = "Default"
        elseif SelectMaterial == "Fish Tail" then
            MMon = {"Fishman Warrior", "Fishman Commando", "Fishman Lord"}; MPos = CFrame.new(61123, 19, 1569); SP = "Default"
            shouldRequestEntrance(Vector3.new(61163.8515625, 5.342342376708984, 1819.7841796875), 17000)
        end
    elseif World2 then
        if SelectMaterial == "Leather + Scrap Metal" then
            MMon = {"Marine Captain"}; MPos = CFrame.new(-2010.5059814453125, 73.00115966796875, -3326.620849609375); SP = "Default"
        elseif SelectMaterial == "Magma Ore" then
            MMon = {"Magma Ninja", "Lava Pirate"}; MPos = CFrame.new(-5428, 78, -5959); SP = "Default"
        elseif SelectMaterial == "Ectoplasm" then
            MMon = {"Ship Deckhand", "Ship Engineer", "Ship Steward", "Ship Officer"}; MPos = CFrame.new(911.35827636719, 125.95812988281, 33159.5390625); SP = "Default"
            shouldRequestEntrance(Vector3.new(61163.8515625, 5.342342376708984, 1819.7841796875), 18000)
        elseif SelectMaterial == "Mystic Droplet" then
            MMon = {"Water Fighter"}; MPos = CFrame.new(-3385, 239, -10542); SP = "Default"
        elseif SelectMaterial == "Radioactive Material" then
            MMon = {"Factory Staff"}; MPos = CFrame.new(295, 73, -56); SP = "Default"
        elseif SelectMaterial == "Vampire Fang" then
            MMon = {"Vampire"}; MPos = CFrame.new(-6033, 7, -1317); SP = "Default"
        end
    elseif World3 then
        if SelectMaterial == "Scrap Metal" then
            MMon = {"Jungle Pirate", "Forest Pirate"}; MPos = CFrame.new(-11975.78515625, 331.7734069824219, -10620.0302734375); SP = "Default"
        elseif SelectMaterial == "Fish Tail" then
            MMon = {"Fishman Raider", "Fishman Captain"}; MPos = CFrame.new(-10993, 332, -8940); SP = "Default"
        elseif SelectMaterial == "Conjured Cocoa" then
            MMon = {"Chocolate Bar Battler", "Cocoa Warrior"}; MPos = CFrame.new(620.6344604492188, 78.93644714355469, -12581.369140625); SP = "Default"
        elseif SelectMaterial == "Dragon Scale" then
            MMon = {"Dragon Crew Archer", "Dragon Crew Warrior"}; MPos = CFrame.new(6594, 383, 139); SP = "Default"
        elseif SelectMaterial == "Gunpowder" then
            MMon = {"Pistol Billionaire"}; MPos = CFrame.new(-84.8556900024414, 85.62061309814453, 6132.0087890625); SP = "Default"
        elseif SelectMaterial == "Mini Tusk" then
            MMon = {"Mythological Pirate"}; MPos = CFrame.new(-13545, 470, -6917); SP = "Default"
        elseif SelectMaterial == "Demonic Wisp" then
            MMon = {"Demonic Soul"}; MPos = CFrame.new(-9495.6806640625, 453.58624267578125, 5977.3486328125); SP = "Default"
        end
    end
end

QuestNeta = function()
    local questData = GetQuests()
    return {
        [1] = questData.Mob,
        [2] = questData.ID,
        [3] = questData.NameQuest,
        [4] = questData.LevelReq,
        [5] = questData.Mob,
        [6] = GetQuestPoint()
    }
end

-- ============================================================
-- HUY PHAM HUB UI - OBSIDIAN BLACK & WHITE
-- ============================================================
local ObsidianRepo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(ObsidianRepo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(ObsidianRepo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(ObsidianRepo .. "addons/SaveManager.lua"))()

local Options = Library.Options
local Toggles = Library.Toggles

Library.ForceCheckbox = false
Library.ShowToggleFrameInKeybinds = true
Library.ShowCustomCursor = true

Library.Scheme = {
    BackgroundColor = Color3.fromRGB(5, 5, 5),
    MainColor = Color3.fromRGB(12, 12, 12),
    AccentColor = Color3.fromRGB(255, 255, 255),
    OutlineColor = Color3.fromRGB(70, 70, 70),
    FontColor = Color3.fromRGB(255, 255, 255),
    Font = Font.fromEnum(Enum.Font.Gotham),
    RedColor = Color3.fromRGB(255, 255, 255),
    DestructiveColor = Color3.fromRGB(255, 255, 255),
    DarkColor = Color3.fromRGB(0, 0, 0),
    WhiteColor = Color3.fromRGB(255, 255, 255)
}

local RealWindow = Library:CreateWindow({
    Title = "Huy Pham Hub",
    Footer = "by real_@HuyPhamHub",
    Icon = 94678517792779,
    NotifySide = "Right",
    ShowCustomCursor = true,
    Center = true,
    AutoShow = true,
    Resizable = true,
    MobileButtonsSide = "Left"
})

Library.ToggleKeybind = Options.MenuKeybind

pcall(function()
    ThemeManager:SetLibrary(Library)
    SaveManager:SetLibrary(Library)
    SaveManager:IgnoreThemeSettings()
    SaveManager:SetIgnoreIndexes({"MenuKeybind"})
    ThemeManager:SetFolder("HuyPhamHub")
    SaveManager:SetFolder("HuyPhamHub/configs")
end)

-- ============================================================
-- TAB SHIM (giữ API cũ)
-- ============================================================
local Window = {}

local function MakeTabShim(page)
    local tab = {}
    local currentSection = nil
    local sectionCount = 0

    local function ensureSection()
        if not currentSection then
            sectionCount += 1
            currentSection = page:AddLeftGroupbox("Main " .. sectionCount)
        end
        return currentSection
    end

    function tab:AddSection(name)
        sectionCount += 1
        if sectionCount % 2 == 1 then
            currentSection = page:AddLeftGroupbox(tostring(name or "Section"))
        else
            currentSection = page:AddRightGroupbox(tostring(name or "Section"))
        end
        return currentSection
    end

    function tab:AddToggle(cfg)
        cfg = cfg or {}
        return ensureSection():AddToggle(
            cfg.Flag or cfg.Name or cfg.Title or ("Toggle_" .. tostring(os.clock())),
            {
                Text = cfg.Name or cfg.Title or "Toggle",
                Default = cfg.Default == true,
                Tooltip = cfg.Tooltip,
                DisabledTooltip = cfg.DisabledTooltip,
                Disabled = cfg.Disabled == true,
                Visible = cfg.Visible ~= false,
                Risky = false,
                Callback = cfg.Callback or function() end
            }
        )
    end

    function tab:AddButton(cfg)
        cfg = cfg or {}
        return ensureSection():AddButton({
            Text = cfg.Name or cfg.Title or "Button",
            Func = cfg.Callback or cfg.Func or function() end,
            DoubleClick = cfg.DoubleClick == true,
            Tooltip = cfg.Tooltip,
            DisabledTooltip = cfg.DisabledTooltip,
            Disabled = cfg.Disabled == true,
            Visible = cfg.Visible ~= false,
            Risky = false
        })
    end

    function tab:AddDropdown(cfg)
        cfg = cfg or {}
        local values = cfg.Options or cfg.Values or cfg.Items or {}
        return ensureSection():AddDropdown(
            cfg.Flag or cfg.Name or cfg.Title or ("Dropdown_" .. tostring(os.clock())),
            {
                Values = values,
                Default = cfg.Default,
                Multi = cfg.Multi == true,
                Text = cfg.Name or cfg.Title or "Dropdown",
                Tooltip = cfg.Tooltip,
                DisabledTooltip = cfg.DisabledTooltip,
                Searchable = cfg.Searchable == true,
                Disabled = cfg.Disabled == true,
                Visible = cfg.Visible ~= false,
                Callback = cfg.Callback or function() end
            }
        )
    end

    function tab:AddSlider(cfg)
        cfg = cfg or {}
        return ensureSection():AddSlider(
            cfg.Flag or cfg.Name or cfg.Title or ("Slider_" .. tostring(os.clock())),
            {
                Text = cfg.Name or cfg.Title or "Slider",
                Default = cfg.Default or cfg.Min or 0,
                Min = cfg.Min or 0,
                Max = cfg.Max or 100,
                Rounding = cfg.Rounding or 0,
                Suffix = cfg.Suffix,
                Compact = cfg.Compact == true,
                HideMax = cfg.HideMax == true,
                Tooltip = cfg.Tooltip,
                DisabledTooltip = cfg.DisabledTooltip,
                Disabled = cfg.Disabled == true,
                Visible = cfg.Visible ~= false,
                Callback = cfg.Callback or function() end
            }
        )
    end

    function tab:AddTextBox(cfg)
        cfg = cfg or {}
        return ensureSection():AddInput(
            cfg.Flag or cfg.Name or cfg.Title or ("Input_" .. tostring(os.clock())),
            {
                Default = cfg.Default or "",
                Numeric = cfg.Numeric == true or cfg.NumbersOnly == true,
                Finished = cfg.Finished == true,
                ClearTextOnFocus = cfg.ClearTextOnFocus ~= false,
                Text = cfg.Name or cfg.Title or "Input",
                Placeholder = cfg.Placeholder or "",
                Tooltip = cfg.Tooltip,
                DisabledTooltip = cfg.DisabledTooltip,
                Disabled = cfg.Disabled == true,
                Visible = cfg.Visible ~= false,
                Callback = cfg.Callback or function() end
            }
        )
    end

    function tab:AddParagraph(a, b)
        local section = ensureSection()
        local titleLabel = section:AddLabel(tostring(a or ""))
        local descLabel = section:AddLabel(tostring(b or ""), true)
        local proxy = { _title = titleLabel, _desc = descLabel }
        function proxy:SetDesc(value) pcall(function() descLabel:SetText(tostring(value or "")) end) end
        function proxy:SetDescription(value) self:SetDesc(value) end
        function proxy:Set(value) pcall(function() titleLabel:SetText(tostring(value or "")) end) end
        return proxy
    end

    function tab:AddDiscordInvite(cfg)
        cfg = cfg or {}
        return ensureSection():AddButton({
            Text = cfg.Title or "Discord",
            Func = cfg.Callback or function()
                if cfg.Invite and setclipboard then pcall(setclipboard, tostring(cfg.Invite)) end
            end
        })
    end

    return tab
end

function Window:MakeTab(cfg)
    cfg = cfg or {}
    local title = tostring(cfg.Title or cfg.Name or "Tab")
    local icon = cfg.Icon
    local page = RealWindow:AddTab(title, icon)
    return MakeTabShim(page)
end

function Window:Notify(opts)
    opts = opts or {}
    pcall(function()
        Library:Notify({
            Title = opts.Title or "Huy Pham Hub",
            Description = opts.Content or opts.Message or opts.Description or "",
            Time = opts.Duration or 3,
            Icon = opts.Icon
        })
    end)
end

local redzlib = { Notify = function(_, opts) Window:Notify(opts) end }

print("[Huy Pham Hub] Obsidian Black & White UI ready")

-- ============================================================
-- TẠO TABS
-- ============================================================
local Tabs = {
    Info = Window:MakeTab({ Title = "Info And Status", Icon = "info" }),
    Main = Window:MakeTab({ Title = "Main", Icon = "rbxassetid://10709769508" }),
    Font = Window:MakeTab({ Title = "Font", Icon = "type" }),
    Settings = Window:MakeTab({ Title = "Setting", Icon = "settings" }),
    Fish = Window:MakeTab({ Title = "Fishing", Icon = "fish" }),
    Quests = Window:MakeTab({ Title = "Quest And Item", Icon = "scroll" }),
    SeaEvent = Window:MakeTab({ Title = "Sea Event", Icon = "rbxassetid://10747376931" }),
    Race = Window:MakeTab({ Title = "Mirage And Race", Icon = "moon" }),
    Prehistoric = Window:MakeTab({ Title = "Volcano Event", Icon = "flame" }),
    Esp = Window:MakeTab({ Title = "Stats And Esp", Icon = "eye" }),
    Raids = Window:MakeTab({ Title = "Fruit And Raid", Icon = "swords" }),
    Combat = Window:MakeTab({ Title = "Local Player", Icon = "user" }),
    Travel = Window:MakeTab({ Title = "Teleport", Icon = "map" }),
    Shop = Window:MakeTab({ Title = "Shop", Icon = "shopping-cart" }),
    Misc = Window:MakeTab({ Title = "Miscellaneous", Icon = "settings-2" })
}

pcall(function()
    SaveManager:BuildConfigSection(Tabs.Settings)
    ThemeManager:ApplyToTab(Tabs.Settings)
end)

-- ============================================================
-- INFO TAB
-- ============================================================
Tabs.Info:AddSection("Information")

Tabs.Info:AddDiscordInvite({
    Title = "Huy Pham Hub | Community🇻🇳👑",
    Description = "Sever discord.",
    Banner = "rbxassetid://94678517792779",
    Logo = "rbxassetid://94678517792779",
    Invite = "https://discord.gg/k6MRH4KxTv",
    Members = 36, Online = 67,
})
Tabs.Info:AddDiscordInvite({
    Title = "Máy chủ siêu cấp lá đu đủ ☠️",
    Description = "Sever discord.",
    Banner = "rbxassetid://94678517792779",
    Logo = "rbxassetid://94678517792779",
    Invite = "https://discord.gg/3zuHDZCybR",
    Members = 36, Online = 67,
})
Tabs.Info:AddDiscordInvite({
    Title = "Facebook",
    Description = "Facebook.",
    Banner = "rbxassetid://94678517792779",
    Logo = "rbxassetid://94678517792779",
    Invite = "https://www.facebook.com/share/1MFxSYvpAS/",
    Members = 36, Online = 67,
})
Tabs.Info:AddDiscordInvite({
    Title = "Tiktok",
    Description = "Tiktok.",
    Banner = "rbxassetid://94678517792779",
    Logo = "rbxassetid://94678517792779",
    Invite = "tiktok.com/@dev_HuyPhamHub",
    Members = 36, Online = 67,
})
Tabs.Info:AddDiscordInvite({
    Title = "Instagram",
    Description = "Instagram.",
    Banner = "rbxassetid://94678517792779",
    Logo = "rbxassetid://94678517792779",
    Invite = "https://www.instagram.com/ttd.213?igsh=N2ljc3A4NTQ0ZW9n",
    Members = 36, Online = 67,
})

Tabs.Info:AddSection("Status Server")

-- Time Zone
local TimeZone = Tabs.Info:AddParagraph("Time Zone", "")
function UpdateOS()
    local date = os.date("*t")
    local hour = (date.hour) % 24
    local ampm = hour < 12 and "AM" or "PM"
    local timezone = string.format("%02i:%02i:%02i %s", ((hour - 1) % 12) + 1, date.min, date.sec, ampm)
    local datetime = string.format("%02d/%02d/%04d", date.day, date.month, date.year)
    local LocalizationService = game:GetService("LocalizationService")
    local player = game:GetService("Players").LocalPlayer
    local result, code
    if not getgenv().countryRegionCode then
        result, code = pcall(function() return LocalizationService:GetCountryRegionForPlayerAsync(player) end)
        getgenv().countryRegionCode = result and code or "Unknown"
    else code = getgenv().countryRegionCode end
    TimeZone:SetDesc(datetime .. " - " .. timezone .. " [ " .. code .. " ]")
end
spawn(function() while true do UpdateOS(); wait(1) end end)

-- Game Time
local GameTime = Tabs.Info:AddParagraph("Game Time", "")
function UpdateGameTime()
    local GameTimeValue = math.floor(workspace.DistributedGameTime + 0.5)
    local Hour = math.floor(GameTimeValue / (60^2)) % 24
    local Minute = math.floor(GameTimeValue / (60^1)) % 60
    local Second = math.floor(GameTimeValue / (60^0)) % 60
    GameTime:SetDesc(Hour .. "h " .. Minute .. "m " .. Second .. "s")
end
spawn(function() while true do UpdateGameTime(); wait(1) end end)

-- Mirage
local MirageCheck = Tabs.Info:AddParagraph("Mirage Island", "Status: ")
local previousMirageStatus = ""
spawn(function()
    pcall(function()
        while true do
            wait(1)
            local mirageIslandExists = game.Workspace._WorldOrigin.Locations:FindFirstChild('Mirage Island') ~= nil
            local currentStatus = mirageIslandExists and '✅' or '❌'
            if currentStatus ~= previousMirageStatus then
                MirageCheck:SetDesc('Status: ' .. currentStatus)
                previousMirageStatus = currentStatus
            end
        end
    end)
end)

-- Kitsune
local KitsuneCheck = Tabs.Info:AddParagraph("Kitsune Island", "Status: ")
local previousKitsuneStatus = ""
spawn(function()
    while task.wait(1) do
        local currentStatus = game:GetService("Workspace").Map:FindFirstChild("KitsuneIsland") and '✅' or '❌'
        if currentStatus ~= previousKitsuneStatus then
            KitsuneCheck:SetDesc('Status: ' .. currentStatus)
            previousKitsuneStatus = currentStatus
        end
    end
end)

-- Prehistoric
local PrehistoricCheck = Tabs.Info:AddParagraph("Prehistoric Island", "Status: ")
local previousPrehistoricStatus = ""
task.spawn(function()
    while task.wait(1) do
        local currentStatus = game.Workspace._WorldOrigin.Locations:FindFirstChild("Prehistoric Island") and '✅' or '❌'
        if currentStatus ~= previousPrehistoricStatus then
            PrehistoricCheck:SetDesc("Status: " .. currentStatus)
            previousPrehistoricStatus = currentStatus
        end
    end
end)

-- Frozen
local FrozenCheck = Tabs.Info:AddParagraph("Frozen Dimension", "Status: ")
local previousFrozenStatus = ""
spawn(function()
    while wait(1) do
        local currentStatus = game.Workspace._WorldOrigin.Locations:FindFirstChild('Frozen Dimension') and '✅' or '❌'
        if currentStatus ~= previousFrozenStatus then
            FrozenCheck:SetDesc('Status: ' .. currentStatus)
            previousFrozenStatus = currentStatus
        end
    end
end)

-- Cake Prince
local CakePrinceStatus = Tabs.Info:AddParagraph("Cake Prince", "")
spawn(function()
    while wait(1) do
        local cakePrince = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CakePrinceSpawner")
        local killStatus = "Cake Prince: ✅"
        if string.len(cakePrince) >= 86 then
            local killCount = string.sub(cakePrince, 39, 41)
            killStatus = "Killed: " .. killCount
        end
        CakePrinceStatus:SetDesc(killStatus)
    end
end)

-- Rip Indra
local RipIndraCheck = Tabs.Info:AddParagraph("Rip Indra", "Status: ")
local previousRipStatus = ""
spawn(function()
    while wait(1) do
        local currentStatus = (game:GetService("ReplicatedStorage"):FindFirstChild("rip_indra True Form") or game:GetService("Workspace").Enemies:FindFirstChild("rip_indra")) and '✅' or '❌'
        if currentStatus ~= previousRipStatus then
            RipIndraCheck:SetDesc("Status: " .. currentStatus)
            previousRipStatus = currentStatus
        end
    end
end)

-- Dough King
local DoughKingCheck = Tabs.Info:AddParagraph("Dough King", "Status: ")
local previousDoughStatus = ""
spawn(function()
    while wait(1) do
        local currentStatus = (game:GetService("ReplicatedStorage"):FindFirstChild("Dough King") or game:GetService("Workspace").Enemies:FindFirstChild("Dough King")) and '✅' or '❌'
        if currentStatus ~= previousDoughStatus then
            DoughKingCheck:SetDesc("Status: " .. currentStatus)
            previousDoughStatus = currentStatus
        end
    end
end)

-- Full Moon
local FullMoonCheck = Tabs.Info:AddParagraph("Full Moon", "")
task.spawn(function()
    while task.wait(1) do
        local moonTextureId = game:GetService("Lighting").Sky.MoonTextureId
        local moonStatus = "Moon: 0/5"
        if moonTextureId == "http://www.roblox.com/asset/?id=9709149431" then moonStatus = "Moon: 5/5 (Full Moon) ✅"
        elseif moonTextureId == "http://www.roblox.com/asset/?id=9709149052" then moonStatus = "Moon: 4/5"
        elseif moonTextureId == "http://www.roblox.com/asset/?id=9709143733" then moonStatus = "Moon: 3/5"
        elseif moonTextureId == "http://www.roblox.com/asset/?id=9709150401" then moonStatus = "Moon: 2/5"
        elseif moonTextureId == "http://www.roblox.com/asset/?id=9709149680" then moonStatus = "Moon: 1/5" end
        FullMoonCheck:SetDesc(moonStatus)
    end
end)

-- Legendary Sword
local LegendarySwordCheck = Tabs.Info:AddParagraph("Legendary Sword", "Status: ")
spawn(function()
    while wait(1) do
        local swordStatus = "Not Found"
        if game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("LegendarySwordDealer", "1") then swordStatus = "Shisui ✅"
        elseif game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("LegendarySwordDealer", "2") then swordStatus = "Wando ✅"
        elseif game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("LegendarySwordDealer", "3") then swordStatus = "Saddi ✅" end
        LegendarySwordCheck:SetDesc(swordStatus)
    end
end)

-- Bones
local BoneCount = Tabs.Info:AddParagraph("Bone", "")
spawn(function()
    while wait(1) do
        local bones = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Bones", "Check")
        BoneCount:SetDesc("You Have: " .. tostring(bones) .. " Bones")
    end
end)

-- ============================================================
-- FONT TAB
-- ============================================================
Tabs.Font:AddSection("Font")
local currentFont = Enum.Font.Code
local function ApplyGlobalFont(fontEnum)
    currentFont = fontEnum
    for _, obj in ipairs(game.Players.LocalPlayer.PlayerGui:GetDescendants()) do
        if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
            obj.Font = fontEnum
        end
    end
end

game.Players.LocalPlayer.PlayerGui.DescendantAdded:Connect(function(obj)
    if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
        obj.Font = currentFont
    end
end)

local fontList = {
    {"Amatic SC", Enum.Font.AmaticSC}, {"Antique", Enum.Font.Antique},
    {"Arcade", Enum.Font.Arcade}, {"Arial", Enum.Font.Arial},
    {"Arial Bold", Enum.Font.ArialBold}, {"Bangers", Enum.Font.Bangers},
    {"Bodoni", Enum.Font.Bodoni}, {"Cartoon", Enum.Font.Cartoon},
    {"Code", Enum.Font.Code}, {"Creepster", Enum.Font.Creepster},
    {"Denk One", Enum.Font.DenkOne}, {"Fondamento", Enum.Font.Fondamento},
    {"Fredoka One", Enum.Font.FredokaOne}, {"Garamond", Enum.Font.Garamond},
    {"Gotham", Enum.Font.Gotham}
}

for _, fontData in ipairs(fontList) do
    Tabs.Font:AddButton({
        Name = "Font: " .. fontData[1],
        Description = "",
        Callback = function() ApplyGlobalFont(fontData[2]) end
    })
end

pcall(function() ApplyGlobalFont(Enum.Font.Code) end)

-- ============================================================
-- END PHẦN 2
-- ============================================================
-- ============================================================
-- MAIN TAB - WEAPON SELECT
-- ============================================================
WeaponDropdown = Tabs.Main:AddDropdown({
    Name = "Select Weapon",
    Options = {"Melee", "Sword", "Blox Fruit", "Gun"},
    Default = "nil",
    Callback = function(Value) _G.ChooseWP = Value end
})
spawn(function()
    while task.wait(0.5) do
        pcall(function()
            if _G.ChooseWP == "Melee" then
                for _, v in pairs(plr.Backpack:GetChildren()) do
                    if v.ToolTip == "Melee" then _G.SelectWeapon = v.Name end
                end
            elseif _G.ChooseWP == "Sword" then
                for _, v in pairs(plr.Backpack:GetChildren()) do
                    if v.ToolTip == "Sword" then _G.SelectWeapon = v.Name end
                end
            elseif _G.ChooseWP == "Gun" then
                for _, v in pairs(plr.Backpack:GetChildren()) do
                    if v.ToolTip == "Gun" then _G.SelectWeapon = v.Name end
                end
            elseif _G.ChooseWP == "Blox Fruit" then
                for _, v in pairs(plr.Backpack:GetChildren()) do
                    if v.ToolTip == "Blox Fruit" then _G.SelectWeapon = v.Name end
                end
            end
        end)
    end
end)

-- ============================================================
-- FARMING SECTION
-- ============================================================
Tabs.Main:AddSection("Farming")

FarmLevel = Tabs.Main:AddToggle({
    Name = "Auto Farm Level",
    Description = "",
    Default = false,
    Callback = function(Value)
        _G.Level = Value
        if not Value then
            _G._alreadyTeleported = false
            _G._teleporting = false
        end
    end
})

local function IsInSubmergedIsland()
    local char = plr.Character
    if not char then return false end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    local islandXZ = Vector3.new(11520.8017578125, 0, 9829.513671875)
    local playerXZ = Vector3.new(hrp.Position.X, 0, hrp.Position.Z)
    return (playerXZ - islandXZ).Magnitude < 2000
end

task.spawn(function()
    while task.wait(Sec) do
        if _G.Level then
            pcall(function()
                local char = plr.Character or plr.CharacterAdded:Wait()
                local Root = char:WaitForChild("HumanoidRootPart")
                if not Root then return end
                local level = plr.Data.Level.Value
                local inSub = IsInSubmergedIsland()
                local questUI = plr.PlayerGui.Main.Quest
                local QuestTitle = questUI.Visible and questUI.Container.QuestTitle.Title.Text or ""

                if level >= 2600 and not inSub and not _G._teleporting and not _G._alreadyTeleported then
                    _G._teleporting = true
                    local npcPos = CFrame.new(-16269.7041, 25.2288494, 1373.65955)
                    local teleportAttempts = 0
                    repeat
                        task.wait(Sec)
                        _tp(npcPos)
                        teleportAttempts = teleportAttempts + 1
                    until not _G.Level or (Root.Position - npcPos.Position).Magnitude <= 8 or teleportAttempts > 20
                    if not _G.Level then _G._teleporting = false return end
                    task.wait(1)
                    pcall(function()
                        local args = {"TravelToSubmergedIsland"}
                        game:GetService("ReplicatedStorage").Modules.Net:FindFirstChild("RF/SubmarineWorkerSpeak"):InvokeServer(unpack(args))
                    end)
                    local timeout = tick()
                    repeat
                        task.wait(0.5)
                        local currentInSub = IsInSubmergedIsland()
                        local farFromNPC = (Root.Position - npcPos.Position).Magnitude > 50
                        if currentInSub or farFromNPC then break end
                    until not _G.Level or tick() - timeout > 15
                    task.wait(2)
                    _G._alreadyTeleported = true
                    _G._teleporting = false
                elseif inSub or level < 2600 then
                    _G._alreadyTeleported = true
                    _G._teleporting = false
                    local questData = QuestNeta()
                    if not questData or not questData[1] then task.wait(1) return end
                    if questUI.Visible and not string.find(QuestTitle, questData[1]) then
                        replicated.Remotes.CommF_:InvokeServer("AbandonQuest")
                        task.wait(0.2)
                        return
                    end
                    if not questUI.Visible then
                        local questPos = questData[6]
                        if questPos then
                            _tp(questPos)
                            task.wait(2)
                            if (Root.Position - questPos.Position).Magnitude <= 10 then
                                pcall(function()
                                    replicated.Remotes.CommF_:InvokeServer("StartQuest", questData[3], questData[2])
                                end)
                                task.wait(1)
                            end
                        else
                            pcall(function()
                                replicated.Remotes.CommF_:InvokeServer("StartQuest", questData[3], questData[2])
                            end)
                            task.wait(1)
                        end
                        return
                    end
                    local enemyName = questData[1]
                    local foundMob = false
                    for _, v in pairs(workspace.Enemies:GetChildren()) do
                        if v.Name == enemyName and Attack.Alive(v) then
                            foundMob = true
                            repeat
                                task.wait(Sec)
                                _tp(v.HumanoidRootPart.CFrame * CFrame.new(0, 20, 0))
                                Attack.Kill(v, _G.Level)
                                if not questUI.Visible then break end
                            until not _G.Level or not v.Parent or v.Humanoid.Health <= 0
                            break
                        end
                    end
                    if not foundMob then
                        for _, v in pairs(replicated:GetChildren()) do
                            if v.Name == enemyName and Attack.Alive(v) then
                                foundMob = true
                                _tp(v.HumanoidRootPart.CFrame * CFrame.new(0, 20, 0))
                                break
                            end
                        end
                    end
                    if not foundMob then
                        for _, spawnPoint in pairs(workspace["_WorldOrigin"].EnemySpawns:GetChildren()) do
                            if string.find(spawnPoint.Name, enemyName) then
                                _tp(spawnPoint.CFrame * CFrame.new(0, 20, 0))
                                break
                            end
                        end
                    end
                end
            end)
        else
            _G._teleporting = false
            _G._alreadyTeleported = false
        end
    end
end)

ClosetMons = Tabs.Main:AddToggle({
    Name = "Auto Farm Nearest",
    Description = "",
    Default = false,
    Callback = function(Value) _G.AutoFarmNear = Value end
})
spawn(function()
    while wait() do
        pcall(function()
            if _G.AutoFarmNear then
                for i, v in pairs(workspace.Enemies:GetChildren()) do
                    if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                        repeat
                            wait()
                            Attack.Kill(v, _G.AutoFarmNear)
                        until not _G.AutoFarmNear or not v.Parent or v.Humanoid.Health <= 0
                    end
                end
            end
        end)
    end
end)

FactoryRaids = Tabs.Main:AddToggle({
    Name = "Auto Factory Raid",
    Description = "",
    Default = false,
    Callback = function(Value) _G.AutoFactory = Value end
})
spawn(function()
    while wait(Sec) do
        pcall(function()
            if _G.AutoFactory then
                local v = GetConnectionEnemies("Core")
                if v then
                    repeat
                        wait()
                        EquipWeapon(_G.SelectWeapon)
                        _tp(CFrame.new(448.46756, 199.356781, -441.389252))
                    until v.Humanoid.Health <= 0 or _G.AutoFactory == false
                else
                    _tp(CFrame.new(448.46756, 199.356781, -441.389252))
                end
            end
        end)
    end
end)

CastleRaids = Tabs.Main:AddToggle({
    Name = "Auto Pirate Raid",
    Description = "",
    Default = false,
    Callback = function(Value) _G.AutoRaidCastle = Value end
})
spawn(function()
    while wait(Sec) do
        if _G.AutoRaidCastle then
            pcall(function()
                local CFrameCastleRaid = CFrame.new(-5496.17432, 313.768921, -2841.53027, 0.924894512, 7.37058015e-09, 0.380223751, 3.5881019e-08, 1, -1.06665446e-07, -0.380223751, 1.12297109e-07, 0.924894512)
                if (CFrame.new(-5539.3115234375, 313.800537109375, -2972.372314453125).Position - Root.Position).Magnitude <= 500 then
                    for i, v in pairs(workspace.Enemies:GetChildren()) do
                        if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                            if (v.HumanoidRootPart.Position - Root.Position).Magnitude <= 2000 then
                                repeat
                                    wait()
                                    Attack.Kill(v, _G.AutoRaidCastle)
                                until not _G.AutoRaidCastle or not v.Parent or v.Humanoid.Health <= 0 or not workspace.Enemies:FindFirstChild(v.Name)
                            end
                        end
                    end
                else
                    local Castle_Mob = {"Galley Pirate", "Galley Captain", "Raider", "Mercenary", "Vampire", "Zombie", "Snow Trooper", "Winter Warrior", "Lab Subordinate", "Horned Warrior", "Magma Ninja", "Lava Pirate", "Ship Deckhand", "Ship Engineer", "Ship Steward", "Ship Officer", "Arctic Warrior", "Snow Lurker", "Sea Soldier", "Water Fighter"}
                    for i = 1, #Castle_Mob do
                        if replicated:FindFirstChild(Castle_Mob[i]) then
                            for _, v in pairs(replicated:GetChildren()) do
                                if table.find(Castle_Mob, v.Name) then
                                    _tp(CFrameCastleRaid)
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
end)

Ecto = Tabs.Main:AddToggle({
    Name = "Auto Farm Ectoplasm",
    Description = "",
    Default = false,
    Callback = function(Value) _G.AutoEctoplasm = Value end
})
spawn(function()
    while wait(Sec) do
        pcall(function()
            if _G.AutoEctoplasm then
                local EctoTable = {"Ship Deckhand", "Ship Engineer", "Ship Steward", "Ship Officer", "Arctic Warrior"}
                local v = GetConnectionEnemies(EctoTable)
                if Attack.Alive(v) then
                    repeat
                        wait()
                        Attack.Kill(v, _G.AutoEctoplasm)
                    until not _G.AutoEctoplasm or not v.Parent or v.Humanoid.Health <= 0
                else
                    replicated.Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(923.21252441406, 126.9760055542, 32852.83203125))
                end
            end
        end)
    end
end)

-- ============================================================
-- CHEST SECTION
-- ============================================================
Tabs.Main:AddSection("Chest")

ChestTW = Tabs.Main:AddToggle({
    Name = "Auto Farm Chest",
    Description = "",
    Default = false,
    Callback = function(Value) _G.AutoFarmChest = Value end
})
spawn(function()
    while wait(Sec) do
        if _G.AutoFarmChest then
            pcall(function()
                local CollectionService = game:GetService("CollectionService")
                local Player = game:GetService("Players").LocalPlayer
                local Character = Player.Character or Player.CharacterAdded:Wait()
                if not Character then return end
                local Position = Character:GetPivot().Position
                local Chests = CollectionService:GetTagged("_ChestTagged")
                local Distance, Nearest = math.huge, nil
                for i = 1, #Chests do
                    local Chest = Chests[i]
                    local Magnitude = (Chest:GetPivot().Position - Position).Magnitude
                    if not Chest:GetAttribute("IsDisabled") and Magnitude < Distance then
                        Distance = Magnitude
                        Nearest = Chest
                    end
                end
                if Nearest then _tp(Nearest:GetPivot()) end
            end)
        end
    end
end)

ChestBP = Tabs.Main:AddToggle({
    Name = "Auto Chest Bypass",
    Description = "",
    Default = false,
    Callback = function(Value)
        _G.AutoChestBP = Value
        if Value then
            local LocalPlayer = game:GetService("Players").LocalPlayer
            local IsFarming = false
            local UncheckedChests = {}
            local FirstRun = true

            local function getCharacter()
                if not LocalPlayer.Character then LocalPlayer.CharacterAdded:Wait() end
                LocalPlayer.Character:WaitForChild("HumanoidRootPart")
                return LocalPlayer.Character
            end

            local function getChestsSorted()
                if FirstRun then
                    FirstRun = false
                    for _, Object in pairs(game:GetDescendants()) do
                        if Object.Name:find("Chest") and Object.ClassName == "Part" then
                            table.insert(UncheckedChests, Object)
                        end
                    end
                end
                local Chests = {}
                for _, Chest in pairs(UncheckedChests) do
                    if Chest:FindFirstChild("TouchInterest") then
                        table.insert(Chests, Chest)
                    end
                end
                local RootPart = getCharacter().LowerTorso
                table.sort(Chests, function(a, b)
                    return (RootPart.Position - a.Position).Magnitude < (RootPart.Position - b.Position).Magnitude
                end)
                return Chests
            end

            local function runChestLoop()
                if IsFarming then return end
                IsFarming = true
                task.spawn(function()
                    while _G.AutoChestBP and LocalPlayer.Character and LocalPlayer.Character.Parent do
                        local Chests = getChestsSorted()
                        if #Chests > 0 then
                            local RootPart = getCharacter().HumanoidRootPart
                            RootPart.CFrame = Chests[1].CFrame
                        end
                        task.wait(0.1)
                    end
                    IsFarming = false
                end)
            end

            LocalPlayer.CharacterAdded:Connect(function()
                getCharacter()
                task.wait(0.5)
                if _G.AutoChestBP then runChestLoop() end
            end)
            runChestLoop()
        end
    end
})

StopI = Tabs.Main:AddToggle({
    Name = "Stop Items",
    Description = "",
    Default = true,
    Callback = function(Value) _G.StopWhenChalice = Value end
})
spawn(function()
    while wait(0.2) do
        if _G.StopWhenChalice and (_G.AutoFarmChest or _G.AutoChestBP) then
            pcall(function()
                if GetBP("God's Chalice") or GetBP("Sweet Chalice") or GetBP("Fist of Darkness") then
                    _G.AutoFarmChest = false
                    _G.AutoChestBP = false
                end
            end)
        end
    end
end)

-- ============================================================
-- COLLECT BERRY
-- ============================================================
Tabs.Main:AddSection("Collect Berry")

Berry = Tabs.Main:AddToggle({
    Name = "Auto Farm Berry",
    Description = "",
    Default = false,
    Callback = function(Value) _G.AutoBerry = Value end
})
spawn(function()
    while wait(Sec) do
        if _G.AutoBerry then
            local CollectionService = game:GetService("CollectionService")
            local BerryBush = CollectionService:GetTagged("BerryBush")
            for i = 1, #BerryBush do
                local Bush = BerryBush[i]
                for AttributeName, BerryName in pairs(Bush:GetAttributes()) do
                    if not BerryArray or table.find(BerryArray, BerryName) then
                        _tp(Bush.Parent:GetPivot())
                        for i = 1, #BerryBush do
                            local Bush = BerryBush[i]
                            for AttributeName, BerryName in pairs(Bush:GetChildren()) do
                                if not BerryArray or table.find(BerryArray, BerryName) then
                                    _tp(BerryName.WorldPivot)
                                    fireproximityprompt(BerryName.ProximityPrompt, math.huge)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end)

BerryH = Tabs.Main:AddToggle({
    Name = "Auto Farm Berry + Hop",
    Description = "",
    Default = false,
    Callback = function(Value) _G.AutoBerryH = Value end
})
spawn(function()
    while wait(Sec) do
        if _G.AutoBerryH then
            local CollectionService = game:GetService("CollectionService")
            local Player = game:GetService("Players").LocalPlayer
            local BerryBush = CollectionService:GetTagged("BerryBush")
            if #BerryBush == 0 then
                local TeleportService = game:GetService("TeleportService")
                local ServerList = {}
                local Success = pcall(function()
                    ServerList = game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
                end)
                if Success and ServerList.data then
                    for _, Server in pairs(ServerList.data) do
                        if Server.playing < Server.maxPlayers and Server.id ~= game.JobId then
                            TeleportService:TeleportToPlaceInstance(game.PlaceId, Server.id, Player)
                            break
                        end
                    end
                end
            else
                for i = 1, #BerryBush do
                    local Bush = BerryBush[i]
                    for AttributeName, BerryName in pairs(Bush:GetAttributes()) do
                        if not BerryArray or table.find(BerryArray, BerryName) then
                            _tp(Bush.Parent:GetPivot())
                            for j = 1, #BerryBush do
                                local Bush2 = BerryBush[j]
                                for _, BerryChild in pairs(Bush2:GetChildren()) do
                                    if not BerryArray or table.find(BerryArray, BerryChild.Name) then
                                        _tp(BerryChild.WorldPivot)
                                        fireproximityprompt(BerryChild.ProximityPrompt, math.huge)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- ============================================================
-- FARM MOB
-- ============================================================
Tabs.Main:AddSection("Farm Mob")

if World1 then
    Tabs.Main:AddDropdown({
        Name = "Select Mob",
        Default = "Bandit",
        Options = {"Bandit", "Monkey", "Gorilla", "Pirate", "Brute", "Desert Bandit", "Desert Officer", "Snow Bandit", "Snowman", "Chief Petty Officer", "Sky Bandit", "Dark Master", "Toga Warrior", "Gladiator", "Military Soldier", "Military Spy", "Fishman Warrior", "Fishman Commando", "God's Guard", "Shanda", "Royal Squad", "Royal Soldier", "Galley Pirate", "Galley Captain"},
        Callback = function(Value) getgenv().SelectMob = Value end
    })
end
if World2 then
    Tabs.Main:AddDropdown({
        Name = "Select Mob",
        Default = "Raider",
        Options = {"Raider", "Mercenary", "Swan Pirate", "Factory Staff", "Marine Lieutenant", "Marine Captain", "Zombie", "Vampire", "Snow Trooper", "Winter Warrior", "Lab Subordinate", "Horned Warrior", "Magma Ninja", "Lava Pirate", "Ship Deckhand", "Ship Engineer", "Ship Steward", "Ship Officer", "Arctic Warrior", "Snow Lurker", "Sea Soldier", "Water Fighter"},
        Callback = function(Value) getgenv().SelectMob = Value end
    })
end
if World3 then
    Tabs.Main:AddDropdown({
        Name = "Select Mob",
        Options = {"Pirate Millionaire", "Dragon Crew Warrior", "Dragon Crew Archer", "Female Islander", "Giant Islander", "Marine Commodore", "Marine Rear Admiral", "Fishman Raider", "Fishman Captain", "Forest Pirate", "Mythological Pirate", "Jungle Pirate", "Musketeer Pirate", "Reborn Skeleton", "Living Zombie", "Demonic Soul", "Posessed Mummy", "Peanut Scout", "Peanut President", "Ice Cream Chef", "Ice Cream Commander", "Cookie Crafter", "Cake Guard", "Baking Staff", "Head Baker", "Cocoa Warrior", "Chocolate Bar Battler", "Sweet Thief", "Candy Rebel", "Candy Pirate", "Snow Demon", "Isle Outlaw", "Island Boy", "Sun-kissed Warrior", "Isle Champion"},
        Callback = function(Value) getgenv().SelectMob = Value end
    })
end

Tabs.Main:AddToggle({
    Name = "Auto Kill Mob",
    Default = false,
    Callback = function(Value) _G.AutoKillMob = Value end
})
spawn(function()
    while wait() do
        if _G.AutoKillMob then
            pcall(function()
                if game:GetService("Workspace").Enemies:FindFirstChild(getgenv().SelectMob) then
                    for i, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                        if v.Name == getgenv().SelectMob and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                            repeat
                                game:GetService("RunService").Heartbeat:Wait()
                                Attack.Kill(v, _G.AutoKillMob)
                            until not _G.AutoKillMob or not v.Parent or v.Humanoid.Health <= 0
                        end
                    end
                end
            end)
        end
    end
end)

-- ============================================================
-- FARM ALL ISLAND
-- ============================================================
Tabs.Main:AddSection("Farm All Island")

local Sea1_Islands = {
    ["Pirates"] = { CFrame = CFrame.new(-2709.67944, 24.5206585, 2104.24585), Mobs = {"Bandit"} },
    ["Marine"] = { CFrame = CFrame.new(-2709.67944, 24.5206585, 2104.24585), Mobs = {"Trainee"} },
    ["Jungle"] = { CFrame = CFrame.new(-1600, 36, 150), Mobs = {"Monkey", "Gorilla"} },
    ["Pirate Village"] = { CFrame = CFrame.new(-1100, 4, 3850), Mobs = {"Pirate", "Brute"} },
    ["Desert"] = { CFrame = CFrame.new(1090, 7, 4370), Mobs = {"Desert Bandit", "Desert Officer"} },
    ["Frozen Village"] = { CFrame = CFrame.new(1200, 28, -1500), Mobs = {"Snow Bandit", "Snowman"} },
    ["Marine Fortress"] = { CFrame = CFrame.new(-4500, 20, 4250), Mobs = {"Chief Petty Officer"} },
    ["Skylands Lower"] = { CFrame = CFrame.new(-5000, 700, -2500), Mobs = {"Sky Bandit", "Dark Master"} },
    ["Prison"] = { CFrame = CFrame.new(4875, 6, 735), Mobs = {"Prisoner", "Dangerous Prisoner"} },
    ["Colosseum"] = { CFrame = CFrame.new(-1500, 60, -290), Mobs = {"Toga Warrior", "Gladiator"} },
    ["Magma Village"] = { CFrame = CFrame.new(-5200, 8, 8400), Mobs = {"Military Soldier", "Military Spy"} },
    ["Underwater City"] = { CFrame = CFrame.new(61160, 5, 1819), Mobs = {"Fishman Warrior", "Fishman Commando"} },
    ["Skylands Upper"] = { CFrame = CFrame.new(-7880, 5545, -380), Mobs = {"Shanda", "Royal Squad", "Royal Soldier"} }
}
local Sea2_Islands = {
    ["Kingdom of Rose"] = { CFrame = CFrame.new(-321, 73, 297), Mobs = { "Raider", "Mercenary", "Swan Pirate", "Factory Staff" } },
    ["Green Zone"] = { CFrame = CFrame.new(-2447, 73, -3211), Mobs = { "Marine Lieutenant", "Marine Captain" } },
    ["Graveyard Island"] = { CFrame = CFrame.new(-9515, 142, 5536), Mobs = { "Zombie", "Vampire" } },
    ["Snow Mountain"] = { CFrame = CFrame.new(561, 401, -5306), Mobs = { "Snow Trooper", "Winter Warrior" } },
    ["Hot and Cold (Cold)"] = { CFrame = CFrame.new(-6026, 15, -5062), Mobs = { "Lab Subordinate", "Horned Warrior" } },
    ["Hot and Cold (Hot)"] = { CFrame = CFrame.new(-5478, 15, -5240), Mobs = { "Magma Ninja", "Lava Pirate" } },
    ["Cursed Ship"] = { CFrame = CFrame.new(902, 126, 33071), Mobs = { "Ship Deckhand", "Ship Engineer", "Ship Steward", "Ship Officer" } },
    ["Ice Castle"] = { CFrame = CFrame.new(6137, 294, -6747), Mobs = { "Arctic Warrior", "Snow Lurker" } },
    ["Forgotten Island"] = { CFrame = CFrame.new(-3043, 238, -10191), Mobs = { "Sea Soldier", "Water Fighter" } }
}
local Sea3_Islands = {
    ["Port Town"] = { CFrame = CFrame.new(-290, 44, 5450), Mobs = { "Pirate Millionaire", "Pistol Billionaire" } },
    ["Hydra Island"] = { CFrame = CFrame.new(5228, 604, 345), Mobs = { "Dragon Crew Warrior", "Dragon Crew Archer", "Female Islander", "Giant Islander" } },
    ["Great Tree"] = { CFrame = CFrame.new(2682, 1682, -7190), Mobs = { "Marine Commodore", "Marine Rear Admiral" } },
    ["Floating Turtle"] = { CFrame = CFrame.new(-12000, 331, -8500), Mobs = { "Forest Pirate", "Mythological Pirate", "Jungle Pirate", "Musketeer Pirate", "Fishman Raider", "Fishman Captain" } },
    ["Haunted Castle"] = { CFrame = CFrame.new(-9515, 142, 5536), Mobs = { "Reborn Skeleton", "Living Zombie", "Demonic Soul", "Posessed Mummy" } },
    ["Sea of Treats"] = { CFrame = CFrame.new(-1145, 13, -14450), Mobs = { "Peanut Scout", "Peanut President", "Ice Cream Commander", "Cookie Crafter", "Cake Guard", "Baking Staff", "Head Baker", "Cocoa Warrior", "Chocolate Bar Battler", "Sweet Thief", "Candy Rebel" } },
    ["Tiki Outpost"] = { CFrame = CFrame.new(-16200, 90, -17300), Mobs = { "Isle Outlaw", "Island Boy", "Sun-kissed Warrior", "Isle Champion" } },
    ["Submerged Island"] = { CFrame = CFrame.new(-3200, -10, -10000), Mobs = { "Reef Bandit", "Coral Pirate", "Sea Chanter", "Ocean Prophet", "High Disciple", "Grand Devotee" } }
}

if World1 then
    Tabs.Main:AddDropdown({
        Name = "Select Island",
        Options = {"Pirates", "Marine", "Jungle", "Pirate Village", "Desert", "Frozen Village", "Marine Fortress", "Skylands Lower", "Prison", "Colosseum", "Magma Village", "Underwater City", "Skylands Upper"},
        Callback = function(Value) _G.SelectIsland = Value end
    })
end
if World2 then
    Tabs.Main:AddDropdown({
        Name = "Select Island",
        Options = {"Kingdom of Rose", "Green Zone", "Graveyard Island", "Snow Mountain", "Hot and Cold (Cold)", "Hot and Cold (Hot)", "Cursed Ship", "Ice Castle", "Forgotten Island"},
        Callback = function(Value) _G.SelectIsland = Value end
    })
end
if World3 then
    Tabs.Main:AddDropdown({
        Name = "Select Island",
        Options = {"Port Town", "Hydra Island", "Great Tree", "Floating Turtle", "Haunted Castle", "Sea of Treats", "Tiki Outpost", "Submerged Island"},
        Callback = function(Value) _G.SelectIsland = Value end
    })
end

local IslandData
if World1 then IslandData = Sea1_Islands
elseif World2 then IslandData = Sea2_Islands
elseif World3 then IslandData = Sea3_Islands end

Tabs.Main:AddToggle({
    Name = "Auto Farm All Island",
    Default = false,
    Callback = function(Value) _G.AutoFarmIsland = Value end
})
task.spawn(function()
    while task.wait(0.2) do
        if not _G.AutoFarmIsland then continue end
        if not _G.SelectIsland then continue end
        if not IslandData then continue end
        local island = IslandData[_G.SelectIsland]
        if not island then continue end
        local MobMap = {}
        for _, name in ipairs(island.Mobs) do MobMap[name] = true end
        local found = false
        for _, v in pairs(workspace.Enemies:GetChildren()) do
            if MobMap[v.Name] and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                found = true
                repeat
                    task.wait()
                    _tp(v.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0))
                    Attack.Kill(v, true)
                until not _G.AutoFarmIsland or not v.Parent or v.Humanoid.Health <= 0
            end
        end
        if not found then _tp(island.CFrame) end
    end
end)

-- ============================================================
-- FARM ELITE HUNTER
-- ============================================================
Tabs.Main:AddSection("Farm Elite Hunter")

local Process = Tabs.Main:AddParagraph("Elites Process", "")
spawn(function()
    while wait(Sec) do
        pcall(function()
            Process:SetDesc("Elite Progress : " .. replicated.Remotes.CommF_:InvokeServer("EliteHunter", "Progress"))
        end)
    end
end)

local EliteHunter = Tabs.Main:AddParagraph("Elite Spawn", "Status: ")
spawn(function()
    local previousStatus = ""
    while wait(1) do
        local currentStatus = (game:GetService("ReplicatedStorage"):FindFirstChild("Diablo") or game:GetService("ReplicatedStorage"):FindFirstChild("Deandre") or game:GetService("ReplicatedStorage"):FindFirstChild("Urban") or game:GetService("Workspace").Enemies:FindFirstChild("Diablo") or game:GetService("Workspace").Enemies:FindFirstChild("Deandre") or game:GetService("Workspace").Enemies:FindFirstChild("Urban")) and '✅' or '❌'
        local progress = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("EliteHunter", "Progress")
        if currentStatus ~= previousStatus then
            EliteHunter:SetDesc("Status: " .. currentStatus .. " | Killed: " .. progress)
            previousStatus = currentStatus
        end
    end
end)

EliteQ = Tabs.Main:AddToggle({
    Name = "Auto Farm Elite",
    Description = "",
    Default = false,
    Callback = function(Value) _G.FarmEliteHunt = Value end
})
spawn(function()
    while wait(1) do
        pcall(function()
            if _G.FarmEliteHunt then
                local questGui = plr.PlayerGui.Main.Quest
                local questTitle = questGui.Container.QuestTitle.Title.Text
                if not questGui.Visible then
                    local result = replicated.Remotes.CommF_:InvokeServer("EliteHunter")
                    if result == nil or string.find(result, "Cooldown") then wait(10) return end
                    task.wait(1)
                else
                    local eliteName = nil
                    for _, name in pairs({"Diablo", "Urban", "Deandre"}) do
                        if string.find(questTitle, name) then eliteName = name; break end
                    end
                    if eliteName then
                        local boss = nil
                        for _, v in pairs(replicated:GetChildren()) do
                            if v.Name == eliteName and v:FindFirstChild("HumanoidRootPart") then boss = v; break end
                        end
                        for _, v in pairs(Enemies:GetChildren()) do
                            if v.Name == eliteName and Attack.Alive(v) then boss = v; break end
                        end
                        if boss and boss:FindFirstChild("HumanoidRootPart") then
                            _tp(boss.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                            repeat
                                wait()
                                Attack.Kill(boss, _G.FarmEliteHunt)
                            until not _G.FarmEliteHunt or not boss.Parent or boss.Humanoid.Health <= 0 or not questGui.Visible
                        else wait(5) end
                    else
                        replicated.Remotes.CommF_:InvokeServer("AbandonQuest")
                    end
                end
            end
        end)
    end
end)

local function HopServerElite()
    local Http = game:GetService("HttpService")
    local TPS = game:GetService("TeleportService")
    local Api = "https://games.roblox.com/v1/games/"
    local PlaceID = game.PlaceId
    local Cursor = ""
    local foundServer = false
    repeat
        local success, result = pcall(function()
            return game:HttpGet(Api .. PlaceID .. "/servers/Public?sortOrder=Asc&limit=100&cursor=" .. Cursor)
        end)
        if success and result then
            local data = Http:JSONDecode(result)
            if data.data then
                for _, v in pairs(data.data) do
                    if v.playing < v.maxPlayers and v.id ~= game.JobId then
                        foundServer = true
                        TPS:TeleportToPlaceInstance(PlaceID, v.id)
                        break
                    end
                end
                Cursor = data.nextPageCursor or ""
            end
        end
    until not Cursor or foundServer
end

EliteH = Tabs.Main:AddToggle({
    Name = "Auto Farm Elite + Hop",
    Description = "",
    Default = false,
    Callback = function(Value) _G.FarmEliteH = Value end
})
spawn(function()
    while task.wait(1) do
        pcall(function()
            if _G.FarmEliteH then
                local questGui = plr.PlayerGui.Main.Quest
                local questTitle = questGui.Container.QuestTitle.Title.Text
                if not questGui.Visible then
                    local result = replicated.Remotes.CommF_:InvokeServer("EliteHunter")
                    if result == nil or string.find(result, "Cooldown") then
                        HopServerElite()
                        return
                    end
                    task.wait(1)
                else
                    local eliteName = nil
                    for _, name in pairs({"Diablo", "Urban", "Deandre"}) do
                        if string.find(questTitle, name) then eliteName = name; break end
                    end
                    if eliteName then
                        local boss = nil
                        for _, v in pairs(replicated:GetChildren()) do
                            if v.Name == eliteName and v:FindFirstChild("HumanoidRootPart") then boss = v; break end
                        end
                        for _, v in pairs(workspace.Enemies:GetChildren()) do
                            if v.Name == eliteName and Attack.Alive(v) then boss = v; break end
                        end
                        if boss and boss:FindFirstChild("HumanoidRootPart") then
                            _tp(boss.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                            repeat
                                wait()
                                Attack.Kill(boss, _G.FarmEliteH)
                            until not _G.FarmEliteH or not boss.Parent or boss.Humanoid.Health <= 0 or not questGui.Visible
                        else
                            task.wait(5)
                            HopServerElite()
                        end
                    else
                        replicated.Remotes.CommF_:InvokeServer("AbandonQuest")
                        task.wait(1)
                        HopServerElite()
                    end
                end
            end
        end)
    end
end)

-- ============================================================
-- FARM RIP INDRA
-- ============================================================
Tabs.Main:AddSection("Farm Rip Indra")

Tabs.Main:AddToggle({
    Name = "Auto Attack Rip Indra",
    Description = "",
    Default = false,
    Callback = function(Value) _G.AutoRipIngay = Value end
})
spawn(function()
    while wait(Sec) do
        pcall(function()
            if _G.AutoRipIngay then
                local v = GetConnectionEnemies("rip_indra")
                if v then
                    repeat
                        wait()
                        Attack.Kill(v, _G.AutoRipIngay)
                    until not _G.AutoRipIngay or not v.Parent or v.Humanoid.Health <= 0
                else
                    replicated.Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(-5097.93164, 316.447021, -3142.66602))
                    wait(.1)
                    _tp(CFrame.new(-5344.822265625, 423.98541259766, -2725.0930175781))
                end
            end
        end)
    end
end)

-- ============================================================
-- AUTO UNLOCKED HAKI
-- ============================================================
Tabs.Main:AddToggle({
    Name = "Auto Unlocked Haki",
    Description = "",
    Default = false,
    Callback = function(Value) _G.AutoUnHaki = Value end
})

AuraSkin = function(HakiID)
    local args = {[1] = {["StorageName"] = HakiID, ["Type"] = "AuraSkin", ["Context"] = "Equip"}}
    replicated:WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RF/FruitCustomizerRF"):InvokeServer(unpack(args))
end

VaildColor = function(Part)
    if Part and Part.BrickColor then return (tostring(Part.BrickColor) == "Lime green") end
end

HakiCalculate = function(Part)
    local ID = {["Really red"] = "Pure Red", ["Oyster"] = "Snow White", ["Hot pink"] = "Winter Sky"}
    if Part and Part.BrickColor then return (ID[tostring(Part.BrickColor)]) end
end

spawn(function()
    while wait(Sec) do
        if _G.AutoUnHaki then
            pcall(function()
                local Summoner = workspace.Map["Boat Castle"]:FindFirstChild("Summoner")
                if Summoner and Summoner:FindFirstChild("Circle") then
                    for i, v in pairs(Summoner:FindFirstChild("Circle"):GetChildren()) do
                        if v.Name == "Part" then
                            local TogglesPart = v:FindFirstChild("Part")
                            if VaildColor(TogglesPart) == false then
                                AuraSkin(HakiCalculate(v))
                                repeat wait() _tp(v.CFrame) until VaildColor(TogglesPart) == true or not _G.AutoUnHaki
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- ============================================================
-- FARMING CAKE
-- ============================================================
Tabs.Main:AddSection("Farming Cake")

local MobKilled = Tabs.Main:AddParagraph("Cake Princes", "")
spawn(function()
    while wait(0.2) do
        pcall(function()
            local Killed = string.match(replicated.Remotes.CommF_:InvokeServer("CakePrinceSpawner"), "%d+")
            if Killed then MobKilled:SetDesc("Killed : " .. (500 - tonumber(Killed) or 0)) end
        end)
    end
end)

Cake = Tabs.Main:AddToggle({
    Name = "Auto Farm Cake Prince",
    Description = "",
    Default = false,
    Callback = function(Value) _G.Auto_Cake_Prince = Value end
})
spawn(function()
    while task.wait() do
        if _G.Auto_Cake_Prince and not _G.AutoRaidCastle then
            pcall(function()
                local player = game.Players.LocalPlayer
                local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                local questUI = player.PlayerGui.Main.Quest
                local enemies = workspace.Enemies
                local cakeMap = workspace.Map:FindFirstChild("CakeLoaf")
                local bigMirror = cakeMap and cakeMap:FindFirstChild("BigMirror")
                if not root then return end
                if _G.AcceptQuestC and questUI and not questUI.Visible then
                    local questPos = CFrame.new(-1927.92, 37.8, -12842.54)
                    _tp(questPos)
                    while (questPos.Position - root.Position).Magnitude > 50 do task.wait(0.2) end
                    local questData = {
                        {"StartQuest", "CakeQuest2", 2}, {"StartQuest", "CakeQuest2", 1},
                        {"StartQuest", "CakeQuest1", 1}, {"StartQuest", "CakeQuest1", 2}
                    }
                    pcall(function()
                        game.ReplicatedStorage.Remotes.CommF_:InvokeServer(unpack(questData[math.random(1, 4)]))
                    end)
                end
                if not cakeMap then _tp(CFrame.new(-2077, 252, -12373)); task.wait(2); return end
                if bigMirror and (bigMirror.Other.Transparency == 0 or enemies:FindFirstChild("Cake Prince")) then
                    local boss = GetConnectionEnemies("Cake Prince")
                    if boss then
                        repeat task.wait() Attack.Kill2(boss, _G.Auto_Cake_Prince) until not _G.Auto_Cake_Prince or not boss.Parent or boss.Humanoid.Health <= 0
                    else _tp(CFrame.new(-2151.82, 149.32, -12404.91)) end
                else
                    local CakeMobs = {"Cookie Crafter", "Cake Guard", "Baking Staff", "Head Baker"}
                    local mob = GetConnectionEnemies(CakeMobs)
                    if mob then
                        repeat task.wait() Attack.Kill(mob, _G.Auto_Cake_Prince) until not _G.Auto_Cake_Prince or not mob.Parent or mob.Humanoid.Health <= 0 or (bigMirror and bigMirror.Other.Transparency == 0)
                    else _tp(CFrame.new(-2077, 252, -12373)) end
                end
            end)
        end
    end
end)

CakeQ = Tabs.Main:AddToggle({
    Name = "Accept Quests",
    Description = "",
    Default = false,
    Callback = function(Value) _G.AcceptQuestC = Value end
})

CakeSM = Tabs.Main:AddToggle({
    Name = "Auto Summon Cake Prince",
    Description = "",
    Default = false,
    Callback = function(Value) _G.AutoSpawnCP = Value end
})
spawn(function()
    while task.wait(2) do
        if _G.AutoSpawnCP then
            pcall(function()
                local CommF = game.ReplicatedStorage.Remotes.CommF_
                local enemies = workspace.Enemies
                local bigMirror = workspace.Map.CakeLoaf:FindFirstChild("BigMirror")
                if not bigMirror then return end
                if enemies:FindFirstChild("Cake Prince") then return end
                if bigMirror.Other.Transparency == 0 then return end
                CommF:InvokeServer("CakePrinceSpawner", true)
            end)
        end
    end
end)

Tabs.Main:AddToggle({
    Name = "Auto Dough King [Fully]",
    Default = false,
    Callback = function(Value) _G.AutoDoughKing = Value end
})
spawn(function()
    while wait() do
        if _G.AutoDoughKing then
            pcall(function()
                if not workspace.Map.CakeLoaf:FindFirstChild("RedDoor") then
                    if GetBP("Red Key") then
                        replicated.Remotes.CommF_:InvokeServer("CakeScientist", "Check")
                        replicated.Remotes.CommF_:InvokeServer("RaidsNpc", "Check")
                    end
                elseif workspace.Map.CakeLoaf:FindFirstChild("RedDoor") then
                    if GetBP("Red Key") then
                        repeat task.wait()
                            _tp(CFrame.new(-2681.97998, 64.3921585, -12853.7363))
                        until not _G.AutoDoughKing or (plr.Character.HumanoidRootPart.CFrame - CFrame.new(-2681.97998, 64.3921585, -12853.7363)).Magnitude <= 5
                        EquipWeapon("Red Key")
                    end
                elseif GetConnectionEnemies("Dough King") then
                    local v = GetConnectionEnemies("Dough King")
                    if v then
                        repeat task.wait() Attack.Kill(v, _G.AutoDoughKing) until not _G.AutoDoughKing or not v.Parent or v.Humanoid.Health <= 0
                    else _tp(CFrame.new(-1943.676513671875, 251.5095672607422, -12337.880859375)) end
                end
                if GetBP("Sweet Chalice") then
                    replicated.Remotes.CommF_:InvokeServer("CakePrinceSpawner", true)
                    _G.AutoAttackDoughKing = true
                else _G.AutoAttackDoughKing = false end
                if GetBP("God's Chalice") and GetM("Conjured Cocoa") >= 10 then
                    replicated.Remotes.CommF_:InvokeServer("SweetChaliceNpc")
                end
                if not plr.Backpack:FindFirstChild("God's Chalice") or plr.Character:FindFirstChild("God's Chalice") then
                    _G.FarmEliteHunt = true
                else _G.FarmEliteHunt = false end
                if GetM("Conjured Cocoa") <= 10 then
                    local v = GetConnectionEnemies{"Cocoa Warrior", "Chocolate Bar Battler"}
                    if v then
                        repeat task.wait() Attack.Kill(v, _G.AutoDoughKing) until _G.AutoDoughKing == false or not v.Parent or v.Humanoid.Health <= 0
                    else _tp(CFrame.new(402.7189025878906, 81.06050109863281, -12259.54296875)) end
                end
            end)
        end
    end
end)

Tabs.Main:AddToggle({
    Name = "Auto Farm Dough King",
    Default = false,
    Callback = function(Value) _G.AutoAttackDoughKing = Value end
})
spawn(function()
    while wait() do
        if _G.AutoAttackDoughKing then
            pcall(function()
                local v = GetConnectionEnemies("Dough King")
                if v then
                    repeat task.wait() Attack.Kill(v, _G.AutoAttackDoughKing) until not _G.AutoAttackDoughKing or not v.Parent or v.Humanoid.Health <= 0
                else _tp(CFrame.new(-1943.6765, 251.5095, -12337.8809)) end
            end)
        end
    end
end)

Tabs.Main:AddToggle({
    Name = "Auto Farm Dough King + Hop",
    Default = false,
    Callback = function(Value) _G.AutoHop_Dough = Value end
})
local function HopServerDough()
    pcall(function()
        local Http = game:GetService("HttpService")
        local Servers = {}
        local req = game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")
        local data = Http:JSONDecode(req)
        for i, v in pairs(data.data) do
            if v.playing < v.maxPlayers then table.insert(Servers, v.id) end
        end
        if #Servers > 0 then
            game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, Servers[math.random(1, #Servers)], game.Players.LocalPlayer)
        end
    end)
end
spawn(function()
    while task.wait() do
        if _G.AutoHop_Dough then
            pcall(function()
                local v = GetConnectionEnemies("Dough King")
                if v then
                    repeat task.wait() Attack.Kill(v, _G.AutoHop_Dough) until not _G.AutoHop_Dough or not v.Parent or v.Humanoid.Health <= 0
                else
                    _tp(CFrame.new(-1943.6765, 251.5095, -12337.8809))
                    task.wait(2)
                    if not GetConnectionEnemies("Dough King") and _G.AutoHop_Dough then HopServerDough() end
                end
            end)
        end
    end
end)

-- ============================================================
-- FARMING BONE
-- ============================================================
Tabs.Main:AddSection("Farming Bone")

local CheckingBone = Tabs.Main:AddParagraph("Bones", "")
spawn(function()
    while wait(0.2) do
        pcall(function() CheckingBone:SetDesc("Bones : " .. GetM("Bones")) end)
    end
end)

Tabs.Main:AddToggle({
    Name = "Auto Farm Bone",
    Description = "",
    Default = false,
    Callback = function(Value) _G.AutoFarm_Bone = Value end
})
spawn(function()
    local player = game.Players.LocalPlayer
    local BonesTable = { "Reborn Skeleton", "Living Zombie", "Demonic Soul", "Possessed Mummy" }
    while wait(0.5) do
        if not _G.AutoFarm_Bone then continue end
        pcall(function()
            local char = player.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if not root then return end
            local questUI = player.PlayerGui:FindFirstChild("Main") and player.PlayerGui.Main:FindFirstChild("Quest")
            local bone = GetConnectionEnemies(BonesTable)
            if _G.AcceptQuestB and questUI and not questUI.Visible then
                local questPos = CFrame.new(-9516.99316, 172.01718, 6078.46533)
                _tp(questPos)
                repeat wait(2) until not _G.AutoFarm_Bone or (questPos.Position - root.Position).Magnitude <= 50
                if not _G.AutoFarm_Bone then return end
                local questData = {
                    {"StartQuest", "HauntedQuest2", 2}, {"StartQuest", "HauntedQuest2", 1},
                    {"StartQuest", "HauntedQuest1", 1}, {"StartQuest", "HauntedQuest1", 2}
                }
                game.ReplicatedStorage.Remotes.CommF_:InvokeServer(unpack(questData[math.random(1, #questData)]))
            end
            if bone then
                repeat wait() Attack.Kill(bone, true) until not _G.AutoFarm_Bone or not bone.Parent or bone.Humanoid.Health <= 0
            else
                _tp(CFrame.new(-9495.6806640625, 453.58624267578125, 5977.3486328125))
            end
        end)
    end
end)

BoneQ = Tabs.Main:AddToggle({
    Name = "Accept Quests",
    Description = "",
    Default = false,
    Callback = function(Value) _G.AcceptQuestB = Value end
})

Tabs.Main:AddToggle({
    Name = "Auto Soul Reaper",
    Description = "",
    Default = false,
    Callback = function(Value) _G.AutoHytHallow = Value end
})
spawn(function()
    while wait(Sec) do
        if _G.AutoHytHallow then
            pcall(function()
                local v = GetConnectionEnemies("Soul Reaper")
                if v then
                    repeat task.wait() Attack.Kill(v, _G.AutoHytHallow) until v.Humanoid.Health <= 0 or _G.AutoHytHallow == false
                else
                    if not GetBP("Hallow Essence") then
                        repeat task.wait(.1) replicated.Remotes.CommF_:InvokeServer("Bones", "Buy", 1, 1) until _G.AutoHytHallow == false or GetBP("Hallow Essence")
                    else
                        repeat wait(.1) _tp(CFrame.new(-8932.322265625, 146.83154296875, 6062.55078125)) until _G.AutoHytHallow == false or (plr.Character.HumanoidRootPart.CFrame == CFrame.new(-8932.322265625, 146.83154296875, 6062.55078125))
                        EquipWeapon("Hallow Essence")
                    end
                end
            end)
        end
    end
end)

RanBone = Tabs.Main:AddToggle({
    Name = "Auto Random Bones",
    Description = "",
    Default = false,
    Callback = function(Value) _G.Auto_Random_Bone = Value end
})
spawn(function()
    while wait(Sec) do
        pcall(function()
            if _G.Auto_Random_Bone then
                repeat task.wait() replicated.Remotes.CommF_:InvokeServer("Bones", "Buy", 1, 1) until not _G.Auto_Random_Bone
            end
        end)
    end
end)

Lucky = Tabs.Main:AddToggle({
    Name = "Auto Try Luck Gravestone",
    Description = "",
    Default = false,
    Callback = function(Value) _G.TryLucky = Value end
})
spawn(function()
    while wait(Sec) do
        if _G.TryLucky then
            local try_bones_luck = CFrame.new(-8761.3154296875, 164.85829162598, 6161.1567382813)
            if (plr.Character.HumanoidRootPart.CFrame ~= try_bones_luck) then
                _tp(CFrame.new(-8761.3154296875, 164.85829162598, 6161.1567382813))
            elseif (plr.Character.HumanoidRootPart.CFrame == try_bones_luck) then
                replicated.Remotes.CommF_:InvokeServer("gravestoneEvent", 1)
            end
        end
    end
end)

Pray = Tabs.Main:AddToggle({
    Name = "Auto Pray Gravestone",
    Description = "",
    Default = false,
    Callback = function(Value) _G.Praying = Value end
})
spawn(function()
    while wait(Sec) do
        if _G.Praying then
            local try_bones_luck = CFrame.new(-8761.3154296875, 164.85829162598, 6161.1567382813)
            if (plr.Character.HumanoidRootPart.CFrame ~= try_bones_luck) then
                _tp(CFrame.new(-8761.3154296875, 164.85829162598, 6161.1567382813))
            elseif (plr.Character.HumanoidRootPart.CFrame == try_bones_luck) then
                replicated.Remotes.CommF_:InvokeServer("gravestoneEvent", 2)
            end
        end
    end
end)

-- ============================================================
-- TYRANT OF THE SKIES
-- ============================================================
Tabs.Main:AddSection("Tyrant of the Skies")

local TyrantStatus = Tabs.Main:AddParagraph("Boss Spawn", "")
spawn(function()
    pcall(function()
        while wait(1) do
            if workspace.Enemies:FindFirstChild("Tyrant of the Skies") then TyrantStatus:SetDesc("✅")
            else TyrantStatus:SetDesc("❌") end
        end
    end)
end)

local EyeStatus = Tabs.Main:AddParagraph("Check Status Eyes", "")
function Check_Eye()
    local e = workspace.Map.TikiOutpost.IslandModel
    local eyes = { e.Eye1, e.Eye2, e.IslandChunks.E.Eye3, e.IslandChunks.E.Eye4 }
    local count = 0
    for _, eye in ipairs(eyes) do
        if eye and eye.Transparency ~= 1 then count = count + 1 end
    end
    return count, (count == 4)
end
task.spawn(function()
    while task.wait(1) do
        local current = Check_Eye()
        EyeStatus:SetDesc("Eyes: " .. current .. "/4")
    end
end)

FarmTyrant = Tabs.Main:AddToggle({
    Name = "Auto Farm Boss TOTS",
    Description = "",
    Default = false,
    Callback = function(Value) _G.FarmTyrant = Value end
})
spawn(function()
    while wait(Sec) do
        if _G.FarmTyrant then
            pcall(function()
                if not plr.Character then return end
                local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                if not hrp then return end
                local bossPos = Vector3.new(-16268.287, 152.616, 1390.773)
                if (hrp.Position - bossPos).Magnitude > 5 then
                    _tp(CFrame.new(bossPos))
                    repeat wait() until not _G.FarmTyrant or (plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and (plr.Character.HumanoidRootPart.Position - bossPos).Magnitude <= 5)
                end
                local boss = workspace.Enemies:FindFirstChild("Tyrant of the Skies")
                if boss and boss:FindFirstChild("Humanoid") and boss.Humanoid.Health > 0 then
                    repeat
                        if not _G.FarmTyrant then break end
                        Attack.Kill(boss, _G.FarmTyrant)
                        wait()
                    until not _G.FarmTyrant or not boss.Parent or boss.Humanoid.Health <= 0
                    return
                end
                local mobList = {"Serpent Hunter", "Skull Slayer", "Isle Champion", "Sun-kissed Warrior"}
                for _, mobName in ipairs(mobList) do
                    if not _G.FarmTyrant then break end
                    for _, mob in pairs(workspace.Enemies:GetChildren()) do
                        if not _G.FarmTyrant then break end
                        if mob and mob.Name == mobName and mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                            if (hrp.Position - mob.HumanoidRootPart.Position).Magnitude > 5000 then
                                _tp(mob.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                                local t0 = tick()
                                repeat wait() hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
                                until not _G.FarmTyrant or not hrp or (hrp.Position - mob.HumanoidRootPart.Position).Magnitude <= 6 or tick() - t0 > 8
                            end
                            repeat
                                if not _G.FarmTyrant then break end
                                Attack.Kill(mob, _G.FarmTyrant)
                                wait()
                            until not _G.FarmTyrant or not mob.Parent or mob.Humanoid.Health <= 0
                        end
                    end
                end
            end)
        end
    end
end)

-- ============================================================
-- AUTO SUMMON BOSS (PhaBinh)
-- ============================================================
FarmPhaBinh = Tabs.Main:AddToggle({
    Name = "Auto Summon Boss",
    Description = "",
    Default = false,
    Callback = function(Value) _G.FarmPhaBinh = Value end
})
local function sendSkillKey(skillKey)
    local virtualInputManager = game:GetService("VirtualInputManager")
    virtualInputManager:SendKeyEvent(true, skillKey, false, game)
    wait(0.05)
    virtualInputManager:SendKeyEvent(false, skillKey, false, game)
end
local function equipAndUseSkill(toolType)
    local character = plr.Character
    local backpack = plr.Backpack
    if not (character and character:FindFirstChild("Humanoid") and character.Humanoid.Health > 0) then return end
    for _, item in pairs(backpack:GetChildren()) do
        if item:IsA("Tool") and item.ToolTip == toolType then
            item.Parent = character
            wait(0.12)
            for _, skill in ipairs({"Z", "X", "C", "V", "F"}) do
                if not _G.FarmPhaBinh then break end
                pcall(function() sendSkillKey(skill) end)
                wait(0.12)
            end
            item.Parent = backpack
            break
        end
    end
end
local PhaBinhPoints = {
    CFrame.new(-16332.5263671875, 158.07200622558594, 1440.324951171875),
    CFrame.new(-16288.609375, 158.16700744628906, 1470.3680419921875),
    CFrame.new(-16245.412109375, 158.43699645996094, 1463.365966796875),
    CFrame.new(-16212.46875, 158.16700744628906, 1466.343994140625),
    CFrame.new(-16211.9462890625, 158.07200622558594, 1322.39794921875),
    CFrame.new(-16260.921875, 154.92100524902344, 1323.615966796875),
    CFrame.new(-16297.0595703125, 159.322998046875, 1317.2239990234375),
    CFrame.new(-16335.0966796875, 159.33399963378906, 1324.885986328125),
}
spawn(function()
    while wait(Sec) do
        if _G.FarmPhaBinh then
            pcall(function()
                if not (plr and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0) then return end
                for _, point in ipairs(PhaBinhPoints) do
                    if not _G.FarmPhaBinh then break end
                    _tp(point)
                    local arrived = false
                    local start = tick()
                    while tick() - start < 12 and not arrived and _G.FarmPhaBinh do
                        local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
                        if not hrp then break end
                        if (hrp.Position - point.Position).Magnitude <= 3 then arrived = true; break end
                        wait(0.1)
                    end
                    if _G.FarmPhaBinh and arrived then
                        equipAndUseSkill("Melee")
                        equipAndUseSkill("Sword")
                        equipAndUseSkill("Gun")
                    end
                end
            end)
        end
    end
end)

-- ============================================================
-- FARM MATERIAL
-- ============================================================
Tabs.Main:AddSection("Farm Material")

Test = Tabs.Main:AddDropdown({
    Name = "Choose Material",
    Description = "",
    Options = MaterialList,
    Callback = function(Value) getgenv().SelectMaterial = Value end
})

Toggle = Tabs.Main:AddToggle({
    Name = "Auto Farm Materials",
    Description = "",
    Default = false,
    Callback = function(Value) getgenv().AutoMaterial = Value end
})
spawn(function()
    local function processEnemy(v, EnemyName)
        if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
            if v.Name == EnemyName then
                repeat wait() Attack.Kill(v, getgenv().AutoMaterial) until not getgenv().AutoMaterial or not v.Parent or v.Humanoid.Health <= 0
            end
        end
    end
    local function handleEnemySpawns()
        for _, v in pairs(game:GetService("Workspace")["_WorldOrigin"].EnemySpawns:GetChildren()) do
            for _, EnemyName in ipairs(MMon) do
                if string.find(v.Name, EnemyName) then
                    if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.Position).Magnitude >= 10 then
                        _tp(v.CFrame * Pos)
                    end
                end
            end
        end
    end
    while wait() do
        if getgenv().AutoMaterial then
            pcall(function()
                if getgenv().SelectMaterial then
                    MaterialMon(getgenv().SelectMaterial)
                    _tp(MPos)
                end
                for _, EnemyName in ipairs(MMon) do
                    for _, v in pairs(workspace.Enemies:GetChildren()) do
                        processEnemy(v, EnemyName)
                    end
                end
                handleEnemySpawns()
            end)
        end
    end
end)

-- ============================================================
-- END PHẦN 3
-- ============================================================
-- ============================================================
-- FARM BOSS
-- ============================================================
Tabs.Main:AddSection("Farm Boss")

BossDropdown = Tabs.Main:AddDropdown({
    Name = "Select Boss",
    Description = "",
    Options = BossList,
    Callback = function(value) _G.FindBoss = value end
})

FarmBoss = Tabs.Main:AddToggle({
    Name = "Auto Farm Boss",
    Description = "",
    Default = false,
    Callback = function(value)
        _G.FarmBoss = value
        spawn(function()
            while wait(Sec) do
                if _G.FarmBoss then
                    pcall(function()
                        local HasQuest = QuestBeta()[2] ~= nil and QuestBeta()[3] ~= nil
                        local QuestTitle = plr.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text
                        if _G.AcceptQuestBoss and HasQuest then
                            if not string.find(QuestTitle, QuestBeta()[0]) then
                                replicated.Remotes.CommF_:InvokeServer("AbandonQuest")
                            end
                            if plr.PlayerGui.Main.Quest.Visible == false then
                                _tp(QuestBeta()[5])
                                if (Root.Position - QuestBeta()[5].Position).Magnitude <= 5 then
                                    replicated.Remotes.CommF_:InvokeServer("StartQuest", QuestBeta()[3], QuestBeta()[2])
                                end
                            elseif plr.PlayerGui.Main.Quest.Visible == true then
                                if workspace.Enemies:FindFirstChild(QuestBeta()[1]) then
                                    for i, v in pairs(workspace.Enemies:GetChildren()) do
                                        if Attack.Alive(v) and v.Name == QuestBeta()[1] then
                                            if string.find(QuestTitle, QuestBeta()[0]) then
                                                repeat wait() Attack.Kill(v, _G.FarmBoss) until not _G.FarmBoss or v.Humanoid.Health <= 0 or not v.Parent or plr.PlayerGui.Main.Quest.Visible == false
                                            else
                                                replicated.Remotes.CommF_:InvokeServer("AbandonQuest")
                                            end
                                        end
                                    end
                                else
                                    _tp(QuestBeta()[4])
                                    if replicated:FindFirstChild(QuestBeta()[1]) then
                                        _tp(replicated:FindFirstChild(QuestBeta()[1]).HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                                    end
                                end
                            end
                        else
                            if workspace.Enemies:FindFirstChild(QuestBeta()[1]) then
                                for i, v in pairs(workspace.Enemies:GetChildren()) do
                                    if Attack.Alive(v) and v.Name == QuestBeta()[1] then
                                        repeat wait() Attack.Kill(v, _G.FarmBoss) until not _G.FarmBoss or v.Humanoid.Health <= 0 or not v.Parent
                                    end
                                end
                            else
                                _tp(QuestBeta()[4])
                                if replicated:FindFirstChild(QuestBeta()[1]) then
                                    _tp(replicated:FindFirstChild(QuestBeta()[1]).HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                                end
                            end
                        end
                    end)
                end
            end
        end)
    end
})

BossQ = Tabs.Main:AddToggle({
    Name = "Accept Quests",
    Description = "",
    Default = true,
    Callback = function(Value) _G.AcceptQuestBoss = Value end
})

FarmAllBoss = Tabs.Main:AddToggle({
    Name = "Auto Farm All Boss",
    Default = false,
    Callback = function(Value) _G.AutoFarmAllBoss = Value end
})
task.spawn(function()
    while task.wait(0.3) do
        if _G.AutoFarmAllBoss then
            pcall(function()
                local player = game.Players.LocalPlayer
                if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
                local hrp = player.Character.HumanoidRootPart
                local nearestBoss, nearestDist = nil, math.huge
                for _, boss in pairs(workspace.Enemies:GetChildren()) do
                    if boss:FindFirstChild("HumanoidRootPart") and boss:FindFirstChild("Humanoid") and boss.Humanoid.Health > 0 then
                        if table.find(BossList, boss.Name) then
                            local dist = (hrp.Position - boss.HumanoidRootPart.Position).Magnitude
                            if dist < nearestDist then
                                nearestBoss = boss
                                nearestDist = dist
                            end
                        end
                    end
                end
                if nearestBoss and nearestBoss:FindFirstChild("HumanoidRootPart") then
                    local bossHRP = nearestBoss.HumanoidRootPart
                    local humanoid = nearestBoss.Humanoid
                    repeat
                        task.wait(0.1)
                        if not _G.AutoFarmAllBoss then break end
                        local targetCFrame = bossHRP.CFrame * CFrame.new(0, 5, 0)
                        if (hrp.Position - targetCFrame.Position).Magnitude > 100 then
                            player.Character:PivotTo(targetCFrame)
                        else
                            _tp(targetCFrame)
                        end
                        if Attack and typeof(Attack.Kill) == "function" then
                            Attack.Kill(nearestBoss, true)
                        end
                    until not nearestBoss.Parent or humanoid.Health <= 0 or not _G.AutoFarmAllBoss
                end
            end)
        end
    end
end)

-- ============================================================
-- FARMING MASTERY
-- ============================================================
Tabs.Main:AddSection("Farming Mastery")

local posMastery = {"Cake", "Bone"}
local Mastery_Config = Tabs.Main:AddDropdown({
    Name = "Choose Island",
    Description = "",
    Options = posMastery,
    Default = "Bone",
    Callback = function(Value) SelectIsland = Value end
})

local MasteryFruits = Tabs.Main:AddToggle({
    Name = "Auto Mastery Fruits",
    Description = "",
    Default = false,
    Callback = function(Value) _G.FarmMastery_Dev = Value end
})

spawn(function()
    RunSer.RenderStepped:Connect(function()
        pcall(function()
            if _G.FarmMastery_Dev or _G.FarmMastery_G or _G.FarmMastery_S then
                for a, b in pairs(plr.PlayerGui.Notifications:GetChildren()) do
                    if b.Name == "NotificationTemplate" then
                        if string.find(b.Text, "Skill locked!") then b:Destroy() end
                    end
                end
            end
        end)
    end)
end)

spawn(function()
    while wait(Sec) do
        if _G.FarmMastery_Dev then
            pcall(function()
                if SelectIsland == "Cake" then
                    local v = GetConnectionEnemies(mastery1)
                    if v then
                        HealthM = v.Humanoid.MaxHealth * 70 / 100
                        repeat wait() MousePos = v.HumanoidRootPart.Position; Attack.Mas(v, _G.FarmMastery_Dev)
                        until _G.FarmMastery_Dev == false or v.Humanoid.Health <= 0 or not v.Parent
                    else _tp(CFrame.new(-1943.676513671875, 251.5095672607422, -12337.880859375)) end
                elseif SelectIsland == "Bone" then
                    local v = GetConnectionEnemies(mastery2)
                    if v then
                        HealthM = v.Humanoid.MaxHealth * 70 / 100
                        repeat wait() MousePos = v.HumanoidRootPart.Position; Attack.Mas(v, _G.FarmMastery_Dev)
                        until _G.FarmMastery_Dev == false or v.Humanoid.Health <= 0 or not v.Parent
                    else _tp(CFrame.new(-9495.6806640625, 453.58624267578125, 5977.3486328125)) end
                end
            end)
        end
    end
end)

local MasteryGun = Tabs.Main:AddToggle({
    Name = "Auto Mastery Gun",
    Description = "",
    Default = false,
    Callback = function(Value) _G.FarmMastery_G = Value end
})
spawn(function()
    while wait(Sec) do
        if _G.FarmMastery_G then
            pcall(function()
                local targetTable = SelectIsland == "Cake" and mastery1 or mastery2
                local teleportPos = SelectIsland == "Cake" and CFrame.new(-1943.676513671875, 251.5095672607422, -12337.880859375) or CFrame.new(-9495.6806640625, 453.58624267578125, 5977.3486328125)
                local v = GetConnectionEnemies(targetTable)
                if v then
                    HealthM = v.Humanoid.MaxHealth * 70 / 100
                    repeat
                        wait()
                        MousePos = v.HumanoidRootPart.Position
                        Attack.Masgun(v, _G.FarmMastery_G)
                        local Modules = replicated:FindFirstChild("Modules")
                        local Net = Modules and Modules:FindFirstChild("Net")
                        local RE_ShootGunEvent = Net and Net:FindFirstChild("RE/ShootGunEvent")
                        local tool = plr.Character:FindFirstChildOfClass("Tool")
                        if not tool or tool.ToolTip ~= "Gun" then return end
                        if tool.Name == 'Skull Guitar' then
                            SoulGuitar = true
                            tool.RemoteEvent:FireServer("TAP", MousePos)
                        else
                            SoulGuitar = false
                            if RE_ShootGunEvent then RE_ShootGunEvent:FireServer(MousePos, {v.HumanoidRootPart}) end
                        end
                        if _G.FarmMastery_G then
                            vim1:SendMouseButtonEvent(0, 0, 0, true, game, 1); wait(0.05)
                            vim1:SendMouseButtonEvent(0, 0, 0, false, game, 1); wait(0.05)
                        end
                    until _G.FarmMastery_G == false or v.Humanoid.Health <= 0 or not v.Parent
                    SoulGuitar = false
                else _tp(teleportPos) end
            end)
        end
    end
end)

local MasterySword = Tabs.Main:AddToggle({
    Name = "Auto Mastery All Sword",
    Description = "",
    Default = false,
    Callback = function(Value) _G.FarmMastery_S = Value end
})
spawn(function()
    while wait(Sec) do
        pcall(function()
            if _G.FarmMastery_S then
                local targetTable = SelectIsland == "Cake" and mastery1 or mastery2
                local teleportPos = SelectIsland == "Cake" and CFrame.new(-1943.676513671875, 251.5095672607422, -12337.880859375) or CFrame.new(-9495.6806640625, 453.58624267578125, 5977.3486328125)
                for _, v in next, replicated.Remotes.CommF_:InvokeServer("getInventory") do
                    if type(v) == "table" and v.Type == "Sword" then
                        SwordName = v.Name
                        if tonumber(v.Mastery) >= 1 and tonumber(v.Mastery) <= 599 then
                            local target = GetConnectionEnemies(targetTable)
                            if GetBP(SwordName) then
                                if target then
                                    repeat wait() Attack.Sword(target, _G.FarmMastery_S) until _G.FarmMastery_S == false or not target.Parent or target.Humanoid.Health <= 0
                                else _tp(teleportPos) end
                            else replicated.Remotes.CommF_:InvokeServer("LoadItem", SwordName) end
                        elseif tonumber(v.Mastery) >= 600 then
                            if not GetBP(SwordName) then replicated.Remotes.CommF_:InvokeServer("LoadItem", SwordName) end
                        end
                        break
                    end
                end
            end
        end)
    end
end)

-- ============================================================
-- SETTINGS TAB
-- ============================================================
Tabs.Settings:AddSection("Settings / Configure")

Initialize = Tabs.Settings:AddToggle({
    Name = "Fast Attack",
    Description = "",
    Default = true,
    Callback = function(Value) _G.Seriality = Value end
})

Bringmob = Tabs.Settings:AddToggle({
    Name = "Bring Mobs",
    Description = "",
    Default = true,
    Callback = function(Value) _B = Value end
})

Tabs.Settings:AddToggle({
    Name = "Auto Hop Server with time",
    Default = false,
    Callback = function(Value)
        _G.AutoHopServer = Value
        if not Value then _G.HopTimer = nil end
    end
})

spawn(function()
    while wait(1) do
        if _G.AutoHopServer then
            pcall(function()
                if not _G.HopTimer then _G.HopTimer = tick() end
                if tick() - _G.HopTimer >= (_G.HopDelay or 1800) then
                    _G.HopTimer = tick()
                    if syn and syn.queue_on_teleport then
                        syn.queue_on_teleport("loadstring(game:HttpGet('https://pastefy.app/iiFOhcot/raw'))()")
                    end
                    game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
                end
            end)
        end
    end
end)

Tabs.Settings:AddSlider({
    Name = "Hop Delay (Minutes)",
    Min = 5, Max = 120, Default = 30, Rounding = 0,
    Callback = function(Value) _G.HopDelay = Value * 60 end
})

Tabs.Settings:AddToggle({
    Name = "Auto Set Spawn Point",
    Default = false,
    Callback = function(Value)
        getgenv().Set = Value
        if Value then pcall(function() game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetSpawnPoint") end) end
    end
})

BusuAura = Tabs.Settings:AddToggle({
    Name = "Auto Turn on Buso",
    Description = "",
    Default = true,
    Callback = function(Value) Boud = Value end
})
spawn(function()
    while wait(Sec) do
        pcall(function()
            if Boud and plr.Character then
                if not plr.Character:FindFirstChild("HasBuso") then
                    replicated.Remotes.CommF_:InvokeServer("Buso")
                end
            end
        end)
    end
end)

-- Auto ON
task.defer(function()
    task.wait(0.35)
    _G.Seriality = true
    _B = true
    Boud = true
    RandomCFrame = true
    _G.StopWhenChalice = true
    pcall(function()
        local vu = game:GetService("VirtualUser")
        game:GetService("Players").LocalPlayer.Idled:Connect(function()
            vu:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
            task.wait(1)
            vu:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
        end)
    end)
    pcall(function() if Initialize and Initialize.Set then Initialize:Set(true) end end)
    pcall(function() if Bringmob and Bringmob.Set then Bringmob:Set(true) end end)
    pcall(function() if BusuAura and BusuAura.Set then BusuAura:Set(true) end end)
    pcall(function() if RandomAround and RandomAround.Set then RandomAround:Set(true) end end)
    pcall(function() if StopI and StopI.Set then StopI:Set(true) end end)
    print("[Huy Pham Hub] Auto ON: Fast Attack / Bring / Buso / Spin XYZ / Stop Items / Anti AFK")
end)

Tabs.Settings:AddToggle({
    Name = "Auto Haki Observation",
    Default = false,
    Callback = function(Value) getgenv().Observation = Value end
})
spawn(function()
    while wait() do
        if getgenv().Observation then
            pcall(function() game:GetService("ReplicatedStorage").Remotes.CommE:FireServer("Ken", true) end)
        end
    end
end)

RaceV3Aura = Tabs.Settings:AddToggle({
    Name = "Auto Turn on Race V3",
    Description = "",
    Default = false,
    Flag = "AutoTurnonRaceV3",
    Callback = function(Value) _G.RaceClickAutov3 = Value end
})
spawn(function()
    while wait(.2) do
        pcall(function()
            if _G.RaceClickAutov3 then
                repeat replicated.Remotes.CommE:FireServer("ActivateAbility"); wait(30) until not _G.RaceClickAutov3
            end
        end)
    end
end)

RaceV4Aura = Tabs.Settings:AddToggle({
    Name = "Auto Turn on Race V4",
    Description = "",
    Default = false,
    Callback = function(Value) _G.RaceClickAutov4 = Value end
})
spawn(function()
    while wait(.2) do
        pcall(function()
            if _G.RaceClickAutov4 then
                if plr.Character:FindFirstChild("RaceEnergy") and plr.Character.RaceEnergy.Value == 1 then
                    Useskills("nil", "Y")
                end
            end
        end)
    end
end)

RandomAround = Tabs.Settings:AddToggle({
    Name = "Auto Turn on Spin xyz",
    Description = "",
    Default = true,
    Callback = function(Value) RandomCFrame = Value end
})

SafeModes = Tabs.Settings:AddToggle({
    Name = "Safe Mode",
    Description = "",
    Default = false,
    Callback = function(Value) _G.Safemode = Value end
})
spawn(function()
    while task.wait(Sec) do
        pcall(function()
            if _G.Safemode and plr.Character then
                local Calc_Health = plr.Character.Humanoid.Health / plr.Character.Humanoid.MaxHealth * 100
                if Calc_Health < Num_self then
                    shouldTween = true
                    _tp(Root.CFrame * CFrame.new(0, 500, 0))
                else shouldTween = false end
            end
        end)
    end
end)

DisableHitVFX = Tabs.Settings:AddToggle({
    Name = "Remove Hit VFX",
    Description = "Removes slash and sword visual effects",
    Default = false,
    Callback = function(Value) _G.DestroyHit = Value end
})
local HitEffects = {"SlashHit", "CurvedRing", "SwordSlash", "SlashTail"}
task.spawn(function()
    while task.wait(Sec) do
        if _G.DestroyHit then
            pcall(function()
                for _, v in pairs(workspace["_WorldOrigin"]:GetChildren()) do
                    if table.find(HitEffects, v.Name) then v:Destroy() end
                end
            end)
        end
    end
end)

RmvVFX = Tabs.Settings:AddToggle({
    Name = "Remove Death & Respawned VFX",
    Default = false,
    Callback = function(Value) RDeath = Value end
})
spawn(function()
    while wait(Sec) do
        pcall(function()
            if RDeath then
                if replicated.Effect.Container:FindFirstChild("Death") then replicated.Effect.Container.Death:Destroy() end
                if replicated.Effect.Container:FindFirstChild("Respawn") then replicated.Effect.Container.Respawn:Destroy() end
            end
        end)
    end
end)

DisblesNotify = Tabs.Settings:AddToggle({
    Name = "Disable Notify",
    Default = false,
    Callback = function(Value) RemoveDamage = Value end
})
spawn(function()
    while wait(Sec) do
        pcall(function()
            if RemoveDamage then
                replicated.Assets.GUI.DamageCounter.Enabled = false
                plr.PlayerGui.Notifications.Enabled = false
            else
                replicated.Assets.GUI.DamageCounter.Enabled = true
                plr.PlayerGui.Notifications.Enabled = true
            end
        end)
    end
end)

Tabs.Settings:AddToggle({
    Name = "Anti AFK",
    Default = true,
    Callback = function(Value)
        if Value then
            local vu = game:GetService("VirtualUser")
            repeat wait() until game:IsLoaded()
            game:GetService("Players").LocalPlayer.Idled:Connect(function()
                vu:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
                wait(1)
                vu:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
            end)
        end
    end
})

Tabs.Settings:AddToggle({
    Name = "Auto Anti - Admin Join Server",
    Default = true,
    Callback = function(Value) getgenv().HopServerAdmin = Value end
})
spawn(function()
    while wait() do
        pcall(function()
            if getgenv().HopServerAdmin then
                local blacklist = { "red_game43", "rip_indra", "Axiore", "Polkster", "wenlocktoad", "Daigrock", "toilamvidamme", "oofficialnoobie", "Uzoth", "Azarth", "arlthmetic", "Death_King", "Lunoven", "TheGreateAced", "rip_fud", "drip_mama", "layandikit12", "Hingoi" }
                for _, v in pairs(game.Players:GetPlayers()) do
                    if table.find(blacklist, v.Name) then Hop() end
                end
            end
        end)
    end
end)

Tabs.Settings:AddToggle({
    Name = "No Clip",
    Default = false,
    Callback = function(Value) getgenv().NoClip = Value end
})
spawn(function()
    pcall(function()
        game:GetService("RunService").Stepped:Connect(function()
            if getgenv().NoClip and plr.Character then
                for _, v in pairs(plr.Character:GetDescendants()) do
                    if v:IsA("BasePart") then v.CanCollide = false end
                end
            end
        end)
    end)
end)

-- ============================================================
-- STATS UPGRADE (thuộc Esp tab)
-- ============================================================
Tabs.Esp:AddSection("Stats Upgrade")

StatusSelect = Tabs.Esp:AddSlider({
    Name = "Stats Value",
    Description = "",
    Default = 10, Min = 0, Max = 1000, Rounding = 1,
    Callback = function(Value) pSats = Value end
})

Tabs.Esp:AddToggle({ Name = "Auto Melee", Default = false, Callback = function(Value) _G.Auto_Melee = Value end })
spawn(function() while wait(Sec) do pcall(function() if _G.Auto_Melee then statsSetings("Melee", pSats) end end) end end)
Tabs.Esp:AddToggle({ Name = "Auto Swords", Default = false, Callback = function(Value) _G.Auto_Sword = Value end })
spawn(function() while wait(Sec) do pcall(function() if _G.Auto_Sword then statsSetings("Sword", pSats) end end) end end)
Tabs.Esp:AddToggle({ Name = "Auto Gun", Default = false, Callback = function(Value) _G.Auto_Gun = Value end })
spawn(function() while wait(Sec) do pcall(function() if _G.Auto_Gun then statsSetings("Gun", pSats) end end) end end)
Tabs.Esp:AddToggle({ Name = "Auto Blox Fruit", Default = false, Callback = function(Value) _G.Auto_DevilFruit = Value end })
spawn(function() while wait(Sec) do pcall(function() if _G.Auto_DevilFruit then statsSetings("Devil", pSats) end end) end end)
Tabs.Esp:AddToggle({ Name = "Auto Defense", Default = false, Callback = function(Value) _G.Auto_Defense = Value end })
spawn(function() while wait(Sec) do pcall(function() if _G.Auto_Defense then statsSetings("Defense", pSats) end end) end end)

-- ============================================================
-- FISHING TAB
-- ============================================================
Tabs.Fish:AddSection("Fishing")

Tabs.Fish:AddDropdown({
    Name = "Select Fishing Rod",
    Options = {"Fishing Rod", "Gold Rod", "Shark Rod", "Shell Rod", "Treasure Rod"},
    Default = "Fishing Rod",
    Callback = function(Value) _G.SelectedRod = Value end
})

BaitDropdown = Tabs.Fish:AddDropdown({
    Name = "Select Bait",
    Options = {"Basic Bait", "Kelp Bait", "Good Bait", "Abyssal Bait", "Frozen Bait", "Epic Bait", "Carnivore Bait"},
    Default = "Basic Bait",
    Callback = function(Value)
        _G.SelectedBait = Value
        if _G.AutoBuyBait then pcall(function() Remotes.RFCraft:InvokeServer("Craft", _G.SelectedBait, {}) end) end
    end
})

BuyBaitToggle = Tabs.Fish:AddToggle({
    Name = "Auto Buy Bait",
    Default = false,
    Callback = function(Value)
        _G.AutoBuyBait = Value
        if Value then pcall(function() Remotes.RFCraft:InvokeServer("Craft", _G.SelectedBait, {}) end) end
    end
})
task.spawn(function()
    while task.wait(2) do
        if _G.AutoBuyBait and _G.SelectedBait then
            pcall(function() Remotes.RFCraft:InvokeServer("Craft", _G.SelectedBait, {}) end)
        end
    end
end)

FishingToggle = Tabs.Fish:AddToggle({
    Name = "Auto Fishing",
    Default = false,
    Callback = function(Value) _G.AutoFishing = Value end
})

local FishReplicated = replicated:WaitForChild("FishReplicated")
local FishingRequest = FishReplicated:WaitForChild("FishingRequest")
local Config = require(FishReplicated.FishingClient.Config)
local GetWaterHeight = require(replicated.Util.GetWaterHeightAtLocation)
local MaxDistance = Config.Rod.MaxLaunchDistance

task.spawn(function()
    while task.wait(0.5) do
        if _G.AutoFishing then
            pcall(function()
                local Char = plr.Character or plr.CharacterAdded:Wait()
                local HRP = Char:FindFirstChild("HumanoidRootPart")
                if not HRP then return end
                local Tool = Char:FindFirstChildOfClass("Tool")
                if _G.SelectedRod and (not Tool or Tool.Name ~= _G.SelectedRod) then
                    local backpackTool = plr.Backpack:FindFirstChild(_G.SelectedRod)
                    if backpackTool then
                        Char.Humanoid:EquipTool(backpackTool)
                        Tool = backpackTool
                    end
                end
                if Tool then
                    local waterHeight = GetWaterHeight(HRP.Position)
                    local _, hitPos = workspace:FindPartOnRayWithIgnoreList(
                        Ray.new(Char.Head.Position, HRP.CFrame.LookVector * MaxDistance),
                        {Char, workspace.Characters, workspace.Enemies}
                    )
                    local TargetPos = hitPos and Vector3.new(hitPos.X, math.max(hitPos.Y, waterHeight), hitPos.Z)
                    local State = Tool:GetAttribute("State")
                    local ServerState = Tool:GetAttribute("ServerState")
                    if TargetPos and (State == "ReeledIn" or ServerState == "ReeledIn") then
                        FishingRequest:InvokeServer("StartCasting")
                        task.wait()
                        FishingRequest:InvokeServer("CastLineAtLocation", TargetPos, 100, true)
                    elseif ServerState == "Biting" then
                        FishingRequest:InvokeServer("Catching", true)
                        task.wait(0.1)
                        FishingRequest:InvokeServer("Catch", 1)
                    end
                end
            end)
        end
    end
end)

FishingQ = Tabs.Fish:AddToggle({
    Name = "Auto Quest Fishing",
    Default = false,
    Callback = function(Value) _G.AutoFishingQuest = Value end
})
task.spawn(function()
    while task.wait(1) do
        if _G.AutoFishingQuest then
            pcall(function()
                local questGui = plr.PlayerGui:FindFirstChild("Quest") or plr.PlayerGui:FindFirstChild("QuestGui")
                local hasQuest = questGui and questGui:FindFirstChild("Container") and questGui.Container:FindFirstChild("QuestTitle")
                if not hasQuest and Remotes.RFJobsRemoteFunction then
                    Remotes.RFJobsRemoteFunction:InvokeServer("FishingNPC", "Angler", "AskQuest")
                end
            end)
        end
    end
end)

QuestToggle = Tabs.Fish:AddToggle({
    Name = "Auto Complete Quest",
    Default = false,
    Callback = function(Value)
        _G.AutoQuestComplete = Value
        if Value then pcall(function() Remotes.RFJobsRemoteFunction:InvokeServer("FishingNPC", "FinishQuest") end) end
    end
})
task.spawn(function()
    while task.wait(5) do
        if _G.AutoQuestComplete then pcall(function() Remotes.RFJobsRemoteFunction:InvokeServer("FishingNPC", "FinishQuest") end) end
    end
end)

SellFishToggle = Tabs.Fish:AddToggle({
    Name = "Auto Sell Fish",
    Default = false,
    Callback = function(Value)
        _G.AutoSellFish = Value
        if Value then pcall(function() Remotes.RFJobsRemoteFunction:InvokeServer("FishingNPC", "SellFish") end) end
    end
})
task.spawn(function()
    while task.wait(5) do
        if _G.AutoSellFish then pcall(function() Remotes.RFJobsRemoteFunction:InvokeServer("FishingNPC", "SellFish") end) end
    end
end)

SpamSkillZ = Tabs.Fish:AddToggle({
    Name = "Auto Spam Skill Z",
    Default = false,
    Callback = function(Value) _G.AutoSkillZ = Value end
})
task.spawn(function()
    while task.wait(0.5) do
        if _G.AutoSkillZ and Remotes.RFCraft then
            pcall(function()
                local RFJobToolAbilities = replicated.Modules.Net:WaitForChild("RF/JobToolAbilities")
                RFJobToolAbilities:InvokeServer("Z", true)
            end)
        end
    end
end)

-- ============================================================
-- ESP SECTION
-- ============================================================
Tabs.Esp:AddSection("Esp")

function isnil(thing) return (thing == nil) end
local function round(n) return math.floor(tonumber(n) + 0.5) end
Number = math.random(1, 1000000)

EspPly = function()
    for _, v in next, game.Players:GetChildren() do
        pcall(function()
            if not isnil(v.Character) and PlayerEsp then
                if not isnil(v.Character.Head) and not v.Character.Head:FindFirstChild('NameEsp' .. Number) then
                    local bill = Instance.new('BillboardGui', v.Character.Head)
                    bill.Name = 'NameEsp' .. Number
                    bill.ExtentsOffset = Vector3.new(0, 1, 0)
                    bill.Size = UDim2.new(1, 200, 1, 30)
                    bill.Adornee = v.Character.Head
                    bill.AlwaysOnTop = true
                    local name = Instance.new('TextLabel', bill)
                    name.Font = Enum.Font.Code
                    name.FontSize = "Size14"
                    name.TextWrapped = true
                    name.Text = (v.Name .. ' \n' .. round((plr.Character.Head.Position - v.Character.Head.Position).Magnitude / 3) .. ' M')
                    name.Size = UDim2.new(1, 0, 1, 0)
                    name.TextYAlignment = 'Top'
                    name.BackgroundTransparency = 1
                    name.TextStrokeTransparency = 0.5
                    name.TextColor3 = v.Team == TeamSelf and Color3.new(0, 0, 254) or Color3.new(255, 0, 0)
                elseif v.Character.Head:FindFirstChild('NameEsp' .. Number) then
                    v.Character.Head['NameEsp' .. Number].TextLabel.Text = (v.Name .. ' | ' .. round((plr.Character.Head.Position - v.Character.Head.Position).Magnitude / 3) .. ' M\nHealth : ' .. round(v.Character.Humanoid.Health * 100 / v.Character.Humanoid.MaxHealth) .. '%')
                end
            elseif v.Character and v.Character:FindFirstChild("Head") and v.Character.Head:FindFirstChild('NameEsp' .. Number) then
                v.Character.Head:FindFirstChild('NameEsp' .. Number):Destroy()
            end
        end)
    end
end

LocationEsp = function()
    for _, v in next, workspace["_WorldOrigin"].Locations:GetChildren() do
        pcall(function()
            if IslandESP and v.Name ~= "Sea" then
                if not v:FindFirstChild('NameEsp') then
                    local bill = Instance.new('BillboardGui', v)
                    bill.Name = 'NameEsp'
                    bill.ExtentsOffset = Vector3.new(0, 1, 0)
                    bill.Size = UDim2.new(1, 200, 1, 30)
                    bill.Adornee = v
                    bill.AlwaysOnTop = true
                    local name = Instance.new('TextLabel', bill)
                    name.Font = Enum.Font.Code
                    name.FontSize = "Size14"
                    name.TextWrapped = true
                    name.Size = UDim2.new(1, 0, 1, 0)
                    name.TextYAlignment = 'Top'
                    name.BackgroundTransparency = 1
                    name.TextStrokeTransparency = 0.5
                    name.TextColor3 = Color3.fromRGB(98, 252, 252)
                    name.Text = (v.Name .. ' \n' .. round((plr.Character.Head.Position - v.Position).Magnitude / 3) .. ' M')
                else
                    v['NameEsp'].TextLabel.Text = (v.Name .. ' \n' .. round((plr.Character.Head.Position - v.Position).Magnitude / 3) .. ' M')
                end
            elseif v:FindFirstChild('NameEsp') then
                v:FindFirstChild('NameEsp'):Destroy()
            end
        end)
    end
end

DevEsp = function()
    for i, v in next, workspace:GetChildren() do
        pcall(function()
            if DevilFruitESP then
                if string.find(v.Name, "Fruit") then
                    if not v.Handle:FindFirstChild('NameEsp' .. Number) then
                        local bill = Instance.new('BillboardGui', v.Handle)
                        bill.Name = 'NameEsp' .. Number
                        bill.ExtentsOffset = Vector3.new(0, 1, 0)
                        bill.Size = UDim2.new(1, 200, 1, 30)
                        bill.Adornee = v.Handle
                        bill.AlwaysOnTop = true
                        local name = Instance.new('TextLabel', bill)
                        name.Font = Enum.Font.Code
                        name.FontSize = "Size14"
                        name.TextWrapped = true
                        name.Size = UDim2.new(1, 0, 1, 0)
                        name.TextYAlignment = 'Top'
                        name.BackgroundTransparency = 1
                        name.TextStrokeTransparency = 0.5
                        name.TextColor3 = Color3.fromRGB(255, 255, 255)
                        name.Text = (v.Name .. ' \n' .. round((plr.Character.Head.Position - v.Handle.Position).Magnitude / 3) .. ' M')
                    else
                        v.Handle['NameEsp' .. Number].TextLabel.Text = ('[' .. v.Name .. ']' .. ' \n' .. round((plr.Character.Head.Position - v.Handle.Position).Magnitude / 3) .. ' M')
                    end
                elseif v:FindFirstChild('Handle') and v.Handle:FindFirstChild('NameEsp' .. Number) then
                    v.Handle:FindFirstChild('NameEsp' .. Number):Destroy()
                end
            end
        end)
    end
end

flowerEsp = function()
    for _, v in pairs(workspace:GetChildren()) do
        pcall(function()
            if (v.Name == "Flower2" or v.Name == "Flower1") and FlowerESP then
                if not v:FindFirstChild('NameEsp' .. Number) then
                    local bill = Instance.new('BillboardGui', v)
                    bill.Name = 'NameEsp' .. Number
                    bill.ExtentsOffset = Vector3.new(0, 1, 0)
                    bill.Size = UDim2.new(1, 200, 1, 30)
                    bill.Adornee = v
                    bill.AlwaysOnTop = true
                    local name = Instance.new('TextLabel', bill)
                    name.Font = Enum.Font.Code
                    name.FontSize = "Size14"
                    name.TextWrapped = true
                    name.Size = UDim2.new(1, 0, 1, 0)
                    name.TextYAlignment = 'Top'
                    name.BackgroundTransparency = 1
                    name.TextStrokeTransparency = 0.5
                    name.TextColor3 = Color3.fromRGB(88, 214, 252)
                    name.Text = (v.Name == "Flower1" and "Blue Flower" or "Red Flower") .. ' \n' .. round((plr.Character.Head.Position - v.Position).Magnitude / 3) .. ' M'
                end
            elseif v:FindFirstChild('NameEsp' .. Number) then
                v:FindFirstChild('NameEsp' .. Number):Destroy()
            end
        end)
    end
end

EventIslandEsp = function()
    for _, v in pairs(workspace._WorldOrigin.Locations:GetChildren()) do
        pcall(function()
            if EspEventIsland and (v.Name == "Mirage Island" or v.Name == "Prehistoric Island" or v.Name == "Kitsune Island") then
                if not v:FindFirstChild("NameEsp") then
                    local bill = Instance.new("BillboardGui", v)
                    bill.Name = "NameEsp"
                    bill.ExtentsOffset = Vector3.new(0, 1, 0)
                    bill.Size = UDim2.new(1, 200, 1, 30)
                    bill.Adornee = v
                    bill.AlwaysOnTop = true
                    local name = Instance.new("TextLabel", bill)
                    name.Font = "Code"
                    name.FontSize = "Size14"
                    name.TextWrapped = true
                    name.Size = UDim2.new(1, 0, 1, 0)
                    name.TextYAlignment = "Top"
                    name.BackgroundTransparency = 1
                    name.TextStrokeTransparency = 0.5
                    name.TextColor3 = Color3.fromRGB(80, 245, 245)
                    name.Text = (v.Name .. " \n" .. round((plr.Character.Head.Position - v.Position).Magnitude / 3) .. " M")
                else
                    v.NameEsp.TextLabel.Text = v.Name .. " \n" .. round((plr.Character.Head.Position - v.Position).Magnitude / 3) .. " M"
                end
            elseif v:FindFirstChild("NameEsp") then
                v:FindFirstChild("NameEsp"):Destroy()
            end
        end)
    end
end

gearEsp = function()
    for _, v in pairs(workspace.Map.MysticIsland:GetDescendants()) do
        pcall(function()
            if ESPGear and v.Name == "Part" and v.Material == Enum.Material.Neon then
                if not v:FindFirstChild("NameEsp") then
                    local bill = Instance.new("BillboardGui", v)
                    bill.Name = "NameEsp"
                    bill.ExtentsOffset = Vector3.new(0, 1, 0)
                    bill.Size = UDim2.new(1, 200, 1, 30)
                    bill.Adornee = v
                    bill.AlwaysOnTop = true
                    local name = Instance.new("TextLabel", bill)
                    name.Font = "Code"
                    name.FontSize = "Size14"
                    name.TextWrapped = true
                    name.Size = UDim2.new(1, 0, 1, 0)
                    name.TextYAlignment = "Top"
                    name.BackgroundTransparency = 1
                    name.TextStrokeTransparency = 0.5
                    name.TextColor3 = Color3.fromRGB(80, 245, 245)
                    name.Text = "Gear \n" .. round((plr.Character.Head.Position - v.Position).Magnitude / 3) .. " M"
                end
            elseif v:FindFirstChild("NameEsp") then
                v:FindFirstChild("NameEsp"):Destroy()
            end
        end)
    end
end

AdvanFruitEsp = function()
    if advanEsp then
        for _, v in pairs(replicated.NPCs:GetChildren()) do
            if v.Name == "Advanced Fruit Dealer" then
                if not workspace:FindFirstChild("Adv") then
                    Adv = Instance.new("Part")
                    Adv.Name = "Adv"
                    Adv.Transparency = 1
                    Adv.Size = Vector3.new(1, 1, 1)
                    Adv.Anchored = true
                    Adv.CanCollide = false
                    Adv.Parent = workspace
                    Adv.CFrame = v.HumanoidRootPart.CFrame
                elseif not Adv:FindFirstChild("NameEsp") then
                    local bill = Instance.new("BillboardGui", Adv)
                    bill.Name = "NameEsp"
                    bill.ExtentsOffset = Vector3.new(0, 1, 0)
                    bill.Size = UDim2.new(1, 200, 1, 30)
                    bill.Adornee = Adv
                    bill.AlwaysOnTop = true
                    local name = Instance.new("TextLabel", bill)
                    name.Font = "Code"
                    name.FontSize = "Size14"
                    name.TextWrapped = true
                    name.Size = UDim2.new(1, 0, 1, 0)
                    name.TextYAlignment = "Top"
                    name.BackgroundTransparency = 1
                    name.TextStrokeTransparency = 0.5
                    name.TextColor3 = Color3.fromRGB(80, 245, 245)
                    name.Text = (v.Name .. " \n" .. round((plr.Character.Head.Position - v.HumanoidRootPart.Position).Magnitude / 3) .. " M")
                end
            end
        end
    elseif workspace:FindFirstChild("Adv") then
        workspace:FindFirstChild("Adv"):Destroy()
    end
end

HakiClorEsp = function()
    if ColorEsp then
        for _, v in pairs(replicated.NPCs:GetChildren()) do
            if v.Name == "Barista Cousin" then
                if not workspace:FindFirstChild("Gay") then
                    Gay = Instance.new("Part")
                    Gay.Name = "Gay"
                    Gay.Transparency = 1
                    Gay.Size = Vector3.new(1, 1, 1)
                    Gay.Anchored = true
                    Gay.CanCollide = false
                    Gay.Parent = workspace
                    Gay.CFrame = v.HumanoidRootPart.CFrame
                end
            end
        end
    elseif workspace:FindFirstChild("Gay") then
        workspace:FindFirstChild("Gay"):Destroy()
    end
end

LegenSword = function()
    if LegenS then
        for _, v in pairs(replicated.NPCs:GetChildren()) do
            if v.Name == "Legendary Sword Dealer" then
                if not workspace:FindFirstChild("Lgd") then
                    Lgd = Instance.new("Part")
                    Lgd.Name = "Lgd"
                    Lgd.Transparency = 1
                    Lgd.Size = Vector3.new(1, 1, 1)
                    Lgd.Anchored = true
                    Lgd.CanCollide = false
                    Lgd.Parent = workspace
                    Lgd.CFrame = v.HumanoidRootPart.CFrame
                end
            end
        end
    elseif workspace:FindFirstChild("Lgd") then
        workspace:FindFirstChild("Lgd"):Destroy()
    end
end

ChestEsp = function()
    if ChestESP then
        local CollectionService = game:GetService("CollectionService")
        for _, Chest in ipairs(CollectionService:GetTagged("_ChestTagged")) do
            pcall(function()
                local existingEsp = Chest:FindFirstChild("ChestEspAttachment")
                if not existingEsp then
                    local attachment = Instance.new("Attachment")
                    attachment.Name = "ChestEspAttachment"
                    attachment.Parent = Chest
                    attachment.Position = Vector3.new(0, 3, 0)
                    local nameEsp = Instance.new("BillboardGui")
                    nameEsp.Name = "NameEsp"
                    nameEsp.Size = UDim2.new(0, 200, 0, 30)
                    nameEsp.Adornee = attachment
                    nameEsp.ExtentsOffset = Vector3.new(0, 1, 0)
                    nameEsp.AlwaysOnTop = true
                    nameEsp.Parent = attachment
                    local nameLabel = Instance.new("TextLabel")
                    nameLabel.Font = Enum.Font.Code
                    nameLabel.TextSize = 14
                    nameLabel.TextWrapped = true
                    nameLabel.Size = UDim2.new(1, 0, 1, 0)
                    nameLabel.TextYAlignment = Enum.TextYAlignment.Top
                    nameLabel.BackgroundTransparency = 1
                    nameLabel.TextStrokeTransparency = 0.5
                    nameLabel.TextColor3 = Color3.fromRGB(80, 245, 245)
                    nameLabel.Parent = nameEsp
                end
                local nameEsp = existingEsp and existingEsp:FindFirstChild("NameEsp")
                if nameEsp then
                    local dist = (Chest:GetPivot().Position - plr.Character.Head.Position).Magnitude
                    nameEsp.TextLabel.Text = string.format("[%s] %d M", Chest.Name:gsub("Label", ""), math.floor(dist / 3))
                end
            end)
        end
    else
        for _, Chest in ipairs(game:GetService("CollectionService"):GetTagged("_ChestTagged")) do
            local espAttachment = Chest:FindFirstChild("ChestEspAttachment")
            if espAttachment then espAttachment:Destroy() end
        end
    end
end

berriesEsp = function()
    if BerryEsp then
        local CollectionService = game:GetService("CollectionService")
        for _, Bush in ipairs(CollectionService:GetTagged("BerryBush")) do
            pcall(function()
                local bushPosition = Bush.Parent:GetPivot().Position
                for _, BerryName in pairs(Bush:GetAttributes()) do
                    if BerryName then
                        local espPartName = "BerryEspPart_" .. BerryName .. "_" .. tostring(bushPosition)
                        local existingEsp = workspace:FindFirstChild(espPartName)
                        if not existingEsp then
                            existingEsp = Instance.new("Part")
                            existingEsp.Name = espPartName
                            existingEsp.Transparency = 1
                            existingEsp.Size = Vector3.new(1, 1, 1)
                            existingEsp.Anchored = true
                            existingEsp.CanCollide = false
                            existingEsp.Parent = workspace
                            existingEsp.CFrame = CFrame.new(bushPosition)
                        end
                        if not existingEsp:FindFirstChild("NameEsp") then
                            local nameEsp = Instance.new("BillboardGui", existingEsp)
                            nameEsp.Name = "NameEsp"
                            nameEsp.ExtentsOffset = Vector3.new(0, 1, 0)
                            nameEsp.Size = UDim2.new(0, 200, 0, 30)
                            nameEsp.Adornee = existingEsp
                            nameEsp.AlwaysOnTop = true
                            local nameLabel = Instance.new("TextLabel", nameEsp)
                            nameLabel.Font = Enum.Font.Code
                            nameLabel.TextSize = 14
                            nameLabel.TextWrapped = true
                            nameLabel.Size = UDim2.new(1, 0, 1, 0)
                            nameLabel.TextYAlignment = Enum.TextYAlignment.Top
                            nameLabel.BackgroundTransparency = 1
                            nameLabel.TextStrokeTransparency = 0.5
                            nameLabel.TextColor3 = Color3.fromRGB(80, 245, 245)
                        end
                        local nameEsp = existingEsp:FindFirstChild("NameEsp")
                        local distance = (plr.Character.Head.Position - bushPosition).Magnitude / 3
                        if nameEsp then nameEsp.TextLabel.Text = ('[' .. BerryName .. ']' .. " " .. math.round(distance) .. " M") end
                    end
                end
            end)
        end
    else
        for _, v in ipairs(workspace:GetChildren()) do
            if v:IsA("Part") and v.Name:match("BerryEspPart_.*") then v:Destroy() end
        end
    end
end

-- ESP toggles
Tabs.Esp:AddToggle({
    Name = "Esp Berry", Default = false,
    Callback = function(Value)
        BerryEsp = Value
        if not Value then
            for _, v in ipairs(workspace:GetChildren()) do
                if v:IsA("Part") and v.Name:match("BerryEspPart_.*") then v:Destroy() end
            end
        else task.spawn(function() while BerryEsp do berriesEsp(); task.wait() end end) end
    end
})

Tabs.Esp:AddToggle({
    Name = "Esp Player", Default = false,
    Callback = function(Value)
        PlayerEsp = Value
        if not Value then
            for _, v in next, game.Players:GetChildren() do
                pcall(function()
                    if not isnil(v.Character) and not isnil(v.Character.Head) and v.Character.Head:FindFirstChild('NameEsp' .. Number) then
                        v.Character.Head:FindFirstChild('NameEsp' .. Number):Destroy()
                    end
                end)
            end
        else task.spawn(function() while PlayerEsp do EspPly(); task.wait() end end) end
    end
})

Tabs.Esp:AddToggle({
    Name = "Esp Chest", Default = false,
    Callback = function(Value)
        ChestESP = Value
        if not Value then
            for _, Chest in ipairs(game:GetService("CollectionService"):GetTagged("_ChestTagged")) do
                local espAttachment = Chest:FindFirstChild("ChestEspAttachment")
                if espAttachment then espAttachment:Destroy() end
            end
        else task.spawn(function() while ChestESP do ChestEsp(); task.wait() end end) end
    end
})

Tabs.Esp:AddToggle({
    Name = "Esp Fruit", Default = false,
    Callback = function(Value)
        DevilFruitESP = Value
        if not Value then
            for i, v in next, workspace:GetChildren() do
                pcall(function()
                    if v:FindFirstChild('Handle') and v.Handle:FindFirstChild('NameEsp' .. Number) then
                        v.Handle:FindFirstChild('NameEsp' .. Number):Destroy()
                    end
                end)
            end
        else task.spawn(function() while DevilFruitESP do DevEsp(); task.wait() end end) end
    end
})

Tabs.Esp:AddToggle({
    Name = "Esp Island", Default = false,
    Callback = function(Value)
        IslandESP = Value
        if not Value then
            for _, v in next, workspace["_WorldOrigin"].Locations:GetChildren() do
                pcall(function()
                    if v:FindFirstChild('NameEsp') then v:FindFirstChild('NameEsp'):Destroy() end
                end)
            end
        else task.spawn(function() while IslandESP do LocationEsp(); task.wait() end end) end
    end
})

Tabs.Esp:AddToggle({
    Name = "Esp Flower", Default = false,
    Callback = function(Value)
        FlowerESP = Value
        if not Value then
            for _, v in pairs(workspace:GetChildren()) do
                pcall(function()
                    if (v.Name == "Flower2" or v.Name == "Flower1") and v:FindFirstChild('NameEsp' .. Number) then
                        v:FindFirstChild('NameEsp' .. Number):Destroy()
                    end
                end)
            end
        else task.spawn(function() while FlowerESP do flowerEsp(); task.wait() end end) end
    end
})

Tabs.Esp:AddToggle({
    Name = "Esp Legendary Sword", Default = false,
    Callback = function(Value)
        LegenS = Value
        if not Value then
            if workspace:FindFirstChild("Lgd") then workspace:FindFirstChild("Lgd"):Destroy() end
        else task.spawn(function() while LegenS do LegenSword(); task.wait() end end) end
    end
})

Tabs.Esp:AddToggle({
    Name = "Esp Haki Color", Default = false,
    Callback = function(Value)
        ColorEsp = Value
        if not Value then
            if workspace:FindFirstChild("Gay") then workspace:FindFirstChild("Gay"):Destroy() end
        else task.spawn(function() while ColorEsp do HakiClorEsp(); task.wait() end end) end
    end
})

Tabs.Esp:AddToggle({
    Name = "Esp Gear", Default = false,
    Callback = function(Value)
        ESPGear = Value
        if not Value then
            for _, v in pairs(workspace.Map.MysticIsland:GetDescendants()) do
                pcall(function()
                    if v:FindFirstChild("NameEsp") then v:FindFirstChild("NameEsp"):Destroy() end
                end)
            end
        else task.spawn(function() while ESPGear do gearEsp(); task.wait() end end) end
    end
})

Tabs.Esp:AddToggle({
    Name = "Esp SeaEvent Island", Default = false,
    Callback = function(Value)
        EspEventIsland = Value
        if not Value then
            for _, v in pairs(workspace._WorldOrigin.Locations:GetChildren()) do
                pcall(function()
                    if v:FindFirstChild("NameEsp") then v:FindFirstChild("NameEsp"):Destroy() end
                end)
            end
        else task.spawn(function() while EspEventIsland do EventIslandEsp(); task.wait() end end) end
    end
})

Tabs.Esp:AddToggle({
    Name = "Esp Advanced Dealer", Default = false,
    Callback = function(Value)
        advanEsp = Value
        if not Value then
            if workspace:FindFirstChild("Adv") then workspace:FindFirstChild("Adv"):Destroy() end
        else task.spawn(function() while advanEsp do AdvanFruitEsp(); task.wait() end end) end
    end
})

-- ============================================================
-- END PHẦN 4
-- ============================================================
-- ============================================================
-- QUESTS TAB - TRAVEL WORLDS
-- ============================================================
TravelDress = Tabs.Quests:AddToggle({
    Name = "Auto Quest Sea 2",
    Description = "",
    Default = false,
    Callback = function(Value) _G.TravelDres = Value end
})
spawn(function()
    while wait(Sec) do
        pcall(function()
            if _G.TravelDres then
                if plr.Data.Level.Value >= 700 then
                    if workspace.Map.Ice.Door.CanCollide == true and workspace.Map.Ice.Door.Transparency == 0 then
                        replicated.Remotes.CommF_:InvokeServer("DressrosaQuestProgress", "Detective")
                        EquipWeapon("Key")
                        repeat wait() _tp(CFrame.new(1347.7124, 37.3751602, -1325.6488)) until not _G.TravelDres or (Root.Position == CFrame.new(1347.7124, 37.3751602, -1325.6488).Position)
                    elseif workspace.Map.Ice.Door.CanCollide == false and workspace.Map.Ice.Door.Transparency == 1 then
                        if Enemies:FindFirstChild("Ice Admiral") then
                            for _, xz in pairs(Enemies:GetChildren()) do
                                if xz.Name == "Ice Admiral" and Attack.Alive(xz) then
                                    repeat task.wait() Attack.Kill(xz, _G.TravelDres) until _G.TravelDres == false or xz.Humanoid.Health <= 0
                                    replicated.Remotes.CommF_:InvokeServer("TravelDressrosa")
                                end
                            end
                        else _tp(CFrame.new(1347.7124, 37.3751602, -1325.6488)) end
                    else
                        replicated.Remotes.CommF_:InvokeServer("TravelDressrosa")
                    end
                end
            end
        end)
    end
end)

Zou = Tabs.Quests:AddToggle({
    Name = "Auto Quest Sea 3",
    Description = "",
    Default = false,
    Callback = function(Value) _G.AutoZou = Value end
})
spawn(function()
    while wait(Sec) do
        pcall(function()
            if _G.AutoZou then
                if plr.Data.Level.Value >= 1500 then
                    if replicated.Remotes.CommF_:InvokeServer("BartiloQuestProgress", "Bartilo") == 3 then
                        if replicated.Remotes.CommF_:InvokeServer("GetUnlockables").FlamingoAccess ~= nil then
                            replicated.Remotes.CommF_:InvokeServer("F_", "TravelZou")
                            if replicated.Remotes.CommF_:InvokeServer("ZQuestProgress", "Check") == 0 then
                                local v = GetConnectionEnemies("rip_indra")
                                if v then
                                    repeat wait() Attack.Kill(v, _G.AutoZou) until not _G.AutoZou or not v.Parent or v.Humanoid.Health <= 0
                                    Check = 2
                                    repeat wait() replicated.Remotes.CommF_:InvokeServer("F_", "TravelZou") until Check == 1
                                else
                                    replicated.Remotes.CommF_:InvokeServer("F_", "ZQuestProgress", "Check")
                                    wait(.1)
                                    replicated.Remotes.CommF_:InvokeServer("F_", "ZQuestProgress", "Begin")
                                end
                            elseif replicated.Remotes["CommF_"]:InvokeServer("ZQuestProgress", "Check") == 1 then
                                replicated.Remotes.CommF_:InvokeServer("F_", "TravelZou")
                            else
                                local v = GetConnectionEnemies("Don Swan")
                                if v then
                                    repeat wait() Attack.Kill(v, _G.AutoZou) until not _G.AutoZou or not v.Parent or v.Humanoid.Health <= 0
                                else
                                    repeat wait() _tp(CFrame.new(2288.802, 15.1870775, 863.034607)) until not _G.AutoZou or (Root.Position == CFrame.new(2288.802, 15.1870775, 863.034607).Position)
                                    if (Root.CFrame == CFrame.new(2288.802, 15.1870775, 863.034607)) then notween(CFrame.new(2288.802, 15.1870775, 863.034607)) end
                                end
                            end
                        else
                            if replicated.Remotes.CommF_:InvokeServer("GetUnlockables").FlamingoAccess == nil then
                                local TabelDevilFruitStore = {}
                                local TabelDevilFruitOpen = {}
                                for _, v in pairs(replicated.Remotes["CommF_"]:InvokeServer("getInventoryFruits")) do
                                    for i1, v1 in pairs(v) do
                                        if i1 == "Name" then table.insert(TabelDevilFruitStore, v1) end
                                    end
                                end
                                for _, v in next, game.ReplicatedStorage:WaitForChild("Remotes").CommF_:InvokeServer("GetFruits") do
                                    if v.Price >= 1000000 then table.insert(TabelDevilFruitOpen, v.Name) end
                                end
                                for _, DevilFruitOpenDoor in pairs(TabelDevilFruitOpen) do
                                    for _, DevilFruitStore in pairs(TabelDevilFruitStore) do
                                        if DevilFruitOpenDoor == DevilFruitStore and replicated.Remotes.CommF_:InvokeServer("GetUnlockables").FlamingoAccess == nil then
                                            if not plr.Backpack:FindFirstChild(DevilFruitStore) then
                                                replicated.Remotes.CommF_:InvokeServer("F_", "LoadFruit", DevilFruitStore)
                                            else
                                                replicated.Remotes.CommF_:InvokeServer("F_", "TalkTrevor", "1")
                                                replicated.Remotes.CommF_:InvokeServer("F_", "TalkTrevor", "2")
                                                replicated.Remotes.CommF_:InvokeServer("F_", "TalkTrevor", "3")
                                            end
                                        end
                                    end
                                end
                                replicated.Remotes.CommF_:InvokeServer("F_", "TalkTrevor", "1")
                                replicated.Remotes.CommF_:InvokeServer("F_", "TalkTrevor", "2")
                                replicated.Remotes.CommF_:InvokeServer("F_", "TalkTrevor", "3")
                            end
                        end
                    else
                        if replicated.Remotes.CommF_:InvokeServer("BartiloQuestProgress", "Bartilo") == 0 then
                            if string.find(plr.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Swan Pirates") and string.find(plr.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "50") and plr.PlayerGui.Main.Quest.Visible == true then
                                local v = GetConnectionEnemies("Swan Pirate")
                                if v then
                                    pcall(function()
                                        repeat wait() Attack.Kill(v, _G.AutoZou) until not v.Parent or v.Humanoid.Health <= 0 or _G.AutoZou == false or plr.PlayerGui.Main.Quest.Visible == false
                                    end)
                                else _tp(CFrame.new(1057.92761, 137.614319, 1242.08069)) end
                            else _tp(CFrame.new(-456.28952, 73.0200958, 299.895966)) end
                        elseif replicated.Remotes.CommF_:InvokeServer("BartiloQuestProgress", "Bartilo") == 1 then
                            local v = GetConnectionEnemies("Jeremy")
                            if v then repeat wait() Attack.Kill(v, _G.AutoZou) until not v.Parent or v.Humanoid.Health <= 0 or _G.AutoZou == false
                            else _tp(CFrame.new(2099.88159, 448.931, 648.997375)) end
                        elseif replicated.Remotes.CommF_:InvokeServer("BartiloQuestProgress", "Bartilo") == 2 then
                            repeat wait() _tp(CFrame.new(-1836, 11, 1714)) until not _G.AutoZou or (Root.Position == CFrame.new(-1836, 11, 1714).Position)
                            if (Root.CFrame == CFrame.new(-1836, 11, 1714)) then notween(CFrame.new(-1836, 11, 1714)) end
                            notween(CFrame.new(-1850.49329, 13.1789551, 1750.89685)); wait(.1)
                            notween(CFrame.new(-1858.87305, 19.3777466, 1712.01807)); wait(.1)
                            notween(CFrame.new(-1803.94324, 16.5789185, 1750.89685)); wait(.1)
                            notween(CFrame.new(-1858.55835, 16.8604317, 1724.79541)); wait(.1)
                            notween(CFrame.new(-1869.54224, 15.987854, 1681.00659)); wait(.1)
                            notween(CFrame.new(-1800.0979, 16.4978027, 1684.52368)); wait(.1)
                            notween(CFrame.new(-1819.26343, 14.795166, 1717.90625)); wait(.1)
                            notween(CFrame.new(-1813.51843, 14.8604736, 1724.79541))
                        end
                    end
                end
            end
        end)
    end
end)

-- ============================================================
-- TUSHITA + YAMA
-- ============================================================
Tabs.Quests:AddSection("Tushita + Yama")

Q = Tabs.Quests:AddToggle({
    Name = "Auto Tushita Sword",
    Description = "",
    Default = false,
    Callback = function(Value) _G.Auto_Tushita = Value end
})
spawn(function()
    while wait(Sec) do
        pcall(function()
            if _G.Auto_Tushita then
                if workspace.Map.Turtle:FindFirstChild("TushitaGate") then
                    if not GetBP("Holy Torch") then
                        _tp(CFrame.new(5148.03613, 162.352493, 910.548218)); wait(0.7)
                    else
                        EquipWeapon("Holy Torch"); task.wait(1)
                        repeat task.wait() _tp(CFrame.new(-10752, 417, -9366)) until not _G.Auto_Tushita or (CFrame.new(-10752, 417, -9366).Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 10; wait(.7)
                        repeat task.wait() _tp(CFrame.new(-11672, 334, -9474)) until not _G.Auto_Tushita or (CFrame.new(-11672, 334, -9474).Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 10; wait(.7)
                        repeat task.wait() _tp(CFrame.new(-12132, 521, -10655)) until not _G.Auto_Tushita or (CFrame.new(-12132, 521, -10655).Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 10; wait(.7)
                        repeat task.wait() _tp(CFrame.new(-13336, 486, -6985)) until not _G.Auto_Tushita or (CFrame.new(-13336, 486, -6985).Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 10; wait(.7)
                        repeat task.wait() _tp(CFrame.new(-13489, 332, -7925)) until not _G.Auto_Tushita or (CFrame.new(-13489, 332, -7925).Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 10
                    end
                else
                    local v = GetConnectionEnemies("Longma")
                    if v then repeat task.wait() Attack.Kill(v, _G.Auto_Tushita) until v.Humanoid.Health <= 0 or not _G.Auto_Tushita or not v.Parent
                    elseif replicated:FindFirstChild("Longma") then _tp(replicated:FindFirstChild("Longma").HumanoidRootPart.CFrame * CFrame.new(0, 40, 0)) end
                end
            end
        end)
    end
end)

Q = Tabs.Quests:AddToggle({
    Name = "Auto Yama Sword",
    Description = "",
    Default = false,
    Callback = function(Value) _G.Auto_Yama = Value end
})
spawn(function()
    while wait(Sec) do
        pcall(function()
            if _G.Auto_Yama then
                if replicated.Remotes.CommF_:InvokeServer("EliteHunter", "Progress") < 30 then
                    _G.FarmEliteHunt = true
                elseif replicated.Remotes.CommF_:InvokeServer("EliteHunter", "Progress") > 30 then
                    _G.FarmEliteHunt = false
                    if (workspace.Map.Waterfall.SealedKatana.Handle.Position - plr.Character.HumanoidRootPart.Position).Magnitude >= 20 then
                        _tp(workspace.Map.Waterfall.SealedKatana.Handle.CFrame)
                        local zx = GetConnectionEnemies("Ghost")
                        if zx then
                            repeat wait() Attack.Kill(zx, _G.Auto_Yama) until zx.Humanoid.Health <= 0 or not zx.Parent or not _G.Auto_Yama
                            fireclickdetector(workspace.Map.Waterfall.SealedKatana.Handle.ClickDetector)
                        end
                    end
                end
            end
        end)
    end
end)

-- ============================================================
-- SKULL GUITAR
-- ============================================================
Tabs.Quests:AddSection("Skull Guitars / Misc")

local CheckSoul = Tabs.Quests:AddParagraph("Skull Guitar Quests", "")
spawn(function()
    while wait(0.2) do
        pcall(function()
            if Quest1 == true then CheckSoul:SetDesc("Quest Number : Quest1")
            elseif Quest2 == true then CheckSoul:SetDesc("Quest Number : Quest2")
            elseif Quest3 == true then CheckSoul:SetDesc("Quest Number : Quest3")
            elseif Quest4 == true then CheckSoul:SetDesc("Quest Number : Quest4")
            elseif GetWP("Skull Guitar") then CheckSoul:SetDesc("Quest Number : Collect!!")
            else CheckSoul:SetDesc("Quest Number : No Quest!!") end
        end)
    end
end)

Tabs.Quests:AddToggle({
    Name = "Auto Skull Guitar",
    Description = "",
    Default = false,
    Callback = function(Value) _G.Auto_Soul_Guitar = Value end
})
task.spawn(function()
    while wait() do
        if _G.Auto_Soul_Guitar then
            pcall(function()
                local v = GetConnectionEnemies("Living Zombie")
                if v then
                    v.HumanoidRootPart.CFrame = CFrame.new(-10138.3974609375, 138.6524658203125, 5902.89208984375)
                    v.Head.CanCollide = false
                    v.Humanoid.Sit = false
                    v.HumanoidRootPart.CanCollide = false
                    v.Humanoid.JumpPower = 0
                    v.Humanoid.WalkSpeed = 0
                    if v.Humanoid:FindFirstChild('Animator') then v.Humanoid:FindFirstChild('Animator'):Destroy() end
                end
            end)
        end
    end
end)

function getT(num)
    local seg = workspace.Map["Haunted Castle"].Tablet["Segment" .. num]
    if seg and seg.Line then return seg.Line.Rotation.Z end
end

function getRT(num)
    for _, v in pairs(workspace.Map["Haunted Castle"].Trophies.Quest:GetChildren()) do
        if v.Name == "Trophy" .. num and v:FindFirstChild("Handle") then
            return v.Handle.Rotation.Z
        end
    end
end

GetFirePlacard = function(Number, Side)
    if tostring(workspace.Map["Haunted Castle"]["Placard" .. Number][Side].Indicator.BrickColor) ~= "Pearl" then
        fireclickdetector(workspace.Map["Haunted Castle"]["Placard" .. Number][Side].ClickDetector)
    end
end

spawn(function()
    repeat task.wait() until _G.Auto_Soul_Guitar
    while wait(Sec) do
        pcall(function()
            if _G.Auto_Soul_Guitar and World3 then
                local check = replicated.Remotes.CommF_:InvokeServer("GuitarPuzzleProgress", "Check")
                if check == nil then
                    _tp(CFrame.new(-8655.0166015625, 141.3166961669922, 6160.0224609375))
                    replicated.Remotes.CommF_:InvokeServer("gravestoneEvent", 2)
                    replicated.Remotes.CommF_:InvokeServer("gravestoneEvent", 2, true)
                elseif check.Swamp == false then
                    Quest1 = true; Quest2 = false; Quest3 = false; Quest4 = false
                    local v = GetConnectionEnemies("Living Zombie")
                    if v then repeat task.wait() Attack.Kill(v, _G.Auto_Soul_Guitar) until not _G.Auto_Soul_Guitar or v.Humanoid.Health <= 0 or not v.Parent or workspace.Map["Haunted Castle"].SwampWater.Color ~= Color3.fromRGB(117, 0, 0)
                    else _tp(CFrame.new(-10170.7275390625, 138.6524658203125, 5934.26513671875)) end
                elseif check.Gravestones == false then
                    Quest1 = false; Quest2 = true; Quest3 = false; Quest4 = false
                    GetFirePlacard("7", "Left"); GetFirePlacard("6", "Left"); GetFirePlacard("5", "Left")
                    GetFirePlacard("4", "Right"); GetFirePlacard("3", "Left"); GetFirePlacard("2", "Right"); GetFirePlacard("1", "Right")
                elseif check.Ghost == false then
                    replicated.Remotes.CommF_:InvokeServer("GuitarPuzzleProgress", "Ghost")
                    replicated.Remotes.CommF_:InvokeServer("GuitarPuzzleProgress", "Ghost", true)
                elseif check.Trophies == false then
                    Quest1 = false; Quest2 = false; Quest3 = true; Quest4 = false
                    _tp(CFrame.new(-9532.8232421875, 6.471667766571045, 6078.068359375))
                    for i = 1, 5 do
                        local trophyIdx = ({1, 3, 4, 7, 10})[i]
                        repeat wait()
                            local rt = getRT(i); local t = getT(trophyIdx)
                            if rt and t and rt ~= t then fireclickdetector(workspace.Map["Haunted Castle"]["Tablet"]["Segment" .. trophyIdx]:FindFirstChild("ClickDetector")) end
                        until rt == t
                    end
                    repeat wait()
                        for _, seg in ipairs({2, 5, 6, 8, 9}) do
                            pcall(function() fireclickdetector(workspace.Map["Haunted Castle"]["Tablet"]["Segment" .. seg]:FindFirstChild("ClickDetector")) end)
                        end
                    until workspace.Map["Haunted Castle"].Tablet.Segment2.Line.Rotation.Z == 0
                elseif check.Pipes == false then
                    Quest1 = false; Quest2 = false; Quest3 = false; Quest4 = true
                    local LabP = workspace.Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model
                    for _, part in ipairs({"Part3", "Part4", "Part6", "Part8", "Part10"}) do
                        _tp(LabP[part].CFrame)
                        fireclickdetector(LabP[part].ClickDetector)
                    end
                end
            end
        end)
    end
end)

Tabs.Quests:AddToggle({
    Name = "Auto Farm Material Skull Guitar",
    Description = "",
    Default = false,
    Callback = function(Value) _G.AutoMatSoul = Value end
})
spawn(function()
    while wait(Sec) do
        pcall(function()
            if _G.AutoMatSoul and GetWP("Skull Guitar") == false then
                if GetM("Bones") >= 500 and GetM("Ectoplasm") >= 250 and GetM("Dark Fragment") >= 1 then
                    replicated.Remotes.CommF_:InvokeServer("soulGuitarBuy", true)
                elseif GetM("Ectoplasm") <= 250 then
                    if World2 then
                        local xz = GetConnectionEnemies({"Ship Deckhand", "Ship Engineer", "Ship Steward", "Ship Officer", "Arctic Warrior"})
                        if xz then repeat task.wait() Attack.Kill(xz, _G.AutoMatSoul) until not _G.AutoMatSoul or not xz.Parent or xz.Humanoid.Health <= 0
                        else replicated.Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(923.21252441406, 126.9760055542, 32852.83203125)) end
                    else replicated.Remotes.CommF_:InvokeServer("TravelDressrosa") end
                elseif GetM("Dark Fragment") < 1 then
                    if World2 then
                        local black = GetConnectionEnemies("Darkbeard")
                        if black then repeat task.wait() Attack.Kill(black, _G.AutoMatSoul) until _G.AutoMatSoul or black.Humanoid.Health <= 0
                        else _tp(CFrame.new(3798.4575195313, 13.826690673828, -3399.806640625)) end
                    else replicated.Remotes.CommF_:InvokeServer("TravelDressrosa") end
                    if not GetConnectionEnemies("Darkbeard") then Hop() end
                elseif GetM("Bones") <= 500 then
                    if World3 then
                        local zx = GetConnectionEnemies({"Reborn Skeleton", "Living Zombie", "Demonic Soul", "Posessed Mummy"})
                        if zx then repeat task.wait() Attack.Kill(zx, _G.AutoMatSoul) until not _G.AutoMatSoul or zx.Humanoid.Health <= 0 or not zx.Parent
                        else _tp(CFrame.new(-9504.8564453125, 172.14292907714844, 6057.259765625)) end
                    else replicated.Remotes.CommF_:InvokeServer("TravelZou") end
                end
            end
        end)
    end
end)

-- ============================================================
-- CURSED DUAL KATANA
-- ============================================================
Tabs.Quests:AddSection("Cursed Dual Katana")

local CheckCDK = Tabs.Quests:AddParagraph("Number Cursed dual katana quests", "Quest Numbers :")
spawn(function()
    while wait(0.2) do
        if QuestYama_1 == true then CheckCDK:SetDesc("Quest Numbers : yama quest 1")
        elseif QuestYama_2 == true then CheckCDK:SetDesc("Quest Numbers : yama quest 2")
        elseif QuestYama_3 == true then CheckCDK:SetDesc("Quest Numbers : yama quest 3")
        elseif QuestTushita_1 == true then CheckCDK:SetDesc("Quest Numbers : tushita quest 1")
        elseif QuestTushita_2 == true then CheckCDK:SetDesc("Quest Numbers : tushita quest 2")
        elseif GetWP("Cursed Dual Katana") then CheckCDK:SetDesc("Quest Numbers : CDK done!!") end
    end
end)

Q = Tabs.Quests:AddToggle({
    Name = "Auto Get CDK [ Last Quest ]",
    Description = "",
    Default = false,
    Callback = function(Value) _G.CDK = Value end
})
spawn(function()
    while wait(Sec) do
        pcall(function()
            if _G.CDK then
                replicated.Remotes.CommF_:InvokeServer("CDKQuest", "Progress", "Good")
                replicated.Remotes.CommF_:InvokeServer("CDKQuest", "Progress", "Evil")
                replicated.Remotes.CommF_:InvokeServer("CDKQuest", "StartTrial", "Boss")
                local v = GetConnectionEnemies("Cursed Skeleton Boss")
                if v then
                    repeat wait()
                        if plr.Character:FindFirstChild("Yama") or plr.Backpack:FindFirstChild("Yama") then EquipWeapon("Yama")
                        elseif plr.Character:FindFirstChild("Tushita") or plr.Backpack:FindFirstChild("Tushita") then EquipWeapon("Tushita") end
                        _tp(v.HumanoidRootPart.CFrame * CFrame.new(0, 20, 0))
                    until not _G.CDK or not v.Parent or v.Humanoid.Health <= 0
                else
                    _tp(CFrame.new(-12318.193359375, 601.9518432617188, -6538.662109375)); wait(.5)
                    _tp(workspace.Map.Turtle.Cursed.BossDoor.CFrame)
                end
            end
        end)
    end
end)

Q = Tabs.Quests:AddToggle({
    Name = "Auto Yama CDK",
    Description = "",
    Default = false,
    Callback = function(Value) _G.CDK_YM = Value end
})
spawn(function()
    while wait() do
        pcall(function()
            if _G.CDK_YM then
                if tostring(replicated.Remotes.CommF_:InvokeServer("CDKQuest", "OpenDoor")) ~= "opened" then
                    replicated.Remotes.CommF_:InvokeServer("CDKQuest", "OpenDoor")
                    replicated.Remotes.CommF_:InvokeServer("CDKQuest", "OpenDoor", true)
                else
                    local prog = replicated.Remotes.CommF_:InvokeServer("CDKQuest", "Progress")
                    if prog["Finished"] == nil then
                        replicated.Remotes.CommF_:InvokeServer("CDKQuest", "StartTrial", "Evil")
                    elseif prog["Finished"] == false then
                        local evil = tonumber(prog["Evil"])
                        if evil == -3 then
                            QuestYama_1 = true; QuestYama_2 = false; QuestYama_3 = false
                            repeat task.wait()
                                local v = GetConnectionEnemies("Forest Pirate")
                                if v then Attack.Kill(v, _G.CDK_YM)
                                else _tp(CFrame.new(-13223.521484375, 428.1938171386719, -7766.06787109375)) end
                            until tonumber(replicated.Remotes.CommF_:InvokeServer("CDKQuest", "Progress")["Evil"]) == 1 or not _G.CDK_YM
                        elseif evil == -4 then
                            QuestYama_1 = false; QuestYama_2 = true; QuestYama_3 = false
                            for ix, HitMon in pairs(game:GetService("Players").LocalPlayer.QuestHaze:GetChildren()) do
                                for NameMonHaze, CFramePos in pairs(PosMsList) do
                                    if string.find(NameMonHaze, HitMon.Name) and HitMon.Value > 0 then
                                        if workspace.Enemies:FindFirstChild(NameMonHaze) then
                                            for i, v in pairs(workspace.Enemies:GetChildren()) do
                                                if v.Name == NameMonHaze and v:FindFirstChild("HazeESP") and v.Humanoid.Health > 0 then
                                                    repeat wait() Attack.Kill(v, _G.CDK_YM) until not _G.CDK_YM or tonumber(replicated.Remotes.CommF_:InvokeServer("CDKQuest", "Progress")["Evil"]) == 2 or not v:FindFirstChild("HazeESP") or v.Humanoid.Health <= 0
                                                end
                                            end
                                        else _tp(CFramePos) end
                                    end
                                end
                            end
                        elseif evil == -5 then
                            QuestYama_1 = false; QuestYama_2 = false; QuestYama_3 = true
                            if workspace.Map:FindFirstChild("HellDimension") then
                                if (Root.Position - workspace.Map.HellDimension.Spawn.Position).Magnitude <= 1000 then
                                    for gg, ez in pairs(workspace.Map.HellDimension.Exit:GetChildren()) do
                                        if tonumber(gg) == 2 then
                                            repeat task.wait() Root.CFrame = workspace.Map.HellDimension.Exit.CFrame until not _G.CDK_YM or tonumber(replicated.Remotes.CommF_:InvokeServer("CDKQuest", "Progress")["Evil"]) == 3
                                        end
                                    end
                                end
                                for i, torch in ipairs({"Torch1", "Torch2", "Torch3"}) do
                                    repeat task.wait()
                                        _tp(workspace.Map.HellDimension[torch].Particles.CFrame)
                                        for _, v in pairs(workspace.Map.HellDimension:GetDescendants()) do
                                            if v:IsA("ProximityPrompt") then fireproximityprompt(v) end
                                        end
                                    until (workspace.Map.HellDimension[torch].Particles.Position - Root.Position).Magnitude < 5 or not _G.CDK_YM
                                    wait(2)
                                end
                                for i, v in pairs(workspace.Enemies:GetChildren()) do
                                    if (v:FindFirstChild("HumanoidRootPart").Position - workspace.Map.HellDimension.Spawn.Position).Magnitude <= 300 and v.Humanoid.Health > 0 then
                                        repeat task.wait() Attack.Kill(v, _G.CDK_YM) until not _G.CDK_YM or v.Humanoid.Health <= 0 or not v.Parent or tonumber(replicated.Remotes.CommF_:InvokeServer("CDKQuest", "Progress")["Evil"]) == 3
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end)
    end
end)

Q = Tabs.Quests:AddToggle({
    Name = "Auto Tushita CDK",
    Description = "",
    Default = false,
    Callback = function(Value) _G.CDK_TS = Value end
})
spawn(function()
    while wait() do
        pcall(function()
            if _G.CDK_TS then
                if tostring(replicated.Remotes.CommF_:InvokeServer("CDKQuest", "OpenDoor")) ~= "opened" then
                    wait(.7)
                    replicated.Remotes.CommF_:InvokeServer("CDKQuest", "OpenDoor")
                    wait(.3)
                    replicated.Remotes.CommF_:InvokeServer("CDKQuest", "OpenDoor", true)
                else
                    local prog = replicated.Remotes.CommF_:InvokeServer("CDKQuest", "Progress")
                    if prog["Finished"] == nil then
                        replicated.Remotes.CommF_:InvokeServer("CDKQuest", "StartTrial", "Good")
                    elseif prog["Finished"] == false then
                        local good = tonumber(prog["Good"])
                        if good == -3 then
                            QuestTushita_1 = true; QuestTushita_2 = false
                            local boats = {
                                CFrame.new(-4602.5107421875, 16.446542739868164, -2880.998046875),
                                CFrame.new(4001.185302734375, 10.089399337768555, -2654.86328125),
                                CFrame.new(-9530.763671875, 7.245208740234375, -8375.5087890625)
                            }
                            for _, b in ipairs(boats) do
                                repeat wait() _tp(b) until (b.Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 3 or not _G.CDK_TS or tonumber(replicated.Remotes.CommF_:InvokeServer("CDKQuest", "Progress")["Good"]) == 1
                                if (b.Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 10 then
                                    wait(.7)
                                    replicated.Remotes.CommF_:InvokeServer("CDKQuest", "BoatQuest", workspace.NPCs:FindFirstChild("Luxury Boat Dealer"), "Check")
                                    wait(.5)
                                    replicated.Remotes.CommF_:InvokeServer("CDKQuest", "BoatQuest", workspace.NPCs:FindFirstChild("Luxury Boat Dealer"))
                                end
                            end
                        elseif good == -4 then
                            QuestTushita_1 = false; QuestTushita_2 = true
                            repeat wait() _G.AutoRaidCastle = true until not _G.CDK_TS or tonumber(replicated.Remotes.CommF_:InvokeServer("CDKQuest", "Progress")["Good"]) == 2
                            _G.AutoRaidCastle = false
                        elseif good == -5 then
                            QuestTushita_1 = false; QuestTushita_2 = false
                            if workspace.Enemies:FindFirstChild("Cake Queen") then
                                local v = GetConnectionEnemies("Cake Queen")
                                if v then repeat wait() Attack.Kill(v, _G.CDK_TS) until not _G.CDK_TS or not v.Parent or v.Humanoid.Health <= 0 or tonumber(replicated.Remotes.CommF_:InvokeServer("CDKQuest", "Progress")["Good"]) == 3 end
                            else
                                _tp(CFrame.new(-709.3132934570312, 381.6005859375, -11011.396484375))
                            end
                        end
                    end
                end
            end
        end)
    end
end)

-- ============================================================
-- TRUE TRIPLE KATANA
-- ============================================================
Tabs.Quests:AddSection("True Triple Katana Sword")
Tabs.Quests:AddButton({ Name = "Buy Legendary Sword", Description = "", Callback = function()
    replicated.Remotes.CommF_:InvokeServer("LegendarySwordDealer", "1")
    replicated.Remotes.CommF_:InvokeServer("LegendarySwordDealer", "2")
    replicated.Remotes.CommF_:InvokeServer("LegendarySwordDealer", "3")
end })
Tabs.Quests:AddButton({ Name = "Buy True Triple Katana Sword", Description = "", Callback = function()
    replicated.Remotes.CommF_:InvokeServer("MysteriousMan", "2")
end })
Q = Tabs.Quests:AddToggle({ Name = "Tween to Legendary Sword Dealer", Default = false, Callback = function(Value) _G.Tp_LgS = Value end })
spawn(function()
    while wait(Sec) do
        if _G.Tp_LgS then
            pcall(function()
                for _, v in pairs(replicated.NPCs:GetChildren()) do
                    if v.Name == "Legendary Sword Dealer" then _tp(v.HumanoidRootPart.CFrame) end
                end
            end)
        end
    end
end)

-- ============================================================
-- POLE V1 / V2
-- ============================================================
Tabs.Quests:AddSection("Pole / God Enal's")
Q = Tabs.Quests:AddToggle({ Name = "Auto Pole V1", Default = false, Callback = function(Value) _G.AutoPole = Value end })
spawn(function()
    while wait(Sec) do
        if _G.AutoPole then pcall(function()
            local v = GetConnectionEnemies("Thunder God")
            if v then repeat task.wait() Attack.Kill(v, _G.AutoPole) until not _G.AutoPole or not v.Parent or v.Humanoid.Health <= 0
            else _tp(CFrame.new(-7994.984375, 5761.025390625, -2088.6479492188)) end
        end) end
    end
end)

Q = Tabs.Quests:AddToggle({ Name = "Auto Pole V2 [Beta]", Default = false, Callback = function(Value) _G.AutoPoleV2 = Value end })
spawn(function()
    while wait(Sec) do
        pcall(function()
            if _G.AutoPoleV2 then
                if not GetBP("Pole (1st Form)") then replicated.Remotes.CommF_:InvokeServer("LoadItem", "Pole (1st Form)") end
                if not GetBP("Pole (2nd Form)") then replicated.Remotes.CommF_:InvokeServer("LoadItem", "Pole (2nd Form)") end
                if GetBP("Pole (1st Form)") and GetBP("Pole (1st Form)").Level.Value <= 179 then _G.Level = true
                elseif GetBP("Pole (1st Form)") and GetBP("Pole (1st Form)").Level.Value >= 180 then _G.Level = false end
                if not GetBP("Rumble Fruit") then return end
                local rumble = GetBP("Rumble Fruit")
                if rumble.AwakenedMoves:FindFirstChild("Z") and rumble.AwakenedMoves:FindFirstChild("X") and rumble.AwakenedMoves:FindFirstChild("C") and rumble.AwakenedMoves:FindFirstChild("V") and rumble.AwakenedMoves:FindFirstChild("F") then
                    _G.SelectChip = nil; _G.Raiding = false; _G.Auto_Awakener = false
                    if plr.Data.Fragments.Value >= 5000 then
                        replicated.Remotes.CommF_:InvokeServer("Thunder God", "Talk"); wait(Sec)
                        replicated.Remotes.CommF_:InvokeServer("Thunder God", "Sure")
                    end
                elseif replicated.Remotes.CommF_:InvokeServer("Awakener", "Check") == nil or replicated.Remotes.CommF_:InvokeServer("Awakener", "Check") == 0 then
                    _G.SelectChip = "Rumble"
                    local Buying = replicated.Remotes.CommF_:InvokeServer("RaidsNpc", "Select", _G.SelectChip)
                    if Buying then Buying:Stop() end
                    _G.Raiding = true; _G.Auto_Awakener = true
                end
            end
        end)
    end
end)

-- ============================================================
-- SABER / CYBORG / USOAP / BISENTO
-- ============================================================
Q = Tabs.Quests:AddToggle({ Name = "Auto Saw Sword", Default = false, Callback = function(Value) _G.AutoSaw = Value end })
spawn(function()
    while wait(.2) do
        pcall(function()
            if _G.AutoSaw then
                local v = GetConnectionEnemies("The Saw")
                if v then repeat task.wait() Attack.Kill(v, _G.AutoSaw) until _G.AutoSaw == false or v.Humanoid.Health <= 0
                else _tp(CFrame.new(-784.89715576172, 72.427383422852, 1603.5822753906)) end
            end
        end)
    end
end)

Q = Tabs.Quests:AddToggle({ Name = "Auto Saber Sword", Default = false, Callback = function(Value) _G.AutoSaber = Value end })
spawn(function()
    while wait(.2) do
        pcall(function()
            if _G.AutoSaber and plr.Data.Level.Value >= 200 and not plr.Backpack:FindFirstChild("Saber") and not plr.Character:FindFirstChild("Saber") then
                if workspace.Map.Jungle.Final.Part.Transparency == 0 then
                    if workspace.Map.Jungle.QuestPlates.Door.Transparency == 0 then
                        if (CFrame.new(-1612.55884, 36.9774132, 148.719543).Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 100 then
                            for _, p in ipairs({"Plate1", "Plate2", "Plate3", "Plate4", "Plate5"}) do
                                plr.Character.HumanoidRootPart.CFrame = workspace.Map.Jungle.QuestPlates[p].Button.CFrame
                                wait(0.5)
                            end
                        else _tp(CFrame.new(-1612.55884, 36.9774132, 148.719543)) end
                    elseif workspace.Map.Desert.Burn.Part.Transparency == 0 then
                        if plr.Backpack:FindFirstChild("Torch") or plr.Character:FindFirstChild("Torch") then
                            EquipWeapon("Torch")
                            firetouchinterest(plr.Character.Torch.Handle, workspace.Map.Desert.Burn.Fire, 0)
                            firetouchinterest(plr.Character.Torch.Handle, workspace.Map.Desert.Burn.Fire, 1)
                            _tp(CFrame.new(1114.61475, 5.04679728, 4350.22803))
                        else _tp(CFrame.new(-1610.00757, 11.5049858, 164.001587)) end
                    else
                        if replicated.Remotes.CommF_:InvokeServer("ProQuestProgress", "SickMan") ~= 0 then
                            replicated.Remotes.CommF_:InvokeServer("ProQuestProgress", "GetCup"); wait(0.5)
                            EquipWeapon("Cup"); wait(0.5)
                            replicated.Remotes.CommF_:InvokeServer("ProQuestProgress", "FillCup", plr.Character.Cup); wait(Sec)
                            replicated.Remotes.CommF_:InvokeServer("ProQuestProgress", "SickMan")
                        else
                            if replicated.Remotes.CommF_:InvokeServer("ProQuestProgress", "RichSon") == nil then
                                replicated.Remotes.CommF_:InvokeServer("ProQuestProgress", "RichSon")
                            elseif replicated.Remotes.CommF_:InvokeServer("ProQuestProgress", "RichSon") == 0 then
                                local v = GetConnectionEnemies("Mob Leader")
                                if v then
                                    _tp(CFrame.new(-2967.59521, -4.91089821, 5328.70703))
                                    repeat task.wait() Attack.Kill(v, _G.AutoSaber) until v.Humanoid.Health <= 0 or _G.AutoSaber == false
                                end
                            elseif replicated.Remotes.CommF_:InvokeServer("ProQuestProgress", "RichSon") == 1 then
                                replicated.Remotes.CommF_:InvokeServer("ProQuestProgress", "RichSon")
                                EquipWeapon("Relic")
                                _tp(CFrame.new(-1404.91504, 29.9773273, 3.80598116))
                            end
                        end
                    end
                else
                    local v = GetConnectionEnemies("Saber Expert")
                    if v then
                        repeat task.wait() Attack.Kill(v, _G.AutoSaber) until v.Humanoid.Health <= 0 or _G.AutoSaber == false
                        replicated.Remotes.CommF_:InvokeServer("ProQuestProgress", "PlaceRelic")
                    else _tp(CFrame.new(-1401.85046, 29.9773273, 8.81916237)) end
                end
            end
        end)
    end
end)

Q = Tabs.Quests:AddToggle({ Name = "Auto Cyborg", Default = false, Callback = function(Value) _G.AutoColShad = Value end })
spawn(function()
    while wait(.2) do
        if _G.AutoColShad then pcall(function()
            local v = GetConnectionEnemies("Cyborg")
            if v then repeat task.wait() Attack.Kill(v, _G.AutoColShad) until _G.AutoColShad == false or not v.Parent or v.Humanoid.Health <= 0
            else _tp(CFrame.new(6094.0249023438, 73.770050048828, 3825.7348632813)) end
        end) end
    end
end)

Q = Tabs.Quests:AddToggle({ Name = "Auto Usoap's Hat", Default = false, Callback = function(Value) _G.AutoGetUsoap = Value end })
spawn(function()
    while task.wait(Sec) do
        pcall(function()
            if _G.AutoGetUsoap then
                for _, v in pairs(workspace.Characters:GetChildren()) do
                    if v.Name ~= plr.Name and v.Humanoid.Health > 0 and v:FindFirstChild("HumanoidRootPart") and (Root.Position - v.HumanoidRootPart.Position).Magnitude <= 230 then
                        repeat task.wait() EquipWeapon(_G.SelectWeapon); _tp(v.HumanoidRootPart.CFrame * CFrame.new(1, 1, 2)) until _G.AutoGetUsoap == false or v.Humanoid.Health <= 0 or not v.Parent
                    end
                end
            end
        end)
    end
end)

Q = Tabs.Quests:AddToggle({ Name = "Auto Bisento V2", Default = false, Callback = function(Value) _G.Greybeard = Value end })
spawn(function()
    while wait(Sec) do
        if _G.Greybeard then pcall(function()
            if not GetWP("Bisento") then replicated.Remotes.CommF_:InvokeServer("BuyItem", "Bisento")
            elseif GetWP("Bisento") then
                replicated.Remotes.CommF_:InvokeServer("LoadItem", "Bisento")
                local v = GetConnectionEnemies("Greybeard")
                if v then repeat wait() Attack.Kill(v, _G.Greybeard) until _G.Greybeard == false or not v.Parent or v.Humanoid.Health <= 0
                else _tp(CFrame.new(-5023.38330078125, 28.65203285217285, 4332.3818359375)) end
            end
        end) end
    end
end)

Q = Tabs.Quests:AddToggle({ Name = "Auto Warden Sword", Default = false, Callback = function(Value) _G.WardenBoss = Value end })
spawn(function()
    while wait(.1) do
        if _G.WardenBoss then pcall(function()
            local v = GetConnectionEnemies("Chief Warden")
            if v then repeat wait() Attack.Kill(v, _G.WardenBoss) until _G.WardenBoss == false or not v.Parent or v.Humanoid.Health <= 0
            else _tp(CFrame.new(5206.92578, 0.997753382, 814.976746)) end
        end) end
    end
end)

Q = Tabs.Quests:AddToggle({ Name = "Auto Marine Coat", Default = false, Callback = function(Value) _G.MarinesCoat = Value end })
spawn(function()
    while wait(.1) do
        if _G.MarinesCoat then pcall(function()
            local v = GetConnectionEnemies("Vice Admiral")
            if v then repeat wait() Attack.Kill(v, _G.MarinesCoat) until _G.MarinesCoat == false or not v.Parent or v.Humanoid.Health <= 0
            else _tp(CFrame.new(-5006.5454101563, 88.032081604004, 4353.162109375)) end
        end) end
    end
end)

Q = Tabs.Quests:AddToggle({ Name = "Auto Swan Coat", Default = false, Callback = function(Value) _G.SwanCoat = Value end })
spawn(function()
    while wait(.1) do
        if _G.SwanCoat then pcall(function()
            local v = GetConnectionEnemies("Swan")
            if v then repeat wait() Attack.Kill(v, _G.SwanCoat) until _G.SwanCoat == false or not v.Parent or v.Humanoid.Health <= 0
            else _tp(CFrame.new(5325.09619, 7.03906584, 719.570679)) end
        end) end
    end
end)

-- ============================================================
-- SWORDS VARIETY
-- ============================================================
Tabs.Quests:AddSection("Rengoku Sword")

Q = Tabs.Quests:AddToggle({ Name = "Auto Rengoku Sword", Default = false, Callback = function(Value) _G.IceBossRen = Value end })
spawn(function()
    while wait(.1) do
        if _G.IceBossRen then pcall(function()
            local v = GetConnectionEnemies("Awakened Ice Admiral")
            if v then repeat task.wait() Attack.Kill(v, _G.IceBossRen) until _G.IceBossRen == false or not v.Parent or v.Humanoid.Health <= 0
            else _tp(CFrame.new(5668.9780273438, 28.519989013672, -6483.3520507813)) end
        end) end
    end
end)

Q = Tabs.Quests:AddToggle({ Name = "Auto Key Rengoku", Default = false, Callback = function(Value) _G.KeysRen = Value end })
spawn(function()
    while wait(.1) do
        pcall(function()
            if _G.KeysRen then
                if plr.Backpack:FindFirstChild(RenMon[3]) or plr.Character:FindFirstChild(RenMon[3]) then
                    EquipWeapon(RenMon[3]); wait(.1)
                    _tp(CFrame.new(6571.1201171875, 299.23028564453, -6967.841796875))
                else
                    local v = GetConnectionEnemies(RenMon)
                    if v then repeat task.wait() Attack.Kill(v, _G.KeysRen) until plr.Backpack:FindFirstChild(RenMon[3]) or _G.KeysRen == false or not v.Parent or v.Humanoid.Health <= 0
                    else _tp(CFrame.new(5439.716796875, 84.420944213867, -6715.1635742188)) end
                end
            end
        end)
    end
end)

Q = Tabs.Quests:AddToggle({ Name = "Auto Dragon Trident", Default = false, Callback = function(Value) _G.AutoTridentW2 = Value end })
spawn(function()
    while wait(.1) do
        if _G.AutoTridentW2 then pcall(function()
            local v = GetConnectionEnemies("Tide Keeper")
            if v then repeat task.wait() Attack.Kill(v, _G.AutoTridentW2) until _G.AutoTridentW2 == false or not v.Parent or v.Humanoid.Health <= 0
            else _tp(CFrame.new(-3795.6423339844, 105.88877105713, -11421.307617188)) end
        end) end
    end
end)

Q = Tabs.Quests:AddToggle({ Name = "Auto Long Sword", Default = false, Callback = function(Value) _G.LongsWord = Value end })
spawn(function()
    while wait(.1) do
        if _G.LongsWord then pcall(function()
            local v = GetConnectionEnemies("Diamond")
            if v then repeat task.wait() Attack.Kill(v, _G.LongsWord) until _G.LongsWord == false or not v.Parent or v.Humanoid.Health <= 0
            else _tp(CFrame.new(-1576.7166748047, 198.59265136719, 13.724286079407)) end
        end) end
    end
end)

Q = Tabs.Quests:AddToggle({ Name = "Auto Black Spikey", Default = false, Callback = function(Value) _G.BlackSpikey = Value end })
spawn(function()
    while wait(.1) do
        if _G.BlackSpikey then pcall(function()
            local v = GetConnectionEnemies("Jeremy")
            if v then repeat wait() Attack.Kill(v, _G.BlackSpikey) until _G.BlackSpikey == false or not v.Parent or v.Humanoid.Health <= 0
            else _tp(CFrame.new(2006.9261474609, 448.95666503906, 853.98284912109)) end
        end) end
    end
end)

Q = Tabs.Quests:AddToggle({ Name = "Auto Dark Blade V3", Default = false, Callback = function(Value) _G.DarkBladev3 = Value end })
spawn(function()
    while wait(Sec) do
        pcall(function()
            if _G.DarkBladev3 and World2 then
                if not GetBP("Dark Blade") then replicated.Remotes.CommF_:InvokeServer("LoadItem", "Dark Blade") end
                if GetBP("Fist of Darkness") then
                    if not workspace.Enemies:FindFirstChild("Darkbeard") then
                        _tp(CFrame.new(3677.08203125, 62.751937866211, -3144.8332519531))
                    elseif GetConnectionEnemies("Darkbeard") and GetBP("Fist of Darkness") then
                        repeat wait() _tp(CFrame.new(-5719.36376953125, 48.50590515136719, -782.9759521484375)) until not _G.DarkBladev3 or (Root.Position == CFrame.new(-5719.36376953125, 48.50590515136719, -782.9759521484375).Position)
                        fireclickdetector(workspace.Map.GraveIsland.Mountain.Rocks.Button.ClickDetector)
                    end
                else _G.AutoFarmChest = true end
            end
        end)
    end
end)

Q = Tabs.Quests:AddToggle({ Name = "Auto Midnight Blade", Default = false, Callback = function(Value) _G.AutoEcBoss = Value end })
spawn(function()
    while wait(Sec) do
        pcall(function()
            if _G.AutoEcBoss then
                if GetM("Ectoplasm") >= 99 then
                    replicated.Remotes.CommF_:InvokeServer("Ectoplasm", "Buy", 3)
                elseif GetM("Ectoplasm") <= 99 then
                    local v = GetConnectionEnemies("Cursed Captain")
                    if v then repeat wait() Attack.Kill(v, _G.AutoEcBoss) until not _G.AutoEcBoss or not v.Parent or v.Humanoid.Health <= 0
                    else
                        replicated.Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(923.21252441406, 126.9760055542, 32852.83203125)); wait(.5)
                        _tp(CFrame.new(916.928589, 181.092773, 33422))
                    end
                end
            end
        end)
    end
end)

Q = Tabs.Quests:AddToggle({ Name = "Auto Darkbeard", Default = false, Callback = function(Value) _G.Auto_Def_DarkCoat = Value end })
spawn(function()
    while wait(.1) do
        if _G.Auto_Def_DarkCoat then pcall(function()
            if GetBP("Fist of Darkness") and not workspace.Enemies:FindFirstChild("Darkbeard") then
                _tp(CFrame.new(3677.08203125, 62.751937866211, -3144.8332519531))
            else
                local v = GetConnectionEnemies("Darkbeard")
                if v then repeat wait() Attack.Kill(v, _G.Auto_Def_DarkCoat) until _G.Auto_Def_DarkCoat == false or not v.Parent or v.Humanoid.Health <= 0
                elseif not GetBP("Fist of Darkness") then
                    repeat wait(.1) _G.AutoFarmChest = true until not _G.Auto_Def_DarkCoat or GetBP("Fist of Darkness") or GetConnectionEnemies("Darkbeard")
                    _G.AutoFarmChest = false
                end
            end
        end) end
    end
end)

-- ============================================================
-- DON SWAN / SWAN GLASSES
-- ============================================================
Q = Tabs.Quests:AddToggle({ Name = "Auto Unlocked DonSwan", Default = false, Callback = function(Value) _G.Auto_DonAcces = Value end })
spawn(function()
    while wait(.1) do
        if _G.Auto_DonAcces then pcall(function()
            if replicated.Remotes.CommF_:InvokeServer("GetUnlockables").FlamingoAccess == nil and plr.Data.Level.Value >= 1500 then
                local FruitPrice = {}
                local FruitStore = {}
                for _, v in next, replicated.Remotes["CommF_"]:InvokeServer("GetFruits") do
                    if v.Price >= 1000000 then table.insert(FruitPrice, v.Name) end
                end
                for _, v in pairs(replicated.Remotes["CommF_"]:InvokeServer("getInventoryFruits")) do
                    for k, x in pairs(v) do
                        if k == "Name" then table.insert(FruitStore, x) end
                    end
                end
                replicated.Remotes.CommF_:InvokeServer("Cousin", "Buy")
                for _, y in pairs(FruitPrice) do
                    for _, z in pairs(FruitStore) do
                        if y == z and replicated.Remotes.CommF_:InvokeServer("GetUnlockables").FlamingoAccess == nil then
                            if not plr.Backpack:FindFirstChild(FruitStore[1]) then
                                replicated.Remotes.CommF_:InvokeServer("LoadFruit", tostring(y))
                            else
                                replicated.Remotes.CommF_:InvokeServer("TalkTrevor", "1")
                                replicated.Remotes.CommF_:InvokeServer("TalkTrevor", "2")
                                replicated.Remotes.CommF_:InvokeServer("TalkTrevor", "3")
                            end
                        end
                    end
                end
                if replicated.Remotes.CommF_:InvokeServer("GetUnlockables").FlamingoAccess ~= nil then
                    _G.Auto_DonAcces = false
                end
            end
        end) end
    end
end)

Q = Tabs.Quests:AddToggle({ Name = "Auto Swan Glasses", Default = false, Callback = function(Value) _G.Auto_SwanGG = Value end })
spawn(function()
    while wait(.2) do
        if _G.Auto_SwanGG then pcall(function()
            local v = GetConnectionEnemies("Don Swan")
            if v then repeat wait() Attack.Kill(v, _G.Auto_SwanGG) until _G.Auto_SwanGG == false or not v.Parent or v.Humanoid.Health <= 0
            else _tp(CFrame.new(2286.2004394531, 15.177839279175, 863.8388671875)) end
        end) end
    end
end)

-- ============================================================
-- CAVENDISH / TWIN HOOKS / BIGMOM / SERPENT / LEI
-- ============================================================
Tabs.Quests:AddSection("Cavender + Twin Hooks + Bigmom")

Q = Tabs.Quests:AddToggle({ Name = "Auto Bigmom", Default = false, Callback = function(Value) _G.AutoBigmom = Value end })
spawn(function()
    while wait(Sec) do
        if _G.AutoBigmom then pcall(function()
            local bx = GetConnectionEnemies("Cake Queen")
            if bx then repeat task.wait() Attack.Kill(bx, _G.AutoBigmom) until not _G.AutoBigmom or not bx.Parent or bx.Humanoid.Health <= 0
            else _tp(CFrame.new(-709.3132934570312, 381.6005859375, -11011.396484375)) end
        end) end
    end
end)

Q = Tabs.Quests:AddToggle({ Name = "Auto Cavendish Sword", Default = false, Callback = function(Value) _G.Auto_Cavender = Value end })
spawn(function()
    while wait(Sec) do
        pcall(function()
            if _G.Auto_Cavender then
                local v = GetConnectionEnemies("Beautiful Pirate")
                if v then repeat wait() Attack.Kill(v, _G.Auto_Cavender) until not _G.Auto_Cavender or v.Humanoid.Health <= 0
                else _tp(CFrame.new(5283.609375, 22.56223487854, -110.78285217285)) end
            end
        end)
    end
end)

Q = Tabs.Quests:AddToggle({ Name = "Auto Twin Hooks", Default = false, Callback = function(Value) _G.TwinHook = Value end })
spawn(function()
    while wait(Sec) do
        pcall(function()
            if _G.TwinHook then
                local v = GetConnectionEnemies("Captain Elephant")
                if v then repeat wait() Attack.Kill(v, _G.TwinHook) until not _G.TwinHook or v.Humanoid.Health <= 0
                else
                    replicated.Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(-12471.169921875, 374.94024658203, -7551.677734375)); wait(.2)
                    _tp(CFrame.new(-13376.7578125, 433.28689575195, -8071.392578125))
                end
            end
        end)
    end
end)

Q = Tabs.Quests:AddToggle({ Name = "Auto Serpent Bow", Default = false, Callback = function(Value) _G.AutoSerpentBow = Value end })
spawn(function()
    while wait(Sec) do
        if _G.AutoSerpentBow then pcall(function()
            local v = GetConnectionEnemies("Hydra Leader")
            if v then repeat wait() Attack.Kill(v, _G.AutoSerpentBow) until not _G.AutoSerpentBow or not v.Parent or v.Humanoid.Health <= 0
            else _tp(CFrame.new(5821.89794921875, 1019.0950927734375, -73.71923065185547)) end
        end) end
    end
end)

Q = Tabs.Quests:AddToggle({ Name = "Auto Lei Accessory", Default = false, Callback = function(Value) _G.AutoKilo = Value end })
spawn(function()
    while wait(.2) do
        if _G.AutoKilo then pcall(function()
            local v = GetConnectionEnemies("Kilo Admiral")
            if v then repeat task.wait() Attack.Kill(v, _G.AutoKilo) until not _G.AutoKilo or not v.Parent or v.Humanoid.Health <= 0
            else _tp(CFrame.new(2764.2233886719, 432.46154785156, -7144.4580078125)) end
        end) end
    end
end)

-- ============================================================
-- BUSO/AURA COLORS
-- ============================================================
Tabs.Quests:AddSection("Buso/Aura Colours")
Q = Tabs.Quests:AddToggle({ Name = "Auto Teleport Barista Cousin", Default = false, Callback = function(Value) _G.Tp_MasterA = Value end })
spawn(function()
    while wait() do
        if _G.Tp_MasterA then pcall(function()
            for _, v in pairs(replicated.NPCs:GetChildren()) do
                if v.Name == "Barista Cousin" then _tp(v.HumanoidRootPart.CFrame) end
            end
        end) end
    end
end)

Tabs.Quests:AddButton({ Name = "Buy Buso Colors", Description = "", Callback = function() replicated.Remotes.CommF_:InvokeServer("ColorsDealer", "2") end })

Q = Tabs.Quests:AddToggle({ Name = "Auto Rainbow Colors", Default = false, Callback = function(Value) _G.Auto_Rainbow_Haki = Value end })
spawn(function()
    while wait(Sec) do
        pcall(function()
            if _G.Auto_Rainbow_Haki then
                local questUI = plr.PlayerGui.Main.Quest
                local questText = questUI.Visible and questUI.Container.QuestTitle.Title.Text or ""
                if not questUI.Visible then
                    if plr.PlayerGui.Main.Quest.Visible == false then
                        replicated.Remotes.CommF_:InvokeServer("HornedMan", "Bet")
                    end
                elseif string.find(questText, "Stone") then
                    local v = GetConnectionEnemies("Stone")
                    if v then repeat wait() Attack.Kill(v, _G.Auto_Rainbow_Haki) until not _G.Auto_Rainbow_Haki or v.Humanoid.Health <= 0 or not v.Parent or not questUI.Visible
                    else _tp(CFrame.new(-1086.11621, 38.8425903, 6768.71436)) end
                elseif string.find(questText, "Hydra Leader") then
                    local v = GetConnectionEnemies("Hydra Leader")
                    if v then repeat wait() Attack.Kill(v, _G.Auto_Rainbow_Haki) until not _G.Auto_Rainbow_Haki or v.Humanoid.Health <= 0 or not v.Parent or not questUI.Visible
                    else
                        replicated.Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(5643.45263671875, 1013.0858154296875, -340.51025390625))
                        _tp(CFrame.new(5821.89794921875, 1019.0950927734375, -73.71923065185547))
                    end
                elseif string.find(questText, "Kilo Admiral") then
                    local v = GetConnectionEnemies("Kilo Admiral")
                    if v then repeat wait() Attack.Kill(v, _G.Auto_Rainbow_Haki) until not _G.Auto_Rainbow_Haki or v.Humanoid.Health <= 0 or not v.Parent or not questUI.Visible
                    else _tp(CFrame.new(2877.61743, 423.558685, -7207.31006)) end
                elseif string.find(questText, "Captain Elephant") then
                    local v = GetConnectionEnemies("Captain Elephant")
                    if v then repeat wait() Attack.Kill(v, _G.Auto_Rainbow_Haki) until not _G.Auto_Rainbow_Haki or v.Humanoid.Health <= 0 or not v.Parent or not questUI.Visible
                    else
                        replicated.Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(-12471.169921875, 374.94024658203, -7551.677734375))
                        _tp(CFrame.new(-13376.7578125, 433.28689575195, -8071.392578125))
                    end
                elseif string.find(questText, "Beautiful Pirate") then
                    local v = GetConnectionEnemies("Beautiful Pirate")
                    if v then repeat wait() Attack.Kill(v, _G.Auto_Rainbow_Haki) until not _G.Auto_Rainbow_Haki or v.Humanoid.Health <= 0 or not v.Parent or not questUI.Visible
                    else replicated.Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(5314.54638671875, 22.562219619750977, -127.06755065917969)) end
                end
            end
        end)
    end
end)

Q = Tabs.Quests:AddToggle({ Name = "Accept Rainbow Quest Faster", Default = false, Callback = function(Value) _G.GetQFast = Value end })

-- ============================================================
-- OBSERVATION
-- ============================================================
Tabs.Quests:AddSection("Instinct / Observation")

Q = Tabs.Quests:AddToggle({ Name = "Auto Farm Observation", Default = false, Callback = function(Value) _G.obsFarm = Value end })
spawn(function()
    while wait(.2) do
        pcall(function()
            if _G.obsFarm then
                replicated.Remotes.CommE:FireServer("Ken", true)
                if plr:GetAttribute("KenDodgesLeft") == 0 then KenTest = false
                elseif plr:GetAttribute("KenDodgesLeft") > 0 then
                    replicated.Remotes.CommE:FireServer("Ken", true)
                    KenTest = true
                end
            end
        end)
    end
end)
spawn(function()
    while wait(.2) do
        pcall(function()
            if _G.obsFarm then
                if World1 then
                    if workspace.Enemies:FindFirstChild("Galley Captain") then
                        if KenTest then repeat wait() _tp(workspace.Enemies.GalleyCaptain.HumanoidRootPart.CFrame * CFrame.new(3, 0, 0)) until _G.obsFarm == false or KenTest == false
                        else repeat wait() _tp(workspace.Enemies.GalleyCaptain.HumanoidRootPart.CFrame * CFrame.new(0, 50, 0)) until _G.obsFarm == false or KenTest end
                    else _tp(CFrame.new(5533.29785, 88.1079102, 4852.3916)) end
                elseif World2 then
                    if workspace.Enemies:FindFirstChild("Lava Pirate") then
                        if KenTest then repeat wait() _tp(workspace.Enemies["Lava Pirate"].HumanoidRootPart.CFrame * CFrame.new(3, 0, 0)) until _G.obsFarm == false or KenTest == false
                        else repeat wait() _tp(workspace.Enemies["Lava Pirate"].HumanoidRootPart.CFrame * CFrame.new(0, 50, 0)) until _G.obsFarm == false or KenTest end
                    else _tp(CFrame.new(-5478.39209, 15.9775667, -5246.9126)) end
                elseif World3 then
                    if workspace.Enemies:FindFirstChild("Venomous Assailant") then
                        if KenTest then repeat wait() _tp(workspace.Enemies["Venomous Assailant"].HumanoidRootPart.CFrame * CFrame.new(3, 0, 0)) until _G.obsFarm == false or KenTest == false
                        else repeat wait() _tp(workspace.Enemies["Venomous Assailant"].HumanoidRootPart.CFrame * CFrame.new(0, 50, 0)) until _G.obsFarm == false or KenTest end
                    else _tp(CFrame.new(4530.3540039063, 656.75695800781, -131.60952758789)) end
                end
            end
        end)
    end
end)

Q = Tabs.Quests:AddToggle({ Name = "Auto Observation V2", Default = false, Callback = function(Value) _G.AutoKenVTWO = Value end })
spawn(function()
    while wait(Sec) do
        if _G.AutoKenVTWO then pcall(function()
            local Kv2Pos1 = CFrame.new(-12444.78515625, 332.40396118164, -7673.1806640625)
            local Kv2Pos3 = CFrame.new(-10920.125, 624.20275878906, -10266.995117188)
            local Kv2Pos4 = CFrame.new(-13277.568359375, 370.34185791016, -7821.1572265625)
            local Kv2Pos5 = CFrame.new(-13493.12890625, 318.89553833008, -8373.7919921875)
            local questUI = plr.PlayerGui.Main.Quest
            local questText = questUI.Visible and questUI.Container.QuestTitle.Title.Text or ""
            if questUI.Visible and string.find(questText, "Defeat 50 Forest Pirates") then
                local v = GetConnectionEnemies("Forest Pirate")
                if v then repeat wait() Attack.Kill(v, _G.AutoKenVTWO) until not _G.AutoKenVTWO or v.Humanoid.Health <= 0 or not questUI.Visible
                else _tp(Kv2Pos4) end
            elseif questUI.Visible then
                local v = GetConnectionEnemies("Captain Elephant")
                if v then repeat wait() Attack.Kill(v, _G.AutoKenVTWO) until not _G.AutoKenVTWO or v.Humanoid.Health <= 0 or not questUI.Visible
                else _tp(Kv2Pos5) end
            elseif not questUI.Visible then
                replicated.Remotes.CommF_:InvokeServer("CitizenQuestProgress", "Citizen"); wait(.1)
                replicated.Remotes.CommF_:InvokeServer("StartQuest", "CitizenQuest", 1)
            end
            if replicated.Remotes.CommF_:InvokeServer("CitizenQuestProgress", "Citizen") == 2 then
                _tp(CFrame.new(-12513.51953125, 340.1137390136719, -9873.048828125))
            end
        end) end
    end
end)

-- ============================================================
-- BARTILO / CITIZEN / DUMMY
-- ============================================================
Bartilo = Tabs.Quests:AddToggle({ Name = "Auto Done Bartilo Quest", Default = false, Callback = function(Value) _G.Bartilo_Quest = Value end })
spawn(function()
    while wait(.1) do
        pcall(function()
            if _G.Bartilo_Quest and Lv >= 850 then
                local Qbart = plr.PlayerGui.Main.Quest
                local prog = replicated.Remotes.CommF_:InvokeServer("BartiloQuestProgress", "Bartilo")
                if prog == 0 then
                    _G.Level = false
                    if Qbart.Visible then
                        local x = GetConnectionEnemies(BartMon)
                        if x then
                            repeat task.wait()
                                if not string.find(Qbart.Container.QuestTitle.Title.Text, "Swan Pirate") then replicated.Remotes.CommF_:InvokeServer("AbandonQuest")
                                else Attack.Kill(x, _G.Bartilo_Quest) end
                            until _G.Bartilo_Quest == false or not x.Parent or x.Humanoid.Health <= 0 or not Qbart.Visible
                        else _tp(CFrame.new(970.369446, 142.653198, 1217.3667)) end
                    else
                        repeat wait() _tp(CFrame.new(-461.533203, 72.3478546, 300.311096)) until (CFrame.new(-461.533203, 72.3478546, 300.311096).Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 20 or _G.Bartilo_Quest == false
                        if (CFrame.new(-461.533203, 72.3478546, 300.311096).Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 1 then
                            replicated.Remotes.CommF_:InvokeServer("StartQuest", "BartiloQuest", 1)
                        end
                    end
                elseif prog == 1 then
                    _G.Level = false
                    local je = GetConnectionEnemies("Jeremy")
                    if je then repeat task.wait() Attack.Kill(je, _G.Bartilo_Quest) until _G.Bartilo_Quest == false or not je.Parent or je.Humanoid.Health <= 0 or not Qbart.Visible
                    else _tp(CFrame.new(2158.97412, 449.056244, 705.411682)) end
                elseif prog == 2 then
                    repeat wait() _tp(CFrame.new(-1830.83972, 10.5578213, 1680.60229)) until (CFrame.new(-1830.83972, 10.5578213, 1680.60229).Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 1 or _G.Bartilo_Quest == false
                    wait(0.5)
                    for i = 1, 8 do
                        plr.Character.HumanoidRootPart.CFrame = workspace.Map.Dressrosa.BartiloPlates["Plate" .. i].CFrame
                        wait(0.5)
                    end
                end
            end
        end)
    end
end)

CitizenQ = Tabs.Quests:AddToggle({ Name = "Auto Done Citizen Quest", Default = false, Callback = function(Value) _G.CitizenQuest = Value end })
spawn(function()
    while wait(Sec) do
        pcall(function()
            if _G.CitizenQuest then
                local prog = replicated.Remotes.CommF_:InvokeServer("CitizenQuestProgress")
                local questUI = plr.PlayerGui.Main.Quest
                if Lv >= 1800 and prog.KilledBandits == false then
                    if string.find(questUI.Container.QuestTitle.Title.Text, "Forest Pirate") and string.find(questUI.Container.QuestTitle.Title.Text, "50") and questUI.Visible then
                        local v = GetConnectionEnemies("Forest Pirate")
                        if v then repeat task.wait() Attack.Kill(v, _G.CitizenQuest) until _G.CitizenQuest == false or not v.Parent or v.Humanoid.Health <= 0 or not questUI.Visible
                        else _tp(CFrame.new(-13206.452148438, 425.89199829102, -7964.5537109375)) end
                    else
                        _tp(CFrame.new(-12443.8671875, 332.40396118164, -7675.4892578125))
                        if (Vector3.new(-12443.8671875, 332.40396118164, -7675.4892578125) - plr.Character.HumanoidRootPart.Position).Magnitude <= 30 then
                            wait(1.5)
                            replicated.Remotes.CommF_:InvokeServer("StartQuest", "CitizenQuest", 1)
                        end
                    end
                elseif Lv >= 1800 and prog.KilledBoss == false then
                    local v = GetConnectionEnemies("Captain Elephant")
                    if questUI.Visible and string.find(questUI.Container.QuestTitle.Title.Text, "Captain Elephant") then
                        if v then repeat task.wait() Attack.Kill(v, _G.CitizenQuest) until _G.CitizenQuest == false or v.Humanoid.Health <= 0 or not v.Parent or not questUI.Visible
                        else _tp(CFrame.new(-13374.889648438, 421.27752685547, -8225.208984375)) end
                    else
                        _tp(CFrame.new(-12443.8671875, 332.40396118164, -7675.4892578125))
                        if (CFrame.new(-12443.8671875, 332.40396118164, -7675.4892578125).Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 4 then
                            wait(1.5)
                            replicated.Remotes.CommF_:InvokeServer("CitizenQuestProgress", "Citizen")
                        end
                    end
                elseif Lv >= 1800 and prog.Citizen == 2 then
                    _tp(CFrame.new(-12512.138671875, 340.39279174805, -9872.8203125))
                end
            end
        end)
    end
end)

Q = Tabs.Quests:AddToggle({ Name = "Auto Training Dummy", Default = false, Callback = function(Value) _G.DummyMan = Value end })
spawn(function()
    while wait(Sec) do
        if _G.DummyMan then pcall(function()
            local questUI = plr.PlayerGui.Main.Quest
            if not questUI.Visible then
                replicated.Remotes.CommF_:InvokeServer("ArenaTrainer")
            else
                local v = GetConnectionEnemies("Training Dummy")
                if v then repeat wait() Attack.Kill(v, _G.DummyMan) until not _G.DummyMan or not v.Parent or v.Humanoid.Health <= 0
                else _tp(CFrame.new(3688.005126953125, 12.746943473815918, 170.20953369140625)) end
            end
        end) end
    end
end)

-- ============================================================
-- MELEE STYLES
-- ============================================================
Tabs.Quests:AddSection("Fighting Melee Styles")

SuperHuman = Tabs.Quests:AddToggle({ Name = "Auto Superhuman", Default = false, Callback = function(Value) _G.Auto_SuperHuman = Value end })
spawn(function()
    while wait(Sec) do
        pcall(function()
            if _G.Auto_SuperHuman and plr:FindFirstChild("WeaponAssetCache") then
                if not GetBP("Superhuman") then
                    if not GetBP("Black Leg") and plr.Data.Beli.Value >= 150000 then replicated.Remotes.CommF_:InvokeServer("BuyBlackLeg") end
                    if not GetBP("Electro") and plr.Data.Beli.Value >= 500000 then replicated.Remotes.CommF_:InvokeServer("BuyElectro") end
                    if not GetBP("Fishman Karate") and plr.Data.Beli.Value >= 750000 then replicated.Remotes.CommF_:InvokeServer("BuyFishmanKarate") end
                    if not GetBP("Dragon Claw") and plr.Data.Fragments.Value >= 1500 then replicated.Remotes.CommF_:InvokeServer("BlackbeardReward", "DragonClaw", "2") end
                    replicated.Remotes.CommF_:InvokeServer("BuySuperhuman")
                end
            end
        end)
    end
end)

DeathStep = Tabs.Quests:AddToggle({ Name = "Auto DeathStep", Default = false, Callback = function(Value) _G.AutoDeathStep = Value end })
spawn(function()
    while wait(Sec) do
        pcall(function()
            if _G.AutoDeathStep and plr:FindFirstChild("WeaponAssetCache") then
                if not GetBP("Death Step") then
                    if not GetBP("Black Leg") then replicated.Remotes.CommF_:InvokeServer("BuyBlackLeg") end
                    if GetBP("Black Leg") and GetBP("Black Leg").Level.Value >= 400 then replicated.Remotes.CommF_:InvokeServer("BuyDeathStep")
                    else _G.Level = true end
                end
            end
        end)
    end
end)

SharkManV2 = Tabs.Quests:AddToggle({ Name = "Auto Sharkman Karate", Default = false, Callback = function(Value) _G.Auto_SharkMan_Karate = Value end })
spawn(function()
    while wait(Sec) do
        pcall(function()
            if _G.Auto_SharkMan_Karate and plr:FindFirstChild("WeaponAssetCache") then
                if not GetBP("Sharkman Karate") then
                    if not GetBP("Fishman Karate") then replicated.Remotes.CommF_:InvokeServer("BuyFishmanKarate") end
                    if GetBP("Fishman Karate") and GetBP("Fishman Karate").Level.Value >= 400 then
                        if GetBP("Water Key") then replicated.Remotes.CommF_:InvokeServer("BuySharkmanKarate")
                        else
                            local v = GetConnectionEnemies("Tide Keeper")
                            if v then repeat wait() Attack.Kill(v, _G.Auto_SharkMan_Karate) until not v.Parent or v.Humanoid.Health <= 0 or GetBP("Water Key")
                            else _tp(CFrame.new(-3053.9814453125, 237.18954467773, -10145.0390625)) end
                        end
                    end
                end
            end
        end)
    end
end)

ElectricClaw = Tabs.Quests:AddToggle({ Name = "Auto ElectricClaw", Default = false, Callback = function(Value) _G.Auto_Electric_Claw = Value end })
spawn(function()
    while wait(Sec) do
        pcall(function()
            if _G.Auto_Electric_Claw and plr:FindFirstChild("WeaponAssetCache") then
                if not GetBP("Electro") then replicated.Remotes.CommF_:InvokeServer("BuyElectro") end
                if GetBP("Electro") and GetBP("Electro").Level.Value >= 400 then
                    if replicated.Remotes.CommF_:InvokeServer("BuyElectricClaw", "Start") == nil then notween(CFrame.new(-12548, 337, -7481)) end
                    replicated.Remotes.CommF_:InvokeServer("BuyElectricClaw")
                end
            end
        end)
    end
end)

DragonTalon = Tabs.Quests:AddToggle({ Name = "Auto DragonTalon", Default = false, Callback = function(Value) _G.AutoDragonTalon = Value end })
spawn(function()
    while wait(Sec) do
        pcall(function()
            if _G.AutoDragonTalon and plr:FindFirstChild("WeaponAssetCache") then
                if not GetBP("Dragon Claw") then replicated.Remotes.CommF_:InvokeServer("BlackbeardReward", "DragonClaw", "2") end
                if GetBP("Dragon Claw") and GetBP("Dragon Claw").Level.Value >= 400 then
                    replicated.Remotes.CommF_:InvokeServer("Bones", "Buy", 1, 1)
                    replicated.Remotes.CommF_:InvokeServer("BuyDragonTalon")
                end
            end
        end)
    end
end)

Godhuman = Tabs.Quests:AddToggle({ Name = "Auto Godhuman", Default = false, Callback = function(Value) _G.Auto_God_Human = Value end })
spawn(function()
    while wait() do
        pcall(function()
            if _G.Auto_God_Human then
                local result = replicated.Remotes.CommF_:InvokeServer("BuyGodhuman", true)
                if result == "Bring me 20 Fish Tails, 20 Magma Ore, 10 Dragon Scales and 10 Mystic Droplets." then
                    if GetM("Dragon Scale") < 10 then
                        if World3 then Lv = 1575; _G.Level = true else replicated.Remotes.CommF_:InvokeServer("TravelZou") end
                    elseif GetM("Fish Tail") < 20 then
                        if World3 then Lv = 1775; _G.Level = true else replicated.Remotes.CommF_:InvokeServer("TravelZou") end
                    elseif GetM("Mystic Droplet") < 10 then
                        if World2 then Lv = 1425; _G.Level = true else replicated.Remotes.CommF_:InvokeServer("TravelDressrosa") end
                    elseif GetM("Magma Ore") < 20 then
                        if World2 then Lv = 1175; _G.Level = true else replicated.Remotes.CommF_:InvokeServer("TravelDressrosa") end
                    end
                elseif result ~= 3 then
                    replicated.Remotes.CommF_:InvokeServer("BuyGodhuman")
                end
            end
        end)
    end
end)

SanguineArt = Tabs.Quests:AddToggle({ Name = "Auto SanguineArt", Default = false, Callback = function(Value) _G.Snaguine = Value end })
spawn(function()
    while wait(Sec) do
        if _G.Snaguine then pcall(function()
            if not GetBP("Sanguine Art") then
                replicated.Remotes.CommF_:InvokeServer("Sanguine Art")
                if GetM("Leviathan Heart") < 1 then
                    if World3 then _G.DangerSc = "Lv Infinite"; _G.SailBoats = true
                    else _G.SailBoats = false end
                end
                if GetM("Vampire Fang") < 20 then
                    if World2 then
                        local n = GetConnectionEnemies("Vampire")
                        if n then repeat task.wait() Attack.Kill(n, _G.Snaguine) until not _G.Snaguine or n.Humanoid.Health <= 0 or not n.Parent
                        else _tp(CFrame.new(-6041.29248046875, 6.402710914611816, -1304.63330078125)) end
                    else replicated.Remotes.CommF_:InvokeServer("TravelDressrosa") end
                end
                if GetM("Demonic Wisp") < 20 then
                    if World3 then
                        local n = GetConnectionEnemies("Demonic Soul")
                        if n then repeat task.wait() Attack.Kill(n, _G.Snaguine) until not _G.Snaguine or n.Humanoid.Health <= 0 or not n.Parent
                        else _tp(CFrame.new(-9495.6806640625, 453.58624267578125, 5977.3486328125)) end
                    else replicated.Remotes.CommF_:InvokeServer("TravelZou") end
                end
            end
        end) end
    end
end)

-- ============================================================
-- END PHẦN 5
-- ============================================================
-- ============================================================
-- RACE TAB
-- ============================================================
Tabs.Race:AddSection("Mystic Island / Full Moon")

local FullMOOn = Tabs.Race:AddParagraph("FullMoon Status", "")
local Ismirage = Tabs.Race:AddParagraph("Mirage Island Status", "")
spawn(function()
    while wait(0.2) do
        if workspace.Map:FindFirstChild("MysticIsland") or workspace._WorldOrigin.Locations:FindFirstChild("Mirage Island") then
            Ismirage:SetDesc("Mirage Island : True")
        else Ismirage:SetDesc("Mirage Island : False") end
    end
end)
spawn(function()
    while wait(0.2) do
        pcall(function()
            local moonMap = {
                ["http://www.roblox.com/asset/?id=9709135895"] = "Moon : 0 / 8",
                ["http://www.roblox.com/asset/?id=9709139597"] = "Moon : 1 / 8",
                ["http://www.roblox.com/asset/?id=9709143733"] = "Moon : 2 / 8",
                ["http://www.roblox.com/asset/?id=9709149052"] = "Moon : 3 / 8 [ Next Night ]",
                ["http://www.roblox.com/asset/?id=9709149431"] = "Moon : 4 / 8 [ Full Moon ]",
                ["http://www.roblox.com/asset/?id=9709149680"] = "Moon : 5 / 8 [ Last Night ]",
                ["http://www.roblox.com/asset/?id=9709150086"] = "Moon : 6 / 8",
                ["http://www.roblox.com/asset/?id=9709150401"] = "Moon : 7 / 8"
            }
            local moon = Getmoon()
            if moonMap[moon] then FullMOOn:SetDesc(moonMap[moon]) end
        end)
    end
end)

Tabs.Race:AddToggle({ Name = "Auto Find Mirage Island", Default = false, Callback = function(Value) _G.FindMirage = Value end })
spawn(function()
    while wait() do
        if _G.FindMirage then pcall(function()
            if not workspace["_WorldOrigin"].Locations:FindFirstChild("Mirage Island", true) then
                local myBoat = CheckBoat()
                if not myBoat then
                    local buyBoatCFrame = CFrame.new(-16927.451, 9.086, 433.864)
                    TeleportToTarget(buyBoatCFrame)
                    if (buyBoatCFrame.Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 10 then
                        replicated.Remotes.CommF_:InvokeServer("BuyBoat", _G.SelectedBoat or "Guardian")
                    end
                else
                    if plr.Character.Humanoid.Sit == false then
                        _tp(myBoat.VehicleSeat.CFrame * CFrame.new(0, 1, 0))
                    else
                        repeat wait()
                            if CheckEnemiesBoat() or CheckTerrorShark() or CheckPirateGrandBrigade() then _tp(CFrame.new(-10000000, 150, 37016.25))
                            else _tp(CFrame.new(-10000000, 31, 37016.25)) end
                        until not _G.FindMirage or workspace["_WorldOrigin"].Locations:FindFirstChild("Mirage Island") or plr.Character.Humanoid.Sit == false
                        plr.Character.Humanoid.Sit = false
                    end
                end
            else _tp(workspace.Map.MysticIsland.Center.CFrame * CFrame.new(0, 300, 0)) end
        end) end
    end
end)

Tabs.Race:AddToggle({ Name = "Auto Tween To Mirage Island", Default = false, Callback = function(Value) _G.AutoMysticIsland = Value end })
spawn(function()
    while task.wait(0.1) do pcall(function()
        if _G.AutoMysticIsland then
            for _, location in pairs(game:GetService("Workspace")._WorldOrigin.Locations:GetChildren()) do
                if location.Name == "Mirage Island" then _tp(location.CFrame * CFrame.new(0, 333, 0)) end
            end
        end
    end) end
end)

Tabs.Race:AddToggle({ Name = "Auto Tween To Highest Point", Default = false, Callback = function(Value) _G.HighestMirage = Value end })
spawn(function()
    while wait(Sec) do
        if _G.HighestMirage then pcall(function()
            if workspace["_WorldOrigin"].Locations:FindFirstChild("Mirage Island", true) then
                _tp(workspace.Map.MysticIsland.Center.CFrame * CFrame.new(0, 400, 0))
            end
        end) end
    end
end)

Tabs.Race:AddToggle({ Name = "Auto Collect Gear", Default = false, Callback = function(Value) _G.TPGEAR = Value end })
spawn(function()
    while wait(0.1) do
        if _G.TPGEAR then pcall(function()
            for _, v in pairs(workspace.Map:FindFirstChild('MysticIsland'):GetChildren()) do
                if v.Name == "Part" and v.ClassName == "MeshPart" then _tp(v.CFrame) end
            end
        end) end
    end
end)

Tabs.Race:AddToggle({ Name = "Change Transparency can see", Default = false, Callback = function(Value) _G.can = Value end })
spawn(function()
    while wait(Sec) do
        if _G.can then pcall(function()
            for _, v in pairs(workspace.Map:FindFirstChild('MysticIsland'):GetChildren()) do
                if v.Name == "Part" and v.ClassName == "MeshPart" then v.Transparency = 0 else v.Transparency = 1 end
            end
        end) end
    end
end)

Tabs.Race:AddToggle({ Name = "Auto Tween Advanced Fruit Dealer", Default = false, Callback = function(Value) _G.Addealer = Value end })
spawn(function()
    while wait() do
        if _G.Addealer then pcall(function()
            for _, v in pairs(replicated.NPCs:GetChildren()) do
                if v.Name == "Advanced Fruit Dealer" then _tp(v.HumanoidRootPart.CFrame) end
            end
        end) end
    end
end)

Tabs.Race:AddToggle({ Name = "Auto Collect Mirage Chest", Default = false, Callback = function(Value) _G.FarmChestM = Value end })
spawn(function()
    while wait(.2) do
        if _G.FarmChestM then pcall(function()
            if workspace.Map.MysticIsland.Chests:FindFirstChild("DiamondChest") or workspace.Map.MysticIsland.Chests:FindFirstChild("FragChest") then
                local CollectionService = game:GetService("CollectionService")
                local Player = game:GetService("Players").LocalPlayer
                local Character = Player.Character or Player.CharacterAdded:Wait()
                if not Character then return end
                local Position = Character:GetPivot().Position
                local Chests = CollectionService:GetTagged("_ChestTagged")
                local Distance, Nearest = math.huge, nil
                for i = 1, #Chests do
                    local Chest = Chests[i]
                    local Magnitude = (Chest:GetPivot().Position - Position).Magnitude
                    if not Chest:GetAttribute("IsDisabled") and Magnitude < Distance then Distance = Magnitude; Nearest = Chest end
                end
                if Nearest then _tp(Nearest:GetPivot()) end
            end
        end) end
    end
end)

Tabs.Race:AddButton({ Name = "Talk With Stone", Callback = function()
    replicated.Remotes.CommF_:InvokeServer("RaceV4Progress", "Begin")
    replicated.Remotes.CommF_:InvokeServer("RaceV4Progress", "Check")
    replicated.Remotes.CommF_:InvokeServer("RaceV4Progress", "Teleport")
    replicated.Remotes.CommF_:InvokeServer("RaceV4Progress", "Continue")
end })

Tabs.Race:AddToggle({ Name = "Auto Look At Moon", Default = false, Callback = function(Value) LookM = Value end })
task.spawn(function()
    while task.wait() do
        if LookM then
            local moonDir = Lighting:GetMoonDirection()
            workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, workspace.CurrentCamera.CFrame.Position + moonDir)
            plr.Character.HumanoidRootPart.CFrame = CFrame.new(plr.Character.HumanoidRootPart.Position, plr.Character.HumanoidRootPart.Position + moonDir)
            wait(.1)
            replicated.Remotes.CommE:FireServer("ActivateAbility")
        end
    end
end)

-- RACE UPGRADE
Tabs.Race:AddSection("Upgrade Races V2 And V3")

Tabs.Race:AddToggle({ Name = "Auto Upgrade Mink", Default = false, Callback = function(Value) _G.Auto_Mink = Value end })
spawn(function()
    while wait(Sec) do
        pcall(function()
            if _G.Auto_Mink then
                local a1 = replicated.Remotes.CommF_:InvokeServer("Alchemist", "1")
                if a1 == 0 then replicated.Remotes.CommF_:InvokeServer("Alchemist", "2")
                elseif a1 == 1 then
                    if not GetBP("Flower 1") then _tp(workspace.Flower1.CFrame)
                    elseif not GetBP("Flower 2") then _tp(workspace.Flower2.CFrame)
                    elseif not GetBP("Flower 3") then
                        local v = GetConnectionEnemies("Swan Pirate")
                        if v then repeat wait() Attack.Kill(v, _G.Auto_Mink) until GetBP("Flower 3") or not v.Parent or v.Humanoid.Health <= 0
                        else _tp(CFrame.new(980.0985107421875, 121.331298828125, 1287.2093505859375)) end
                    end
                elseif a1 == 2 then replicated.Remotes.CommF_:InvokeServer("Alchemist", "3") end
            end
        end)
    end
end)

Tabs.Race:AddToggle({ Name = "Auto Upgrade Human", Default = false, Callback = function(Value) _G.Auto_Human = Value end })
spawn(function()
    while wait(Sec) do
        pcall(function()
            if _G.Auto_Human then
                local a1 = replicated.Remotes.CommF_:InvokeServer("Alchemist", "1")
                if a1 == 0 then replicated.Remotes.CommF_:InvokeServer("Alchemist", "2")
                elseif a1 == 1 then
                    if not GetBP("Flower 1") then _tp(workspace.Flower1.CFrame)
                    elseif not GetBP("Flower 2") then _tp(workspace.Flower2.CFrame)
                    elseif not GetBP("Flower 3") then
                        local v = GetConnectionEnemies("Swan Pirate")
                        if v then repeat wait() Attack.Kill(v, _G.Auto_Human) until GetBP("Flower 3") or not v.Parent or v.Humanoid.Health <= 0
                        else _tp(CFrame.new(980.0985107421875, 121.331298828125, 1287.2093505859375)) end
                    end
                elseif a1 == 2 then replicated.Remotes.CommF_:InvokeServer("Alchemist", "3") end
            end
        end)
    end
end)

Tabs.Race:AddToggle({ Name = "Auto Upgrade Angel", Default = false, Callback = function(Value) _G.Auto_Skypiea = Value end })
spawn(function()
    while wait(Sec) do
        pcall(function()
            if _G.Auto_Skypiea then
                local a1 = replicated.Remotes.CommF_:InvokeServer("Alchemist", "1")
                if a1 == 0 then replicated.Remotes.CommF_:InvokeServer("Alchemist", "2")
                elseif a1 == 1 then
                    if not GetBP("Flower 1") then _tp(workspace.Flower1.CFrame)
                    elseif not GetBP("Flower 2") then _tp(workspace.Flower2.CFrame)
                    elseif not GetBP("Flower 3") then
                        local v = GetConnectionEnemies("Swan Pirate")
                        if v then repeat wait() Attack.Kill(v, _G.Auto_Skypiea) until GetBP("Flower 3") or not v.Parent or v.Humanoid.Health <= 0
                        else _tp(CFrame.new(980.0985107421875, 121.331298828125, 1287.2093505859375)) end
                    end
                elseif a1 == 2 then replicated.Remotes.CommF_:InvokeServer("Alchemist", "3") end
            end
        end)
    end
end)

Tabs.Race:AddToggle({ Name = "Auto Upgrade FishMan", Default = false, Callback = function(Value) _G.Auto_Fish = Value end })
spawn(function()
    while wait(Sec) do
        pcall(function()
            if _G.Auto_Fish then
                local a1 = replicated.Remotes.CommF_:InvokeServer("Alchemist", "1")
                if a1 == 0 then replicated.Remotes.CommF_:InvokeServer("Alchemist", "2")
                elseif a1 == 1 then
                    if not GetBP("Flower 1") then _tp(workspace.Flower1.CFrame)
                    elseif not GetBP("Flower 2") then _tp(workspace.Flower2.CFrame)
                    elseif not GetBP("Flower 3") then
                        local v = GetConnectionEnemies("Swan Pirate")
                        if v then repeat wait() Attack.Kill(v, _G.Auto_Fish) until GetBP("Flower 3") or not v.Parent or v.Humanoid.Health <= 0
                        else _tp(CFrame.new(980.0985107421875, 121.331298828125, 1287.2093505859375)) end
                    end
                elseif a1 == 2 then replicated.Remotes.CommF_:InvokeServer("Alchemist", "3") end
            end
        end)
    end
end)

-- TRIALS V4
Tabs.Race:AddSection("Trials Quest V4")
local CheckTier = Tabs.Race:AddParagraph("Tiers V4 Status", "")
spawn(function()
    pcall(function()
        while wait(0.2) do
            CheckTier:SetDesc("Tiers - V4 : " .. plr.Data.Race.C.Value)
        end
    end)
end)

Tabs.Race:AddToggle({ Name = "Auto Pull Lever", Default = false, Callback = function(Value) _G.Lver = Value end })
spawn(function()
    while wait(Sec) do
        if _G.Lver then pcall(function()
            for _, c in pairs(workspace.Map["Temple of Time"]:GetDescendants()) do
                if c.Name == "ProximityPrompt" then fireproximityprompt(c, math.huge) end
            end
        end) end
    end
end)

Tabs.Race:AddToggle({ Name = "Auto Train V4", Default = false, Callback = function(Value) _G.AcientOne = Value end })
spawn(function()
    while wait(Sec) do
        pcall(function()
            if _G.AcientOne then
                local BonesTable = {"Reborn Skeleton", "Living Zombie", "Demonic Soul", "Posessed Mummy"}
                if plr.Character:FindFirstChild("RaceEnergy") and plr.Character.RaceEnergy.Value == 1 then
                    vim1:SendKeyEvent(true, "Y", false, game)
                    replicated.Remotes.CommF_:InvokeServer("UpgradeRace", "Buy")
                    _tp(CFrame.new(-8987.041015625, 215.862060546875, 5886.71044921875))
                elseif plr.Character:FindFirstChild("RaceTransformed") and plr.Character.RaceTransformed.Value == false then
                    local v = GetConnectionEnemies(BonesTable)
                    if v then repeat wait() Attack.Kill(v, _G.AcientOne) until _G.AcientOne == false or v.Humanoid.Health <= 0 or not v.Parent
                    else _tp(CFrame.new(-9495.6806640625, 453.58624267578125, 5977.3486328125)) end
                end
            end
        end)
    end
end)

Tabs.Race:AddButton({ Name = "Teleport to Temple of Time", Callback = function()
    local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
    if hrp then hrp.CFrame = CFrame.new(28286.35546875, 14895.3017578125, 102.62469482421875) end
    if not workspace.Map:FindFirstChild("Temple of Time") and World3 then
        local stash = replicated:FindFirstChild("MapStash")
        if stash and stash:FindFirstChild("Temple of Time") then stash["Temple of Time"].Parent = workspace.Map end
    end
end })

Tabs.Race:AddToggle({ Name = "Auto Teleport to Race Doors", Default = false, Callback = function(Value) _G.TPDoor = Value end })
spawn(function()
    while wait(Sec) do
        pcall(function()
            if _G.TPDoor then
                local race = tostring(plr.Data.Race.Value)
                local doorPos = {
                    Mink = CFrame.new(29020.66015625, 14889.4267578125, -379.2682800292969),
                    Fishman = CFrame.new(28224.056640625, 14889.4267578125, -210.5872039794922),
                    Cyborg = CFrame.new(28492.4140625, 14894.4267578125, -422.1100158691406),
                    Skypiea = CFrame.new(28967.408203125, 14918.0751953125, 234.31198120117188),
                    Ghoul = CFrame.new(28672.720703125, 14889.1279296875, 454.5961608886719),
                    Human = CFrame.new(29237.294921875, 14889.4267578125, -206.94955444335938)
                }
                if doorPos[race] then _tp(doorPos[race]) end
            end
        end)
    end
end)

Tabs.Race:AddToggle({ Name = "Auto Complete Trial Race", Default = false, Callback = function(Value) _G.Complete_Trials = Value end })
spawn(function()
    while wait(Sec) do
        pcall(function()
            if _G.Complete_Trials then
                local race = tostring(plr.Data.Race.Value)
                if race == "Mink" and workspace.Map:FindFirstChild("MinkTrial") then
                    notween(workspace.Map.MinkTrial.Ceiling.CFrame * CFrame.new(0, -20, 0))
                elseif race == "Cyborg" and workspace.Map:FindFirstChild("CyborgTrial") then
                    _tp(workspace.Map.CyborgTrial.Floor.CFrame * CFrame.new(0, 500, 0))
                elseif race == "Skypiea" and workspace.Map:FindFirstChild("SkyTrial") then
                    notween(workspace.Map.SkyTrial.Model.FinishPart.CFrame)
                elseif race == "Human" or race == "Ghoul" then
                    local v = GetConnectionEnemies({"Ancient Vampire", "Ancient Zombie"})
                    if v then repeat wait() Attack.Kill(v, _G.Complete_Trials) until _G.Complete_Trials == false or not v.Parent or v.Humanoid.Health <= 0 end
                elseif race == "Fishman" then
                    if workspace["_WorldOrigin"].Locations:FindFirstChild("Trial of Water") then
                        local trial = workspace._WorldOrigin.Locations["Trial of Water"]
                        for _, seaBeast in pairs(workspace.SeaBeasts:GetChildren()) do
                            if seaBeast:FindFirstChild("HumanoidRootPart") and (seaBeast.HumanoidRootPart.Position - trial.Position).Magnitude <= 1500 and seaBeast.Health.Value > 0 then
                                repeat task.wait() _tp(CFrame.new(seaBeast.HumanoidRootPart.Position.X, workspace.Map["WaterBase-Plane"].Position.Y + 300, seaBeast.HumanoidRootPart.Position.Z)) until not _G.Complete_Trials or seaBeast.Health.Value <= 0
                            end
                        end
                    end
                end
            end
        end)
    end
end)

-- ============================================================
-- PREHISTORIC TAB
-- ============================================================
Tabs.Prehistoric:AddSection("Dojo Quest")

Tabs.Prehistoric:AddButton({ Name = "Teleport To Dragon Dojo", Callback = function()
    replicated.Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(5661.5322265625, 1013.0907592773438, -334.9649963378906))
    _tp(CFrame.new(5814.42724609375, 1208.3267822265625, 884.5785522460938))
end })

Tabs.Prehistoric:AddToggle({ Name = "Auto Dojo Trainer", Default = false, Callback = function(Value) _G.Dojoo = Value end })
spawn(function()
    while wait(Sec) do
        if _G.Dojoo then pcall(function()
            local args = {[1] = {["NPC"] = "Dojo Trainer", ["Command"] = "RequestQuest"}}
            local progress = replicated.Modules.Net:FindFirstChild("RF/InteractDragonQuest"):InvokeServer(unpack(args))
            local NameBelt = nil
            if type(progress) == "table" and progress.Quest and progress.Quest["BeltName"] then
                NameBelt = progress.Quest["BeltName"]
            end
            if not progress or not NameBelt then
                _tp(CFrame.new(5865.0234375, 1208.3154296875, 871.15185546875))
                if (CFrame.new(5865.0234375, 1208.3154296875, 871.15185546875).Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 50 then
                    local args2 = {[1] = {["NPC"] = "Dojo Trainer", ["Command"] = "ClaimQuest"}}
                    replicated.Modules.Net:FindFirstChild("RF/InteractDragonQuest"):InvokeServer(unpack(args2))
                end
            elseif NameBelt == "White" then
                local v = GetConnectionEnemies("Skull Slayer")
                if v then repeat task.wait() Attack.Kill(v, _G.Dojoo) until not _G.Dojoo or not Attack.Alive(v)
                else _tp(CFrame.new(-16759.58984375, 71.28376770019531, 1595.3399658203125)) end
            elseif NameBelt == "Yellow" then
                _G.SeaBeast1 = true; _G.TerrorShark = true; _G.Shark = true; _G.Piranha = true; _G.MobCrew = true; _G.FishBoat = true; _G.SailBoats = true
            elseif NameBelt == "Green" then _G.SailBoats = true
            elseif NameBelt == "Purple" then _G.FarmEliteHunt = true
            elseif NameBelt == "Red" then _G.SailBoats = true; _G.FishBoat = true
            elseif NameBelt == "Black" then
                if workspace.Map:FindFirstChild("PrehistoricIsland") then
                    _G.Prehis_Find = true
                    local core = workspace.Map.PrehistoricIsland:FindFirstChild("Core")
                    if core and core:FindFirstChild("ActivationPrompt", true) then
                        _G.Prehis_Skills = false
                    else _G.Prehis_Skills = true end
                else _G.Prehis_Find = true; _G.Prehis_Skills = false end
            end
        end) end
    end
end)

-- DRAGO TRIAL
Tabs.Prehistoric:AddSection("Drago Trial")

Tabs.Prehistoric:AddToggle({ Name = "Tween To Upgrade Drago Trial", Default = false, Callback = function(Value) _G.UPGDrago = Value end })
spawn(function()
    while wait(Sec) do
        if _G.UPGDrago then pcall(function()
            _tp(CFrame.new(5814.42724609375, 1208.3267822265625, 884.5785522460938))
            if (CFrame.new(5814.42724609375, 1208.3267822265625, 884.5785522460938).Position - Root.Position).Magnitude <= 5 then
                replicated.Modules.Net:FindFirstChild("RF/InteractDragonQuest"):InvokeServer({[1] = {NPC = "Dragon Wizard", Command = "Upgrade"}})
            end
        end) end
    end
end)

Tabs.Prehistoric:AddToggle({ Name = "Auto Drago (V1)", Default = false, Callback = function(Value) _G.DragoV1 = Value end })
spawn(function()
    while wait(Sec) do
        if _G.DragoV1 then pcall(function()
            if GetM("Dragon Egg") <= 0 then
                _G.Prehis_Find = true; _G.Prehis_Skills = true; _G.Prehis_DE = true
            else
                _G.Prehis_Find = false; _G.Prehis_Skills = false; _G.Prehis_DE = false
            end
        end) end
    end
end)

Tabs.Prehistoric:AddToggle({ Name = "Auto Drago (V2)", Default = false, Callback = function(Value) _G.AutoFireFlowers = Value end })
spawn(function()
    while wait(Sec) do
        if _G.AutoFireFlowers then
            local FireFlower = workspace:FindFirstChild("FireFlowers")
            local v = GetConnectionEnemies("Forest Pirate")
            if v then repeat wait() Attack.Kill(v, _G.AutoFireFlowers) until not _G.AutoFireFlowers or not v.Parent or v.Humanoid.Health <= 0 or FireFlower
            else _tp(CFrame.new(-13206.452148438, 425.89199829102, -7964.5537109375)) end
            if FireFlower then
                for _, v in pairs(FireFlower:GetChildren()) do
                    if v:IsA("Model") and v.PrimaryPart then
                        local FlowerPos = v.PrimaryPart.Position
                        local dist = (FlowerPos - plr.Character.HumanoidRootPart.Position).Magnitude
                        if dist <= 100 then
                            vim1:SendKeyEvent(true, "E", false, game); wait(1.5); vim1:SendKeyEvent(false, "E", false, game)
                        else _tp(CFrame.new(FlowerPos)) end
                    end
                end
            end
        end
    end
end)

Tabs.Prehistoric:AddToggle({ Name = "Auto Drago (V3)", Default = false, Callback = function(Value) _G.DragoV3 = Value end })
spawn(function()
    while wait(Sec) do
        if _G.DragoV3 then pcall(function()
            _G.DangerSc = "Lv Infinite"; _G.SailBoats = true; _G.TerrorShark = true
        end) end
    end
end)

Tabs.Prehistoric:AddToggle({ Name = "Auto Relic Drago Trial [Beta]", Default = false, Callback = function(Value) _G.Relic123 = Value end })
spawn(function()
    while wait(Sec) do
        if _G.Relic123 then pcall(function()
            if workspace.Map:FindFirstChild("DracoTrial") then
                replicated.Remotes.DracoTrial:InvokeServer(); wait(.5)
                _tp(CFrame.new(-39934.9765625, 10685.359375, 22999.34375)); wait(1)
                _tp(CFrame.new(-40511.25390625, 9376.4013671875, 23458.37890625)); wait(2.5)
                _tp(CFrame.new(-39914.65625, 10685.384765625, 23000.177734375)); wait(1)
                _tp(CFrame.new(-40045.83203125, 9376.3984375, 22791.287109375)); wait(2.5)
                _tp(CFrame.new(-39908.5, 10685.4052734375, 22990.04296875)); wait(1)
                _tp(CFrame.new(-39609.5, 9376.400390625, 23472.94335975))
            else
                local drago = workspace.Map.PrehistoricIsland:FindFirstChild("TrialTeleport")
                if drago and drago:IsA("Part") then _tp(CFrame.new(drago.Position)) end
            end
        end) end
    end
end)

Tabs.Prehistoric:AddToggle({ Name = "Auto Train Drago v4", Default = false, Callback = function(Value) _G.TrainDrago = Value end })
spawn(function()
    while wait(Sec) do
        if _G.TrainDrago then pcall(function()
            local DragoM = {"Venomous Assailant", "Hydra Enforcer"}
            if plr.Character:FindFirstChild("RaceEnergy") and plr.Character.RaceEnergy.Value == 1 then
                vim1:SendKeyEvent(true, "Y", false, game)
                replicated.Remotes.CommF_:InvokeServer("UpgradeRace", "Buy", 2)
                _tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.0868835449219))
            elseif plr.Character:FindFirstChild("RaceTransformed") and plr.Character.RaceTransformed.Value == false then
                local v = GetConnectionEnemies(DragoM)
                if v then repeat wait() Attack.Kill(v, _G.TrainDrago) until _G.TrainDrago == false or v.Humanoid.Health <= 0 or not v.Parent
                else _tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.0868835449219)) end
            end
        end) end
    end
end)

Tabs.Prehistoric:AddToggle({ Name = "Tween to Drago Trials", Default = false, Callback = function(Value) _G.TpDrago_Prehis = Value end })
spawn(function()
    while wait(Sec) do
        if _G.TpDrago_Prehis then
            local v748 = workspace.Map.PrehistoricIsland:FindFirstChild("TrialTeleport")
            if v748 and v748:IsA("Part") then _tp(CFrame.new(v748.Position)) end
        end
    end
end)

Tabs.Prehistoric:AddToggle({ Name = "Swap Drago Race", Default = false, Callback = function(Value) _G.BuyDrago = Value end })
spawn(function()
    while wait(Sec) do
        if _G.BuyDrago then pcall(function()
            _tp(CFrame.new(5814.42724609375, 1208.3267822265625, 884.5785522460938))
            if (CFrame.new(5814.42724609375, 1208.3267822265625, 884.5785522460938).Position - Root.Position).Magnitude <= 5 then
                replicated.Modules.Net:FindFirstChild("RF/InteractDragonQuest"):InvokeServer({[1] = {NPC = "Dragon Wizard", Command = "DragonRace"}})
            end
        end) end
    end
end)

Tabs.Prehistoric:AddToggle({ Name = "Upgrade Dragon Talon With Uzoth", Default = false, Callback = function(Value) _G.DT_Uzoth = Value end })
spawn(function()
    while wait(Sec) do
        if _G.DT_Uzoth then
            local Uz_POS = CFrame.new(5661.89014, 1211.31909, 864.836731)
            _tp(Uz_POS)
            if (Uz_POS.Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 25 then
                replicated.Modules.Net["RF/InteractDragonQuest"]:InvokeServer({["NPC"] = "Uzoth", ["Command"] = "Upgrade"})
            end
        end
    end
end)

-- CRAFT VOLCANO
Tabs.Prehistoric:AddSection("Volcanic Crafting")
Tabs.Prehistoric:AddButton({ Name = "Craft Dragonheart", Callback = function() replicated.Remotes.CommF_:InvokeServer("CraftItem", "Craft", "Dragonheart") end })
Tabs.Prehistoric:AddButton({ Name = "Craft Dragonstorm", Callback = function() replicated.Remotes.CommF_:InvokeServer("CraftItem", "Craft", "Dragonstorm") end })
Tabs.Prehistoric:AddButton({ Name = "Craft Dino Hood", Callback = function() replicated.Remotes.CommF_:InvokeServer("CraftItem", "Craft", "DinoHood") end })
Tabs.Prehistoric:AddButton({ Name = "Craft T-Rex Skull", Callback = function() replicated.Remotes.CommF_:InvokeServer("CraftItem", "Craft", "TRexSkull") end })

-- PREHISTORIC ISLAND
Tabs.Prehistoric:AddSection("Prehistoric Island")
local Check_Volcano = Tabs.Prehistoric:AddParagraph("Prehistoric Island Status", "")
spawn(function()
    while wait(0.2) do
        if workspace.Map:FindFirstChild("PrehistoricIsland") or workspace._WorldOrigin.Locations:FindFirstChild("Prehistoric Island") then
            Check_Volcano:SetDesc("Prehistoric Island : True")
        else Check_Volcano:SetDesc("Prehistoric Island : False") end
    end
end)

Tabs.Prehistoric:AddButton({ Name = "Craft Volcanic Magnet", Callback = function()
    game:GetService("ReplicatedStorage").Modules.Net["RF/Craft"]:InvokeServer("PossibleHardcode", "Volcanic Magnet")
end })

Tabs.Prehistoric:AddToggle({ Name = "Auto Find Prehistoric Island", Default = false, Callback = function(Value) _G.Prehis_Find = Value end })
spawn(function()
    while wait(Sec) do
        if _G.Prehis_Find then pcall(function()
            local char = plr.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local hum = char:FindFirstChild("Humanoid")
            if not hrp or not hum or hum.Health <= 0 then return end
            local prehistoricLoc = workspace["_WorldOrigin"].Locations:FindFirstChild("Prehistoric Island", true)
            if not prehistoricLoc then
                local myBoat = CheckBoat()
                if not myBoat then
                    local buyBoatCFrame = CFrame.new(-16927.451, 9.086, 433.864)
                    TeleportToTarget(buyBoatCFrame)
                    if (buyBoatCFrame.Position - hrp.Position).Magnitude <= 10 then
                        replicated.Remotes.CommF_:InvokeServer("BuyBoat", _G.SelectedBoat or "Guardian")
                    end
                    return
                end
                if hum.Sit == false then _tp(myBoat.VehicleSeat.CFrame * CFrame.new(0, 1, 0)); return end
                if CheckEnemiesBoat() or CheckTerrorShark() or CheckPirateGrandBrigade() then _tp(CFrame.new(-10000000, 150, 37016.25))
                else _tp(CFrame.new(-10000000, 31, 37016.25)) end
            else
                local stoneHead = prehistoricLoc:FindFirstChild("HeadTeleport", true)
                if stoneHead then
                    local safePos = stoneHead.CFrame.Position - stoneHead.CFrame.LookVector * 40 + Vector3.new(0, 20, 0)
                    if (safePos - hrp.Position).Magnitude > 30 then _tp(CFrame.new(safePos)) end
                end
            end
        end) end
    end
end)

Tabs.Prehistoric:AddToggle({ Name = "Auto Start Prehistoric Event", Default = false, Callback = function(Value) _G.AutoStartPrehistoric = Value end })
spawn(function()
    while wait() do
        if _G.AutoStartPrehistoric then pcall(function()
            local prehistoricIsland = workspace["_WorldOrigin"].Locations:FindFirstChild("Prehistoric Island", true)
            if prehistoricIsland and workspace.Map:FindFirstChild("PrehistoricIsland", true) then
                local promptPart = workspace.Map.PrehistoricIsland.Core:FindFirstChild("ActivationPrompt", true)
                if promptPart and promptPart:FindFirstChild("ProximityPrompt") then
                    if plr:DistanceFromCharacter(promptPart.CFrame.Position) <= 150 then
                        fireproximityprompt(promptPart.ProximityPrompt, math.huge)
                        vim1:SendKeyEvent(true, "E", false, game); wait(1.5); vim1:SendKeyEvent(false, "E", false, game)
                    end
                    _tp(promptPart.CFrame)
                end
            end
        end) end
    end
end)

Tabs.Prehistoric:AddToggle({ Name = "Auto Patch Prehistoric Event", Default = false, Callback = function(Value) _G.Prehis_Skills = Value end })
spawn(function()
    while wait(0.3) do
        if _G.Prehis_Skills then pcall(function()
            local island = workspace.Map:FindFirstChild("PrehistoricIsland")
            if not island then return end
            for _, obj in pairs(island:GetDescendants()) do
                if (obj:IsA("BasePart") or obj:IsA("MeshPart")) and obj.Name:lower():find("lava") then obj:Destroy() end
            end
            local core = island:FindFirstChild("Core")
            if core and core:FindFirstChild("InteriorLava") then core.InteriorLava:Destroy() end
        end) end
    end
end)
spawn(function()
    while wait(Sec) do
        if _G.Prehis_Skills then pcall(function()
            local golem = GetConnectionEnemies("Lava Golem")
            if golem and golem:FindFirstChild("Humanoid") then
                repeat wait(0.1) Attack.Kill(golem, true); golem.Humanoid:ChangeState(15) until not _G.Prehis_Skills or not golem.Parent or golem.Humanoid.Health <= 0
            end
        end) end
    end
end)

Tabs.Prehistoric:AddToggle({ Name = "Kill Aura", Default = false, Callback = function(Value) _G.KillAuraFull = Value end })
spawn(function()
    while task.wait(2) do
        if _G.KillAuraFull then pcall(function()
            local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            sethiddenproperty(plr, "SimulationRadius", math.huge)
            for _, enemy in pairs(workspace.Enemies:GetChildren()) do
                if enemy:FindFirstChild("Humanoid") and enemy:FindFirstChild("HumanoidRootPart") then
                    if (enemy.HumanoidRootPart.Position - hrp.Position).Magnitude <= 500 and enemy.Humanoid.Health > 0 then
                        enemy.Humanoid.Health = 0
                        enemy:BreakJoints()
                    end
                end
            end
        end) end
    end
end)

Tabs.Prehistoric:AddToggle({ Name = "Auto Collect Dino Bones", Default = false, Callback = function(Value) _G.Prehis_DB = Value end })
spawn(function()
    while wait(Sec) do
        if _G.Prehis_DB then pcall(function()
            for _, v in pairs(workspace:GetChildren()) do
                if v.Name == "DinoBone" then _tp(v.CFrame) end
            end
        end) end
    end
end)

Tabs.Prehistoric:AddToggle({ Name = "Auto Collect Dragon Eggs", Default = false, Callback = function(Value) _G.Prehis_DE = Value end })
spawn(function()
    while wait(Sec) do
        if _G.Prehis_DE then pcall(function()
            local eggs = workspace.Map.PrehistoricIsland.Core:FindFirstChild("SpawnedDragonEggs")
            if eggs and eggs:FindFirstChild("DragonEgg") then
                _tp(eggs.DragonEgg.Molten.CFrame)
                fireproximityprompt(eggs.DragonEgg.Molten.ProximityPrompt, 30)
            end
        end) end
    end
end)

-- ============================================================
-- SEA EVENT TAB
-- ============================================================
Tabs.SeaEvent:AddSection("Sea Event / Setting Sail")

local ListSeaBoat = {"Guardian", "PirateGrandBrigade", "MarineGrandBrigade", "PirateBrigade", "MarineBrigade", "PirateSloop", "MarineSloop", "Beast Hunter"}
local ListSeaZone = {"Lv 1", "Lv 2", "Lv 3", "Lv 4", "Lv 5", "Lv 6", "Lv Infinite"}

Tabs.SeaEvent:AddButton({ Name = "Remove Lighting Effect", Callback = function() game:GetService("Lighting").BaseAtmosphere:Destroy() end })

Tabs.SeaEvent:AddToggle({ Name = "Ship Speed Modifier", Default = false, Callback = function(Value) getgenv().SpeedBoat = Value end })
game:GetService("RunService").RenderStepped:Connect(function()
    if getgenv().SpeedBoat and SetSpeedBoat then
        if plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Sit then
            for _, boat in pairs(workspace.Boats:GetChildren()) do
                local seat = boat:FindFirstChildWhichIsA("VehicleSeat")
                if seat then seat.MaxSpeed = SetSpeedBoat end
            end
        end
    end
end)
Tabs.SeaEvent:AddSlider({ Name = "Ship Speed", Min = 0, Max = 1000, Increment = 1, Default = 300, Callback = function(Value) SetSpeedBoat = Value end })

Tabs.SeaEvent:AddToggle({ Name = "Auto Press W", Default = false, Callback = function(Value) getgenv().AutoPressW = Value end })
spawn(function()
    while wait() do
        pcall(function()
            if getgenv().AutoPressW then
                local hum = plr.Character:WaitForChild("Humanoid")
                if hum.Sit then game:GetService("VirtualInputManager"):SendKeyEvent(true, "W", false, game) end
            end
        end)
    end
end)

Tabs.SeaEvent:AddToggle({ Name = "No Clip Ship", Default = false, Callback = function(Value) getgenv().NoClipShip = Value end })
spawn(function()
    while wait() do
        pcall(function()
            for _, boat in pairs(workspace.Boats:GetChildren()) do
                for _, v in pairs(boat:GetDescendants()) do
                    if v:IsA("BasePart") then
                        if getgenv().NoClipShip or getgenv().FindPrehistoric then v.CanCollide = false
                        else v.CanCollide = true end
                    end
                end
            end
        end)
    end
end)

Tabs.SeaEvent:AddSection("Crafting Items")
Tabs.SeaEvent:AddButton({ Name = "Craft SharkTooth", Callback = function() replicated.Remotes.CommF_:InvokeServer("CraftItem", "Craft", "SharkTooth") end })
Tabs.SeaEvent:AddButton({ Name = "Craft TerrorJaw", Callback = function() replicated.Remotes.CommF_:InvokeServer("CraftItem", "Craft", "TerrorJaw") end })
Tabs.SeaEvent:AddButton({ Name = "Craft SharkAnchor", Callback = function() replicated.Remotes.CommF_:InvokeServer("CraftItem", "Craft", "SharkAnchor") end })
Tabs.SeaEvent:AddButton({ Name = "Craft LeviathanCrown", Callback = function() replicated.Remotes.CommF_:InvokeServer("CraftItem", "Craft", "LeviathanCrown") end })
Tabs.SeaEvent:AddButton({ Name = "Craft LeviathanShield", Callback = function() replicated.Remotes.CommF_:InvokeServer("CraftItem", "Craft", "LeviathanShield") end })
Tabs.SeaEvent:AddButton({ Name = "Craft LeviathanBoat", Callback = function() replicated.Remotes.CommF_:InvokeServer("CraftItem", "Craft", "LeviathanBoat") end })

Tabs.SeaEvent:AddSection("Choose Sea Event")
Tabs.SeaEvent:AddDropdown({ Name = "Select Boats", Options = ListSeaBoat, Callback = function(Value) _G.SelectedBoat = Value end })
Tabs.SeaEvent:AddButton({ Name = "Buy Boats", Callback = function() replicated.Remotes.CommF_:InvokeServer("BuyBoat", _G.SelectedBoat) end })
Tabs.SeaEvent:AddDropdown({ Name = "Select Sea Level", Options = ListSeaZone, Callback = function(Value) _G.DangerSc = Value end })

Tabs.SeaEvent:AddToggle({ Name = "Auto Sail Boat", Default = false, Callback = function(Value) _G.SailBoats = Value end })
spawn(function()
    while wait() do
        if _G.SailBoats then pcall(function()
            local myBoat = CheckBoat()
            local anySeaEvent = (CheckShark() and _G.Shark) or (CheckTerrorShark() and _G.TerrorShark) or (CheckFishCrew() and _G.MobCrew) or (CheckPiranha() and _G.Piranha) or (CheckEnemiesBoat() and _G.FishBoat) or (CheckSeaBeast() and _G.SeaBeast1) or (_G.PGB and CheckPirateGrandBrigade()) or (_G.HCM and CheckHauntedCrew()) or (_G.Leviathan1 and CheckLeviathan())
            if not myBoat and not anySeaEvent then
                local buyBoatCFrame = CFrame.new(-16927.451, 9.086, 433.864)
                TeleportToTarget(buyBoatCFrame)
                if (buyBoatCFrame.Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 10 then
                    replicated.Remotes.CommF_:InvokeServer("BuyBoat", _G.SelectedBoat)
                end
            elseif myBoat and not anySeaEvent then
                if plr.Character.Humanoid.Sit == false then
                    _tp(myBoat.VehicleSeat.CFrame * CFrame.new(0, 1, 0))
                else
                    local zoneCF = {
                        ["Lv 1"] = CFrame.new(-21998.375, 30.0006084, -682.309143),
                        ["Lv 2"] = CFrame.new(-26779.5215, 30.0005474, -822.858032),
                        ["Lv 3"] = CFrame.new(-31171.957, 30.0001011, -2256.93774),
                        ["Lv 4"] = CFrame.new(-34054.6875, 30.2187767, -2560.12012),
                        ["Lv 5"] = CFrame.new(-38887.5547, 30.0004578, -2162.99023),
                        ["Lv 6"] = CFrame.new(-44541.7617, 30.0003204, -1244.8584),
                        ["Lv Infinite"] = CFrame.new(-10000000, 31, 37016.25)
                    }
                    local CFrameSelectedZone = zoneCF[_G.DangerSc or "Lv 1"]
                    repeat wait()
                        if (not _G.FishBoat and CheckEnemiesBoat()) or (not _G.PGB and CheckPirateGrandBrigade()) or (not _G.TerrorShark and CheckTerrorShark()) then
                            _tp(CFrameSelectedZone * CFrame.new(0, 150, 0))
                        else _tp(CFrameSelectedZone) end
                    until _G.SailBoats == false or (CheckShark() and _G.Shark) or (CheckTerrorShark() and _G.TerrorShark) or (CheckFishCrew() and _G.MobCrew) or (CheckPiranha() and _G.Piranha) or (CheckSeaBeast() and _G.SeaBeast1) or (CheckEnemiesBoat() and _G.FishBoat) or (_G.PGB and CheckPirateGrandBrigade()) or plr.Character.Humanoid.Sit == false
                    plr.Character.Humanoid.Sit = false
                end
            end
        end) end
    end
end)

Tabs.SeaEvent:AddSection("Entity Sea Event")
Tabs.SeaEvent:AddToggle({ Name = "Auto Shark", Default = false, Callback = function(Value) _G.Shark = Value end })
Tabs.SeaEvent:AddToggle({ Name = "Auto Piranha", Default = false, Callback = function(Value) _G.Piranha = Value end })
Tabs.SeaEvent:AddToggle({ Name = "Auto Terror Shark", Default = false, Callback = function(Value) _G.TerrorShark = Value end })
Tabs.SeaEvent:AddToggle({ Name = "Auto Fish Crew Member", Default = false, Callback = function(Value) _G.MobCrew = Value end })
Tabs.SeaEvent:AddToggle({ Name = "Auto Haunted Crew Member", Default = false, Callback = function(Value) _G.HCM = Value end })
Tabs.SeaEvent:AddToggle({ Name = "Auto Attack PirateGrandBrigade", Default = false, Callback = function(Value) _G.PGB = Value end })
Tabs.SeaEvent:AddToggle({ Name = "Auto Attack Fish Boat", Default = false, Callback = function(Value) _G.FishBoat = Value end })
Tabs.SeaEvent:AddToggle({ Name = "Auto Attack Sea Beast", Default = false, Callback = function(Value) _G.SeaBeast1 = Value end })
Tabs.SeaEvent:AddToggle({ Name = "Auto Attack Leviathan", Default = false, Callback = function(Value) _G.Leviathan1 = Value end })

spawn(function()
    while wait() do
        pcall(function()
            local checkList = {
                {flag = _G.Shark, name = "Shark", check = CheckShark},
                {flag = _G.TerrorShark, name = "Terrorshark", check = CheckTerrorShark, sea = true},
                {flag = _G.Piranha, name = "Piranha", check = CheckPiranha},
                {flag = _G.MobCrew, name = "Fish Crew Member", check = CheckFishCrew},
                {flag = _G.HCM, name = "Haunted Crew Member", check = CheckHauntedCrew}
            }
            for _, cfg in ipairs(checkList) do
                if cfg.flag and cfg.check() then
                    for _, enemy in pairs(workspace.Enemies:GetChildren()) do
                        if enemy.Name == cfg.name and Attack.Alive(enemy) then
                            repeat task.wait()
                                if cfg.sea then Attack.KillSea(enemy, cfg.flag) else Attack.Kill(enemy, cfg.flag) end
                            until not cfg.flag or not enemy.Parent or enemy.Humanoid.Health <= 0
                        end
                    end
                end
            end
            if _G.SeaBeast1 and workspace.SeaBeasts:FindFirstChild("SeaBeast1") then
                for _, b in pairs(workspace.SeaBeasts:GetChildren()) do
                    if b:FindFirstChild("HumanoidRootPart") and b:FindFirstChild("Health") and b.Health.Value > 0 then
                        repeat task.wait()
                            _tp(CFrame.new(b.HumanoidRootPart.Position.X, workspace.Map["WaterBase-Plane"].Position.Y + 200, b.HumanoidRootPart.Position.Z))
                        until _G.SeaBeast1 == false or not b.Parent or b.Health.Value <= 0
                    end
                end
            end
            if _G.Leviathan1 and workspace.SeaBeasts:FindFirstChild("Leviathan") then
                for _, b in pairs(workspace.SeaBeasts:GetChildren()) do
                    if b.Name == "Leviathan" and b:FindFirstChild("HumanoidRootPart") and b.Health.Value > 0 then
                        repeat task.wait()
                            _tp(CFrame.new(b.HumanoidRootPart.Position.X, workspace.Map["WaterBase-Plane"].Position.Y + 200, b.HumanoidRootPart.Position.Z))
                        until _G.Leviathan1 == false or not b.Parent or b.Health.Value <= 0
                    end
                end
            end
        end)
    end
end)

-- ============================================================
-- RAIDS TAB
-- ============================================================
Tabs.Raids:AddSection("Fruits Options")

local function formatNumber(number)
    local str = tostring(number)
    repeat local replaced, count = str:gsub("^(-?%d+)(%d%d%d)", "%1,%2"); str = replaced until count == 0
    return str
end

RandomFF = Tabs.Raids:AddToggle({ Name = "Auto Random Fruit", Default = false, Callback = function(Value) _G.Random_Auto = Value end })
spawn(function()
    while wait(Sec) do pcall(function() if _G.Random_Auto then replicated.Remotes.CommF_:InvokeServer("Cousin", "Buy") end end) end
end)

DropF = Tabs.Raids:AddToggle({ Name = "Auto Drop Fruit", Default = false, Callback = function(Value) _G.DropFruit = Value end })
spawn(function()
    while wait(Sec) do if _G.DropFruit then pcall(function() DropFruits() end) end end
end)

StoredF = Tabs.Raids:AddToggle({ Name = "Auto Store Fruit", Default = false, Callback = function(Value) _G.StoreF = Value end })
spawn(function()
    while wait(Sec) do if _G.StoreF then pcall(function() UpdStFruit() end) end end
end)

TwF = Tabs.Raids:AddToggle({ Name = "Auto Tween to Fruit", Default = false, Callback = function(Value) _G.TwFruits = Value end })
spawn(function()
    while wait(Sec) do
        if _G.TwFruits then pcall(function()
            for _, x1 in pairs(workspace:GetChildren()) do
                if string.find(x1.Name, "Fruit") then _tp(x1.Handle.CFrame) end
            end
        end) end
    end
end)

BringF = Tabs.Raids:AddToggle({ Name = "Auto Collect Fruit", Default = false, Callback = function(Value) _G.InstanceF = Value end })
spawn(function()
    while wait(Sec) do if _G.InstanceF then pcall(function() collectFruits(_G.InstanceF) end) end end
end)

-- DUNGEON
Tabs.Raids:AddSection("Dungeon Event / Raiding")
DungeonTables = {"Flame", "Ice", "Quake", "Light", "Dark", "String", "Rumble", "Magma", "Human: Buddha", "Sand", "Bird: Phoenix", "Dough"}
Q = Tabs.Raids:AddDropdown({ Name = "Select Chip", Options = DungeonTables, Callback = function(Value) _G.SelectChip = Value end })

Tabs.Raids:AddButton({ Name = "Buy Dungeon Chips [Beli]", Callback = function()
    if not GetBP("Special Microchip") then replicated.Remotes.CommF_:InvokeServer("RaidsNpc", "Select", _G.SelectChip) end
end })

AutoChipBeli = Tabs.Raids:AddToggle({ Name = "Auto Buy Chip [Beli]", Default = false, Callback = function(Value) _G.AutoChipBeli = Value end })
task.spawn(function()
    while task.wait(1) do if _G.AutoChipBeli then pcall(function()
        if not GetBP("Special Microchip") then replicated.Remotes.CommF_:InvokeServer("RaidsNpc", "Select", _G.SelectChip) end
    end) end end
end)

StartR = Tabs.Raids:AddToggle({ Name = "Auto Start Raid", Default = false, Callback = function(Value) _G.Auto_StartRaid = Value end })
task.spawn(function()
    while task.wait(Sec) do
        if _G.Auto_StartRaid then pcall(function()
            local top = plr.PlayerGui.Main:FindFirstChild("TopHUDList")
            if not top or top.RaidTimer.Visible then return end
            if not GetBP("Special Microchip") then return end
            if World2 then
                local btn = workspace.Map.CircleIsland.RaidSummon2.Button.Main
                if btn then
                    if btn:FindFirstChild("ProximityPrompt") then fireproximityprompt(btn.ProximityPrompt)
                    elseif btn:FindFirstChild("ClickDetector") then fireclickdetector(btn.ClickDetector) end
                end
            elseif World3 then
                local btn = workspace.Map["Boat Castle"].RaidSummon2.Button.Main
                if btn then
                    if btn:FindFirstChild("ProximityPrompt") then fireproximityprompt(btn.ProximityPrompt)
                    elseif btn:FindFirstChild("ClickDetector") then fireclickdetector(btn.ClickDetector) end
                end
            end
        end) end
    end
end)

Raiding = Tabs.Raids:AddToggle({ Name = "Auto Raid + Next Island", Default = false, Callback = function(Value) _G.Raiding = Value end })
spawn(function()
    local islands = {"Island 1", "Island 2", "Island 3", "Island 4", "Island 5"}
    local currentIsland = nil
    while task.wait(0.3) do
        if not _G.Raiding then continue end
        local gui = plr.PlayerGui.Main.TopHUDList.RaidTimer
        if not gui.Visible then continue end
        local char = plr.Character
        if not char then continue end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not root or not hum or hum.Health <= 0 or hum.Sit then continue end
        local locations = workspace["_WorldOrigin"].Locations
        local closestDist = 999999
        for _, name in ipairs(islands) do
            local loc = locations:FindFirstChild(name)
            if loc then
                local dist = (root.Position - loc.Position).Magnitude
                if dist < closestDist then closestDist = dist; currentIsland = name end
            end
        end
        if not currentIsland then continue end
        local islandPos = locations:FindFirstChild(currentIsland)
        if not islandPos then continue end
        local foundEnemies = false
        for _, mob in ipairs(workspace.Enemies:GetChildren()) do
            local eh = mob:FindFirstChild("Humanoid")
            local ehrp = mob:FindFirstChild("HumanoidRootPart")
            if eh and ehrp and eh.Health > 0 and (ehrp.Position - islandPos.Position).Magnitude < 450 then
                foundEnemies = true
                repeat task.wait() Attack.Kill(mob, _G.Raiding) until not _G.Raiding or not mob.Parent or eh.Health <= 0
            end
        end
        if not foundEnemies then
            local idx = table.find(islands, currentIsland)
            if idx and islands[idx + 1] then
                local nxt = locations:FindFirstChild(islands[idx + 1])
                if nxt then _tp(nxt.CFrame * CFrame.new(0, 45, 120)) end
                currentIsland = islands[idx + 1]
                task.wait(1)
            end
        end
    end
end)

Tabs.Raids:AddToggle({ Name = "Auto Awakening", Default = false, Callback = function(Value) _G.Auto_Awakener = Value end })
spawn(function()
    while wait(Sec) do pcall(function()
        if _G.Auto_Awakener then
            replicated.Remotes.CommF_:InvokeServer("Awakener", "Check")
            replicated.Remotes.CommF_:InvokeServer("Awakener", "Awaken")
        end
    end) end
end)

Tabs.Raids:AddToggle({ Name = "Auto Teleport To Lab", Default = false, Callback = function(Value) _G.TpLab = Value end })
spawn(function()
    while wait() do
        if _G.TpLab then
            if World2 then _tp(CFrame.new(-6438.73535, 250.645355, -4501.50684))
            elseif World3 then _tp(CFrame.new(-5017.40869, 314.844055, -2823.0127)) end
        end
    end
end)

Tabs.Raids:AddSection("Items Law/Order Sword")
Tabs.Raids:AddButton({ Name = "Buy Microchip Law", Callback = function() replicated.Remotes.CommF_:InvokeServer("BlackbeardReward", "Microchip", "2") end })
Tabs.Raids:AddButton({ Name = "Start Law Raids", Callback = function() fireclickdetector(workspace.Map.CircleIsland.RaidSummon.Button.Main.ClickDetector) end })
Tabs.Raids:AddToggle({ Name = "Auto Kill Law", Default = false, Callback = function(Value) _G.AutoLawKak = Value end })
spawn(function()
    while wait(Sec) do if _G.AutoLawKak then pcall(function()
        local v = GetConnectionEnemies("Order")
        if v then repeat task.wait() Attack.Kill(v, _G.AutoLawKak) until _G.AutoLawKak == false or not v.Parent or v.Humanoid.Health <= 0
        else _tp(CFrame.new(-6217.2021484375, 28.047645568848, -5053.1357421875)) end
    end) end end
end)

-- ============================================================
-- COMBAT TAB
-- ============================================================
Tabs.Combat:AddSection("Combat / AimBot")
local __indexPlayer = Tabs.Combat:AddParagraph("All Players On Server", "")
spawn(function()
    while wait(Sec) do pcall(function()
        local playerCount = #game:GetService("Players"):GetPlayers()
        __indexPlayer:SetDesc("All Players : " .. playerCount .. " / 12" .. (playerCount >= 12 and " [Max]" or ""))
    end) end
end)

local PlrList = {}
for _, v in pairs(game:GetService("Players"):GetChildren()) do table.insert(PlrList, v.Name) end
Tabs.Combat:AddDropdown({ Name = "Select Players", Options = PlrList, Callback = function(Value) _G.PlayersList = Value end })

Tabs.Combat:AddToggle({ Name = "Teleport To Select Players", Default = false, Callback = function(Value)
    _G.TpPly = Value
    spawn(function()
        pcall(function()
            while _G.TpPly do
                wait()
                local p = game:GetService("Players")[_G.PlayersList]
                if p and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then _tp(p.Character.HumanoidRootPart.CFrame) end
            end
        end)
    end)
end })

Tabs.Combat:AddDropdown({ Name = "Select Aim Method", Options = {"Aim Player", "Nearest Aim"}, Callback = function(Value) ABmethod = Value end })
Tabs.Combat:AddToggle({ Name = "Aimbot Method Skills", Default = false, Callback = function(Value) _G.AimMethod = Value end })

-- FLY
local flying = false
local flySpeed = 50
local flyConnection, bg, bv, ctrl = nil, nil, nil, {f = 0, b = 0, l = 0, r = 0}
local function toggleFly(value)
    flying = value
    if flying then
        if not plr.Character then return end
        local hum = plr.Character:FindFirstChildOfClass("Humanoid")
        local rootPart = plr.Character:FindFirstChild("Torso") or plr.Character:FindFirstChild("UpperTorso")
        if not hum or not rootPart then return end
        for _, part in ipairs(plr.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false; part.Massless = true end
        end
        bg = Instance.new("BodyGyro", rootPart); bg.P = 9e4; bg.maxTorque = Vector3.new(9e9, 9e9, 9e9); bg.cframe = rootPart.CFrame
        bv = Instance.new("BodyVelocity", rootPart); bv.velocity = Vector3.new(0, 0, 0); bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
        hum.PlatformStand = true
        flyConnection = RunSer.Heartbeat:Connect(function()
            if not flying or not plr.Character then return end
            if ctrl.f ~= 0 or ctrl.b ~= 0 or ctrl.l ~= 0 or ctrl.r ~= 0 then
                bv.velocity = ((workspace.CurrentCamera.CoordinateFrame.lookVector * (ctrl.f + ctrl.b)) + ((workspace.CurrentCamera.CoordinateFrame * CFrame.new(ctrl.l + ctrl.r, (ctrl.f + ctrl.b) * 0.2, 0).p) - workspace.CurrentCamera.CoordinateFrame.p)) * flySpeed
            else bv.velocity = Vector3.new(0, 0, 0) end
            bg.cframe = workspace.CurrentCamera.CoordinateFrame
        end)
    else
        if flyConnection then flyConnection:Disconnect(); flyConnection = nil end
        if plr.Character then
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.PlatformStand = false end
            for _, part in ipairs(plr.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = true; part.Massless = false end
            end
        end
        if bg then bg:Destroy() end
        if bv then bv:Destroy() end
    end
end

Tabs.Combat:AddToggle({ Name = "Enable Fly", Default = false, Callback = function(Value) toggleFly(Value) end })
Tabs.Combat:AddSlider({ Name = "Speed Fly Mode", Min = 10, Max = 200, Default = 50, Callback = function(Value) flySpeed = Value end })

-- Instance abilities
Tabs.Combat:AddToggle({ Name = "Instance Mink V3 [ INF ]", Default = false, Callback = function(Value) InfAblities = Value end })
spawn(function()
    while wait(.2) do pcall(function()
        if InfAblities then
            if not plr.Character.HumanoidRootPart:FindFirstChild("Agility") then
                local agility = replicated.FX["Agility"]:Clone()
                agility.Name = "Agility"
                agility.Parent = plr.Character.HumanoidRootPart
            end
        elseif plr.Character.HumanoidRootPart:FindFirstChild("Agility") then
            plr.Character.HumanoidRootPart.Agility:Destroy()
        end
    end) end
end)

Tabs.Combat:AddToggle({ Name = "Instance Energy [ INF ]", Default = false, Callback = function(Value) infEnergy = Value; if Value then getInfinity_Ability("Energy", infEnergy) end end })
Tabs.Combat:AddToggle({ Name = "Instance Soru [ INF ]", Default = false, Callback = function(Value) _G.InfSoru = Value; if Value then getInfinity_Ability("Soru", _G.InfSoru) end end })
Tabs.Combat:AddToggle({ Name = "Instance Observation Range [ INF ]", Default = false, Callback = function(Value) _G.InfiniteObRange = Value; if Value then getInfinity_Ability("Observation", _G.InfiniteObRange) end end })
Tabs.Combat:AddToggle({ Name = "Ignore Same Teams", Default = false, Callback = function(Value) _G.NoAimTeam = Value end })

-- ============================================================
-- TRAVEL TAB
-- ============================================================
Tabs.Travel:AddSection("Travel - Worlds")
Tabs.Travel:AddButton({ Name = "Travel East Blue (World 1)", Callback = function() replicated.Remotes.CommF_:InvokeServer("TravelMain") end })
Tabs.Travel:AddButton({ Name = "Travel Dressrosa (World 2)", Callback = function() replicated.Remotes.CommF_:InvokeServer("TravelDressrosa") end })
Tabs.Travel:AddButton({ Name = "Travel Zou (World 3)", Callback = function() replicated.Remotes.CommF_:InvokeServer("TravelZou") end })

Tabs.Travel:AddSection("Travel - Island")
local Location = {}
for _, v in pairs(workspace["_WorldOrigin"].Locations:GetChildren()) do table.insert(Location, v.Name) end
Tabs.Travel:AddDropdown({ Name = "Select Travelling", Options = Location, Callback = function(Value) _G.Island = Value end })
Tabs.Travel:AddToggle({ Name = "Auto Travel", Default = false, Callback = function(Value)
    _G.Teleport = Value
    if Value then
        for _, v in pairs(workspace["_WorldOrigin"].Locations:GetChildren()) do
            if v.Name == _G.Island then
                repeat wait() _tp(v.CFrame * CFrame.new(0, 30, 0)) until not _G.Teleport or Root.CFrame == v.CFrame
            end
        end
    end
end })

Tabs.Travel:AddSection("Travel - Portal")
local Location_Portal = {}
if World1 then Location_Portal = {"Sky", "UnderWater"}
elseif World2 then Location_Portal = {"SwanRoom", "Cursed Ship"}
elseif World3 then Location_Portal = {"Castle On The Sea", "Mansion Cafe", "Hydra Teleport", "Canvendish Room", "Temple of Time"} end
Tabs.Travel:AddDropdown({ Name = "Select Portal", Options = Location_Portal, Callback = function(Value) _G.Island_PT = Value end })
Tabs.Travel:AddButton({ Name = "requestEntrance", Callback = function()
    local posMap = {
        Sky = Vector3.new(-7894, 5547, -380), UnderWater = Vector3.new(61163, 11, 1819),
        SwanRoom = Vector3.new(2285, 15, 905), ["Cursed Ship"] = Vector3.new(923, 126, 32852),
        ["Castle On The Sea"] = Vector3.new(-5097.93164, 316.447021, -3142.66602),
        ["Mansion Cafe"] = Vector3.new(-12471.169921875, 374.94024658203, -7551.677734375),
        ["Hydra Teleport"] = Vector3.new(5643.45263671875, 1013.0858154296875, -340.51025390625),
        ["Canvendish Room"] = Vector3.new(5314.54638671875, 22.562219619750977, -127.06755065917969),
        ["Temple of Time"] = Vector3.new(28310.0234, 14895.1123, 109.456741)
    }
    if _G.Island_PT and posMap[_G.Island_PT] then
        replicated.Remotes.CommF_:InvokeServer("requestEntrance", posMap[_G.Island_PT])
    end
end })

Tabs.Travel:AddSection("Travel - NPCs")
local NPCList = {}
for _, v in pairs(replicated.NPCs:GetChildren()) do table.insert(NPCList, v.Name) end
Tabs.Travel:AddDropdown({ Name = "Select NPCs", Options = NPCList, Callback = function(Value) NPClist = Value end })
Tabs.Travel:AddToggle({ Name = "Auto Tween to NPC", Default = false, Callback = function(Value) _G.TPNpc = Value end })
spawn(function()
    while wait(Sec) do
        if _G.TPNpc then pcall(function()
            for _, v in pairs(replicated.NPCs:GetChildren()) do
                if v.Name == NPClist then _tp(v.HumanoidRootPart.CFrame) end
            end
        end) end
    end
end)

-- ============================================================
-- SHOP TAB
-- ============================================================
Tabs.Shop:AddSection("Shop Options")
Tabs.Shop:AddButton({ Name = "Buy Buso", Callback = function() replicated.Remotes.CommF_:InvokeServer("BuyHaki", "Buso") end })
Tabs.Shop:AddButton({ Name = "Buy Geppo", Callback = function() replicated.Remotes.CommF_:InvokeServer("BuyHaki", "Geppo") end })
Tabs.Shop:AddButton({ Name = "Buy Soru", Callback = function() replicated.Remotes.CommF_:InvokeServer("BuyHaki", "Soru") end })
Tabs.Shop:AddButton({ Name = "Buy Ken", Callback = function() replicated.Remotes.CommF_:InvokeServer("KenTalk", "Buy") end })

Tabs.Shop:AddSection("Fighting - Style")
for name, args in pairs({
    ["Buy Black Leg"] = {"BuyBlackLeg"}, ["Buy Electro"] = {"BuyElectro"},
    ["Buy Fishman Karate"] = {"BuyFishmanKarate"}, ["Buy Superhuman"] = {"BuySuperhuman"},
    ["Buy Death Step"] = {"BuyDeathStep"}, ["Buy Sharkman Karate"] = {"BuySharkmanKarate"},
    ["Buy ElectricClaw"] = {"BuyElectricClaw"}, ["Buy DragonTalon"] = {"BuyDragonTalon"},
    ["Buy Godhuman"] = {"BuyGodhuman"}, ["Buy SanguineArt"] = {"BuySanguineArt"}
}) do
    Tabs.Shop:AddButton({ Name = name, Callback = function() replicated.Remotes.CommF_:InvokeServer(unpack(args)) end })
end
Tabs.Shop:AddButton({ Name = "Buy DragonClaw", Callback = function() replicated.Remotes.CommF_:InvokeServer("BlackbeardReward", "DragonClaw", "2") end })

Tabs.Shop:AddSection("Accessory")
for name, args in pairs({
    ["Buy Tomoe Ring"] = {"BuyItem", "Tomoe Ring"}, ["Buy Black Cape"] = {"BuyItem", "Black Cape"},
    ["Buy Swordsman Hat"] = {"BuyItem", "Swordsman Hat"}
}) do
    Tabs.Shop:AddButton({ Name = name, Callback = function() replicated.Remotes.CommF_:InvokeServer(unpack(args)) end })
end
Tabs.Shop:AddButton({ Name = "Buy Bizarre Rifle", Callback = function() replicated.Remotes.CommF_:InvokeServer("Ectoplasm", "Buy", 1) end })
Tabs.Shop:AddButton({ Name = "Buy Ghoul Mask", Callback = function() replicated.Remotes.CommF_:InvokeServer("Ectoplasm", "Buy", 2) end })

Tabs.Shop:AddSection("Weapon World1")
local weapons = {"Cutlass", "Katana", "Iron Mace", "Duel Katana", "Triple Katana", "Pipe", "Dual-Headed Blade", "Bisento", "Soul Cane", "Slingshot", "Musket", "Dual Flintlock", "Flintlock", "Refined Flintlock", "Cannon"}
for _, w in ipairs(weapons) do
    Tabs.Shop:AddButton({ Name = "Buy " .. w, Callback = function() replicated.Remotes.CommF_:InvokeServer("BuyItem", w) end })
end
Tabs.Shop:AddButton({ Name = "Buy Kabucha", Callback = function() replicated.Remotes.CommF_:InvokeServer("BlackbeardReward", "Slingshot", "2") end })

Tabs.Shop:AddSection("Fragments shop")
Tabs.Shop:AddButton({ Name = "Buy Refund Stats", Callback = function() replicated.Remotes.CommF_:InvokeServer("BlackbeardReward", "Refund", "2") end })
Tabs.Shop:AddButton({ Name = "Buy Reroll Race", Callback = function() replicated.Remotes.CommF_:InvokeServer("BlackbeardReward", "Reroll", "2") end })
Tabs.Shop:AddButton({ Name = "Buy Ghoul Race", Callback = function() replicated.Remotes.CommF_:InvokeServer("Ectoplasm", " Change", 4) end })
Tabs.Shop:AddButton({ Name = "Buy Cyborg Race (2.5k)", Callback = function() replicated.Remotes.CommF_:InvokeServer("CyborgTrainer", " Buy") end })

-- ============================================================
-- MISC TAB
-- ============================================================
Tabs.Misc:AddSection("Server - Function")
Tabs.Misc:AddButton({ Name = "Redeem All Codes", Callback = function()
    local codes = {"LIGHTNINGABUSE", "1LOSTADMIN", "ADMINFIGHT", "GIFTING_HOURS", "NOMOREHACK", "BANEXPLOIT", "WildDares", "BossBuild", "GetPranked", "EARN_FRUITS", "SUB2GAMERROBOT_RESET1", "KITT_RESET", "Bignews", "CHANDLER", "Fudd10", "fudd10_v2", "Sub2UncleKizaru", "FIGHT4FRUIT", "kittgaming", "TRIPLEABUSE", "Sub2CaptainMaui", "Sub2Fer999", "Enyu_is_Pro", "Magicbus", "JCWK", "Starcodeheo", "Bluxxy", "SUB2GAMERROBOT_EXP1", "Sub2NoobMaster123", "Sub2Daigrock", "Axiore", "TantaiGaming", "StrawHatMaine", "Sub2OfficialNoobie", "TheGreatAce", "JULYUPDATE_RESET", "ADMINHACKED", "SEATROLLING", "24NOADMIN", "ADMIN_TROLL", "NEWTROLL", "SECRET_ADMIN", "staffbattle", "NOEXPLOIT", "NOOB2ADMIN", "CODESLIDE", "fruitconcepts", "krazydares"}
    local RedeemRemote = replicated:WaitForChild("Remotes"):FindFirstChild("Redeem")
    if not RedeemRemote then return end
    for _, code in ipairs(codes) do
        task.wait(0)
        pcall(function()
            if RedeemRemote.InvokeServer then RedeemRemote:InvokeServer(code) else RedeemRemote:FireServer(code) end
        end)
    end
end })

Tabs.Misc:AddButton({ Name = "Rejoin Server", Callback = function() game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer) end })
Tabs.Misc:AddButton({ Name = "Hop Server", Callback = function()
    task.spawn(function()
        local HttpService = game:GetService("HttpService")
        local success, servers = pcall(function()
            return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")).data
        end)
        if success and servers then
            local targetServer
            for _, s in pairs(servers) do if s.playing < s.maxPlayers then targetServer = s.id end end
            if targetServer then pcall(function() game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, targetServer, plr) end) end
        end
    end)
end })

Tabs.Misc:AddTextBox({ Name = "Input Job Id", Placeholder = "Job ID", ClearOnFocus = true, Callback = function(Value) getgenv().Job = Value end })
Tabs.Misc:AddButton({ Name = "Teleport [Job ID]", Callback = function()
    if getgenv().Job and getgenv().Job ~= "" then
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, getgenv().Job, plr)
    end
end })
Tabs.Misc:AddButton({ Name = "Copy JobID", Callback = function() setclipboard(tostring(game.JobId)) end })

Tabs.Misc:AddSection("Player Gui / Others")
Tabs.Misc:AddButton({ Name = "Open Awakenings Expert", Callback = function() plr.PlayerGui.Main.AwakeningToggler.Visible = true end })
Tabs.Misc:AddButton({ Name = "Open Title Selection", Callback = function()
    replicated.Remotes.CommF_:InvokeServer("getTitles", true)
    plr.PlayerGui.Main.Titles.Visible = true
end })

Tabs.Misc:AddButton({ Name = "Set Pirate Team", Callback = function() Pirates() end })
Tabs.Misc:AddButton({ Name = "Set Marine Team", Callback = function() Marines() end })

Tabs.Misc:AddSection("Graphics / Haki Stats")
local HakiSt = {"State 0", "State 1", "State 2", "State 3", "State 4", "State 5"}
Tabs.Misc:AddDropdown({ Name = "Select Haki States", Options = HakiSt, Callback = function(Value) _G.SelectStateHaki = Value end })
Tabs.Misc:AddButton({ Name = "ChangeBusoStage", Callback = function()
    if _G.SelectStateHaki then
        local num = tonumber(_G.SelectStateHaki:match("%d+"))
        if num then replicated.Remotes.CommF_:InvokeServer("ChangeBusoStage", num) end
    end
end })

Tabs.Misc:AddButton({ Name = "Turn on Fast Mode", Callback = function()
    for _, zx in next, workspace:GetDescendants() do
        if table.find(Past, zx.ClassName) then zx.Material = "Plastic" end
    end
end })
Tabs.Misc:AddButton({ Name = "Turn on Low CPU", Callback = function() LowCpu() end })
Tabs.Misc:AddButton({ Name = "Remove Sky Fog", Callback = function()
    if Lighting:FindFirstChild("LightingLayers") then Lighting.LightingLayers:Destroy() end
    if Lighting:FindFirstChild("FantasySky") then Lighting.FantasySky:Destroy() end
end })

Tabs.Misc:AddToggle({ Name = "Full Bright", Default = false, Callback = function(Value)
    if Value then
        Lighting.Ambient = Color3.new(1, 1, 1)
        Lighting.ColorShift_Bottom = Color3.new(1, 1, 1)
        Lighting.ColorShift_Top = Color3.new(1, 1, 1)
    else
        Lighting.Ambient = Color3.new(0, 0, 0)
        Lighting.ColorShift_Bottom = Color3.new(0, 0, 0)
        Lighting.ColorShift_Top = Color3.new(0, 0, 0)
    end
end })

Tabs.Misc:AddToggle({ Name = "Walk on Water", Default = true, Callback = function(Value)
    _G.WalkWater_Part = Value
    if _G.WalkWater_Part then game.Workspace.Map["WaterBase-Plane"].Size = Vector3.new(1000, 112, 1000)
    else game.Workspace.Map["WaterBase-Plane"].Size = Vector3.new(1000, 80, 1000) end
end })

-- ============================================================
-- NOTIFICATIONS
-- ============================================================
local Alurt
pcall(function()
    Alurt = loadstring(game:HttpGet("https://raw.githubusercontent.com/azir-py/project/refs/heads/main/Zwolf/AlurtUI.lua"))()
    getgenv().HuyPhamHubAlurt = Alurt
end)

task.spawn(function()
    if not Alurt or not Alurt.CreateNode then
        pcall(function()
            Window:Notify({ Title = "Welcome to Huy Pham Hub!", Content = "Thanks you for use", Duration = 5 })
        end)
        return
    end
    Alurt.CreateNode({
        Title = "Welcome to Huy Pham Hub!",
        Content = "Thanks you for use",
        Audio = "rbxassetid://17525305988",
        Length = 8,
        Image = "rbxassetid://17616650704",
        BarColor = Color3.fromRGB(255, 255, 255),
    })
    task.wait(2)
    Alurt.CreateNode({
        Title = "Script beta nên còn lỗi nhé",
        Content = "",
        Audio = "rbxassetid://17208361335",
        Length = 4,
        Image = "rbxassetid://6031068421",
        BarColor = Color3.fromRGB(200, 200, 200),
    })
end)

-- ============================================================
-- BILLBOARD TÊN TRÊN ĐẦU NHÂN VẬT
-- ============================================================
local TEXT = "@HuyPhamHub"
local TEXT_SIZE = 14
local GUI_OFFSET = Vector3.new(0, 1.8, 0)

local function createBillboardFor(character)
    if not character then return end
    local head = character:FindFirstChild("Head") or character:FindFirstChildWhichIsA("BasePart")
    if not head then return end
    local existing = head:FindFirstChild("HuyPhamHub_Label")
    if existing then existing:Destroy() end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "HuyPhamHub_Label"
    billboard.Adornee = head
    billboard.AlwaysOnTop = true
    billboard.Size = UDim2.new(0, 200, 0, 40)
    billboard.StudsOffset = GUI_OFFSET
    billboard.Parent = head

    local textLabel = Instance.new("TextLabel")
    textLabel.Name = "Label"
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = TEXT
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.TextSize = TEXT_SIZE
    textLabel.TextStrokeTransparency = 0.6
    textLabel.TextTransparency = 0
    textLabel.TextScaled = false
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.Parent = billboard
end

local function onCharacterAdded(character)
    if not character.Parent then character.AncestryChanged:Wait() end
    wait(0.1)
    createBillboardFor(character)
end

if plr.Character then onCharacterAdded(plr.Character) end
plr.CharacterAdded:Connect(onCharacterAdded)

-- ============================================================
-- HOÀN TẤT
-- ============================================================
print("[Huy Pham Hub] Loaded successfully! Version 1.0")
