local BaseCell = autoImport("BaseCell")
SceneBottomHeadwearRaidTowerInfoCell = reusableClass("SceneBottomHeadwearRaidTowerInfoCell", BaseCell)
SceneBottomHeadwearRaidTowerInfoCell.ResID = ResourcePathHelper.UICell("SceneBottomHeadwearRaidTowerInfoCell")
local tempVector3 = LuaVector3.Zero()
SceneBottomHeadwearRaidTowerInfoCell.PoolSize = 5
SceneBottomHeadwearRaidTowerInfoCell.EnableColor = LuaColor.New(1, 1, 1, 1)
SceneBottomHeadwearRaidTowerInfoCell.DisableColor = LuaColor.New(1, 1, 1, 0.5019607843137255)

function SceneBottomHeadwearRaidTowerInfoCell:Construct(asArray, args)
  self:DoConstruct(asArray, args)
end

function SceneBottomHeadwearRaidTowerInfoCell:DoConstruct(asArray, args)
  self._alive = true
  self.gameObject = args[1]
  self.creature = args[2]
  self.npcid = self.creature.data.staticData.id
  LuaVector3.Better_Set(tempVector3, 0, 0, 0)
  self.gameObject.transform.localPosition = tempVector3
  self.gameObject.transform.localRotation = LuaGeometry.Const_Qua_identity
  LuaVector3.Better_Set(tempVector3, 1, 1, 1)
  self.gameObject.transform.localScale = tempVector3
  self:InitView()
  self:UpdateInfo()
end

function SceneBottomHeadwearRaidTowerInfoCell:Deconstruct()
  if not LuaGameObject.ObjectIsNull(self.gameObject) then
    Game.GOLuaPoolManager:AddToSceneUIPool(SceneBottomHeadwearRaidTowerInfoCell.ResID, self.gameObject)
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

function SceneBottomHeadwearRaidTowerInfoCell:Exit()
  TableUtility.TableClear(self)
end

function SceneBottomHeadwearRaidTowerInfoCell:InitView()
  self.cr1 = self:FindComponent("cr1", UISprite)
  self.cr2 = self:FindComponent("cr2", UISprite)
  self.lv = self:FindComponent("lv", UILabel)
  self.buff = self:FindComponent("buff", UISlider)
  self.crs = {
    self.cr1,
    self.cr2
  }
end

function SceneBottomHeadwearRaidTowerInfoCell:UpdateInfo()
  local info = HeadwearRaidProxy.Instance:GetTowerInfo(self.creature.data.staticData.id)
  self:SetCr(info)
  self:SetLv(info)
  self:SetBuff(info)
end

function SceneBottomHeadwearRaidTowerInfoCell:SetCr(info)
  for i = 1, #self.crs do
    local itemid = info.crystalInfo[i]
    IconManager:SetItemIcon(Table_Item[itemid].Icon, self.crs[i])
    self.crs[i].color = self.EnableColor
  end
  self:UpdateCr(info)
end

function SceneBottomHeadwearRaidTowerInfoCell:UpdateCr(info)
  local towerInfo = GameConfig.HeadWear.tower[info.id]
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

function SceneBottomHeadwearRaidTowerInfoCell:SetLv(info)
  self.lv.text = "Lv." .. (info and info.level or "0")
end

function SceneBottomHeadwearRaidTowerInfoCell:SetBuff(info)
  self.buff.value = self.creature:GetBuffLayer(info.energybuff) / (info.bufflayer or 1)
end
