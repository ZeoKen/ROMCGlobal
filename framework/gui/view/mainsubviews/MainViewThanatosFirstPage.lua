MainViewThanatosFirstPage = class("MainViewThanatosFirstPage", SubMediatorView)
autoImport("RaidBuffCell")
autoImport("MemberSelectCell")
autoImport("CrystalShieldCell")
autoImport("MissionCommandMove")
autoImport("FloatNormalTip")
local crystalNum = 4
local originHeight = 219
local shortHeight = 100
local countHeight = 34
local originColor = LuaColor.New(1, 1, 1, 1)
local greyColor = LuaColor.New(0.00392156862745098, 0.00784313725490196, 0.011764705882352941)

function MainViewThanatosFirstPage:Show(tarObj)
  self:TryInit()
  MainViewThanatosFirstPage.super.Show(self, tarObj)
  self.isIn = true
  FunctionBuff.Me():AddInterest(self.ConfigThanatos.ValkyrieBuffID)
  FunctionBuff.Me():AddInterest(self.ConfigThanatos.ValkyrieStageBuffID)
  if not self.buffmap then
    self.buffmap = {}
  else
    TableUtility.TableClear(self.buffmap)
  end
  for i = 1, #self.attentionBuffs do
    FunctionBuff.Me():AddInterest(self.attentionBuffs[i])
  end
  if not self.buffListDatas then
    self.buffListDatas = {}
  else
    TableUtility.ArrayClear(self.buffListDatas)
  end
  if not self.hidecrystal then
    if not self.crystalShieldMap then
      self.crystalShieldMap = {}
    else
      TableUtility.TableClear(self.crystalShieldMap)
    end
    self:InitCrystal()
    self.bg.height = originHeight
  else
    self.bg.height = shortHeight
  end
  if not self.hideCountCrystal then
    self.bg.height = self.bg.height + countHeight
    if not self.countMap then
      self.countMap = {}
    else
      TableUtility.TableClear(self.countMap)
    end
    self.count:SetActive(true)
    self:InitCrystalCount()
  else
    self.count:SetActive(false)
  end
  self.myguid = Game.Myself.data.id
  self:ResetBuffData()
  self:ReParent()
  ServiceFuBenCmdProxy.Instance:CallQueryTeamGroupRaidUserInfo()
end

function MainViewThanatosFirstPage:Hide(target)
  MainViewThanatosFirstPage.super.Hide(self, target)
  self.isIn = false
  self.valkyrieGuid = nil
  self.hidecrystal = false
  self.inited = false
  self.hideCountCrystal = false
  if self.crystalListCtr then
    self.crystalListCtr:RemoveAll()
  end
  self.raidinfo.transform.parent = self.gameObject.transform
  FunctionBuff.Me():RemoveInterest(self.ConfigThanatos.ValkyrieBuffID)
  FunctionBuff.Me():RemoveInterest(self.ConfigThanatos.ValkyrieStageBuffID)
  for i = 1, #self.attentionBuffs do
    FunctionBuff.Me():RemoveInterest(self.attentionBuffs[i])
  end
  if self.crystalListCtr then
    self.crystalListCtr:RemoveAll()
  end
end

function MainViewThanatosFirstPage:Init()
  self:AddViewEvts()
end

function MainViewThanatosFirstPage:TryInit()
  if not self.loaded then
    local container = self:FindGO("MainViewThanatosPage")
    self:ReLoadPerferb("view/MainViewThanatosFirstPage")
    self:ResetParent(container)
    self.loaded = true
  end
  if not self.inited then
    self:InitConfig()
    self:FindObjs()
    self:UpdateView()
    self.inited = true
  else
    self.toggleteam = false
    self.toggletopfunc = false
    self.toggleraid = false
  end
end

function MainViewThanatosFirstPage:InitConfig()
  self.curmapid = SceneProxy.Instance:GetCurRaidID()
  local tgConfig = Table_TeamGroupRaid[self.curmapid]
  if tgConfig then
    self.ConfigThanatos = GameConfig.Thanatos[tgConfig.Difficulty]
    self.attentionBuffs = self.ConfigThanatos.AttentionBuffID
    for k, v in pairs(self.ConfigThanatos.HideUI) do
      if v == MainViewThanatosPage.HideUI.HideCystalInfo then
        self.hidecrystal = true
      elseif v == MainViewThanatosPage.HideUI.HideCountCrystal then
        self.hideCountCrystal = true
      end
    end
  end
end

function MainViewThanatosFirstPage:FindObjs()
  self.hpProgress = self:FindGO("HPProgress"):GetComponent(UISlider)
  self.energyProgress = self:FindGO("EnergyProgress"):GetComponent(UISlider)
  self.hpPercent = self:FindGO("hpPercent"):GetComponent(UILabel)
  self.energyPercent = self:FindGO("energyPercent"):GetComponent(UILabel)
  self.crystalHPLabel = {}
  for i = 1, crystalNum do
    local obj = self:FindGO("crystalHP" .. i)
    if obj then
      self.crystalHPLabel[i] = obj:GetComponent(UILabel)
    end
  end
  self.crystalNameLabel = {}
  for i = 1, crystalNum do
    local obj = self:FindGO("name" .. i)
    if obj then
      self.crystalNameLabel[i] = obj:GetComponent(UILabel)
    end
  end
  self.crystalList = self:FindComponent("crystalList", UIGrid)
  self.crystalListCtr = UIGridListCtrl.new(self.crystalList, CrystalShieldCell, "CrystalShieldCell")
  self.bufflist = self:FindGO("BuffList"):GetComponent(UIGrid)
  self.bufflistCtrl = UIGridListCtrl.new(self.bufflist, RaidBuffCell, "RaidBuffCell")
  self.bufflistBg = self:FindGO("BuffListBg"):GetComponent(UISprite)
  self.bufflistCtrl:AddEventListener(RaidBuffCellEvent.BuffEnd, self.RemoveTimeEndBuff, self)
  self.bufflistCtrl:AddEventListener(MouseEvent.MouseClick, self.ClickBuffEvent, self)
  local raidname = self:FindGO("RaidTitle"):GetComponent(UILabel)
  self.curmapid = SceneProxy.Instance:GetCurRaidID()
  local tgConfig = Table_TeamGroupRaid[self.curmapid]
  raidname.text = tgConfig.NameZh
  self.bossID = tgConfig.BossID[1]
  local ValkyrieHeadicon = self:FindGO("SimpleHeadIcon"):GetComponent(UISprite)
  local valkyrieConfig = Table_Monster[self.bossID]
  IconManager:SetFaceIcon(valkyrieConfig.Icon, ValkyrieHeadicon)
  self:AddClickEvent(self:FindGO("ValkyrieHeadCell"), function()
    local vcreature = NSceneNpcProxy.Instance:Find(self.valkyrieGuid)
    if vcreature then
      local cmdArgs = {}
      cmdArgs.targetMapID = SceneProxy.Instance:GetCurMapID()
      cmdArgs.targetPos = LuaGeometry.GetTempVector3(vcreature:GetPosition()[1] or 0, vcreature:GetPosition()[2] or 0, vcreature:GetPosition()[3] or 0)
      cmdArgs.npcID = self.bossID
      local cmd = MissionCommandFactory.CreateCommand(cmdArgs, MissionCommandSkill)
      Game.Myself:Client_SetMissionCommand(cmd)
    end
  end)
  self.bg = self:FindGO("InfoBG"):GetComponent(UISprite)
  self.count = self:FindGO("Count")
  self.countObj = {}
  for i = 1, 4 do
    local c = self:FindGO("crystal" .. i):GetComponent(UISprite)
    self.countObj[i] = c
    c.color = greyColor
  end
end

function MainViewThanatosFirstPage:ReParent()
  local thanatosParent = self.gameObject.transform.parent
  self.raidinfo = self:FindGO("RaidInfo")
  local raidinfoParent = Game.GameObjectUtil:DeepFindChild(thanatosParent.gameObject, "RaidInfo")
  self.raidinfo.transform.parent = raidinfoParent.gameObject.transform
  self.raidinfo.transform.localPosition = LuaGeometry.GetTempVector3(-160, 28, 0)
end

function MainViewThanatosFirstPage:AddViewEvts()
  self:AddListenEvt(SceneUserEvent.SceneAddNpcs, self.HandleAddNpc)
  self:AddListenEvt(SceneUserEvent.SceneRemoveNpcs, self.HandleRemoveNpc)
  self:AddListenEvt(ServiceEvent.NUserNpcDataSync, self.HandleSyncNpc)
  self:AddListenEvt(ServiceEvent.NUserUserBuffNineSyncCmd, self.HandleBuff)
end

function MainViewThanatosFirstPage:ResetParent(parent)
  if not parent then
    return
  end
  self.trans:SetParent(parent.transform, false)
end

function MainViewThanatosFirstPage:UpdateView()
  self:UpdateHP()
  self:UpdateEnergy()
end

function MainViewThanatosFirstPage:UpdateHP()
  local valkyrie = NSceneNpcProxy.Instance:Find(self.valkyrieGuid)
  if valkyrie ~= nil then
    local props = valkyrie.data.props
    local value = props:GetPropByName("Hp"):GetValue() / props:GetPropByName("MaxHp"):GetValue()
    self.hpProgress.value = value
    self.hpPercent.text = string.format("%d%%", value * 100)
  else
    self.hpProgress.value = 1
    self.hpPercent.text = "100"
  end
end

local tempValue = 1

function MainViewThanatosFirstPage:UpdateEnergy(bufflayer)
  if bufflayer == nil then
    local valkyrie = NSceneNpcProxy.Instance:Find(self.valkyrieGuid)
    if valkyrie ~= nil then
      bufflayer = valkyrie:GetBuffLayer(self.ConfigThanatos.ValkyrieBuffID)
    end
  end
  bufflayer = bufflayer or 0
  tempValue = bufflayer / self.ConfigThanatos.ValkyrieMaxBuffLayer
  local value = tempValue < 1 and tempValue or 1
  self.energyProgress.value = value
  self.energyPercent.text = string.format("%d%%", value * 100)
end

function MainViewThanatosFirstPage:HandleAddNpc(note)
  if not self.isIn then
    return
  end
  local data = note.body
  local flag = false
  if data then
    local npcData
    local flag = false
    local cflag = false
    for i = 1, #data do
      npcData = data[i].data
      local staticid = npcData.staticData.id
      if staticid == self.bossID then
        self.valkyrieGuid = npcData.id
        self:UpdateView()
      elseif not self.hidecrystal then
        for i = 1, #self.ConfigThanatos.CrystalshieldID do
          local cfg = self.ConfigThanatos.CrystalshieldID[i]
          if npcData.uniqueid == cfg[1] then
            flag = flag or true
            local single = {}
            single.guid = npcData.id
            single.staticid = staticid
            self.crystalShieldMap[npcData.uniqueid] = npcData.id
          end
        end
        if staticid == self.ConfigThanatos.RedCrystalID or staticid == self.ConfigThanatos.BlueCrystalID then
          flag = flag or true
          local single = {}
          single.guid = npcData.id
          single.staticid = staticid
          self.crystalShieldMap[npcData.uniqueid] = npcData.id
        end
      elseif not self.hideCountCrystal and (staticid == self.ConfigThanatos.RedCrystalID or staticid == self.ConfigThanatos.BlueCrystalID) then
        cflag = cflag or true
        if not self.countMap[staticid] then
          self.countMap[staticid] = {}
        end
        table.insert(self.countMap[staticid], npcData.id)
      end
    end
    if flag then
      self:UpdateCrystal()
    end
    if not self.hideCountCrystal and cflag then
      self:UpdateCount()
    end
  end
end

function MainViewThanatosFirstPage:HandleRemoveNpc(note)
  if not self.isIn then
    return
  end
  local data = note.body
  local flag = false
  if data then
    for i = 1, #data do
      if data[i] == self.valkyrieGuid then
        self.valkyrieGuid = nil
      elseif not self.hidecrystal then
        for k, v in pairs(self.crystalShieldMap) do
          if data[i] == v then
            self:UpdateCrystal()
          end
        end
      elseif not self.hideCountCrystal and self.countMap then
        local rid = self.ConfigThanatos.RedCrystalID
        local red = self.countMap[rid] or {}
        for k, v in pairs(red) do
          if data[i] == v then
            red[k] = nil
            self:UpdateCount()
            break
          end
        end
        local rid = self.ConfigThanatos.BlueCrystalID
        local blue = self.countMap[rid] or {}
        for k, v in pairs(blue) do
          if data[i] == v then
            blue[k] = nil
            self:UpdateCount()
            break
          end
        end
      end
    end
  end
end

function MainViewThanatosFirstPage:HandleSyncNpc(note)
  if not self.isIn then
    return
  end
  local data = note.body
  if data then
    if data.guid == self.valkyrieGuid then
      if #data.attrs > 0 then
        self:UpdateHP()
      end
    elseif not self.hidecrystal then
      for k, v in pairs(self.crystalShieldMap) do
        if data.guid == v and #data.attrs > 0 then
          self:UpdateCrystal(k)
        end
      end
    elseif not self.hideCountCrystal and self.countMap then
      local rid = self.ConfigThanatos.RedCrystalID
      local red = self.countMap[rid] or {}
      for k, v in pairs(red) do
        if data.guid == v and #data.attrs > 0 then
          self:UpdateCount()
          return
        end
      end
      rid = self.ConfigThanatos.BlueCrystalID
      local blue = self.countMap[rid] or {}
      for k, v in pairs(blue) do
        if data.guid == v and #data.attrs > 0 then
          self:UpdateCount()
          return
        end
      end
    end
  end
end

function MainViewThanatosFirstPage:HandleBuff(note)
  if not self.isIn then
    return
  end
  local data = note.body
  if data then
    local buffs = data.updates or {}
    local deleteBuffs = data.dels or {}
    if data.guid == self.valkyrieGuid then
      for i = 1, #buffs do
        if buffs[i].id == self.ConfigThanatos.ValkyrieBuffID then
          self:UpdateEnergy(buffs[i].layer)
        end
      end
    elseif data.guid == Game.Myself.data.id then
      for i = 1, #buffs do
        for k, v in pairs(self.attentionBuffs) do
          if buffs[i].id == v then
            if not flag then
              flag = true
            end
            local single = {
              id = v,
              staticData = Table_Buffer[v],
              starttime = ServerTime.CurServerTime(),
              endtime = buffs[i].time
            }
            if single.endtime == 0 then
              single.endtime = nil
            end
            self.buffmap[v] = single
          end
        end
        if flag then
          self:ResetBuffData()
        end
      end
      for i = 1, #deleteBuffs do
        for k, v in pairs(self.attentionBuffs) do
          if deleteBuffs[i] == v then
            self.buffmap[v] = nil
          end
          self:ResetBuffData()
        end
      end
    else
      for i = 1, #buffs do
        local flag = false
        if buffs[i].id == self.ConfigThanatos.AlterBuffID then
          FunctionPlayerHead.Me():PlayDebuffEffect(data.guid)
        end
      end
      for i = 1, #deleteBuffs do
        if deleteBuffs[i] == self.ConfigThanatos.AlterBuffID then
          FunctionPlayerHead.Me():CloseDebuffEffect(data.guid)
        end
      end
    end
  end
end

function MainViewThanatosFirstPage:ResetBuffData()
  TableUtility.ArrayClear(self.buffListDatas)
  for _, bData in pairs(self.buffmap) do
    table.insert(self.buffListDatas, bData)
  end
  table.sort(self.buffListDatas, function(a, b)
    self:_SortBuffData(a, b)
  end)
  self.bufflistCtrl:ResetDatas(self.buffListDatas)
  self.bufflistBg.gameObject:SetActive(#self.buffListDatas ~= 0)
  self.bufflistBg.height = 10 + 60 * #self.buffListDatas
  self.bufflist:Reposition()
end

local STORAGE_FAKE_ID = "storage_fake_id"

function MainViewThanatosFirstPage:_SortBuffData(a, b)
  if a.isalways ~= nil or b.isalways ~= nil then
    return a.isalways == true
  end
  if a.id == STORAGE_FAKE_ID or b.id == STORAGE_FAKE_ID then
    return a.id == STORAGE_FAKE_ID
  end
  local aBuffCfg = Table_Buffer[a.id]
  local bBuffCfg = Table_Buffer[b.id]
  if aBuffCfg and bBuffCfg then
    local aIsDeBuff = aBuffCfg.BuffType.isgain == 0
    local bIsDeBuff = bBuffCfg.BuffType.isgain == 0
    if aIsDeBuff ~= bIsDeBuff then
      return aIsDeBuff
    end
    if aBuffCfg.IconType and bBuffCfg.IconType then
      if aBuffCfg.IconType ~= bBuffCfg.IconType then
        return aBuffCfg.IconType > bBuffCfg.IconType
      end
      if aBuffCfg.IconType == 1 and bBuffCfg.IconType == 1 and a.endtime and b.endtime and a.endtime and b.endtime then
        return a.starttime < b.starttime
      end
    end
  end
  return a.id < b.id
end

function MainViewThanatosFirstPage:UpdateCrystal(uniqueid)
  local cells = self.crystalListCtr:GetCells()
  for i = 1, #cells do
    cells[i]:UpdateStatus()
  end
end

function MainViewThanatosFirstPage:InitCrystal()
  if not self.crystalDataList then
    self.crystalDataList = {}
  else
    TableUtility.ArrayClear(self.crystalDataList)
  end
  for i = 1, #self.ConfigThanatos.CrystalshieldID do
    local cfg = self.ConfigThanatos.CrystalshieldID[i]
    local single = {}
    single.shieldid = cfg[1]
    single.crystalid = cfg[2]
    single.name = cfg[3]
    table.insert(self.crystalDataList, single)
  end
  self.crystalListCtr:ResetDatas(self.crystalDataList)
end

function MainViewThanatosFirstPage:RemoveTimeEndBuff(buffdata)
  local id = buffdata.id
  for k, v in pairs(self.attentionBuffs) do
    if id == v then
      self.buffmap[v] = nil
    end
  end
  self:ResetBuffData()
end

function MainViewThanatosFirstPage:ClickBuffEvent(cellCtl)
  local data = cellCtl.data
  if data then
    local staticData = data and data.staticData
    local oriDec = staticData and staticData.BuffDesc or ""
    TipsView.Me():ShowStickTip(FloatNormalTip, oriDec, NGUIUtil.AnchorSide.DownRight, cellCtl.icon, {30, 0})
    TipsView.Me().currentTip:SetUpdateSetText(1000, MainViewInfoPage.UpdateBuffTip, data)
  end
end

function MainViewThanatosFirstPage:AddControlPanel(...)
end

function MainViewThanatosFirstPage:InitCrystalCount()
  if self.countObj then
    for i = 1, 4 do
      if self.countObj[i] then
        self.countObj[i].color = greyColor
      end
    end
  end
end

function MainViewThanatosFirstPage:UpdateCount()
  local rid = self.ConfigThanatos.RedCrystalID
  local red = self.countMap[rid] or {}
  for i = 1, #red do
    local creature = NSceneNpcProxy.Instance:Find(red[i])
    local crystalprops = creature and creature.data and creature.data.props or nil
    local crystalhp = crystalprops and crystalprops:GetPropByName("Hp"):GetValue() or 0
    if crystalhp ~= 0 then
      self.countObj[i].color = originColor
    else
      self.countObj[i].color = greyColor
    end
  end
  rid = self.ConfigThanatos.BlueCrystalID
  local blue = self.countMap[rid] or {}
  for i = 1, #blue do
    local creature = NSceneNpcProxy.Instance:Find(blue[i])
    local crystalprops = creature and creature.data and creature.data.props or nil
    local crystalhp = crystalprops and crystalprops:GetPropByName("Hp"):GetValue() or 0
    if crystalhp ~= 0 then
      if self.countObj[2 + i] then
        self.countObj[2 + i].color = originColor
      end
    elseif self.countObj[2 + i] then
      self.countObj[2 + i].color = greyColor
    end
  end
end
