autoImport("EquipSuitPreviewData")
EquipBagPreviewProxy = class("EquipBagPreviewProxy", pm.Proxy)
EquipBagPreviewProxy.Instance = nil
EquipBagPreviewProxy.NAME = "EquipBagPreviewProxy"
local _ApplyInvervalSecond = GameConfig.RiskSkill and GameConfig.RiskSkill.applySuitInterval or 60

function EquipBagPreviewProxy:ctor(proxyName, data)
  self.proxyName = proxyName or EquipBagPreviewProxy.NAME
  if EquipBagPreviewProxy.Instance == nil then
    EquipBagPreviewProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end

function EquipBagPreviewProxy:Init()
  self:InitStaticSuitPos()
  self:InitSuit()
end

function EquipBagPreviewProxy:InitStaticSuitPos()
  self.static_suitPosMap = {}
  local config_suitPos = GameConfig.System.equipSuitPos
  if not config_suitPos then
    redlog("未找到换装保存的装备栏位，检查配置GameConfig.System.equipSuitPos")
    return
  end
  for i = 1, #config_suitPos do
    self.static_suitPosMap[config_suitPos[i]] = 1
  end
end

function EquipBagPreviewProxy:InitSuit()
  self.suitMap = {}
  self.suitMenu = {}
  self.suitCount = GameConfig.System and GameConfig.System.equipSuitCount or 3
  for i = 1, self.suitCount do
    table.insert(self.suitMenu, i)
    local data = EquipSuitPreviewData.new(i)
    self.suitMap[i] = data
  end
end

function EquipBagPreviewProxy:IsEmpty(index)
  local suitData = self.suitMap[index]
  return suitData:IsEmpty()
end

function EquipBagPreviewProxy:GetSuitMenu()
  return self.suitMenu
end

function EquipBagPreviewProxy:HandleSuitNtf(suits)
  if suits then
    for i = 1, #suits do
      self:UpdateSuit(suits[i])
    end
  end
end

function EquipBagPreviewProxy:UpdateSuit(magicSuit)
  if not magicSuit then
    return
  end
  local index = magicSuit.index
  local suitData = self.suitMap[index]
  if suitData then
    suitData:Reset(magicSuit.name, magicSuit.suit_pos)
  else
    redlog("------------------后端 MagicSuit index 发送错误： ", index)
  end
end

function EquipBagPreviewProxy:CheckSuitIsSameAsEquipBag(index)
  local suitData = self.suitMap[index]
  local bagSiteMap = BagProxy.Instance.roleEquip.siteMap
  local allSame = true
  for pos, item in pairs(bagSiteMap) do
    if self.static_suitPosMap[pos] and not suitData:IsSame(pos, item.id) then
      allSame = false
      break
    end
  end
  local bagItem
  for suitPos, suitPosData in pairs(suitData.posMap) do
    bagItem = bagSiteMap[suitPos]
    if not bagItem or bagItem.id ~= suitPosData.guid then
      allSame = false
      break
    end
  end
  return allSame
end

function EquipBagPreviewProxy:DoApply(index)
  if self:IsEmpty(index) then
    MsgManager.ShowMsgByID(43212)
    return
  end
  if self:CheckSuitIsSameAsEquipBag(index) then
    MsgManager.ShowMsgByID(43211)
    return
  end
  local curServerTime = ServerTime.CurServerTime() / 1000
  if not self.applySuitTime or curServerTime > self.applySuitTime + _ApplyInvervalSecond then
    ServiceItemProxy.Instance:CallMagicSuitApply(index)
    self.applySuitTime = curServerTime
  else
    MsgManager.ShowMsgByID(43176)
  end
end

function EquipBagPreviewProxy:DoSave(index)
  local roleEquip = BagProxy.Instance.roleEquip
  if roleEquip:IsMagicSuitPosEmpty() then
    MsgManager.ShowMsgByID(43223)
    return
  end
  if self:CheckSuitIsSameAsEquipBag(index) then
    MsgManager.ShowMsgByID(43210)
    return
  end
  ServiceItemProxy.Instance:CallMagicSuitSave(index)
end
