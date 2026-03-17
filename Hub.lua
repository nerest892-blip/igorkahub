-- KEY SYSTEM
local allowed = {
	["PmTbsiYAgaQJ18NaJU"] = true
}

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()

-- KEY GUI
local keyGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
keyGui.ResetOnSpawn = false

local keyFrame = Instance.new("Frame", keyGui)
keyFrame.Size = UDim2.new(0,220,0,130)
keyFrame.Position = UDim2.new(0.4,0,0.4,0)
keyFrame.BackgroundColor3 = Color3.fromRGB(25,0,45)
Instance.new("UICorner", keyFrame)

local keyBox = Instance.new("TextBox", keyFrame)
keyBox.Size = UDim2.new(1,-20,0,40)
keyBox.Position = UDim2.new(0,10,0,20)
keyBox.PlaceholderText = "Enter Key..."
keyBox.Font = Enum.Font.GothamBold
keyBox.TextColor3 = Color3.new(1,1,1)
keyBox.BackgroundColor3 = Color3.fromRGB(50,0,90)
Instance.new("UICorner", keyBox)

local keyBtn = Instance.new("TextButton", keyFrame)
keyBtn.Size = UDim2.new(1,-20,0,30)
keyBtn.Position = UDim2.new(0,10,0,70)
keyBtn.Text = "UNLOCK"
keyBtn.Font = Enum.Font.GothamBold
keyBtn.TextColor3 = Color3.new(1,1,1)
keyBtn.BackgroundColor3 = Color3.fromRGB(70,0,130)
Instance.new("UICorner", keyBtn)

local unlocked = false

keyBtn.MouseButton1Click:Connect(function()
	if allowed[keyBox.Text] then
		unlocked = true
		keyGui:Destroy()
	else
		keyBtn.Text = "WRONG KEY"
	end
end)

repeat task.wait() until unlocked

-- OPTIMIZER (без зникнення світу)
for _,v in pairs(workspace:GetDescendants()) do
	if v:IsA("BasePart") then
		v.Material = Enum.Material.SmoothPlastic
	elseif v:IsA("Decal") or v:IsA("Texture") then
		v.Transparency = 0.3
	elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
		v.Enabled = false
	end
end

game:GetService("Lighting").Brightness = 1
game:GetService("Lighting").GlobalShadows = false
game:GetService("Lighting").FogEnd = 100000

-- SETTINGS
local autoKick = false
local speedOn = false
local espOn = false
local speedValue = 32
local spawnPos = char:WaitForChild("HumanoidRootPart").Position

-- GUI
local gui = Instance.new("ScreenGui")
gui.ResetOnSpawn = false
gui.Parent = player.PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,220,0,300)
frame.Position = UDim2.new(0.03,0,0.35,0)
frame.BackgroundColor3 = Color3.fromRGB(25,0,45)
frame.Active = true
frame.Parent = gui
Instance.new("UICorner",frame)

local stroke = Instance.new("UIStroke",frame)
stroke.Color = Color3.fromRGB(120,0,255)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,40)
title.BackgroundColor3 = Color3.fromRGB(50,0,90)
title.Text = "IGORKA HUB"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Parent = frame

local layout = Instance.new("UIListLayout",frame)
layout.Padding = UDim.new(0,8)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local function makeButton(text)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1,-16,0,36)
	b.BackgroundColor3 = Color3.fromRGB(70,0,130)
	b.Text = text
	b.TextColor3 = Color3.new(1,1,1)
	b.Font = Enum.Font.GothamBold
	b.TextSize = 14
	b.Parent = frame
	Instance.new("UICorner",b)
	return b
end

local autoKickBtn = makeButton("AUTO KICK OFF")
local instaBtn    = makeButton("INSTA STEAL")
local speedBtn    = makeButton("SPEED OFF")
local espBtn      = makeButton("ESP OFF")
local desyncBtn   = makeButton("DESYNC")

-- DRAG
local dragging=false
local dragStart
local startPos

title.InputBegan:Connect(function(input)
	if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
		dragging=true
		dragStart=input.Position
		startPos=frame.Position
	end
end)

UIS.InputChanged:Connect(function(input)
	if dragging then
		local delta=input.Position-dragStart
		frame.Position=UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset+delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset+delta.Y
		)
	end
end)

-- SPEED
speedBtn.MouseButton1Click:Connect(function()
	speedOn = not speedOn
	local hum = char:FindFirstChildOfClass("Humanoid")
	if hum then
		hum.WalkSpeed = speedOn and speedValue or 16
	end
	speedBtn.Text = speedOn and "SPEED ON" or "SPEED OFF"
end)

-- AUTO KICK
autoKickBtn.MouseButton1Click:Connect(function()
	autoKick = not autoKick
	autoKickBtn.Text = autoKick and "AUTO KICK ON" or "AUTO KICK OFF"
end)

-- DESYNC
desyncBtn.MouseButton1Click:Connect(function()
	player:LoadCharacter()
end)

-- ESP
local espObjects = {}

local function createESP(plr)
	if plr == player then return end
	local box = Drawing.new("Square")
	box.Thickness = 2
	box.Color = Color3.fromRGB(170,0,255)
	box.Filled = false

	local text = Drawing.new("Text")
	text.Size = 14
	text.Center = true
	text.Outline = true

	espObjects[plr] = {box, text}
end

for _,p in pairs(Players:GetPlayers()) do
	createESP(p)
end

Players.PlayerAdded:Connect(createESP)

RunService.RenderStepped:Connect(function()
	for plr,objs in pairs(espObjects) do
		if not espOn then
			objs[1].Visible=false
			objs[2].Visible=false
			continue
		end

		local c = plr.Character
		if c and c:FindFirstChild("HumanoidRootPart") then
			local pos,onscreen = workspace.CurrentCamera:WorldToViewportPoint(c.HumanoidRootPart.Position)

			if onscreen then
				local size = 60/(pos.Z/10)
				objs[1].Size = Vector2.new(size,size)
				objs[1].Position = Vector2.new(pos.X-size/2,pos.Y-size/2)
				objs[1].Visible = true

				objs[2].Text = plr.Name
				objs[2].Position = Vector2.new(pos.X,pos.Y-size/2-14)
				objs[2].Visible = true
			end
		end
	end
end)

espBtn.MouseButton1Click:Connect(function()
	espOn = not espOn
	espBtn.Text = espOn and "ESP ON" or "ESP OFF"
end)

-- INSTA STEAL
instaBtn.MouseButton1Click:Connect(function()
	local root = char:FindFirstChild("HumanoidRootPart")
	if not root then return end

	local distance = (root.Position - spawnPos).Magnitude
	local time = distance / 120

	local tween = TweenService:Create(root, TweenInfo.new(time, Enum.EasingStyle.Linear), {
		CFrame = CFrame.new(spawnPos)
	})

	tween:Play()

	if autoKick then
		task.delay(2.3,function()
			player:Kick("EZZZ STEAL WITH IGORKA HUB")
		end)
	end
end)

-- RESPAWN FIX
player.CharacterAdded:Connect(function(c)
	char = c
	task.wait(1)
	if speedOn then
		local hum = char:FindFirstChildOfClass("Humanoid")
		if hum then hum.WalkSpeed = speedValue end
	end
end)
