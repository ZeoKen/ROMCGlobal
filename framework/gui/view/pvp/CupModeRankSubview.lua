autoImport("WarbandHeadCell")
CupModeRankSubview = class("CupModeRankSubview", SubView)
local viewPath = ResourcePathHelper.UIView("CupModeRankSubview")
local textureName = "12pvp_bg_pic_Ranking"
local viewName = "CupModeRankSubview"

function CupModeRankSubview:OnEnter()
  CupModeRankSubview.super.OnEnter(self)
  CupMode6v6Proxy.Instance:DoQuerySeasonRank()
end

function CupModeRankSubview:OnDestroy()
  CupModeRankSubview.super.OnDestroy(self)
  PictureManager.Instance:UnLoadPVP(textureName, self.texture)
end

function CupModeRankSubview:Init()
  self:FindObjs()
  self:AddBtnEvts()
  self:AddEvts()
  self:InitShow()
end

function CupModeRankSubview:LoadSubviews()
  self.rootGO = self:FindGO("CupModeRankSubview", self.gameObject)
  local obj = self:LoadPreferb_ByFullPath(viewPath, self.rootGO, true)
  obj.name = "CupModeRankSubview"
end

function CupModeRankSubview:FindObjs()
  self:LoadSubviews()
  self.rankRoot = self:FindGO("CupModeRankRoot", self.rootGO)
  self.texture = self:FindComponent("Texture", UITexture, self.rankRoot)
  self.scheduleLab = self:FindComponent("ScheduleLab", UILabel, self.rootGO)
  self.seasonRankBtnGO = self:FindGO("SeasonRank", self.rootGO)
  self.seasonRankBtnGO_Icon = self.seasonRankBtnGO:GetComponent(UISprite)
  self.seasonRankBtnGO_Label = self:FindGO("Label", self.seasonRankBtnGO):GetComponent(UILabel)
  self.seasonRankBtnGO_boxCollider = self.seasonRankBtnGO:GetComponent(BoxCollider)
  self.emptyTip = self:FindComponent("EmptyTip", UILabel, self.rootGO)
  self.emptyTip.text = ZhString.Warband_Empty_NoSeason
end

function CupModeRankSubview:AddBtnEvts()
  self:AddClickEvent(self.seasonRankBtnGO, function(go)
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.CupModeRankPopup,
      viewdata = {
        proxy = CupMode6v6Proxy.Instance,
        crossServer = false
      }
    })
  end)
end

function CupModeRankSubview:AddEvts()
  self:AddListenEvt(CupModeEvent.Sort_6v6, self.UpdateView)
  self:AddListenEvt(CupModeEvent.QueryBand_6v6, self.HandleQueryMember)
end

function CupModeRankSubview:InitShow()
  PictureManager.Instance:SetPVP(textureName, self.texture)
  self:InitHead()
  self:UpdateView()
end

function CupModeRankSubview:HandleQueryMember(note)
  local data = note.body
  local season = data and data.season
  if season < 10000 then
    local proxy = CupMode6v6Proxy.Instance
    TipManager.Instance:ShowTeamMemberTip({
      memberData = proxy.memberinfoData,
      teamName = proxy.memberinfoTeamName
    })
  end
end

function CupModeRankSubview:InitHead()
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

function CupModeRankSubview:OnClickHead(ctl)
  local data = ctl and ctl.data
  if data then
    CupMode6v6Proxy.Instance:DoQueryBand(data.season, data.id)
  end
end

function CupModeRankSubview:UpdateView()
  local proxy = CupMode6v6Proxy.Instance
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
