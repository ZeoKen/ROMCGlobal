local BaseCell = autoImport("BaseCell")
TechTreeLevelContentCell = class("TechTreeLevelContentCell", BaseCell)

function TechTreeLevelContentCell:Init()
  TechTreeLevelContentCell.super.Init(self)
  self:FindObjs()
end

function TechTreeLevelContentCell:FindObjs()
  self.widget = self.gameObject:GetComponent(UIWidget)
  self.descLabel = self:FindGO("DescLabel"):GetComponent(UILabel)
  self.itemContainer = self:FindGO("ItemContainer")
  self.itemIcon = self:FindGO("Icon", self.itemContainer):GetComponent(UISprite)
  self.itemCount = self:FindGO("Count", self.itemContainer):GetComponent(UILabel)
  self.commonSymbol = self:FindGO("commonSymbol")
  self.attrIcon = self:FindGO("AttrIcon", self.commonSymbol):GetComponent(UISprite)
  self.questIcon = self:FindGO("QuestIcon", self.commonSymbol):GetComponent(UISprite)
  self.skillIcon = self:FindGO("SkillIcon", self.commonSymbol):GetComponent(UISprite)
  self.goBtn = self:FindGO("goBtn")
  self.rewardEffect = self:FindGO("RewardEffect")
  self.rewardEffect_Tex = self.rewardEffect:GetComponent(UITexture)
  PictureManager.Instance:SetGuildBuilding("guild_bg_star", self.rewardEffect_Tex)
  self:SetEvent(self.goBtn, function()
    if self.questID then
      FuncShortCutFunc.Me():CallByQuestFinishID({
        self.questID
      })
      GameFacade.Instance:sendNotification(UIEvent.CloseUI, UIViewType.NormalLayer)
    end
  end)
  self:AddClickEvent(self.itemIcon.gameObject, function()
    if self.rewardValid then
      local config = Table_TechTreeLevel[self.id]
      if not config then
        return
      end
      local treeid = config.Tree or 3
      xdlog("申请领奖", treeid, self.id)
      TechTreeProxy.CallTechTreeLevelReward(treeid, {
        self.id
      })
    else
      self:sendNotification(UICellEvent.OnCellClicked, {
        itemid = self.itemid
      })
    end
  end)
end

function TechTreeLevelContentCell:SetData(data)
  self.data = data
  self.id = data.id
  local config = Table_TechTreeLevel[self.id]
  if not config then
    redlog("缺配置", self.id)
    return
  end
  self.descLabel.text = config.Desc or "???"
  self.itemContainer:SetActive(false)
  self.commonSymbol:SetActive(false)
  self.goBtn:SetActive(false)
  local params = config.Params
  local queststate = data.queststate
  if queststate == 2 then
    self.goBtn:SetActive(true)
    self.questID = params.finishquest
    return
  elseif queststate == 3 then
    self.descLabel.text = config.Desc
  elseif queststate == 1 then
    self.descLabel.text = OverSea.LangManager.Instance():GetLangByKey(config.Desc) .. ZhString.TechTree_PrequestExist
  end
  if config.Type == 1 then
    self.itemContainer:SetActive(true)
    self.itemid = params and params.itemid
    local str = Table_Item[self.itemid].Icon
    local setSuc = IconManager:SetItemIcon(str, self.itemIcon)
    setSuc = setSuc or IconManager:SetItemIcon("item_45001", self.itemIcon)
    local count = params and params.num
    self.itemCount.text = count
  elseif config.Type == 2 then
    self.commonSymbol:SetActive(true)
    self.questIcon.gameObject:SetActive(true)
    self.attrIcon.gameObject:SetActive(false)
    self.skillIcon.gameObject:SetActive(false)
  elseif config.Type == 3 then
    self.commonSymbol:SetActive(true)
    self.questIcon.gameObject:SetActive(false)
    self.attrIcon.gameObject:SetActive(false)
    self.skillIcon.gameObject:SetActive(true)
  elseif config.Type == 4 then
    self.commonSymbol:SetActive(true)
    self.questIcon.gameObject:SetActive(false)
    self.attrIcon.gameObject:SetActive(true)
    self.skillIcon.gameObject:SetActive(false)
  end
  local awarded = data.awarded
  local achieved = data.achieved
  self.rewardValid = queststate == 0 and achieved and not awarded or false
  self.rewardEffect:SetActive(self.rewardValid)
  self.widget.alpha = awarded and 0.33 or 1
  self:RegisterGuide()
end

function TechTreeLevelContentCell:RefreshStatus(data)
end

function TechTreeLevelContentCell:HandleClickReward(cellCtrl)
end

function TechTreeLevelContentCell:RegisterGuide()
  if self.id == 10011 then
    self:AddOrRemoveGuideId(self.itemIcon.gameObject, 508)
  elseif self.id == 40001 then
    self:AddOrRemoveGuideId(self.itemIcon.gameObject, 482)
  end
end

function TechTreeLevelContentCell:OnDestroy()
  PictureManager.Instance:UnloadGuildBuilding("guild_bg_star", self.rewardEffect_Tex)
end
