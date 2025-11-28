local BaseCell = autoImport("BaseCell")
ComodoBossHeadCell = class("ComodoBossHeadCell", BossHeadCell)
local HPColor = LuaColor(1, 0.4117647058823529, 0.4117647058823529)
local SanityColor = LuaColor(1, 0.6431372549019608, 0.40784313725490196)

function ComodoBossHeadCell:Init()
  self.hpProgress = self:FindGO("HPProgress"):GetComponent(UISlider)
  self.forebg = self:FindGO("forebg"):GetComponent(UISprite)
  self.hpPercent = self:FindGO("hpPercent"):GetComponent(UILabel)
  self.headicon = self:FindGO("SimpleHeadIcon"):GetComponent(UISprite)
  self.bossName = self:FindGO("bossName"):GetComponent(UILabel)
  self.clsSp = {}
  local cls1 = self:FindGO("cls1")
  if cls1 then
    self.clsSp[1] = cls1:GetComponent(UISprite)
  end
  local cls2 = self:FindGO("cls2")
  if cls2 then
    self.clsSp[2] = cls2:GetComponent(UISprite)
  end
  self.bossName.text = ""
  self:AddCellClickEvent()
end

function ComodoBossHeadCell:SetData(data)
  if data then
    self.bossGuid = data.guid
    self.staticID = data.staticID
    local class = data.class
    local bossConfig = Table_Monster[self.staticID]
    IconManager:SetFaceIcon(bossConfig.Icon, self.headicon)
    self.headicon:SetMaskPath(UIMaskConfig.SimpleHeadMask)
    self.headicon.OpenMask = true
    self.headicon.OpenCompress = false
    self.headicon.NeedOffset2 = false
    local classid = 0
    if class then
      for i = 1, #class do
        classid = class[i]
        local config = Table_Class[classid]
        if config and config.icon and self.clsSp[i] then
          IconManager:SetNewProfessionIcon(config.icon, self.clsSp[i])
          self.clsSp[i].gameObject:SetActive(true)
        end
      end
      self.bossName.text = ""
    else
      self.bossName.text = bossConfig.NameZh
      for i = 1, #self.clsSp do
        self.clsSp[i].gameObject:SetActive(false)
      end
    end
    if data.phase ~= FuBenCmd_pb.ECOMODO_PHASE_SAVE_NPC then
      self:UpdateHP(self.bossGuid)
      self.forebg.color = HPColor
    else
      self:UpdateBuff(0)
      self.forebg.color = SanityColor
    end
    self.maxLayer = data.maxLayer or 100
    self.gameObject:SetActive(true)
  else
    self.gameObject:SetActive(false)
  end
end

function ComodoBossHeadCell:UpdateHP(bossguid)
  if bossguid ~= self.bossGuid then
    return
  end
  local bossCreature = NSceneNpcProxy.Instance:Find(self.bossGuid)
  if bossCreature ~= nil then
    local props = bossCreature.data.props
    local value = props:GetPropByName("Hp"):GetValue() / props:GetPropByName("MaxHp"):GetValue()
    self.hpProgress.value = value
    self.hpPercent.text = string.format("[c][FF6969]%d%%[-][/c]", value * 100)
  else
    self.hpProgress.value = 0
    self.hpPercent.text = "[c][FF6969]0%[-][/c]"
  end
end

function ComodoBossHeadCell:UpdateBuff(bufflayer)
  if not self.maxLayer then
    return
  end
  local layer = bufflayer or 0
  local value = layer / self.maxLayer
  self.hpProgress.value = value
  self.hpPercent.text = string.format("[c][FFA468]%d%%[-][/c]", value * 100)
end
