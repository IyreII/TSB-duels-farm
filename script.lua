repeat task.wait() until game:IsLoaded()

queue_on_teleport([[
loadstring(game:HttpGet("https://raw.githubusercontent.com/IyreII/TSB-duels-farm/refs/heads/main/script.lua"))()
]])

local service; service = setmetatable({}, {
    __index = function(_, Key)
        service[Key] = cloneref(game:GetService(Key))
        return service[Key]
    end
})

local Players: Players = service.Players
local RunService: RunService = service.RunService
local UserInputService: UserInputService = service.UserInputService

local Player: Player = Players.LocalPlayer
local Character: Model = Player.Character or Player.CharacterAdded:Wait()
local Humanoid: Humanoid = Character:WaitForChild("Humanoid")
local Animator: Animator = Humanoid:WaitForChild("Animator")
local HumanoidRootPart: Part = Character:WaitForChild("HumanoidRootPart")
local Communicate: RemoteEvent = Character:WaitForChild("Communicate")

Player.CharacterAdded:Connect(function(NewCharacter)
    Character = NewCharacter
    Humanoid = Character:WaitForChild("Humanoid")
    Animator = Humanoid:WaitForChild("Animator")
    HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
    Communicate = Character:WaitForChild("Communicate")
end)

service.StarterGui:SetCore("SendNotification", {
    Title = "Free rank",
    Text = "Script executed, enabling anti void",
    Duration = 2
})

if not getgenv().hooked then
    local oldIndex;
    oldIndex = hookmetamethod(game, "__index", function(...)
        local self, key = ...;

        if rawequal(self, workspace) and rawequal(key, "FallenPartsDestroyHeight") and not checkcaller() then
            return -502;
        end

        return oldIndex(...);
    end)

    local oldNewIndex;
    oldNewIndex = hookmetamethod(game, "__newindex", function(...)
        local self, key, value = ...;

        if rawequal(self, workspace) and rawequal(key, "FallenPartsDestroyHeight") then
            value = 0/0;
        end

        if rawequal(self, Humanoid) and rawequal(key, "Health") and rawequal(value, 0) then
            return;
        end

        return oldNewIndex(...);
    end)
    getgenv().hooked = true
    workspace.FallenPartsDestroyHeight = 0/0
end

service.StarterGui:SetCore("SendNotification", {
    Title = "Free rank",
    Text = "hooks made, anti void enabled, waiting for game to start",
    Duration = 2
})

--// wait for game to start
repeat task.wait(0.5) until workspace:GetAttribute("GlobalStun") ~= true
task.wait(2)

service.StarterGui:SetCore("SendNotification", {
    Title = "Free rank",
    Text = "Game started, doing shit..",
    Duration = 2
})

lockOn = nil

c = RunService.Heartbeat:Connect(function()
    if not HumanoidRootPart then
        return
    end

    if lockOn and not lockOn:FindFirstChild("HumanoidRootPart") then
        return
    end

    if not lockOn then
        HumanoidRootPart.CFrame = CFrame.new(0, -600, 0)
    else
        HumanoidRootPart.CFrame = CFrame.new(lockOn.HumanoidRootPart.Position - lockOn.HumanoidRootPart.CFrame.LookVector * 1.5 + lockOn.HumanoidRootPart.Velocity * Player:GetNetworkPing() * 1.2, lockOn.HumanoidRootPart.CFrame.LookVector);
    end

    HumanoidRootPart.Velocity = Vector3.zero;
end)

local function UseMove(Name)
    if not Communicate then
        return
    end

    Communicate:FireServer({
        IsAutoActivate = true,
        Goal = "Console Move",
        Tool = Player.Backpack:FindFirstChild(Name),
        ToolName = Name
    })
end


local old = HumanoidRootPart.CFrame

local function set()
    lockOn = (function()
        for _,v in workspace.Live:GetChildren() do
            if v ~= Character and v.Name ~= "Weakest Dummy" and not v:FindFirstChild("ForceField") then
                return v
            end
        end
    end)()
end

repeat
    set()

    for i = 1, 15 do
        task.wait(0.02)
        UseMove("Flowing Water")
    end

    task.wait(0.7)

    lockOn = nil

    for i = 1, 19 do
        task.wait(1)
        if workspace:GetAttribute("GlobalStun") then
            break
        end
    end
until workspace:GetAttribute("GlobalStun")

c:Disconnect()
HumanoidRootPart.CFrame = old

task.wait(5)

repeat
    pcall(function()
        firesignal(Player.PlayerGui.Ranked.Container.realholder.newgame.Activated)
        firesignal(Player.PlayerGui.Ranked.Container.realholder.newgame.MouseButton1Click)
        firesignal(Player.PlayerGui.Ranked.Container.realholder.newgame.MouseButton1Down)
        firesignal(Player.PlayerGui.Ranked.Container.realholder.newgame.MouseButton1Up)
    end)
    task.wait(1)
until secondcoming
