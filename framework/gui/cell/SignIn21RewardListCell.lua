local baseCell = autoImport("BaseCell")
SignIn21RewardListCell = class("SignIn21RewardListCell", baseCell)

function SignIn21RewardListCell:Init()
  self.lvLabel = self:FindComponent("LvLabel", UILabel)
  self.icon1 = self:FindComponent("Icon1", UISprite)
  self.icon2 = self:FindComponent("Icon2", UISprite)
  self.drag = self.gameObject:GetComponent(UIDragScrollView)
  self.reward1Got = self:FindGO("Reward1Got")
  self.reward2Got = self:FindGO("Reward2Got")
  local clickEvent = function(index)
    if not self.data then
      return
    end
    self:PassEvent(MouseEvent.MouseClick, self.data[index] and self.data[index].id)
  end
  self:AddClickEvent(self.icon1.gameObject, function()
    clickEvent(1)
  end)
  self:AddClickEvent(self.icon2.gameObject, function()
    clickEvent(2)
  end)
  UIUtil.HandleDragScrollForObj(self.icon1.gameObject, self.drag)
  UIUtil.HandleDragScrollForObj(self.icon2.gameObject, self.drag)
end

function SignIn21RewardListCell:SetData(data)
  self.data = data
  if not data then
    return
  end
  self.lvLabel.text = "Lv." .. (data.level or 0)
  local id, sprite
  for i = 1, 2 do
    id, sprite = data[i] and data[i].id, self["icon" .. i]
    if id and Table_Item[id] then
      sprite.gameObject:SetActive(true)
      IconManager:SetItemIcon(Table_Item[id].Icon, sprite)
    else
      sprite.gameObject:SetActive(false)
    end
  end
  local level = SignIn21Proxy.Instance:GetLevelAndProgressFromTargetPoint()
  if not level then
    LogUtility.Warning("Cannot get Level&progress from targetPoint!!")
    return
  end
  self.reward1Got:SetActive(level >= data.level)
  self.reward2Got:SetActive(level >= data.level)
end
