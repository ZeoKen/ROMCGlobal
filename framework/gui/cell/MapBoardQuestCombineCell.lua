local BaseCell = autoImport("BaseCell")
MapBoardQuestCombineCell = class("MapBoardQuestCombineCell", BaseCell)
autoImport("MapBoardQuestFatherCell")
autoImport("MapBoardQuestCell")

function MapBoardQuestCombineCell:Init()
  local fatherObj = self:FindGO("FatherTag")
  self.tweenScale = self:FindComponent("ChildContainer", TweenScale)
  self.arrow = self:FindGO("PlusMinus")
  self.arrow_UISprite = self:FindComponent("PlusMinus", UISprite)
  self.questTable = self:FindComponent("ChildTable", UITable)
  self.fatherCell = MapBoardQuestFatherCell.new(fatherObj)
  self.fatherCell:AddEventListener(MouseEvent.MouseClick, self.ClickFather, self)
  self.childCtl = UIGridListCtrl.new(self.questTable, MapBoardQuestCell, "MapBoardQuestCell")
  self.childCtl:AddEventListener(MouseEvent.MouseClick, self.ClickChild, self)
  self.childCtl:AddEventListener("MapBoardQuestcell_ClickDescribeBtn", self.RefreshDescriptionShow, self)
  self:AddClickEvent(self.arrow, function()
    self:ClickFather()
  end)
  self.folderState = true
end

function MapBoardQuestCombineCell:SetData(data)
  if data == nil then
    self.gameObject:SetActive(false)
    return
  elseif data.childQuests and #data.childQuests == 0 then
    self.gameObject:SetActive(false)
    return
  elseif not data.childQuests then
    self.gameObject:SetActive(false)
    return
  else
    self.gameObject:SetActive(true)
  end
  self.data = data
  self:RefreshArrowStatus()
  if data.fatherTag then
    self.fatherCell:SetData(data.fatherTag)
    if self.folderState then
      self.childCtl:ResetDatas(data.childQuests)
      self.questTable:Reposition()
    end
  else
    redlog("No fatherTag!")
  end
end

function MapBoardQuestCombineCell:ClickFather()
  self:SetFolderShownState(not self.folderState)
  self:RefreshArrowStatus()
end

function MapBoardQuestCombineCell:ClickChild(cell)
  GameFacade.Instance:sendNotification("ClickBigMapBoardQuestCell", {cellCtrl = cell})
end

function MapBoardQuestCombineCell:SetFolderShownState(isOpen)
  if self.folderState ~= isOpen then
    self.folderState = isOpen
    if isOpen then
      self.childCtl:ResetDatas(self.data.childQuests)
    else
      self.childCtl:RemoveAll()
      self.childCtl:Layout()
    end
    self.questTable:Reposition()
  end
  self:PassEvent("RefreshMapBoardList", self)
end

function MapBoardQuestCombineCell:RefreshArrowStatus()
  if self.folderState then
    self.arrow_UISprite.spriteName = "com_btn_cuts"
  else
    self.arrow_UISprite.spriteName = "com_btn_add"
  end
  self.arrow_UISprite:MakePixelPerfect()
end

function MapBoardQuestCombineCell:RefreshDescriptionShow()
  self.questTable:Reposition()
  self:PassEvent("MapBoardQuestCombineCell_ClickDescribeBtn")
end
