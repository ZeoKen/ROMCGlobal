ShortCutOptionPopUp = class("ShortCutOptionPopUp", BaseView)
autoImport("ShortCutItemCell")
ShortCutOptionPopUp.ViewType = UIViewType.PopUpLayer

function ShortCutOptionPopUp:Init()
  self.tip = self:FindComponent("Tips", UILabel)
  self.bg = self:FindComponent("Bg", UISprite)
  local grid = self:FindComponent("Grid", UIGrid)
  self.ctl = UIGridListCtrl.new(grid, ShortCutItemCell, "ShortCutItemCell")
  self.ctl:AddEventListener(MouseEvent.MouseClick, self.ClickItemTrace, self)
end

function ShortCutOptionPopUp:ClickItemTrace(shortCutItem)
  if shortCutItem.traceId then
    FuncShortCutFunc.Me():CallByID(shortCutItem.traceId, nil, self.showTraceInfo, self.growthid, shortCutItem.questId)
  end
  if shortCutItem.questData then
    FuncShortCutFunc.Me():CallByQuestFinishID(nil, nil, shortCutItem.questData)
  end
  self:CloseSelf()
end

local datas = {}

function ShortCutOptionPopUp:OnEnter()
  ShortCutOptionPopUp.super.OnEnter(self)
  local viewdata = self.viewdata.viewdata
  self.showTraceInfo = false
  if viewdata then
    local data = viewdata.data
    self.showTraceInfo = viewdata.showTraceInfo or false
    self.growthid = viewdata.growthid
    local alignIndex = viewdata.alignIndex or false
    TableUtility.ArrayClear(datas)
    if viewdata.functiontype == 2 then
      if data[1] == 0 then
        self.tip.gameObject:SetActive(true)
        self.tip.text = ZhString.ServantImproveCellState_Tip1
        self.bg.height = 551
      else
        self.tip.gameObject:SetActive(false)
        self.bg.height = 508
      end
      if data then
        for i = alignIndex and 1 or 2, #data do
          local staticData = Table_ServantQuestfinishStep[data[i]]
          local questData, questStep
          if staticData then
            for j = 1, #staticData.QuestStep do
              questStep = staticData.QuestStep[j]
              questData = QuestProxy.Instance:GetQuestDataBySameQuestID(questStep)
              if questData then
                table.insert(datas, questData)
                break
              end
            end
          end
          if not questData then
            local id = viewdata.gotomode[alignIndex and i or i - 1]
            helplog("搜不到任务，走gotomode", id)
            local shortCutData = Table_ShortcutPower[id]
            shortCutData.questId = staticData.QuestStep[1]
            table.insert(datas, shortCutData)
          end
        end
      end
      self.ctl:ResetDatas(datas)
    else
      if data then
        for i = 1, #data do
          local shortCutData = Table_ShortcutPower[data[i]]
          table.insert(datas, shortCutData)
        end
      else
        helplog("function ShortCutOptionPopUp:OnEnter() nil")
      end
      self.ctl:ResetDatas(datas)
    end
  end
end
