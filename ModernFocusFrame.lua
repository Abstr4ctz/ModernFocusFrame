-- Configuration
local scale = 1 -- Modify this value to scale the frame

ModernFocusFrame = AceLibrary("AceAddon-2.0"):new("AceEvent-2.0", "AceDB-2.0")

function ModernFocusFrame:OnInitialize()
    self:RegisterDB("ModernFocusFrameDB")

    self:RegisterDefaults("profile", {
        position = { "CENTER", "UIParent", "CENTER", 0, 0 }
    })
    self:CreateMainFrame()
    self:CreateHealthBar()
    self:CreateManaBar()
    self:CreateTextElements()
    self:CreatePortrait()
    self:CreateLevelCircle()
    self:CreateCastBar()
    self:LoadPosition()
    self:EnableDragging()

    self.focusGUID = nil
    self:RegisterEvent("UNIT_HEALTH")
    self:RegisterEvent("UNIT_MANA")
    self:RegisterEvent("UNIT_RAGE")
    self:RegisterEvent("UNIT_ENERGY")
    self:RegisterEvent("UNIT_LEVEL")
    self:RegisterEvent("UNIT_CASTEVENT")

    self.frame:SetScript("OnUpdate", function(_, elapsed) self:OnUpdate(elapsed) end)
end

function ModernFocusFrame:CreateMainFrame()
    self.frame = CreateFrame("Frame", "ModernFocusFrame", UIParent)
    self.frame:SetWidth(256 * scale)
    self.frame:SetHeight(128 * scale)
    self.frame:SetPoint("CENTER", UIParent, "CENTER")
    self.frame:SetBackdrop({ bgFile = "Interface\\AddOns\\ModernFocusFrame\\textures\\UI-TargetingFrame-Light.blp" })

    self.frame:Hide()
end

function ModernFocusFrame:CreatePortrait()
    self.portraitFrame = CreateFrame("Frame", nil, self.frame)
    self.portraitFrame:SetAllPoints(self.frame)
    self.portraitFrame:SetFrameLevel(self.frame:GetFrameLevel() - 1)

    self.portrait = self.portraitFrame:CreateTexture(nil, "BACKGROUND")
    local portraitSize = self.frame:GetHeight() * 0.442
    self.portrait:SetWidth(portraitSize)
    self.portrait:SetHeight(portraitSize)
    self.portrait:SetPoint("TOPRIGHT", self.frame, "TOPRIGHT", -self.frame:GetWidth() * 0.182,
        -self.frame:GetHeight() * 0.134)

    self.portraitFrame:Hide()
end

function ModernFocusFrame:CreateLevelCircle()
    self.levelFrame = CreateFrame("Frame", nil, self.frame)
    self.levelFrame:SetWidth(32 * scale)
    self.levelFrame:SetHeight(32 * scale)
    self.levelFrame:SetPoint("BOTTOMRIGHT", self.portrait, "BOTTOMRIGHT", self.frame:GetWidth() * 0.039,
        -self.frame:GetHeight() * 0.069)
    self.levelFrame:SetFrameLevel(self.frame:GetFrameLevel() + 1)

    self.levelTexture = self.levelFrame:CreateTexture(nil, "OVERLAY")
    self.levelTexture:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-LevelCircle")
    self.levelTexture:SetAllPoints(self.levelFrame)

    self.levelText = self.levelFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    self.levelText:SetPoint("CENTER", self.levelFrame, "CENTER", 0, 0)
    self.levelText:SetFont("Fonts\\FRIZQT__.TTF", 12 * scale, "OUTLINE")
    self.levelText:SetTextColor(1, 1, 1)

    self.levelFrame:Hide()
end

function ModernFocusFrame:CreateHealthBar()
    self.healthBar = CreateFrame("StatusBar", nil, self.frame)
    self.healthBar:SetPoint("TOPLEFT", self.frame, "TOPLEFT", self.frame:GetWidth() * 0.12,
        -self.frame:GetHeight() * 0.185)
    self.healthBar:SetPoint("TOPRIGHT", self.frame, "TOPRIGHT", -self.frame:GetWidth() * 0.42,
        -self.frame:GetHeight() * 0.05)
    self.healthBar:SetHeight(self.frame:GetHeight() * 0.20)
    self.healthBar:SetStatusBarTexture("Interface\\AddOns\\ModernFocusFrame\\textures\\Smooth.blp")
    self.healthBar:SetStatusBarColor(0, 1, 0)
    self.healthBar:SetFrameLevel(self.frame:GetFrameLevel() - 1)

    self.healthBar:Hide()
end

function ModernFocusFrame:CreateManaBar()
    self.manaBar = CreateFrame("StatusBar", nil, self.frame)
    self.manaBar:SetPoint("TOPLEFT", self.healthBar, "BOTTOMLEFT", 0, -self.frame:GetHeight() * 0.0215)
    self.manaBar:SetPoint("TOPRIGHT", self.healthBar, "BOTTOMRIGHT", 0, -self.frame:GetHeight() * 0.02)
    self.manaBar:SetHeight(self.frame:GetHeight() * 0.08)
    self.manaBar:SetStatusBarTexture("Interface\\AddOns\\ModernFocusFrame\\textures\\Smooth.blp")
    self.manaBar:SetStatusBarColor(0, 0, 1)
    self.manaBar:SetFrameLevel(self.frame:GetFrameLevel() - 1)

    self.manaBar:Hide()
end

function ModernFocusFrame:CreateTextElements()
    local fontSize = 12 * scale
    local font, _, flags = "Fonts\\FRIZQT__.TTF", fontSize, "OUTLINE"

    self.healthText = self.healthBar:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    self.healthText:SetPoint("CENTER", self.healthBar, "CENTER", 0, -4)
    self.healthText:SetFont(font, fontSize, flags)

    self.manaText = self.manaBar:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    self.manaText:SetPoint("CENTER", self.manaBar, "CENTER", 0, 0)
    self.manaText:SetFont(font, fontSize * 0.95, flags)

    self.nameText = self.frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    self.nameText:SetPoint("BOTTOM", self.healthBar, "TOP", 0, -4)
    self.nameText:SetFont(font, fontSize, flags)
    self.nameText:SetTextColor(1, 1, 1)
end

function ModernFocusFrame:CreateCastBar()
    self.castBar = CreateFrame("StatusBar", nil, self.frame)
    self.castBar:SetPoint("TOPLEFT", self.manaBar, "BOTTOMLEFT", 0, -self.frame:GetHeight() * 0.02)
    self.castBar:SetPoint("TOPRIGHT", self.manaBar, "BOTTOMRIGHT", 0, -self.frame:GetHeight() * 0.02)
    self.castBar:SetHeight(self.frame:GetHeight() * 0.2)
    self.castBar:SetStatusBarTexture("Interface\\AddOns\\ModernFocusFrame\\textures\\Smooth.blp")
    self.castBar:SetStatusBarColor(1, 0.7, 0)
    self.castBar:SetMinMaxValues(0, 1)

    self.castText = self.castBar:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    self.castText:SetPoint("CENTER", self.castBar, "CENTER", 0, 0)
    self.castText:SetFont("Fonts\\FRIZQT__.TTF", 12 * scale, "OUTLINE")

    self.castSpark = self.castBar:CreateTexture(nil, "OVERLAY")
    self.castSpark:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
    self.castSpark:SetWidth(20)
    self.castSpark:SetHeight(self.castBar:GetHeight() * 2)
    self.castSpark:SetBlendMode("ADD")

    self.castIcon = self.castBar:CreateTexture(nil, "OVERLAY")
    local iconSize = self.castBar:GetHeight() * 1
    self.castIcon:SetWidth(iconSize)
    self.castIcon:SetHeight(iconSize)
    self.castIcon:SetPoint("RIGHT", self.castBar, "LEFT", -2, 0)
    self.castIcon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
    self.castIcon:Hide()

    self.castBar:Hide()
end

function ModernFocusFrame:UNIT_HEALTH(unit)
    local _, unitGUID = UnitExists(unit)
    if unit and unitGUID and self.focusGUID == unitGUID then
        self:UpdateModernFocusFrame()
    end
end

function ModernFocusFrame:UNIT_MANA(unit)
    local _, unitGUID = UnitExists(unit)
    if unit and unitGUID and self.focusGUID == unitGUID then
        self:UpdateModernFocusFrame()
    end
end

function ModernFocusFrame:UNIT_RAGE(unit)
    local _, unitGUID = UnitExists(unit)
    if unit and unitGUID and self.focusGUID == unitGUID then
        self:UpdateModernFocusFrame()
    end
end

function ModernFocusFrame:UNIT_ENERGY(unit)
    local _, unitGUID = UnitExists(unit)
    if unit and unitGUID and self.focusGUID == unitGUID then
        self:UpdateModernFocusFrame()
    end
end

function ModernFocusFrame:UNIT_LEVEL(unit)
    local _, unitGUID = UnitExists(unit)
    if unit and unitGUID and self.focusGUID == unitGUID then
        self:UpdateModernFocusFrame()
    end
end

function ModernFocusFrame:UNIT_CASTEVENT(casterGUID, targetGUID, eventType, spellID, castDuration)
    if casterGUID == self.focusGUID then
        if eventType == "START" then
            self:StartCastBar(spellID, castDuration, false)
        elseif eventType == "CHANNEL" then
            self:StartCastBar(spellID, castDuration, true)
        elseif eventType == "FAIL" then
            self:StopCastBar(true)
        end
    end
end

function ModernFocusFrame:OnUpdate(elapsed)
    if self.isCasting or self.isChanneling then
        local elapsedTime = GetTime() - self.castStartTime
        local remainingTime = self.castDuration - elapsedTime

        if elapsedTime >= self.castDuration then
            self:StopCastBar(false)
        else
            if self.isCasting then
                self.castBar:SetValue(elapsedTime)
                self.castSpark:SetPoint("CENTER", self.castBar, "LEFT",
                    (elapsedTime / self.castDuration) * self.castBar:GetWidth(), 0)
            elseif self.isChanneling then
                self.castBar:SetValue(remainingTime)
                self.castSpark:SetPoint("CENTER", self.castBar, "LEFT",
                    (remainingTime / self.castDuration) * self.castBar:GetWidth(), 0)
            end
        end
    end
end

function ModernFocusFrame:UpdateModernFocusFrame()
    if self.focusGUID then
        local unit = self.focusGUID
        if not UnitExists(unit) then
            self.frame:Hide()
            return
        end

        local name = UnitName(unit)
        self.nameText:SetText(name or "Unknown")

        local hp, hpMax = UnitHealth(unit), UnitHealthMax(unit)
        local powerType = UnitPowerType(unit)
        local power, powerMax = UnitMana(unit), UnitManaMax(unit)

        self.healthBar:SetMinMaxValues(0, hpMax)
        self.healthBar:SetValue(hp)
        self.healthText:SetText(hp)

        self.manaBar:SetMinMaxValues(0, powerMax)
        self.manaBar:SetValue(power)

        if powerType == 1 then
            self.manaBar:SetStatusBarColor(1, 0, 0)
            self.manaText:SetText(power)
        elseif powerType == 3 then
            self.manaBar:SetStatusBarColor(1, 1, 0)
            self.manaText:SetText(power)
        else
            self.manaBar:SetStatusBarColor(0, 0, 1)
            self.manaText:SetText(power)
        end

        SetPortraitTexture(self.portrait, unit)

        local level = UnitLevel(unit)
        if level and level > 0 then
            self.levelText:SetText(level)
            if UnitCanAttack("player", unit) then
                local color = GetDifficultyColor(level)
                self.levelText:SetTextColor(color.r, color.g, color.b)
            else
                self.levelText:SetTextColor(1.0, 0.82, 0.0)
            end
        else
            self.levelText:SetText("??")
        end

        self.frame:Show()
        self.portraitFrame:Show()
        self.levelFrame:Show()
        self.healthBar:Show()
        self.manaBar:Show()
    end
end

function ModernFocusFrame:StartCastBar(spellID, castDuration, isChanneling)
    local spellName, _, spellIcon = SpellInfo(spellID)
    spellName = spellName or "Unknown Spell"

    self.castText:SetText(spellName)
    self.castStartTime = GetTime()
    self.castDuration = castDuration / 1000
    self.isCasting = not isChanneling
    self.isChanneling = isChanneling

    UIFrameFadeRemoveFrame(self.castBar)

    self.castBar:SetMinMaxValues(0, self.castDuration)
    self.castBar:SetValue(isChanneling and self.castDuration or 0)
    self.castBar:SetStatusBarColor(1, 0.7, 0)
    self.castBar:SetAlpha(1)
    self.castBar:Show()

    if spellIcon then
        self.castIcon:SetTexture(spellIcon)
        self.castIcon:Show()
    else
        self.castIcon:Hide()
    end
end

function ModernFocusFrame:StopCastBar(failed)
    self.isCasting = false
    self.isChanneling = false

    if failed then
        self.castBar:SetStatusBarColor(1, 0, 0)
        self.castBar:SetAlpha(1)
        UIFrameFadeOut(self.castBar, 0.5, 1, 0)
    else
        UIFrameFadeOut(self.castBar, 0.5, 1, 0)
    end
end

function ModernFocusFrame:LoadPosition()
    local pos = self.db.profile.position
    if type(pos) ~= "table" or not pos[1] or not pos[2] or not pos[3] or not pos[4] then
        pos = { "CENTER", "UIParent", "CENTER", 0, 0 }
        self.db.profile.position = pos
    end
    self.frame:ClearAllPoints()
    self.frame:SetPoint(pos[1], pos[2], pos[3], pos[4], pos[5])
end

function ModernFocusFrame:SavePosition()
    local point, relativeTo, relativePoint, xOfs, yOfs = self.frame:GetPoint()
    if not relativeTo or type(relativeTo) ~= "string" then
        relativeTo = "UIParent"
    end
    self.db.profile.position = { point, relativeTo, relativePoint, xOfs, yOfs }
end

function ModernFocusFrame:EnableDragging()
    self.frame:SetMovable(true)
    self.frame:EnableMouse(true)
    self.frame:RegisterForDrag("LeftButton")

    self.frame:SetScript("OnDragStart", function()
        self.frame:StartMoving()
    end)

    self.frame:SetScript("OnDragStop", function()
        self.frame:StopMovingOrSizing()
        self:SavePosition()
    end)
end

SLASH_FOCUS1 = "/focus"
SlashCmdList["FOCUS"] = function(msg)
    local exists, targetGUID = UnitExists("target")
    if msg == "clear" or not exists then
        ModernFocusFrame.focusGUID = nil
        ModernFocusFrame.frame:Hide()
    elseif exists and targetGUID then
        ModernFocusFrame.focusGUID = targetGUID
        ModernFocusFrame.frame:Show()
        ModernFocusFrame:UpdateModernFocusFrame()
    else
        DEFAULT_CHAT_FRAME:AddMessage("No valid target to focus.")
    end
end

SLASH_FOCUSMOUSE1 = "/focusmouse"
SlashCmdList["FOCUSMOUSE"] = function(msg)
    local exists, targetGUID = UnitExists("mouseover")
    if msg == "clear" or not exists then
        ModernFocusFrame.focusGUID = nil
        ModernFocusFrame.frame:Hide()
    elseif exists and targetGUID then
        ModernFocusFrame.focusGUID = targetGUID
        ModernFocusFrame.frame:Show()
        ModernFocusFrame:UpdateModernFocusFrame()
    else
        DEFAULT_CHAT_FRAME:AddMessage("No valid mouseover target to focus.")
    end
end
