MusicGamePanel = class("MusicGamePanel", ContainerView)
MusicGamePanel.ViewType = UIViewType.NormalLayer
autoImport("MusicNoteCell")
local hideType = {hideClickSound = true, hideClickEffect = false}
local noteCellPath = ResourcePathHelper.UICell("MusicNoteCell")
local _Game = Game
local tempVector3 = LuaVector3.Zero()
local getlocalPos = LuaGameObject.GetLocalPosition
local soundList = {
  [1] = {
    SE = "Common/sfx_note_1",
    sound = "Do"
  },
  [2] = {
    SE = "Common/sfx_note_2",
    sound = "Re"
  },
  [3] = {
    SE = "Common/sfx_note_3",
    sound = "Mi"
  },
  [4] = {
    SE = "Common/sfx_note_4",
    sound = "Fa"
  },
  [5] = {
    SE = "Common/sfx_note_5",
    sound = "So"
  },
  [6] = {
    SE = "Common/sfx_note_6",
    sound = "La"
  },
  [7] = {
    SE = "Common/sfx_note_7",
    sound = "Xi"
  }
}
local actionList = {
  ready = "wls_functional_action13",
  play = "wls_functional_action14",
  miss = "wls_functional_action12",
  finish = "wls_functional_action15"
}

function MusicGamePanel:Init()
  self:FindObjs()
  self:AddEvts()
  self:InitShow()
end

function MusicGamePanel:FindObjs()
  self.effectHandlerRoot = self:FindGO("effectContainer")
  self.noteList = {}
  self.noteList[1] = self:FindGO("Do")
  self.noteList[2] = self:FindGO("Re")
  self.noteList[3] = self:FindGO("Mi")
  self.noteList[4] = self:FindGO("Fa")
  self.noteList[5] = self:FindGO("So")
  self.noteList[6] = self:FindGO("La")
  self.noteList[7] = self:FindGO("Xi")
  self.noteEffectContainer = {}
  for i = 1, 7 do
    self.noteEffectContainer[i] = self:FindGO("effectContainer", self.noteList[i])
  end
  self.textureWhite = self:FindGO("TextureWhite"):GetComponent(UITexture)
  self.textureGold = self:FindGO("TextureGold"):GetComponent(UITexture)
  self.textureGold.fillAmount = 0
  self.scoreScrollView = self:FindGO("ScoreScrollView"):GetComponent(UIScrollView)
  self.scoreTweenPosition = self:FindGO("TextureWhite"):GetComponent(TweenPosition)
  self.curCountDown = 3
  self.countDownLabel = self:FindGO("CountDownLabel"):GetComponent(UILabel)
  self.countDownGO = self.countDownLabel.gameObject
  self.countDownTweenScale = self.countDownGO:GetComponent(TweenScale)
  self.countDownTweenScale:SetOnFinished(function()
    self.curCountDown = self.curCountDown - 1
    if self.curCountDown == 0 then
      self:GameStart()
      return
    end
    self.countDownLabel.text = self.curCountDown
    self.countDownTweenScale:ResetToBeginning()
    self.countDownTweenScale:PlayForward()
  end)
  self.closeBtn = self:FindGO("CloseButton")
  self.restartBtn = self:FindGO("RestartBtn")
  self.restartBtn_Color = self:FindGO("PlayIconBG", self.restartBtn):GetComponent(UISprite)
  self.restartBtn_Frame = self:FindGO("PlayDynamicBG", self.restartBtn)
  self.restartBtn_BoxCollider = self.restartBtn:GetComponent(BoxCollider)
  self:SetResetBtnStatus(true)
  self.restartBtn_BoxCollider.enabled = false
  local btnsRoot = self:FindGO("BtnsRoot")
  self.btnsRoot_TweenPos = self:FindGO("TweenRoot", btnsRoot):GetComponent(TweenPosition)
  self.btnsRoot_TweenPos:PlayForward()
  local scoreRoot = self:FindGO("ScoreRoot")
  self.scoreRoot_TweenPos = self:FindGO("TweenRoot", scoreRoot):GetComponent(TweenPosition)
  self.scoreRoot_TweenPos:SetOnFinished(function()
  end)
  self.scoreRoot_TweenPos:PlayForward()
  self.restartTip = self:FindGO("RestartTip")
  self.restartTip:SetActive(false)
  self.resultPanel = self:FindGO("ResultPanel")
  self.title = self:FindGO("Title", self.resultPanel)
  self.title_TweenScale = self.title:GetComponent(TweenScale)
  self.title_TweenAlpha = self.title:GetComponent(TweenAlpha)
  self.title_TweenScale:ResetToBeginning()
  self.title_TweenAlpha:ResetToBeginning()
  self.resultLabel = self:FindGO("Label", self.title):GetComponent(UILabel)
  self.resultLabel_EN = self:FindGO("Label_EN", self.title):GetComponent(UILabel)
  self.titleTexture1 = self:FindGO("Texture1", self.title):GetComponent(UITexture)
  self.titleTexture2 = self:FindGO("Texture2", self.title):GetComponent(UITexture)
end

function MusicGamePanel:SetResetBtnStatus(bool)
  if bool then
    self.restartBtn_Color.color = LuaGeometry.GetTempVector4(0.39215686274509803, 0.5333333333333333, 0.8588235294117647, 1)
    self.restartBtn_Frame:SetActive(false)
  else
    self.restartBtn_Color.color = LuaGeometry.GetTempVector4(0.8745098039215686, 0.6, 0.30980392156862746, 1)
    self.restartBtn_Frame:SetActive(true)
  end
end

function MusicGamePanel:AddEvts()
  for i = 1, 7 do
    if self.noteList[i] then
      self:AddClickEvent(self.noteList[i], function(go)
        xdlog("点击的id", i)
        self:ClickNote(i)
        self:PlaySoundEffect(i)
      end, hideType)
    end
  end
  self:AddClickEvent(self.restartBtn, function()
    TimeTickManager.Me():ClearTick(self, 5)
    FunctionBGMCmd.Me():SetMute(true)
    self:CountDownReady()
    self.restartTip:SetActive(false)
    self:EndGame()
  end)
  self:AddClickEvent(self.closeBtn, function()
    redlog("失败跳转")
    if self.questData then
      QuestProxy.Instance:notifyQuestState(self.questData.scope, self.questData.id, self.questData.staticData.FailJump)
    end
    if self.triggerID then
      EventManager.Me():PassEvent(StealthGameEvent.ThePlayPinaoResult, {
        Success = 3,
        TriggerID = self.triggerID
      })
      self:CloseSelf()
    end
    if self.asset_Role then
      self.asset_Role:PlayAction_Idle()
    end
    self:CloseSelf()
  end)
end

function MusicGamePanel:InitShow()
  local viewdata = self.viewdata and self.viewdata.viewdata
  self.questData = viewdata and viewdata.questData
  if self.questData then
    xdlog("有任务信息")
    self.musicScoreID = self.questData.params.id or 1
    self.swanharpID = self.questData.params.equip or 400246
  else
    self.musicScoreID = viewdata and viewdata.scoreID or 1
    self.triggerID = viewdata and viewdata.triggerId
    xdlog("曲目 触发器", self.musicScoreID, self.triggerID)
    self.swanharpID = 400246
  end
  self:LoadScoreTexture()
  TimeTickManager.Me():CreateOnceDelayTick(1000, function(owner, deltaTime)
    self:CountDownReady()
  end, 7)
end

function MusicGamePanel:InitDatas()
  local musicScoreConfig = Table_MusicScore[self.musicScoreID]
  if not musicScoreConfig then
    return
  end
  self.musicPath = musicScoreConfig and musicScoreConfig.Music
  self.bgmPath = musicScoreConfig.BGM
  self.bpm = musicScoreConfig and musicScoreConfig.BPM or 60
  self.speedRate = self.bpm / 60
  local score = musicScoreConfig and musicScoreConfig.Score
  self.scoreList = {}
  xdlog("曲子信息 长度", self.musicScoreID, #score)
  for i = 1, #score do
    local singleScore = score[i]
    if singleScore[1] and singleScore[2] then
      self.scoreList[singleScore[1] / self.speedRate] = singleScore[2]
    else
      redlog("配置错误", singleScore[1], singleScore[2])
    end
  end
  self.scoreLength = musicScoreConfig.MusicTime and musicScoreConfig.MusicTime
  self.scoreEndTime = ServerTime.CurServerTime() / 1000 + self.scoreLength
  self.textureGold.fillAmount = 0
  self.chance = musicScoreConfig.Chance or 0
  self.maxCombo = #score
  self.curProcess = 0
  self.curCombo = 0
  self.nextUpdateTime = 0
  self.gameEnd = false
  self.noteData = {}
end

function MusicGamePanel:LoadScoreTexture()
  local musicScoreConfig = Table_MusicScore[self.musicScoreID]
  self.texturePath = musicScoreConfig and musicScoreConfig.ScoreTexture or "qws_bg_tablature_01"
  PictureManager.Instance:SetMusicGameTexture(self.texturePath .. "a", self.textureWhite)
  self.textureWhite:MakePixelPerfect()
  PictureManager.Instance:SetMusicGameTexture(self.texturePath .. "b", self.textureGold)
  self.textureGold:MakePixelPerfect()
end

function MusicGamePanel:GameStart()
  self:InitDatas()
  self.startTimeStamp = ServerTime.CurServerTime() / 1000
  self.gameOver = false
  self.countDownLabel.text = ""
  self:AddMonoUpdateFunction(self.Update)
  self.audioSource = nil
  FunctionBGMCmd.Me():SetMute(false)
  if self.bgmPath and self.bgmPath ~= "" then
    FunctionBGMCmd.Me():PlayUIBgm(self.bgmPath, 1)
  end
  self:SetResetBtnStatus(false)
  self.restartBtn_BoxCollider.enabled = true
  self:ScoreTween()
  self.asset_Role:PlayAction_SimpleLoop(actionList.play)
  self.playing = true
end

function MusicGamePanel:ScoreTween()
  local maxWidth = 1112
  if maxWidth <= self.textureWhite.width then
    self.scoreTweenPosition.duration = self.scoreLength
    self.scoreTweenPosition.style = 0
    LuaVector3.Better_Set(tempVector3, getlocalPos(self.textureWhite.gameObject.transform))
    self.scoreTweenPosition.from = tempVector3
    self.scoreTweenPosition.to = LuaGeometry.GetTempVector3(tempVector3.x - self.textureWhite.width / 2, tempVector3.y, tempVector3.z)
    self.scoreTweenPosition.enabled = true
    self.scoreTweenPosition:ResetToBeginning()
    self.scoreTweenPosition:PlayForward()
  end
  self.timeTick = TimeTickManager.Me():CreateTick(0, 33, self.UpdateScoreProcess, self, 6)
end

function MusicGamePanel:UpdateScoreProcess()
  local leftTime = self.scoreEndTime - ServerTime.CurServerTime() / 1000
  if 0 < leftTime then
    self.textureGold.fillAmount = (self.scoreLength - leftTime) / self.scoreLength
  else
    self.gameOver = true
    TimeTickManager.Me():ClearTick(self, 6)
  end
end

function MusicGamePanel:Update(time, deltaTime)
  if time > self.nextUpdateTime then
    self.nextUpdateTime = time + 0.1
    self:UpdateNote(time, deltaTime)
  end
  if self.curProcess >= self.maxCombo and self.gameOver and not self.gameEnd then
    self.gameEnd = true
    self.restartBtn_BoxCollider.enabled = false
    TimeTickManager.Me():CreateOnceDelayTick(3000, function(owner, deltaTime)
      self:RemoveMonoUpdateFunction()
      self.gameEnd = false
      self:SetResetBtnStatus(true)
      if self.curCombo + self.chance >= self.maxCombo then
        xdlog("游戏成功")
        self:ShowResult(true)
        self.scoreRoot_TweenPos:PlayReverse()
        self.btnsRoot_TweenPos:PlayReverse()
        self.closeBtn:SetActive(false)
        self.restartBtn:SetActive(false)
        if self.musicPath and self.musicPath ~= "" then
          FunctionBGMCmd.Me():PlayUIBgm(self.musicPath, 1, nil, nil, nil, nil, function()
            self.asset_Role:PlayAction_Simple(actionList.finish)
            self.restartBtn_BoxCollider.enabled = true
            if self.questData then
              xdlog("成功跳转")
              QuestProxy.Instance:notifyQuestState(self.questData.scope, self.questData.id, self.questData.staticData.FinishJump)
            elseif self.triggerID then
              EventManager.Me():PassEvent(StealthGameEvent.ThePlayPinaoResult, {
                Success = 1,
                TriggerID = self.triggerID
              })
            end
            self:CloseSelf()
          end)
        else
          TimeTickManager.Me():CreateOnceDelayTick(1000, function(owner, deltaTime)
            self.asset_Role:PlayAction_Simple(actionList.finish)
            self.restartBtn_BoxCollider.enabled = true
            if self.questData then
              xdlog("成功跳转")
              QuestProxy.Instance:notifyQuestState(self.questData.scope, self.questData.id, self.questData.staticData.FinishJump)
            elseif self.triggerID then
              EventManager.Me():PassEvent(StealthGameEvent.ThePlayPinaoResult, {
                Success = 1,
                TriggerID = self.triggerID
              })
            end
            self:CloseSelf()
          end, self, 8)
        end
      else
        redlog("游戏失败")
        self:ShowResult(false)
        self.restartBtn:SetActive(true)
        self.restartTip:SetActive(true)
        self.asset_Role:PlayAction_Simple(actionList.miss)
        self.restartBtn_BoxCollider.enabled = true
      end
    end, self, 5)
  end
  if Input.GetKeyDown(KeyCode.Z) then
    self:ClickNote(1)
    self:PlaySoundEffect(1)
  end
  if Input.GetKeyDown(KeyCode.X) then
    self:ClickNote(2)
    self:PlaySoundEffect(2)
  end
  if Input.GetKeyDown(KeyCode.C) then
    self:ClickNote(3)
    self:PlaySoundEffect(3)
  end
  if Input.GetKeyDown(KeyCode.V) then
    self:ClickNote(4)
    self:PlaySoundEffect(4)
  end
  if Input.GetKeyDown(KeyCode.B) then
    self:ClickNote(5)
    self:PlaySoundEffect(5)
  end
  if Input.GetKeyDown(KeyCode.N) then
    self:ClickNote(6)
    self:PlaySoundEffect(6)
  end
  if Input.GetKeyDown(KeyCode.M) then
    self:ClickNote(7)
    self:PlaySoundEffect(7)
  end
end

function MusicGamePanel:UpdateNote(time, deltaTime)
  local curServerTime = ServerTime.CurServerTime() / 1000
  for k, v in pairs(self.scoreList) do
    if curServerTime - self.startTimeStamp >= k - 1 then
      self:NoteReady(v, curServerTime + 1)
      self.scoreList[k] = nil
      self.curProcess = self.curProcess + 1
      break
    end
  end
end

function MusicGamePanel:NoteReady(index, time)
  if not self.noteList[index] then
    return
  end
  local go = _Game.AssetManager_UI:CreateAsset(noteCellPath, self.noteEffectContainer[index])
  if go then
    local cellCtrl = MusicNoteCell.new(go)
    if not self.noteData[index] then
      self.noteData[index] = {}
    end
    cellCtrl:SetIndex(index)
    cellCtrl:SetTimeStamp(time)
    table.insert(self.noteData[index], cellCtrl)
    cellCtrl:AddEventListener("MusicNoteEnd", self.NoteTimePass, self)
  end
end

function MusicGamePanel:ClickNote(index)
  if not (self.noteData and self.noteData[index]) or #self.noteData[index] == 0 then
    redlog("无候选列表", index)
    return
  end
  table.sort(self.noteData[index], function(l, r)
    return l.time < r.time
  end)
  local cellCtrl = self.noteData[index][1]
  if not cellCtrl then
    return
  end
  local timeStamp = cellCtrl.time
  local curTime = ServerTime.CurServerTime() / 1000
  local offset = math.abs(timeStamp - curTime)
  if 0.3 < offset then
    self:PlayUIEffect(EffectMap.UI.MusicGame_Miss, self.noteEffectContainer[index], false)
    local animParams = Asset_Role.GetPlayActionParams(actionList.miss, nil, 1)
    animParams[7] = function()
      self.playing = false
      self.asset_Role:PlayAction_Simple(actionList.ready, nil, 2)
    end
    self.asset_Role:PlayAction(animParams)
  elseif offset < 0.3 and 0.2 < offset then
    self:PlayUIEffect(EffectMap.UI.MusicGame_Good, self.noteEffectContainer[index], false)
    self.curCombo = self.curCombo + 1
    self:ContinueAction()
  else
    self:PlayUIEffect(EffectMap.UI.MusicGame_Perfect, self.noteEffectContainer[index], false)
    self.curCombo = self.curCombo + 1
    self:ContinueAction()
  end
  self:RemoveNote(cellCtrl)
end

function MusicGamePanel:ContinueAction()
  if not self.playing then
    self.playing = true
    self.asset_Role:PlayAction_Simple(actionList.play, nil, 1)
  end
end

function MusicGamePanel:PlaySoundEffect(index)
  local path = soundList[index] and soundList[index].SE
  local clip = AudioUtility.GetAudioClip(path)
  local go = self:FindGO("AudioSource")
  if not go then
    local tempGO = GameObject("AudioSource")
    self.audioSource = tempGO:AddComponent(AudioController)
  end
  self.audioSource.audioSource.clip = clip
  self.audioSource.audioSource:Play()
end

function MusicGamePanel:NoteTimePass(cellCtrl)
  self:RemoveNote(cellCtrl)
  local index = cellCtrl.index
  self:PlayUIEffect(EffectMap.UI.MusicGame_Miss, self.noteEffectContainer[index], false)
end

function MusicGamePanel:RemoveNote(cellCtrl)
  local index = cellCtrl.index
  if index then
    table.remove(self.noteData[index], 1)
  end
  local obj = cellCtrl.gameObject
  GameObject.DestroyImmediate(obj)
end

function MusicGamePanel:CountDownReady()
  self.curCountDown = 3
  self.countDownLabel.text = self.curCountDown
  self.countDownTweenScale:ResetToBeginning()
  self.countDownTweenScale:PlayForward()
  self.textureWhite.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(-522.47, -28, 0)
  self.textureGold.fillAmount = 0
  TimeTickManager.Me():ClearTick(self, 6)
  self.asset_Role:PlayAction_Simple(actionList.ready)
  self.restartBtn_BoxCollider.enabled = false
end

function MusicGamePanel:EndGame()
  self:RemoveMonoUpdateFunction()
  self.gameEnd = false
  self:SetResetBtnStatus(true)
  for i = 1, 7 do
    Game.GameObjectUtil:DestroyAllChildren(self.noteEffectContainer[i])
    if self.noteData[i] then
      TableUtility.TableClear(self.noteData[i])
    end
  end
end

function MusicGamePanel:ShowResult(success)
  self.title_TweenScale:ResetToBeginning()
  self.title_TweenScale:PlayForward()
  self.title_TweenAlpha:ResetToBeginning()
  self.title_TweenAlpha:PlayForward()
  if success then
    self.resultLabel.text = ZhString.Roguelike_ArchiveCmdOperationSuccess
    self.resultLabel.gradientTop = LuaGeometry.GetTempColor()
    self.resultLabel.gradientBottom = LuaGeometry.GetTempVector4(0.9607843137254902, 0.6823529411764706, 0.3764705882352941, 1)
    self.titleTexture1.color = LuaGeometry.GetTempVector4(1, 0.5764705882352941, 0.49411764705882355, 1)
    self.resultLabel_EN.text = "S U C C E S S"
    self.resultLabel_EN.gradientTop = LuaGeometry.GetTempColor()
    self.resultLabel_EN.gradientBottom = LuaGeometry.GetTempVector4(0.9607843137254902, 0.6823529411764706, 0.3764705882352941, 1)
  else
    self.resultLabel.text = ZhString.Roguelike_ArchiveCmdOperationFailed
    self.resultLabel_EN.text = "F  A  I  L  U  R  E"
    self.resultLabel.gradientTop = LuaGeometry.GetTempColor()
    self.resultLabel.gradientBottom = LuaGeometry.GetTempVector4(0.6627450980392157, 0.6784313725490196, 0.9254901960784314, 1)
    self.titleTexture1.color = LuaGeometry.GetTempVector4(0.6392156862745098, 0.7450980392156863, 0.9647058823529412, 1)
    self.resultLabel_EN.gradientTop = LuaGeometry.GetTempColor()
    self.resultLabel_EN.gradientBottom = LuaGeometry.GetTempVector4(0.6627450980392157, 0.6784313725490196, 0.9254901960784314, 1)
  end
end

local ViewPort = Vector3(0.35, 0.17, 7.5)
local Rotation = Vector3(0, 60, 0)

function MusicGamePanel:OnEnter()
  MusicGamePanel.super.OnEnter(self)
  local myTrans = Game.Myself.assetRole.completeTransform
  self:CameraFaceTo(myTrans, CameraConfig.MusicGame_ViewPort, CameraConfig.MusicGame_Rotation, 1)
  FunctionBGMCmd.Me():SetMute(true)
  if not SgAIManager.Me().m_isInBattle then
    FunctionSceneFilter.Me():StartFilter(46)
  end
  self.asset_Role = Game.Myself.assetRole
  self.previewWeaponID = self.asset_Role:GetWeaponID()
  Game.Myself.assetRole:RedressPart(Asset_Role.PartIndex.RightWeapon, self.swanharpID)
  Game.Myself.assetRole:_ActionHideWeapon(false)
  Game.Myself.assetRole:SetWeaponDisplay(true)
  PictureManager.Instance:SetUI("Japanesecopy_bg_bottom", self.titleTexture1)
  PictureManager.Instance:SetUI("Japanesecopy_bg_light", self.titleTexture2)
end

function MusicGamePanel:OnExit()
  self:RemoveMonoUpdateFunction()
  TimeTickManager.Me():ClearTick(self)
  MusicGamePanel.super.OnExit(self)
  self:CameraReset(1)
  FunctionBGMCmd.Me():StopUIBgm()
  FunctionBGMCmd.Me():SetMute(false)
  if not SgAIManager.Me().m_isInBattle then
    FunctionSceneFilter.Me():EndFilter(46)
  end
  PictureManager.Instance:UnloadMusicGameTexture(self.texturePath .. "a", self.textureWhite)
  PictureManager.Instance:UnloadMusicGameTexture(self.texturePath .. "b", self.textureGold)
  self.asset_Role:RedressPart(Asset_Role.PartIndex.RightWeapon, self.previewWeaponID)
  Game.Myself.assetRole:_ActionHideWeapon(true)
  Game.Myself.assetRole:SetWeaponDisplay(false)
  PictureManager.Instance:UnLoadUI("Japanesecopy_bg_bottom", self.titleTexture1)
  PictureManager.Instance:UnLoadUI("Japanesecopy_bg_light", self.titleTexture2)
end
