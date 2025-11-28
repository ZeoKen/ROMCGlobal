autoImport("MenuUnLockCell")
autoImport("MenuMsgCell")
autoImport("CoinPopView")
autoImport("ItemPopView")
autoImport("MenuCatCell")
autoImport("CommonUnlockInfo")
autoImport("ConfirmCell")
SystemUnLockView = class("SystemUnLockView", BaseView)
SystemUnLockView.ViewType = UIViewType.SystemOpenLayer
SystemUnLockView.TypeEnum = {
  MenuUnlock = {
    prefab = ResourcePathHelper.UICell("MenuUnLock"),
    isMenu = true
  },
  MenuMsg = {
    prefab = ResourcePathHelper.UICell("UnLockMsg"),
    isMenu = true
  },
  MenuCatCell = {
    prefab = ResourcePathHelper.UICell("MenuCatCell"),
    isMenu = true
  },
  SystemMenuMsg = {
    prefab = ResourcePathHelper.UICell("UnLockMsg"),
    isMenu = false,
    stayTime = 500
  },
  MenuCoinPop = {
    prefab = ResourcePathHelper.UICell("CoinPopView"),
    isMenu = false,
    stayTime = 500
  },
  MenuItemPop = {
    prefab = ResourcePathHelper.UICell("ItemPopView"),
    isMenu = false,
    stayTime = 500
  },
  CommonUnlockInfo = {
    prefab = ResourcePathHelper.UICell("CommonUnlockInfo"),
    isMenu = false,
    stayTime = 500
  }
}

function SystemUnLockView:OnExit()
  for k, v in pairs(self.typeMapCell) do
    if v.OnExit ~= nil then
      v:OnExit()
    end
    if v.OnCellDestroy ~= nil then
      v:OnCellDestroy()
    end
  end
  SystemUnLockView.super.OnExit(self)
end

function SystemUnLockView:Init()
  self.data = self.viewdata.data
  self:MapViewInterests()
  self:FindObjs()
  self:InitDatas()
  self:InitClickEvent()
  self.confirmCell = ConfirmCell.new(self:FindGO("BeforePanel"))
end

function SystemUnLockView:MapViewInterests()
  self:AddListenEvt(SystemUnLockEvent.NUserNewMenu, self.HandleNewMenu)
  self:AddListenEvt(SystemUnLockEvent.CommonUnlockInfo, self.HandleCommonUnlockInfo)
  self:AddListenEvt(HotKeyEvent.ClosePopView, self.HandleHotKeyClosePop)
end

function SystemUnLockView:FindObjs()
  self.bgClick = self:FindChild("BgClick")
end

function SystemUnLockView:InitClickEvent()
  self:AddClickEvent(self.bgClick, function(go)
    self:OnCloseClick()
  end)
end

function SystemUnLockView:OnCloseClick()
  local current = self:GetCurrentCell()
  if current ~= nil and current.PlayHide ~= nil then
    current:PlayHide()
  end
end

function SystemUnLockView:InitDatas()
  self.waitPlayCount = 0
  self.waitQueues = {}
  self.typeMapCell = {}
end

function SystemUnLockView:GetCurrentCell()
  return self.currentCell
end

function SystemUnLockView:HandleNewMenu(note)
  local list = note.body.list
  if list == nil then
    return
  end
  self.animplay = note.body.animplay
  local table_Menu, config = Table_Menu
  for i = 1, #list do
    local v = list[i]
    config = table_Menu[v]
    if not config or config.type == 3 then
    elseif config.type == 4 then
      self:_waitQueue_Push({
        Type = SystemUnLockView.TypeEnum.MenuCatCell,
        id = v,
        class = MenuCatCell,
        data = config
      })
    elseif config.Condition.found_elf_num or config.Condition.found_abyss_lake_elf_num then
    else
      self:_waitQueue_Push({
        Type = SystemUnLockView.TypeEnum.MenuUnlock,
        id = v,
        class = MenuUnLockCell,
        data = nil
      })
    end
  end
  self:TryShowCell()
end

function SystemUnLockView:HandleCommonUnlockInfo(note)
  local data = note.body
  if data then
    self:_waitQueue_Push({
      Type = SystemUnLockView.TypeEnum.CommonUnlockInfo,
      id = "Common",
      class = CommonUnlockInfo,
      data = data
    })
  end
  self:TryShowCell()
end

function SystemUnLockView:_waitQueue_Push(data)
  if data.Type.isMenu then
    local mData = FunctionUnLockFunc.Me():GetMenuData(data.id)
    data.data = mData and mData.staticData
    if data.data.Show then
      data.animplay = true
      self.waitPlayCount = self.waitPlayCount + 1
    end
  elseif data.data then
    data.animplay = true
    self.waitPlayCount = self.waitPlayCount + 1
  end
  self.waitQueues[#self.waitQueues + 1] = data
end

function SystemUnLockView:_waitQueue_Pop()
  local d = table.remove(self.waitQueues, 1)
  if d and d.animplay then
    self.waitPlayCount = self.waitPlayCount - 1
  end
  return d
end

function SystemUnLockView:SetCurrent(data)
  self.currentCell = self:GetOrSpawnCell(data.Type, data.class)
  self.currentCell:SetData(data)
end

function SystemUnLockView:TryShowCell()
  local waitlen = #self.waitQueues
  if waitlen == 0 then
    self:CloseSelf()
    return
  end
  if self:CheckSkipConfirm() then
    return
  end
  if self:GetCurrentCell() == nil then
    local rawData = self:_waitQueue_Pop()
    if rawData.Type.isMenu then
      FunctionUnLockFunc.Me():UnLockMenu(rawData.id)
      if not self.animplay or not rawData.animplay then
        self:HandleEndAndGoNext(rawData)
        return
      end
    end
    if rawData.data then
      self:SetCurrent(rawData)
    else
      self:TryShowCell()
    end
  end
end

function SystemUnLockView:CheckSkipConfirm()
  if self.skipConfirmed then
    return
  end
  return false
end

function SystemUnLockView:HandleEndAndGoNext(data)
  self:HandleEnd(data)
  local current = self:GetCurrentCell()
  if current ~= nil then
    current:Hide()
    self.currentCell = nil
  end
  self:TryShowCell()
end

function SystemUnLockView:HandleEnd(data)
  if data.Type.isMenu then
    data = data.data
    FunctionUnLockFunc.Me():UnRegisteEnterBtn(data.id)
    if data.event and data.event.type and data.event.type == "skillgrid" then
      ShortCutProxy.Instance:SetCacheListToRealList()
      self:sendNotification(SkillEvent.SkillUnlockPos)
    elseif data.id == 5359 then
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.HomeLetterPanel
      })
    end
  end
end

function SystemUnLockView:GetOrSpawnCell(Type, class)
  local cell = self.typeMapCell[Type]
  if cell == nil then
    cell = class.new(Game.AssetManager_UI:CreateAsset(Type.prefab, self.gameObject))
    cell:AddEventListener(SystemUnLockEvent.ShowNextEvent, self.HandleEndAndGoNext, self)
    self.typeMapCell[Type] = cell
  end
  cell:Show()
  return cell
end

function SystemUnLockView:OnShow()
  if self.currentCell and self.currentCell.OnShow then
    self.currentCell:OnShow()
  end
end

function SystemUnLockView:HandleHotKeyClosePop()
  self:OnCloseClick()
end
