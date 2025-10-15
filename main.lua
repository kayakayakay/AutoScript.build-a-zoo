local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

-- Criar janela principal
local Window = Fluent:CreateWindow({
    Title = "Lugangelo",
    SubTitle = "| Build a zoo",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- Criar aba
local Tabs = {
    Main = Window:AddTab({
        Title = "Principal",
        Icon = ""
    })
}

-- Alternância de coleta automática
local CollectToggle = Tabs.Main:AddToggle("CollectToggle", {
    Title = "Coletar moedas automaticamente",
    Default = false
})

-- Auto Coletar
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

-- Comprar frutas automaticamente
local stateToggle = false -- Estado do toggle
local selectFruit = {} -- Lista de frutas selecionadas

local Dropdown = Tabs.Main:AddDropdown("Dropdown", {
    Title = "Selecione os alimentos para comprar",
    Values = { -- Lista de frutas disponíveis (adicione mais se necessário)
        "Strawberry", "Blueberry", "Watermelon", "Apple", "Orange", "Corn", "Banana", "Grape", "Pear", "Pineapple",
        "DragonFruit", "GoldMango", "BloodstoneCycad", "ColossalPinecone", "VoltGinkgo", "DeepseaPearlFruit", "Durian"
    },
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

-- Alternância de compra automática
local autoBuyToggle = Tabs.Main:AddToggle("autoBuyToggles", {
    Title = "Comprar alimentos automaticamente",
    Default = false
})

local stateBuyToggle = false -- Estado do toggle
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
            print("Por favor, selecione uma fruta primeiro.") -- Idealmente usar uma notificação
        end
    else
        stateBuyToggle = false
    end
end)
