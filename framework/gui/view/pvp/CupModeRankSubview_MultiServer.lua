autoImport("CupModeRankSubview")
CupModeRankSubview_MultiServer = class("CupModeRankSubview_MultiServer", CupModeRankSubview)
local viewPath = ResourcePathHelper.UIView("CupModeRankSubview")
local textureName = "12pvp_bg_pic_Ranking"
local viewName = "CupModeRankSubview"

function CupModeRankSubview_MultiServer:OnEnter()
  CupModeRankSubview.super.OnEnter(self)
  CupMode6v6Proxy_MultiServer.Instance:DoQuerySeasonRank()
end

function CupModeRankSubview_MultiServer:LoadSubviews()
  self.rootGO = self:FindGO("CupModeRankSubview_MultiServer")
  local obj = self:LoadPreferb_ByFullPath(viewPath, self.rootGO, true)
  obj.name = "CupModeRankSubview_MultiServer"
end

function CupModeRankSubview_MultiServer:AddBtnEvts()
  self:AddClickEvent(self.seasonRankBtnGO, function(go)
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.CupModeRankPopup,
      viewdata = {
        proxy = CupMode6v6Proxy_MultiServer.Instance,
        crossServer = true
      }
    })
  end)
end

function CupModeRankSubview_MultiServer:HandleQueryMember(note)
  local data = note.body
  local season = data and data.season
  if 10000 < season then
    local proxy = CupMode6v6Proxy_MultiServer.Instance
    TipManager.Instance:ShowTeamMemberTip({
      memberData = proxy.memberinfoData,
      teamName = proxy.memberinfoTeamName
    })
  end
end

function CupModeRankSubview_MultiServer:OnClickHead(ctl)
  local data = ctl and ctl.data
  if data then
    CupMode6v6Proxy_MultiServer.Instance:DoQueryBand(data.season, data.id)
  end
end

function CupModeRankSubview_MultiServer:UpdateView()
  local proxy = CupMode6v6Proxy_MultiServer.Instance
  local data = proxy:GetLastSeasonRank()
  if data then
    self.rankRoot:SetActive(true)
    self.champtionHeadCell[1]:SetData(proxy:GetLastSeasonRankByRank(2))
    self.champtionHeadCell[2]:SetData(proxy:GetLastSeasonRankByRank(1))
    local rank3Array = proxy:GetLastSeasonRankByRank(3)
    self.champtionHeadCell[3]:SetData(rank3Array[1])
    self.champtionHeadCell[4]:SetData(rank3Array[2])
    self.emptyTip.gameObject:SetActive(false)
    self.scheduleLab.text = ZhString.Warband_SeaonNoOpen
    self.seasonRankBtnGO_Icon.spriteName = "com_btn_1"
    self.seasonRankBtnGO_boxCollider.enabled = true
  else
    self.scheduleLab.text = ZhString.Warband_Reward_Empty
    self.emptyTip.gameObject:SetActive(true)
    self.rankRoot:SetActive(false)
    self.seasonRankBtnGO_Icon.spriteName = "com_btn_13"
    self.seasonRankBtnGO_Label.effectColor = Color.gray
    self.seasonRankBtnGO_boxCollider.enabled = false
  end
end
