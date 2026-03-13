ArtifactDistributePopUp = class("ArtifactDistributePopUp", ContainerView)
ArtifactDistributePopUp.ViewType = UIViewType.PopUpLayer
autoImport("ArtifactDistributeCell")

function ArtifactDistributePopUp:Init(parent)
  self:InitView()
  self:InitData()
  self:MapEvent()
  self.artiData = self.viewdata.viewdata.data
  self.charID = self.viewdata.viewdata.charID
end

function ArtifactDistributePopUp:InitView()
  self.callBackWhenClickOtherPlace = self.gameObject:GetComponent(CallBackWhenClickOtherPlace)
  if self.callBackWhenClickOtherPlace then
    function self.callBackWhenClickOtherPlace.call()
      self:CloseSelf()
    end
  end
  self.title = self:FindComponent("title", UILabel)
  self.distTog = self:FindGO("DistTog")
  self.distTog_Toggle = self:FindComponent("Tog", UIToggle, self.distTog)
  self.retrieveTog = self:FindGO("RetrieveTog")
  self.retrieveTog_Toggle = self:FindComponent("Tog", UIToggle, self.retrieveTog)
  self.consumeTog = self:FindGO("ConsumeTog")
  self.consumeTog_Toggle = self:FindComponent("Tog", UIToggle, self.consumeTog)
  self.toggles = {
    self.retrieveTog_Toggle,
    self.distTog_Toggle,
    self.consumeTog_Toggle
  }
  self:AddClickEvent(self.distTog, function()
    self:SwitchPage(2)
  end)
  self:AddClickEvent(self.retrieveTog, function()
    self:SwitchPage(1)
  end)
  self:AddClickEvent(self.consumeTog, function()
    self:SwitchPage(3)
  end)
  local grid = self:FindGO("Wrap"):GetComponent(UIGrid)
  self.artifactCtrl = UIGridListCtrl.new(grid, ArtifactDistributeCell, "ArtifactDistributeCell")
  self.artifactCtrl:AddEventListener(MouseEvent.MouseClick, self.handleClickCellTog, self)
  self.artifactCtrl:SetDisableDragIfFit()
  self.funcGrid = self:FindComponent("FuncGrid", UIGrid)
  self.confirmBtn = self:FindGO("ConfirmBtn")
  self.confirmBtn_Label = self:FindComponent("ConfirmLabel", UILabel, self.confirmBtn)
  self:AddClickEvent(self.confirmBtn, function()
    self:DoConfirm()
  end)
  self.changeBtn = self:FindGO("ChangeBtn")
  self:AddClickEvent(self.changeBtn, function()
    self:DoChange()
  end)
  self.noneTip = self:FindGO("NoneTip")
  self.noneTipLabel = self.noneTip:GetComponent(UILabel)
  self.checkBtn = self:FindGO("CheckBtn"):GetComponent(UIToggle)
  self:AddClickEvent(self.checkBtn.gameObject, function()
    self:DoRestrieveAll()
  end)
end

function ArtifactDistributePopUp:InitData()
  self.pageIndex = 1
  self.toggles[1].value = true
end

function ArtifactDistributePopUp:SwitchPage(pageIndex)
  self.pageIndex = pageIndex
  self.toggles[pageIndex].value = true
  self:UpdateView()
  self.artifactCtrl:ResetPosition()
end

function ArtifactDistributePopUp:Option(cellctl)
  if cellctl then
    local data = cellctl.data
    helplog("CallArtifactOptGuildCmd  -----> data.Phase ", data.Phase, "data.guid: ", data.guid)
    local guidArray = {}
    guidArray[#guidArray + 1] = data.guid
    local myGuildData = GuildProxy.Instance.myGuildData
    local guildMemberData = myGuildData:GetMemberByGuid(self.charID)
    if data.Phase == ArtifactProxy.OptionType.Distribute then
      if guildMemberData and not data:CanEquip(guildMemberData.profession) then
        MsgManager.ShowMsgByID(3794)
        return
      end
      if not data:CanDistribute() then
        local disCount = data.staticData and data.staticData.DistributeCount or 2
        MsgManager.ShowMsgByIDTable(3793, disCount)
        return
      end
    end
    local msgID
    if data.Phase == ArtifactProxy.OptionType.Distribute then
      msgID = 3796
    elseif data.Phase == ArtifactProxy.OptionType.Retrieve then
      msgID = 3797
    elseif data.Phase == ArtifactProxy.OptionType.RetrieveCancle then
      msgID = 3798
    end
    MsgManager.ConfirmMsgByID(msgID, function()
      ServiceGuildCmdProxy:CallArtifactOptGuildCmd(data.Phase, guidArray, self.charID)
      self:CloseSelf()
    end, nil, nil)
  end
end

function ArtifactDistributePopUp:OnEnter()
  ArtifactDistributePopUp.super.OnEnter(self)
  self:UpdateView()
end

function ArtifactDistributePopUp:UpdateView()
  if self.artiData then
    local result = {}
    local isDistributed = false
    if self.pageIndex == 1 then
      for i = 1, #self.artiData do
        if self.artiData[i].ownerID and self.artiData[i].ownerID ~= 0 then
          table.insert(result, self.artiData[i])
        end
      end
    elseif self.pageIndex == 2 then
      for i = 1, #self.artiData do
        if self.artiData[i].ownerID and self.artiData[i].ownerID == 0 and self.artiData[i].itemType ~= 106 then
          table.insert(result, self.artiData[i])
        end
      end
    elseif self.pageIndex == 3 then
      for i = 1, #self.artiData do
        if self.artiData[i].ownerID and self.artiData[i].ownerID == 0 and self.artiData[i].itemType == 106 then
          table.insert(result, self.artiData[i])
        end
        if self.artiData[i].ownerID and self.artiData[i].ownerID ~= 0 and self.artiData[i].itemType == 106 then
          isDistributed = true
        end
      end
    end
    self.artifactCtrl:ResetDatas(result)
    local cells = self.artifactCtrl:GetCells()
    if self.pageIndex == 3 then
      if 0 < #cells then
        self.selectData = self.selectData or cells[1].data
        for i = 1, #cells do
          cells[i]:SetSelect(cells[i].data == self.selectData)
          cells[i]:SetCheckBtn(false)
        end
      end
    else
      for i = 1, #cells do
        cells[i]:SetSelect(false)
        cells[i]:SetCheckBtn(true)
      end
    end
    self.noneTip:SetActive(#result == 0)
    if self.pageIndex == 2 or self.pageIndex == 3 then
      self.confirmBtn_Label.text = ZhString.ArtifactMake_Dist
      self.title.text = self.pageIndex == 2 and ZhString.ArtifactMake_ChooseDistEquip or ZhString.ArtifactMake_ChooseDistConsume
      self.noneTipLabel.text = ZhString.ArtifactMake_DistEmpty
      self.checkBtn.gameObject:SetActive(false)
      self.checkBtn.value = false
    elseif self.pageIndex == 1 then
      self.confirmBtn_Label.text = ZhString.ArtifactMake_Retrieve
      self.title.text = ZhString.ArtifactMake_ChooseRetrieveTarget
      self.noneTipLabel.text = ZhString.ArtifactMake_RetrieveEmpty
      self.checkBtn.gameObject:SetActive(#result ~= 0 and true or false)
    end
    self.confirmBtn:SetActive(#result ~= 0 and not isDistributed)
    self.changeBtn:SetActive(isDistributed)
  end
  self.funcGrid:Reposition()
end

function ArtifactDistributePopUp:MapEvent()
end

function ArtifactDistributePopUp:DoConfirm()
  local hasChange = false
  local optList = {}
  if self.pageIndex == 3 then
    if self.selectData then
      hasChange = true
      local data = self.selectData
      local optType = data.Phase
      if not optList[optType] then
        optList[optType] = {}
      end
      table.insert(optList[optType], data.guid)
    end
  else
    local cells = self.artifactCtrl:GetCells()
    if cells and 0 < #cells then
      for i = 1, #cells do
        if cells[i].checkBtn.value then
          hasChange = true
          local data = cells[i].data
          local optType = data.Phase
          if not optList[optType] then
            optList[optType] = {}
          end
          table.insert(optList[optType], data.guid)
        end
      end
    end
  end
  if not hasChange then
    redlog("没有选择装备", GuildCmd_pb.EARTIFACTOPTTYPE_RETRIEVE_ALL)
    return
  else
    for _optType, _guidArray in pairs(optList) do
      xdlog("请求指令变动", _optType, #_guidArray)
      local msgID
      if _optType == ArtifactProxy.OptionType.Distribute then
        msgID = 3813
      elseif _optType == ArtifactProxy.OptionType.Retrieve then
        msgID = 3812
      end
      MsgManager.ConfirmMsgByID(msgID, function()
        ServiceGuildCmdProxy:CallArtifactOptGuildCmd(_optType, _guidArray, self.charID)
        self:CloseSelf()
      end, nil, nil)
      break
    end
  end
end

function ArtifactDistributePopUp:DoChange()
  xdlog("更换")
  if self.pageIndex ~= 3 then
    return
  end
  if not self.selectData then
    return
  end
  local optList = {}
  local optType = self.selectData.Phase
  if not optList[optType] then
    optList[optType] = {}
  end
  table.insert(optList[optType], self.selectData.guid)
  MsgManager.ConfirmMsgByID(3813, function()
    ServiceGuildCmdProxy:CallArtifactOptGuildCmd(optType, optList[optType], self.charID)
    self:CloseSelf()
  end, nil, nil)
end

function ArtifactDistributePopUp:DoRestrieveAll()
  xdlog("收回所有")
  local status = self.checkBtn.value
  local cells = self.artifactCtrl:GetCells()
  if cells and 0 < #cells then
    for i = 1, #cells do
      cells[i].checkBtn.value = status
    end
  end
end

function ArtifactDistributePopUp:handleClickCellTog(cellCtrl)
  if self.pageIndex == 1 then
    self:ResetCheckBtn()
  elseif self.pageIndex == 3 then
    local cells = self.artifactCtrl:GetCells()
    for i = 1, #cells do
      cells[i]:SetSelect(cells[i] == cellCtrl)
    end
    self.selectData = cellCtrl.data
  end
end

function ArtifactDistributePopUp:ResetCheckBtn()
  local cells = self.artifactCtrl:GetCells()
  local isAllChecked = true
  if cells and 0 < #cells then
    for i = 1, #cells do
      if not cells[i].checkBtn.value then
        isAllChecked = false
      end
    end
  end
  self.checkBtn.value = isAllChecked
end

function ArtifactDistributePopUp:OnExit()
  if self.callBackWhenClickOtherPlace then
    self.callBackWhenClickOtherPlace.call = nil
    self.callBackWhenClickOtherPlace = nil
  end
  ArtifactDistributePopUp.super.OnExit(self)
end
