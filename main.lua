--[[
    @author https://github.com/Nopparatz123
    @library by https://forgenet.gitbook.io/fluent-documentation/
]] 
    
-- Import library
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

-- Create FrameWindow
local Window = Fluent:CreateWindow({
    Title = "Syrup ",
    SubTitle = "| Bulid a zoo",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- Create TabMenu
local Tabs = {
    Main = Window:AddTab({
        Title = "Main",
        Icon = ""
    })
}
-- CollectToggle UI
local CollectToggle = Tabs.Main:AddToggle("CollectToggle ", {
    Title = "เก็บเหรียญอัตโนมัติ",
    Default = false
})

-- Auto Collect
local Autocollect = false
CollectToggle:OnChanged(function(state)
    Autocollect = state
    if Autocollect then
        task.spawn(function()
            while Autocollect do
                for _, pet in pairs(workspace.Pets:GetChildren()) do
                    if pet:FindFirstChild("RootPart") and pet.RootPart:FindFirstChild("RE") then
                        pet.RootPart.RE:FireServer("Claim")
                    end
                end
                task.wait(1)
            end
        end)
    end
end)

-- Auto Buy Fruit
local stateToggle = false -- สถานะToggle
local selectFruit = {} -- Data Table List Fruit

local Dropdown = Tabs.Main:AddDropdown("Dropdown", {
    Title = "เลือกอาหารที่ซื้อ",
    Values = { -- Table List อาหาร ถ้ามีเพิ่มใส่ต่อDurian
    "Strawberry", "Blueberry", "Watermelon", "Apple", "Orange", "Corn", "Banana", "Grape", "Pear", "Pineapple",
    "DragonFruit", "GoldMango", "BloodstoneCycad", "ColossalPinecone", "VoltGinkgo", "DeepseaPearlFruit", "Durian"},
    Multi = true,
    Default = {
        Strawberry = true
    }
})
Dropdown:SetValue({
    Strawberry = true
})
Dropdown:OnChanged(function(Value)
    selectFruit = Value
end)

-- autoBuy Toggle UI
local autoBuyToggle = Tabs.Main:AddToggle("autoBuyToggles", {
    Title = "ซื้ออาหารอัตโนมัติ",
    Default = false
})

local stateBuyToggle = false -- สถานะ toggle
autoBuyToggle:OnChanged(function(state)
    stateBuyToggle = state

    if stateBuyToggle then
        if selectFruit and next(selectFruit) ~= nil then
            task.spawn(function()
                while stateBuyToggle do
                    for foodName, isSelected in next, selectFruit do
                        if isSelected then
                            game:GetService("ReplicatedStorage").Remote.FoodStoreRE:FireServer(foodName)
                            task.wait(0.2)
                        end
                    end
                    task.wait(0.3)
                end
            end)
        else
            print("กรุณาเลือกไม้ผล") -- จริงๆควรใส่เป็นNotification
        end
    else
        stateBuyToggle = false
    end
end)
