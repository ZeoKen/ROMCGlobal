autoImport("MemoryEquipRewardData")
autoImport("MemoryEquipRewardCell")
MemoryEquipRewardPopUp = class("MemoryEquipRewardPopUp", BaseView)
MemoryEquipRewardPopUp.ViewType = UIViewType.PopUpLayer
local HiglightPos = {
  [1] = LuaVector3.zero,
  [2] = LuaVector3.zero,
  [3] = LuaVector3.zero
}

function MemoryEquipRewardPopUp:Init()
  self:InitData()
  self:FindObjs()
  self:AddListenEvts()
end

function MemoryEquipRewardPopUp:InitData()
  self.rewardInfo = {}
  local serverData = self.viewdata and self.viewdata.viewdata
  if serverData then
    if serverData.infos then
      for i = 1, #serverData.infos do
        local info = serverData.infos[i]
        local data = MemoryEquipRewardData.new(info)
        table.insert(self.rewardInfo, data)
      end
    end
    self.endTime = serverData.endtime
  end
  self.chooseIndex = 1
end

function MemoryEquipRewardPopUp:FindObjs()
  self.grid = self:FindComponent("Grid", UIGrid)
  self.rewardListCtrl = UIGridListCtrl.new(self.grid, MemoryEquipRewardCell, "MemoryEquipRewardCell")
  self.rewardListCtrl:AddEventListener(MouseEvent.MouseClick, self.OnClickReward, self)
  self.confirmBtn = self:FindGO("ConfirmBtn")
  self:AddClickEvent(self.confirmBtn, function()
    self:ChooseReward()
  end)
  self.title = self:FindComponent("Title", UILabel)
  self.highlightPanel = self:FindGO("HighlightPanel")
  self.darkMask = self:FindGO("DarkMask")
  local _tmpV3 = LuaVector3.zero
  for i = 1, #HiglightPos do
    LuaVector3.Better_Set(_tmpV3, self.grid.cellWidth * (i - 1), 0, 0)
    local _x, _y, _z = LuaGameObject.TransformPoint(self.grid.transform, _tmpV3)
    LuaVector3.Better_Set(_tmpV3, _x, _y, _z)
    _x, _y, _z = LuaGameObject.InverseTransformPointByVector3(self.highlightPanel.transform, _tmpV3)
    LuaVector3.Better_Set(HiglightPos[i], _x, _y, _z)
  end
end

function MemoryEquipRewardPopUp:AddListenEvts()
  self:AddListenEvt(ServiceEvent.FuBenCmdChooseMemoryEquipRewardInfo, self.HandleChooseReward)
  EventManager.Me():AddEventListener(ServiceEvent.ConnReconnect, self.HandleReconnect, self)
end

function MemoryEquipRewardPopUp:OnEnter()
  self.rewardListCtrl:ResetDatas(self.rewardInfo, nil, false)
  local cells = self.rewardListCtrl:GetCells()
  self:OnClickReward(cells[self.chooseIndex])
  if self.endTime then
    local cd = math.floor(self.endTime - ServerTime.CurServerTime() / 1000)
    TimeTickManager.Me():CreateTick(0, 1000, function()
      self.title.text = string.format(ZhString.MemoryEquipReward_Title, cd)
      if cd <= 0 then
        self:ChooseReward()
        TimeTickManager.Me():ClearTick(self)
        return
      end
      cd = cd - 1
    end, self)
  end
  UIManagerProxy.Instance:NeedEnableAndroidKey(false)
end

function MemoryEquipRewardPopUp:OnExit()
  TimeTickManager.Me():ClearTick(self)
  self.rewardListCtrl:RemoveAll()
  UIManagerProxy.Instance:NeedEnableAndroidKey(true, UIManagerProxy.GetDefaultNeedEnableAndroidKeyCallback())
  EventManager.Me():RemoveEventListener(ServiceEvent.ConnReconnect, self.HandleReconnect, self)
end

function MemoryEquipRewardPopUp:ChooseReward()
  ServiceFuBenCmdProxy.Instance:CallChooseMemoryEquipRewardInfo(self.chooseIndex)
end

function MemoryEquipRewardPopUp:OnClickReward(cell)
  if cell.data then
    self.chooseIndex = cell.data.index
  end
  cell:SetHighlight(self.highlightPanel.transform)
  cell.trans.localPosition = HiglightPos[self.chooseIndex]
  self.darkMask:SetActive(true)
  local cells = self.rewardListCtrl:GetCells()
  for i = 1, #cells do
    cells[i]:SetChoose(cells[i] == cell)
    if cells[i] ~= cell then
      cells[i]:ResetHighlight()
      cells[i].trans.localPosition = LuaGeometry.GetTempVector3(self.grid.cellWidth * (i - 1), 0, 0)
    end
  end
end

function MemoryEquipRewardPopUp:HandleChooseReward()
  local data = self.rewardInfo[self.chooseIndex]
  if data then
    local equipData = data:GetEquipMemoryData()
    if equipData then
      local itemConfig = Table_Item[equipData.staticId]
      local msgId, name, newLv = nil, itemConfig and itemConfig.NameZh or "", data.newLevel
      if data.state == FuBenCmd_pb.EMEMORY_EQUIP_REWARD_UP_LEVEL then
        msgId = 43652
      elseif data.state == FuBenCmd_pb.EMEMORY_EQUIP_REWARD_TO_BREAK then
        msgId = 43653
      end
      if msgId then
        MsgManager.ShowMsgByID(msgId, {name, newLv})
      end
    end
  end
  self:CloseSelf()
end

function MemoryEquipRewardPopUp:HandleReconnect()
  self:CloseSelf()
end
