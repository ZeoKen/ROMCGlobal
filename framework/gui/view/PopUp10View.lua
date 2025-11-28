autoImport("MenuUnLockCell")
autoImport("MenuMsgCell")
autoImport("SystemUnLockView")
PopUp10View = class("PopUp10View", SystemUnLockView)
PopUp10View.ViewType = UIViewType.Popup10Layer
PopUp10View.NUserNewMenu = "PopUp10View.NUserNewMenu"
PopUp10View.ItemCoinShowType = {Common = 1, Decompose = 2}

function PopUp10View:Init()
  self.data = self.viewdata.data
  self:MapViewInterests()
  self:FindObjs()
  self:InitDatas()
  self:InitClickEvent()
end

function PopUp10View:MapViewInterests()
  self:AddListenEvt(PopUp10View.NUserNewMenu, self.HandleNewMenu)
  self:AddListenEvt(SystemMsgEvent.MenuMsg, self.HandleMenuMsg)
  self:AddListenEvt(SystemMsgEvent.MenuCoinPop, self.HandleMenuCoinPop)
  self:AddListenEvt(SystemMsgEvent.MenuItemPop, self.HandleMenuItemPop)
  self:AddListenEvt(HotKeyEvent.ClosePopView, self.HandleHotKeyClosePop)
end

function PopUp10View:HandleMenuCoinPop(note)
  printGreen("HandleMenuCoinPop")
  local data = {}
  TableUtility.TableShallowCopy(data, note.body)
  self:_waitQueue_Push({
    Type = SystemUnLockView.TypeEnum.MenuCoinPop,
    class = CoinPopView,
    data = data
  })
  self:TryShowCell()
end

function PopUp10View:HandleMenuMsg(note)
  self:_waitQueue_Push({
    Type = SystemUnLockView.TypeEnum.SystemMenuMsg,
    class = MenuMsgCell,
    data = note.body
  })
  self:TryShowCell()
end

function PopUp10View:HandleMenuItemPop(note)
  printGreen("HandleMenuItemPop")
  local data = {}
  TableUtility.TableShallowCopy(data, note.body)
  self:_waitQueue_Push({
    Type = SystemUnLockView.TypeEnum.MenuItemPop,
    class = ItemPopView,
    data = data
  })
  self:TryShowCell()
  local isMax = false
  local showData
  for i = 1, #data do
    if data[i] and data[i].equipInfo and data[i].equipInfo.randomEffect then
      for k, v in pairs(data[i].equipInfo.randomEffect) do
        local equipeffectData = Table_EquipEffect[k]
        if equipeffectData and v == equipeffectData.AttrRate[#equipeffectData.AttrRate][1] then
          isMax = true
          showData = data[i]
          break
        end
      end
    end
    if showData then
      break
    end
  end
  if isMax then
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.EquipConvertResultShareView,
      viewdata = showData
    })
  end
end

function PopUp10View:OnExit()
  PopUp10View.super.OnExit(self)
  ServiceItemProxy.spec_icon = nil
end

function PopUp10View:HandleNewMenu(note)
  local list = note.body.list
  self.animplay = note.body.animplay
  self.unlocklist = self.unlocklist or {}
  local config
  for i = 1, #list do
    local v = list[i]
    config = Table_Menu[v]
    if config then
      if config.type == 3 then
        self:_waitQueue_Push({
          Type = SystemUnLockView.TypeEnum.MenuMsg,
          id = v,
          class = MenuMsgCell,
          data = nil
        })
      end
    else
      self:LogError("Can Not Find " .. v .. " in Table_Menu")
    end
  end
  self:TryShowCell()
end

function PopUp10View:HandleEnd(data)
  PopUp10View.super.HandleEnd(self, data)
  if data.Type == SystemUnLockView.TypeEnum.MenuCoinPop or data.Type == SystemUnLockView.TypeEnum.MenuItemPop then
    self:ShowFloatMsgByData(data, true)
  end
end

function PopUp10View:CheckSkipConfirm()
  return false
end

local tipsUnionEdge

function PopUp10View:ShowFloatMsgByData(data, in_chat_view_only)
  local itemDatas = data.data
  if not itemDatas then
    return
  end
  if not tipsUnionEdge then
    tipsUnionEdge = GameConfig.MiscSetting.tipsUnionEdge
  end
  local elementCount, itemCount = #itemDatas, 0
  local sysMsgId = (elementCount > tipsUnionEdge or in_chat_view_only) and 93 or 6
  for i = 1, #itemDatas do
    local single = itemDatas[i]
    local params = {}
    params[1] = single.staticData.id
    params[2] = single.staticData.id
    params[3] = single.num
    itemCount = itemCount + single.num
    MsgManager.ShowMsgByIDTable(sysMsgId, params, Game.Myself.data.id)
  end
  if elementCount > tipsUnionEdge then
    MsgManager.ShowMsgByIDTable(41011, itemCount)
  end
end
