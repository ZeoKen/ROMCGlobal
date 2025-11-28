local baseCell = autoImport("BaseCell")
GuildFubenGateCell = class("GuildFubenGateCell", baseCell)
local iconBgTex = "guild_script_bg"
local geteIconTex = "guild_script_Entrance"
local whiteBG_Tex = "guild_bg_star"
local yelloweff = Color(0.6196078431372549, 0.33725490196078434, 0 / 255)
local blueEffect = Color(0.11372549019607843, 0.17647058823529413, 0.4627450980392157)
local btnState = {
  "com_btn_13",
  "com_btn_1",
  "com_btn_2"
}
local teammateIMG = {
  "guild_script_teammate1",
  "guild_script_teammate2"
}

function GuildFubenGateCell:Init()
  self:FindObjs()
  self:InitUI()
  self:AddEvts()
end

function GuildFubenGateCell:FindObjs()
  self.gateIcon = self:FindComponent("GateIcon", UITexture)
  self.whiteBg = self:FindComponent("WhiteBg", UITexture)
  self.iconBg = self:FindComponent("IconBg", UITexture)
  self.btn = self:FindComponent("Btn", UISprite)
  self.btnName = self:FindComponent("BtnLab", UILabel)
  self.teammateGrid = self:FindGO("TeammateGrid")
  self.effectRoot = self:FindGO("EffectRoot")
end

function GuildFubenGateCell:InitUI()
  self.bossMap = {}
  local bossgrid = self:FindGO("BossKillGrid")
  for i = 1, 5 do
    local bossSymbol = self:FindGO("BossSymbol" .. i, bossgrid)
    self.bossMap[i] = self:FindGO("Finish", bossSymbol)
  end
end

function GuildFubenGateCell:AddEvts()
  self:AddClickEvent(self.btn.gameObject, function()
    if self.data and self.data.state == Guild_GateState.Lock then
      return
    end
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end

function GuildFubenGateCell:SetData(data)
  self.data = data
  self.gameObject:SetActive(nil ~= data)
  if data then
    PictureManager.Instance:SetGuildBuilding(geteIconTex, self.gateIcon)
    PictureManager.Instance:SetGuildBuilding(whiteBG_Tex, self.whiteBg)
    PictureManager.Instance:SetGuildBuilding(iconBgTex, self.iconBg)
    local numInRaid = GuildProxy.Instance:GetGuildTeamMembermateNumInRaid()
    if 0 < numInRaid then
      self.gateIcon.gameObject:SetActive(false)
      self:EnterRaidOpenGateEff()
      self.btn.spriteName = btnState[3]
      self.btnName.text = ZhString.GuildFubenGateView_Btn_Enter
      self.btnName.effectStyle = UILabel.Effect.Outline
      self.btnName.effectColor = yelloweff
      self.teammateGrid:SetActive(true)
      local teammembernum = 0
      if TeamProxy.Instance:IHaveTeam() then
        teammembernum = #TeamProxy.Instance.myTeam:GetPlayerMemberList(false, true)
      end
      for i = 1, 5 do
        local trans = self.teammateGrid.transform:GetChild(i - 1)
        trans.gameObject:SetActive(i <= teammembernum)
        trans.gameObject:GetComponent(UISprite).spriteName = teammateIMG[1]
      end
      for i = 1, numInRaid do
        self.teammateGrid.transform:GetChild(i - 1).gameObject:GetComponent(UISprite).spriteName = teammateIMG[2]
      end
    else
      self.gateIcon.gameObject:SetActive(true)
      self.btn.spriteName = btnState[2]
      self.btnName.text = ZhString.GuildFubenGateView_Btn_Open
      self.btnName.effectStyle = UILabel.Effect.Outline
      self.btnName.effectColor = blueEffect
      self.teammateGrid:SetActive(false)
      if self.gateEffectPfb then
        self.gateEffectPfb:SetActive(false)
      end
    end
    for i = 1, #self.bossMap do
      self.bossMap[i]:SetActive(i <= data.killedbossnum)
    end
  end
end

function GuildFubenGateCell:EnterRaidOpenGateEff()
  self.gateIcon.gameObject:SetActive(false)
  if not self.gateEffectPfb then
    self.gateEffectPfb = self:LoadPreferb_ByFullPath(ResourcePathHelper.Effect("UI/LabourUnion_Portal"), self.effectRoot)
  end
end

function GuildFubenGateCell:OnDestroy()
  PictureManager.Instance:UnloadGuildBuilding()
end
