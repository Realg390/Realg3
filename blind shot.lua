local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local DISCORD_LINK = "https://discord.gg/8kmfBFMjfM"
local correctKey = "DreamOnTop"

local autoFarmEnabled = false
local FARM_INTERVAL = 10
local START_POS = Vector3.new(74.38, 65.00, 116.10)
local WALK_TO = Vector3.new(84.37, 64.77, 117.06)
local FINAL_TP = Vector3.new(75.44, 29.65, 86.95)
local farmThread = nil

local esp = false

RunService.RenderStepped:Connect(function()
    if esp then
        for _, plrs in pairs(Players:GetPlayers()) do
            if plrs ~= LocalPlayer and plrs.Character then
                for _, obj in pairs(plrs.Character:GetDescendants()) do
                    if obj:IsA("BasePart") then
                        if obj.Name ~= "hitbox" and obj.Name ~= "HumanoidRootPart" then
                            obj.Transparency = 0
                        end
                    elseif obj:IsA("Beam") then
                        obj.Enabled = true
                    elseif obj:IsA("BillboardGui") and obj.Name == "OrdemBillboard" then
                        obj.Enabled = true
                    end
                end
            end
        end
    end
end)

local function startAutoFarm()
    if farmThread then task.cancel(farmThread) end
    farmThread = task.spawn(function()
        while autoFarmEnabled do
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") then
                local hrp = char.HumanoidRootPart
                local humanoid = char.Humanoid

                hrp.CFrame = CFrame.new(START_POS)
                task.wait(0.3)

                humanoid:MoveTo(WALK_TO)
                humanoid.MoveToFinished:Wait()

                task.wait(1)
                hrp.CFrame = CFrame.new(FINAL_TP)
            end
            task.wait(FARM_INTERVAL)
        end
    end)
end

local Window = WindUI:CreateWindow({
    Title = "Blind Shot",
    Icon = "crosshair",
    Author = "DreamSolutions",
    Folder = "BlindShotConfig",
    Size = UDim2.fromOffset(500, 450),
    Transparent = true,
    Theme = "Dark",
    KeySystem = {
        Key = { correctKey },
        Note = "Join our Discord to get the key!",
        URL = DISCORD_LINK,
        SaveKey = true
    }
})

local AutoFarmTab = Window:Tab({ Title = "Auto Farm" })
local VisualsTab = Window:Tab({ Title = "Visuals" })
local UtilsTab = Window:Tab({ Title = "Utils" })

AutoFarmTab:Toggle({
    Title = "Auto Farm",
    Desc = "Auto farm simple",
    Value = false,
    Callback = function(state)
        autoFarmEnabled = state
        if state then
            startAutoFarm()
        elseif farmThread then
            task.cancel(farmThread)
            farmThread = nil
        end
    end
})

VisualsTab:Toggle({
    Title = "ESP + View Laser",
    Desc = "See players and lasers",
    Value = false,
    Callback = function(state)
        esp = state
    end
})

UtilsTab:Button({
    Title = "Fly GUI V5",
    Desc = "Execute Fly GUI V5",
    Callback = function()
        loadstring(game:HttpGet("https://github.com/Realg390/Realg3/blob/main/blind%20shot.lua"))()
    end
})

