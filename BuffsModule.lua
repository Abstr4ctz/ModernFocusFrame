-- BuffsModule.lua

local ModernFocusFrame = ModernFocusFrame

---------------------------
-- Buffs/Debuffs Module --
---------------------------

function ModernFocusFrame:InitBuffsModule()
    -- Cache for buffs and debuffs
    self.buffCache = {}
    self.debuffCache = {}
    
    -- Constants for buff/debuff display
    self.MAX_BUFFS = 5
    self.MAX_DEBUFFS = 5
    self.BUFF_SIZE = 23 * self.scale
    self.BUFF_SPACING = 2 * self.scale
    
    -- Register for UNIT_AURA events
    self:RegisterEvent("UNIT_AURA")
    
    -- Create buff/debuff container frames
    self:CreateBuffFrames()
    self:CreateDebuffFrames()
    self:SetupAuraTooltips()
end

function ModernFocusFrame:CreateBuffFrames()
    -- Create buff container frame
    self.buffsContainer = CreateFrame("Frame", nil, self.frame)
    -- Position buffs BELOW the cast bar
    self.buffsContainer:SetPoint("BOTTOMLEFT", self.castBar, "TOPLEFT", -17 * self.scale, 32 * self.scale)
    self.buffsContainer:SetWidth((self.BUFF_SIZE + self.BUFF_SPACING) * self.MAX_BUFFS - self.BUFF_SPACING)
    self.buffsContainer:SetHeight(self.BUFF_SIZE)
    
    -- Create individual buff frames
    self.buffFrames = {}
    for i = 1, self.MAX_BUFFS do
        local buff = CreateFrame("Button", nil, self.buffsContainer)
        buff:SetWidth(self.BUFF_SIZE)
        buff:SetHeight(self.BUFF_SIZE)
        buff:SetPoint("TOPLEFT", (i-1) * (self.BUFF_SIZE + self.BUFF_SPACING), 0)
        buff:EnableMouse(true)
        
        -- Create border first (to be behind the icon)
        buff.border = buff:CreateTexture(nil, "BACKGROUND")
        buff.border:SetTexture("Interface\\Buttons\\UI-Debuff-Overlays")
        buff.border:SetTexCoord(0.296875, 0.5703125, 0, 0.515625)
        buff.border:SetPoint("TOPLEFT", buff, "TOPLEFT", -1, 1)
        buff.border:SetPoint("BOTTOMRIGHT", buff, "BOTTOMRIGHT", 1, -1)
        buff.border:SetVertexColor(0, 1, 0, 1) -- Green border for buffs
        
        -- Create icon on top of border
        buff.icon = buff:CreateTexture(nil, "BORDER")
        buff.icon:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
        buff.icon:SetTexCoord(0.07, 0.93, 0.07, 0.93) -- Trim the icon borders
        buff.icon:SetPoint("TOPLEFT", buff, "TOPLEFT", 2, -2)
        buff.icon:SetPoint("BOTTOMRIGHT", buff, "BOTTOMRIGHT", -2, 2)
        
        -- Create count text
        buff.count = buff:CreateFontString(nil, "OVERLAY", "NumberFontNormal")
        buff.count:SetPoint("BOTTOMRIGHT", buff, "BOTTOMRIGHT", -1, 1)
        
        buff:Hide()
        self.buffFrames[i] = buff
    end
end

function ModernFocusFrame:CreateDebuffFrames()
    -- Create debuff container frame
    self.debuffsContainer = CreateFrame("Frame", nil, self.frame)
    self.debuffsContainer:SetPoint("TOPLEFT", self.buffsContainer, "BOTTOMLEFT", 0, -2 * self.scale)
    self.debuffsContainer:SetWidth((self.BUFF_SIZE + self.BUFF_SPACING) * self.MAX_DEBUFFS - self.BUFF_SPACING)
    self.debuffsContainer:SetHeight(self.BUFF_SIZE)
    
    -- Create individual debuff frames
    self.debuffFrames = {}
    for i = 1, self.MAX_DEBUFFS do
        local debuff = CreateFrame("Button", nil, self.debuffsContainer)
        debuff:SetWidth(self.BUFF_SIZE)
        debuff:SetHeight(self.BUFF_SIZE)
        debuff:SetPoint("TOPLEFT", (i-1) * (self.BUFF_SIZE + self.BUFF_SPACING), 0)
        debuff:EnableMouse(true)
        
        -- Create border first (to be behind the icon)
        debuff.border = debuff:CreateTexture(nil, "BACKGROUND")
        debuff.border:SetTexture("Interface\\Buttons\\UI-Debuff-Overlays")
        debuff.border:SetTexCoord(0.296875, 0.5703125, 0, 0.515625)
        debuff.border:SetPoint("TOPLEFT", debuff, "TOPLEFT", -1, 1)
        debuff.border:SetPoint("BOTTOMRIGHT", debuff, "BOTTOMRIGHT", 1, -1)
        debuff.border:SetVertexColor(1, 0, 0, 1) -- Red border for debuffs by default
        
        -- Create icon on top of border
        debuff.icon = debuff:CreateTexture(nil, "BORDER")
        debuff.icon:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
        debuff.icon:SetTexCoord(0.07, 0.93, 0.07, 0.93) -- Trim the icon borders
        debuff.icon:SetPoint("TOPLEFT", debuff, "TOPLEFT", 2, -2)
        debuff.icon:SetPoint("BOTTOMRIGHT", debuff, "BOTTOMRIGHT", -2, 2)
        
        -- Create count text
        debuff.count = debuff:CreateFontString(nil, "OVERLAY", "NumberFontNormal")
        debuff.count:SetPoint("BOTTOMRIGHT", debuff, "BOTTOMRIGHT", -1, 1)
        
        -- Create cooldown frame for timer
        debuff.cooldown = CreateFrame("Model", nil, debuff, "CooldownFrameTemplate")
        debuff.cooldown:SetAllPoints()
        debuff.cooldown:SetScale(0.6)
        debuff.cooldown:SetAlpha(0.8)
        
        -- Create timer text
        debuff.timer = CreateFrame("Frame", nil, debuff)
        debuff.timer:SetAllPoints()
        debuff.timer:SetFrameLevel(debuff:GetFrameLevel() + 1)
        debuff.timer.text = debuff.timer:CreateFontString(nil, "OVERLAY")
        debuff.timer.text:SetFont(STANDARD_TEXT_FONT, 10, "OUTLINE")
        debuff.timer.text:SetPoint("CENTER", debuff.timer, "CENTER", 0, 0)
        
        debuff:Hide()
        self.debuffFrames[i] = debuff
    end
end

function ModernFocusFrame:CreateBuffTooltip()
    -- Create tooltip for scanning buff/debuff names
    self.scanTip = CreateFrame("GameTooltip", "ModernFocusFrameScanTip", nil, "GameTooltipTemplate")
    self.scanTip:SetOwner(WorldFrame, "ANCHOR_NONE")
end

function ModernFocusFrame:ScanAndCacheAuras()
    if not self.focusGUID then return end
    
    -- Clear existing cache (using vanilla compatible method)
    for k in pairs(self.buffCache) do self.buffCache[k] = nil end
    for k in pairs(self.debuffCache) do self.debuffCache[k] = nil end
    
    local unit = self.focusGUID
    if not UnitExists(unit) then return end
    
    -- Create tooltip scanner if it doesn't exist
    if not self.scanTip then
        self:CreateBuffTooltip()
    end
    
    -- Scan buffs - In vanilla, UnitBuff only returns texture
    local buffIndex = 1
    while buffIndex <= 32 do -- Vanilla limit
        local buffTexture = UnitBuff(unit, buffIndex)
        if not buffTexture then break end
        
        -- Get tooltip info for the buff name
        self.scanTip:ClearLines()
        self.scanTip:SetUnitBuff(unit, buffIndex)
        local buffName = ModernFocusFrameScanTipTextLeft1:GetText()
        
        -- Store buff data
        self.buffCache[buffIndex] = {
            name = buffName or "Unknown",
            icon = buffTexture,
            count = 1 -- Vanilla doesn't return count, assume 1
        }
        
        buffIndex = buffIndex + 1
    end
    
    -- Scan debuffs - In vanilla, UnitDebuff returns texture, count, and debuff type
    local debuffIndex = 1
    while debuffIndex <= 16 do -- Vanilla limit
        local debuffTexture, debuffCount, debuffType = UnitDebuff(unit, debuffIndex)
        if not debuffTexture then break end
        
        -- Get tooltip info for the debuff name
        self.scanTip:ClearLines()
        self.scanTip:SetUnitDebuff(unit, debuffIndex)
        local debuffName = ModernFocusFrameScanTipTextLeft1:GetText()
        
        -- Store debuff data
        self.debuffCache[debuffIndex] = {
            name = debuffName or "Unknown",
            icon = debuffTexture,
            count = debuffCount or 1,
            debuffType = debuffType
        }
        
        debuffIndex = debuffIndex + 1
    end
    
    -- Update the visual display
    self:UpdateAurasDisplay()
end

function ModernFocusFrame:UpdateAurasDisplay()
    -- Update buffs display
    for i = 1, self.MAX_BUFFS do
        local buffFrame = self.buffFrames[i]
        local buffInfo = self.buffCache[i]
        
        if buffInfo and buffInfo.icon then
            buffFrame.icon:SetTexture(buffInfo.icon)
            
            if buffInfo.count and buffInfo.count > 1 then
                buffFrame.count:SetText(buffInfo.count)
                buffFrame.count:Show()
            else
                buffFrame.count:Hide()
            end
            
            buffFrame:Show()
        else
            buffFrame:Hide()
        end
    end
    
    -- Update debuffs display
    for i = 1, self.MAX_DEBUFFS do
        local debuffFrame = self.debuffFrames[i]
        local debuffInfo = self.debuffCache[i]
        
        if debuffInfo and debuffInfo.icon then
            debuffFrame.icon:SetTexture(debuffInfo.icon)
            
            if debuffInfo.count and debuffInfo.count > 1 then
                debuffFrame.count:SetText(debuffInfo.count)
                debuffFrame.count:Show()
            else
                debuffFrame.count:Hide()
            end
            
            -- Set border color based on debuff type
            if debuffInfo.debuffType then
                local color = {1, 0, 0} -- Default red
                if debuffInfo.debuffType == "Magic" then
                    color = {0.2, 0.6, 1.0} -- Blue
                elseif debuffInfo.debuffType == "Curse" then
                    color = {0.6, 0.0, 1.0} -- Purple
                elseif debuffInfo.debuffType == "Disease" then
                    color = {0.6, 0.4, 0} -- Brown
                elseif debuffInfo.debuffType == "Poison" then
                    color = {0.0, 0.6, 0} -- Green
                end
                debuffFrame.border:SetVertexColor(color[1], color[2], color[3], 1)
            else
                debuffFrame.border:SetVertexColor(1, 0, 0, 1) -- Default red
            end
            
            debuffFrame:Show()
        else
            debuffFrame:Hide()
        end
    end
end

function ModernFocusFrame:SetupAuraTooltips()
    -- Setup tooltips for buff frames
    for i = 1, self.MAX_BUFFS do
        local buffFrame = self.buffFrames[i]
        
        buffFrame:SetScript("OnEnter", function()
            if self.buffCache[i] then
                GameTooltip:SetOwner(buffFrame, "ANCHOR_RIGHT")
                GameTooltip:SetText(self.buffCache[i].name or "Unknown Buff")
                GameTooltip:Show()
            end
        end)
        
        buffFrame:SetScript("OnLeave", function()
            GameTooltip:Hide()
        end)
    end
    
    -- Setup tooltips for debuff frames
    for i = 1, self.MAX_DEBUFFS do
        local debuffFrame = self.debuffFrames[i]
        
        debuffFrame:SetScript("OnEnter", function()
            if self.debuffCache[i] then
                GameTooltip:SetOwner(debuffFrame, "ANCHOR_RIGHT")
                GameTooltip:SetText(self.debuffCache[i].name or "Unknown Debuff")
                
                if self.debuffCache[i].debuffType then
                    GameTooltip:AddLine(self.debuffCache[i].debuffType, 1, 0.4, 0.4)
                end
                
                GameTooltip:Show()
            end
        end)
        
        debuffFrame:SetScript("OnLeave", function()
            GameTooltip:Hide()
        end)
    end
end

-- Handle UNIT_AURA event
function ModernFocusFrame:UNIT_AURA(unit)
    local exists, unitGUID = UnitExists(unit)
    if exists and unitGUID and self.focusGUID == unitGUID then
        self:ScanAndCacheAuras()
    end
end
