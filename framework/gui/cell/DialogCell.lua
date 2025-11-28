local BaseCell = autoImport("BaseCell")
DialogCell = class("DialogCell", BaseCell)
autoImport("PpLua")
autoImport("SimpleItemCell")
local ModelType = {NPC = 1, Monster = 2}
local kapraCommonNpcID = 823480
local maxVolumeSpNum = 2

function DialogCell:Init()
  self:InitView()
end

function DialogCell:InitView()
  self.namelabel = self:FindGO("NpcNameLabel"):GetComponent(UILabel)
  self.voiceBtn = self:FindGO("voice", self.namelabel.gameObject)
  if self.voiceBtn then
    self:AddClickEvent(self.voiceBtn, function()
      self:OnNpcVoiceBtnClick()
    end)
    for i = 1, maxVolumeSpNum do
      self["voiceVolume" .. i] = self:FindComponent("volume" .. i, UISprite, self.voiceBtn)
      self["voiceVolume" .. i].alpha = 0
    end
    self.curVolumeSpNum = 0
  end
  self.contentlabel = self:FindGO("DialogContent"):GetComponent(UILabel)
  self.continue = self:FindGO("continueSymbol")
  if self.continue then
    self.continueSp = self.continue:GetComponent(UISprite)
  end
  self.viceContentLabel = self:FindComponent("DialogViceContent", UILabel)
  self.Purikura = self:FindGO("Purikura")
  if self.Purikura then
    self.Purikura_UITexture = self.Purikura:GetComponent(UITexture)
  end
  local bgClick = self:FindGO("BgClick")
  if bgClick then
    local bgSprite = bgClick:GetComponent(UISprite)
    bgSprite.height = Game.GameObjectUtil:GetUIActiveHeight(bgClick)
    self:SetEvent(bgClick, function(go)
      self:ClickCell()
    end, {hideClickSound = true})
  end
  self.npcModel = self:FindGO("NPCModel", bottom)
  if self.npcModel then
    self.npcModelTexture = self:FindGO("npcTexture"):GetComponent(UITexture)
    self.modelRoot = self:FindGO("ModelRoot")
  end
  self.plotContainer = self:FindGO("PlotContainer")
  if self.plotContainer then
    self.plotpic = self:FindGO("PlotPic"):GetComponent(UITexture)
    self.plotBG1 = self:FindGO("BGTexture1"):GetComponent(UITexture)
    self.plotBG2 = self:FindGO("BGTexture2"):GetComponent(UITexture)
    self.plotContainer:SetActive(false)
  end
end

function DialogCell:ClickCell()
  if self.leftStr == nil then
    self:PassEvent(MouseEvent.MouseClick)
    return
  end
  if self.cpyData == nil then
    self.cpyData = {}
  else
    TableUtility.TableClear(self.cpyData)
  end
  for k, v in pairs(self.data) do
    self.cpyData[k] = v
  end
  self.cpyData.Text = self.leftStr
  self:SetData(self.cpyData)
end

function DialogCell._HandleMidEffectShow(effectHandle, owner)
  if effectHandle == nil then
    helplog("if effectHandle == nil then")
    return
  end
  owner:HandleMidEffectShow(effectHandle)
end

function DialogCell:HandleMidEffectShow(effectHandle, owner)
end

function DialogCell:SetData(dialogData, params, npcguid, isExtendDialog)
  self.data = dialogData
  if dialogData then
    self.npcguid = npcguid
    local speakerID = dialogData.Speaker or 0
    if speakerID == kapraCommonNpcID then
      speakerID = self:CheckKapraName() or 0
    end
    if speakerID == 0 then
      self.namelabel.text = Game.Myself.data:GetName()
      speakerID = Game.Myself.data.id
    elseif Table_Npc[speakerID] then
      self.namelabel.text = Table_Npc[speakerID].NameZh
      if dialogData.ModelAct then
        self:SetModel(ModelType.NPC, dialogData)
      else
        self.model = nil
        if self.npcModelTexture then
          self.npcModelTexture.mainTexture = nil
        end
      end
    elseif Table_Monster[speakerID] then
      self.namelabel.text = Table_Monster[speakerID].NameZh
      if dialogData.ModelAct then
        self:SetModel(ModelType.Monster, dialogData)
      else
        self.model = nil
        if self.npcModelTexture then
          self.npcModelTexture.mainTexture = nil
        end
      end
    end
    if speakerID then
      if dialogData.Emoji and dialogData.Emoji ~= 0 then
        self:PlayEmoji(speakerID, dialogData.Emoji)
      end
      if dialogData.Action and dialogData.Action.actionid then
        self:PlayAction(speakerID, dialogData.Action.actionid, dialogData.Action.num)
      end
      if self.voiceBtn then
        if BranchMgr.IsKorea() then
          self:SetNpcVoiceBtnState(false)
        elseif not StringUtil.IsEmpty(dialogData.Voice) and FunctionPlotCmd.Me():PlayNpcVisitVocal(dialogData.Voice) ~= false then
          self:SetNpcVoiceBtnState(true)
        else
          self:SetNpcVoiceBtnState(false)
        end
      end
    end
    local context = self:GetDialogText(dialogData)
    if context == "" then
      self:Hide(self.gameObject)
    else
      self:Show(self.gameObject)
      if params and 0 < #params then
        for k, v in pairs(params) do
          if string.match(v, "、") then
            local t = StringUtil.Split(v, "、")
            for k, v in pairs(t) do
              t[k] = OverSea.LangManager.Instance():GetLangByKey(v)
            end
            params[k] = table.concat(t, "、")
          end
        end
        context = self:_ReplaceQuestParams(context, params)
      end
      self:SetContext(context)
      if dialogData.Speaker == 1024 and dialogData.id == 2251 then
        if BranchMgr.IsJapan() or BranchMgr.IsKorea() then
          OverSeas_TW.OverSeasManager.GetInstance():TrackEvent(AppBundleConfig.GetAdjustByName("changeJob"))
        elseif BranchMgr.IsSEA() or BranchMgr.IsNA() or BranchMgr.IsEU() then
          OverSeas_TW.OverSeasManager.GetInstance():EvtUnlockAchievement()
        end
      end
      if not dialogData.NoSpeak and not isExtendDialog then
        self:PlayerSpeak(speakerID, context)
      end
    end
    if self.viceContentLabel then
      if dialogData.ViceText then
        self.viceContentLabel.text = dialogData.ViceText
        self.viceContentLabel.gameObject:SetActive(true)
      else
        self.viceContentLabel.gameObject:SetActive(false)
      end
    end
    if dialogData.Picture then
      self:SetPlotPic(dialogData.Picture)
    else
      self:UnLoadPlotPic()
    end
    if dialogData.BlackMask and dialogData.BlackMask == 1 then
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.DialogMaskView
      })
    end
    self:SetItemDatas(dialogData.Items)
  end
end

local _Dialog_ReplaceParam = Dialog_ReplaceParam

function DialogCell:GetDialogText(dialogData)
  local out_text = MsgParserProxy.Instance:TryParse(dialogData.Text or "")
  if dialogData.id == nil or _Dialog_ReplaceParam == nil then
    return out_text
  end
  local cfg = _Dialog_ReplaceParam[dialogData.id]
  if cfg == nil then
    return out_text
  end
  local params = {}
  for i = 1, #cfg do
    table.insert(params, self:ParseReplaceParam(cfg[i], self.npcguid))
  end
  return string.format(out_text, unpack(params))
end

local ReplaceParam_FuncMap = {}
local DialogParamType_StoragePrice = DialogParamType and DialogParamType.StoragePrice or "111"
local DialogParamType_GuildName = DialogParamType.GuildName or "Dialog_ParamType_GuildName"
local DialogParamType_GuildLeaderName = DialogParamType.GuildLeaderName or "Dialog_ParamType_GuildLeaderName"
local DialogParamType_GvgSeason = DialogParamType.GvgSeason or "Dialog_ParamType_GvgSeason"
local DialogParamType_GvgStatueBattleLine = DialogParamType.GvgStatueBattleLine or "Dialog_ParamType_GvgStatueBattleLine"
local DialogParamType_GvgStatueCity = DialogParamType.GvgStatueCity or "Dialog_ParamType_GvgStatueCity"
local DialogParamType_GvgStatueGuildName = DialogParamType.GvgStatueGuildName or "Dialog_ParamType_GvgStatueGuildName"
local DialogParamType_GvgStatueLeaderName = DialogParamType.GvgStatueLeaderName or "Dialog_ParamType_GvgStatueLeaderName"
local TryGetGVGStatueCityID = function(guid)
  local nnpc = NSceneNpcProxy.Instance:Find(guid)
  if nnpc then
    local unique_id = GvgProxy.GetStatueCity(nnpc.data.uniqueid)
    if unique_id then
      return GvgProxy.GetStatueCity(unique_id)
    end
  end
end
local DialogParamType_TrippleChamp = DialogParamType.TrippleChampion
local DialogParamType_TeampwsChamp = DialogParamType.TeampwsChampion
local DialogParamType_TwelveChamp = DialogParamType.TwelveChampion
ReplaceParam_FuncMap[DialogParamType_StoragePrice] = function()
  local isFree = ActivityEventProxy.Instance:IsStorageFree()
  if isFree then
    return 0
  end
  local free_actid = GameConfig.System.warehouse_free_activityid
  if free_actid then
    local running = FunctionActivity.Me():IsActivityRunning(free_actid)
    if running then
      return 0
    end
  end
  local rewardInfo = ActivityEventProxy.Instance:GetRewardByType(AERewardType.GuildDonate)
  return GameConfig.System.warehouseZeny
end
ReplaceParam_FuncMap[DialogParamType_GuildName] = function()
  local info = GvgProxy.Instance:GetStatueInfo()
  return info and info.guildname or ""
end
ReplaceParam_FuncMap[DialogParamType_GuildLeaderName] = function()
  local info = GvgProxy.Instance:GetStatueInfo()
  return info and info.leadername or ""
end
ReplaceParam_FuncMap[DialogParamType_GvgSeason] = function()
  local info = GvgProxy.Instance:GetStatueInfo()
  return info and info.season or ""
end
ReplaceParam_FuncMap[DialogParamType_GvgStatueBattleLine] = function(guid)
  return GvgProxy.Instance:GetCurMapStatueBattleClientGroupID()
end
ReplaceParam_FuncMap[DialogParamType_GvgStatueCity] = function(guid)
  local city_id = TryGetGVGStatueCityID(guid)
  if city_id then
    local city_static_data = Table_Guild_StrongHold[city_id] or Table_DateBattleCity[city_id]
    if city_static_data then
      return city_static_data.Name or ""
    end
  end
  return ""
end
ReplaceParam_FuncMap[DialogParamType_GvgStatueGuildName] = function(guid)
  local city_id = TryGetGVGStatueCityID(guid)
  if city_id then
    local group_id = GuildProxy.Instance:GetMyGuildGvgGroup()
    if group_id and 0 < group_id then
      return GvgProxy.Instance:GetGuildNameByStatusCity(group_id, city_id) or ""
    end
  end
  return ""
end
ReplaceParam_FuncMap[DialogParamType_GvgStatueLeaderName] = function(guid)
  local city_id = TryGetGVGStatueCityID(guid)
  if city_id then
    local group_id = GuildProxy.Instance:GetMyGuildGvgGroup()
    if group_id and 0 < group_id then
      return GvgProxy.Instance:GetLeaderNameByStatusCity(group_id, city_id) or ""
    end
  end
  return ""
end
ReplaceParam_FuncMap[DialogParamType_TrippleChamp] = function()
  local info = PvpProxy.Instance:GetStatueInfo(PvpProxy.StatueType.Triple)
  return info and info.statueInfo and info.statueInfo.username or ""
end
ReplaceParam_FuncMap[DialogParamType_TeampwsChamp] = function()
  local info = PvpProxy.Instance:GetStatueInfo(PvpProxy.StatueType.Teampws)
  return info and info.statueInfo and info.statueInfo.username or ""
end
ReplaceParam_FuncMap[DialogParamType_TwelveChamp] = function()
  local info = PvpProxy.Instance:GetStatueInfo(PvpProxy.StatueType.Twelve)
  return info and info.statueInfo and info.statueInfo.username or ""
end

function DialogCell:ParseReplaceParam(param, npcguid)
  local func = ReplaceParam_FuncMap[param]
  if func then
    return ReplaceParam_FuncMap[param](npcguid)
  end
  return ""
end

local QuestParamPattern = "%[QuestParam%]"

function DialogCell:_ReplaceQuestParams(text, params)
  local resultStr = string.gsub(text, QuestParamPattern, function()
    return table.remove(params, 1) or ""
  end)
  return resultStr
end

function DialogCell:SetContext(text)
  self.contentlabel.text = text
  local newText = self.contentlabel.text
  local bWrap, leftStr = OverseaHostHelper:GetWrapLeftStringTextLua(self.contentlabel, newText)
  if not bWrap and leftStr ~= "" then
    self.leftStr = leftStr
  else
    self.leftStr = nil
  end
end

function DialogCell:GetNearNpc(id)
  local myPos = Game.Myself:GetPosition()
  return NSceneNpcProxy.Instance:FindNearestNpc(myPos, id)
end

function DialogCell:PlayerSpeak(id, text)
  local role = self:GetNearNpc(id)
  if role then
    role:GetSceneUI().roleTopUI:Speak(text)
  end
end

function DialogCell:PlayEmoji(id, emojiId)
  local role = self:GetNearNpc(id)
  if role then
    role:GetSceneUI().roleTopUI:PlayEmojiById(emojiId)
  end
end

function DialogCell:PlayAction(id, actionId, num)
  local role = self:GetNearNpc(id)
  if role then
    num = num or 1
    local actionName = Table_ActionAnime[actionId] and Table_ActionAnime[actionId].Name
    role:Client_PlayAction(actionName, nil, false)
  end
end

function DialogCell:Set_UpdateSetTextCall(updateSetTextCall, updateSetTextCallParam)
  local remove, text = updateSetTextCall(updateSetTextCallParam)
  self:SetContext(text)
  if not remove then
    self.updateSetTextCall = updateSetTextCall
    self.updateSetTextCallParam = updateSetTextCallParam
    self.updateSetTick = TimeTickManager.Me():CreateTick(0, 1000, self._updateSetTick, self)
  end
end

function DialogCell:_updateSetTick()
  if self.updateSetTextCall then
    local remove, text = self.updateSetTextCall(self.updateSetTextCallParam)
    self:SetContext(text)
    if remove then
      self:RemoveUpdateSetTick()
    end
  end
end

function DialogCell:RemoveUpdateSetTick()
  if self.updateSetTick then
    TimeTickManager.Me():ClearTick(self, 1)
    self.updateSetTick = nil
  end
end

function DialogCell:OnExit()
  self:RemoveUpdateSetTick()
  if self.Purikura then
    self.Purikura.transform.localScale = LuaGeometry.GetTempVector3(0, 0, 0)
  end
  if self.npcModel then
    self.npcModel:SetActive(false)
  end
  TimeTickManager.Me():ClearTick(self)
  self:UnregisterHotKeyTip()
end

function DialogCell:SetModel(modeltype, dialogData)
  if not self.npcModelTexture then
    return
  end
  local staticid = dialogData.Speaker
  if self.lastSpeaker ~= staticid then
    self.lastSpeaker = staticid
    self.npcModelTexture.mainTexture = nil
    UIModelUtil.Instance:ClearModel(self.npcModelTexture)
  end
  local mconfig
  if modeltype == ModelType.Monster then
    mconfig = Table_Monster[staticid]
    UIModelUtil.Instance:SetMonsterModelTexture(self.npcModelTexture, staticid, nil, nil, function(obj)
      self:SetModelCallBack(dialogData, mconfig, obj)
    end)
  else
    mconfig = Table_Npc[staticid]
    UIModelUtil.Instance:SetNpcModelTexture(self.npcModelTexture, staticid, nil, function(obj)
      self:SetModelCallBack(dialogData, mconfig, obj)
    end)
  end
end

function DialogCell:SetModelCallBack(dialogData, mconfig, obj)
  self.model = obj
  self.model:RegisterWeakObserver(self)
  UIModelUtil.Instance:SetCellTransparent(self.npcModelTexture)
  local showPos = mconfig and mconfig.ModelPose
  if showPos and #showPos == 3 then
    self.model:SetPosition(LuaGeometry.GetTempVector3(showPos[1], showPos[2], showPos[3]))
  end
  if mconfig.ModelRotate then
    self.model:SetEulerAngleY(mconfig.ModelRotate)
  end
  if dialogData.ModelAct then
    local actionName = Table_ActionAnime[dialogData.ModelAct] and Table_ActionAnime[dialogData.ModelAct].Name
    local params = Asset_Role.GetPlayActionParams(actionName)
    if params then
      params[5] = dialogData.ActType and dialogData.ActType == 1 or false
      self.model:PlayAction(params)
    end
  end
  self.model:SetScale(mconfig.ModelSize or 1)
  if dialogData.ModelFace then
    self.model:SetExpression(dialogData.ModelFace, true)
  end
  self.npcModel:SetActive(true)
end

function DialogCell:ObserverDestroyed(obj)
  if obj == self.model then
    self.model = nil
  end
end

function DialogCell:SetPlotPic(picPath)
  if not self.plotpic then
    return
  end
  if picPath ~= self.picPath then
    self.picPath = picPath
  end
  if self.picPath then
    PictureManager.Instance:SetPlotPic(self.picPath, self.plotpic)
    PictureManager.Instance:SetUI("renwudian_zuizhong_bg1", self.plotBG1)
    PictureManager.Instance:SetUI("renwudian_zuizhong_bg2", self.plotBG2)
    self.plotContainer:SetActive(true)
  end
end

function DialogCell:UnLoadPlotPic()
  if not self.plotpic then
    return
  end
  if self.plotpic.mainTexture then
    PictureManager.Instance:UnLoadPlotPic(self.plotpic)
    PictureManager.Instance:UnLoadUI("renwudian_zuizhong_bg1", self.plotBG1)
    PictureManager.Instance:UnLoadUI("renwudian_zuizhong_bg2", self.plotBG2)
    self.plotpic.mainTexture = nil
    self.plotBG1.mainTexture = nil
    self.plotBG2.mainTexture = nil
    self.plotContainer:SetActive(false)
  end
end

function DialogCell:CheckKapraName()
  local myPos = Game.Myself:GetPosition()
  local target = NSceneNpcProxy.Instance:FindNpcInRange(myPos, 5, self.CheckKapraNpc)
  if not target then
    return 0
  end
  return target.data.staticData.id
end

function DialogCell.CheckKapraNpc(target)
  if target then
    local npcId = target.data.staticData.id
    local npcData = Table_Npc[npcId]
    if not npcData then
      return false
    end
    local npcFunc = npcData.NpcFunction
    if 0 < #npcFunc then
      for i = 1, #npcFunc do
        local type = npcFunc[i].type
        local npcFuncData = Table_NpcFunction[type]
        if npcFuncData and npcFuncData.NameEn == "DirectPassFunc" then
          return true
        end
      end
    end
  end
end

local tempItemDatas = {}

function DialogCell:SetItemDatas(items)
  if not items or #items == 0 then
    if self.itemCtrl then
      self.itemCtrl:ResetDatas(_EmptyTable)
      self.itemCtrl = nil
    end
    return
  end
  if not self.itemCtrl then
    local grid = self:FindComponent("ItemGrid", UIGrid)
    self.itemCtrl = UIGridListCtrl.new(grid, SimpleItemCell, "SimpleItemCell")
  end
  for i = 1, #items do
    local itemData = ItemData.new("DialogShow", items[i][1])
    itemData:SetItemNum(items[i][2] or 1)
    table.insert(tempItemDatas, itemData)
  end
  self.itemCtrl:ResetDatas(tempItemDatas)
  local cells = self.itemCtrl:GetCells()
  for i = 1, #cells do
    cells[i]:SetMinDepth(10)
  end
  TableUtility.ArrayClear(tempItemDatas)
end

function DialogCell:SetNpcVoiceBtnState(on)
  self.voiceBtn:SetActive(on)
  if on then
    TimeTickManager.Me():CreateTick(0, 500, function()
      if self.curVolumeSpNum < maxVolumeSpNum then
        local index = self.curVolumeSpNum + 1
        self["voiceVolume" .. index].alpha = 1
        self.curVolumeSpNum = index
      else
        for i = 1, maxVolumeSpNum do
          self["voiceVolume" .. i].alpha = 0
        end
        self.curVolumeSpNum = 0
      end
    end, self, 2)
  else
    TimeTickManager.Me():ClearTick(self, 2)
  end
end

function DialogCell:OnNpcVoiceBtnClick()
  local npcVolume = FunctionPerformanceSetting.Me().setting.plotVolume
  local bgmVolume = FunctionPerformanceSetting.Me().setting.bgmVolume
  local defaultNpcVolume = GameConfig.DefaultVolume and GameConfig.DefaultVolume.NPC
  defaultNpcVolume = defaultNpcVolume or 0.7
  local defaultBgmVolume = GameConfig.DefaultVolume and GameConfig.DefaultVolume.BGM
  defaultBgmVolume = defaultBgmVolume or 0.7
  if npcVolume >= defaultNpcVolume and bgmVolume >= defaultBgmVolume then
    MsgManager.ShowMsgByID(42122)
  else
    MsgManager.ConfirmMsgByID(42123, function()
      local setting = FunctionPerformanceSetting.Me()
      setting:SetBgmVolume(defaultBgmVolume)
      setting:SetPlotVolume(defaultNpcVolume)
      setting:SetEnd()
    end)
  end
end

function DialogCell:RegisterHotKeyTip()
  if not self.continueSp then
    return
  end
  Game.HotKeyTipManager:RegisterHotKeyTip(5, self.continueSp, NGUIUtil.AnchorSide.TopLeft)
end

function DialogCell:UnregisterHotKeyTip()
  if not self.continueSp then
    return
  end
  Game.HotKeyTipManager:RemoveHotKeyTip(5, self.continueSp)
end
