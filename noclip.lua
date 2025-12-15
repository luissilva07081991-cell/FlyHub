-- NOCLIP SIMPLES E FUNCIONAL

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()

local noclip = false
local connection

-- Função noclip
local function setNoclip(state)
	noclip = state

	if connection then
		connection:Disconnect()
		connection = nil
	end

	if noclip then
		connection = RunService.Stepped:Connect(function()
			for _,part in pairs(char:GetDescendants()) do
				if part:IsA("BasePart") then
					part.CanCollide = false
				end
			end
		end)
	else
		for _,part in pairs(char:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = true
			end
		end
	end
end

-- GUI
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,200,0,120)
frame.Position = UDim2.new(0,20,0.4,0)
frame.BackgroundColor3 = Color3.fromRGB(30,30,35)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,12)

local toggle = Instance.new("TextButton", frame)
toggle.Size = UDim2.new(1,-20,0,40)
toggle.Position = UDim2.new(0,10,0,20)
toggle.Text = "🟢 ATIVAR NOCLIP"
toggle.Font = Enum.Font.GothamBold
toggle.TextSize = 14
toggle.TextColor3 = Color3.new(1,1,1)
toggle.BackgroundColor3 = Color3.fromRGB(50,50,60)
Instance.new("UICorner", toggle).CornerRadius = UDim.new(0,8)

local close = Instance.new("TextButton", frame)
close.Size = UDim2.new(1,-20,0,30)
close.Position = UDim2.new(0,10,0,70)
close.Text = "FECHAR"
close.Font = Enum.Font.GothamBold
close.TextSize = 13
close.TextColor3 = Color3.fromRGB(255,100,100)
close.BackgroundColor3 = Color3.fromRGB(40,40,45)
Instance.new("UICorner", close).CornerRadius = UDim.new(0,8)

-- Botões
toggle.MouseButton1Click:Connect(function()
	noclip = not noclip
	setNoclip(noclip)
	toggle.Text = noclip and "🔴 DESATIVAR NOCLIP" or "🟢 ATIVAR NOCLIP"
end)

close.MouseButton1Click:Connect(function()
	setNoclip(false)
	gui:Destroy()
end)