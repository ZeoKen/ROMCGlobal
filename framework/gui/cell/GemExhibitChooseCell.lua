autoImport("GemExhibitCell")
GemExhibitChooseCell = class("GemExhibitChooseCell", GemExhibitCell)
GemExhibitChooseCellEvent = {
  ClickGem = "GemExhibitChooseCellEvent_ClickGem"
}

function GemExhibitChooseCell:Init()
  GemExhibitChooseCell.super.Init(self)
  if self.bgSp then
    self:AddClickEvent(self.bgSp.gameObject, function()
      self:PassEvent(GemExhibitChooseCellEvent.ClickGem, self)
    end)
  end
end
