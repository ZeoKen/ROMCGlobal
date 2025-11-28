OverSeaFunc = class("OverSeaFunc")

function OverSeaFunc.MsgToExtraOperation(title, text, param)
  if BranchMgr.IsChina() or BranchMgr.IsJapan() or BranchMgr.IsKorea() then
    local data = MsgData.new(nil, text, param)
    UIUtil.FloatMsgByData(data)
    return
  end
  GameFacade.Instance:sendNotification(UIEvent.CloseUI, UIViewType.NormalLayer)
  GameFacade.Instance:sendNotification(UIEvent.CloseUI, UIViewType.DialogLayer)
  if text == Table_Sysmsg[1].Text then
    FunctionNewRecharge.Instance():OpenUI(PanelConfig.NewRecharge_TDeposit, FunctionNewRecharge.InnerTab.Deposit_Zeny)
  elseif text == Table_Sysmsg[3634].Text then
    FunctionNewRecharge.Instance():OpenUI(PanelConfig.NewRecharge_TDeposit)
  else
    FunctionNewRecharge.Instance():OpenUI(PanelConfig.NewRecharge_TDeposit, FunctionNewRecharge.InnerTab.Deposit_Zeny)
  end
end

function OverSeaFunc.SpecialItemNotEnoughMsg(itemID)
  if itemID == 100 then
    MsgManager.ShowMsgByID(1)
  elseif itemID == 151 then
    MsgManager.ShowMsgByID(3634)
  else
    local itemName = ""
    if Table_Item[itemID] then
      itemName = Table_Item[itemID].NameZh or ""
    end
    MsgManager.FloatMsgTableParam(nil, ZhString.HappyShop_NotEnough, itemName)
  end
end

function OverSeaFunc.GetZenDeskInfo()
  local charid = ""
  if Game ~= nil and Game.Myself ~= nil then
    playerName = Game.Myself.data:GetName()
    if Game.Myself.data ~= nil and Game.Myself.data.userdata ~= nil then
      local server = FunctionLogin.Me():getCurServerData()
      level = Game.Myself.data.userdata:Get(UDEnum.ROLELEVEL)
      charid = Game.Myself.data.id
    end
  end
  return charid
end

function OverSeaFunc.StartUCloudTimer()
  if OverSeaFunc.ucloud_timer ~= nil then
    TimeTickManager.Me():ClearTick(OverSeaFunc)
    OverSeaFunc.ucloud_timer = nil
  end
  if OverSeaFunc.ucloud_timer == nil then
    OverSeaFunc.ucloud_timer = TimeTickManager.Me():CreateTick(1000, 300000, function()
      OverSeaFunc.SetUCloudData()
    end, OverSeaFunc)
  end
end

function OverSeaFunc.SetUCloudData()
  if not BackwardCompatibilityUtil.CompatibilityMode_V62 and not EnvChannel.IsReleaseBranch() then
    local accid = FunctionGetIpStrategy.Me():getAccId()
    if accid ~= nil then
      local data = "accid:" .. accid .. ";"
      data = data .. "timestamp:" .. tostring(ServerTime.serverTimeStamp) .. ";"
      data = data .. "device_info:" .. DeviceInfo.GetModel() .. ";"
      if Game ~= nil and Game.Myself ~= nil then
        data = data .. "line_id:" .. tostring(Game.Myself.data.userdata:Get(UDEnum.ZONEID)) .. ";"
      end
      if Game ~= nil and Game.MapManager ~= nil then
        data = data .. "map_id:" .. Game.MapManager:GetMapID() .. ";"
      end
    end
  end
end

function OverSeaFunc.ClearFunc()
  if not BranchMgr.IsChina() then
    local listener = OverSeas_TW.OverSeasManager.GetInstance().GetTDSGEventListener()
    listener.TDSGInitCallback = nil
    listener.TDSGDidPassportCallback = nil
    listener.TDSGDidPaySuccessCallback = nil
    listener.TDSGPayCancelCallback = nil
    listener.TDSGPassportUpdatedCallback = nil
  end
end
