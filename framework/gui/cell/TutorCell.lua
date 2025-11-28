autoImport("FriendBaseCell")
local baseCell = autoImport("BaseCell")
TutorCell = class("TutorCell", FriendBaseCell)
local certificate_week_limit = GameConfig.Tutor.certificate_week_limit or 1
local shield_certificate = GameConfig.Tutor.shield_certificate

function TutorCell:Init()
  self:FindObjs()
  self:AddButtonEvt()
  self:InitShow()
end

function TutorCell:FindObjs()
  TutorCell.super.FindObjs(self)
  self.guildIcon = self:FindGO("GuildIcon"):GetComponent(UISprite)
  self.guildName = self:FindGO("GuildName"):GetComponent(UILabel)
  self.emptyGuild = self:FindGO("EmptyGuild")
  self.proficiency = self:FindGO("Proficiency")
  if self.proficiency then
    self.proficiency = self.proficiency:GetComponent(UILabel)
  end
  self.proficiencyProgress = self:FindComponent("Progress", UILabel)
  self.taskDetail = self:FindGO("TaskDetail")
  self.favoriteTip = self:FindGO("FavoriteTip")
  if self.proficiency and self.proficiencyProgress then
    if shield_certificate and shield_certificate == 1 then
      self.proficiency.gameObject:SetActive(false)
      self.proficiencyProgress.gameObject:SetActive(false)
    else
      self.proficiency.gameObject:SetActive(true)
      self.proficiencyProgress.gameObject:SetActive(true)
    end
  end
end

function TutorCell:AddButtonEvt()
  if self.taskDetail ~= nil then
    self:AddClickEvent(self.taskDetail, function()
      self:TaskDetail()
    end)
  end
end

function TutorCell:SetData(data)
  TutorCell.super.SetData(self, data)
  if data then
    self.guid = data.guid
    if data.guildname ~= "" then
      self:SetGuild(true)
      self.guildName.text = data.guildname
      local guildportrait = tonumber(data.guildportrait) or 1
      guildportrait = Table_Guild_Icon[guildportrait] and Table_Guild_Icon[guildportrait].Icon or ""
      IconManager:SetGuildIcon(guildportrait, self.guildIcon)
    else
      self:SetGuild(false)
    end
    if self.proficiency ~= nil then
      local proficiency = data.profic or 0
      if self.proficiency and self.proficiencyProgress then
        self.proficiency.text = ZhString.Tutor_StudentPoint
        self.proficiencyProgress.text = proficiency
      end
    end
    if self.taskDetail ~= nil then
      local ERedSys = SceneTip_pb.EREDSYS_TUTOR_TASK
      local _RedTipProxy = RedTipProxy.Instance
      local isNew = _RedTipProxy:IsNew(ERedSys, data.guid)
      if isNew then
        _RedTipProxy:RegisterUI(ERedSys, self.taskDetail, 8, {0, 0})
      else
        _RedTipProxy:UnRegisterUI(ERedSys, self.taskDetail)
      end
    end
    self:UpdateFavoriteTip()
  end
end

function TutorCell:SetGuild(isActive)
  self.emptyGuild:SetActive(not isActive)
  self.guildIcon.gameObject:SetActive(isActive)
  self.guildName.gameObject:SetActive(isActive)
end

function TutorCell:TaskDetail()
  if self.data then
    local proficiency = self.data.profic or 0
    proficiency = TutorProxy.Instance:GetProficiency(proficiency)
    if proficiency < 100 then
      self:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.TutorTaskView,
        viewdata = self.data.guid
      })
    else
      MsgManager.ShowMsgByID(3246)
    end
    RedTipProxy.Instance:SeenNew(SceneTip_pb.EREDSYS_TUTOR_TASK, self.data.guid)
  end
end

function TutorCell:UpdateFavoriteTip()
  if not self.favoriteTip then
    return
  end
  if FriendProxy.Instance:CheckIsFavorite(self.guid) then
    self.favoriteTip:SetActive(true)
  else
    self.favoriteTip:SetActive(false)
  end
end
