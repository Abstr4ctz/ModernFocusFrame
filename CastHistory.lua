-- CastHistory.lua

local ModernFocusFrame = ModernFocusFrame

local castHistoryFrames = {}
local castHistoryFrameSize = 40
local castHistoryMaxFrames = 5
local castHistoryFadeTime = 6

local function GetScaledValue(value, scale)
    return value * scale
end

function ModernFocusFrame:CreateSpellFrame(spellIcon)

    local scale = self.scale or 1
    local scaledFrameSize = GetScaledValue(castHistoryFrameSize, scale)
    local castHistoryOffsetX = GetScaledValue(-5, scale)
    local castHistoryOffsetY = GetScaledValue(20, scale)
    local spacing = GetScaledValue(5, scale)

    local i = table.getn(castHistoryFrames)
    while i > 0 do
        if castHistoryFrames[i].isFaded then
            castHistoryFrames[i]:Hide()
            table.remove(castHistoryFrames, i)
        end
        i = i - 1
    end

    local focusFrameRight = self.frame:GetRight() + castHistoryOffsetX
    local focusFrameCenterY = (self.frame:GetTop() - (self.frame:GetHeight() / 2)) + castHistoryOffsetY

    local activeFrames = table.getn(castHistoryFrames)

    i = activeFrames
    while i > 0 do
        local frame = castHistoryFrames[i]
        frame.startX = focusFrameRight + ((i - 1) * (scaledFrameSize + spacing))
        frame.targetX = frame.startX + (scaledFrameSize + spacing)
        frame.startTime = GetTime()
        frame.moveDuration = 0.25
        i = i - 1
    end

    local newFrame = CreateFrame("Frame", nil, UIParent)
    newFrame:SetWidth(scaledFrameSize)
    newFrame:SetHeight(scaledFrameSize)
    newFrame.startX = focusFrameRight
    newFrame.startY = focusFrameCenterY
    newFrame:SetPoint("CENTER", UIParent, "BOTTOMLEFT", newFrame.startX, newFrame.startY)
    newFrame:Show()

    local newTexture = newFrame:CreateTexture(nil, "BACKGROUND")
    newTexture:SetAllPoints()
    newTexture:SetTexture(spellIcon)
    newTexture:SetTexCoord(0.1, 0.9, 0.1, 0.9)

    newFrame.fadeTime = castHistoryFadeTime
    newFrame.elapsed = 0
    newFrame.isFaded = false
    newFrame.startTime = GetTime()
    newFrame.moveDuration = 0.25

    newFrame:SetScript("OnUpdate", function()
        local now = GetTime()
        if not this.startTime then this.startTime = now end

        local progress = (now - this.startTime) / this.moveDuration
        if progress > 1 then progress = 1 end

        if this.targetX then
            local newX = this.startX + (this.targetX - this.startX) * progress
            this:SetPoint("CENTER", UIParent, "BOTTOMLEFT", newX, this.startY)
        end

        this.elapsed = (this.elapsed or 0) + arg1
        if this.elapsed >= this.fadeTime then
            this:SetAlpha(0)
            this.isFaded = true
        else
            this:SetAlpha(1 - (this.elapsed / this.fadeTime))
        end
    end)

    table.insert(castHistoryFrames, 1, newFrame)
end
