local _Texture = {
  titleTexture = "sign_21days_bg_title1",
  titleTextureBlue = "sign_21days_bg_progress-bar1",
  titleTextureYellow = "sign_21days_bg_progress-bar2",
  topBgTexture = "sign_21days_bg_title0",
  topicBgTexture = "sign_21days_bgbg",
  passTexture = "mall_bg_bottom_07"
}
local _PictureMgr, _TopicProxy
local _LayerCellName = "TopicLayerCell"
local _SetLocalPositionGO = LuaGameObject.SetLocalPositionGO
local _EvenPosConfig = GameConfig.Topic.layerPos.even
local _OddPosConfig = GameConfig.Topic.layerPos.odd
local _CalcProgress = function(rewarded_cnt, completelayer_cnt)
  return (rewarded_cnt + completelayer_cnt * 2) / 20
end
autoImport("TopicQuestCell")
autoImport("TopicLayerCell")
TopicView = class("TopicView", ContainerView)
TopicView.ViewType = UIViewType.NormalLayer

function TopicView:Init()
  _TopicProxy = TopicProxy.Instance
  _PictureMgr = PictureManager.Instance
  _TopicProxy:ResetCurMaxTopic()
  self.curViewTopic = _TopicProxy:GetCurTopicIndex()
  self:FindObj()
  self:AddUIEvt()
  self:AddEvt()
  self:UpdatePage()
end

function TopicView:OnEnter()
  TopicView.super.OnEnter(self)
  self:LoadTexture()
end

function TopicView:LoadTexture()
  _PictureMgr:SetSignIn(_Texture.titleTexture, self.titleTexture)
  _PictureMgr:SetSignIn(_Texture.titleTextureBlue, self.titleTextureBlue)
  _PictureMgr:SetSignIn(_Texture.titleTextureYellow, self.titleTextureYellowProgress)
  _PictureMgr:SetSignIn(_Texture.topBgTexture, self.topBgTexture)
  _PictureMgr:SetSignIn(_Texture.topicBgTexture, self.topicBgTexture)
  _PictureMgr:SetUI(_Texture.passTexture, self.passTexture)
end

function TopicView:UnLoadTexture()
  _PictureMgr:UnLoadSignIn(_Texture.titleTexture, self.titleTexture)
  _PictureMgr:UnLoadSignIn(_Texture.titleTextureBlue, self.titleTextureBlue)
  _PictureMgr:UnLoadSignIn(_Texture.titleTextureYellow, self.titleTextureYellowProgress)
  _PictureMgr:UnLoadSignIn(_Texture.topBgTexture, self.topBgTexture)
  _PictureMgr:UnLoadSignIn(_Texture.topicBgTexture, self.topicBgTexture)
  _PictureMgr:UnLoadUI(_Texture.passTexture, self.passTexture)
end

function TopicView:OnExit()
  TopicView.super.OnExit(self)
  self:UnLoadTexture()
end

function TopicView:AddUIEvt()
  self:AddClickEvent(self.prePageBtn.gameObject, function()
    self.curViewTopic = self.curViewTopic - 1
    self:UpdatePage()
    self:UpdateLayer()
  end)
  self:AddClickEvent(self.nextPageBtn.gameObject, function()
    local curMaxTopic = _TopicProxy:GetCurTopicIndex()
    if curMaxTopic <= self.curViewTopic then
      MsgManager.ShowMsgByID(43159)
      return
    end
    self.curViewTopic = self.curViewTopic + 1
    self:UpdatePage()
    self:UpdateLayer()
  end)
end

function TopicView:UpdatePage()
  self.topicIndexLab.text = StringUtil.IntToRoman(self.curViewTopic)
  local curMaxTopic, curMinTopic = _TopicProxy:GetCurTopicIndex()
  self.nextPageBtn.alpha = curMaxTopic > self.curViewTopic and 1 or 0.3
  self.prePageBtn.gameObject:SetActive(curMinTopic < self.curViewTopic)
  self:UpdateQuest()
end

function TopicView:FindObj()
  self:InitTop()
  self:InitLeft()
  self:InitRight()
  self.topicBgTexture = self:FindComponent("TopicBgTexture", UITexture)
  self.prePageBtn = self:FindComponent("PrePageBtn", UISprite)
  self.nextPageBtn = self:FindComponent("NextPageBtn", UISprite)
  self.tipStick = self:FindComponent("TipWidgetStick", UIWidget)
end

function TopicView:InitTop()
  self.topRoot = self:FindGO("Top")
  local titleLabFixedLab = self:FindComponent("TitleLab_Fixed", UILabel, self.topRoot)
  titleLabFixedLab.text = ZhString.Topic_FixedTitle
  self.topicIndexLab = self:FindComponent("TopicIndexLab", UILabel, self.topRoot)
  self.titleTexture = self:FindComponent("Texture_Title", UITexture, self.topRoot)
  self.titleTextureBlue = self:FindComponent("Texture_Blue", UITexture, self.topRoot)
  self.titleTextureYellowProgress = self:FindComponent("Texture_Yellow_Progress", UITexture, self.topRoot)
  self.topBgTexture = self:FindComponent("Texture_Bg", UITexture, self.topRoot)
  self.passTexture = self:FindComponent("Texture_Pass", UITexture, self.topRoot)
  local passLab = self:FindComponent("Label", UILabel, self.passTexture.gameObject)
  passLab.text = ZhString.Topic_Pass
end

function TopicView:InitLeft()
  self.leftRoot = self:FindGO("Left")
  local questTitleLab = self:FindComponent("QuestTitleLab", UILabel, self.leftRoot)
  questTitleLab.text = ZhString.Topic_QuestFixedTitle
  local wrap = self:FindGO("Container")
  local wrapConfig = {
    wrapObj = wrap,
    cellName = "TopicQuestCell",
    control = TopicQuestCell
  }
  self.questWrapHelper = WrapCellHelper.new(wrapConfig)
  self.questWrapHelper:AddEventListener(MouseEvent.MouseClick, self.OnClickQuestCell, self)
end

function TopicView:InitRight()
  self.rightRoot = self:FindGO("Right")
  local layerCount = GameConfig.Topic.goalOneTopic
  self.layerCell = {}
  self.isEvenTopic = self.curViewTopic & 1 == 0
  local pos_config = self.isEvenTopic and _EvenPosConfig or _OddPosConfig
  for i = 1, layerCount do
    local cell_obj = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell(_LayerCellName))
    if not cell_obj then
      redlog("未找到预设" .. _LayerCellName)
      return
    end
    cell_obj.transform:SetParent(self.rightRoot.transform, false)
    _SetLocalPositionGO(cell_obj, pos_config[i][1], pos_config[i][2], 0)
    self.layerCell[i] = TopicLayerCell.new(cell_obj)
  end
  self:UpdateLayer()
end

function TopicView:AddEvt()
  self:AddListenEvt(MyselfEvent.ServantChallengeExpChange, self.HandleServantExpChanged)
  self:AddListenEvt(ServiceEvent.PlayerMapChange, self.CloseSelf)
  self:AddListenEvt(ServiceEvent.NoviceBattlePassChallengeTargetUpdateCmd, self.UpdateQuest)
  self:AddListenEvt(TopicEvent.ClickLayer, self.HandleTopicTip)
end

function TopicView:HandleTopicTip(note)
  local tipData = note.body
  if not tipData then
    return
  end
  TipManager.Instance:ShowTopicTip(tipData, self.tipStick)
end

function TopicView:HandleServantExpChanged()
  self:UpdateLayer(true)
end

function TopicView:UpdateLayer(tryPlayEffect)
  local layerData = _TopicProxy:GetLayerDataByTopic(self.curViewTopic)
  local nowIsEvenTopic = self.curViewTopic & 1 == 0
  for i = 1, #self.layerCell do
    if tryPlayEffect and self.layerCell[i].tipData.locked then
      self.layerCell[i]:PlayUIEff()
      tryPlayEffect = false
    end
    self.layerCell[i]:SetData(layerData[i], i)
    if nowIsEvenTopic ~= self.isEvenTopic then
      self.isEvenTopic = nowIsEvenTopic
      local pos_config = self.isEvenTopic and _EvenPosConfig or _OddPosConfig
      _SetLocalPositionGO(self.layerCell[i].gameObject, pos_config[i][1], pos_config[i][2], 0)
    end
  end
  self:CalcTopicProgress()
end

function TopicView:OnClickQuestCell(cellCtl)
  local data = cellCtl.data
  if not data then
    return
  end
  local msg = data.staticData.Version
  if not StringUtil.IsEmpty(msg) then
    MsgManager.FloatMsg(nil, msg)
    return
  end
  local guideId = data.staticData.GuideID
  if guideId and 0 < guideId then
    ServiceUserEventProxy.Instance:CallGuideQuestEvent(data.id)
    self:CloseSelf()
    return
  end
  FuncShortCutFunc.Me():CallByID(data.staticData.Goto)
  self:CloseSelf()
end

function TopicView:UpdateQuest()
  local data = _TopicProxy:GetQuests(self.curViewTopic)
  self.questWrapHelper:UpdateInfo(data, true)
  self:CalcTopicProgress()
end

function TopicView:CalcTopicProgress()
  local completeLayerCnt, rewardedQuestCnt = 0, 0
  for k, v in pairs(self.layerCell) do
    if v.tipData.layerFinished then
      completeLayerCnt = completeLayerCnt + 1
    end
  end
  local datas = self.questWrapHelper:GetDatas()
  for i = 1, #datas do
    if datas[i]:IsRewarded() then
      rewardedQuestCnt = rewardedQuestCnt + 1
    end
  end
  redlog("rewardedQuestCnt: ", rewardedQuestCnt, completeLayerCnt)
  local progress = _CalcProgress(rewardedQuestCnt, completeLayerCnt)
  redlog("progress: ", progress)
  self.titleTextureYellowProgress.fillAmount = progress
  self.passTexture.gameObject:SetActive(1 <= progress)
end
