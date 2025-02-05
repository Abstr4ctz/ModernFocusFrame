-- MainFrame.lua

local ModernFocusFrame = ModernFocusFrame

function ModernFocusFrame:CreateMainFrame()
    self.frame = CreateFrame("Frame", "ModernFocusFrame", UIParent)
    self.frame:SetWidth(256 * self.scale)
    self.frame:SetHeight(128 * self.scale)
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
    self.portrait:SetPoint("TOPRIGHT", self.frame, "TOPRIGHT", -self.frame:GetWidth() * 0.182, -self.frame:GetHeight() * 0.134)
    self.portraitFrame:Hide()
end

function ModernFocusFrame:CreateLevelCircle()
    self.levelFrame = CreateFrame("Frame", nil, self.frame)
    self.levelFrame:SetWidth(32 * self.scale)
    self.levelFrame:SetHeight(32 * self.scale)
    self.levelFrame:SetPoint("BOTTOMRIGHT", self.portrait, "BOTTOMRIGHT", self.frame:GetWidth() * 0.039, -self.frame:GetHeight() * 0.069)
    self.levelFrame:SetFrameLevel(self.frame:GetFrameLevel() + 1)

    self.levelTexture = self.levelFrame:CreateTexture(nil, "OVERLAY")
    self.levelTexture:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-LevelCircle")
    self.levelTexture:SetAllPoints(self.levelFrame)

    self.levelText = self.levelFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    self.levelText:SetPoint("CENTER", self.levelFrame, "CENTER", 0, 0)
    self.levelText:SetFont("Fonts\\FRIZQT__.TTF", 12 * self.scale, "OUTLINE")
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
    local fontSize = 12 * self.scale
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