autoImport("GemResultCell")
autoImport("BaseItemResultView")
GemResultView = class("GemResultView", BaseItemResultView)
GemResultView.CellControl = GemResultCell
GemResultView.Title = ZhString.Gem_ResultTitle
GemResultView.ViewType = UIViewType.PopUpLayer

function GemResultView:AddListenEvts()
end

function GemResultView:InitSnapshot()
end

function GemResultView:GetResultDatas()
  local viewData = self.viewdata.viewdata
  if not viewData or not next(viewData) then
    LogUtility.Error("Cannot get viewdata while initializing GemResultView!")
    return
  end
  self.isShowFuncBtns = viewData.isShowFuncBtns
  local data = viewData.data
  if type(data) ~= "table" or not next(data) then
    LogUtility.Error("Cannot get gem data to show while initializing GemResultView!")
    return
  end
  return data
end

function GemResultView:OnEnter()
  GemResultView.super.OnEnter(self)
  self:PlayUISound(AudioMap.UI.GemReward)
  self:ResetDatas()
  TimeTickManager.Me():CreateOnceDelayTick(250, function(owner, deltaTime)
    if self.listCtrl then
      self.listCtrl:Layout()
    end
  end, self)
end

function GemResultView:OnExit()
  TimeTickManager.Me():ClearTick(self)
  GemResultView.super.OnExit(self)
end

local tipOffset = {0, 0}

function GemResultView:_ShowItemTip(data, isGoRight)
  GemCell.ShowGemTip(nil, data, self.normalStick, 0 < isGoRight and NGUIUtil.AnchorSide.Left or NGUIUtil.AnchorSide.Right, tipOffset, nil, self.isShowFuncBtns)
end
