GVGRoadBlockView = class("GVGRoadBlockView", ContainerView)
GVGRoadBlockView.ViewType = UIViewType.PopUpLayer
local MapTexName = "GVG_map"

function GVGRoadBlockView:Init()
  self:AddListenEvt(ServiceEvent.GuildCmdGvgRoadblockQueryGuildCmd, self.OnGuildRoadBlockCmdQuery)
  self:InitData()
  self:FindObjs()
  self:InitView()
end

function GVGRoadBlockView:InitData()
  self.cityId = self.viewdata and self.viewdata.viewdata and self.viewdata.viewdata.cityId
  self.groupId = self.viewdata and self.viewdata.viewdata and self.viewdata.viewdata.groupId
  if self.cityId and self.groupId then
    local info = GvgProxy.Instance:GetRuleGuildInfo(self.cityId, self.groupId)
    self.roadBlock = info and info.roadBlock
  else
    ServiceGuildCmdProxy.Instance:CallGvgRoadblockQueryGuildCmd()
  end
end

function GVGRoadBlockView:FindObjs()
  self:AddButtonEvent("CloseButton", function()
    self:CloseSelf()
  end)
  TipsView.Me():TryShowGeneralHelpByHelpId(530, self:FindGO("HelpButton"))
  self.mapTex = self:FindComponent("MapTex", UITexture)
  self.blockIcon11 = self:FindComponent("blockA1", UIMultiSprite)
  self.blockIcon12 = self:FindComponent("blockA2", UIMultiSprite)
  self.blockIcon21 = self:FindComponent("blockB1", UIMultiSprite)
  self.blockIcon22 = self:FindComponent("blockB2", UIMultiSprite)
  self.blockIcon23 = self:FindComponent("blockB3", UIMultiSprite)
  self.blockIcon31 = self:FindComponent("blockC1", UIMultiSprite)
  self.blockIcon32 = self:FindComponent("blockC2", UIMultiSprite)
  self.tipLabel = self:FindComponent("Tip", UILabel)
end

function GVGRoadBlockView:InitView()
  if self.roadBlock then
    self:RefreshView()
  end
end

function GVGRoadBlockView:RefreshView()
  local mod = self.roadBlock or 0
  for i = 1, 3 do
    local state = mod // 10 ^ (3 - i)
    for j = 1, 3 do
      local sp = self["blockIcon" .. i .. j]
      if sp then
        sp.CurrentState = state == j and 1 or 0
      end
    end
    mod = mod % 10 ^ (3 - i)
  end
  local str = GvgProxy.Instance:IsInRoadBlockActivedTime() and ZhString.GVGRoadBlock_BlockActived or ZhString.GVGRoadBlock_BlockUnactived
  self.tipLabel.text = str
end

function GVGRoadBlockView:OnGuildRoadBlockCmdQuery()
  self.roadBlock = GvgProxy.Instance:GetMyGuildRoadBlock()
  self:RefreshView()
end

function GVGRoadBlockView:OnEnter()
  PictureManager.Instance:SetRoadBlockTexture(MapTexName, self.mapTex)
end

function GVGRoadBlockView:OnExit()
  PictureManager.Instance:UnloadRoadBlockTexture(MapTexName, self.mapTex)
end
