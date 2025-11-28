DialogUtil = class("DialogUtil")

function DialogUtil.GetDialogData(dialogid)
  if Table_Dialog == nil then
    autoImport("Table_Dialog")
  end
  if Table_Dialog then
    local data = Table_Dialog[dialogid]
    if not data then
      data = Table_Dialog[4]
      redlog("没有找到对话：" .. tostring(dialogid))
    end
    Game.transTable(data)
    return data
  end
end

function DialogUtil.SetViewMenuCtlByMenuData(menuGO, menuCtl, menuData)
  if not (menuGO and menuCtl) or not menuData then
    LogUtility.Warning("ArgumentNilException")
    return
  end
  local datas = ReusableTable.CreateArray()
  for i = 1, #menuData do
    if menuData[i].state ~= NpcFuncState.InActive then
      datas[#datas + 1] = menuData[i]
    end
  end
  local menuSprite = menuGO:GetComponent(UISprite)
  local realCount = #datas
  if menuSprite and 0 < realCount then
    if 6 < realCount then
      menuSprite.height = 500
    else
      menuSprite.height = 60 + realCount * 70
    end
    menuGO:SetActive(true)
  else
    menuGO:SetActive(false)
  end
  menuCtl:ResetDatas(datas)
  local lCtrl = menuCtl.layoutCtrl
  lCtrl.transform.localPosition = LuaGeometry.GetTempVector3(-12.42, -57, 0)
  lCtrl.repositionNow = true
  lCtrl:Reposition()
  ReusableTable.DestroyArray(datas)
end
