-- SlashCommands.lua

local ModernFocusFrame = ModernFocusFrame

SLASH_FOCUS1 = "/mfffocus"
SlashCmdList["FOCUS"] = function(msg)
    local exists, targetGUID = UnitExists("target")
    if msg == "clear" or not exists then
        ModernFocusFrame.focusGUID = nil
        ModernFocusFrame.frame:Hide()
    elseif exists and targetGUID then
        ModernFocusFrame.focusGUID = targetGUID
        ModernFocusFrame.frame:Show()
        ModernFocusFrame:UpdateModernFocusFrame()
    else
        DEFAULT_CHAT_FRAME:AddMessage("No valid target to focus.")
    end
end

SLASH_FOCUSMOUSE1 = "/mffmouse"
SlashCmdList["FOCUSMOUSE"] = function(msg)
    local exists, targetGUID = UnitExists("mouseover")
    if msg == "clear" or not exists then
        ModernFocusFrame.focusGUID = nil
        ModernFocusFrame.frame:Hide()
    elseif exists and targetGUID then
        ModernFocusFrame.focusGUID = targetGUID
        ModernFocusFrame.frame:Show()
        ModernFocusFrame:UpdateModernFocusFrame()
    else
        DEFAULT_CHAT_FRAME:AddMessage("No valid mouseover target to focus.")
    end
end

SLASH_SCALE1 = "/mffscale"
SlashCmdList["SCALE"] = function(msg)
    local newScale = tonumber(msg)
    
    if newScale and newScale > 0 then
        ModernFocusFrame:SaveScale(newScale)
        DEFAULT_CHAT_FRAME:AddMessage("ModernFocusFrame: Scale set to " .. newScale)
    else
        DEFAULT_CHAT_FRAME:AddMessage("Usage: /mfscale <number> (e.g., /mfscale 1.2)")
    end
end

