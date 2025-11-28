local BaseCell = autoImport("BaseCell")
HomeTelevisionCell = class("HomeTelevisionCell", BaseCell)
local blueColor = LuaColor.New(0.5490196078431373, 0.796078431372549, 0.9529411764705882, 1)
local greyColor = LuaColor.New(0.6274509803921569, 0.6274509803921569, 0.6274509803921569, 1)

function HomeTelevisionCell:Init()
  self.chooseSymbol = self:FindGO("ChooseSymbol")
  self.iconSp = self:FindComponent("Icon", UISprite)
  self.titleLabel = self:FindComponent("Title", UILabel)
  self.descLabel = self:FindComponent("Desc", UILabel)
  self.playBtn = self:FindGO("PlayBtn")
  self:AddClickEvent(self.gameObject, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
  self:AddClickEvent(self.playBtn, function()
    self:PassEvent(HomeEvent.WatchTV, self)
  end)
end

function HomeTelevisionCell:SetData(data)
  self.data = data
  local isUnlocked = self:CheckIsCgUnlocked()
  self.titleLabel.text = data.NameZh
  self.titleLabel.color = isUnlocked and blueColor or greyColor
  self.iconSp.color = isUnlocked and ColorUtil.NGUIWhite or greyColor
  self.descLabel.text = isUnlocked and self:GetMenuText() or data.UnlockDesc
  self.playBtn:SetActive(isUnlocked)
  self:UpdateChoose()
end

function HomeTelevisionCell:SetChoose(chooseId)
  self.chooseId = chooseId
  self:UpdateChoose()
end

function HomeTelevisionCell:UpdateChoose()
  if not self.chooseSymbol then
    return
  end
  self.chooseSymbol:SetActive(self.chooseId ~= nil and self.data ~= nil and self.data.id == self.chooseId)
end

function HomeTelevisionCell:CheckIsCgUnlocked()
  return FunctionUnLockFunc.Me():CheckCanOpen(self.data and self.data.menuid)
end

function HomeTelevisionCell:GetMenuText()
  if not self.data or not self.data.menuid then
    return
  end
  return string.gsub(Table_Menu[self.data.menuid].text, "解锁", "") or ""
end
