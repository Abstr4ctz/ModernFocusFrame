-- SlashCommands.lua

local ModernFocusFrame = ModernFocusFrame

SLASH_FOCUS1 = "/focus"
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

SLASH_FOCUSMOUSE1 = "/focusmouse"
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
