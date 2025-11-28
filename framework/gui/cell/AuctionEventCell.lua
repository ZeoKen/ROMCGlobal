local baseCell = autoImport("BaseCell")
AuctionEventCell = class("AuctionEventCell", baseCell)
local pos = LuaVector3.Zero()

function AuctionEventCell:Init()
  self:FindObjs()
  self:AddEvts()
  self:InitShow()
end

function AuctionEventCell:FindObjs()
  self.time = self:FindGO("Time"):GetComponent(UILabel)
  self.millisecond = self:FindGO("Millisecond"):GetComponent(UILabel)
  self.content = self:FindGO("Content"):GetComponent(UILabel)
  self.clickUrl = self.content.gameObject:GetComponent(UILabelClickUrl)
  self.root = self:FindGO("Root")
end

function AuctionEventCell:AddEvts()
  function self.clickUrl.callback(url)
    if url ~= nil and self.data ~= nil then
      ServiceSessionSocialityProxy.Instance:CallQueryUserInfoCmd(self.data.playerid)
    end
  end
end

function AuctionEventCell:InitShow()
  self.contentOriginalHight = 34
  self.contentOffset = 17
  LuaVector3.Better_Set(pos, LuaGameObject.GetLocalPosition(self.root.transform))
end

function AuctionEventCell:SetData(data)
  self.data = data
  self.gameObject:SetActive(data ~= nil)
  if data then
    self.time.text = data:GetTimeString()
    self.millisecond.text = string.format(".%03d", data.time % 1000)
    self.content.text = data:GetContent()
    local sizeY = self.content.localSize.y
    local rate = sizeY / self.contentOriginalHight
    pos[2] = self.contentOffset * (rate - 1)
    self.root.transform.localPosition = pos
  end
end
