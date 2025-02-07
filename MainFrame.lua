-- MainFrame.lua

local ModernFocusFrame = ModernFocusFrame

----------------
-- Main Frame --
----------------
function ModernFocusFrame:CreateMainFrame()
    self.frame = CreateFrame("Button", "ModernFocusFrame", UIParent)
    self.frame:SetWidth(256 * self.scale)
    self.frame:SetHeight(128 * self.scale)
    self.frame:SetPoint("CENTER", UIParent, "CENTER")
    self.frame:SetBackdrop({ bgFile = "Interface\\AddOns\\ModernFocusFrame\\textures\\UI-TargetingFrame-Light.blp" })
	self.frame:EnableMouse(true)

	local leftInset = 25 * self.scale
	local rightInset = 40 * self.scale
	local topInset = 10 * self.scale
	local bottomInset = 50 * self.scale
	self.frame:SetHitRectInsets(leftInset, rightInset, topInset, bottomInset)

	self.frame:SetScript("OnClick", function()
		if UnitExists(self.focusGUID) then
			TargetUnit(self.focusGUID)
		end
	end)

    self.frame:SetScript("OnEnter", function()
        if self.focusGUID then
            SetMouseoverUnit(self.focusGUID)
        end
    end)

    self.frame:SetScript("OnLeave", function()
        SetMouseoverUnit()
    end)
	
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
    self.nameText:SetPoint("BOTTOM", self.healthBar, "TOP", 0, -3.5)
    self.nameText:SetFont(font, fontSize, flags)
    self.nameText:SetTextColor(1, 1, 1)
end

---------------------
-- Target of Focus --
---------------------
function ModernFocusFrame:CreateTargetOfFocusFrame()
    self.TargetOfFocusFrame = CreateFrame("Button", "TargetOfFocusFrame", UIParent)
    self.TargetOfFocusFrame:SetWidth(128 * self.scale)
    self.TargetOfFocusFrame:SetHeight(64 * self.scale)
    self.TargetOfFocusFrame:SetPoint("TOPRIGHT", self.manaBar, "BOTTOMRIGHT", self.manaBar:GetWidth() * 0.915, -3 * self.scale)
    self.TargetOfFocusFrame:SetBackdrop({ bgFile = "Interface\\AddOns\\ModernFocusFrame\\textures\\UI-SmallTargetingFramex-NoMana-Light.blp" })
	self.TargetOfFocusFrame:SetFrameLevel(self.frame:GetFrameLevel() + 1)
    self.TargetOfFocusFrame:EnableMouse(true)
	
	local leftInset = 1 * self.scale
	local rightInset = 32 * self.scale
	local topInset = 0.1 * self.scale
	local bottomInset = 25 * self.scale
	self.TargetOfFocusFrame:SetHitRectInsets(leftInset, rightInset, topInset, bottomInset)
	
	self.TargetOfFocusFrame:SetScript("OnClick", function()
		if UnitExists(self.tofocusGUID) then
			TargetUnit(self.tofocusGUID)
		end
	end)

    self.TargetOfFocusFrame:SetScript("OnEnter", function()
        if self.tofocusGUID then
            SetMouseoverUnit(self.tofocusGUID)
        end
    end)

    self.TargetOfFocusFrame:SetScript("OnLeave", function()
        SetMouseoverUnit()
    end)
	
	self.TargetOfFocusFrame:Hide()
end

function ModernFocusFrame:CreateToFPortrait()
    self.tofPortraitFrame = CreateFrame("Frame", nil, self.TargetOfFocusFrame)
    self.tofPortraitFrame:SetAllPoints(self.TargetOfFocusFrame)
    self.tofPortraitFrame:SetFrameLevel(self.TargetOfFocusFrame:GetFrameLevel() - 1)

    self.tofPortrait = self.tofPortraitFrame:CreateTexture(nil, "BACKGROUND")
    local tofPortraitSize = self.TargetOfFocusFrame:GetHeight() * 0.515
    self.tofPortrait:SetWidth(tofPortraitSize)
    self.tofPortrait:SetHeight(tofPortraitSize)
    self.tofPortrait:SetPoint("TOPLEFT", self.TargetOfFocusFrame, "TOPLEFT", -self.TargetOfFocusFrame:GetWidth() * -0.059, -self.TargetOfFocusFrame:GetHeight() * 0.10)
    self.tofPortraitFrame:Hide()
end

function ModernFocusFrame:CreateToFHealthBar()
    self.tofHealthBar = CreateFrame("StatusBar", nil, self.TargetOfFocusFrame)
    self.tofHealthBar:SetPoint("TOPLEFT", self.TargetOfFocusFrame, "TOPLEFT", self.TargetOfFocusFrame:GetWidth() * 0.358,
        -self.TargetOfFocusFrame:GetHeight() * 0.225)
    self.tofHealthBar:SetPoint("TOPRIGHT", self.TargetOfFocusFrame, "TOPRIGHT", -self.TargetOfFocusFrame:GetWidth() * 0.27,
        -self.TargetOfFocusFrame:GetHeight() * 0.05)
    self.tofHealthBar:SetHeight(self.TargetOfFocusFrame:GetHeight() * 0.16)
    self.tofHealthBar:SetStatusBarTexture("Interface\\AddOns\\ModernFocusFrame\\textures\\Smooth.blp")
    self.tofHealthBar:SetStatusBarColor(0, 1, 0)
    self.tofHealthBar:SetFrameLevel(self.TargetOfFocusFrame:GetFrameLevel() - 1)

    self.tofHealthBar:Hide()
end

function ModernFocusFrame:CreateToFTextElements()
    local fontSize = 12 * self.scale
    local font, _, flags = "Fonts\\FRIZQT__.TTF", fontSize, "OUTLINE"

    self.tofNameText = self.TargetOfFocusFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    self.tofNameText:SetPoint("TOP", self.tofHealthBar, "BOTTOM", 0, -3)
    self.tofNameText:SetFont(font, fontSize, flags)
    self.tofNameText:SetTextColor(1, 1, 1)
end