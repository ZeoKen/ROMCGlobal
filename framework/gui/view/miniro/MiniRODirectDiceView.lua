MiniRODirectDiceView = class("MiniRODirectDiceView", BaseView)
MiniRODirectDiceView.ViewType = UIViewType.PopUpLayer

function MiniRODirectDiceView:Init()
  self.selectIndex = 1
  self:FindObjs()
  self:AddEvents()
  self:AddListenEvts()
end

function MiniRODirectDiceView:OnEnter()
  self.selectIndex = 1
  MiniRODirectDiceView.super.OnEnter(self)
end

function MiniRODirectDiceView:OnExit()
  self.selectIndex = 1
  MiniRODirectDiceView.super.OnExit(self)
end

function MiniRODirectDiceView:FindObjs()
  self.objSelect = self:FindGO("objSelect")
  self.listDiceObj = {}
  for i = 1, 6 do
    self.listDiceObj[i] = self:FindGO("btn" .. i)
  end
end

function MiniRODirectDiceView:AddEvents()
  for i = 1, 6 do
    self:AddClickEvent(self.listDiceObj[i], function(go)
      for k, v in pairs(self.listDiceObj) do
        if v == go then
          self.selectIndex = k
          self.objSelect.transform.localPosition = go.transform.localPosition
          break
        end
      end
    end)
  end
  self:AddButtonEvent("btnConfirm", function(go)
    ServiceActMiniRoCmdProxy.Instance:CallActMiniRoCastDice(EACTMINIRODICETYPE.EACTMINIRODICETYPE_ASSIGN, self.selectIndex)
    self:CloseSelf()
  end)
end

function MiniRODirectDiceView:AddListenEvts()
  self:AddListenEvt(ServiceEvent.ActMiniRoCmdActMiniRoCastDice, self.CloseView)
end

function MiniRODirectDiceView:CloseView()
  self:CloseSelf()
end
