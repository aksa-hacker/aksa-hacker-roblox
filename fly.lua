local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local FlyButton = Instance.new("TextButton")
local SpeedUp = Instance.new("TextButton")
local SpeedDown = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")
local UIGradient = Instance.new("UIGradient")

-- Setup GUI
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
MainFrame.Name = "AksaFlyPremium"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MainFrame.Position = UDim2.new(0.1, 0, 0.4, 0)
MainFrame.Size = UDim2.new(0, 160, 0, 200)
MainFrame.Active = true
MainFrame.Draggable = true

UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

-- Efek Warna Gradasi (RGB Style)
UIGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(170, 0, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 170, 255))
}
UIGradient.Parent = MainFrame

-- Animasi Warna Berjalan
spawn(function()
    while true do
        for i = 0, 1, 0.01 do
            UIGradient.Offset = Vector2.new(i, 0)
            task.wait(0.05)
        end
    end
end)

Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "AKSA EXECUTOR"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.BackgroundTransparency = 1

local function StyleButton(btn, pos, text)
    btn.Parent = MainFrame
    btn.Size = UDim2.new(0.85, 0, 0, 35)
    btn.Position = pos
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.Gotham
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
end

StyleButton(FlyButton, UDim2.new(0.075, 0, 0.25, 0), "FLY: OFF")
StyleButton(SpeedUp, UDim2.new(0.075, 0, 0.5, 0), "SPEED +")
StyleButton(SpeedDown, UDim2.new(0.075, 0, 0.75, 0), "SPEED -")

-- Logic Terbang
local player = game.Players.LocalPlayer
local flying = false
local speed = 50
local bv, bg

FlyButton.MouseButton1Click:Connect(function()
    flying = not flying
    FlyButton.Text = flying and "FLY: ON" or "FLY: OFF"
    FlyButton.BackgroundColor3 = flying and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(40, 40, 40)
    
    local character = player.Character
    if not character then return end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    
    if flying then
        bg = Instance.new("BodyGyro", hrp)
        bg.P = 9e4
        bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
        bg.cframe = hrp.CFrame
        
        bv = Instance.new("BodyVelocity", hrp)
        bv.velocity = Vector3.new(0, 0.1, 0)
        bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
        
        spawn(function()
            while flying do
                task.wait()
                bv.velocity = (workspace.CurrentCamera.CFrame.LookVector * speed)
                bg.cframe = workspace.CurrentCamera.CFrame
            end
            if bg then bg:Destroy() end
            if bv then bv:Destroy() end
        end)
    end
end)

SpeedUp.MouseButton1Click:Connect(function()
    speed = speed + 15
    print("Current Speed: "..speed)
end)

SpeedDown.MouseButton1Click:Connect(function()
    speed = math.max(10, speed - 15)
    print("Current Speed: "..speed)
end)
