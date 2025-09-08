-- LocalScript para destacar Humanoids e desenhar linhas (Beams) do jogador local para cada um deles ao pressionar K, sem teleporte e funcionando em primeira pessoa

local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local highlightColor = Color3.fromRGB(255, 0, 0)
local highlights = {}
local beams = {}
local highlightsActive = false
local originAttachment = nil

-- Função para limpar highlights/beams/attachments
local function clearEffects()
    for _, hl in pairs(highlights) do
        if hl and hl.Parent then hl:Destroy() end
    end
    highlights = {}

    for _, obj in pairs(beams) do
        if obj and obj.Parent then obj:Destroy() end
    end
    beams = {}

    if originAttachment and originAttachment.Parent then
        originAttachment:Destroy()
        originAttachment = nil
    end
end

-- Função para destacar e desenhar linhas
local function showEffects()
    local localPlayer = Players.LocalPlayer
    local character = localPlayer.Character
    if not character then return end
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end

    -- Usar um Attachment como origem da linha
    originAttachment = Instance.new("Attachment")
    originAttachment.Name = "BeamOrigin"
    originAttachment.Parent = rootPart

    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Humanoid") and obj.Parent:IsA("Model") then
            local model = obj.Parent
            -- Highlight
            if not model:FindFirstChildOfClass("Highlight") and model:FindFirstChildWhichIsA("BasePart") then
                local highlight = Instance.new("Highlight")
                highlight.Adornee = model
                highlight.FillColor = highlightColor
                highlight.OutlineColor = Color3.fromRGB(0, 0, 0)
                highlight.FillTransparency = 0.2
                highlight.OutlineTransparency = 0
                highlight.Parent = model
                table.insert(highlights, highlight)
            end

            -- Beam (linha)
            local targetRoot = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChildWhichIsA("BasePart")
            if targetRoot and targetRoot ~= rootPart then
                local targetAttachment = Instance.new("Attachment")
                targetAttachment.Parent = targetRoot

                local beam = Instance.new("Beam")
                beam.Attachment0 = originAttachment
                beam.Attachment1 = targetAttachment
                beam.Color = ColorSequence.new(Color3.new(1, 0, 0)) -- vermelho
                beam.Width0 = 0.15
                beam.Width1 = 0.15
                beam.Transparency = NumberSequence.new(0)
                beam.FaceCamera = true
                beam.Parent = rootPart
                table.insert(beams, beam)
                table.insert(beams, targetAttachment)
            end
        end
    end
end

-- Alternância ao pressionar K
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.K then
        highlightsActive = not highlightsActive
        if highlightsActive then
            showEffects()
        else
            clearEffects()
        end
    end
end)
