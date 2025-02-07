-- CastBar.lua

local ModernFocusFrame = ModernFocusFrame

function ModernFocusFrame:CreateCastBar()
    self.castBar = CreateFrame("StatusBar", nil, self.frame)
    self.castBar:SetPoint("TOPLEFT", self.manaBar, "BOTTOMLEFT", self.frame:GetWidth() * 0.059, -self.frame:GetHeight() * 0.42)
    self.castBar:SetPoint("TOPRIGHT", self.manaBar, "BOTTOMRIGHT", self.frame:GetWidth() * 0.059, -self.frame:GetHeight() * 0.42)
    self.castBar:SetHeight(self.frame:GetHeight() * 0.15)
	-- self.castBar:SetWidth(self.frame:GetWidth() * 0.9)
    self.castBar:SetStatusBarTexture("Interface\\AddOns\\ModernFocusFrame\\textures\\Smooth.blp")
    self.castBar:SetStatusBarColor(1, 0.7, 0)
    self.castBar:SetMinMaxValues(0, 1)
	
	self.castOverlay = self.castBar:CreateTexture(nil, "BACKGROUND")
	self.castOverlay:SetAllPoints(self.castBar)
	self.castOverlay:SetTexture("Interface\\Buttons\\WHITE8X8")
	self.castOverlay:SetVertexColor(0, 0, 0, 0.3)


    self.castText = self.castBar:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    self.castText:SetPoint("CENTER", self.castBar, "CENTER", 0, 0)
    self.castText:SetFont("Fonts\\FRIZQT__.TTF", 12 * self.scale, "OUTLINE")

    self.castSpark = self.castBar:CreateTexture(nil, "OVERLAY")
    self.castSpark:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
    self.castSpark:SetWidth(20)
    self.castSpark:SetHeight(self.castBar:GetHeight() * 2)
    self.castSpark:SetBlendMode("ADD")

    self.castIcon = self.castBar:CreateTexture(nil, "OVERLAY")
    local iconSize = self.castBar:GetHeight() * 1
    self.castIcon:SetWidth(iconSize)
    self.castIcon:SetHeight(iconSize)
    self.castIcon:SetPoint("RIGHT", self.castBar, "LEFT", -5, 0)
    self.castIcon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
    self.castIcon:Hide()

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
