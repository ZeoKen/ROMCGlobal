local baseCell = autoImport("BaseCell")
DMMapIntroCell = class("DMMapIntroCell", baseCell)
autoImport("DMMapListComineCell")

function DMMapIntroCell:Init()
  self:InitView()
end

function DMMapIntroCell:InitView()
  self.iconContainer = self:FindGO("iconContainer")
  self.introTable = self:FindComponent("UITableP", UITable)
  self.LeftCtrl = UIGridListCtrl.new(self.introTable, DMMapListComineCell, "DMMapListComineCell")
  self.LeftCtrl:AddEventListener(MouseEvent.MouseClick, self.ClickGoal, self)
  self.LeftCtrl:ResetDatas(self:GenerateMapIntroInfo())
  local rightScrollPanel = self:FindComponent("Right", UIPanel)
  local panel = GameObjectUtil.Instance:FindCompInParents(self.gameObject, UIScrollView).panel
  rightScrollPanel.depth = panel.depth + 1
end

function DMMapIntroCell:ClickGoal(parama)
  if "Father" == parama.type then
    local combine = parama.combine
    if combine.data ~= nil then
      if combine == self.combineGoal then
        combine:PlayReverseAnimation()
        return
      end
      if self.combineGoal and next(self.combineGoal) ~= nil then
        self.combineGoal:SetChoose(false)
        self.combineGoal:SetFolderState(false)
        self.combineGoal = nil
      end
      self.combineGoal = combine
      self.combineGoal:PlayReverseAnimation()
      self.fatherGoalId = combine.data.fatherGoal.id
      self.goal = self.fatherGoalId
    else
    end
  else
    if parama.child and parama.child.linkIcon then
      local tween = parama.child.linkIcon:GetComponent(TweenScale)
      if tween then
        tween:ResetToBeginning()
        tween:PlayForward()
      end
    else
    end
  end
end

local sortFunc = function(a, b)
  return a.ShowOrder > b.ShowOrder
end

function DMMapIntroCell:GenerateMapIntroInfo()
  if not self.info then
    self.info = {}
  end
  TableUtility.ArrayClear(self.info)
  local table_mapintro = Table_MapIntro or Local_Table_MapIntro
  local child
  for _, v in pairs(table_mapintro) do
    if v.Type == "father" then
      local data = {}
      data.ShowOrder = v.ShowOrder or v.id
      data.fatherGoal = {}
      data.fatherGoal.isMapIntroCell = true
      data.fatherGoal.Name = v.Name
      data.fatherGoal.Img = v.Icon
      data.childGoals = {}
      if v.Child then
        for i = 1, #v.Child do
          child = table_mapintro[v.Child[i]]
          if child then
            local cdata = {}
            cdata.Name = child.Name
            cdata.Img = child.Icon
            cdata.Pos = {}
            cdata.Pos[1] = child.Pos[1]
            cdata.Pos[2] = child.Pos[2]
            cdata.iconContainer = self.iconContainer
            data.childGoals[i] = cdata
          end
        end
      end
      TableUtility.InsertSort(self.info, data, sortFunc)
    end
  end
  return self.info
end

Local_Table_MapIntro = {
  [1] = {
    id = 1,
    Name = "示例1",
    Icon = {"map_barber", "map_eye"},
    Type = "father",
    Child = {
      2,
      3,
      4,
      5
    },
    ShowOrder = 1
  },
  [2] = {
    id = 2,
    Name = "示例2",
    Icon = {"map_eye"},
    Type = "child",
    Pos = {1, 2}
  },
  [3] = {
    id = 3,
    Name = "示例3",
    Icon = {"map_eye"},
    Type = "child",
    Pos = {30, 40}
  },
  [4] = {
    id = 4,
    Name = "示例4",
    Icon = {"map_eye"},
    Type = "child",
    Pos = {60, -50}
  },
  [5] = {
    id = 5,
    Name = "示例5",
    Icon = {"map_eye"},
    Type = "child",
    Pos = {-100, -120}
  },
  [6] = {
    id = 6,
    Name = "示例6",
    Icon = {
      "map_barber",
      "map_eye",
      "map_eye"
    },
    Type = "father",
    ShowOrder = 2
  }
}
