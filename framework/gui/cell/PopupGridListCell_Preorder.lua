PopupGridListCell_Preorder = class("PopupGridListCell_Preorder", BaseCell)
local redTipOffset = {0, 0}

function PopupGridListCell_Preorder:Init()
  PopupGridListCell_Preorder.super.Init(self)
  self:FindObjs()
  self:AddEvts()
  self.redIDs = {}
end

function PopupGridListCell_Preorder:FindObjs()
  self.objRedTipContainer = self:FindGO("redTipContainer")
  self.objRedTip = self:FindGO("redTip", self.objRedTipContainer)
  self.labContent = self:FindComponent("labContent", UILabel)
  self.collider = self.gameObject:GetComponent(BoxCollider)
  self.subLabContent = self:FindComponent("subLabContent", UILabel)
end

function PopupGridListCell_Preorder:AddEvts()
  self:AddCellClickEvent()
end

function PopupGridListCell_Preorder:SetData(data)
  self.data = data
  local haveData = data ~= nil
  if self.isActive ~= haveData then
    self.gameObject:SetActive(haveData)
    self.isActive = haveData
  end
  if not haveData then
    return
  end
  self.subText = nil
  if type(data) == "table" then
    self.text = data.text or data.Name or data.NameZh or data.name
    self:ShowRedTip(data.showRedTip)
    if data.subText then
      self.subText = data.subText
    end
  else
    self.text = tostring(data)
  end
  self.labContent.text = self.text
  self.subLabContent.text = self.subText or ""
  self:CheckRedTip()
end

function PopupGridListCell_Preorder:RefreshLabelWidth(bgWidth)
  if not bgWidth then
    return
  end
  if self.subText then
    self.labContent.width = bgWidth - 130
  else
    self.labContent.width = bgWidth - 40
  end
  self.collider.size = LuaGeometry.GetTempVector2(bgWidth - 19, self.collider.size.y)
  self.collider.center = LuaGeometry.GetTempVector2(-5 - (200 - bgWidth) / 2, self.collider.center.y)
  self.labContent.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(self.collider.center.x, 0, 0)
end

function PopupGridListCell_Preorder:ShowRedTip(isShow)
  self.objRedTip:SetActive(isShow == true)
end

function PopupGridListCell_Preorder:CheckRedTip()
  self:UnRegisterRedTipChecks()
  if self.data.forceHideRedTip then
    return
  end
  local redTipIds = type(self.data) == "table" and (self.data.RidTip or self.data.RedTip)
  if redTipIds then
    if type(redTipIds) == "table" then
      for key, id in pairs(redTipIds) do
        self.redIDs[#self.redIDs + 1] = id
      end
    elseif type(redTipIds) == "number" then
      self.redIDs[1] = redTipIds
    end
  end
  for i = 1, #self.redIDs do
    RedTipProxy.Instance:RegisterUI(self.redIDs[i], self.objRedTipContainer, 1, redTipOffset, NGUIUtil.AnchorSide.Center)
  end
end

function PopupGridListCell_Preorder:UnRegisterRedTipChecks()
  for i = 1, #self.redIDs do
    RedTipProxy.Instance:UnRegisterUI(self.redIDs[i], self.objRedTipContainer)
  end
  TableUtility.TableClear(self.redIDs)
end

function PopupGridListCell_Preorder:OnCellDestroy()
  self:UnRegisterRedTipChecks()
end
