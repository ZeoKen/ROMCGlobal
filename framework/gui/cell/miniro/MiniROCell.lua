autoImport("BaseItemCell")
MiniROCell = class("MiniROCell", BaseItemCell)

function MiniROCell:ctor(obj, data)
  MiniROCell.super.ctor(self, obj)
  self.data = data
  self.localPosition = obj.transform.localPosition
  self:FindObjs()
  self:AddEvents()
end

function MiniROCell:FindObjs()
  if self.data.id > 0 then
    self.objNormal = self:FindComponent("objNormal", UISprite)
    self.imgNormal = self:FindGO("imgNormal")
    self.imgEvent = self:FindGO("imgEvent")
    self.objPassed = self:FindGO("objPassed")
    self.objSpecial = self:FindGO("objSpecial")
  end
end

function MiniROCell:AddEvents()
  self:AddButtonEvent("objNormal", function(go)
    if self.data.Type == MiniROProxy.CellType.Normal then
      MsgManager.ShowMsgByID(41351)
    elseif self.data.Type == MiniROProxy.CellType.Event then
      MsgManager.ShowMsgByID(41352)
    elseif self.data.Type == MiniROProxy.CellType.Special then
      if MiniROProxy.Instance:CheckOnceReward(self.data.id) then
        MsgManager.ShowMsgByID(41353)
      else
        if not self.data.Param then
          return
        end
        local cellData = {
          rewardid = self.data.Param
        }
        TipManager.Instance:ShowRewardListTip(cellData, self.objNormal, NGUIUtil.AnchorSide.DownRight, {75, 75})
      end
    end
  end)
end

function MiniROCell:SetData(data)
  if data.id > 0 then
    self.data = data
    self.imgNormal:SetActive(data.Type == MiniROProxy.CellType.Normal)
    self.imgEvent:SetActive(data.Type == MiniROProxy.CellType.Event)
    if data.Type == MiniROProxy.CellType.Special then
      self.isGetOnceReward = MiniROProxy.Instance:CheckOnceReward(data.id)
      self.objSpecial:SetActive(not self.isGetOnceReward)
      self.objPassed:SetActive(self.isGetOnceReward)
    end
  end
end

function MiniROCell:SetPassed()
  if self.data.Type == MiniROProxy.CellType.Special then
    local isGetOnceReward = MiniROProxy.Instance:CheckOnceReward(self.data.id)
    self.objSpecial:SetActive(not isGetOnceReward)
    self.objPassed:SetActive(isGetOnceReward)
  end
end

function MiniROCell:GetPosition()
  return self.localPosition
end
