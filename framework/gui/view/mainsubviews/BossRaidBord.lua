BossRaidBord = class("BossRaidBord", CoreView)
autoImport("Simple_BossIconCell")
local tickManager

function BossRaidBord:UpdateCountDownLb()
  self.countdown = self.countdown - 1
  local mm = math.floor(self.countdown / 60)
  local ss = self.countdown % 60
  self.countDownLb.text = string.format("%02d:%02d", mm, ss)
  if self.countdown <= 0 then
    self:StopCountDown()
  end
end

function BossRaidBord:StopCountDown()
  tickManager:ClearTick(self)
  self.countDownLb.text = "00:00"
end

function BossRaidBord:CountdownUpdateBossRaidBord(data)
  tickManager:ClearTick(self)
  self.countdown = data.body.time
  if "number" ~= type(self.countdown) then
    return
  end
  if self.countdown < 1 then
    return
  end
  local mm = math.floor(self.countdown / 60)
  local ss = self.countdown % 60
  self.countDownLb.text = string.format("%02d:%02d", mm, ss)
  tickManager:CreateTick(0, 1000, self.UpdateCountDownLb, self)
end

function BossRaidBord.LoadPreferb_ByFullPath(path, parent, initPanel)
  local obj = Game.AssetManager_UI:CreateAsset(path, parent.gameObject)
  if obj == nil then
    errorLog(path)
    return
  end
  UIUtil.ChangeLayer(obj, parent.gameObject.layer)
  obj.transform.localPosition = LuaGeometry.GetTempVector3()
  if obj and initPanel then
    local upPanel = UIUtil.GetComponentInParents(obj, UIPanel)
    if upPanel then
      local panels = UIUtil.GetAllComponentsInChildren(obj, UIPanel, true)
      for i = 1, #panels do
        panels[i].depth = panels[i].depth + upPanel.depth
      end
    end
  end
  return obj, path
end

function BossRaidBord.CreateSelf(parent)
  local go = BossRaidBord.LoadPreferb_ByFullPath("GUI/v1/part/BossRaidBord", parent, true)
  return BossRaidBord.new(go)
end

function BossRaidBord:ctor(go)
  self.gameObject = go
  tickManager = TimeTickManager.Me()
  self:InitView()
end

function BossRaidBord:InitView()
  self.grid = self:FindComponent("BossGrid", UIGrid)
  self.bossCtrl = UIGridListCtrl.new(self.grid, Simple_BossIconCell, "Simple_BossIconCell")
  self.countDownLb = self:FindComponent("countDown", UILabel)
  self.countDownLb.text = ""
end

function BossRaidBord:UpdateBoss()
  local bosslist = DungeonProxy.Instance:GetBossSceneInfo()
  if bosslist then
    self.bossCtrl:ResetDatas(bosslist)
  else
    self.bossCtrl:ResetDatas(_EmptyTable)
  end
end

function BossRaidBord:Finish()
  self.bossCtrl:ResetDatas(_EmptyTable)
end

function BossRaidBord:Destroy()
  tickManager:ClearTick(self)
  self.countDownLb.text = ""
  if not Slua.IsNull(self.gameObject) then
    GameObject.DestroyImmediate(self.gameObject)
  end
  self.gameObject = nil
end
