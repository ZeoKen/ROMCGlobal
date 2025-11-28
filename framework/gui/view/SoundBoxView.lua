SoundBoxView = class("SoundBoxView", ContainerView)
SoundBoxView.ViewType = UIViewType.NormalLayer
autoImport("SoundBoxCell")

function SoundBoxView:Init()
  self.npc = self.viewdata.npcInfo
  if not self.npc then
    self.furniture = self.viewdata.viewdata and self.viewdata.viewdata.furniture
  end
  self:MapEvent()
  self:InitView()
end

function SoundBoxView:InitView()
  local slistgrid = self:FindComponent("SoundListGrid", UIGrid)
  self.soundList = UIGridListCtrl.new(slistgrid, SoundBoxCell, "SoundBoxCell")
  self.soundList:AddEventListener(MouseEvent.MouseClick, self.ClickSoundBox, self)
  self.noneTip = self:FindGO("NoneTip")
  self.chooseButton = self:FindGO("ChooseButton")
  self:AddClickEvent(self.chooseButton, function(go)
    local viewdata = {}
    if self.npc then
      viewdata.npc = self.npc
    elseif self.furniture then
      viewdata.furniture = self.furniture
    end
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.SoundItemChoosePopUp,
      viewdata = viewdata
    })
  end)
  self.recordRot = self:FindComponent("CDRecord", TweenRotation)
  self.jukeboxRot = self:FindComponent("Jukebox", TweenRotation)
  local accentGO = self:FindGO("Accents")
  self.accents = UIUtil.GetAllComponentsInChildren(accentGO, TweenRotation)
  local phoneplat = ApplicationInfo.GetRunPlatformStr()
  if (BranchMgr.IsSEA() or BranchMgr.IsEU()) and phoneplat == "iOS" then
    self:addAppleMusic()
  end
end

function SoundBoxView:addAppleMusic()
  local p = self:FindGO("BeforePanel")
  self.appleMusicBtn = self:CopyGameObject(self.chooseButton, p)
  self.appleMusicBtn.name = "APBtn"
  self.appleMusicBtn.transform.localPosition = LuaGeometry.GetTempVector3(414, -311, 0)
  self.chooseButton.transform.localPosition = LuaGeometry.GetTempVector3(160, -311, 0)
  local label = self:FindGO("Label", self.appleMusicBtn):GetComponent(UILabel)
  OverseaHostHelper:FixLabelOverV1(label, 3, 140)
  label.text = ZhString.ListenONAM
  label.effectColor = LuaGeometry.GetTempColor(0.2, 0.4, 0.6, 1)
  local sprite = self.appleMusicBtn:GetComponent(UISprite)
  sprite.spriteName = "com_btn_1"
  self:AddClickEvent(self.appleMusicBtn, function(go)
    OverseaHostHelper:JumpToAppleMusic()
  end)
end

function SoundBoxView:ClickSoundBox(cellCtl)
  local data = cellCtl.data
  if not self.isShowTip then
    local callback = function()
      self.isShowTip = false
    end
    local txt = data.staticData.MusicName
    local sp = cellCtl.gameObject:GetComponent(UIWidget)
    TipManager.Instance:ShowNormalTip(txt, sp, NGUIUtil.AnchorSide.DownRight, {0, 0}, callback, {
      sp.gameObject
    })
  end
end

function SoundBoxView:OnEnter()
  SoundBoxView.super.OnEnter(self)
  self:FocusOnNpc()
  if self.npc then
    ServiceNUserProxy.Instance:CallQueryMusicList(self.npc.data.id)
  elseif self.furniture then
    ServiceHomeCmdProxy.Instance:CallFurnitureOperHomeCmd(HomeCmd_pb.EFURNITUREOPER_RADIO_QUERY, self.furniture.data.id)
  end
end

function SoundBoxView:OnExit()
  if self.npc then
    ServiceNUserProxy.Instance:CallCloseMusicFrame()
  end
  SoundBoxView.super.OnExit(self)
  self:CameraReset()
end

function SoundBoxView:FocusOnNpc()
  local trans
  if self.npc then
    trans = self.npc.assetRole.completeTransform
  elseif self.furniture then
    trans = self.furniture.trans
  end
  if trans then
    self:CameraFocusOnNpc(trans)
  end
end

function SoundBoxView:UpdateSoundList(list)
  list = list or _EmptyTable
  self.soundList:ResetDatas(list)
  local isEmpty = #list == 0
  self.noneTip:SetActive(isEmpty)
  self:PlayAnim(not isEmpty)
end

function SoundBoxView:PlayAnim(state)
  if state ~= self.cacheState then
    if state then
      self.jukeboxRot:PlayForward()
      self.jukeboxRot:SetOnFinished(function()
        self.recordRot.enabled = true
        for _, accent in pairs(self.accents) do
          accent.enabled = true
        end
      end)
    else
      self.jukeboxRot:PlayReverse()
      self.jukeboxRot:SetOnFinished(function()
        self.recordRot.enabled = false
        for _, accent in pairs(self.accents) do
          accent.enabled = false
        end
      end)
    end
  end
  self.cacheState = state
end

function SoundBoxView:MapEvent()
  self:AddListenEvt(ServiceEvent.NUserQueryMusicList, self.HandleUpdateSList)
  self:AddListenEvt(HomeEvent.SoundListUpdate, self.HandleUpdateHouseSList)
  self:AddListenEvt(HomeEvent.ExitHome, self.CloseSelf)
end

function SoundBoxView:HandleUpdateSList(note)
  self:UpdateSoundList(ServiceNUserProxy.Instance.musicList)
end

function SoundBoxView:HandleUpdateHouseSList()
  local tempArr = ReusableTable.CreateArray()
  local soundList = HomeProxy.Instance.curSoundList
  for i = 1, #soundList do
    TableUtility.ArrayPushBack(tempArr, {
      starttime = 0,
      musicid = soundList[i].musicid,
      playername = soundList[i].name,
      index = i,
      staticData = Table_MusicBox[soundList[i].musicid]
    })
    if i == 1 and ServerTime.CurServerTime() / 1000 >= soundList[i].starttime then
      tempArr[i].starttime = soundList[i].starttime
    end
  end
  self:UpdateSoundList(tempArr)
  ReusableTable.DestroyAndClearArray(tempArr)
end
