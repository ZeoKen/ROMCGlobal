autoImport("EquipMemoryDecomposeView")
ArtifactDecomposeView = class("ArtifactDecomposeView", EquipMemoryDecomposeView)
autoImport("EquipMemoryItemCell")

function ArtifactDecomposeView:InitUI()
  ArtifactDecomposeView.super.InitUI(self)
  self.autoDecomposeSetBtn:SetActive(false)
  self.title = self:FindComponent("Title", UILabel)
  self.title.text = ZhString.ArtifaceDecompose_Title
  self.emptyChosenTipLabel = self:FindComponent("EmptyChosenTip", UILabel)
  self.emptyChosenTipLabel.text = ZhString.ArtifaceDecompose_EmptyTip1
  self.tipLabel = self:FindComponent("TIPLabel", UILabel)
  self.tipLabel.text = ZhString.ArtifaceDecompose_Tip
  self.filter.gameObject:SetActive(false)
  self.helpBtn:SetActive(true)
  self:RegistShowGeneralHelpByHelpID(32626, self.helpBtn)
end

function ArtifactDecomposeView:MapEvent()
  self:AddListenEvt(ServiceEvent.ItemEquipDecompose, self.HandleEquipCompose)
  self:AddListenEvt(MyselfEvent.MyDataChange, self.UpdateCoins)
  self:AddListenEvt(ServiceEvent.GuildCmdQueryPackGuildCmd, self.HandleDecomposeSuccess)
  self:AddListenEvt(ServiceEvent.GuildCmdPackUpdateGuildCmd, self.HandleDecomposeSuccess)
end

function ArtifactDecomposeView:GetEquipMemoryList()
  local result = {}
  local myGuildData = GuildProxy.Instance.myGuildData
  if myGuildData then
    local list = myGuildData:GetGuildAsset() or {}
    xdlog("仓库内东西数量", #list)
    local validType = {}
    for _, _info in pairs(GameConfig.ArtifactType) do
      for _type, _name in pairs(_info) do
        if _type and _type ~= 0 then
          validType[_type] = 1
        end
      end
    end
    for i = 1, #list do
      if list[i].staticData and list[i].staticData.Type and validType[list[i].staticData.Type] then
        local single = list[i]:Clone()
        table.insert(result, single)
      end
    end
  end
  return result
end

function ArtifactDecomposeView:ClickMemoryCell(cell)
  if self.longPressEventDispatched then
    return
  end
  local data = cell.data
  if not data then
    return
  end
  self.clickEventDispatched = true
  TimeTickManager.Me():CreateOnceDelayTick(300, function(owner, deltaTime)
    self.clickEventDispatched = nil
  end, self)
  cell.data.isMark = not cell.data.isMark
  cell:UpdateCheckMark()
  if cell.data.isMark then
    local found = false
    for i = 1, #self.chosenMap do
      if self.chosenMap[i].staticId == cell.data.id then
        found = true
        return
      end
    end
    if not found then
      table.insert(self.chosenMap, {
        guid = cell.data.id,
        staticId = cell.data.staticData.id
      })
    end
  else
    for i = 1, #self.chosenMap do
      if self.chosenMap[i].guid == cell.data.id then
        table.remove(self.chosenMap, i)
        break
      end
    end
  end
  self:DecomposePreview()
end

function ArtifactDecomposeView:HandleChooseAll()
  xdlog("HandleChooseAll")
  local equipdatas = self:GetEquipMemoryList()
  for i = 1, #equipdatas do
    equipdatas[i].isMark = true
    local found = false
    for j = 1, #self.chosenMap do
      if self.chosenMap[j].guid == equipdatas[i].id then
        found = true
        break
      end
    end
    if not found then
      table.insert(self.chosenMap, {
        guid = equipdatas[i].id,
        staticId = equipdatas[i].staticData.id
      })
    end
  end
  local cells = self.memoryListCtrl:GetCells()
  for i = 1, #cells do
    cells[i]:UpdateCheckMark()
  end
  self:UpdateChooseBord()
  self:DecomposePreview()
end

function ArtifactDecomposeView:getArtifactMats(id, list)
  local staticData = Table_Artifact[id]
  local decomposeRateMap = GameConfig.Guild and GameConfig.Guild.artifact_decompose_ratio
  if staticData then
    local level = staticData and staticData.Level or 1
    local rate = decomposeRateMap[level]
    local mats = staticData and staticData.Material
    for _type, _materials in pairs(mats) do
      if _type == 1 then
        for i = 1, #_materials do
          local mainMatID = _materials[i].id
          self:getArtifactMats(mainMatID, list)
        end
      else
        for i = 1, #_materials do
          local subMatID = _materials[i].id
          if not list[subMatID] then
            list[subMatID] = math.floor(rate * _materials[i].num)
          else
            list[subMatID] = list[subMatID] + math.floor(rate * _materials[i].num)
          end
        end
      end
    end
  end
end

function ArtifactDecomposeView:DecomposePreview()
  local result = {}
  local chosenList = {}
  local decomposeRateMap = GameConfig.Guild and GameConfig.Guild.artifact_decompose_ratio
  local myGuildData = GuildProxy.Instance.myGuildData
  local previewReturnMats = {}
  for i = 1, #self.chosenMap do
    local item = myGuildData:GetGuildPackItemByGuid(self.chosenMap[i].guid)
    if item then
      table.insert(chosenList, item)
    end
    self:getArtifactMats(self.chosenMap[i].staticId, previewReturnMats)
  end
  for _itemid, _num in pairs(previewReturnMats) do
    local itemData = ItemData.new("Decompose", _itemid)
    itemData.num = _num
    table.insert(result, itemData)
  end
  self.resultCtl:ResetDatas(result)
  if 5 <= #result then
    self.resultScrollView.contentPivot = UIWidget.Pivot.Left
  else
    self.resultScrollView.contentPivot = UIWidget.Pivot.Center
  end
  self.resultScrollView:ResetPosition()
  self.chooseCtl:ResetDatas(chosenList)
  self.chosenScrollView:ResetPosition()
  self.noMaterialTip:SetActive(#result == 0)
  self.emptyChosenTip:SetActive(#chosenList == 0)
  if #result == 0 then
    self:SetTextureGrey(self.startBtn)
    self.startBtn_BoxCollider.enabled = false
  else
    self:SetTextureWhite(self.startBtn, ColorUtil.ButtonLabelBlue)
    self.startBtn_BoxCollider.enabled = true
  end
end

function ArtifactDecomposeView:HandleRemoveChosen(cellCtrl)
  if self.longPressEventDispatched then
    return
  end
  local itemData = cellCtrl.data
  if not itemData then
    return
  end
  self.clickEventDispatched = true
  TimeTickManager.Me():CreateOnceDelayTick(300, function(owner, deltaTime)
    self.clickEventDispatched = nil
  end, self)
  xdlog("itemData", itemData.id)
  for i = 1, #self.chosenMap do
    if self.chosenMap[i].guid == itemData.id then
      table.remove(self.chosenMap, i)
      break
    end
  end
  self:UpdateChooseBord()
  self:DecomposePreview()
end

function ArtifactDecomposeView:UpdateChooseBord()
  local equipdatas = self:GetEquipMemoryList()
  for i = 1, #equipdatas do
    local found = false
    for j = 1, #self.chosenMap do
      if self.chosenMap[j].guid == equipdatas[i].id then
        found = true
        break
      end
    end
    if found then
      equipdatas[i].isMark = true
    end
  end
  self.memoryListCtrl:ResetDatas(equipdatas)
end

function ArtifactDecomposeView:StartDeCompose()
  xdlog("推送分解")
  local result = {}
  for i = 1, #self.chosenMap do
    xdlog("分解列表", self.chosenMap[i].guid)
    table.insert(result, self.chosenMap[i].guid)
  end
  if 0 < #result then
    FunctionSecurity.Me():NormalOperation(function()
      MsgManager.ConfirmMsgByID(43541, function()
        ServiceGuildCmdProxy:CallArtifactOptGuildCmd(ArtifactProxy.OptionType.Decompose, result)
      end)
    end)
  end
end

function ArtifactDecomposeView:HandleCallQueryGuildAsset()
  FunctionGuild.Me():QueryGuildItemList()
end

function ArtifactDecomposeView:OnEnter()
  ArtifactDecomposeView.super.OnEnter(self)
  ServiceGuildCmdProxy.Instance:CallQueryPackGuildCmd()
  ServiceGuildCmdProxy.Instance:CallFrameStatusGuildCmd(true)
end

function ArtifactDecomposeView:OnExit()
  ArtifactDecomposeView.super.OnExit(self)
  ServiceGuildCmdProxy.Instance:CallFrameStatusGuildCmd(false)
end
