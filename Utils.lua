-- Utils.lua

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

        self.frame:Show()
        self.portraitFrame:Show()
        self.levelFrame:Show()
        self.healthBar:Show()
        self.manaBar:Show()
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
