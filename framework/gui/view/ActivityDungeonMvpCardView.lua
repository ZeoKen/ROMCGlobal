ActivityDungeonMvpCardView = class("ActivityDungeonMvpCardView", SubView)
local Prefab_Path = ResourcePathHelper.UIView("ActivityDungeonMvpCardView")
local LoadingName = "card_loading"

function ActivityDungeonMvpCardView:Init()
  self:InitData()
  self:LoadPrefab()
  self:FindObjs()
  self.tipData = {}
  self.tipData.funcConfig = {}
end

function ActivityDungeonMvpCardView:InitData()
  self.bgName = self.subViewData and self.subViewData.Texture or ""
  self.cardId = self.subViewData and self.subViewData.Item
  if self.cardId then
    self.cardItemData = ItemData.new(self.cardId, self.cardId)
  end
  local config = Table_Card[self.cardId]
  self.cardTexName = config and config.Picture or ""
  self.gotoMode = self.subViewData and self.subViewData.GoToMode
end

function ActivityDungeonMvpCardView:LoadPrefab()
  local obj = self:LoadPreferb_ByFullPath(Prefab_Path, self.container, true)
  obj.name = "ActivityDungeonMvpCardView"
  self.gameObject = obj
end

function ActivityDungeonMvpCardView:FindObjs()
  self.bg = self:FindComponent("BgTexture", UITexture)
  self.cardTex = self:FindComponent("CardTex", UITexture)
  self:AddClickEvent(self.cardTex.gameObject, function()
    self:OnCardClick()
  end)
  self.gotoBtn = self:FindGO("GoToBtn")
  self:AddClickEvent(self.gotoBtn, function()
    FuncShortCutFunc.Me():CallByID(self.gotoMode)
    self.container:CloseSelf()
  end)
  self.titleLabel = self:FindComponent("TitleLabel", UILabel)
  self.titleShadowLabel = self:FindComponent("TitleLabelShadow", UILabel)
  self.timeLabel = self:FindComponent("TimeLabel", UILabel)
  self.descLabel = self:FindComponent("DescLabel", UILabel)
  self.helpBtn = self:FindGO("HelpBtn")
  self.loading = self:FindGO("Loading")
end

function ActivityDungeonMvpCardView:OnEnter(id)
  local staticData = Table_ActivityIntegration[id]
  if staticData then
    self.titleLabel.text = staticData.TitleName
    self.titleShadowLabel.text = staticData.TitleName
    self.descLabel.gameObject:SetActive(not StringUtil.IsEmpty(staticData.Desc))
    self.descLabel.text = staticData.Desc
    local duration = EnvChannel.IsTFBranch() and staticData.TFDuration or staticData.Duration
    self.timeLabel.gameObject:SetActive(duration ~= nil)
    if duration then
      local startTimeStr, endTimeStr = duration[1], duration[2]
      local startTime = ClientTimeUtil.GetOSDateTime(startTimeStr)
      local endTime = ClientTimeUtil.GetOSDateTime(endTimeStr)
      local curTime = ServerTime.CurServerTime() / 1000
      if startTime <= curTime then
        TimeTickManager.Me():CreateTick(0, 1000, function()
          self:RefreshRemainTime(endTime)
        end, self)
      else
        self.timeLabel.text = ZhString.RememberLoginView_OntimeEnd
      end
    end
    self:RegistShowGeneralHelpByHelpID(staticData.HelpID, self.helpBtn)
  end
  PictureManager.Instance:SetUI(self.bgName, self.bg)
  self:SetCardTex()
end

function ActivityDungeonMvpCardView:OnExit()
  TimeTickManager.Me():ClearTick(self)
  if self.assetname ~= nil then
    Game.AssetLoadEventDispatcher:RemoveEventListener(self.assetname, self.LoadPicComplete, self)
    self.assetname = nil
  end
  PictureManager.Instance:UnLoadUI(self.bgName, self.bg)
  PictureManager.Instance:UnLoadCard(self.cardTexName, self.cardTex)
  PictureManager.Instance:UnLoadCard(LoadingName, self.cardTex)
end

function ActivityDungeonMvpCardView:OnCardClick()
  if self.cardItemData then
    self.tipData.itemdata = self.cardItemData
    self:ShowItemTip(self.tipData, self.cardTex, NGUIUtil.AnchorSide.Right, {220, 0})
  end
end

function ActivityDungeonMvpCardView:RefreshRemainTime(endTime)
  local curTime = ServerTime.CurServerTime() / 1000
  local remainTime = endTime - curTime
  if 0 < remainTime then
    local d, h, m, s = ClientTimeUtil.FormatTimeBySec(remainTime)
    if 0 < d then
      self.timeLabel.text = string.format(ZhString.RemainTimeDay, d)
    else
      self.timeLabel.text = string.format(ZhString.MVPFightInfoBord_LeftTime, h, m, s)
    end
  else
    TimeTickManager.Me():ClearTick(self)
    self.timeLabel.text = ZhString.RememberLoginView_OntimeEnd
  end
end

function ActivityDungeonMvpCardView:SetCardTex()
  if self.cardTexName then
    local _AssetLoadEventDispatcher = Game.AssetLoadEventDispatcher
    local assetname = _AssetLoadEventDispatcher:AddRequestUrl(ResourcePathHelper.ResourcePath(PictureManager.Config.Pic.Card .. self.cardTexName))
    if self.assetname ~= nil and self.assetname ~= assetname then
      _AssetLoadEventDispatcher:RemoveEventListener(self.assetname, self.LoadPicComplete, self)
    end
    self.assetname = assetname
    if assetname ~= nil then
      _AssetLoadEventDispatcher:AddEventListener(assetname, self.LoadPicComplete, self)
      PictureManager.Instance:SetCard(LoadingName, self.cardTex)
    else
      PictureManager.Instance:SetCard(self.cardTexName, self.cardTex)
    end
    self.loading:SetActive(assetname ~= nil)
  end
end

function ActivityDungeonMvpCardView:LoadPicComplete(args)
  if args.success then
    self.loading:SetActive(false)
    PictureManager.Instance:SetCard(self.cardTexName, self.cardTex)
  end
end
