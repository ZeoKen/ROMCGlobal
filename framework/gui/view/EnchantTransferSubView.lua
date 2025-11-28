autoImport("EnchantTransferView")
EnchantTransferSubView = class("EnchantTransferSubView", EnchantTransferView)
autoImport("EnchantNewCombineView")
EnchantTransferSubView.BrotherView = EnchantIntegerCombineView
EnchantTransferSubView.EquipChooseControl = EquipChooseBord_CombineSize
