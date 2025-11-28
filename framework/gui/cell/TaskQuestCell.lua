local baseCell = autoImport("BaseCell")
autoImport("QuestData")
autoImport("TaskQuestCell_Special")
TaskQuestCell = class("TaskQuestCell", baseCell)
TaskQuestCell.FilterQuestStepType = {
  QuestDataStepType.QuestDataStepType_VISIT,
  QuestDataStepType.QuestDataStepType_KILL,
  QuestDataStepType.QuestDataStepType_COLLECT,
  QuestDataStepType.QuestDataStepType_USE,
  QuestDataStepType.QuestDataStepType_GATHER,
  QuestDataStepType.QuestDataStepType_MOVE,
  QuestDataStepType.QuestDataStepType_SELFIE
}
local tempVector3 = LuaVector3.Zero()
local getlocalPos = LuaGameObject.GetLocalPosition
local calSize = NGUIMath.CalculateRelativeWidgetBounds
local isNil = LuaGameObject.ObjectIsNull
Color_disLabel = LuaColor(0.42745098039215684, 0.8, 1.0, 1)
Color_Desc = LuaColor(0.8784313725490196, 0.8784313725490196, 0.8784313725490196, 1)
TaskQuestCell.TraceBackgroundColor = {
  [6] = LuaColor(0.6980392156862745, 0.03529411764705882, 0 / 255.0, 0.6),
  [5] = LuaColor(0 / 255.0, 0.2549019607843137, 0.6980392156862745, 0.6),
  [1] = LuaColor(0.6980392156862745, 0.03529411764705882, 0 / 255.0, 0.6),
  [2] = LuaColor(0.21176470588235294, 0.5058823529411764, 0.6980392156862745, 0.6),
  [4] = LuaColor(0.6431372549019608, 0.21176470588235294, 0.6980392156862745, 0.6),
  [3] = LuaColor(0.21176470588235294, 0.6980392156862745, 0.24313725490196078, 0.6),
  [7] = LuaColor(1, 0.8117647058823529, 0.050980392156862744, 0.6),
  [999] = LuaColor(1, 1, 1, 0.6)
}
TaskQuestCell.TitleColor = {
  [1] = {
    LuaColor.New(1, 0.9450980392156862, 0.5137254901960784),
    nil
  },
  [4] = {
    LuaColor.New(0.8431372549019608, 0.611764705882353, 1),
    nil
  },
  [5] = {
    nil,
    LuaColor.New(0.6235294117647059, 0.14901960784313725, 0.2823529411764706)
  },
  [6] = {
    LuaColor.New(1, 0.3764705882352941, 0.15294117647058825),
    nil
  },
  [7] = {
    LuaColor.New(1, 0.9529411764705882, 0.4823529411764706),
    nil
  }
}

function TaskQuestCell:Init()
  self:initView()
  self:initData()
  self:initColor()
end

function TaskQuestCell:initData()
  self.questType = -1
  self.isSelected = true
  self.bgSizeChanged = false
  self:setIsSelected(false)
  self:setIsOngoing(false)
  self.type = nil
  self.titleBg = nil
  self.iconStr = nil
  self.thumbBgStr = nil
  self.thumbStr = nil
  self.isTitleIconShow = true
  self.isIconObjShow = false
  self.isChooseSymbolShow = false
  self.prevDesc = ""
end

function TaskQuestCell:AddLongPress()
  local long = self.bgSprite.gameObject:GetComponent(UILongPress)
  if long then
    function long.pressEvent(obj, isPress)
      if not self.data or self.data.type == QuestDataType.QuestDataType_SEALTR or self.data.type == QuestDataType.QuestDataType_ITEMTR or self.data.type == QuestDataType.QuestDataType_HelpTeamQuest or self.data.type == QuestDataType.QuestDataType_INVADE or self.data.type == QuestDataType.QuestDataType_ACTIVITY_TRACEINFO or self.data.type == QuestDataType.QuestDataType_DAHUANG then
        return
      end
      if isPress then
        TipsView.Me():ShowStickTip(QuestDetailTip, self.data, NGUIUtil.AnchorSide.TopLeft, self.bgSprite, {0, 0})
      else
        TipsView.Me():HideTip(QuestDetailTip)
      end
    end
  end
end

function TaskQuestCell:initColor()
  self.desc.richLabel.color = Color_Desc
  self.disLabel.color = Color_disLabel
end

function TaskQuestCell:ChangeScale()
  if GameConfig and GameConfig.Quest and GameConfig.Quest.CircleScale then
    self.icon.transform.localScale = LuaGeometry.GetTempVector3(GameConfig.Quest.CircleScale, GameConfig.Quest.CircleScale, GameConfig.Quest.CircleScale)
  end
end

function TaskQuestCell:initView()
  self.progress = self:FindGO("progress")
  if self.progress then
    self.slWidget = self.progress:GetComponent(UIWidget)
    self.progress = self.progress:GetComponent(UISlider)
    self.thumb = self:FindComponent("thumb", UISprite)
    self.thumbObj = self.thumb.gameObject
    self.thumbCt = self:FindGO("thumbCt")
    self.thumbCtObj = self.thumbCt.gameObject
    self.thumbBg = self:FindComponent("bg", UISprite, self.thumbCt)
    self.thumbBgObj = self.thumbBg.gameObject
    self.foreBg = self:FindComponent("forebg", UISprite, self.progress.gameObject)
    self.progressBg = self:FindComponent("bg", UISprite, self.progress.gameObject)
  end
  self.titleBgCt = self:FindGO("titleBgCt")
  self.content = self:FindGO("content")
  self.TitleCt = self:FindGO("TitleCt", self.content)
  self.TitleIcon = self:FindGO("TitleIcon")
  if self.TitleIcon then
    self.TitleIcon_UISprite = self.TitleIcon:GetComponent(UISprite)
  end
  local titlePanel = self:FindComponent("titleScrol", UIPanel)
  local upPanel = UIUtil.GetComponentInParents(self.gameObject, UIPanel)
  if upPanel and titlePanel then
    titlePanel.depth = upPanel.depth + 1
  end
  local titleScrol = self:FindGO("titleScrol")
  if not BranchMgr:IsChina() then
    self.title = self:FindComponent("Title", UILabel, titleScrol)
    self.titleTrans = self.title.gameObject.transform
    self.titleTween = self.title.gameObject:GetComponent(TweenPosition)
    self.titleWidth = self.title.width
    self.titleOverflow = self.title.overflowMethod
    if self.titleTween == nil then
      self.titleTween = self.title.gameObject:AddComponent(TweenPosition)
      self.titleTween.enabled = false
    end
    self.titleMaxWidth = titlePanel.width
  else
    self.title = self:FindComponent("CNTitle", UILabel)
    self.titleTrans = self.title.gameObject.transform
  end
  self.desc = self:FindComponent("Desc", UIRichLabel)
  self.desc = SpriteLabel.new(self.desc, nil, 20, 20)
  self.icon = self:FindComponent("Icon", UISprite)
  self.iconTrans = self.icon.transform
  self.iconObj = self.icon.gameObject
  self:ChangeScale()
  self.bgSprite = self:FindComponent("bg", UISprite)
  self.disLabel = self:FindComponent("currentDisLb", UILabel)
  self.mainQuestSymbol = self:FindGO("mainQuestSymbol")
  local click = function(obj)
    self:PassEvent(MouseEvent.MouseClick, self)
  end
  self:SetEvent(self.bgSprite.gameObject, click)
  self:AddDoubleClickEvent(self.bgSprite.gameObject, function(obj)
    self:PassEvent(MouseEvent.DoubleClick, self)
  end)
  self.animSp = self:FindComponent("ShowAnimSp", UISprite)
  self.closeTrace = self:FindGO("CloseTrace")
  
  function click(obj)
    if self.data then
      if self.data.type == QuestDataType.QuestDataType_ITEMTR then
        self:sendNotification(MainViewEvent.CancelItemTrace, {
          self.data.id
        })
      elseif self.data.type == QuestDataType.QuestDataType_HelpTeamQuest then
        self:sendNotification(QuestEvent.RemoveHelpQuest, {
          self.data.id
        })
      else
        QuestProxy.Instance:RemoveTraceCell(self.data.type, self.data.id)
      end
    end
  end
  
  if self.closeTrace then
    self:SetEvent(self.closeTrace, click)
  end
  self.selectorSp = self:FindGO("selector"):GetComponent(UISprite)
  self:AddPressEvent(self.bgSprite.gameObject, press)
  local objLua = self.gameObject:GetComponent(GameObjectForLua)
  if objLua then
    function objLua.onEnable()
      if QuestProxy.Instance:checkIsShowDirAndDis(self.data) then
        self:resetBgSize(true)
      else
        self:resetBgSize(false)
      end
    end
  end
  self.disObj = self.disLabel.gameObject
  self.disObjTrans = self.disObj.transform
  self.richObjTrans = self.desc.richLabel.gameObject.transform
  self.progressObj = self.progress.gameObject
  self.traceNewVer = false
  if not self.traceNewVer then
    self:AddLongPress()
  end
  self.effectContainer = self:FindGO("TitleEffectContainer")
  self.chooseSymbol = self:FindGO("ChooseSymbol")
  self:SetQuestTraceSymbol(false)
  self.container = self:FindGO("Container")
  self.widget = self:FindGO("Widget"):GetComponent(UIWidget)
  self.newTag = self:FindGO("NewTag")
end

function TaskQuestCell:setIsSelected(isSelected)
  if self.isSelected ~= isSelected then
    self.isSelected = isSelected
    if isSelected then
    else
    end
  end
end

function TaskQuestCell:ShowAnimSp()
  if self.animSp then
    self:Show(self.animSp.gameObject)
  end
end

function TaskQuestCell:HideAnimSp()
  if self.animSp then
    self:Hide(self.animSp.gameObject)
  end
end

function TaskQuestCell:setISShowDir(value)
  self.isShowDir = value
  if not self.data then
    return
  end
  if value then
    if self.data.type ~= QuestDataType.QuestDataType_DAHUANG then
      self:SetQuestTraceSymbol(true)
    end
    if self.data.type == QuestDataType.QuestDataType_HelpTeamQuest then
      self:SetMyIconByServer("Rewardtask_icon_team")
    else
      self:SetMyIconByServer("icon_39")
    end
    self:ChangeScale()
  elseif self.data.type ~= QuestDataType.QuestDataType_ACTIVITY_TRACEINFO and self.data.type ~= QuestDataType.QuestDataType_DAHUANG then
    self:SetIconObj(false)
    self:SetQuestTraceSymbol(false)
    local disStr = self:GetShowMap()
    if disStr then
      if disStr ~= self.disLabelTemp then
        self:Show(self.disObj)
        self.disLabel.text = disStr
        self.disLabelTemp = disStr
      end
    else
      self:Hide(self.disObj)
    end
  end
end

function TaskQuestCell:GetIsShowDir()
  return self.isShowDir
end

function TaskQuestCell:GetShowMap(data)
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

function TaskQuestCell:checkShowDisAndIcon(data)
  if QuestProxy.Instance:checkIsShowDirAndDis(data) and data.type ~= QuestDataType.QuestDataType_DAHUANG then
    self:SetIconObj(false)
    self:SetQuestTraceSymbol(false)
    local disStr = self:GetShowMap(data)
    if disStr then
      self:Show(self.disObj)
      if self.disLabelTemp ~= disStr then
        self.disLabel.text = disStr
        self.disLabelTemp = disStr
      end
    else
      self:Hide(self.disObj)
    end
    self:resetBgSize(true)
    self.icon.width = 30
    self.icon.height = 27
  else
    if (data.type == QuestDataType.QuestDataType_INVADE or data.type == QuestDataType.QuestDataType_ACTIVITY_TRACEINFO) and data.icon then
      if self.iconStr ~= data.icon then
        self:SetIconObj(true)
        self:SetMyIconByServer(data.icon)
        self.icon:MakePixelPerfect()
        local aspect = 35 / self.icon.width
        self.icon.width = aspect * self.icon.width
        self.icon.height = aspect * self.icon.height
      end
    else
      self:SetIconObj(false)
      self:SetQuestTraceSymbol(false)
    end
    self:Hide(self.disObj)
    self:resetBgSize(false)
  end
end

function TaskQuestCell:setIsOngoing(isOngoing)
  if self.isOngoing ~= isOngoing then
    self.isOngoing = isOngoing
    if isOngoing then
      self.title.color = Color(1, 0.7725490196078432, 0.0784313725490196, 1)
    else
      self:ShowTitleColor()
    end
  end
end

function TaskQuestCell:AdjustRelatedComp(data)
  if data.type ~= QuestDataType.QuestDataType_ACTIVITY_TRACEINFO and data.type ~= QuestDataType.QuestDataType_DAHUANG and (self.type ~= data.type or not self.groupid) then
    local name = data.traceTitle
    local desStr = data:parseTranceInfo()
    self.title.pivot = UIWidget.Pivot.Left
    LuaVector3.Better_Set(tempVector3, getlocalPos(self.titleTrans))
    tempVector3[1] = 41.5
    self.titleTrans.localPosition = tempVector3
    LuaVector3.Better_Set(tempVector3, getlocalPos(self.iconTrans.transform))
    tempVector3[1] = 22
    self.iconTrans.localPosition = tempVector3
    LuaVector3.Better_Set(tempVector3, getlocalPos(self.richObjTrans))
    tempVector3[1] = 45.6
    self.richObjTrans.localPosition = tempVector3
    self.desc.richLabel.width = 154
    self:Hide(self.titleBgCt.gameObject)
  end
  if self.progress and data.type ~= QuestDataType.QuestDataType_ACTIVITY_TRACEINFO and data.type ~= QuestDataType.QuestDataType_INVADE and self.type ~= data.type then
    self:Hide(self.progress.gameObject)
    self:Hide(self.thumbCtObj)
  end
  if self.closeTrace then
    if data.type ~= QuestDataType.QuestDataType_HelpTeamQuest and data.type ~= QuestDataType.QuestDataType_ITEMTR then
      if self.type ~= data.type then
        self:Hide(self.closeTrace)
      end
    elseif self.type ~= data.type then
      self:Show(self.closeTrace)
    end
  end
end

function TaskQuestCell.SortCombinedQuestList(a, b)
  if a.id ~= b.id then
    return a.id < b.id
  end
end

function TaskQuestCell:SetData(data)
  if data == nil then
    return
  end
  self:OverSeaStopTweenLable()
  self.emptyCell = data.emptyCell
  if not data.emptyCell then
    if not self.container.activeSelf then
      self.container:SetActive(true)
    end
    if self.widget.gameObject.activeSelf then
      self.widget.gameObject:SetActive(false)
    end
  else
    if self.container.activeSelf then
      self.container:SetActive(false)
    end
    if not self.widget.gameObject.activeSelf then
      self.widget.gameObject:SetActive(true)
    end
    return
  end
  self.IconFromServer = nil
  self.ColorFromServer = nil
  self.specialIcon = nil
  self.groupid = nil
  self.questData = data
  self.nInvadeStyle = nil
  self.nInvadeItemId = nil
  self.nInvadeFinishTraceList = nil
  self.titleBg = nil
  self.iconStr = nil
  self.questList = nil
  if data.isCombined and data.groupid then
    self.nInvadeStyle = data.nInvadeStyle
    self.nInvadeItemId = data.nInvadeStyle and data.nInvadeStyle.LimitItem[1]
    self.nInvadeFinishTraceList = data.nInvadeFinishTraceList
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
    if data.nInvadeStyle then
      if not self.specialCell then
        self.specialCell = TaskQuestCell_Special.new(self.gameObject)
      end
      self.specialCell:SetData(data.nInvadeStyle)
      self:UpdateInvadeProgress()
    else
      if self.specialCell then
        self.specialCell:DestroySelf()
        self.specialCell = nil
      end
      if StringUtil.ChLength(self.title.text) > 18 then
        self.title.fontSize = 18
      else
        self.title.fontSize = 20
      end
    end
    self:SetTitleText(self.curChoose.traceTitle or "")
    self:UpdateCombinedTrace()
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
    if not self.specialIcon and self.curChoose.staticData and self.curChoose.staticData.headIcon then
      self.specialIcon = self.curChoose.staticData.headIcon
    end
    self:checkShowDisAndIcon(self.curChoose)
    self.thumbBgStr = self.curChoose.thumbBg
    self.thumbStr = self.curChoose.thumb
    self.type = self.curChoose.type
    self:initColor()
    self:SeperateQuestDataType(self.curChoose.type)
    self:ShowTaskIcon(self.specialIcon)
    self:UpdateCombinedQuestTraceInfo()
    self:resetBgSize(true)
    self:RegisterGuide()
    return
  elseif self.specialCell then
    self.specialCell:DestroySelf()
    self.specialCell = nil
  end
  local name = data.traceTitle or data.traceInfo or ""
  local desStr = data:parseTranceInfo()
  self:AdjustRelatedComp(data)
  self:setIsOngoing(false)
  local disY = 0
  local distPos = 0
  if data.type == QuestDataType.QuestDataType_DAILY then
    local dailyData = QuestProxy.Instance:getDailyQuestData(SceneQuest_pb.EOTHERDATA_DAILY)
    local ratio = "0%"
    local exp = "0"
    if dailyData then
      ratio = dailyData.param4 * 100
      ratio = ratio .. "%"
      exp = dailyData.param3
    end
    name = string.format(name, ratio)
    desStr = string.format(desStr, exp)
  elseif data.type == QuestDataType.QuestDataType_ACTIVITY_TRACEINFO then
    self:UpActivityTraceView(data)
  elseif data.type == QuestDataType.QuestDataType_INVADE then
    self:UpInvadeTraceView(data)
  elseif data.type == QuestDataType.QuestDataType_DAHUANG then
    self:UpDahuangTraceView(data)
  end
  if self.mainQuestSymbol and data.type == QuestDataType.QuestDataType_MAIN and MyselfProxy.Instance:RoleLevel() >= 80 then
    self:Show(self.mainQuestSymbol)
  else
    self:Hide(self.mainQuestSymbol)
  end
  self:SetIconObj(true)
  self:SetTitleText(name)
  if StringUtil.ChLength(name) > 18 then
    self.title.fontSize = 18
  else
    self.title.fontSize = 20
  end
  if BranchMgr.IsChina() then
    UIUtil.WrapLabel(self.title)
  else
    self:OverSeaTweenLable()
  end
  desStr = desStr or ""
  if self.prevDesc ~= desStr then
    self.desc:SetText(desStr)
    self.prevDesc = desStr
  end
  self:checkShowDisAndIcon(data)
  self.data = data
  self.titleBg = data.titleBg
  self.iconStr = data.icon
  if data.staticData and data.staticData.IconFromServer then
    self.IconFromServer = data.staticData.IconFromServer
  end
  if data.staticData and data.staticData.ColorFromServer then
    self.ColorFromServer = data.staticData.ColorFromServer
  end
  if data.staticData and data.staticData.headIcon then
    self.specialIcon = data.staticData.headIcon
  end
  if data.questListType == SceneQuest_pb.EQUESTLIST_CANACCEPT and data.staticData and data.staticData.CreateTime and data.staticData.CreateTime ~= 0 then
    local myCreateTime = ClientTimeUtil.GetDailyRefreshTime()
    local leftDay, leftHour, leftMin, leftSec = ClientTimeUtil.GetFormatRefreshTimeStr(data.staticData.CreateTime + myCreateTime)
    if leftDay <= 0 then
      leftDay = 1
    end
    local desc = string.format(ZhString.QuestManual_TimeLimit, leftDay)
    self.prevDesc = desc
    self.desc:SetText(desc)
    self:Hide(self.disObj)
    self:resetBgSize(true)
  end
  self.thumbBgStr = data.thumbBg
  self.thumbStr = data.thumb
  self.type = data.type
  self:initColor()
  self:SeperateQuestDataType(data.type)
  self:ShowTaskIcon(self.specialIcon)
  self:ShowTitleColor()
  self:RegisterGuide()
end

function TaskQuestCell:OverSeaTweenLable()
  if BranchMgr.IsChina() then
    return
  end
  local tempText = self.title.text
  self.title.text = ""
  self.title.pivot = UIWidget.Pivot.Left
  self.title.overflowMethod = 2
  self.title.text = tempText
  LuaVector3.Better_Set(tempVector3, getlocalPos(self.titleTrans))
  self:StartTweenLable(self.title, self.titleMaxWidth, self.titleTween, tempVector3, 5, 1)
end

function TaskQuestCell:OverSeaStopTweenLable()
  if BranchMgr.IsChina() then
    return
  end
  self:StopTweenLable(self.titleTween)
  self.title.overflowMethod = self.titleOverflow
  self.title.width = self.titleWidth
end

function TaskQuestCell:SetTitleIcon(bool)
  if self.isTitleIconShow == bool then
    return
  end
  if bool then
    self:Show(self.TitleIcon)
  else
    self:Hide(self.TitleIcon)
  end
  self.isTitleIconShow = bool
end

function TaskQuestCell:SetIconObj(bool)
  if self.isIconObjShow == bool then
    return
  end
  if bool then
    self:Show(self.iconObj)
  else
    self:Hide(self.iconObj)
  end
  self.isIconObjShow = bool
end

function TaskQuestCell:SetTraceEffect(bool)
  if bool then
    if not self.traceEffect then
      self.traceEffect = self:PlayUIEffect(EffectMap.UI.MainTask_ui, self.effectContainer)
    end
  elseif self.traceEffect then
    self.traceEffect:Stop()
    self.traceEffect = nil
  end
end

function TaskQuestCell:SetQuestTraceSymbol(bool)
  if self.isChooseSymbolShow == bool then
    return
  end
  if bool then
    self:Show(self.chooseSymbol)
    self.selectorSp.color = Color(1, 1, 1, 1)
    Game.HotKeyTipManager:RegisterHotKeyTip(61, self.bgSprite, NGUIUtil.AnchorSide.TopLeft, {-27, -18})
  else
    self:Hide(self.chooseSymbol)
    self.selectorSp.color = Color(1, 1, 1, 0.00392156862745098)
    Game.HotKeyTipManager:RemoveHotKeyTip(61, self.bgSprite)
  end
  self.isChooseSymbolShow = bool
end

function TaskQuestCell:GetIconFromSever()
  return self.IconFromServer or 0
end

function TaskQuestCell:SetTitleText(text)
  if self.nInvadeFinishTraceList then
    self.title.text = ""
  else
    self.title.text = text
  end
end

function TaskQuestCell:ShowTaskIcon(specialIcon)
  local atlasStr, spriteNameStr, iconScale, needMakePixelPerfect
  if self.IconFromServer and self.IconFromServer ~= 0 and GameConfig.Quest.TraceIcon then
    local tempIconNum
    if specialIcon and specialIcon ~= 0 and GameConfig.Quest.TraceIcon[specialIcon] ~= nil then
      tempIconNum = specialIcon
    else
      tempIconNum = self.IconFromServer
    end
    if GameConfig.Quest.TraceIcon[tempIconNum] then
      iconScale = GameConfig.Quest.TraceIcon[tempIconNum][3]
      needMakePixelPerfect = GameConfig.Quest.TraceIcon[tempIconNum][4]
      atlasStr = GameConfig.Quest.TraceIcon[tempIconNum][2]
      spriteNameStr = GameConfig.Quest.TraceIcon[tempIconNum][1]
    else
      helplog("防御:请任务追踪框策划检查配置表:配置表GameConfig.Quest.TraceIcon出错:self.IconFromServer:" .. self.IconFromServer)
    end
  end
  if self.nInvadeItemId then
    iconScale = 0.7
    if IconManager:SetItemIcon(Table_Item[self.nInvadeItemId].Icon, self.TitleIcon_UISprite) then
      self:SetTitleIcon(true)
      if iconScale then
        self.TitleIcon.gameObject.transform.localScale = LuaGeometry.GetTempVector3(iconScale, iconScale, iconScale)
      elseif GameConfig and GameConfig.Quest and GameConfig.Quest.TitleIconScale then
        self.TitleIcon.gameObject.transform.localScale = LuaGeometry.GetTempVector3(GameConfig.Quest.TitleIconScale, GameConfig.Quest.TitleIconScale, GameConfig.Quest.TitleIconScale)
      end
      return
    end
  elseif atlasStr and spriteNameStr then
    if IconManager:SetIconByType(spriteNameStr, self.TitleIcon_UISprite, atlasStr) then
      self:SetTitleIcon(true)
      if needMakePixelPerfect then
        self.TitleIcon_UISprite:MakePixelPerfect()
      end
      if iconScale then
        self.TitleIcon.gameObject.transform.localScale = LuaGeometry.GetTempVector3(iconScale, iconScale, iconScale)
      elseif GameConfig and GameConfig.Quest and GameConfig.Quest.TitleIconScale then
        self.TitleIcon.gameObject.transform.localScale = LuaGeometry.GetTempVector3(GameConfig.Quest.TitleIconScale, GameConfig.Quest.TitleIconScale, GameConfig.Quest.TitleIconScale)
      end
      return
    end
    local ui1Atlas = RO.AtlasMap.GetAtlas(atlasStr)
    if ui1Atlas == nil then
      helplog("请任务追踪框策划确认 没有图集！" .. atlasStr)
      self:SetTitleIcon(false)
      return
    end
    self.TitleIcon_UISprite.atlas = ui1Atlas
    self.TitleIcon_UISprite.spriteName = spriteNameStr
    self:SetTitleIcon(true)
    if needMakePixelPerfect then
      self.TitleIcon_UISprite:MakePixelPerfect()
    end
    if iconScale then
      self.TitleIcon.gameObject.transform.localScale = LuaGeometry.GetTempVector3(iconScale, iconScale, iconScale)
    elseif GameConfig and GameConfig.Quest and GameConfig.Quest.TitleIconScale then
      self.TitleIcon.gameObject.transform.localScale = LuaGeometry.GetTempVector3(GameConfig.Quest.TitleIconScale, GameConfig.Quest.TitleIconScale, GameConfig.Quest.TitleIconScale)
    end
    return
  end
  self:SetTitleIcon(false)
end

function TaskQuestCell:ShowTaskBackGround(specialIcon)
  if self.ColorFromServer and self.ColorFromServer ~= 0 then
    local ui1Atlas = RO.AtlasMap.GetAtlas("NewUI5")
    if ui1Atlas then
      self.TitleBackground_UISprite.atlas = ui1Atlas
      local specialCellBG
      if specialIcon == 0 then
        specialIcon = self.ColorFromServer
      end
      if QuestSymbolConfig[specialIcon] then
        specialCellBG = QuestSymbolConfig[specialIcon].TaskquestcellBG
      end
      if specialIcon ~= 0 and specialCellBG ~= nil then
        local specialSprite = QuestSymbolConfig[specialIcon].TaskquestcellBG
        self.TitleBackground_UISprite.spriteName = specialSprite
        self.TitleBackground_UISprite.color = LuaGeometry.GetTempColor(1, 1, 1, 1)
      else
        self.TitleBackground_UISprite.spriteName = "main_task_bg2_00"
        if self.ColorFromServer ~= 0 and TaskQuestCell.TraceBackgroundColor[self.ColorFromServer] then
          self.TitleBackground_UISprite.color = TaskQuestCell.TraceBackgroundColor[self.ColorFromServer]
        else
          self.TitleBackground_UISprite.color = TaskQuestCell.TraceBackgroundColor[999]
        end
      end
      self:Show(self.TitleBackground)
      return
    else
      helplog("防御: NewUI5 没了")
    end
  end
  self:Hide(self.TitleBackground)
end

function TaskQuestCell:ShowTitleColor()
  if self.ColorFromServer and self.ColorFromServer ~= 0 then
    if TaskQuestCell.TitleColor[self.ColorFromServer] then
      if TaskQuestCell.TitleColor[self.ColorFromServer][1] then
        self.title.color = TaskQuestCell.TitleColor[self.ColorFromServer][1]
      else
        self.title.color = LuaGeometry.GetTempColor()
      end
      if TaskQuestCell.TitleColor[self.ColorFromServer][2] then
        self.title.effectColor = TaskQuestCell.TitleColor[self.ColorFromServer][2]
      else
        self.title.effectColor = LuaGeometry.GetTempColor(0.2549019607843137, 0.2549019607843137, 0.2549019607843137)
      end
    else
      self.title.color = LuaGeometry.GetTempColor()
      self.title.effectColor = LuaGeometry.GetTempColor(0.2549019607843137, 0.2549019607843137, 0.2549019607843137)
    end
  else
    self.title.color = LuaGeometry.GetTempColor()
    self.title.effectColor = LuaGeometry.GetTempColor(0.2549019607843137, 0.2549019607843137, 0.2549019607843137)
  end
end

function TaskQuestCell:SeperateQuestDataType(mType)
  self:Hide(self.mainQuestSymbol)
  local bShowTitleBgCt = false
  if mType == QuestDataType.QuestDataType_MAIN then
    bShowTitleBgCt = true
  elseif mType == QuestDataType.QuestDataType_BRANCH then
  elseif mType == QuestDataType.QuestDataType_DAILY then
  elseif mType == QuestDataType.QuestDataType_ACTIVITY_TRACEINFO then
    bShowTitleBgCt = true
  elseif mType == QuestDataType.QuestDataType_DAHUANG then
    bShowTitleBgCt = true
  end
  if bShowTitleBgCt then
    self:Hide(self.titleBgCt)
  else
  end
end

function TaskQuestCell:UpActivityTraceView(data)
  if data.type == QuestDataType.QuestDataType_ACTIVITY_TRACEINFO and (not self.data or self.data.type ~= data.type) then
    self.title.pivot = UIWidget.Pivot.Center
    LuaVector3.Better_Set(tempVector3, getlocalPos(self.titleTrans))
    tempVector3[1] = 118
    self.titleTrans.localPosition = tempVector3
    LuaVector3.Better_Set(tempVector3, getlocalPos(self.iconTrans))
    tempVector3[1] = 25
    self.iconTrans.localPosition = tempVector3
    LuaVector3.Better_Set(tempVector3, getlocalPos(self.richObjTrans))
    tempVector3[1] = 14
    self.richObjTrans.localPosition = tempVector3
    self.desc.richLabel.width = 185
  end
  if self.titleBgCt and data.titleBg and self.titleBg ~= data.titleBg then
    self:Show(self.titleBgCt)
  end
  if self.progress and data.process and not self.progressObj.activeSelf then
    self:Show(self.progress.gameObject)
    self:Show(self.thumbCt)
    if self.slWidget then
      self.slWidget:ResetAndUpdateAnchors()
    end
  end
  if not data.process and self.progressObj.activeSelf then
    self:Hide(self.progress.gameObject)
    self:Hide(self.thumbCt)
  end
  if self.progress and data.process then
    self.progress.value = data.process
    if data.thumb and data.thumb ~= "" or data.thumbBg and data.thumbBg ~= "" then
      if data.thumb then
        self:Show(self.thumbObj)
        if data.thumb ~= self.thumbStr then
          IconManager:SetUIIcon(data.thumb, self.thumb)
          self.thumb:MakePixelPerfect()
        end
      else
        self:Hide(self.thumbObj)
      end
      if data.thumbBg then
        self:Show(self.thumbBgObj)
        if data.thumbBg ~= self.thumbBgStr then
          IconManager:SetUIIcon(data.thumbBg, self.thumbBg)
          self.thumbBg:MakePixelPerfect()
        end
      else
        self:Hide(self.thumbBgObj)
      end
    else
      self:Hide(self.thumbCt)
    end
    if data.foreBg and data.foreBg ~= "" then
      self.foreBg.spriteName = data.foreBg
    end
    if data.progressBg and data.progressBg ~= "" then
      self.progressBg.spriteName = data.progressBg
    end
  end
end

function TaskQuestCell:UpInvadeTraceView(data)
  if self.progress and data.process and not self.progressObj.activeSelf then
    if self.slWidget then
      self.slWidget:ResetAndUpdateAnchors()
    end
    self:Show(self.progress.gameObject)
    self:Show(self.thumbCt)
  end
  if self.progress and data.process then
    self.progress.value = data.process
    if data.thumb then
      self:Show(self.thumbObj)
      if data.thumb ~= self.thumbStr then
        IconManager:SetUIIcon(data.thumb, self.thumb)
        self.thumb:MakePixelPerfect()
      end
    else
      self:Hide(self.thumbObj)
    end
    if data.thumbBg then
      self:Show(self.thumbBgObj)
      if data.thumbBg ~= self.thumbBgStr then
        IconManager:SetUIIcon(data.thumbBg, self.thumbBg)
        self.thumbBg:MakePixelPerfect()
      end
    else
      self:Hide(self.thumbBgObj)
    end
  end
end

function TaskQuestCell:UpDahuangTraceView(data)
  self.title.pivot = UIWidget.Pivot.Center
  LuaVector3.Better_Set(tempVector3, getlocalPos(self.titleTrans))
  tempVector3[1] = 118
  self.titleTrans.localPosition = tempVector3
  LuaVector3.Better_Set(tempVector3, getlocalPos(self.iconTrans))
  tempVector3[1] = 25
  self.iconTrans.localPosition = tempVector3
  LuaVector3.Better_Set(tempVector3, getlocalPos(self.richObjTrans))
  tempVector3[1] = 14
  self.richObjTrans.localPosition = tempVector3
  self.desc.richLabel.width = 185
  self:Hide(self.progress.gameObject)
  self:Hide(self.thumbCt)
end

function TaskQuestCell:resetBgSize(showDistance)
  self.bgSizeChanged = false
  if not self.disLabel then
    return
  end
  if not self.disObj then
    return
  end
  LuaVector3.Better_Set(tempVector3, getlocalPos(self.disObjTrans))
  local _, y, _ = getlocalPos(self.richObjTrans)
  local deshg = self.desc.richLabel.height
  y = y - deshg - 14
  tempVector3[2] = y
  self.disObjTrans.localPosition = tempVector3
  local x1, y1, z1 = getlocalPos(self.progressObj.transform)
  y1 = -64 - deshg
  LuaVector3.Better_Set(tempVector3, x1, y1, z1)
  self.progressObj.transform.localPosition = tempVector3
  local height = calSize(self.content.transform)
  height = height.size.y
  height = height + 4
  local originHeight = self.bgSprite.height
  if 2 < math.abs(originHeight - height) then
    self.bgSizeChanged = true
    if self.slWidget then
      self.slWidget:ResetAndUpdateAnchors()
    end
  end
  self.bgSprite.height = height
  height = height + 8
  self.selectorSp.height = height + 25
  self.animSp.height = height + 4
end

function TaskQuestCell:SetMyIconByServer(OriginName)
  IconManager:SetUIIcon(OriginName, self.icon)
end

function TaskQuestCell:Update(teleData)
  if not self.disLabel then
    return
  end
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
  if disStr ~= "" and disStr ~= self.disLabelTemp then
    if not self.disObj.activeSelf then
      self:Show(self.disObj)
    end
    self.disLabel.text = disStr
    self.disLabelTemp = disStr
    self:resetBgSize(true)
  end
end

function TaskQuestCell:OnExit()
  if self.data then
    FunctionQuestDisChecker.RemoveQuestCheck(self.data.id)
  end
  self.type = nil
  self.titleBg = nil
  self.iconStr = nil
  self.thumbBgStr = nil
  self.thumbStr = nil
  self.IconFromServer = nil
  self.ColorFromServer = nil
  TaskQuestCell.super.OnExit(self)
end

function TaskQuestCell:OnRemove()
end

function TaskQuestCell:SwitchTracedQuestInCombinedGroup()
  for i = 1, #self.questList do
    if self.curChoose.id == self.questList[i].id then
      for j = i, #self.questList do
        if self.questList[j + 1] and not self.questList[j + 1].isFinish then
          self.curChoose = self.questList[j + 1]
          self.data = self.curChoose
          self:SetTitleText(self.curChoose.traceTitle)
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
      self:SetTitleText(self.curChoose.traceTitle)
      self:UpdateCombinedQuestTraceInfo()
      break
    end
  end
end

function TaskQuestCell:UpdateCombinedQuestTraceInfo()
  local desStr = ""
  if self.nInvadeFinishTraceList then
    local style = self.nInvadeStyle
    for i = 1, #self.nInvadeFinishTraceList do
      local questId = self.nInvadeFinishTraceList[i].id
      local single
      for j = 1, #self.questList do
        if self.questList[j].id == questId then
          single = self.questList[j]
          break
        end
      end
      if not single then
        desStr = desStr .. style.NoAccept
      elseif not single.isFinish then
        local traceInfo = single:parseTranceInfo()
        if single.id == self.curChoose.id then
          desStr = desStr .. string.format(style.Choose, traceInfo)
        else
          desStr = desStr .. string.format(style.Accept, traceInfo)
        end
      else
        local finishTraceInfo = OverSea.LangManager.Instance():GetLangByKey(Table_FinishTraceInfo[single.id].FinishTraceInfo)
        desStr = desStr .. string.format(style.Finish, finishTraceInfo)
      end
      if i < #self.nInvadeFinishTraceList then
        desStr = desStr .. "\n"
      end
    end
  else
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
  end
  desStr = desStr or ""
  if self.prevDesc ~= desStr then
    self.desc:SetText(desStr)
    self.prevDesc = desStr
  end
end

function TaskQuestCell:UpdateCombinedTrace()
  self.title.pivot = UIWidget.Pivot.Center
  LuaVector3.Better_Set(tempVector3, getlocalPos(self.titleTrans))
  tempVector3[1] = 118
  self.titleTrans.localPosition = tempVector3
  LuaVector3.Better_Set(tempVector3, getlocalPos(self.iconTrans))
  tempVector3[1] = 22
  self.iconTrans.localPosition = tempVector3
  LuaVector3.Better_Set(tempVector3, getlocalPos(self.richObjTrans))
  tempVector3[1] = 14
  self.richObjTrans.localPosition = tempVector3
  self.desc.richLabel.width = 185
  if self.progress then
    self:Hide(self.progress.gameObject)
    self:Hide(self.thumbCtObj)
  end
  self:Hide(self.titleBgCt.gameObject)
end

function TaskQuestCell:SetCurrentChooseQuest(id)
  if self.questList and #self.questList > 0 then
    for i = 1, #self.questList do
      if self.questList[i].id == id and not self.questList[i].isFinish then
        self.curChoose = self.questList[i]
        break
      end
    end
  end
end

function TaskQuestCell:GetBgHeight()
  return self.bgSprite.height
end

function TaskQuestCell:ResizeWidget(delta)
  if self.widget and self.widget.height ~= delta then
    self.widget.height = delta
  end
end

function TaskQuestCell:RegisterGuide()
  self:AddOrRemoveGuideId(self.bgSprite.gameObject)
  if self.data and self.data.id == 210930001 then
    self:AddOrRemoveGuideId(self.bgSprite.gameObject, 514)
  end
  if self.data and self.data.id == 10001 then
    self:AddOrRemoveGuideId(self.bgSprite.gameObject, 450)
  end
end

function TaskQuestCell:UpdateInvadeProgress()
  if not self.nInvadeItemId then
    return
  end
  self:SetSpecialProgress(FunctionTempItem.Me():GetItemGainCount(self.nInvadeItemId))
end

function TaskQuestCell:SetSpecialProgress(val, maxVal)
  if not self.specialCell then
    return
  end
  self.specialCell:SetProgress(val, maxVal)
end

function TaskQuestCell:OnCellDestroy()
  TaskQuestCell.super.OnCellDestroy(self)
  if self.specialCell then
    self.specialCell:OnCellDestroy()
    self.specialCell = nil
  end
  Game.HotKeyTipManager:RemoveHotKeyTip(61, self.bgSprite)
end
