local BaseCell = autoImport("BaseCell")
DisneyFriendHeartCell = class("DisneyFriendHeartCell", BaseCell)

function DisneyFriendHeartCell:Init()
  DisneyFriendHeartCell.super.Init(self)
  self:FindObjs()
  self:AddCellClickEvent()
end

function DisneyFriendHeartCell:FindObjs()
  self.heartSprite = self.gameObject:GetComponent(UISprite)
  self.gift = self:FindGO("Gift")
  self.heartQuarter = {}
  for i = 1, 4 do
    self.heartQuarter[i] = self:FindGO("heart" .. i):GetComponent(UISprite)
  end
end

function DisneyFriendHeartCell:SetData(data)
  self.data = data
end

function DisneyFriendHeartCell:SetStatus(status)
  if status == 1 then
    self.heartSprite.color = LuaGeometry.GetTempVector4(0.9686274509803922, 0.5490196078431373, 0.5490196078431373, 1)
  else
    self.heartSprite.color = LuaGeometry.GetTempVector4(0.9098039215686274, 0.9411764705882353, 0.9686274509803922, 1)
  end
end

function DisneyFriendHeartCell:SetHeartNum(num)
  if num == 0 then
    for i = 1, 4 do
      self.heartQuarter[i].gameObject:SetActive(false)
    end
    return
  end
  for i = 1, 4 do
    if i <= num then
      self.heartQuarter[i].gameObject:SetActive(true)
      if num == 4 and self.gift.activeSelf then
        self.heartQuarter[i].color = LuaGeometry.GetTempVector4(0.7568627450980392, 0.5490196078431373, 0.9686274509803922, 1)
      else
        self.heartQuarter[i].color = LuaGeometry.GetTempVector4(0.9686274509803922, 0.5490196078431373, 0.5490196078431373, 1)
      end
    else
      self.heartQuarter[i].gameObject:SetActive(false)
    end
  end
end

function DisneyFriendHeartCell:SetGiftStatus(bool)
  self.gift:SetActive(bool)
end
