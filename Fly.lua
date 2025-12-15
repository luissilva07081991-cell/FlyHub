-- Fly UI FIXED (R15 / R6)
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local player = Players.LocalPlayer

local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")
local hrp = char:WaitForChild("HumanoidRootPart")

local flying = false
local speed = 60

local att, lv, ao

local function startFly()
	att = Instance.new("Attachment", hrp)

	lv = Instance.new("LinearVelocity", hrp)
	lv.Attachment0 = att
	lv.MaxForce = math.huge
	lv.VectorVelocity = Vector3.zero

	ao = Instance.new("AlignOrientation", hrp)
	ao.Attachment0 = att
	ao.MaxTorque = math.huge
	ao.Responsiveness = 15

	humanoid:ChangeState(Enum.HumanoidStateType.Physics)

	RS:BindToRenderStep("Fly", 0, function()
		local cam = workspace.CurrentCamera
		local move = Vector3.zero

		if UIS:IsKeyDown(Enum.KeyCode.W) then move += cam.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.S) then move -= cam.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.A) then move -= cam.CFrame.RightVector end
		if UIS:IsKeyDown(Enum.KeyCode.D) then move += cam.CFrame.RightVector end
		if UIS:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.new(0,1,0) end
		if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then move -= Vector3.new(0,1,0) end

		lv.VectorVelocity = move.Magnitude > 0 and move.Unit * speed or Vector3.zero
		ao.CFrame = cam.CFrame
	end)
end

local function stopFly()
	flying = false
	RS:UnbindFromRenderStep("Fly")

	if att then att:Destroy() end
	if lv then lv:Destroy() end
	if ao then ao:Destroy() end

	humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
end

-- UI simples (mantém compatível)
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,200,0,180)
frame.Position = UDim2.new(0,20,0.4,0)
frame.BackgroundColor3 = Color3.fromRGB(25,25,30)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,12)

local function btn(text,y)
	local b = Instance.new("TextButton", frame)
	b.Size = UDim2.new(1,-20,0,35)
	b.Position = UDim2.new(0,10,0,y)
	b.Text = text
	b.TextColor3 = Color3.new(1,1,1)
	b.BackgroundColor3 = Color3.fromRGB(50,50,60)
	b.Font = Enum.Font.GothamBold
	b.TextSize = 14
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,8)
	return b
end

local flyBtn = btn("ATIVAR FLY",10)
local plus = btn("VELOCIDADE +",55)
local minus = btn("VELOCIDADE -",100)
local close = btn("FECHAR",145)

flyBtn.MouseButton1Click:Connect(function()
	flying = not flying
	flyBtn.Text = flying and "DESATIVAR FLY" or "ATIVAR FLY"
	if flying then startFly() else stopFly() end
end)

plus.MouseButton1Click:Connect(function() speed += 10 end)
minus.MouseButton1Click:Connect(function() speed = math.max(20, speed - 10) end)

close.MouseButton1Click:Connect(function()
	stopFly()
	gui:Destroy()
end)