local BaseCell = autoImport("BaseCell")
DisneyFriendsBondCell = class("DisneyFriendsBondCell", BaseCell)
autoImport("ManorPartnerHeadCell")

function DisneyFriendsBondCell:Init()
  DisneyFriendsBondCell.super.Init(self)
  self:FindObjs()
  self:AddCellClickEvent()
end

function DisneyFriendsBondCell:FindObjs()
  self.bondName = self:FindGO("BondName"):GetComponent(UILabel)
  self.bondEffect = self:FindGO("BondEffect"):GetComponent(UILabel)
  self.lockSymbol = self:FindGO("LockSymbol")
  self.headGrid = self:FindGO("HeadGrid"):GetComponent(UIGrid)
  self.partnerHeadCtrl = UIGridListCtrl.new(self.headGrid, ManorPartnerHeadCell, "ManorPartnerHeadCell")
  self.bgSprite = self.gameObject:GetComponent(UISprite)
end

function DisneyFriendsBondCell:SetData(data)
  self.data = data
  self.id = data.id
  local composeConfig = Table_ManorPartnerCompose[self.id]
  if not composeConfig then
    redlog("ManorPartnerCompose表缺少ID", self.id)
    return
  end
  local partners = composeConfig.Partners
  local partnerList = {}
  for i = 1, #partners do
    local tempData = {
      id = partners[i]
    }
    tempData.isUnlock = data.unlock
    table.insert(partnerList, tempData)
  end
  self.partnerHeadCtrl:ResetDatas(partnerList)
  local effectIds = composeConfig.Effects
  local str = ""
  for i = 1, #effectIds do
    local effectId = effectIds[i]
    local effectConfig = Table_AssetEffect[effectId]
    local effectDesc = effectConfig.Desc
    str = str .. effectDesc
  end
  self.bondEffect.text = str
  self.bondName.text = composeConfig.ComposeName or ""
  if not data.unlock then
    self.bondName.text = ""
    self.lockSymbol:SetActive(true)
  else
    self.lockSymbol:SetActive(false)
  end
end
