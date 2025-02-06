-- Utils.lua

-------------------
-- Frame Updates --
-------------------
local ModernFocusFrame = ModernFocusFrame

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

        self.portraitFrame:Show()
        self.levelFrame:Show()
        self.healthBar:Show()
        self.manaBar:Show()
		self.frame:Show()
    end
end

----------------
-- Frame Size --
----------------
function ModernFocusFrame:LoadScale()
    if not ModernFocusFrameDB then
        ModernFocusFrameDB = {}
    end
    if not ModernFocusFrameDB.scale then
        ModernFocusFrameDB.scale = 1
    end
    self.scale = ModernFocusFrameDB.scale
end

function ModernFocusFrame:SaveScale(newScale)
    ModernFocusFrameDB.scale = newScale
    self.scale = newScale

    if self.frame then
        self.frame:Hide()
        self.frame = nil
    end

	self:LoadScale()
    self:CreateMainFrame()
    self:CreateHealthBar()
    self:CreateManaBar()
    self:CreateTextElements()
    self:CreatePortrait()
    self:CreateLevelCircle()
    self:CreateCastBar()
    self:LoadPosition()
	
	if self.db.profile.isDraggingEnabled then
        self:EnableDragging()
    end

    self.focusGUID = nil
    self:RegisterEvent("UNIT_HEALTH")
    self:RegisterEvent("UNIT_MANA")
    self:RegisterEvent("UNIT_RAGE")
    self:RegisterEvent("UNIT_ENERGY")
    self:RegisterEvent("UNIT_LEVEL")
    self:RegisterEvent("UNIT_CASTEVENT")

    self.frame:SetScript("OnUpdate", function(_, elapsed) self:OnUpdate(elapsed) end)
end

---------------------------
-- Position and Dragging --
---------------------------
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

function ModernFocusFrame:DisableDragging()
    self.frame:SetMovable(false)
    self.frame:RegisterForDrag(nil)
    self.frame:SetScript("OnDragStart", nil)
    self.frame:SetScript("OnDragStop", nil)
end

-------------------
-- Focus Casting --
-------------------
function ModernFocusFrame:CastOnFocus(spellName)
    if not spellName or spellName == "" then
        DEFAULT_CHAT_FRAME:AddMessage("Usage: /mff cast <spell name>")
        return
    end

    if not self.focusGUID then
        DEFAULT_CHAT_FRAME:AddMessage("No focus target set.")
        return
    end

    CastSpellByName(spellName)

    if SpellIsTargeting() then
        SpellTargetUnit(self.focusGUID)
    end
end
