autoImport("BaseCombineCell")
PackageWalletCombineItemCell = class("PackageWalletCombineItemCell", BaseCombineCell)
autoImport("PackageWalletCell")

function PackageWalletCombineItemCell:Init()
  self:InitCells(1, "PackageWalletCell", PackageWalletCell)
end
