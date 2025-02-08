-- Core.lua

ModernFocusFrame = AceLibrary("AceAddon-2.0"):new("AceEvent-2.0", "AceDB-2.0")

function ModernFocusFrame:OnInitialize()
    self:RegisterDB("ModernFocusFrameDB")
    self:RegisterDefaults("profile", {
        position = { "CENTER", "UIParent", "CENTER", 0, 0 },
		isDraggingEnabled = false,
		isCastHistoryEnabled = true
    })

	self:LoadScale()
    self:CreateMainFrame()
    self:CreateHealthBar()
    self:CreateManaBar()
    self:CreateTextElements()
    self:CreatePortrait()
    self:CreateLevelCircle()
    self:CreateCastBar()

	self:CreateTargetOfFocusFrame()
	self:CreateToFPortrait()
	self:CreateToFHealthBar()
	self:CreateToFTextElements()

	self:LoadPosition()

	if self.db.profile.isDraggingEnabled then
        self:EnableDragging()
    end

    self.focusGUID = nil
	self.tofocusGUID = nil
    self:RegisterEvent("UNIT_HEALTH")
    self:RegisterEvent("UNIT_MANA")
    self:RegisterEvent("UNIT_RAGE")
    self:RegisterEvent("UNIT_ENERGY")
    self:RegisterEvent("UNIT_LEVEL")
    self:RegisterEvent("UNIT_CASTEVENT")

    self.frame:SetScript("OnUpdate", function(_, elapsed) self:OnUpdate(elapsed) end)
end

