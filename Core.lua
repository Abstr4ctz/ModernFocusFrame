-- Core.lua

ModernFocusFrame = AceLibrary("AceAddon-2.0"):new("AceEvent-2.0", "AceDB-2.0")
ModernFocusFrame.scale = 1

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

    function HandleUnitUpdateWrapper(event, unit)
		ModernFocusFrame:HandleUnitUpdate(unit)
    end

    self:RegisterEvent("UNIT_HEALTH", HandleUnitUpdateWrapper)
    self:RegisterEvent("UNIT_MANA", HandleUnitUpdateWrapper)
    self:RegisterEvent("UNIT_RAGE", HandleUnitUpdateWrapper)
    self:RegisterEvent("UNIT_ENERGY", HandleUnitUpdateWrapper)
    self:RegisterEvent("UNIT_LEVEL", HandleUnitUpdateWrapper)

    self:RegisterEvent("UNIT_CASTEVENT")

    self.frame:SetScript("OnUpdate", function(_, elapsed) self:OnUpdate(elapsed) end)
end

