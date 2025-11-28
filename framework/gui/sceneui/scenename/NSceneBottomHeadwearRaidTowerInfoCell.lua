local BaseCell = autoImport("BaseCell")
NSceneBottomHeadwearRaidTowerInfoCell = reusableClass("NSceneBottomHeadwearRaidTowerInfoCell", BaseCell)
NSceneBottomHeadwearRaidTowerInfoCell.PoolSize = 5
NSceneBottomHeadwearRaidTowerInfoCell.ResID = ResourcePathHelper.UIPrefab_Cell("SceneBottomHeadwearRaidTowerInfoCell")
NSceneBottomHeadwearRaidTowerInfoCell.EnableColor = LuaColor.New(1, 1, 1, 1)
NSceneBottomHeadwearRaidTowerInfoCell.DisableColor = LuaColor.New(1, 1, 1, 0.5019607843137255)

function NSceneBottomHeadwearRaidTowerInfoCell:Construct(asArray, args)
  self:DoConstruct(asArray, args)
end

function NSceneBottomHeadwearRaidTowerInfoCell:DoConstruct(asArray, args)
  self._alive = true
  self.gameObject = args[1]
  self.creature = args[2]
  self.npcid = self.creature.data.staticData.id
  self.gameObject.transform.localPosition = LuaGeometry.Const_V3_zero
  self.gameObject.transform.localRotation = LuaGeometry.Const_Qua_identity
  self.gameObject.transform.localScale = LuaGeometry.Const_V3_one
  self:InitView()
  self:UpdateInfo()
end

function NSceneBottomHeadwearRaidTowerInfoCell:Deconstruct()
  if not LuaGameObject.ObjectIsNull(self.gameObject) then
    Game.GOLuaPoolManager:AddToSceneUIPool(NSceneBottomHeadwearRaidTowerInfoCell.ResID, self.gameObject)
  end
  self.cr1 = nil
  self.cr2 = nil
  self.crs = nil
  self.lv = nil
  self.buff = nil
  self.npcid = nil
  self.creature = nil
  self.gameObject = nil
  self._alive = false
end

function NSceneBottomHeadwearRaidTowerInfoCell:Exit()
  TableUtility.TableClear(self)
end

function NSceneBottomHeadwearRaidTowerInfoCell:InitView()
  self.cr1 = self:FindComponent("cr1", Image)
  self.cr2 = self:FindComponent("cr2", Image)
  self.lv = self:FindComponent("lv", Text)
  self.buff = self:FindComponent("buff", Slider)
  self.crs = {
    self.cr1,
    self.cr2
  }
end

function NSceneBottomHeadwearRaidTowerInfoCell:UpdateInfo()
  local info = HeadwearRaidProxy.Instance:GetTowerInfo(self.creature.data.staticData.id)
  self:SetCr(info)
  self:SetLv(info)
  self:SetBuff(info)
end

function NSceneBottomHeadwearRaidTowerInfoCell:SetCr(info)
  for i = 1, #self.crs do
    local itemid = info.crystalInfo[i]
    SpriteManager.SetUISprite("sceneuicom", Table_Item[itemid].Icon, self.crs[i])
    self.crs[i].color = self.EnableColor
  end
  self:UpdateCr(info)
end

function NSceneBottomHeadwearRaidTowerInfoCell:UpdateCr(info)
  if HeadwearRaidProxy.Instance.isActivityRaid then
    self.config = GameConfig.HeadWearActivity
  else
    self.config = GameConfig.HeadWear
  end
  local towerInfo = self.config.tower[info.id]
  for i = 1, #self.crs do
    local itemid = info.crystalInfo[i]
    local hasNum = HeadwearRaidProxy.Instance.crystals[itemid]
    local curNum = info.crystals[itemid]
    local nextLv = info.level + 1
    local needNum = towerInfo.upgrade[nextLv] and towerInfo.upgrade[nextLv][i] or 0
    if needNum <= hasNum + curNum then
      self.crs[i].color = self.EnableColor
    else
      self.crs[i].color = self.DisableColor
    end
  end
end

function NSceneBottomHeadwearRaidTowerInfoCell:SetLv(info)
  self.lv.text = "Lv." .. (info and info.level or "0")
end

function NSceneBottomHeadwearRaidTowerInfoCell:SetBuff(info)
  self.buff.value = self.creature:GetBuffLayer(info.energybuff) / (info.bufflayer or 1)
end
