autoImport("WarbandRankSubView")
WarbandRankSubView_MultiServer = class("WarbandRankSubView_MultiServer", WarbandRankSubView)
local view_Path = ResourcePathHelper.UIView("WarbandRankSubView")
local Texture_Name = "12pvp_bg_pic_Ranking"

function WarbandRankSubView_MultiServer:OnEnter()
  WarbandRankSubView_MultiServer.super.super.OnEnter(self)
  WarbandProxy_MultiServer.Instance:DoQuerySeasonRank()
end

function WarbandRankSubView_MultiServer:_loadPrafab()
  self.objRoot = self:FindGO("WarbandRankSubView_MultiServer")
  local obj = self:LoadPreferb_ByFullPath(view_Path, self.objRoot, true)
  obj.name = "RankSubView_MultiServer"
end

function WarbandRankSubView_MultiServer:HandleQueryMember(note)
  local data = note.body
  local season = data and data.season
  if season and 10000 < season then
    local mdata = WarbandProxy_MultiServer.Instance.memberinfoData
    TipManager.Instance:ShowWarbandMemberTip(mdata)
  end
end

function WarbandRankSubView_MultiServer:UpdateView()
  local data = WarbandProxy_MultiServer.Instance:GetLastSeasonRank()
  if data then
    self.rankRoot:SetActive(true)
    self.champtionHeadCell[1]:SetData(WarbandProxy_MultiServer.Instance:GetLastSeasonRankByRank(2))
    self.champtionHeadCell[2]:SetData(WarbandProxy_MultiServer.Instance:GetLastSeasonRankByRank(1))
    local rank3Array = WarbandProxy_MultiServer.Instance:GetLastSeasonRankByRank(3)
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
