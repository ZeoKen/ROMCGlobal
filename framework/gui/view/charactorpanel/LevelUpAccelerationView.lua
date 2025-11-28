autoImport("LevelUpAccelerationCell")
LevelUpAccelerationView = class("LevelUpAccelerationView", SubView)

function LevelUpAccelerationView:Init()
  self:FindObjs()
end

function LevelUpAccelerationView:FindObjs()
  self.gameObject = self:FindGO("LevelUpAccelerationView")
  self.title = self:FindComponent("titleLabel", UILabel)
  local grid = self:FindComponent("Grid", UIGrid)
  
  function grid.onReposition()
    self:RelayoutGridList()
  end
  
  self.accelerationList = UIGridListCtrl.new(grid, LevelUpAccelerationCell, "LevelUpAccelerationCell")
end

local SortFunc = function(l, r)
  return l.id < r.id
end

function LevelUpAccelerationView:SetData(type)
  local totalRatio = 0
  local server_open_day = MyselfProxy.Instance.server_open_day
  local myPro = MyselfProxy.Instance:GetMyProfession()
  local isExpItemActived = MyselfProxy.Instance:IsProfessionSpeedUp(myPro)
  local datas = ReusableTable.CreateArray()
  for id, v in pairs(Table_SpeedUp) do
    local isNeeded = true
    local category = math.floor(id / 1000)
    if category == ESPEEDUPTYPE.ESPEEDUP_TYPE_SERVER then
      local after_open_server = v.Param.after_open_server or 1
      if server_open_day < after_open_server then
        isNeeded = false
      end
    elseif category == ESPEEDUPTYPE.ESPEEDUP_TYPE_ITEM then
      local depositIds = v.Param.deposit_id
      if depositIds then
        for i = 1, #depositIds do
          local depositId = depositIds[i]
          if not isExpItemActived and not NewRechargeTHotData.IsDepositItemCanShow(depositId) then
            isNeeded = false
            break
          end
        end
      end
    end
    if id % 1000 == type and isNeeded then
      local data = {}
      data.id = id
      data.category = category
      data.type = type
      local ratio = MyselfProxy.Instance:GetSpeedUpRatioById(id)
      data.addper = ratio
      totalRatio = totalRatio + ratio
      datas[#datas + 1] = data
    end
  end
  table.sort(datas, SortFunc)
  local str = type == 1 and ZhString.BASE_TOTAL_SPEED_UP or type == 2 and ZhString.JOB_TOTAL_SPEED_UP or ZhString.RUNE_TOTAL_SPEED_UP
  self.title.text = string.format(str, totalRatio)
  self.accelerationList:ResetDatas(datas)
  self.accelerationList:ResetPosition()
  ReusableTable.DestroyArray(datas)
end

function LevelUpAccelerationView:RelayoutGridList()
  local cells = self.accelerationList:GetCells()
  local y = 0
  for i = 1, #cells do
    local cell = cells[i]
    local bound = NGUIMath.CalculateRelativeWidgetBounds(cell.gameObject.transform)
    local x, _, z = LuaGameObject.GetLocalPositionGO(cell.gameObject)
    LuaGameObject.SetLocalPositionGO(cell.gameObject, x, y, z)
    y = y - (bound.size.y + 5)
  end
end
