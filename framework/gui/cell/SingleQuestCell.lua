local baseCell = autoImport("BaseCell")
SingleQuestCell = class("SingleQuestCell", baseCell)
local tempVector3 = LuaVector3.zero
local getlocalPos = LuaGameObject.GetLocalPosition
local calSize = NGUIMath.CalculateRelativeWidgetBounds
local isNil = LuaGameObject.ObjectIsNull

function SingleQuestCell:Init()
  self:initView()
end

function SingleQuestCell:initView()
  self.root = self:FindGO("Root")
  self.mainPart = self:FindGO("GameObject")
  self.content = self:FindGO("Content")
  self.contentTable = self:FindComponent("Content", UITable)
  self.titleIcon = self:FindGO("TitleIcon")
  if self.titleIcon then
    self.titleIcon_UISprite = self.titleIcon:GetComponent(UISprite)
  end
  local titleScrol = self:FindGO("titleScrol")
  self.title = self:FindComponent("Title", UILabel, titleScrol)
  self.titleTrans = self.title.gameObject.transform
  self.titleTween = self.title.gameObject:GetComponent(TweenPosition)
  self.titleWidth = self.title.width
  self.titleOverflow = self.title.overflowMethod
  if self.titleTween == nil then
    self.titleTween = self.title.gameObject:AddComponent(TweenPosition)
    self.titleTween.enabled = false
  end
  self.titleMaxWidth = 166
  local cnTitle = self:FindComponent("CNTitle", UILabel)
  cnTitle.gameObject:SetActive(false)
  self.desc = self:FindComponent("Desc", UIRichLabel)
  self.desc = SpriteLabel.new(self.desc, nil, 20, 20)
  self.icon = self:FindComponent("Icon", UISprite)
  self.iconTrans = self.icon.transform
  self.iconObj = self.icon.gameObject
  self.bgSprite = self:FindComponent("bg", UISprite)
  self.bgShadow = self:FindComponent("taskQuestBG", UISprite)
  self.disLabel = self:FindComponent("currentDisLb", UILabel)
  self.disObj = self.disLabel.gameObject
  self.disObjTrans = self.disObj.transform
  self.richObjTrans = self.desc.richLabel.gameObject.transform
  self.noneTip = self:FindGO("NoneQuestTrace")
  self:SetEvent(self.root, function()
    self:PassEvent(QuestEvent.QuestTraceShowList, self)
  end)
  self.manualTraceBtn = self:FindGO("ManualTraceBtn")
  self.manualTraceRotateSelf = self.manualTraceBtn:GetComponent(RotateSelf)
  self.manualTraceRotateSelf.enabled = false
  self:AddClickEvent(self.manualTraceBtn, function()
    if self.data then
      FunctionQuest.Me():executeQuest(self.data)
    end
  end)
  self.effectHandler = self:FindGO("EffectHandler")
  if self.effectHandler then
    self:PlayUIEffect(EffectMap.UI.MainViewTrace_HighLight, self.effectHandler, false)
  end
end

function SingleQuestCell:SetData(data, lockTrace)
  if data == nil then
    return
  end
  self.mainPart:SetActive(true)
  self.noneTip:SetActive(false)
  self:OverSeaStopTweenLable()
  self.pureData = data
  if data.isCombined and data.groupid then
    self.questList = data.questList
    table.sort(self.questList, TaskQuestCell.SortCombinedQuestList)
    local curTraceQuest = data.curTraceQuest or nil
    self.curChoose = self.questList[1]
    self.groupid = data.groupid
    if curTraceQuest then
      for i = 1, #self.questList do
        if self.questList[i].id == curTraceQuest and not self.questList[i].isFinish then
          self.curChoose = self.questList[i]
          break
        end
        for j = 1, #self.questList do
          if not self.questList[j].isFinish then
            self.curChoose = self.questList[j]
            break
          end
        end
      end
    end
    self.title.text = self.curChoose.traceTitle or ""
    xdlog("复合任务名字", self.title.text)
    if StringUtil.ChLength(self.title.text) > 18 then
      self.title.fontSize = 18
    else
      self.title.fontSize = 20
    end
    self:OverSeaTweenLable()
    self.data = self.curChoose
    self.titleBg = data.titleBg
    self.iconStr = data.icon
    if self.curChoose.staticData and self.curChoose.staticData.IconFromServer then
      self.IconFromServer = self.curChoose.staticData.IconFromServer
    end
    if self.curChoose.staticData and self.curChoose.staticData.ColorFromServer then
      self.ColorFromServer = self.curChoose.staticData.ColorFromServer
    end
    if self.curChoose.staticData and self.curChoose.staticData.headIcon then
      self.specialIcon = self.curChoose.staticData.headIcon
    end
    self:checkShowDisAndIcon(self.curChoose)
    self.thumbBgStr = self.curChoose.thumbBg
    self.thumbStr = self.curChoose.thumb
    self.type = self.curChoose.type
    self:initColor()
    self:ShowTaskIcon(self.specialIcon)
    self:ShowTitleColor()
    self:UpdateCombinedQuestTraceInfo()
    self:resetBgSize(true)
    return
  end
  local name = data.traceTitle or data.traceInfo or ""
  local desStr = data:parseTranceInfo()
  self:setIsOngoing(false)
  self:Show(self.iconObj)
  self:OverSeaTweenLable()
  self.title.text = name
  if not desStr or desStr == "" then
    desStr = ZhString.QuestManual_Acceptable
  end
  self.desc:SetText(desStr)
  self:checkShowDisAndIcon(data)
  self.data = data
  self.curTracingQuestId = self.data.id
  self.lockTrace = lockTrace or false
  self.isMainTrace = QuestProxy.Instance:checkMainQuestAutoExcute()
  if data.staticData and data.staticData.IconFromServer then
    self.IconFromServer = data.staticData.IconFromServer
  end
  if data.staticData and data.staticData.ColorFromServer then
    self.ColorFromServer = data.staticData.ColorFromServer
  end
  if data.staticData and data.staticData.headIcon then
    self.specialIcon = data.staticData.headIcon
  end
  self.type = data.type
  self:initColor()
  self:ShowTaskIcon(self.specialIcon)
  self:ShowTitleColor()
  self:resetBgSize()
  self:CheckCanManualExecute()
end

function SingleQuestCell:Update(teleData)
  local questId = teleData.questId
  local distance = teleData.distance
  local toMap = teleData.toMap
  if self.data and self.data.id ~= questId then
    FunctionQuestDisChecker.RemoveQuestCheck(questId)
    return
  end
  local disStr
  if distance then
    local str = ZhString.TaskQuestCell_Dis .. "M"
    disStr = string.format(str, tostring(distance))
  elseif toMap then
    disStr = string.format(ZhString.TaskQuestCell_Dis, tostring(toMap))
  else
    self:Hide(self.disObj)
    self:resetBgSize(true)
  end
  if disStr ~= "" then
    if not self.disObj.activeSelf then
      self:Show(self.disObj)
    end
    self.disLabel.text = disStr
    self:resetBgSize(true)
  end
end

function SingleQuestCell:OverSeaTweenLable()
  local tempText = self.title.text
  self.title.text = ""
  self.title.pivot = UIWidget.Pivot.Left
  self.title.overflowMethod = 2
  self.title.text = tempText
  LuaVector3.Better_Set(tempVector3, getlocalPos(self.titleTrans))
  self:StartTweenLable(self.title, self.titleMaxWidth, self.titleTween, tempVector3, 7, 1)
end

function SingleQuestCell:OverSeaStopTweenLable()
  self:StopTweenLable(self.titleTween)
  self.title.overflowMethod = self.titleOverflow
  self.title.width = self.titleWidth
end

function SingleQuestCell:StartTweenLable(lable, _maxWidth, tweenPosition, from, duration, style)
  if lable == nil or _maxWidth == nil or _maxWidth >= lable.width then
    return
  end
  tweenPosition.duration = duration
  tweenPosition.style = style
  tweenPosition.from = from
  tweenPosition.to = LuaGeometry.GetTempVector3(from.x - lable.width / 2, from.y, from.z)
  tweenPosition.enabled = true
  tweenPosition:ResetToBeginning()
  tweenPosition:PlayForward()
end

function SingleQuestCell:StopTweenLable(tweenPosition)
  if tweenPosition and tweenPosition.enabled == true then
    tweenPosition:ResetToBeginning()
    tweenPosition.enabled = false
  end
end

function SingleQuestCell:setIsOngoing(isOngoing)
  if self.isOngoing ~= isOngoing then
    self.isOngoing = isOngoing
    if isOngoing then
      self.title.color = Color(1, 0.7725490196078432, 0.0784313725490196, 1)
      self.manualTraceRotateSelf.enabled = true
    else
      self:ShowTitleColor()
      self.manualTraceRotateSelf.enabled = false
    end
  end
end

function SingleQuestCell:initColor()
  self.desc.richLabel.color = Color_Desc
  self.disLabel.color = Color_disLabel
end

function SingleQuestCell:checkShowDisAndIcon(data)
  if QuestProxy.Instance:checkIsShowDirAndDis(data) and data.type ~= QuestDataType.QuestDataType_DAHUANG then
    self:Hide(self.iconObj)
    local disStr = self:GetShowMap(data)
    if disStr then
      self:Show(self.disObj)
      self.disLabel.text = disStr
    else
      self:Hide(self.disObj)
    end
    self:resetBgSize(true)
    self.icon.width = 30
    self.icon.height = 27
  else
    if (data.type == QuestDataType.QuestDataType_INVADE or data.type == QuestDataType.QuestDataType_ACTIVITY_TRACEINFO) and data.icon then
      if self.iconStr ~= data.icon then
        self:Show(self.iconObj)
        self:SetMyIconByServer(data.icon)
        self.icon:MakePixelPerfect()
        local aspect = 35 / self.icon.width
        self.icon.width = aspect * self.icon.width
        self.icon.height = aspect * self.icon.height
      end
    else
      self:Hide(self.iconObj)
    end
    self:Hide(self.disObj)
    self:resetBgSize(false)
  end
end

function SingleQuestCell:GetShowMap(data)
  data = data or self.data
  local tarMap = data.map
  if not tarMap then
    return nil
  end
  local mapData = Table_Map[tarMap]
  local toMap = "..."
  if mapData then
    toMap = mapData.CallZh
  end
  local disStr = string.format(ZhString.TaskQuestCell_Dis, tostring(toMap))
  return disStr
end

function SingleQuestCell:resetBgSize(showDistance)
  self.bgSizeChanged = false
  if not self.disLabel then
    return
  end
  if not self.disObj then
    return
  end
  tempVector3:Set(getlocalPos(self.disObjTrans))
  local _, y, _ = getlocalPos(self.richObjTrans)
  local deshg = self.desc.richLabel.height
  y = y - deshg - 14
  tempVector3:Set(tempVector3.x, y, tempVector3.z)
  self.disObjTrans.localPosition = tempVector3
  local height = calSize(self.content.transform)
  height = height.size.y
  height = height + 4
  local originHeight = self.bgSprite.height
  if math.abs(originHeight - height) > 2 then
    self.bgSizeChanged = true
    if self.slWidget then
      self.slWidget:ResetAndUpdateAnchors()
    end
  end
  self.bgSprite.height = height
  height = height + 8
end

function SingleQuestCell:CheckCanManualExecute()
  if not self.data then
    self.manualTraceBtn:SetActive(false)
  end
  local canAutoExcute = QuestProxy.Instance:checkMainQuestAutoExcute(self.data)
  self.manualTraceBtn:SetActive(canAutoExcute)
end

function SingleQuestCell:SetNoneStatus()
  if self.data then
    FunctionQuestDisChecker.RemoveQuestCheck(self.data.id)
  end
  self.data = nil
  self.lockTrace = false
  self.mainPart:SetActive(false)
  self.noneTip:SetActive(true)
  self.bgShadow.height = 114
end

function SingleQuestCell:ShowTaskIcon(specialIcon)
  if self.IconFromServer and self.IconFromServer ~= 0 and GameConfig.Quest.TraceIcon then
    local tempIconNum
    if specialIcon and specialIcon ~= 0 and GameConfig.Quest.TraceIcon[specialIcon] ~= nil then
      tempIconNum = specialIcon
    else
      tempIconNum = self.IconFromServer
    end
    if GameConfig.Quest.TraceIcon[tempIconNum] then
      local atlasStr = GameConfig.Quest.TraceIcon[tempIconNum][2]
      local spriteNameStr = GameConfig.Quest.TraceIcon[tempIconNum][1]
      local iconScale = GameConfig.Quest.TraceIcon[tempIconNum][3]
      local needMakePixelPerfect = GameConfig.Quest.TraceIcon[tempIconNum][4]
      if atlasStr and spriteNameStr then
        if IconManager:SetIconByType(spriteNameStr, self.titleIcon_UISprite, atlasStr) then
          self.titleIcon:SetActive(true)
          if needMakePixelPerfect then
            self.titleIcon_UISprite:MakePixelPerfect()
          end
          if iconScale then
            self.TitleIcon.gameObject.transform.localScale = Vector3(iconScale, iconScale, iconScale)
          elseif GameConfig and GameConfig.Quest and GameConfig.Quest.TitleIconScale then
            self.TitleIcon.gameObject.transform.localScale = Vector3(GameConfig.Quest.TitleIconScale, GameConfig.Quest.TitleIconScale, GameConfig.Quest.TitleIconScale)
          end
          return
        end
        local ui1Atlas = RO.AtlasMap.GetAtlas(atlasStr)
        if ui1Atlas == nil then
          helplog("请任务追踪框策划确认 没有图集！" .. atlasStr)
          return
        end
        self.titleIcon_UISprite.atlas = ui1Atlas
        self.titleIcon_UISprite.spriteName = spriteNameStr
        self.titleIcon:SetActive(true)
        if needMakePixelPerfect then
          self.titleIcon_UISprite:MakePixelPerfect()
        end
        if iconScale then
          self.titleIcon.gameObject.transform.localScale = Vector3(iconScale, iconScale, iconScale)
        elseif GameConfig and GameConfig.Quest and GameConfig.Quest.TitleIconScale then
          self.titleIcon.gameObject.transform.localScale = Vector3(GameConfig.Quest.TitleIconScale, GameConfig.Quest.TitleIconScale, GameConfig.Quest.TitleIconScale)
        end
        return
      else
        helplog("防御:请任务追踪框策划检查配置表:配置表GameConfig.Quest.TraceIcon出错:self.IconFromServer:" .. self.IconFromServer)
      end
    else
      helplog("防御:请任务追踪框策划检查配置表:配置表GameConfig.Quest.TraceIcon出错:self.IconFromServer:" .. self.IconFromServer)
    end
  end
  self.titleIcon:SetActive(false)
end

function SingleQuestCell:ShowTitleColor()
  if self.ColorFromServer and self.ColorFromServer ~= 0 then
    if TaskQuestCell.TitleColor[self.ColorFromServer] then
      if TaskQuestCell.TitleColor[self.ColorFromServer][1] then
        self.title.color = TaskQuestCell.TitleColor[self.ColorFromServer][1]
      else
        self.title.color = LuaColor.white
      end
      if TaskQuestCell.TitleColor[self.ColorFromServer][2] then
        self.title.effectColor = TaskQuestCell.TitleColor[self.ColorFromServer][2]
      else
        self.title.effectColor = LuaColor.New(0.2549019607843137, 0.2549019607843137, 0.2549019607843137)
      end
    else
      self.title.color = LuaColor.white
      self.title.effectColor = LuaColor.New(0.2549019607843137, 0.2549019607843137, 0.2549019607843137)
    end
  else
    self.title.color = LuaColor.white
    self.title.effectColor = LuaColor.New(0.2549019607843137, 0.2549019607843137, 0.2549019607843137)
  end
end

function SingleQuestCell:ShowChooseEffect(bool)
  self.effectHandler:SetActive(bool)
end

function SingleQuestCell:SwitchTracedQuestInCombinedGroup()
  for i = 1, #self.questList do
    if self.curChoose.id == self.questList[i].id then
      for j = i, #self.questList do
        if self.questList[j + 1] and not self.questList[j + 1].isFinish then
          self.curChoose = self.questList[j + 1]
          self.data = self.curChoose
          self.title.text = self.curChoose.traceTitle
          self:UpdateCombinedQuestTraceInfo()
          return
        end
      end
      for k = 1, #self.questList do
        if not self.questList[k].isFinish and self.questList[k].id ~= self.curChoose.id then
          self.curChoose = self.questList[k]
          break
        end
      end
      self.data = self.curChoose
      self.title.text = self.curChoose.traceTitle
      self:UpdateCombinedQuestTraceInfo()
      break
    end
  end
end

function SingleQuestCell:UpdateCombinedQuestTraceInfo()
  local desStr = ""
  for i = 1, #self.questList do
    local single = self.questList[i]
    local traceInfo = single:parseTranceInfo()
    if not single.isFinish then
      if single.id == self.curChoose.id then
        desStr = desStr .. "{taskuiicon=icon_39}" .. "[c][00FFFF]" .. traceInfo .. "[-][/c]"
      else
        desStr = desStr .. "{taskuiicon=tips_icon_01}" .. traceInfo
      end
    else
      local finishTraceInfo = OverSea.LangManager.Instance():GetLangByKey(Table_FinishTraceInfo[single.id].FinishTraceInfo)
      desStr = desStr .. "{taskuiicon=pet_icon_finish}" .. "[c][6D6D6D]" .. finishTraceInfo .. "[-][/c]"
    end
    if i < #self.questList then
      desStr = desStr .. "\n"
    end
  end
  desStr = desStr or ""
  self.desc:SetText(desStr)
end
