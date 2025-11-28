local baseCell = autoImport("BaseCell")
PhotoStandSponsorListCell = class("PhotoStandSponsorListCell", baseCell)

function PhotoStandSponsorListCell:Init()
  self:initView()
end

function PhotoStandSponsorListCell:initView()
  self.nameLb = self:FindComponent("name", UILabel)
  self.new = self:FindGO("new")
  self.num = self:FindComponent("num", UILabel)
  self.sames = self:FindGO("sames")
  self.nameBC = self:FindComponent("name", BoxCollider)
  self:AddClickEvent(self.nameLb.gameObject, function(obj)
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end

function PhotoStandSponsorListCell:SetData(data)
  self.data = data
  self.nameLb.text = data.name
  self.new:SetActive(data.isNew)
  self.num.text = StringUtil.NumThousandFormat(data.zeny or (data.lottery or 0) * (GameConfig.PhotoBoard.AwardRate or 1))
  local ccneed = MyselfProxy.Instance:GetServerId() == self.data.serverid
  self.sames:SetActive(ccneed)
  self.nameBC.enabled = ccneed
end
