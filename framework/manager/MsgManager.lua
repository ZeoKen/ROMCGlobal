autoImport("EventDispatcher")
autoImport("MsgData")
autoImport("CountDownMsg")
MsgManager = class("MsgManager")
MsgManager.MsgType = {
  Float_S3 = 0,
  Confirm = 1,
  ChatNearChannel = 2,
  ChatWorldChannel = 3,
  ChatTeamChannel = 4,
  ChatGuildChannel = 5,
  ChatYellChannel = 6,
  ChatSystemChannel = 7,
  CountDown = 8,
  ModelTop = 9,
  FuncPopUp = 10,
  Float2 = 11,
  MenuMsg = 12,
  WarnPopup = 13,
  ChatPrivateChannel = 14,
  AbilityGrow = 15,
  DontShowAgain = 16,
  NoticeMsg = 17,
  ShowyFloat = 18,
  MaintenanceMsg = 19,
  ActivityMsg = 20,
  AchievementPopupTip = 21,
  RaidMsg = 22,
  OverSeaMsg = 23,
  QueshFinishTip = 24,
  RainbowFloat = 25,
  MidMsg = 26,
  Float_S1 = 27,
  Float_S2 = 28,
  Float = 29,
  ChatGVG = 30
}
local BitIndexs = {}
for k, v in pairs(MsgManager.MsgType) do
  BitIndexs[#BitIndexs + 1] = v
end
table.sort(BitIndexs)
local SystemMsgRemove = {
  [2613] = 180
}

function MsgManager.ShowMsgByID(id, ...)
  local data = Table_Sysmsg[id]
  if data ~= nil then
    MsgManager.ShowMsg(data.Title, data.Text, data.Type, ...)
  else
    helplog("Table_Sysmsg id" .. id .. "策划没有上传！！！")
  end
end

function MsgManager.ShowMsgByIDTable(id, param, roleid, lockreason, userInfo)
  local data = Table_Sysmsg[id]
  if data ~= nil then
    local setting = FunctionPerformanceSetting.Me()
    if id == 43200 then
      if setting.setting.luckyNotify == true then
        local removeTime = SystemMsgRemove[id]
        MsgManager.ShowMsgTable(data.Title, data.Text, data.Type, param, roleid, data, removeTime, lockreason, data.ShowInSimplify)
      end
    else
      local removeTime = SystemMsgRemove[id]
      MsgManager.ShowMsgTable(data.Title, data.Text, data.Type, param, roleid, data, removeTime, lockreason, data.ShowInSimplify, userInfo)
    end
  end
end

function MsgManager.RemoveMsgByIDTable(id)
  local data = Table_Sysmsg[id]
  if data == nil then
    return
  end
  local handler, index
  for i = 1, #BitIndexs do
    index = BitIndexs[i]
    if BitUtil.valid(data.Type, index) then
      if BitUtil.band(data.Type, index) > 0 then
        handler = MsgManager.RemoveHandler[index]
        if handler ~= nil then
          handler(id)
        end
      end
    else
      break
    end
  end
end

function MsgManager.ShowEightTypeMsgByIDTable(id, param, pos, offset)
  local data = Table_Sysmsg[id]
  if data ~= nil then
    local data = MsgData.new(nil, data.Text, param)
    UIUtil.ShowEightTypeMsgByData(data, pos, offset)
  end
end

function MsgManager.ShowEightTypeMsgByString(content, pos, offset)
  if content ~= nil then
    local data = MsgData.new(nil, content, {})
    UIUtil.ShowEightTypeMsgByData(data, pos, offset)
  end
end

function MsgManager.ShowMsg(title, text, type, ...)
  local handler, index
  for i = 1, #BitIndexs do
    index = BitIndexs[i]
    if BitUtil.valid(type, index) then
      if BitUtil.band(type, index) > 0 then
        handler = MsgManager.TypeHandler[index]
        if handler ~= nil then
          handler(title, text, ...)
        end
      end
    else
      break
    end
  end
end

function MsgManager.ShowMsgTable(title, text, type, param, roleid, data, removeTime, lockreason, showInSimplify, userInfo)
  local handler, index
  for i = 1, #BitIndexs do
    index = BitIndexs[i]
    if BitUtil.valid(type, index) then
      if BitUtil.band(type, index) > 0 then
        handler = MsgManager.TypeTableHandler[index]
        if handler ~= nil then
          handler(title, text, param, roleid, data, removeTime, lockreason, showInSimplify, userInfo)
        end
      end
    else
      break
    end
  end
end

function MsgManager.FloatMsg(title, text, ...)
  local data = MsgData.new(nil, text, ...)
  UIUtil.FloatMsgByData(data)
end

function MsgManager.FloatMsg_S1(title, text, ...)
  local data = MsgData.new(nil, text, ...)
  data.cellType = 1
  UIUtil.FloatMsgByData(data)
end

function MsgManager.FloatMsg_S2(title, text, ...)
  local data = MsgData.new(nil, text, ...)
  data.cellType = 2
  UIUtil.FloatMsgByData(data)
end

function MsgManager.FloatMsg_S3(title, text, ...)
  local data = MsgData.new(nil, text, ...)
  data.cellType = 3
  UIUtil.FloatMsgByData(data)
end

function MsgManager.FloatMsg_S4(title, text, ...)
  local data = MsgData.new(nil, text, ...)
  data.cellType = 4
  UIUtil.FloatMsgByData(data)
end

function MsgManager.FloatMsgTableParam(title, text, param, roleid, data)
  if data and data.id and Table_Sysmsg[data.id] and nil == Table_Sysmsg[data.id].showInPVP and Game.MapManager:CheckMsgForbidden() then
    redlog("PVP地图中屏蔽、找顾伟锏修改msgID： ", data.id)
    return
  end
  local msgData = MsgData.new(nil, text, param)
  UIUtil.FloatMsgByData(msgData)
end

function MsgManager.FloatMsgTableParam_S1(title, text, param, roleid, data)
  if data and data.id and Table_Sysmsg[data.id] and nil == Table_Sysmsg[data.id].showInPVP and Game.MapManager:CheckMsgForbidden() then
    redlog("PVP地图中屏蔽、找顾伟锏修改msgID： ", data.id)
    return
  end
  local msgData = MsgData.new(nil, text, param)
  msgData.cellType = 1
  UIUtil.FloatMsgByData(msgData)
end

function MsgManager.FloatMsgTableParam_S2(title, text, param, roleid, data)
  if data and data.id and Table_Sysmsg[data.id] and nil == Table_Sysmsg[data.id].showInPVP and Game.MapManager:CheckMsgForbidden() then
    redlog("PVP地图中屏蔽、找顾伟锏修改msgID： ", data.id)
    return
  end
  local msgData = MsgData.new(nil, text, param)
  msgData.cellType = 2
  UIUtil.FloatMsgByData(msgData)
end

function MsgManager.FloatMsgTableParam_S3(title, text, param, roleid, data)
  if data and data.id and Table_Sysmsg[data.id] and nil == Table_Sysmsg[data.id].showInPVP and Game.MapManager:CheckMsgForbidden() then
    redlog("PVP地图中屏蔽、找顾伟锏修改msgID： ", data.id)
    return
  end
  local msgData = MsgData.new(nil, text, param)
  msgData.cellType = 3
  UIUtil.FloatMsgByData(msgData)
end

function MsgManager.FloatRainbowMsgTableParam(title, text, param)
  local data = MsgData.new(nil, text, param)
  UIUtil.FloatRainbowMsgByData(data)
end

function MsgManager.FloatMiddleBottomTable(title, text, param)
  local text = MsgParserProxy.Instance:TryParse(text, unpack(param))
  UIUtil.FloatMiddleBottom(tonumber(title), text)
end

function MsgManager.FloatRoleTopMsgTableParam(title, text, param, roleid)
  SceneUIManager.Instance:FloatRoleTopMsg(roleid, text, param)
end

function MsgManager.CountDownMsgTableParam(title, text, param, id, staticdata)
  local parser = MsgParserProxy.Instance
  local isHideTime = staticdata.buttonF == "HideTime"
  local parsedText = text
  if param ~= nil and 0 < #param then
    parsedText = parser:TryParse(text, unpack(param))
  end
  local text, data = parser:TryParseCountDown(parsedText, isHideTime)
  if nil ~= data then
    data.id = id
    UIUtil.StartSceenCountDown(text, data)
  end
end

function MsgManager.AdaptConfirm(confirmID, confirmHandler)
  if confirmID == nil or Table_ShortcutPower[confirmID] == nil then
    return confirmHandler
  end
  return function(...)
    if confirmHandler ~= nil then
      confirmHandler(...)
    end
    FuncShortCutFunc.Me():CallByID(confirmID)
  end
end

function MsgManager.DontAgainConfirmMsgByID(id, confirmHandler, cancelHandler, source, ...)
  local data = Table_Sysmsg[id]
  if data ~= nil and BitUtil.valid(data.Type, MsgManager.MsgType.DontShowAgain) then
    if BitUtil.band(data.Type, MsgManager.MsgType.DontShowAgain) > 0 then
      local dont = LocalSaveProxy.Instance:GetDontShowAgain(id)
      local curTime = ServerTime.CurServerTime()
      confirmHandler = MsgManager.AdaptConfirm(data.Confirm, confirmHandler)
      if dont == nil or 0 < dont and dont < curTime then
        local text = MsgParserProxy.Instance:TryParse(data.Text, ...)
        text = MsgParserProxy.Instance:ParseIlItemInfo(text)
        UIUtil.PopUpDontAgainConfirmView(text, confirmHandler, cancelHandler, source, data)
        if dont and dont < curTime then
          LocalSaveProxy.Instance:RemoveDontShowAgain(id)
        end
      else
        local opt = LocalSaveProxy.Instance:GetDontShowAgainOpt(id)
        opt = opt or data.DontShowAgainDefaultOpt
        if opt == 2 then
          if cancelHandler then
            cancelHandler(source)
          end
        elseif confirmHandler then
          confirmHandler(source)
        end
      end
    else
      MsgManager.ConfirmMsgByID(id, confirmHandler, cancelHandler, source, ...)
    end
  end
end

function MsgManager.DontAgainConfirmMsgByIDWithCustomText(customeText, id, confirmHandler, cancelHandler, source, ...)
  local data = Table_Sysmsg[id]
  if data ~= nil and BitUtil.valid(data.Type, MsgManager.MsgType.DontShowAgain) then
    if BitUtil.band(data.Type, MsgManager.MsgType.DontShowAgain) > 0 then
      local dont = LocalSaveProxy.Instance:GetDontShowAgain(id)
      local curTime = ServerTime.CurServerTime()
      confirmHandler = MsgManager.AdaptConfirm(data.Confirm, confirmHandler)
      if dont == nil or 0 < dont and dont < curTime then
        UIUtil.PopUpDontAgainConfirmView(customeText, confirmHandler, cancelHandler, source, data)
        if dont and dont < curTime then
          LocalSaveProxy.Instance:RemoveDontShowAgain(id)
        end
      else
        local opt = LocalSaveProxy.Instance:GetDontShowAgainOpt(id)
        opt = opt or data.DontShowAgainDefaultOpt
        if opt == 2 then
          if cancelHandler then
            cancelHandler(source)
          end
        elseif confirmHandler then
          confirmHandler(source)
        end
      end
    else
      data = Table_Sysmsg[id]
      if data ~= nil then
        confirmHandler = MsgManager.AdaptConfirm(data.Confirm, confirmHandler)
        UIUtil.PopUpConfirmYesNoView(data.Title, customeText, confirmHandler, cancelHandler, source, data.button, data.buttonF, id)
      end
    end
  end
end

function MsgManager.RichConfirmMsgByID(id, confirmHandler, cancelHandler, source, btnText, btnfText, ...)
  local data = Table_Sysmsg[id]
  if data ~= nil then
    local text = MsgParserProxy.Instance:TryParse(data.Text, ...)
    confirmHandler = MsgManager.AdaptConfirm(data.Confirm, confirmHandler)
    UIUtil.PopUpRichConfirmYesNoView(data.Title, text, confirmHandler, cancelHandler, source, btnText or data.button, btnfText or data.buttonF, id, nil, data.Close)
  end
end

function MsgManager.ConfirmMsgByID(id, confirmHandler, cancelHandler, source, ...)
  local data = Table_Sysmsg[id]
  if data ~= nil then
    local text = MsgParserProxy.Instance:TryParse(data.Text, ...)
    text = MsgParserProxy.Instance:ParseIlItemInfo(text)
    confirmHandler = MsgManager.AdaptConfirm(data.Confirm, confirmHandler)
    UIUtil.PopUpConfirmYesNoView(data.Title, text, confirmHandler, cancelHandler, source, data.button, data.buttonF, id, nil, data.Close)
  end
end

function MsgManager.CloseConfirmMsgByID(id)
  local uniqueConfirm = UIManagerProxy.UniqueConfirmView
  if uniqueConfirm ~= nil then
    local unique = uniqueConfirm:GetUnique()
    if unique ~= nil and unique == id then
      uniqueConfirm:CloseSelf()
    end
  end
end

function MsgManager.ConfirmMsg(title, text, ...)
  text = MsgParserProxy.Instance:TryParse(text, ...)
  UIUtil.PopUpConfirmYesNoView(title, text)
end

function MsgManager.ConfirmMsgTableParam(title, text, param, roleid, data, removeTime, lockreason)
  local confirmHandler, cancelHandler
  if param ~= nil then
    confirmHandler = param.confirmHandler
    cancelHandler = param.cancelHandler
  end
  confirmHandler = MsgManager.AdaptConfirm(data.Confirm, confirmHandler)
  if confirmHandler == nil then
    local handler = MsgParserProxy.Instance:GetMsgHandler(data.id)
    if handler ~= nil then
      function confirmHandler()
        handler()
      end
    end
  end
  if param ~= nil then
    text = MsgParserProxy.Instance:TryParse(text, unpack(param))
  else
    text = MsgParserProxy.Instance:TryParse(text)
  end
  UIUtil.PopUpConfirmYesNoView(title, text, confirmHandler, cancelHandler, nil, data.button, data.buttonF, removeTime, lockreason)
end

function MsgManager.FuncPopUpTableParam(title, text, param, roleid, data)
  local text = MsgParserProxy.Instance:TryParse(data.Text)
  UIUtil.PopUpFuncView(title, text, param.confirmHandler, param.cancelHandler, nil, data.button, data.buttonF)
end

function MsgManager.MenuMsgTableParam(title, text, param, roleid, data)
  if param ~= nil then
    text = MsgParserProxy.Instance:TryParse(text, unpack(param))
  else
    text = MsgParserProxy.Instance:TryParse(text)
  end
  local msg = {text = text, title = title}
  GameFacade.Instance:sendNotification(UIEvent.ShowUI, {
    viewname = "PopUp10View"
  })
  GameFacade.Instance:sendNotification(SystemMsgEvent.MenuMsg, msg)
end

function MsgManager.WarnPopupParam(title, text, param, roleid, data)
  local text
  if param ~= nil then
    text = MsgParserProxy.Instance:TryParse(data.Text, unpack(param))
    UIUtil.WarnPopup(title, text, param.confirmHandler, param.cancelHandler, nil, data.button, data.buttonF)
  else
    text = MsgParserProxy.Instance:TryParse(data.Text)
    UIUtil.WarnPopup(title, text, nil, nil, nil, data.button, data.buttonF)
  end
end

function MsgManager.ChatMsgTableParam(text, param, channelID, removeTime, showInSimplify, userInfo)
  local isHideInSimplify
  if showInSimplify == 1 then
    isHideInSimplify = false
  end
  ChatRoomProxy.Instance:AddSystemMessage(channelID, text, param, removeTime, nil, nil, isHideInSimplify, userInfo)
end

function MsgManager.ChatNearChannelMsgTableParam(title, text, param, roleid, data, removeTime, lockreason, showInSimplify)
  MsgManager.ChatMsgTableParam(text, param, ChatChannelEnum.Current, removeTime, showInSimplify)
end

function MsgManager.ChatWorldChannelMsgTableParam(title, text, param, roleid, data, removeTime, lockreason, showInSimplify)
  MsgManager.ChatMsgTableParam(text, param, ChatChannelEnum.World, removeTime, showInSimplify)
end

function MsgManager.ChatTeamChannelMsgTableParam(title, text, param, roleid, data, removeTime, lockreason, showInSimplify)
  MsgManager.ChatMsgTableParam(text, param, ChatChannelEnum.Team, removeTime, showInSimplify)
end

function MsgManager.ChatGuildChannelMsgTableParam(title, text, param, roleid, data, removeTime, lockreason, showInSimplify, userInfo)
  MsgManager.ChatMsgTableParam(text, param, ChatChannelEnum.Guild, removeTime, showInSimplify, userInfo)
end

function MsgManager.ChatYellChannelMsgTableParam(title, text, param, roleid, data, removeTime, lockreason, showInSimplify)
  MsgManager.ChatMsgTableParam(text, param, ChatChannelEnum.Current, removeTime, showInSimplify)
end

function MsgManager.ChatSystemChannelMsgTableParam(title, text, param, roleid, data, removeTime, lockreason, showInSimplify)
  MsgManager.ChatMsgTableParam(text, param, ChatChannelEnum.System, removeTime, showInSimplify)
end

function MsgManager.ChatPrivateChannelMsgTableParam(title, text, param, roleid, data, removeTime, lockreason, showInSimplify)
  MsgManager.ChatMsgTableParam(text, param, ChatChannelEnum.Private, removeTime, showInSimplify)
end

function MsgManager.ChatGVGChannelMsgTableParam(title, text, param, roleid, data, removeTime, lockreason, showInSimplify)
  local proxy = GuildProxy.Instance
  local amIMercenary = proxy:DoIHaveMercenaryGuild()
  local mercenaryNum = proxy:GetMyGuildMercenaryCount()
  local guildId = proxy:GetGuildID()
  if amIMercenary or mercenaryNum and 0 < mercenaryNum then
    MsgManager.ChatMsgTableParam(text, param, ChatChannelEnum.GVG, removeTime, showInSimplify)
  elseif guildId and guildId ~= 0 then
    MsgManager.ChatMsgTableParam(text, param, ChatChannelEnum.Guild, removeTime, showInSimplify)
  end
end

function MsgManager.NoticeMsgTableParam(title, text, param)
  local msg = {text = text, param = param}
  GameFacade.Instance:sendNotification(UIEvent.ShowUI, {
    viewname = "NoticeMsgView"
  })
  GameFacade.Instance:sendNotification(SystemMsgEvent.NoticeMsg, msg)
end

function MsgManager.NoticeRaidMsgById(id, param)
  local data = Table_Sysmsg[id]
  if data then
    local msgText = MsgParserProxy.Instance:TryParse(data.Text, param)
    EventManager.Me():DispatchEvent(SystemMsgEvent.RaidAdd, msgText)
  end
end

function MsgManager.ShowyFloatMsgTableParam(title, text, param)
  if param then
    text = MsgParserProxy.Instance:TryParse(text, unpack(param))
  end
  UIUtil.FloatShowyMsg(text)
end

function MsgManager.MaintenanceMsgTableParam(title, text, param, roleid, data)
  local confirmHandler, cancelHandler
  if param ~= nil then
    cancelHandler = param.cancelHandler
    confirmHandler = param.confirmHandler
    text = MsgParserProxy.Instance:TryParse(text, unpack(param))
  else
    text = MsgParserProxy.Instance:TryParse(text)
  end
  FloatingPanel.Instance:ShowMaintenanceMsg(title, text, data.remark, data.button, data.Picture, confirmHandler, cancelHandler)
end

function MsgManager.ActivityMsgTableParam(title, text, param, roleid, data)
  local viewdata = {
    viewname = "ActivityPopUpView",
    title = title,
    text = text,
    param = param,
    msgData = data
  }
  GameFacade.Instance:sendNotification(UIEvent.ShowUI, viewdata)
end

function MsgManager.RecommendScoreMsgTableParm(_menuId)
  local viewdata = {
    viewname = "RecommendScoreView",
    menuId = _menuId
  }
  GameFacade.Instance:sendNotification(UIEvent.ShowUI, viewdata)
end

function MsgManager.AndroidPerissonMsg(id, confirmHandler)
  local data = Table_Sysmsg[id]
  if data ~= nil then
    LocalSaveProxy.Instance:RemoveDontShowAgain(id)
    local viewData = {
      viewname = "AndroidPermissionPanel",
      data = data,
      confirmHandler = confirmHandler
    }
    GameFacade.Instance:sendNotification(UIEvent.ShowUI, viewData)
  else
    helplog("Table_Sysmsg not have id == ", id)
    confirmHandler()
  end
end

function MsgManager.NoticeMsgById(id, param)
  local data = Table_Sysmsg[id]
  if data ~= nil then
    MsgManager.NoticeMsgTableParam(data.Title, data.Text, param)
  end
end

function MsgManager.OverSeaMsgTableParam(title, text, param)
  OverSeaFunc.MsgToExtraOperation(title, text, param)
end

function MsgManager.PopupTipAchievement(achievement_conf_id)
  UIUtil.PopupTipAchievement(achievement_conf_id)
end

function MsgManager.QuestFinishTableParam(title, text, param, roleid, data)
  FloatingPanel.Instance:UpdateQuestFinishPopUp(text)
end

function MsgManager.MidMsgTableParam(title, text, param)
  local data = {}
  if type(param) == "table" then
    data.text = string.format(text, unpack(param))
  else
    data.text = string.format(text, param)
  end
  local midMsg = FloatingPanel.Instance:GetMidMsg()
  midMsg:SetData(data)
end

function MsgManager.RemoveMidMsg(id)
  FloatingPanel.Instance:RemoveMidMsg()
end

function MsgManager.RemoveCountDownMsg(id)
  FloatingPanel.Instance:DestroyCountDown()
end

MsgManager.TypeHandler = {}
MsgManager.TypeHandler[MsgManager.MsgType.Float] = MsgManager.FloatMsg
MsgManager.TypeHandler[MsgManager.MsgType.Float_S1] = MsgManager.FloatMsg_S1
MsgManager.TypeHandler[MsgManager.MsgType.Float_S2] = MsgManager.FloatMsg_S2
MsgManager.TypeHandler[MsgManager.MsgType.Float_S3] = MsgManager.FloatMsg_S3
MsgManager.TypeHandler[MsgManager.MsgType.Confirm] = MsgManager.ConfirmMsg
MsgManager.TypeHandler[MsgManager.MsgType.OverSeaMsg] = MsgManager.OverSeaMsgTableParam
MsgManager.TypeTableHandler = {}
MsgManager.TypeTableHandler[MsgManager.MsgType.Float] = MsgManager.FloatMsgTableParam
MsgManager.TypeTableHandler[MsgManager.MsgType.Float_S1] = MsgManager.FloatMsgTableParam_S1
MsgManager.TypeTableHandler[MsgManager.MsgType.Float_S2] = MsgManager.FloatMsgTableParam_S2
MsgManager.TypeTableHandler[MsgManager.MsgType.Float_S3] = MsgManager.FloatMsgTableParam_S3
MsgManager.TypeTableHandler[MsgManager.MsgType.Confirm] = MsgManager.ConfirmMsgTableParam
MsgManager.TypeTableHandler[MsgManager.MsgType.ModelTop] = MsgManager.FloatRoleTopMsgTableParam
MsgManager.TypeTableHandler[MsgManager.MsgType.CountDown] = MsgManager.CountDownMsgTableParam
MsgManager.TypeTableHandler[MsgManager.MsgType.FuncPopUp] = MsgManager.FuncPopUpTableParam
MsgManager.TypeTableHandler[MsgManager.MsgType.MenuMsg] = MsgManager.MenuMsgTableParam
MsgManager.TypeTableHandler[MsgManager.MsgType.WarnPopup] = MsgManager.WarnPopupParam
MsgManager.TypeTableHandler[MsgManager.MsgType.AbilityGrow] = MsgManager.FloatMiddleBottomTable
MsgManager.TypeTableHandler[MsgManager.MsgType.NoticeMsg] = MsgManager.NoticeMsgTableParam
MsgManager.TypeTableHandler[MsgManager.MsgType.ChatNearChannel] = MsgManager.ChatNearChannelMsgTableParam
MsgManager.TypeTableHandler[MsgManager.MsgType.ChatWorldChannel] = MsgManager.ChatWorldChannelMsgTableParam
MsgManager.TypeTableHandler[MsgManager.MsgType.ChatTeamChannel] = MsgManager.ChatTeamChannelMsgTableParam
MsgManager.TypeTableHandler[MsgManager.MsgType.ChatGuildChannel] = MsgManager.ChatGuildChannelMsgTableParam
MsgManager.TypeTableHandler[MsgManager.MsgType.ChatYellChannel] = MsgManager.ChatYellChannelMsgTableParam
MsgManager.TypeTableHandler[MsgManager.MsgType.ChatSystemChannel] = MsgManager.ChatSystemChannelMsgTableParam
MsgManager.TypeTableHandler[MsgManager.MsgType.ChatPrivateChannel] = MsgManager.ChatPrivateChannelMsgTableParam
MsgManager.TypeTableHandler[MsgManager.MsgType.ChatGVG] = MsgManager.ChatGVGChannelMsgTableParam
MsgManager.TypeTableHandler[MsgManager.MsgType.ShowyFloat] = MsgManager.ShowyFloatMsgTableParam
MsgManager.TypeTableHandler[MsgManager.MsgType.MaintenanceMsg] = MsgManager.MaintenanceMsgTableParam
MsgManager.TypeTableHandler[MsgManager.MsgType.ActivityMsg] = MsgManager.ActivityMsgTableParam
MsgManager.TypeTableHandler[MsgManager.MsgType.AchievementPopupTip] = MsgManager.PopupTipAchievement
MsgManager.TypeTableHandler[MsgManager.MsgType.RaidMsg] = MsgManager.NoticeRaidMsgById
MsgManager.TypeTableHandler[MsgManager.MsgType.OverSeaMsg] = MsgManager.OverSeaMsgTableParam
MsgManager.TypeTableHandler[MsgManager.MsgType.QueshFinishTip] = MsgManager.QuestFinishTableParam
MsgManager.TypeTableHandler[MsgManager.MsgType.RainbowFloat] = MsgManager.FloatRainbowMsgTableParam
MsgManager.TypeTableHandler[MsgManager.MsgType.MidMsg] = MsgManager.MidMsgTableParam
MsgManager.RemoveHandler = {}
MsgManager.RemoveHandler[MsgManager.MsgType.MidMsg] = MsgManager.RemoveMidMsg
MsgManager.RemoveHandler[MsgManager.MsgType.CountDown] = MsgManager.RemoveCountDownMsg
