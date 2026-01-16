local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local KillEmotes = {
    "None", "Vampire", "Impostor", "Rudolph's Revenge", "ACME", "Avra Kadoovra",
    "Barbarian", "Blood Sugar", "Frostbound Prison", "Curb Stomp", "Frost Breath",
    "Split Trap", "Possesion", "Gingerbread", "Heart Rip", "Figure Skater",
    "Baldie`s Demise", "Laser Eyes", "Mistletoe", "Naughtly List", "Neck Snap",
    "Orthax", "Surprise", "Goblin Bomb", "Selfie", "Serious Sneeze", "Smite",
    "Snowball Cannon", "Snowflakes", "Sore Winner", "Spine Breaker", "Think Mark",
    "Tree Topper Slice", "Werewolf", "Frozen Impalement", "Sick Burn",
    "Tinsel Strangie", "Wrap It Up", "Cauldron", "Bee", "Pollen Overload", "Glacial Burial"
}

local SelectedEmote = "None"
local SelectedSlot = 1
local SaveCurrent = false

local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "SimpleKillEmoteMenu"
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 260, 0, 360)
MainFrame.Position = UDim2.new(0.5, -130, 0.5, -180)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Text = "Simple kill emote"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.BackgroundTransparency = 1

RunService.RenderStepped:Connect(function()
    Title.TextColor3 = Color3.fromHSV(tick() % 5 / 5, 0.8, 1)
end)

local function StyleButton(btn)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 14
    Instance.new("UICorner", btn)
end

local EmoteBtn = Instance.new("TextButton", MainFrame)
EmoteBtn.Size = UDim2.new(0.9, 0, 0, 35)
EmoteBtn.Position = UDim2.new(0.05, 0, 0, 60)
EmoteBtn.Text = "Emote: None"
StyleButton(EmoteBtn)

local EmoteListFrame = Instance.new("ScrollingFrame", MainFrame)
EmoteListFrame.Size = UDim2.new(0.9, 0, 0, 160)
EmoteListFrame.Position = UDim2.new(0.05, 0, 0, 100)
EmoteListFrame.Visible = false
EmoteListFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
EmoteListFrame.ZIndex = 10
EmoteListFrame.ScrollBarThickness = 3
local UIList = Instance.new("UIListLayout", EmoteListFrame)
Instance.new("UICorner", EmoteListFrame)

for _, name in pairs(KillEmotes) do
    local b = Instance.new("TextButton", EmoteListFrame)
    b.Size = UDim2.new(1, 0, 0, 30)
    b.BackgroundTransparency = 1
    b.Text = name
    b.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    b.Font = Enum.Font.Gotham
    b.TextSize = 14
    b.ZIndex = 11
    b.MouseButton1Click:Connect(function()
        SelectedEmote = name
        EmoteBtn.Text = "Emote: " .. name
        EmoteListFrame.Visible = false
    end)
end
EmoteListFrame.CanvasSize = UDim2.new(0, 0, 0, UIList.AbsoluteContentSize.Y)

EmoteBtn.MouseButton1Click:Connect(function()
    EmoteListFrame.Visible = not EmoteListFrame.Visible
end)

local SlotBtn = Instance.new("TextButton", MainFrame)
SlotBtn.Size = UDim2.new(0.9, 0, 0, 35)
SlotBtn.Position = UDim2.new(0.05, 0, 0, 105)
SlotBtn.Text = "Slot: 1"
StyleButton(SlotBtn)

local SlotListFrame = Instance.new("Frame", MainFrame)
SlotListFrame.Size = UDim2.new(0.9, 0, 0, 120)
SlotListFrame.Position = UDim2.new(0.05, 0, 0, 145)
SlotListFrame.Visible = false
SlotListFrame.ZIndex = 12
SlotListFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Instance.new("UIListLayout", SlotListFrame)

for i = 1, 4 do
    local b = Instance.new("TextButton", SlotListFrame)
    b.Size = UDim2.new(1, 0, 0, 30)
    b.BackgroundTransparency = 1
    b.Text = "Slot " .. i
    b.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    b.ZIndex = 13
    b.TextSize = 14
    b.Font = Enum.Font.Gotham
    b.MouseButton1Click:Connect(function()
        SelectedSlot = i
        SlotBtn.Text = "Slot: " .. i
        SlotListFrame.Visible = false
    end)
end

SlotBtn.MouseButton1Click:Connect(function()
    SlotListFrame.Visible = not SlotListFrame.Visible
    EmoteListFrame.Visible = false
end)

local SaveBtn = Instance.new("TextButton", MainFrame)
SaveBtn.Size = UDim2.new(0.9, 0, 0, 35)
SaveBtn.Position = UDim2.new(0.05, 0, 0, 150)
SaveBtn.Text = "Save current emotes: OFF"
StyleButton(SaveBtn)

SaveBtn.MouseButton1Click:Connect(function()
    SaveCurrent = not SaveCurrent
    SaveBtn.Text = "Save current emotes: " .. (SaveCurrent and "ON" or "OFF")
    SaveBtn.TextColor3 = SaveCurrent and Color3.new(0, 1, 0) or Color3.new(1, 1, 1)
end)

local function GetFinalTable()
    local res = {{"Emote", "None"}, {"Emote", "None"}, {"Emote", "None"}, {"Emote", "None"}, true, true, true, true}
    if SaveCurrent then
        local s, decoded = pcall(function() return HttpService:JSONDecode(LocalPlayer.Data.EmoteEquipped.Value) end)
        if s then for i = 1, 4 do if decoded[i] then res[i] = decoded[i] end end end
    end
    res[SelectedSlot] = {"KillEmote", SelectedEmote}
    return res
end

local ApplyBtn = Instance.new("TextButton", MainFrame)
ApplyBtn.Size = UDim2.new(0.9, 0, 0, 45)
ApplyBtn.Position = UDim2.new(0.05, 0, 0, 210)
ApplyBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 120)
ApplyBtn.Text = "Apply emotes"
StyleButton(ApplyBtn)
ApplyBtn.Font = Enum.Font.GothamBold

local CopyBtn = Instance.new("TextButton", MainFrame)
CopyBtn.Size = UDim2.new(0.9, 0, 0, 45)
CopyBtn.Position = UDim2.new(0.05, 0, 0, 265)
CopyBtn.Text = "Copy as a script"
StyleButton(CopyBtn)
CopyBtn.Font = Enum.Font.GothamBold

ApplyBtn.MouseButton1Click:Connect(function()
    LocalPlayer.Data.EmoteEquipped.Value = HttpService:JSONEncode(GetFinalTable())
end)

CopyBtn.MouseButton1Click:Connect(function()
    local jsonStr = HttpService:JSONEncode(GetFinalTable())
    if setclipboard then setclipboard('game:GetService("Players").LocalPlayer.Data.EmoteEquipped.Value = [=[' .. jsonStr .. ']=]') end
end)
