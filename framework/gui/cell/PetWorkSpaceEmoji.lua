local BaseCell = autoImport("BaseCell")
PetWorkSpaceEmoji = class("PetWorkSpaceEmoji", BaseCell)
local strFormat = "x%s"
local petRestIcon = "pet_icon_zz"
local IconSize = {
  reward = {96, 93},
  rest = {58, 56}
}
local _CommonRewardIcon = "Reward"

function PetWorkSpaceEmoji:ctor(go)
  PetWorkSpaceEmoji.super.ctor(self, go)
end

function PetWorkSpaceEmoji:Init()
  self:FindObj()
end

function PetWorkSpaceEmoji:FindObj()
  self.bg = self:FindGO("pic_biaoqingbg")
  self.icon = self:FindComponent("pic_biaoqinggif", UISprite)
  self.num = self:FindComponent("num", UILabel)
  self.redPoint = self:FindGO("RedPoint")
  self.rest = self:FindGO("rest")
  self:AddCellClickEvent()
end

local tempVector3 = LuaVector3.Zero()

function PetWorkSpaceEmoji:SetData(data)
  if not self.gameObject then
    return
  end
  self.data = data
  if data then
    self.gameObject:SetActive(true)
    if type(data) == "table" then
      local icon = Table_Item[data.id].Icon
      IconManager:SetItemIcon(icon, self.icon)
      self:Show(self.num)
      self.num.text = string.format(strFormat, data.num)
      tempVector3[1] = 8
      self:Show(self.icon)
      self:Hide(self.rest)
      self:Show(self.bg)
    elseif data == "rest" then
      tempVector3[1] = 0
      self:Hide(self.icon)
      self:Show(self.rest)
      self:Show(self.bg)
    elseif data == "paySignReward" then
      self:Hide(self.num)
      self:Hide(self.rest)
      self:Show(self.redPoint)
      self:Hide(self.bg)
      IconManager:SetUIIcon(_CommonRewardIcon, self.icon)
    end
    self.bg.transform.localPosition = tempVector3
  else
    self.gameObject:SetActive(false)
  end
end

function PetWorkSpaceEmoji:SetFavorData(data)
  self:Hide(self.num)
  self:Hide(self.rest)
  self:Show(self.icon)
  self.icon.spriteName = "pet_icon_touch"
end

function PetWorkSpaceEmoji:ShowRedPoint(show)
  self.redPoint:SetActive(show)
end

function PetWorkSpaceEmoji:SetNum(num)
  self.num.text = string.format(strFormat, num)
end
