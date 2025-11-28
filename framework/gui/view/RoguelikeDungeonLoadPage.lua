autoImport("RoguelikeDungeonMultiSaveCell")
RoguelikeDungeonLoadPage = class("RoguelikeDungeonLoadPage", SubView)

function RoguelikeDungeonLoadPage:Init()
  self:ReLoadPerferb("view/RoguelikeDungeonLoadPage")
  self.trans:SetParent(self.container.pageContainer.transform, false)
  self:InitView()
  self:InitData()
end

function RoguelikeDungeonLoadPage:DoDelete()
  if not self.selectedSaveIndex then
    MsgManager.FloatMsg(nil, ZhString.Roguelike_SelectSaveDataFirst)
    return
  end
  if self.pveFunc.autoCreatTeamRaidType ~= nil then
    return
  end
  MsgManager.ConfirmMsgByID(25430, function()
    FunctionPve.DelRoguelikeSaveData(self.selectedSaveIndex)
  end)
end

function RoguelikeDungeonLoadPage:DoLoad()
  if not self.selectedSaveIndex then
    MsgManager.FloatMsg(nil, ZhString.Roguelike_SelectSaveDataFirst)
    return
  end
  if self.pveFunc.autoCreatTeamRaidType ~= nil then
    return
  end
  UIUtil.PopUpConfirmYesNoView("", ZhString.Roguelike_SaveDataLoadConfirm, function()
    self:TryInviteRoguelike()
  end, nil, nil, ZhString.UniqueConfirmView_Confirm, ZhString.UniqueConfirmView_CanCel)
end

function RoguelikeDungeonLoadPage:InitView()
  self.noneTip = self:FindGO("NoneTip")
  self.root = self:FindGO("Root")
  self.root:SetActive(false)
  self.noneTip:SetActive(true)
  self.deleteBtn = self:FindGO("DeleteBtn")
  self:AddClickEvent(self.deleteBtn, function()
    self:DoDelete()
  end)
  self:AddButtonEvent("LoadBtn", function()
    self:DoLoad()
  end)
  self.autoListCtrl = UIGridListCtrl.new(self:FindComponent("AutoGrid", UIGrid), RoguelikeDungeonMultiSaveCell, "RoguelikeDungeonMultiSaveCell")
  self.autoListCtrl:AddEventListener(MouseEvent.MouseClick, self.OnClickCell, self)
  self.autoListCtrl:AddEventListener(RoguelikeEvent.ShowPlayerTip, self.OnShowPlayerTip, self)
  self.manualListCtrl = UIGridListCtrl.new(self:FindComponent("ManualGrid", UIGrid), RoguelikeDungeonMultiSaveCell, "RoguelikeDungeonMultiSaveCell")
  self.manualListCtrl:AddEventListener(MouseEvent.MouseClick, self.OnClickCell, self)
  self.manualListCtrl:AddEventListener(RoguelikeEvent.ShowPlayerTip, self.OnShowPlayerTip, self)
end

function RoguelikeDungeonLoadPage:InitData()
  self.playerTipInitData = {}
  self.playerTipFunc = {
    "SendMessage",
    "AddFriend",
    "ShowDetail"
  }
  self.playerTipFunc_Friend = {
    "SendMessage",
    "ShowDetail"
  }
  self.pveFunc = FunctionPve.Me()
end

function RoguelikeDungeonLoadPage:OnEnter()
  RoguelikeDungeonLoadPage.super.OnEnter(self)
  FunctionPve.QueryRoguelikeArchive()
end

function RoguelikeDungeonLoadPage:OnRecvSaveDatas()
  local autoSaveDatas, manualSaveDatas = self.pveFunc.roguelikeAutoSaveDatas, self.pveFunc.roguelikeManualSaveDatas
  self.autoListCtrl:ResetDatas(autoSaveDatas)
  self.manualListCtrl:ResetDatas(manualSaveDatas)
  local dataCount = 0
  for _, d in pairs(autoSaveDatas) do
    if d.time then
      dataCount = dataCount + 1
    end
  end
  for _, d in pairs(manualSaveDatas) do
    if d.time then
      dataCount = dataCount + 1
    end
  end
  self.noneTip:SetActive(dataCount == 0)
  self.root:SetActive(0 < dataCount)
  self.selectedSaveIndex = nil
  self.selectedSaveGrade = nil
end

function RoguelikeDungeonLoadPage:OnClickCell(cellCtl)
  if self.pveFunc.autoCreatTeamRaidType ~= nil then
    return
  end
  local autoCells = self.autoListCtrl:GetCells()
  for _, cell in pairs(autoCells) do
    cell:SetChoose(false)
  end
  local manualCells = self.manualListCtrl:GetCells()
  for _, cell in pairs(manualCells) do
    cell:SetChoose(false)
  end
  cellCtl:SetChoose(true)
  self.selectedSaveIndex = cellCtl.index
  self.selectedSaveGrade = cellCtl.grade
  self.deleteBtn:SetActive(self.selectedSaveIndex < 1000)
end

function RoguelikeDungeonLoadPage:OnEnterTeam()
  if self.pveFunc.autoCreatTeamRaidType == nil then
    return
  end
  self:TryInviteRoguelike()
end

local playerTipOffset = {-70, 14}

function RoguelikeDungeonLoadPage:OnShowPlayerTip(data)
  local headCell = data.headCell
  if headCell == self.clickedHeadCell then
    FunctionPlayerTip.Me():CloseTip()
    self.clickedHeadCell = nil
    return
  end
  self.clickedHeadCell = headCell
  local saveData = self.pveFunc:GetRoguelikeSaveData(data.saveDataIndex >= 1000, data.saveDataIndex)
  local playerData, player = saveData.users[data.headIndex], PlayerTipData.new()
  if not playerData then
    return
  end
  local playerTip = FunctionPlayerTip.Me():GetPlayerTip(headCell.frameSp, NGUIUtil.AnchorSide.TopRight, playerTipOffset)
  player:SetByRoguelikeUserData(playerData)
  TableUtility.TableClear(self.playerTipInitData)
  self.playerTipInitData.playerData = player
  self.playerTipInitData.funckeys = FriendProxy.Instance:IsFriend(playerData.charid) and self.playerTipFunc_Friend or self.playerTipFunc
  playerTip:SetData(self.playerTipInitData)
  playerTip:HideGuildInfo()
  playerTip:AddIgnoreBound(headCell.gameObject)
  
  function playerTip.clickcallback(funcData)
    if funcData.key == "SendMessage" then
      self:CloseSelf()
    end
  end
  
  function playerTip.closecallback()
    self.clickedHeadCell = nil
  end
end

function RoguelikeDungeonLoadPage:TryInviteRoguelike()
  if not TeamProxy.Instance:IHaveTeam() then
    MsgManager.ShowMsgByID(332)
    return
  end
  if not self.pveFunc:CheckRoguelike(nil, nil, self.selectedSaveIndex) then
    return
  end
  local layer, saveindex = self.selectedSaveGrade, self.selectedSaveIndex
  FunctionPve.SetRugelikeInviteParam(layer, saveindex)
  FunctionPve.Me():DoChallenge()
end

function RoguelikeDungeonLoadPage:AddButtonEvent(name, event)
  RoguelikeDungeonLoadPage.super.super.AddButtonEvent(self, name, event)
end
