autoImport("WarbandHeadCell")
WarbandRankSubView = class("WarbandRankSubView", SubView)
local view_Path = ResourcePathHelper.UIView("WarbandRankSubView")
local Texture_Name = "12pvp_bg_pic_Ranking"

function WarbandRankSubView:OnEnter()
  WarbandRankSubView.super.OnEnter(self)
  WarbandProxy.Instance:DoQuerySeasonRank()
end

function WarbandRankSubView:Init()
  self:_loadPrafab()
  self:FindObjs()
  self:UpdateView()
  self:AddEvts()
end

function WarbandRankSubView:AddEvts()
  self:AddListenEvt(ServiceEvent.MatchCCmdTwelveWarbandSortMatchCCmd, self.UpdateView)
  self:AddListenEvt(ServiceEvent.MatchCCmdTwelveWarbandQueryMatchCCmd, self.HandleQueryMember)
end

function WarbandRankSubView:HandleQueryMember()
  local mdata = WarbandProxy.Instance.memberinfoData
  TipManager.Instance:ShowWarbandMemberTip(mdata)
end

function WarbandRankSubView:FindObjs()
  self.rankRoot = self:FindGO("RankRoot")
  self.texture = self:FindComponent("Texture", UITexture, self.rankRoot)
  self.scheduleLab = self:FindComponent("ScheduleLab", UILabel, self.objRoot)
  self.seasonRankBtn = self:FindGO("SeasonRank", self.objRoot)
  self.seasonRankBtn_Icon = self.seasonRankBtn:GetComponent(UISprite)
  self.seasonRankBtn_Label = self:FindGO("Label", self.seasonRankBtn):GetComponent(UILabel)
  self.seasonRankBtn_boxCollider = self.seasonRankBtn:GetComponent(BoxCollider)
  self.emptyTip = self:FindComponent("EmptyTip", UILabel, self.objRoot)
  self.emptyTip.text = ZhString.Warband_Empty_NoSeason
  self:AddClickEvent(self.seasonRankBtn, function(go)
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.WarbandSeasonRankPopUp
    })
  end)
  self:InitHead()
  PictureManager.Instance:SetPVP(Texture_Name, self.texture)
end

function WarbandRankSubView:_loadPrafab()
  self.objRoot = self:FindGO("WarbandRankSubView")
  local obj = self:LoadPreferb_ByFullPath(view_Path, self.objRoot, true)
  obj.name = "RankSubView"
end

function WarbandRankSubView:InitHead()
  self.champtionHeadCell = {}
  for i = 1, 4 do
    local portraitRoot = self:FindGO("Portrait" .. i, self.rankRoot)
    local obj = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell("WarbandHeadCell"))
    obj.transform:SetParent(portraitRoot.transform)
    obj.transform.localPosition = LuaGeometry.GetTempVector3()
    obj.transform.localScale = LuaGeometry.GetTempVector3(1, 1, 1)
    obj.transform.localRotation = LuaGeometry.GetTempQuaternion()
    self.champtionHeadCell[i] = WarbandHeadCell.new(obj)
    self.champtionHeadCell[i]:AddEventListener(MouseEvent.MouseClick, self.OnClickHead, self)
  end
end

function WarbandRankSubView:OnClickHead(ctl)
  local data = ctl and ctl.data
  if data then
    ServiceMatchCCmdProxy.Instance:CallTwelveWarbandQueryMatchCCmd(data.season, data.id)
  end
end

function WarbandRankSubView:UpdateView()
  local data = WarbandProxy.Instance:GetLastSeasonRank()
  if data then
    self.rankRoot:SetActive(true)
    self.champtionHeadCell[1]:SetData(WarbandProxy.Instance:GetLastSeasonRankByRank(2))
    self.champtionHeadCell[2]:SetData(WarbandProxy.Instance:GetLastSeasonRankByRank(1))
    local rank3Array = WarbandProxy.Instance:GetLastSeasonRankByRank(3)
    self.champtionHeadCell[3]:SetData(rank3Array[1])
    self.champtionHeadCell[4]:SetData(rank3Array[2])
    self.emptyTip.gameObject:SetActive(false)
    self.scheduleLab.text = ZhString.Warband_SeaonNoOpen
    self.seasonRankBtn_Icon.spriteName = "com_btn_1"
    self.seasonRankBtn_boxCollider.enabled = true
  else
    self.emptyTip.gameObject:SetActive(true)
    self.rankRoot:SetActive(false)
    self.scheduleLab.text = ZhString.Warband_Reward_Empty
    self.seasonRankBtn_Icon.spriteName = "com_btn_13"
    self.seasonRankBtn_Label.effectColor = Color.gray
    self.seasonRankBtn_boxCollider.enabled = false
  end
end
