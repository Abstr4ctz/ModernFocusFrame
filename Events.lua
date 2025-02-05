--Events.lua

local ModernFocusFrame = ModernFocusFrame

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
            local progress = (elapsedTime / self.castDuration) * self.castBar:GetWidth()
            if self.isCasting then
                self.castBar:SetValue(elapsedTime)
                self.castSpark:SetPoint("CENTER", self.castBar, "LEFT", progress, 0)
            elseif self.isChanneling then
                local reverseProgress = (remainingTime / self.castDuration) * self.castBar:GetWidth()
                self.castBar:SetValue(remainingTime)
                self.castSpark:SetPoint("CENTER", self.castBar, "LEFT", reverseProgress, 0)
            end
        end
    end
end
