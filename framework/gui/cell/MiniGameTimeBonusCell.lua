local BaseCell = autoImport("BaseCell")
MiniGameTimeBonusCell = class("MiniGameTimeBonusCell", BaseCell)
local color1, color2 = LuaColor.New(0.6470588235294118, 0.9607843137254902, 0.39215686274509803, 1), LuaColor.New(0.8862745098039215, 0.2627450980392157, 0.13725490196078433, 1)

function MiniGameTimeBonusCell:Init()
  self:FindObjs()
end

function MiniGameTimeBonusCell:FindObjs()
  self.number = self:FindComponent("text", UILabel)
end

function MiniGameTimeBonusCell:SetData(data)
  if type(data) == "number" and data ~= 0 then
    if 0 < data then
      self.number.color = color1
      self.number.text = "+" .. math.ceil(math.abs(data)) .. "s"
    else
      self.number.color = color2
      self.number.text = "-" .. math.ceil(math.abs(data)) .. "s"
    end
    self.gameObject:SetActive(true)
    self.timeTick = TimeTickManager.Me():CreateOnceDelayTick(2500, function(owner, deltaTime)
      self.gameObject:SetActive(false)
    end, self)
  else
    self.gameObject:SetActive(false)
  end
end

function MiniGameTimeBonusCell:OnCellDestroy()
  if self.timeTick ~= nil then
    tickMgr:ClearTick(self)
    self.timeTick = nil
  end
end
