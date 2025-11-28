local BaseCell = autoImport("BaseCell")
AdventureBriefSummaryCell = class("AdventureBriefSummaryCell", BaseCell)
local cellUIConfig = {
  [AdventureDataProxy.BriefType.Monster] = {
    icon = "119",
    icon_scale = 60,
    show_attr_btn = false,
    sIcon1 = "Adventure_icon_good",
    sIcon1_scale = 50,
    sIcon2 = "Adventure_icon_perfect",
    sIcon2_scale = 50
  },
  [AdventureDataProxy.BriefType.Fashion] = {icon = "116", icon_scale = 50},
  [AdventureDataProxy.BriefType.Pet] = {icon = "135", icon_scale = 60},
  [AdventureDataProxy.BriefType.Food] = {icon = "136", icon_scale = 60},
  [AdventureDataProxy.BriefType.Npc] = {
    icon = "120",
    icon_scale = 55,
    show_attr_btn = false,
    sIcon1 = "Adventure_icon_perfect",
    sIcon1_scale = 50
  },
  [AdventureDataProxy.BriefType.Scenery] = {
    icon = "124",
    icon_scale = 50,
    show_attr_btn = false
  },
  [AdventureDataProxy.BriefType.Card] = {icon = "117", icon_scale = 55},
  [AdventureDataProxy.BriefType.Collection] = {icon = "126", icon_scale = 55},
  [AdventureDataProxy.BriefType.Furniture] = {icon = "139", icon_scale = 60},
  [AdventureDataProxy.BriefType.Toy] = {icon = "toy_icon", icon_scale = 60},
  [AdventureDataProxy.BriefType.Achieve] = {icon = "128", icon_scale = 50}
}
AdventureBriefSummaryCell.UIEvent = {
  ClickShowAttr = "AdventureBriefSummaryCell_ClickShowAttr",
  ClickGoto = "AdventureBriefSummaryCell_ClickGoto"
}

function AdventureBriefSummaryCell:Init()
  self:initView()
end

function AdventureBriefSummaryCell:initView()
  self.table = self:FindComponent("table", UITable)
  self.titleIcon = self:FindComponent("titleIcon", UISprite)
  self.titleLb = self:FindComponent("labTitle", UILabel)
  self.descLb = self:FindComponent("labDesc", UILabel)
  self.detailTable = self:FindComponent("left", UITable)
  self.cellTable = self:FindComponent("Content", UITable)
  self.summaryLine1 = self:FindGO("SummaryContent1")
  self.summaryLine1_Name = self:FindComponent("sName", UILabel, self.summaryLine1)
  self.summaryLine1_Icon = self:FindComponent("sIcon", UISprite, self.summaryLine1)
  self.summaryLine1_Value = self:FindComponent("sValue", UILabel, self.summaryLine1)
  self.summaryLine2 = self:FindGO("SummaryContent2")
  self.summaryLine2_Name = self:FindComponent("sName", UILabel, self.summaryLine2)
  self.summaryLine2_Icon = self:FindComponent("sIcon", UISprite, self.summaryLine2)
  self.summaryLine2_Value = self:FindComponent("sValue", UILabel, self.summaryLine2)
  self.slider = self:FindComponent("foreSp", UISlider)
  self.btnGoto = self:FindGO("BtnGoto")
  self.btnShowAttr = self:FindGO("BtnShowAttr")
  self:AddClickEvent(self.btnGoto, function()
    self:PassEvent(AdventureBriefSummaryCell.UIEvent.ClickGoto, self)
  end)
  self:AddClickEvent(self.btnShowAttr, function()
    self:PassEvent(AdventureBriefSummaryCell.UIEvent.ClickShowAttr, self)
  end)
end

function AdventureBriefSummaryCell:SetData(data)
  self.data = data
  local cehua_cfg = GameConfig.AdventureProgress[data.btype]
  local ui_cfg = cellUIConfig[data.btype]
  IconManager:SetUIIcon(ui_cfg.icon, self.titleIcon)
  self.titleIcon:MakePixelPerfect()
  self.titleIcon.width = self.titleIcon.width * ui_cfg.icon_scale / 100
  self.titleIcon.height = self.titleIcon.height * ui_cfg.icon_scale / 100
  self.titleLb.text = cehua_cfg.title
  self.descLb.text = cehua_cfg.desc
  if ui_cfg.show_attr_btn == false then
    self.btnShowAttr:SetActive(false)
  else
    self.btnShowAttr:SetActive(true)
  end
  local proxy = AdventureDataProxy.Instance
  local brief = proxy["GetBriefSummary_" .. data.splice](proxy)
  if brief.t then
    self.titleLb.text = cehua_cfg.title .. " " .. brief.t[1] .. "/" .. brief.t[2]
    self.slider.value = brief.t[1] / brief.t[2]
  end
  self.summaryLine1:SetActive(false)
  self.summaryLine2:SetActive(false)
  if #brief.ilist > 0 then
    self.summaryLine1:SetActive(true)
    self.summaryLine1_Value.text = brief.ilist[1][1] .. "/" .. brief.ilist[1][2]
    self.summaryLine1_Name.text = ZhString[string.format("AdventureBriefSummary_Words_%s_1", data.splice)] or ""
    if ui_cfg.sIcon1 then
      self.summaryLine1_Icon.gameObject:SetActive(true)
      self.summaryLine1_Icon.spriteName = ui_cfg.sIcon1
      self.summaryLine1_Icon:MakePixelPerfect()
      if ui_cfg.sIcon1_scale then
        self.summaryLine1_Icon.width = self.summaryLine1_Icon.width * ui_cfg.sIcon1_scale / 100
        self.summaryLine1_Icon.height = self.summaryLine1_Icon.height * ui_cfg.sIcon1_scale / 100
      end
    else
      self.summaryLine1_Icon.gameObject:SetActive(false)
    end
  end
  if 1 < #brief.ilist then
    self.summaryLine2:SetActive(true)
    self.summaryLine2_Value.text = brief.ilist[2][1] .. "/" .. brief.ilist[2][2]
    self.summaryLine2_Name.text = ZhString[string.format("AdventureBriefSummary_Words_%s_2", data.splice)] or ""
    if ui_cfg.sIcon2 then
      self.summaryLine2_Icon.gameObject:SetActive(true)
      self.summaryLine2_Icon.spriteName = ui_cfg.sIcon2
      self.summaryLine2_Icon:MakePixelPerfect()
      if ui_cfg.sIcon2_scale then
        self.summaryLine2_Icon.width = self.summaryLine2_Icon.width * ui_cfg.sIcon2_scale / 100
        self.summaryLine2_Icon.height = self.summaryLine2_Icon.height * ui_cfg.sIcon2_scale / 100
      end
    else
      self.summaryLine2_Icon.gameObject:SetActive(false)
    end
  end
  if data.btype == AdventureDataProxy.BriefType.Monster then
  elseif data.btype == AdventureDataProxy.BriefType.Pet then
    self.titleLb.text = string.format(ZhString.AdventureBriefSummary_Title_Pet, brief.ilist[1][1], brief.ilist[1][2], brief.ilist[2][1], brief.ilist[2][2])
    self.slider.value = (brief.ilist[1][1] + brief.ilist[2][1]) / (brief.ilist[1][2] + brief.ilist[2][2])
  end
  self.detailTable:Reposition()
  self.cellTable:Reposition()
end

function AdventureBriefSummaryCell:DoReposition()
  self.detailTable:Reposition()
  self.cellTable:Reposition()
end
