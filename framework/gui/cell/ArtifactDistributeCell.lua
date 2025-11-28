local BaseCell = autoImport("BaseCell")
ArtifactDistributeCell = class("ArtifactDistributeCell", BaseCell)
local btnPhase = {
  Retrieve = "com_btn_1",
  RetrieveLab = Color(0.14901960784313725, 0.24313725490196078, 0.5568627450980392),
  RetrievePhase = Color(0.3568627450980392, 0.5215686274509804, 0.796078431372549),
  RetrieveCancle = "com_btn_2",
  RetrieveCancleLab = Color(0.6196078431372549, 0.33725490196078434, 0 / 255),
  RetrieveCanclePhase = Color(0.5607843137254902, 0.5607843137254902, 0.5607843137254902),
  UnUsing = "com_btn_3",
  UnUsingLab = Color(0.1607843137254902, 0.4117647058823529, 0 / 255),
  UnUsingPhase = Color(0.5176470588235295, 0.796078431372549, 0.4666666666666667)
}

function ArtifactDistributeCell:Init()
  self:FindObj()
  self:AddEvts()
end

function ArtifactDistributeCell:FindObj()
  self.name = self:FindComponent("name", UILabel)
  self.phase = self:FindComponent("phase", UILabel)
  self.btn = self:FindComponent("btn", UISprite)
  self.btnName = self:FindComponent("btnLab", UILabel)
  local targetCellGO = self:FindGO("TargetCell")
  self.targetCell = ItemCell.new(targetCellGO)
  self.checkBtn = self:FindGO("CheckBtn"):GetComponent(UIToggle)
  self:AddClickEvent(targetCellGO, function()
    xdlog("点击")
    self:ShowArtifactTip()
  end)
  self:AddClickEvent(self.checkBtn.gameObject, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end

function ArtifactDistributeCell:AddEvts()
  self:AddButtonEvent("btn", function()
    self.selected = not self.selected
    self:UpdateFuncBtn()
  end)
end

function ArtifactDistributeCell:SetData(data)
  self.data = data
  if data then
    self.selected = false
    self.checkBtn.value = false
    self.Phase = 0
    self.gameObject:SetActive(true)
    self:ClearTick()
    self.guid = data.guid
    local guid = data.guid
    local id = data.itemID
    self.name.text = data.itemStaticData.NameZh
    local unUsing = data.ownerID == 0
    local retrieving = 0 == data.retrieveTime
    if unUsing then
      self.itemdata = GuildProxy.Instance:GetGuildPackItemByGuid(guid)
    else
      self.itemdata = ItemData.new(guid, id)
    end
    self.targetCell:SetData(self.itemdata)
    self:UpdateFuncBtn(data)
  else
    self.gameObject:SetActive(false)
  end
end

function ArtifactDistributeCell:UpdateFuncBtn(data)
  local data = data or self.data
  if data then
    local id = data.itemID
    self.name.text = data.itemStaticData.NameZh
    local unUsing = data.ownerID == 0
    if unUsing then
      self.phase.text = ZhString.ArtifactMake_UnUsing
      self.phase.color = btnPhase.UnUsingPhase
    else
      self.phase.text = ZhString.ArtifactMake_Using
      self.phase.color = btnPhase.RetrievePhase
    end
  end
end

function ArtifactDistributeCell:_refreshTime()
  if self:ObjIsNil(self.gameObject) then
    self:ClearTick()
    return
  end
  local leftTime = self.data.retrieveTime - ServerTime.CurServerTime() / 1000
  leftTime = math.max(0, leftTime)
  local day, hour, min, sec = ClientTimeUtil.FormatTimeBySec(leftTime)
  local lab = string.format("%02d:%02d:%02d", hour, min, sec)
  self.phase.text = string.format(ZhString.ArtifactMake_LeftTime, lab)
end

function ArtifactDistributeCell:ShowArtifactTip()
  local tipData = {}
  tipData.funcConfig = {}
  tipData.itemdata = self.itemdata
  self:ShowItemTip(tipData, self.targetCell.icon, NGUIUtil.AnchorSide.Right, {200, 0})
end

function ArtifactDistributeCell:ClearTick()
  if self.timeTick then
    TimeTickManager.Me():ClearTick(self)
    self.timeTick = nil
  end
end

function ArtifactDistributeCell:OnDestroy()
  self:ClearTick()
end
