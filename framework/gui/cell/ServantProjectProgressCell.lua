ServantProjectProgressCell = class("ServantProjectProgressCell", BaseCell)

function ServantProjectProgressCell:Init()
  self.wancheng = self:FindGO("_wancheng")
  self.meiwancheng = self:FindGO("_meiwancheng")
  self.duihao = self:FindGO("duihao")
  self.shandian_value = self:FindComponent("shandian_value", UILabel)
  self.jiangli_value = self:FindComponent("jiangli_value", UILabel)
  self.jiangli_cell = self:FindGO("jiangli_cell")
  self.rewardCell = ItemCell.new(self.jiangli_cell)
  self:AddClickEvent(self.jiangli_cell, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end

function ServantProjectProgressCell:SetData(data)
  self.data = data
  self.id = data.id
  if data.finished then
    self.wancheng:SetActive(true)
    self.meiwancheng:SetActive(false)
    self.duihao:SetActive(true)
  else
    self.wancheng:SetActive(false)
    self.meiwancheng:SetActive(true)
    self.duihao:SetActive(false)
  end
  self.shandian_value.text = "1/1"
  self.jiangli_value.text = "真好吃真好吃*1"
  local itemData = ItemData.new(nil, data.itemid)
  self.itemCell:SetData(itemData)
end
