-- SlashCommands.lua

local ModernFocusFrame = ModernFocusFrame

SLASH_MFF1 = "/mff"
SlashCmdList["MFF"] = function(msg)
    if not msg or msg == "" then
        DEFAULT_CHAT_FRAME:AddMessage("ModernFocusFrame Commands:")
        DEFAULT_CHAT_FRAME:AddMessage("/mff focus - Set current target as focus")
        DEFAULT_CHAT_FRAME:AddMessage("/mff mouse - Set mouseover target as focus")
        DEFAULT_CHAT_FRAME:AddMessage("/mff scale <value> - Set frame scale (e.g., /mff scale 1.2)")
        DEFAULT_CHAT_FRAME:AddMessage("/mff lock - Toggle frame dragging lock/unlock")
        DEFAULT_CHAT_FRAME:AddMessage("/mff cast <spell> - Cast spell on focus without changing target")
        return
    end

    local spacePos = strfind(msg, " ")
    local command, arg

    if spacePos then
        command = strsub(msg, 1, spacePos - 1)
        arg = strsub(msg, spacePos + 1)
    else
        command = msg
        arg = ""
    end

    if command == "focus" then
        local exists, targetGUID = UnitExists("target")
        if arg == "clear" or not exists then
            ModernFocusFrame.focusGUID = nil
			ModernFocusFrame.tofocusGUID = nil
			ModernFocusFrame.TargetOfFocusFrame:Hide()
            ModernFocusFrame.frame:Hide()
        elseif exists and targetGUID then
            ModernFocusFrame.focusGUID = targetGUID
			ModernFocusFrame.TargetOfFocusFrame:Hide()
			ModernFocusFrame.tofocusGUID = nil
            ModernFocusFrame.frame:Show()
            ModernFocusFrame:UpdateModernFocusFrame()
        else
            DEFAULT_CHAT_FRAME:AddMessage("No valid target to focus.")
        end

    elseif command == "mouse" then
        local exists, targetGUID = UnitExists("mouseover")
        if arg == "clear" or not exists then
            ModernFocusFrame.focusGUID = nil
			ModernFocusFrame.tofocusGUID = nil
			ModernFocusFrame.TargetOfFocusFrame:Hide()
            ModernFocusFrame.frame:Hide()
        elseif exists and targetGUID then
            ModernFocusFrame.focusGUID = targetGUID
			ModernFocusFrame.TargetOfFocusFrame:Hide()
			ModernFocusFrame.tofocusGUID = nil
            ModernFocusFrame.frame:Show()
            ModernFocusFrame:UpdateModernFocusFrame()
        else
            DEFAULT_CHAT_FRAME:AddMessage("No valid mouseover target to focus.")
        end

    elseif command == "scale" then
        local newScale = tonumber(arg)
        if newScale and newScale > 0 then
            ModernFocusFrame:SaveScale(newScale)
            DEFAULT_CHAT_FRAME:AddMessage("ModernFocusFrame: Scale set to " .. newScale)
        else
            DEFAULT_CHAT_FRAME:AddMessage("Usage: /mff scale <number> (e.g., /mff scale 1.2)")
        end

    elseif command == "lock" then
        ModernFocusFrame.db.profile.isDraggingEnabled = not ModernFocusFrame.db.profile.isDraggingEnabled
        if ModernFocusFrame.db.profile.isDraggingEnabled then
            ModernFocusFrame:EnableDragging()
            DEFAULT_CHAT_FRAME:AddMessage("ModernFocusFrame: Dragging unlocked.")
        else
            ModernFocusFrame:DisableDragging()
            DEFAULT_CHAT_FRAME:AddMessage("ModernFocusFrame: Dragging locked.")
        end

    elseif command == "cast" then
        ModernFocusFrame:CastOnFocus(arg)
    else
        DEFAULT_CHAT_FRAME:AddMessage("Unknown command. Type /mff for help.")
    end
end

-- Clear aura display when focus is removed
local function ClearAuraDisplay()
    if ModernFocusFrame.buffFrames then
        for i = 1, ModernFocusFrame.MAX_BUFFS do
            ModernFocusFrame.buffFrames[i]:Hide()
        end
    end
    
    if ModernFocusFrame.debuffFrames then
        for i = 1, ModernFocusFrame.MAX_DEBUFFS do
            ModernFocusFrame.debuffFrames[i]:Hide()
        end
    end
end

local originalSlashFunc = SlashCmdList["MFF"]

-- Replace with our modified function that handles aura updating
SlashCmdList["MFF"] = function(msg)
    local oldFocusGUID = ModernFocusFrame.focusGUID
    originalSlashFunc(msg)
    
    if not ModernFocusFrame.focusGUID and oldFocusGUID then
        ClearAuraDisplay()
    elseif ModernFocusFrame.focusGUID and ModernFocusFrame.focusGUID ~= oldFocusGUID then
        ModernFocusFrame:ScanAndCacheAuras()
    end
end