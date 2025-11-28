autoImport("LotteryPray")
LotteryPrayMulti = class("LotteryPrayMulti", LotteryPray)
local _PagePath = "GUI/v1/part/LotteryPrayMulti"
local _PrayBtnEnabledEffectColor

function LotteryPrayMulti:CreateSelf(parent)
  self.gameObject = self:LoadPreferb_ByFullPath(_PagePath, parent, true)
  self.gameObject.transform.localPosition = LuaVector3.Zero()
  self:InitBord()
end

function LotteryPrayMulti:Init()
  self:FindObjs()
end

function LotteryPrayMulti:FindObjs()
  LotteryPrayMulti.super.FindObjs(self)
  self.bg = self:FindComponent("Bg", UISprite)
  self.helpRoot = self:FindGO("HelpRoot")
  local table = self:FindComponent("HelpTable", UITable, self.helpRoot)
  self.helpLabCtl = UIGridListCtrl.new(table, TipLabelCell, "LotteryPrayMultiTipLabelCell")
  self.infoRoot = self:FindGO("InfoRoot")
  local helpBtn = self:FindGO("HelpBtn", self.noCardSelectTipLab.gameObject)
  self:AddClickEvent(helpBtn, function()
    self:OnHelpBtnClick()
  end)
end

function LotteryPrayMulti:OnHelpBtnClick()
  self.inHelp = not self.inHelp
  self.helpRoot:SetActive(self.inHelp)
  self.infoRoot:SetActive(not self.inHelp)
  local x, y, z = LuaGameObject.GetLocalPositionGO(self.waittingPrayLab_Card.gameObject)
  y = self.inHelp and -158 or -105
  LuaGameObject.SetLocalPositionGO(self.waittingPrayLab_Card.gameObject, x, y, z)
end

function LotteryPrayMulti:UpdatePray(t)
  LotteryPrayMulti.super.UpdatePray(self, t)
  local cells = self.cardCtrl:GetCells()
  for i = 1, #cells do
    cells[i]:SetLocalScale(1.5)
  end
end

function LotteryPrayMulti:HandleUpdateLotteryPray()
  self:Hide()
end

local _offsetL = {200, 100}
local _offsetR = {-200, 100}

function LotteryPrayMulti:OnPressCard(param)
  local isPressing, cellCtl = param[1], param[2]
  if isPressing then
    if cellCtl and cellCtl.data then
      local data = cellCtl.data
      if data then
        local callback = function()
          self:CancelChooseCard()
        end
        local sdata = {
          itemdata = data,
          funcConfig = {},
          callback = callback,
          ignoreBounds = {
            cellCtl.gameObject
          },
          showCloseBtn = true
        }
        local index = (cellCtl.indexInList - 1) % 6 + 1
        local side = index <= 3 and NGUIUtil.AnchorSide.Right or NGUIUtil.AnchorSide.Left
        local offset = index <= 3 and _offsetR or _offsetL
        TipManager.Instance:ShowItemFloatTip(sdata, self.bg, side, offset)
      end
      self.chooseCard = cellCtl
    else
      self:CancelChooseCard()
    end
  else
  end
end

function LotteryPrayMulti:SetRule()
  LotteryPrayMulti.super.SetRule(self)
  self.helpLabCtl:ResetDatas(self.contextDatas)
end
