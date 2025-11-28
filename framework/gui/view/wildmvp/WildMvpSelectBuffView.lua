autoImport("WildMvpSelectBuffCell")
WildMvpSelectBuffView = class("WildMvpSelectBuffView", ContainerView)
WildMvpSelectBuffView.ViewType = UIViewType.NormalLayer

function WildMvpSelectBuffView:OnExit()
  Game.Myself:PlayEffect(nil, EffectMap.Maps.WildMvpSelectBuff, RoleDefines_EP.Bottom, nil, nil, true)
  if self.timeTick ~= nil then
    TimeTickManager.Me():ClearTick(self)
    self.timeTick = nil
  end
  WildMvpSelectBuffView.super.OnExit(self)
end

function WildMvpSelectBuffView:Init()
  self:FindObjs()
  self:UpdateView()
end

function WildMvpSelectBuffView:FindObjs()
  self.countdown = self:FindGO("Countdown"):GetComponent(UILabel)
  local grid = self:FindGO("Grid"):GetComponent(UIGrid)
  self.ctrl = UIGridListCtrl.new(grid, WildMvpSelectBuffCell, "WildMvp/WildMvpSelectBuffCell")
  self.ctrl:AddEventListener(MouseEvent.MouseClick, self.ClickBuff, self)
  local confirm = self:FindGO("Confirm")
  self.confirmSp = confirm:GetComponent(UIMultiSprite)
  self.confirmLabel = self:FindGO("Label", confirm):GetComponent(UILabel)
  self:AddClickEvent(confirm, function()
    if self.selectID ~= nil then
      ServiceMapProxy.Instance:CallBuffRewardSelectCmd(self.list, nil, self.selectID)
      self:CloseSelf()
    end
  end)
end

function WildMvpSelectBuffView:UpdateView()
  local data = self.viewdata.viewdata
  if data ~= nil then
    self.list = {}
    for i = 1, #data.buffs do
      self.list[#self.list + 1] = data.buffs[i]
    end
    self.ctrl:ResetDatas(self.list)
    self.endTime = data.end_time
    self.timeTick = TimeTickManager.Me():CreateTick(0, 1000, self.UpdateTick, self)
  end
end

function WildMvpSelectBuffView:ClickBuff(cell)
  local data = cell.data
  if data ~= nil then
    if self.selectID == nil then
      self.confirmSp.CurrentState = 1
      self.confirmLabel.effectStyle = UILabel.Effect.Outline
    else
      local cells = self.ctrl:GetCells()
      for i = 1, #cells do
        if self.selectID == cells[i].data then
          cells[i]:PlayTween(false)
        end
      end
    end
    self.selectID = data
    cell:PlayTween(true)
  end
end

function WildMvpSelectBuffView:UpdateTick()
  local countdown = self.endTime - ServerTime.CurServerTime() / 1000
  if countdown < 0 then
    self:CloseSelf()
    return
  end
  self.countdown.text = string.format("%d", countdown)
end
