--[[
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Workspace = game:GetService("Workspace")
    
    -- ฟังก์ชันสำหรับส่งคำขอซื้อไอเท็ม
    local function purchaseItem(itemName, itemType, quantity)
        local Purchase = {
            [1] = itemName,
            [2] = itemType,
            [4] = quantity
        }
    
        if ReplicatedStorage:FindFirstChild("events") and ReplicatedStorage.events:FindFirstChild("purchase") then
            ReplicatedStorage.events.purchase:FireServer(unpack(Purchase))
            print("Purchased:", itemName)
        else
            warn("Purchase event not found!")
        end
    end
    
    -- ฟังก์ชันสำหรับขายไอเท็มทั้งหมด
    local function sellAllItems()
        local npc = Workspace:FindFirstChild("world") 
            and Workspace.world.npcs:FindFirstChild("Marc Merchant")
    
        if npc and npc:FindFirstChild("merchant") and npc.merchant:FindFirstChild("sellall") then
            npc.merchant.sellall:InvokeServer()
            print("Sold all items!")
        else
            warn("SellAll function or NPC not found!")
        end
    end
    
    -- ซื้อไอเท็ม
    while task.wait(3) do
        pcall(function()
            purchaseItem("Carbon Rod", "Rod", 1)
            purchaseItem("Reinforced Rod", "Rod", 1)
            if AuroraRod then purchaseItem("Aurora Rod", "Rod", 1) end
            if TridentRod then purchaseItem("Trident Rod", "Rod", 1) end
            if KingsRod then purchaseItem("Kings Rod", "Rod", 1) end
        end)
    end
    
    -- วนลูปขายไอเท็มทุก 120 วินาที
    while task.wait(120) do
        sellAllItems()
    end

]]
