local BaseCell = autoImport("BaseCell")
ProfessionIconCell = class("ProfessionIconCell", BaseCell)
ProfessionIconCell.AttrLightColor = Color(0.17254901960784313, 0.39215686274509803, 0.9215686274509803)

function ProfessionIconCell.CreateNew(jobid, gameobj)
  local obj = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell("ProfessionIconCell"), gameobj)
  obj.transform.localPosition = LuaGeometry.GetTempVector3(0, 0, 0)
  local pCell = ProfessionIconCell.new(obj)
  pCell:SetIcon(jobid)
  pCell:Setid(jobid)
  return pCell
end

function ProfessionIconCell:Init()
  self:initView()
  self:initData()
end

function ProfessionIconCell:initData()
  self.isSelected = true
  self:setIsSelected(false)
end

function ProfessionIconCell:setIsSelected(isSelected)
  if isSelected ~= self.isSelected then
    self.isSelected = isSelected
  end
  if isSelected then
    self.mark.gameObject:SetActive(true)
    ProfessionProxy.Instance:SetTopScrollChooseID(self:Getid())
  else
    self.mark.gameObject:SetActive(false)
  end
end

function ProfessionIconCell:initView()
  self.Node = self:FindGO("Node")
  self.ProfessIcon = self:FindGO("ProfessIcon", self.Node)
  self.CostedPointBg = self:FindGO("CostedPointBg", self.Node)
  self.CostedPointBg_Sprite = self.CostedPointBg:GetComponent(UISprite)
  self.CostedPointLabel = self:FindGO("CostedPointLabel", self.CostedPointBg)
  self.AttrLabel = self:FindGO("AttrLabel", self.CostedPointBg)
  self.CareerBg = self:FindGO("CareerBg", self.Node)
  self.CareerBord = self:FindGO("CareerBord", self.CareerBg)
  self.Plus = self:FindGO("Plus", self.Node)
  self.mark = self:FindGO("mark")
  self.ProfessIcon_UISprite = self.ProfessIcon:GetComponent(UISprite)
  self.CostedPointLabel_UILabel = self.CostedPointLabel:GetComponent(UILabel)
  self.AttrLabel_UILabel = self.AttrLabel:GetComponent(UILabel)
  self.CareerBg_UISprite = self.CareerBg:GetComponent(UISprite)
  self.mark.gameObject:SetActive(false)
end

function ProfessionIconCell:SetShowType(mType)
  if mType == 1 then
    self.CostedPointBg.gameObject:SetActive(false)
    self.CareerBg.gameObject:SetActive(false)
    self.Plus.gameObject:SetActive(false)
  elseif mType == 2 then
    self.CostedPointBg.gameObject:SetActive(true)
    self.CareerBg.gameObject:SetActive(true)
    if ProfessionProxy.Instance:IsMPOpen() then
      self.Plus.gameObject:SetActive(true)
    else
      self.Plus.gameObject:SetActive(false)
    end
  else
    if mType == 3 then
      self.Plus:SetActive(false)
      self.AttrLabel:SetActive(false)
    else
    end
  end
end

function ProfessionIconCell:addViewEventListener()
end

local tempColor = LuaColor.white

function ProfessionIconCell:SetData(data)
  self.data = data
  if self.data ~= nil then
    IconManager:SetProfessionIcon(Table_Class[self.data.id].icon, self.ProfessIcon_UISprite)
    self.ProfessIcon_UISprite.color = LuaColor(0.00392156862745098, 0.00784313725490196, 0.011764705882352941, 1)
    if data.isGrey == true then
      self.ProfessIcon_UISprite.color = LuaColor(0.00392156862745098, 0.00784313725490196, 0.011764705882352941, 1)
    else
      self.ProfessIcon_UISprite.color = LuaColor(1, 1, 1, 1)
    end
    self:AddClickEvent(self.ProfessIcon, function()
      self:PassEvent(MouseEvent.MouseClick, self)
    end)
  else
    helplog("review code !!")
  end
end

function ProfessionIconCell:initHead()
end

function ProfessionIconCell:SetIcon(id)
  local thisidClass = Table_Class[id]
  local iconName = "icon_1_0"
  if id == 1 then
    iconName = "icon_1_0"
  else
    iconName = thisidClass.icon
  end
  local thisidType = thisidClass.Type
  local colorKey = "CareerIconBg" .. thisidType
  if colorKey and ColorUtil[colorKey] then
    self.CareerBg_UISprite.color = ColorUtil[colorKey]
  else
    helplog("colorKey" .. colorKey .. "不存在")
  end
  IconManager:SetNewProfessionIcon(iconName, self.ProfessIcon_UISprite)
  self.CostedPointLabel_UILabel.text = ProfessionProxy.GetProfessionName(id, MyselfProxy.Instance:GetMySex())
  local printedX = self.CostedPointLabel_UILabel.printedSize.x
  self.CostedPointBg_Sprite.width = 90 < printedX and printedX + 15 or 105
end

function ProfessionIconCell:SetState(state, id)
  self.AttrLabel_UILabel.color = LuaGeometry.GetTempColor(0, 0, 0)
  local PlusNeedShow = false
  self.CostedPointBg_Sprite.spriteName = "skill_bg_line"
  self.CostedPointLabel_UILabel.effectColor = ColorUtil.NGUIWhite
  if state == 0 then
  elseif state == 1 then
    local sprites = UIUtil.GetAllComponentsInChildren(self.ProfessIcon_UISprite, UISprite, true)
    for i = 1, #sprites do
      sprites[i].color = Color(1, 1, 1)
    end
    local thisidType = Table_Class[id].Type
    local colorKey = "CareerIconBg" .. thisidType
    self.CareerBg_UISprite.color = ProfessionProxy.Instance:SafeGetColorFromColorUtil(colorKey)
    self:AddClickEvent(self.ProfessIcon, function()
      self:PassEvent(MouseEvent.MouseClick, id)
    end)
  elseif state == 2 then
  elseif state == 3 then
    local sprites = UIUtil.GetAllComponentsInChildren(self.ProfessIcon_UISprite, UISprite, true)
    for i = 1, #sprites do
      sprites[i].color = Color(0.00392156862745098, 0.00784313725490196, 0.011764705882352941)
    end
    sprites = UIUtil.GetAllComponentsInChildren(self.CareerBg, UISprite, true)
    for i = 1, #sprites do
      sprites[i].color = Color(0.00392156862745098, 0.00784313725490196, 0.011764705882352941)
    end
    PlusNeedShow = true
    self:AddClickEvent(self.Plus.gameObject, function()
      self:PassEvent(CheckAllProfessionPanel.PlusClick, id)
    end)
    self.CostedPointBg_Sprite.spriteName = "skill_bg_line2"
    self.CostedPointLabel_UILabel.effectColor = LuaGeometry.GetTempVector4(1, 0.9568627450980393, 0.8509803921568627, 1)
  elseif state == 4 then
    local sprites = UIUtil.GetAllComponentsInChildren(self.ProfessIcon_UISprite, UISprite, true)
    for i = 1, #sprites do
      sprites[i].color = Color(0.00392156862745098, 0.00784313725490196, 0.011764705882352941)
    end
    sprites = UIUtil.GetAllComponentsInChildren(self.CareerBg, UISprite, true)
    for i = 1, #sprites do
      sprites[i].color = Color(0.00392156862745098, 0.00784313725490196, 0.011764705882352941)
    end
  end
  self.Plus.gameObject:SetActive(PlusNeedShow and ProfessionProxy.Instance:IsMPOpen())
  local attr = GameConfig.ProfessionAttrPlus[id] or ""
  self.state = state
  IconManager:SetNewProfessionIcon(Table_Class[id].icon, self.ProfessIcon_UISprite)
  self:SetAttr(attr)
  if ProfessionProxy.Instance:IsThisIdYiJiuZhi(id) and ProfessionProxy.Instance:IsMPOpen() then
    self.AttrLabel_UILabel.color = ProfessionIconCell.AttrLightColor
  elseif 3 <= id then
    self.AttrLabel_UILabel.color = LuaGeometry.GetTempColor(0, 0, 0, 1)
  else
    self.AttrLabel_UILabel.color = LuaGeometry.GetTempColor(0, 0, 0, 0)
  end
end

function ProfessionIconCell:Setid(id)
  self.id = id
end

function ProfessionIconCell:Getid()
  return self.id or -1
end

function ProfessionIconCell:GetState()
  return self.state or -1
end

function ProfessionIconCell:GetData()
  return self.data
end

function ProfessionIconCell:isShowName(isShow)
end

function ProfessionIconCell:SetAttr(str)
  self.AttrLabel_UILabel.text = str
end

function ProfessionIconCell:SetRecvBuy()
  if self.id == 1 or self.id == 150 then
    self:SetState(1, self.id)
  elseif self.id % 10 >= 3 then
    self:SetState(1, self.id)
  else
    self:SetState(4, self.id)
  end
end
