--[[
    Script UI: Lugangelo | Build a Zoo
    Compatível com todas as versões da Fluent UI
]] 

-- Importar biblioteca Fluent
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

-- Criar janela principal
local Window = Fluent:CreateWindow({
    Title = "Lugangelo",
    SubTitle = "| Build a Zoo",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false,
    Theme = "Amethyst",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- Criar aba principal
local Tabs = {
    Main = Window:AddTab({
        Title = "Principal",
        Icon = ""
    })
}

------------------------------------------------------------
-- 🔹 Alternância de coleta automática
------------------------------------------------------------
local Autocollect = false
local CollectToggle = Tabs.Main:AddToggle("CollectToggle", {
    Title = "Coletar moedas automaticamente",
    Default = false
})

local function handleCollectToggle(state)
    Autocollect = state
    print("[DEBUG] Coleta automática:", state)

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
end

if CollectToggle.OnChanged then
    CollectToggle:OnChanged(handleCollectToggle)
else
    CollectToggle.Callback = handleCollectToggle
end

------------------------------------------------------------
-- 🔹 Sistema de compra automática de frutas
------------------------------------------------------------
local selectFruit = {} -- Lista de frutas selecionadas

local Dropdown = Tabs.Main:AddDropdown("Dropdown", {
    Title = "Selecione a comida desejada",
    Values = {
        "Strawberry", "Blueberry", "Watermelon", "Apple", "Orange",
        "Corn", "Banana", "Grape", "Pear", "Pineapple",
        "DragonFruit", "GoldMango", "BloodstoneCycad", "ColossalPinecone",
        "VoltGinkgo", "DeepseaPearlFruit", "Durian"
    },
    Multi = true,
    Default = { Strawberry = true }
})

Dropdown:SetValue({ Strawberry = true })

local function handleDropdownChange(Value)
    selectFruit = Value
    print("[DEBUG] Frutas selecionadas:", Value)
end

if Dropdown.OnChanged then
    Dropdown:OnChanged(handleDropdownChange)
else
    Dropdown.Callback = handleDropdownChange
end

------------------------------------------------------------
-- 🔹 Alternância de compra automática
------------------------------------------------------------
local stateBuyToggle = false
local autoBuyToggle = Tabs.Main:AddToggle("autoBuyToggles", {
    Title = "Comprar alimentos automaticamente",
    Default = false
})

local function handleAutoBuyToggle(state)
    stateBuyToggle = state
    print("[DEBUG] Compra automática:", state)

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
            warn("[Aviso] Nenhuma fruta selecionada para compra automática.")
        end
    else
        stateBuyToggle = false
    end
end

if autoBuyToggle.OnChanged then
    autoBuyToggle:OnChanged(handleAutoBuyToggle)
else
    autoBuyToggle.Callback = handleAutoBuyToggle
end
