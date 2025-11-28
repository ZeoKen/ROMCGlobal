local BaseCell = autoImport("BaseCell")
ServantStrengthenCell = class("ServantStrengthenCell", BaseCell)

function ServantStrengthenCell:Init()
  ServantStrengthenCell.super.Init(self)
  self:FindObjs()
  self:AddUIEvts()
end

function ServantStrengthenCell:FindObjs()
  self.content = self:FindGO("Content")
  self.icon = self:FindComponent("Icon", UISprite)
  self.name = self:FindComponent("Name", UILabel)
  self.title = self:FindComponent("Title", UILabel)
  self.btn = self:FindComponent("Btn", UISprite)
  self.btnLab = self:FindComponent("BtnText", UILabel)
  self.redTip = self:FindGO("RedPoint")
end

function ServantStrengthenCell:AddUIEvts()
  self:AddClickEvent(self.btn.gameObject, function(obj)
    FuncShortCutFunc.Me():CallByID(self.gotoMode)
  end)
end

local exitIcon, cfg

function ServantStrengthenCell:SetData(data)
  self.data = data
  if self.data then
    cfg = data.staticData
    self.content:SetActive(true)
    self.id = cfg.id
    self.gotoMode = cfg.GotoMode
    self.name.text = cfg.Name
    self.title.text = cfg.Title
    if nil == data.itemID then
      exitIcon = IconManager:SetUIIcon(cfg.Icon, self.icon)
      if not exitIcon then
        exitIcon = IconManager:SetItemIcon(cfg.Icon, self.icon)
      end
    else
      IconManager:SetItemIcon(Table_Item[data.itemID].Icon, self.icon)
    end
    self.btnLab.text = cfg.GoName
    self.redTip:SetActive(true == data.needRedTip)
  else
    self.content:SetActive(false)
  end
end
