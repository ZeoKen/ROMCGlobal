EvidenceDetailTip = class("EvidenceDetailTip", BaseTip)
autoImport("EvidenceTipCell")

function EvidenceDetailTip:Init()
  EvidenceDetailTip.super.Init(self)
  self.closecomp = self.gameObject:GetComponent(CloseWhenClickOtherPlace)
  self.nameLabel = self:FindGO("Name"):GetComponent(UILabel)
  self.descLabel = self:FindGO("Desc"):GetComponent(UILabel)
  self.descScrollView = self:FindGO("DescScrollView"):GetComponent(UIScrollView)
  self.descTable = self:FindGO("DescTable"):GetComponent(UITable)
  self.messageGrid = self:FindGO("MessageGrid"):GetComponent(UITable)
  self.messageGridCtrl = UIGridListCtrl.new(self.messageGrid, EvidenceTipCell, "EvidenceTipCellType2")
  self.repairBtn = self:FindGO("RepairBtn")
  self.askServiceBtn = self:FindGO("AskServiceBtn")
  
  function self.closecomp.callBack(go)
    self:CloseSelf()
  end
end

function EvidenceDetailTip:SetData(data)
  self.data = data
  local id = data
  xdlog("id", id)
  local config = Table_Evidence[id]
  if not config then
    return
  end
  self.nameLabel.text = config.Name
  local itemData = Table_Item[id]
  self.descLabel.text = itemData and itemData.Desc
  local evidenceMessage = config and config.Messages
  local totalEvidenceMessage = evidenceMessage and #evidenceMessage or 0
  self.messageGridCtrl:SetEmptyDatas(totalEvidenceMessage)
  local evidenceData = SevenRoyalFamiliesProxy.Instance.evidenceData
  local info = evidenceData and evidenceData[id]
  local unlockMessages = info and info.unlockMessage
  local cells = self.messageGridCtrl:GetCells()
  for i = 1, #cells do
    local single = cells[i]
    if unlockMessages and unlockMessages[i] then
      single:SetData(unlockMessages[i])
    end
  end
  self.messageGrid:Reposition()
  self.descTable:Reposition()
end

function EvidenceDetailTip:SetPos(pos)
  if self.gameObject ~= nil then
    local p = self.gameObject.transform.position
    pos.z = p.z
    self.gameObject.transform.position = pos
  else
    self.pos = pos
  end
end

function EvidenceDetailTip:CloseSelf()
  if self.callback then
    self.callback(self.callbackParam)
  end
  TipsView.Me():HideCurrent()
end

function EvidenceDetailTip:DestroySelf()
  if not Slua.IsNull(self.gameObject) then
    GameObject.Destroy(self.gameObject)
  end
end
