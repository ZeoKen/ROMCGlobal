local baseCell = autoImport("BaseCell")
MapPlotCell = class("MapPlotCell", baseCell)

function MapPlotCell:Init()
  self:initView()
end

function MapPlotCell:initView()
  self.mapName = self.gameObject:GetComponent(UILabel)
  self.chooseSymbol = self:FindGO("ChooseSymbol")
  self:AddButtonEvent("ActiveBtn", function()
    self:PassEvent(QuestManualEvent.PlotVoiceClick, self)
  end)
  self.chooseSymbol:SetActive(false)
end

function MapPlotCell:setIsSelected(isSelected)
  self.chooseSymbol:SetActive(false)
  if self.isSelected ~= isSelected then
    self.isSelected = isSelected
    if isSelected then
      self.chooseSymbol:SetActive(true)
      self.mapName.color = QuestManualView.ColorTheme[6].color
    elseif self.complete then
      self.mapName.color = QuestManualView.ColorTheme[9].color
    else
      self.mapName.color = QuestManualView.ColorTheme[8].color
    end
  end
end

function MapPlotCell:SetData(data)
  self.data = data
  self.complete = QuestManualProxy.Instance:CheckPlotQuestComplete(data.version, data.mapID)
  if self.complete then
    self.mapName.color = QuestManualView.ColorTheme[9].color
  else
    self.mapName.color = QuestManualView.ColorTheme[8].color
  end
  self.mapName.text = Table_Map[data.mapID] and Table_Map[data.mapID].NameZh
  self.isSelected = false
end
