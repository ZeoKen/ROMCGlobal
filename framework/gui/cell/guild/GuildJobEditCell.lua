local BaseCell = autoImport("BaseCell")
GuildJobEditCell = class("GuildJobEditCell", BaseCell)
GuildJobEditCell.GuildNameChange = "GuildJobEditCell_GuildNameChange"
GuildJobEditEvent = {
  NameChange = "GuildJobEditCell_GuildNameChange",
  AuthorityChange = "GuildJobEditEvent_AuthorityChange"
}
GuildJobEditType = {
  GuildAuthorityMap.InviteJoin,
  GuildAuthorityMap.KickMember,
  GuildAuthorityMap.EditPicture,
  GuildAuthorityMap.CanBeMercenary,
  GuildAuthorityMap.EditAuth,
  GuildAuthorityMap.GvgCity
}
local MAX_LENGTH = GameConfig.System.guildjob_max or 5

function GuildJobEditCell:Init()
  self.input = self:FindComponent("Input", UIInput)
  self.input_boxcollider = self.input:GetComponent(BoxCollider)
  self.input_sp = self.input:GetComponent(UISprite)
  self.input_sp2 = self:FindComponent("Sprite", UISprite, self.input.gameObject)
  self.authInfoMap = {}
  for i = 1, #GuildJobEditType do
    local authorityType = GuildJobEditType[i]
    if authorityType then
      do
        local authInfo = {}
        authInfo.symbol = self:FindComponent("Auth_" .. authorityType, UISprite)
        authInfo.tog = self:FindComponent("Auth_Tog_" .. authorityType, UIToggle)
        authInfo.value = false
        self.authInfoMap[authorityType] = authInfo
        if not authInfo.tog then
          redlog("[bt] tog not found", authorityType)
        end
        self:AddClickEvent(authInfo.tog.gameObject, function(go)
          if authorityType == GuildAuthorityMap.GvgCity and GvgProxy.Instance:CheckInSettleTime() then
            authInfo.tog.value = not authInfo.tog.value
            MsgManager.ShowMsgByID(2678)
            return
          end
          self:ChangeJobAuth(authorityType, authInfo.tog.value)
        end)
      end
    end
  end
  EventDelegate.Set(self.input.onSubmit, function()
    self:ChangeJobName()
  end)
  self:AddSelectEvent(self.input, function(go, state)
    if state and FunctionUnLockFunc.Me():ForbidInput(ProtoCommon_pb.EFUNCPARAM_RENAME_GUILD_JOBNAME) then
      self.input.isSelected = false
    end
  end)
  UIUtil.LimitInputCharacter(self.input, MAX_LENGTH)
end

function GuildJobEditCell:ChangeJobName()
  local guildProxy = GuildProxy.Instance
  local myGuildData = guildProxy.myGuildData
  local job = self.data.id
  local jobname = self.input.value
  local hasUnvalidStr = false
  if jobname ~= myGuildData:GetJobName(job) then
    local temp = {job = job, name = jobname}
    hasUnvalidStr = FunctionMaskWord.Me():CheckMaskWord(jobname, GameConfig.MaskWord.GuildProfession)
    if hasUnvalidStr then
      MsgManager.ShowMsgByIDTable(2604)
    else
      ServiceGuildCmdProxy.Instance:CallSetGuildOptionGuildCmd(nil, nil, nil, {temp})
    end
  end
end

function GuildJobEditCell:ChangeJobAuth(authorityType, value)
  local job = self.data.id
  if GuildProxy.Instance:CanIEditAuthority(job, authorityType) then
    ServiceGuildCmdProxy.Instance:CallModifyAuthGuildCmd(value, GuildCmd_pb.EMODIFY_AUTH, job, authorityType)
    MsgManager.ShowMsgByIDTable(2963)
  end
end

function GuildJobEditCell:SetData(data)
  self.data = data
  if data then
    data.name = OverSea.LangManager.Instance():GetLangByKey(data.name)
    self.input.value = data.name
    local canEditName = GuildProxy.Instance:CanIDoAuthority(GuildAuthorityMap.SetJobname)
    self.input_boxcollider.enabled = canEditName
    self.input_sp.enabled = canEditName
    self.input_sp2.enabled = canEditName
    self:UpdateAuthorities()
  end
end

function GuildJobEditCell:UpdateAuthorities()
  local proxy = GuildProxy.Instance
  for authorityType, authInfo in pairs(self.authInfoMap) do
    if self.data.id == GuildJobType.Chairman then
      authInfo.tog.gameObject:SetActive(false)
      authInfo.symbol.gameObject:SetActive(true)
      authInfo.symbol.spriteName = "com_icon_check"
      authInfo.symbol:MakePixelPerfect()
    else
      local canedit = proxy:CanIEditAuthority(self.data.id, authorityType)
      local cando = proxy:CanJobDoAuthority(self.data.id, authorityType)
      authInfo.value = cando
      if self.data.id == proxy:GetMyGuildJob() then
        authInfo.tog.gameObject:SetActive(false)
        authInfo.symbol.gameObject:SetActive(true)
        authInfo.symbol.spriteName = authInfo.value and "com_icon_check" or "com_icon_off"
        authInfo.symbol:MakePixelPerfect()
      elseif canedit then
        authInfo.tog.gameObject:SetActive(true)
        authInfo.symbol.gameObject:SetActive(false)
        authInfo.tog.value = cando
      else
        authInfo.tog.gameObject:SetActive(false)
        authInfo.symbol.gameObject:SetActive(true)
        authInfo.symbol.spriteName = authInfo.value and "com_icon_check" or "com_icon_off"
        authInfo.symbol:MakePixelPerfect()
      end
    end
  end
end
