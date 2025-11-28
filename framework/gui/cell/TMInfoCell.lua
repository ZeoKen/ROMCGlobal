autoImport("MainViewPlayerFaceCell")
local TMInfoCell_SymbolStatus = {
  NONE = 0,
  FOLLOW = 1,
  HANDINHAND = 2
}
local Follow_SpriteName = {
  "icon_hands",
  "main_icon_2"
}
local BaseCell = autoImport("BaseCell")
TMInfoCell = class("TMInfoCell", BaseCell)
local _ZoneIcon = "main_icon_worldline_jm"
local _ServerIcon = "main_icon_The-server2"
local _TemaPB = SessionTeam_pb

function TMInfoCell:InitHighFrequencyCall()
  self.frequencyCall = {}
  self.frequencyCall[_TemaPB.EMEMBERDATA_BASELEVEL] = self._UpdateBaseLv
  self.frequencyCall[_TemaPB.EMEMBERDATA_HP] = self._UpdateHp
  self.frequencyCall[_TemaPB.EMEMBERDATA_MAXHP] = self._UpdateHp
  self.frequencyCall[_TemaPB.EMEMBERDATA_SP] = self._UpdateMp
  self.frequencyCall[_TemaPB.EMEMBERDATA_MAXSP] = self._UpdateMp
  self.frequencyCall[_TemaPB.EMEMBERDATA_AUTOFOLLOW] = self.UpdateFollow
  self.frequencyCall[_TemaPB.EMEMBERDATA_EXPIRETIME] = self._UpdateRestTip
  self.frequencyCall[_TemaPB.EMEMBERDATA_RELIVETIME] = self._UpdateRestTip
end

function TMInfoCell:_UpdateHp(mdata)
  self.data = mdata
  if mdata and mdata ~= MyselfTeamData.EMPTY_STATE then
    self.headData:ResetTeamHp(mdata)
    self.teamHead:UpdateHp(self.headData.hp)
    self.teamHead:ActiveHpMp(true)
  end
end

function TMInfoCell:_UpdateMp(mdata)
  self.data = mdata
  if mdata and mdata ~= MyselfTeamData.EMPTY_STATE then
    self.headData:ResetTeamMp(mdata)
    self.teamHead:UpdateMp(self.headData.mp)
    self.teamHead:ActiveHpMp(true)
  end
end

function TMInfoCell:UpdateByServerMemberData(type, mdata)
  local callFunc = self.frequencyCall[type]
  if callFunc then
    callFunc(self, mdata)
  end
end

function TMInfoCell:IsFrequencyCall(type)
  return nil ~= self.frequencyCall[type]
end

function TMInfoCell:Init()
  TMInfoCell.super.Init(self)
  self:InitHighFrequencyCall()
  local teamHead = self:FindGO("TeamHead")
  self.teamHead = MainViewPlayerFaceCell.new(teamHead)
  self.teamHead:AddIconEvent()
  self.teamHead:SetMinDepth(40)
  self.teamHead:SetHeadIconPos(false)
  self.teamHead.lvmat = "%s"
  self.teamHeadNameObj = self.teamHead.nameObj
  self.effectContainer = self:FindGO("effectContainer", teamHead)
  self.headData = HeadImageData.new()
  self.emptyButton = self:FindGO("EmptyButton")
  self.emptyButton_None = self:FindGO("None", self.emptyButton)
  self.emptyButton_SearchingTeam = self:FindGO("SearchingTeam", self.emptyButton)
  self.emptyButton_InviteMember = self:FindGO("InviteMember", self.emptyButton)
  self.zoneInfo = self:FindGO("ZoneInfo")
  self.zoneIconSp = self:FindComponent("ZoneIcon", UISprite, self.zoneInfo)
  self.zoneId = self:FindComponent("ZoneId", UILabel)
  self.restTip = self:FindGO("RestTip")
  self.restTime = self:FindComponent("RestTime", UILabel)
  self.GMEVoice = self:FindGO("voice")
  self.GMEState1 = self:FindGO("voice/state1")
  self.GMEState2 = self:FindGO("voice/state2")
  self.GMEState3 = self:FindGO("voice/state3")
  self.m_gmeSpeaker = self:FindGO("voice/state1/Sprite"):GetComponent(UISprite)
  self:_UpdateGME(nil)
  self:AddCellClickEvent()
  self.symbolStatus = TMInfoCell_SymbolStatus.NONE
  self.widget = self.gameObject:GetComponent(UIWidget)
end

function TMInfoCell:_UpdateGME(memberData)
  if memberData == nil then
    self.GMEVoice:SetActive(false)
    return
  end
  self.GMEVoice:SetActive(true)
  self.GMEState1:SetActive(false)
  self.GMEState2:SetActive(false)
  self.GMEState3:SetActive(false)
  local mic = memberData.IsSpeaking
  local speaker = true
  local green = Color.green
  if mic == true and speaker == true then
    self.GMEState1:SetActive(true)
    if self.m_speakerTime == nil then
      self.m_speakerFlag = false
      self.m_speakerTime = TimeTickManager.Me():CreateTick(100, 800, self.updateGMESpeakerState, self, memberData.UserId)
    end
  elseif mic == false and speaker == true then
    self.GMEState2:SetActive(true)
    if self.m_speakerTime ~= nil then
      TimeTickManager.Me():ClearTick(self, memberData.UserId)
      self.m_speakerTime = nil
    end
  elseif mic == false and speaker == false then
    self.GMEState3:SetActive(true)
    if self.m_speakerTime ~= nil then
      TimeTickManager.Me():ClearTick(self, memberData.UserId)
      self.m_speakerTime = nil
    end
  end
end

function TMInfoCell:updateGMESpeakerState()
  redlog("team  .. speak")
  if self.GMEVoice == nil then
    return
  end
  self.m_speakerFlag = not self.m_speakerFlag
  if self.m_speakerFlag then
    self.m_gmeSpeaker.color = Color.green
  else
    self.m_gmeSpeaker.color = ColorUtil.NGUIWhite
  end
end

function TMInfoCell:SetData(data)
  self.data = data
  self.hideEffect = false
  local isEmpty = data == MyselfTeamData.EMPTY_STATE
  if isEmpty then
    self:UpdateEmptyState()
    self:RemoveRestTimeTick()
  end
  local hasData = type(data) == "table"
  if hasData then
    self.id = self.data.id
    self:UpdateImageCreator()
  end
  self.emptyButton:SetActive(isEmpty)
  self:_UpdateBaseLv()
  self:_UpdateHeadIcon()
  self:UpdateFollow()
  self:_UpdateRestTip()
  self:_UpdateZoneId()
end

function TMInfoCell:UpdateEmptyState()
  if not TeamProxy.Instance:IHaveTeam() then
    self.emptyButton_InviteMember:SetActive(false)
    local isEntering = TeamProxy.Instance:IsQuickEntering()
    self.emptyButton_SearchingTeam:SetActive(isEntering)
    self.emptyButton_None:SetActive(not isEntering)
  else
    self.emptyButton_InviteMember:SetActive(true)
    self.emptyButton_SearchingTeam:SetActive(false)
    self.emptyButton_None:SetActive(false)
  end
end

function TMInfoCell:UpdateFollow(update)
  if type(self.data) ~= "table" then
    self:_tryResetFollowSymbol(TMInfoCell_SymbolStatus.NONE)
    return
  end
  local id = self.data.id
  local followid = Game.Myself:Client_GetFollowLeaderID()
  local handFollowerId = Game.Myself:Client_GetHandInHandFollower()
  local isHanding = Game.Myself:Client_IsFollowHandInHand()
  local handTargetId = isHanding and followid or handFollowerId
  if handTargetId == id then
    self:_tryResetFollowSymbol(TMInfoCell_SymbolStatus.HANDINHAND, Follow_SpriteName[1])
  elseif followid == id then
    self:_tryResetFollowSymbol(TMInfoCell_SymbolStatus.FOLLOW, Follow_SpriteName[2])
  else
    self:_tryResetFollowSymbol(TMInfoCell_SymbolStatus.NONE)
  end
end

function TMInfoCell:_UpdateBaseLv(update)
  if type(self.data) ~= "table" then
    return
  end
  if update then
    self.data.baselv = update.baselv
  end
  self.teamHead:SetLevel(self.data.baselv)
end

function TMInfoCell:_UpdateHeadIcon(update)
  if type(self.data) ~= "table" then
    self.teamHead:SetData(nil)
    return
  end
  if update then
    self.data = update
  end
  self.headData:Reset()
  self.headData:TransByTeamMemberData(self.data)
  self.teamHead:SetData(self.headData)
  self.teamHead:ActiveHpMp(true)
  self.hideEffect = self.data:IsOffline()
end

function TMInfoCell:_UpdateZoneId(update)
  if type(self.data) ~= "table" then
    return
  end
  if update then
    self.data.zoneid = update.zoneid
    self.data.realzoneid = update.realzoneid
    self.data.offline = update.offline
    self.data.cat = update.cat
  end
  if self.data == MyselfTeamData.EMPTY_STATE then
    self:SetZoneId()
  elseif self.data:IsSameServer() then
    local zoneid = self.data.zoneid
    local isOffline = self.data:IsOffline()
    local realzoneid = self.data.realzoneid
    local isSameline = self.data:IsSameline()
    self:SetZoneId(zoneid, isOffline, realzoneid, isSameline)
  else
    self:SetServerId(self.data:GetServerId())
  end
end

function TMInfoCell:_tryResetFollowSymbol(status, extra)
  if self.symbolStatus ~= status then
    self.teamHead.symbols:Active(PlayerFaceCell_SymbolType.Follow, status ~= TMInfoCell_SymbolStatus.NONE)
    if extra then
      self.teamHead.symbols:SetSprite(PlayerFaceCell_SymbolType.Follow, extra)
    end
    self.symbolStatus = status
  end
end

function TMInfoCell:UpdateImageCreator()
  self.teamHead.symbols:Active(PlayerFaceCell_SymbolType.ImageCreate, self.data.image == 1)
end

local tempVector3 = LuaVector3.Zero()

function TMInfoCell:SetZoneId(zoneId, offline, realzoneid, IsSameline)
  tempVector3[1] = 48
  if not offline and zoneId and zoneId ~= 0 then
    self.zoneInfo:SetActive(not IsSameline)
    self.zoneIconSp.spriteName = _ZoneIcon
    self.zoneId.text = ChangeZoneProxy.Instance:ZoneNumToString(zoneId, nil, realzoneid)
    if IsSameline then
      tempVector3[2] = 42
    else
      tempVector3[2] = 22
    end
  else
    self.zoneInfo:SetActive(false)
    tempVector3[2] = 42
  end
  self.teamHead:SetSymbolObjPos(tempVector3)
end

function TMInfoCell:SetServerId(serverId)
  self.zoneInfo:SetActive(true)
  self.zoneIconSp.spriteName = _ServerIcon
  self.zoneId.text = tostring(serverId)
  tempVector3:Set(48, 22, 0)
  self.teamHead:SetSymbolObjPos(tempVector3)
end

function TMInfoCell:UpdateHp(value)
  self.teamHead:UpdateHp(value)
end

function TMInfoCell:UpdateMp(value)
  self.teamHead:UpdateMp(value)
end

function TMInfoCell:_UpdateRestTip(update)
  if type(self.data) ~= "table" then
    self.restTip:SetActive(false)
    self:RemoveRestTimeTick()
    return
  end
  if update then
    self.data.expiretime = update.expiretime
    self.data.resttime = update.resttime
  end
  local expiretime = self.data.expiretime or 0
  local curtime = ServerTime.CurServerTime() / 1000
  if expiretime ~= 0 and expiretime <= curtime then
    self.teamHead:SetIconActive(false)
    self.teamHead:ActiveHpMp(false)
    self.restTip:SetActive(true)
    self.restTime.text = ZhString.TeamInviteMembCell_ExpireTime
    self:SetGOActive(self.teamHeadNameObj, false)
    self.hideEffect = true
  else
    local resttime = self.data.resttime
    resttime = resttime or 0
    local restSec = resttime - curtime
    if 0 < restSec then
      self.restTip:SetActive(true)
      if not self.restTimeTick then
        self.restTimeTick = TimeTickManager.Me():CreateTick(0, 1000, self._updateRestTime, self)
      end
      self.teamHead:SetIconActive(false)
      self.teamHead:ActiveHpMp(false)
      self:SetGOActive(self.teamHeadNameObj, false)
      self.hideEffect = true
    else
      self.restTip:SetActive(false)
      self:RemoveRestTimeTick()
    end
  end
end

function TMInfoCell:_updateRestTime()
  if type(self.data) ~= "table" then
    self.restTip:SetActive(false)
    self:RemoveRestTimeTick()
    return
  end
  local cur = ServerTime.CurServerTime() / 1000
  local expiretime = self.data.expiretime or 0
  local resttime = self.data and self.data.resttime
  if cur < expiretime and resttime and 0 < resttime then
    local restSec = resttime - cur
    if 0 < restSec then
      local min, sec = ClientTimeUtil.GetFormatSecTimeStr(restSec)
      self.restTime.text = string.format(ZhString.TMInfoCell_RestTip, min, sec)
    else
      self:RemoveRestTimeTick()
    end
  end
end

function TMInfoCell:_UpdateVoiceState()
  local isSpeeking = false
  if true == isSpeeking then
    self.voiceMic:SetActive(false)
    self.voiceSpeak:SetActive(true)
  else
    self.voiceMic:SetActive(true)
    self.voiceSpeak:SetActive(false)
  end
end

function TMInfoCell:RemoveRestTimeTick()
  if self.restTimeTick then
    TimeTickManager.Me():ClearTick(self, 1)
    self.restTimeTick = nil
    self.restTime.text = ""
  end
  if type(self.data) == "table" and AfkProxy.ParseIsAfk(self.data.afk) then
    self.teamHead:SetIconActive(true, true)
  elseif self.headData and self.headData.offline ~= true then
    self.teamHead:SetIconActive(true, true)
  else
    self.teamHead:SetIconActive(false, false)
  end
  self:SetGOActive(self.teamHeadNameObj, true)
  self.teamHead:UpdateHp(1)
  self.teamHead:UpdateMp(1)
  self.teamHead:ActiveHpMp(true)
end

function TMInfoCell:UpdateMemberPos()
end

function TMInfoCell:OnRemove()
  self.symbolStatus = TMInfoCell_SymbolStatus.NONE
  self.teamHead:RemoveIconEvent()
  self:RemoveRestTimeTick()
end

function TMInfoCell:ShowEffect()
  if self.targetEffect then
    self:ClearEffect()
  end
  local isEmpty = self.data == MyselfTeamData.EMPTY_STATE
  if not isEmpty and type(self.data) == "table" then
    local isValid = self.data:IsValidForAutoLock()
    if isValid and not self.hideEffect then
      self.targetEffect = self:PlayUIEffect(EffectMap.UI.SkillTargetPointTip, self.effectContainer)
    else
      self:ClearEffect()
    end
  else
    self:ClearEffect()
  end
end

function TMInfoCell:ClearEffect()
  if self.targetEffect then
    self.targetEffect:Destroy()
    self.targetEffect = nil
  end
end
