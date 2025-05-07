-- Core.lua

ModernFocusFrame = AceLibrary("AceAddon-2.0"):new("AceEvent-2.0", "AceDB-2.0")

function ModernFocusFrame:OnInitialize()
    self:RegisterDB("ModernFocusFrameDB")
    self:RegisterDefaults("profile", {
        position = { "CENTER", "UIParent", "CENTER", 0, 0 },
        isDraggingEnabled = false,
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

    -- Initialize buff/debuff module
    self:InitBuffsModule()


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

    self.frame:SetScript("OnUpdate", function() self:OnUpdate(arg1) end)
end

RAID_CLASS_COLORS = {
  ["WARRIOR"] = { r = 0.78, g = 0.61, b = 0.43, colorStr = "ffc79c6e" },
  ["MAGE"]    = { r = 0.41, g = 0.8,  b = 0.94, colorStr = "ff69ccf0" },
  ["ROGUE"]   = { r = 1,    g = 0.96, b = 0.41, colorStr = "fffff569" },
  ["DRUID"]   = { r = 1,    g = 0.49, b = 0.04, colorStr = "ffff7d0a" },
  ["HUNTER"]  = { r = 0.67, g = 0.83, b = 0.45, colorStr = "ffabd473" },
  ["SHAMAN"]  = { r = 0.14, g = 0.35, b = 1.0,  colorStr = "ff0070de" },
  ["PRIEST"]  = { r = 1,    g = 1,    b = 1,    colorStr = "ffffffff" },
  ["WARLOCK"] = { r = 0.58, g = 0.51, b = 0.79, colorStr = "ff9482c9" },
  ["PALADIN"] = { r = 0.96, g = 0.55, b = 0.73, colorStr = "fff58cba" },
}