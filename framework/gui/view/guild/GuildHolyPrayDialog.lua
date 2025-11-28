local packageCheck = GameConfig.PackageMaterialCheck.default
local moneyID = GameConfig.HolyPray and GameConfig.HolyPray.MoneyID or {
  5530,
  5531,
  5532,
  5551
}
autoImport("GvGHolyCell")
autoImport("BaseGuildPrayDialog")
GuildHolyPrayDialog = class("GuildHolyPrayDialog", BaseGuildPrayDialog)
GuildHolyPrayDialog.ViewType = UIViewType.DialogLayer

function GuildHolyPrayDialog:InitUI()
  self.title = self:FindComponent("Title", UILabel)
  self.title.text = ZhString.GvGHolyPray_Title
  if moneyID then
    self.moneyMap = {}
    for i = 1, #moneyID do
      local moneyRoot = self:FindGO("Cost" .. i)
      local money = {}
      money.id = moneyID[i]
      money.icon = self:FindComponent("symbol", UISprite, moneyRoot)
      money.label = self:FindComponent("Label", UILabel, moneyRoot)
      local icon = Table_Item[money.id] and Table_Item[money.id].Icon or ""
      IconManager:SetItemIcon(icon, money.icon)
      self.moneyMap[i] = money
    end
  end
  local prayGrid = self:FindComponent("PrayGrid", UIGrid)
  self.prayCtl = UIGridListCtrl.new(prayGrid, GvGHolyCell, "GvGHolyCell")
  self.prayCtl:AddEventListener(MouseEvent.MouseClick, self.ChoosePray, self)
  self.prayCells = self.prayCtl:GetCells()
  GuildHolyPrayDialog.super.InitUI(self)
  self:_updateCoins()
  self:InitPray()
  self:ChoosePray(self.prayCells[1])
end

function GuildHolyPrayDialog:OnClickPray()
  local chooseData = self.chooseData
  if not chooseData then
    return
  end
  if not chooseData.nextPray or 0 == chooseData.nextPray.lv then
    MsgManager.ShowMsgByIDTable(2720)
    return
  end
  local itemCost = chooseData.nextPray.itemCost
  local ownCost = BagProxy.Instance:GetItemNumByStaticID(itemCost.staticData.id, packageCheck)
  if ownCost < itemCost.num then
    MsgManager.ShowMsgByIDTable(3554, chooseData.costName)
    return
  end
  itemCost = chooseData.nextPray.itemCost2
  ownCost = BagProxy.Instance:GetItemNumByStaticID(itemCost.staticData.id, packageCheck)
  if ownCost < itemCost.num then
    MsgManager.ShowMsgByIDTable(3554, chooseData.nextPray.itemCost2.staticData.NameZh)
    return
  end
  self:ActiveLock(true)
  TimeTickManager.Me():ClearTick(self)
  TimeTickManager.Me():CreateOnceDelayTick(1500, function(owner, deltaTime)
    self:PlayPrayResultAnim()
    self:ActiveLock(false)
    self:_updatePrayGrid()
    self:_updateDialogContent()
  end, self)
  local npcInfo = self:GetCurNpc()
  if npcInfo then
    redlog("CallPrayGuildCmd chooseData.id: ", chooseData.id)
    ServiceGuildCmdProxy.Instance:CallPrayGuildCmd(GuildCmd_pb.EPRAYACTION_PRAY, chooseData.id, 1)
  end
end

function GuildHolyPrayDialog:PlayPrayResultAnim()
  for _, cell in pairs(self.prayCells) do
    if self.chooseData and cell.data.id == self.chooseData.id then
      cell:PlayPrayEffect()
    end
  end
end

function GuildHolyPrayDialog:ChoosePray(cellctl)
  local data = cellctl and cellctl.data
  if data then
    self.chooseData = cellctl.data
    if self.chooseId ~= data.id then
      self.chooseId = data.id
      self:_updateDialogContent()
      for _, cell in pairs(self.prayCells) do
        cell:SetChoose(self.chooseId)
      end
    end
  end
end

function GuildHolyPrayDialog:_updateDialogContent()
  if self.lockState then
    return
  end
  local npcInfo = self:GetCurNpc()
  if not npcInfo then
    return
  end
  if not self.chooseData then
    return
  end
  local chooseData = GuildPrayProxy.Instance:GetHolyPrayById(self.chooseData.id)
  if not chooseData then
    return
  end
  local prayDlgData = {
    Speaker = npcInfo.data.staticData.id,
    NoSpeak = true
  }
  local args = chooseData:GetAddAttrValue()
  if args[1] then
    prayDlgData.Text = string.format(ZhString.GvGHolyPray_Dialog, args[2], args[4], args[5], args[6], args[8], args[9])
  else
    prayDlgData.Text = string.format(ZhString.GvGHolyPray_DialogLimit, args[2])
  end
  self.prayDialog:SetData(prayDlgData)
end

function GuildHolyPrayDialog:InitPray()
  self:_updatePrayGrid()
end

function GuildHolyPrayDialog:_updatePrayGrid()
  self.faithDatas = GuildPrayProxy.Instance:GetPrayListByType(GuildCmd_pb.EPRAYTYPE_HOLYBLESS)
  self.prayCtl:ResetDatas(self.faithDatas)
end

function GuildHolyPrayDialog:_updateCoins()
  local _BagProxy = BagProxy.Instance
  for k, v in pairs(self.moneyMap) do
    local num = _BagProxy:GetItemNumByStaticID(v.id, packageCheck)
    v.label.text = StringUtil.NumThousandFormat(num)
  end
end
