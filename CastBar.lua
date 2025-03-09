-- CastBar.lua

local ModernFocusFrame = ModernFocusFrame

function ModernFocusFrame:CreateCastBar()
    local backdrop = {
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true, tileSize = 8, edgeSize = 12,
        insets = { left = 3, right = 3, top = 3, bottom = 3 }
    }

    -- create the castbar
    self.castBar = CreateFrame("StatusBar", nil, self.frame)
    self.castBar:SetPoint("TOPLEFT", self.manaBar, "BOTTOMLEFT", self.frame:GetWidth() * 0.059, -self.frame:GetHeight() * 0.47)
    self.castBar:SetPoint("TOPRIGHT", self.manaBar, "BOTTOMRIGHT", self.frame:GetWidth() * 0.059, -self.frame:GetHeight() * 0.47)
    self.castBar:SetHeight(14 * self.scale) -- ShaguTweaks castbar height
	-- self.castBar:SetWidth(self.frame:GetWidth() * 0.9) -- dynamic width is kept but adjusted by points
    self.castBar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar") -- ShaguTweaks texture
    self.castBar:SetStatusBarColor(1, .8, 0, 1) -- ShaguTweaks color
    self.castBar:SetMinMaxValues(0, 1)

    -- create the spell icon
    self.castIconFrame = CreateFrame("Frame", nil, self.castBar)
    self.castIconFrame:SetPoint("RIGHT", self.castBar, "LEFT", 0, 0)
    self.castIconFrame:SetHeight(25 * self.scale) -- ShaguTweaks icon frame size
    self.castIconFrame:SetWidth(25 * self.scale)  -- ShaguTweaks icon frame size
    self.castIcon = self.castIconFrame:CreateTexture(nil, "BACKGROUND")
    self.castIcon:SetPoint("CENTER", 0, 0)
    self.castIcon:SetWidth(19 * self.scale) -- ShaguTweaks icon size
    self.castIcon:SetHeight(19 * self.scale) -- ShaguTweaks icon size
    self.castIconFrame:SetBackdrop(backdrop)
    self.castIconFrame:SetBackdropBorderColor(1,.8,0)

    -- castbar background
    self.castBG = self.castBar:CreateTexture(nil, "BACKGROUND")
    self.castBG:SetTexture("Interface\\TARGETINGFRAME\\UI-StatusBar") -- ShaguTweaks texture
    self.castBG:SetVertexColor(.1, .1, 0, .8) -- ShaguTweaks color
    self.castBG:SetAllPoints(true)

    -- castbar spark
    self.castSpark = self.castBar:CreateTexture(nil, "OVERLAY")
    self.castSpark:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
    self.castSpark:SetWidth(24 * self.scale) -- ShaguTweaks spark width
    self.castSpark:SetHeight(24 * self.scale) -- ShaguTweaks spark height
    self.castSpark:SetBlendMode("ADD")

    -- castbar border
    self.castBackdrop = CreateFrame("Frame", nil, self.castBar)
    self.castBackdrop:SetFrameLevel(self.castBar:GetFrameLevel())
    self.castBackdrop:SetPoint("TOPLEFT", self.castBar, "TOPLEFT", -3 * self.scale, 3 * self.scale)
    self.castBackdrop:SetPoint("BOTTOMRIGHT", self.castBar, "BOTTOMRIGHT", 3 * self.scale, -3 * self.scale)
    self.castBackdrop:SetBackdrop(backdrop)
    self.castBackdrop:SetBackdropBorderColor(1,.8,0)

    -- castbar spellname
    self.castText = self.castBar:CreateFontString(nil, "HIGH", "GameFontWhite")
    self.castText:SetPoint("CENTER", self.castBar, "CENTER", 0, 0)
    local font, size, opts = self.castText:GetFont()
    self.castText:SetFont(font, (size - 1) * self.scale, "THINOUTLINE")

    self.castBar:Hide()
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
    self.castBar:SetStatusBarColor(1, 0.8, 0)
    self.castBar:SetAlpha(1)
    self.castBar:Show()

    if spellIcon then
        self.castIcon:SetTexture(spellIcon)
        self.castIcon:Show()
        self.castIconFrame:Show()
    else
        self.castIcon:Hide()
        self.castIconFrame:Hide()
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