MidSummerHeartCell = class("MidSummerHeartCell", CoreView)
local availableColor, unavailableColor = LuaColor.New(0.9686274509803922, 0.5490196078431373, 0.5490196078431373), LuaColor.New(0.6705882352941176, 0.7176470588235294, 0.807843137254902)

function MidSummerHeartCell:ctor(obj)
  MidSummerHeartCell.super.ctor(self, obj)
  self.icon = self.gameObject:GetComponent(UISprite)
end

function MidSummerHeartCell:SetData(available)
  self.icon.color = available and availableColor or unavailableColor
end
