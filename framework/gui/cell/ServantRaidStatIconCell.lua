ServantRaidStatIconCell = class("ServantRaidStatIconCell", BaseCell)
local markstat = {
  "bigcat_icon_07",
  "bigcat_icon_08"
}

function ServantRaidStatIconCell:Init()
  ServantRaidStatIconCell.super.Init()
  self:FindObjs()
end

function ServantRaidStatIconCell:FindObjs()
  self.selfwidget = self.gameObject:GetComponent(UIWidget)
  self.icon = self:FindComponent("icon", UISprite)
  self.name = self:FindComponent("name", UILabel)
  self.rewardTip = self:FindGO("redtip")
  self.statmarks = {}
  TableUtility.ArrayPushBack(self.statmarks, self:FindComponent("Mark1", UISprite))
  TableUtility.ArrayPushBack(self.statmarks, self:FindComponent("Mark2", UISprite))
  TableUtility.ArrayPushBack(self.statmarks, self:FindComponent("Mark3", UISprite))
  TableUtility.ArrayPushBack(self.statmarks, self:FindComponent("Mark4", UISprite))
  TableUtility.ArrayPushBack(self.statmarks, self:FindComponent("Mark5", UISprite))
end

function ServantRaidStatIconCell:SetData(data)
  self.data = data
  self.icon.spriteName = data.staticData.Icon
  self.icon:MakePixelPerfect()
  self.name.text = data.staticData.Name
  if not self.data.Lock then
    self.selfwidget.alpha = 1
  else
    self.selfwidget.alpha = 0.5
  end
  for i = 1, #self.statmarks do
    self.statmarks[i].spriteName = markstat[1]
    self.statmarks[i].gameObject:SetActive(false)
  end
  local num = math.min(data.staticData.Monster_Boss, #self.statmarks)
  for i = 1, num do
    self.statmarks[i].gameObject:SetActive(true)
  end
  local exinfo = ServantRaidStatProxy.Instance:GetSingleRaidData(data.staticData.PageType, data.staticData.Difficulty)
  if exinfo and exinfo.exinfo and exinfo.exinfo[1] then
    exinfo = exinfo.exinfo[1]
    num = math.min(exinfo, #self.statmarks)
    for i = 1, num do
      self.statmarks[i].spriteName = markstat[2]
    end
  end
  self.rewardTip:SetActive(self.data.stat)
end

function ServantRaidStatIconCell:AttachClickEvent(handler)
  if not self.data.Lock then
    self:AddClickEvent(self.gameObject, handler)
  end
end

function ServantRaidStatIconCell:ShowSelected(istrue)
end
