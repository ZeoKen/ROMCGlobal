local baseCell = autoImport("BaseCell")
GainWayTipCellV1 = class("GainWayTipCellV1", baseCell)
local DescInfo = function(id)
  if not _DescInfo then
    _DescInfo = {
      [GainWayData.Type.Dungeon] = {
        table = "Table_PveRaidEntrance",
        field = "Name"
      },
      [GainWayData.Type.Monster] = {
        [GainWayData.MonsterType.Wild] = {table = "Table_Map", field = "NameZh"}
      },
      [GainWayData.Type.Compose] = {
        [GainWayData.ComposeType.PicMake] = {table = "Table_Item", field = "NameZh"},
        [GainWayData.ComposeType.Compose] = {table = "Table_Item", field = "NameZh"}
      },
      [GainWayData.Type.Guild] = {
        table = "Table_GuildBuilding",
        field = "Name"
      },
      [GainWayData.Type.Achievement] = {
        [GainWayData.AchievementType.System] = {
          table = "Table_Achievement",
          field = "Name"
        },
        [GainWayData.AchievementType.Dungeon] = {
          table = "Table_PveRaidEntrance",
          field = "Name"
        }
      }
    }
  end
  return _DescInfo[id]
end

function GainWayTipCellV1:Init()
  self:FindObjs()
  self:AddCellClickEvent()
end

function GainWayTipCellV1:FindObjs()
  self.itemName = self:FindGO("itemName"):GetComponent(UILabel)
  self.getWay = self:FindGO("getWay"):GetComponent(UILabel)
  self.signSprite = self:FindGO("signSprite"):GetComponent(UISprite)
  self.Icon_Sprite = self:FindGO("Icon_Sprite"):GetComponent(UISprite)
  self.bossLevel = self:FindGO("bossLevel"):GetComponent(UILabel)
  self.gotoBtn = self:FindGO("GoToButton")
  self:AddClickEvent(self.gotoBtn, function(go)
    self:PassEvent(ItemEvent.GoTraceItem, self.data)
  end)
end

function GainWayTipCellV1:SetData(data)
  self.data = data
  if data then
    self.signSprite.gameObject:SetActive(false)
    local config = GameConfig.GainWay[data.type]
    self.itemName.text = data.name or config.name
    UIUtil.WrapLabel(self.itemName)
    local canTrace = data:CanTrace()
    self.gotoBtn:SetActive(canTrace)
    local descinfo = DescInfo(data.type)
    if descinfo ~= nil then
      descinfo = data.subtype ~= nil and descinfo[data.subtype] or descinfo
      local table = descinfo.table
      if table ~= nil then
        table = _G[table]
        if table ~= nil then
          table = table[data.value]
          if table ~= nil then
            local desc = config.desc
            desc = desc[data.subtype] or desc
            self.getWay.text = string.format(desc, table[descinfo.field])
          end
        end
      else
        local desc = config.desc
        desc = desc[data.subtype] or desc
        self.getWay.text = desc
      end
    else
      local desc = data.desc or canTrace and config.desc or config.expiredesc
      desc = data.subtype ~= nil and desc[data.subtype] or desc
      if data.value ~= nil then
        desc = string.format(desc, data.value)
      end
      self.getWay.text = desc
    end
    self.bossLevel.text = ""
    if data.icon then
      IconManager:SetFaceIcon(data.icon, self.Icon_Sprite)
    elseif data.subtype == GainWayData.PetType.Compose then
      IconManager:SetNpcMonsterIconByID(data.value, self.Icon_Sprite)
    else
      IconManager:SetUIIcon(config.icon, self.Icon_Sprite)
    end
  end
end
