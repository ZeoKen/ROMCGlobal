local BaseCell = autoImport("BaseCell")
HomeRewardCell = class("HomeRewardCell", BaseCell)
HomeRewardCell.ResID = "GUI/v1/prefab/cell/HomeRewardCell"

function HomeRewardCell:ctor(go)
  HomeRewardCell.super.ctor(self, go)
end

function HomeRewardCell:Init()
  self:FindObj()
end

function HomeRewardCell:FindObj()
  local clickFunc = function()
    ServiceHomeCmdProxy.Instance:CallFurnitureOperHomeCmd(HomeProxy.Oper.Reward, self.data.id)
    HomeManager.Me():ClearFurnitureRewards()
  end
  UGUIEventListener.Get(self:FindGO("pic_biaoqingbg")).onClick = function(go)
    if UICamera.isOverUI then
      return
    end
    self:PlayUISound(AudioMap.UI.Click)
    self:CheckHandleClickEvent(nil, clickFunc, go)
  end
  local l_sprRewardIcon = self:FindComponent("home_reward_icon", UISprite)
  IconManager:SetItemIcon("item_700108", l_sprRewardIcon)
end

function HomeRewardCell:SetData(data)
  self.data = data
end

function HomeRewardCell:SetParent(parent)
  self.furniture = parent
end

function HomeRewardCell:Destroy()
  self.furniture:ClearReward()
end
