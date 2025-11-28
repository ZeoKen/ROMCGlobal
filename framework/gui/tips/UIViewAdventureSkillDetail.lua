autoImport("FunctionNewRecharge")
UIViewAdventureSkillDetail = class("UIViewAdventureSkillDetail", BaseTip)
local _singleLineHeight = 24
local _maxBgHeight = 558
local _minBgHeight = 458

function UIViewAdventureSkillDetail:Init()
  self:GetGameObjects()
  self:RegisterButtonClickEvent()
  self:Tutorial()
end

function UIViewAdventureSkillDetail:SetData(data)
  self.tipData = data
  self:InitializeModelSet()
  self:LoadView()
end

function UIViewAdventureSkillDetail:GetGameObjects()
  self.goIcon = self:FindGO("Icon")
  self.spIcon = self.goIcon:GetComponent(UISprite)
  self.goName = self:FindGO("Name")
  self.labName = self.goName:GetComponent(UILabel)
  self.goType = self:FindGO("Type")
  self.labType = self.goType:GetComponent(UILabel)
  self.goDescription = self:FindGO("Description")
  self.labDescription = self.goDescription:GetComponent(UILabel)
  self.goCondition = self:FindGO("Condition")
  self.goPreSkill = self:FindGO("PreSkill", self.goCondition)
  self.goPreSkillValue = self:FindGO("Value", self.goPreSkill)
  self.labPreSkillValue = self.goPreSkillValue:GetComponent(UILabel)
  self.goRequireAdventureLevel = self:FindGO("RequireAdventureLevel", self.goCondition)
  self.labRequireAdventureLevel = self.goRequireAdventureLevel:GetComponent(UILabel)
  self.goCurrency = self:FindGO("Currency")
  self.labCurrency = self:FindGO("Lab", self.goCurrency):GetComponent(UILabel)
  self.spCurrency = self:FindGO("Icon", self.goCurrency):GetComponent(UISprite)
  IconManager:SetItemIcon(Table_Item[100].Icon, self.spCurrency)
  self.goButtonCancel = self:FindGO("ButtonCancel")
  self.goButtonLearn = self:FindGO("ButtonLearn")
  self.learnSp = self:FindComponent("ButtonLearn", UISprite)
  self.labButtonLearnTitle = self:FindComponent("Title", UILabel, self.learnSp.gameObject)
  self.frameBg = self:FindComponent("FrameBg", UISprite)
  self.sv = self:FindComponent("DetailScrollView", UIScrollView)
  self:AddAnchor(self:FindComponent("ButtomRoot", UIWidget))
  self:AddAnchor(self:FindComponent("DetailPart", UIWidget))
  self:AddAnchor(self.labPreSkillValue)
end

function UIViewAdventureSkillDetail:LoadView()
  self.labName.text = self.skillConf.NameZh
  IconManager:SetSkillIcon(self.skillConf.Icon, self.spIcon)
  self.labType.text = ZhString.AdventureSkill_AdventureSkill .. "(" .. GameConfig.SkillType[self.skillConf.SkillType].name .. ")"
  local skillConfDescFieldValue = self.skillConf.Desc
  if skillConfDescFieldValue ~= nil and not table.IsEmpty(skillConfDescFieldValue) then
    local skillDescriptionID = skillConfDescFieldValue[1].id
    local skillDescriptionConf = Table_SkillDesc[skillDescriptionID]
    if skillDescriptionConf == nil then
      LogUtility.Error(string.format("Can't find configure(%s) in SkillDesc.xlsx", skillDescriptionID))
    else
      local params = skillConfDescFieldValue[1].params
      self.labDescription.text = string.format(skillDescriptionConf.Desc, unpack(params))
    end
  end
  local skillConfConditionFieldValue = self.skillConf.Contidion
  if skillConfConditionFieldValue ~= nil and not table.IsEmpty(skillConfConditionFieldValue) then
    local suffix, skillid
    local sb = LuaStringBuilder.CreateAsTable()
    for i = 1, SkillItemData.ConditionSkillCount do
      suffix = i == 1 and "" or i
      skillid = skillConfConditionFieldValue["skillid" .. suffix]
      if skillid ~= nil then
        local preSkillConf = Table_Skill[skillid]
        if preSkillConf ~= nil then
          if i ~= 1 then
            sb:Append("/")
          end
          sb:Append(OverSea.LangManager.Instance():GetLangByKey(preSkillConf.NameZh))
        end
      end
    end
    self.labPreSkillValue.text = sb:GetCount() == 0 and ZhString.MonsterTip_None or sb:ToString()
    sb:Destroy()
  else
    LogUtility.Error(string.format("Field(Contidion, %d) in Skill.xlsx is illegal.", tostring(self.skillConf.id)))
  end
  local requireAdventureLevel = UIModelAdventureSkill.Instance():GetSkillRequireAppellation(self.skillShopItemData.id)
  requireAdventureLevel = requireAdventureLevel or 0
  if requireAdventureLevel ~= nil and requireAdventureLevel then
    self.labRequireAdventureLevel.text = string.format(ZhString.AdventureSkill_AdventureLevelCanLearn, Table_Appellation[requireAdventureLevel] and Table_Appellation[requireAdventureLevel].Name or "")
  else
  end
  local strNeedCurrency = FunctionNewRecharge.FormatMilComma(self.needCurrency)
  if strNeedCurrency ~= nil then
    self.labCurrency.text = strNeedCurrency
  end
  if self.isReachEnoughAdventureLevelForLearn then
    self:EnableButtonLearn()
  else
    self:DisableButtonLearn()
  end
  local delta = self.labDescription.height - _singleLineHeight
  self.frameBg.height = math.clamp(_minBgHeight + delta, _minBgHeight, _maxBgHeight)
  self.sv:ResetPosition()
  self:UpdateAnchor()
end

function UIViewAdventureSkillDetail:AddAnchor(widget)
  if nil == self.anchors then
    self.anchors = {}
  end
  self.anchors[#self.anchors + 1] = widget
end

function UIViewAdventureSkillDetail:UpdateAnchor()
  if self.anchors then
    for i = 1, #self.anchors do
      self.anchors[i]:ResetAndUpdateAnchors()
    end
  end
end

function UIViewAdventureSkillDetail:InitializeModelSet()
  self.skillShopItemData = self.tipData.skillShopItemData
  self.skillConf = self.tipData.skillConf
  self.adventureLevelID = UIModelAdventureSkill.Instance():GetAdventureLevel()
  self.needCurrency = self.skillShopItemData.ItemCount
  self.shopItemID = self.skillShopItemData.id
  self.isReachEnoughAdventureLevelForLearn = self.tipData.isReachEnoughAdventureLevelForLearn
end

function UIViewAdventureSkillDetail:RegisterButtonClickEvent()
  self:AddClickEvent(self.goButtonCancel, function(go)
    self:OnButtonCancelClick()
  end)
  self:AddClickEvent(self.learnSp.gameObject, function(go)
    self:OnButtonLearnClick()
  end)
end

function UIViewAdventureSkillDetail:OnButtonCancelClick()
  TipsView.Me():HideCurrent()
end

function UIViewAdventureSkillDetail:OnButtonLearnClick()
  if self.buttonLearrnIsEnable and self:IsHaveEnoughCostForLearn() and not self.skillShopItemData:CheckCanRemove() then
    self:RequestLearnSkill()
  end
end

function UIViewAdventureSkillDetail:IsHaveEnoughCostForLearn()
  local rob = MyselfProxy.Instance:GetROB()
  if rob < self.needCurrency then
    local sysMsgID = 1
    MsgManager.ShowMsgByID(sysMsgID)
    TipsView.Me():HideCurrent()
    return false
  else
    return true
  end
end

function UIViewAdventureSkillDetail:RequestLearnSkill()
  ServiceSessionShopProxy.Instance:CallBuyShopItem(self.shopItemID, 1)
end

function UIViewAdventureSkillDetail:DisableButtonLearn()
  self.learnSp.color = Color(0.00392156862745098, 0.00784313725490196, 0.011764705882352941, 1)
  self.labButtonLearnTitle.effectColor = Color(0.29411764705882354, 0.29411764705882354, 0.29411764705882354, 1)
  self.buttonLearrnIsEnable = false
end

function UIViewAdventureSkillDetail:EnableButtonLearn()
  self.learnSp.color = Color(1.0, 1.0, 1.0, 1)
  self.labButtonLearnTitle.effectColor = Color(0.5843137254901961, 0.24705882352941178, 0 / 255, 1)
  self.buttonLearrnIsEnable = true
end

function UIViewAdventureSkillDetail:Tutorial()
  self:AddOrRemoveGuideId(self.goButtonLearn)
  self:AddOrRemoveGuideId(self.goButtonLearn, 38)
end
