TransferFightMonsterChooseView = class("TransferFightMonsterChooseView", ContainerView)
autoImport("TransferFightMonsterCell")

function TransferFightMonsterChooseView:Init()
  self:InitDatas()
  self:FindObjs()
  self:InitShow()
end

function TransferFightMonsterChooseView:InitDatas()
  self.timeStamp = PvpProxy.Instance:GetTransferFightMonsterChooseCountDown()
  self.starttime = ServerTime.CurServerTime() / 1000
  self.tickMg = TimeTickManager.Me()
  if GameConfig and GameConfig.TransferFight then
    self.config = GameConfig.TransferFight
  end
end

function TransferFightMonsterChooseView:FindObjs()
  self.confirmBtn = self:FindGO("ConfirmBtn")
  self.confirmDisabled = self:FindGO("ConfirmDisabled")
  self.countDownLabel = self:FindComponent("Label", UILabel)
  self.middlePart = self:FindGO("MIddle")
  local grid = self:FindGO("Grid", self.middlePart):GetComponent(UIGrid)
  self.monsterChooseCtrl = UIGridListCtrl.new(grid, TransferFightMonsterCell, "TransferFightMonsterCell")
  self.monsterChooseCtrl:AddEventListener(MouseEvent.MouseClick, self.ClickMonsterCell, self)
  self.confirmBtn.gameObject:SetActive(false)
  self.confirmDisabled.gameObject:SetActive(true)
  self:AddClickEvent(self.confirmBtn, function()
    self:chooseConfirm()
  end)
  self:AddListenEvt(MyselfEvent.TransformChange, self.OnTransformHandler)
  self:AddListenEvt(ServiceEvent.FuBenCmdTransferFightChooseFubenCmd, self.RefreshTimeStamp)
end

function TransferFightMonsterChooseView:InitShow()
  local transferList = {}
  if self.config and self.config.transBuffs and #self.config.transBuffs > 0 then
    for i = 1, #self.config.transBuffs do
      local single = self.config.transBuffs[i]
      transferList[i] = {}
      transferList[i].id = i
      transferList[i].buff = single.buff
      transferList[i].monster = single.monster
    end
    self.monsterChooseCtrl:ResetDatas(transferList)
  end
  self.tickMg:ClearTick(self)
  self.tickMg:CreateTick(0, 500, self.updateCountDownTime, self)
end

function TransferFightMonsterChooseView:ClickMonsterCell(cellCtl)
  local cellData = cellCtl.data
  if not cellData then
    return
  end
  if cellCtl ~= self.currentChoose then
    if self.currentChoose then
      self.currentChoose:setChoose(false)
    end
    self.currentChoose = cellCtl
    self.currentChoose:setChoose(true)
  else
    helplog("选择项相同")
  end
  self.confirmBtn.gameObject:SetActive(true)
  self.confirmDisabled.gameObject:SetActive(false)
end

function TransferFightMonsterChooseView:updateCountDownTime()
  if not self.starttime then
    self.starttime = ServerTime.CurServerTime() / 1000
  end
  local leftDay, leftHour, leftMin, leftSec = ClientTimeUtil.GetFormatRefreshTimeStr(self.timeStamp)
  if leftSec <= 0 then
    self.tickMg:ClearTick(self)
    self:callTransferFightChooseCmd()
    self:CloseSelf()
    return
  end
  local leftTimeStr = string.format(ZhString.PlayerTip_ExpireTime, leftSec)
  self.countDownLabel.text = leftTimeStr
end

function TransferFightMonsterChooseView:callTransferFightChooseCmd()
  if self.currentChoose and self.currentChoose.id then
    ServiceFuBenCmdProxy.Instance:CallTransferFightChooseFubenCmd(nil, self.currentChoose.id)
  else
    local chooseid = math.random(2)
    ServiceFuBenCmdProxy.Instance:CallTransferFightChooseFubenCmd(nil, chooseid)
  end
end

function TransferFightMonsterChooseView:chooseConfirm()
  if self.currentChoose then
    local cells = self.monsterChooseCtrl:GetCells()
    for i = 1, #cells do
      local single = cells[i]
      if single.id == self.currentChoose.id then
        single:confirmChooseStatus(true)
      else
        single:confirmChooseStatus(false)
      end
    end
  end
  self.confirmBtn.gameObject:SetActive(false)
  self.confirmDisabled.gameObject:SetActive(true)
end

function TransferFightMonsterChooseView:RefreshTimeStamp(note)
  local serverData = note.body
  local timeStamp = serverData.coldtime
  if timeStamp and timeStamp >= self.timeStamp then
    self.timeStamp = timeStamp
  end
end

function TransferFightMonsterChooseView:OnTransformHandler()
  local props = Game.Myself.data.props
  local transformID = props:GetPropByName("TransformID"):GetValue()
  if transformID ~= 0 then
    self:CloseSelf()
  end
end

function TransferFightMonsterChooseView:OnExit()
  TransferFightMonsterChooseView.super.OnExit(self)
  self.tickMg:ClearTick(self)
end
