-- HUD.lua

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "BON HUB",
    SubTitle = "Minimal Dark",
    TabWidth = 160,
    Size = UDim2.fromOffset(520, 360),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local MainTab = Window:AddTab({
    Title = "Main"
})

local Loaded = false

task.delay(1, function()
    Loaded = true
end)

MainTab:AddToggle("FlyToggle", {
    Title = "Fly",
    Default = false,

    Callback = function(Value)
        if not Loaded then return end

        if Value then
            _G.BON.Fly.Start()
        else
            _G.BON.Fly.Stop()
        end
    end
})

Fluent:Notify({
    Title = "BON HUB",
    Content = "Loaded successfully.",
    Duration = 3
})
