autoImport("HeadIconCell")
local baseCell = autoImport("BaseCell")
SkadaRankingCell = class("SkadaRankingCell", baseCell)

function SkadaRankingCell:Init()
  self.ranklb = self:FindComponent("rank", UILabel)
  self.noranklb = self:FindComponent("norank", UILabel)
  self.ranksp = self:FindComponent("ranksp", UIMultiSprite)
  self.gender = self:FindComponent("gender", UIMultiSprite)
  self.namelb = self:FindComponent("Name", UILabel)
  self.lvlb = self:FindComponent("Lv", UILabel)
  self.joblb = self:FindComponent("Job", UILabel)
  self.labFightTime = self:FindComponent("Time", UILabel)
  self.labFightDamage = self:FindComponent("Damage", UILabel)
  self.labDPS = self:FindComponent("DPS", UILabel)
  self.sinfolb = self:FindComponent("SkadaInfo", UILabel)
  self.btn = self:FindGO("DetailButton")
  self.btnColl = self.btn:GetComponent(BoxCollider)
  self:AddClickEvent(self.btn, function()
    self:PassEvent(SkadaRankingEvent.ShowDetail, self)
  end)
  self:AddClickEvent(self.gameObject, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end

function SkadaRankingCell:SetData(data, isSelf)
  self.data = data
  self:SetDetailEnable(true)
  self.gameObject:SetActive(true)
  if not data then
    self:SetDetailEnable(false)
    if isSelf then
      data = {
        name = Game.Myself.data.name,
        gender = Game.Myself.data.userdata:Get(UDEnum.SEX),
        baselevel = Game.Myself.data.userdata:Get(UDEnum.ROLELEVEL),
        profession = Game.Myself.data.userdata:Get(UDEnum.PROFESSION),
        hairID = Game.Myself.data.userdata:Get(UDEnum.HAIR),
        headID = Game.Myself.data.userdata:Get(UDEnum.HEAD),
        faceID = Game.Myself.data.userdata:Get(UDEnum.FACE),
        mouthID = Game.Myself.data.userdata:Get(UDEnum.MOUTH),
        bodyID = Game.Myself.data.userdata:Get(UDEnum.BODY),
        eyeID = Game.Myself.data.userdata:Get(UDEnum.EYE),
        haircolor = Game.Myself.data.userdata:Get(UDEnum.HAIRCOLOR)
      }
    else
      self.gameObject:SetActive(false)
      return
    end
  end
  self.ranklb.text = data.rank or 0
  self.noranklb.text = ZhString.BattlePassRankView_norank
  self.ranklb.gameObject:SetActive(data.rank ~= nil)
  self.noranklb.gameObject:SetActive(data.rank == nil)
  self.ranksp.gameObject:SetActive(data.rank ~= nil)
  self.ranksp.CurrentState = data.rank == 1 and 0 or data.rank == 2 and 1 or data.rank == 3 and 2 or 3
  self.gender.CurrentState = data.gender == ProtoCommon_pb.EGENDER_MALE and 0 or 1
  self.namelb.text = data.name
  local proData = Table_Class[data.profession] or Table_Class[1]
  self.lvlb.text = "Lv." .. (data.baselevel or 0)
  self.joblb.text = proData and ProfessionProxy.GetProfessionNameFromSocialData(data) or "-"
  if not data.totalTime then
    self.labFightTime.text = "-"
  else
    local hour, min, sec = ClientTimeUtil.GetHourMinSec(data.totalTime)
    local sb = LuaStringBuilder.CreateAsTable()
    local haveContent = false
    if 0 < hour then
      sb:Append(hour)
      sb:Append("h")
      haveContent = true
    end
    if 0 < min then
      if haveContent then
        sb:Append(" ")
      end
      sb:Append(min)
      sb:Append("min")
      haveContent = true
    end
    if 0 < sec or not haveContent then
      if haveContent then
        sb:Append(" ")
      end
      sb:Append(sec)
      sb:Append("s")
    end
    self.labFightTime.text = sb:ToString()
    sb:Destroy()
  end
  if not data.totalDamage then
    self.labFightDamage.text = "-"
  elseif data.totalDamage < 10000 then
    self.labFightDamage.text = string.format("%.1f", data.totalDamage)
  else
    local millionNum = math.modf(data.totalDamage / 1000000)
    local thousandStr = string.format("%.1f", math.fmod(data.totalDamage, 1000000) / 1000) .. "K"
    self.labFightDamage.text = 0 < millionNum and millionNum .. "M" .. thousandStr or thousandStr
  end
  if not data.averageDamage then
    self.labDPS.text = "-"
  elseif 10000 > data.averageDamage then
    self.labDPS.text = string.format("%.1f", data.averageDamage)
  else
    local millionNum = math.modf(data.averageDamage / 1000000)
    local thousandStr = string.format("%.1f", math.fmod(data.averageDamage, 1000000) / 1000) .. "K"
    self.labDPS.text = 0 < millionNum and millionNum .. "M" .. thousandStr or thousandStr
  end
  local powerConfig = GameConfig.Home and GameConfig.Home.npc_set_reduce
  powerConfig = data.woodDamageReduce and powerConfig[data.woodDamageReduce] and powerConfig[data.woodDamageReduce].value
  if not powerConfig then
    self.sinfolb.text = "-"
  else
    self.sinfolb.text = powerConfig .. "%"
  end
  self:TryInitHeadIcon()
  local headData = Table_HeadImage[data.portrait]
  if data.portrait and data.portrait ~= 0 and headData and headData.Picture then
    self.headIcon:SetSimpleIcon(headData.Picture, headData.Frame)
    self.headIcon:SetPortraitFrame(data.portraitframe)
  else
    data.hairID = data.hairID or data.hair or 1
    data.headID = data.headID or data.head or 1
    data.faceID = data.faceID or data.face or 1
    data.mouthID = data.mouthID or data.mouth or 1
    data.bodyID = data.bodyID or data.body or 1
    data.eyeID = data.eyeID or data.eye or 1
    self.headIcon:SetData(data)
  end
end

function SkadaRankingCell:SetDetailEnable(istrue)
  if istrue then
    self.btnColl.enabled = true
    self:SetTextureWhite(self.btn, ColorUtil.ButtonLabelOrange)
  else
    self.btnColl.enabled = false
    self:SetTextureGrey(self.btn)
  end
end

function SkadaRankingCell:TryInitHeadIcon()
  if self.headIcon ~= nil then
    return
  end
  local headContainer = self:FindGO("HeadContainer")
  self.headIcon = HeadIconCell.new()
  self.headIcon:CreateSelf(headContainer)
  self.headIcon.gameObject:AddComponent(UIDragScrollView)
  self.headIcon:SetScale(0.6)
  self.headIcon:SetMinDepth(1)
  self:SetEvent(self.headIcon.clickObj.gameObject, function()
    self:PassEvent(FriendEvent.SelectHead, self)
  end)
end
