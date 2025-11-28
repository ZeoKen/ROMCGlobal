autoImport("HeadIconCell")
UserEquipRecommendCell = class("UserEquipRecommendCell", BaseCell)

function UserEquipRecommendCell:Init()
  self:FindObjs()
end

function UserEquipRecommendCell:FindObjs()
  self:AddCellClickEvent()
  self.headContainer = self:FindGO("HeadContainer")
  self.careerBg = self:FindGO("CareerBg")
  self.profession = self:FindComponent("ProfessionIcon", UISprite)
  self.colorIcon = self:FindComponent("Color", UISprite)
  self.empty = self:FindGO("Empty")
  self.pvp = self:FindGO("pvp")
  self:TryInitHeadIcon()
end

function UserEquipRecommendCell:SetData(data)
  self.data = data
  if data and data ~= BagItemEmptyType.Empty then
    local profession = data:GetProfession()
    local config = Table_Class[profession]
    if config then
      IconManager:SetNewProfessionIcon(config.icon, self.profession)
      local colorKey = "CareerIconBg" .. config.Type
      self.colorIcon.color = ProfessionProxy.Instance:SafeGetColorFromColorUtil(colorKey)
    end
    if self.headIcon then
      local randomUserIcons = GameConfig.PassUserInfo.randomUserIcons
      if randomUserIcons then
        if data.id and data.id > 0 then
          math.randomseed(data.id)
        else
          local props = data.playerData.props
          local prop = props:GetPropByName("Atk")
          local per = props:GetPropByName("AtkPer")
          per = per and per:GetValue() or 0
          local value = prop:GetValue() * (1 + per)
          math.randomseed(value)
        end
        local index = math.random(1, #randomUserIcons)
        local headId = randomUserIcons[index]
        local headConfig = Table_HeadImage[headId]
        if headConfig then
          self.headIcon:SetSimpleIcon(headConfig.Picture)
        end
      end
    end
    self:SetEmpty(false)
    self.pvp:SetActive(data:IsFromPvp())
  else
    self:SetEmpty(true)
  end
end

function UserEquipRecommendCell:TryInitHeadIcon()
  if self.headIcon ~= nil then
    return
  end
  self.headIcon = HeadIconCell.new()
  self.headIcon:CreateSelf(self.headContainer)
  self.headIcon:SetScale(0.6)
  self.headIcon:SetMinDepth(1)
  self.headIcon:DisableBoxCollider(false)
end

function UserEquipRecommendCell:SetEmpty(empty)
  self.empty:SetActive(empty)
  self.careerBg:SetActive(not empty)
  self.headContainer:SetActive(not empty)
end
