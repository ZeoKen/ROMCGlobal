BackwardCompatibilityUtil = class("BackwardCompatibilityUtil")
BackwardCompatibilityUtil.V6 = 6
BackwardCompatibilityUtil.V8 = 8
BackwardCompatibilityUtil.V9 = 9
BackwardCompatibilityUtil.V10 = 10
BackwardCompatibilityUtil.V11 = 11
BackwardCompatibilityUtil.V12 = 12
BackwardCompatibilityUtil.V13 = 14
BackwardCompatibilityUtil.V16 = 16
local currentVersion = CompatibilityVersion.version
local BuildVersionName = function(v)
  local v100 = math.floor(v / 100)
  v = v - v100 * 100
  local v10 = math.floor(v / 10)
  v = v - v10 * 10
  if v100 <= 0 then
    v100 = 1
  end
  return string.format("%d.%d.%d", v100, v10, v)
end
local currentVersionName = BuildVersionName(currentVersion)

function BackwardCompatibilityUtil.GetCurrentVersionName()
  return currentVersionName
end

function BackwardCompatibilityUtil.CompatibilityMode(v)
  return v >= currentVersion
end

local SelfClass = BackwardCompatibilityUtil
SelfClass.CompatibilityMode_V9 = SelfClass.CompatibilityMode(SelfClass.V9)
SelfClass.CompatibilityMode_V10 = SelfClass.CompatibilityMode(SelfClass.V10)
SelfClass.CompatibilityMode_V11 = SelfClass.CompatibilityMode(SelfClass.V11)
SelfClass.CompatibilityMode_V12 = SelfClass.CompatibilityMode(SelfClass.V12)
SelfClass.CompatibilityMode_V13 = SelfClass.CompatibilityMode(SelfClass.V13)
SelfClass.CompatibilityMode_V15 = SelfClass.CompatibilityMode(15)
SelfClass.CompatibilityMode_V16 = SelfClass.CompatibilityMode(16)
SelfClass.CompatibilityMode_V17 = SelfClass.CompatibilityMode(17)
SelfClass.CompatibilityMode_V18 = SelfClass.CompatibilityMode(18)
SelfClass.CompatibilityMode_V19 = SelfClass.CompatibilityMode(19)
SelfClass.CompatibilityMode_V20 = SelfClass.CompatibilityMode(20)
SelfClass.CompatibilityMode_V21 = SelfClass.CompatibilityMode(21)
SelfClass.CompatibilityMode_V22 = SelfClass.CompatibilityMode(22)
SelfClass.CompatibilityMode_V22 = SelfClass.CompatibilityMode(22)
SelfClass.CompatibilityMode_V23 = SelfClass.CompatibilityMode(23)
SelfClass.CompatibilityMode_V24 = SelfClass.CompatibilityMode(24)
SelfClass.CompatibilityMode_V25 = SelfClass.CompatibilityMode(25)
SelfClass.CompatibilityMode_V26 = SelfClass.CompatibilityMode(26)
SelfClass.CompatibilityMode_V27 = SelfClass.CompatibilityMode(27)
SelfClass.CompatibilityMode_V28 = SelfClass.CompatibilityMode(28)
SelfClass.CompatibilityMode_V29 = SelfClass.CompatibilityMode(29)
SelfClass.CompatibilityMode_V30 = SelfClass.CompatibilityMode(30)
SelfClass.CompatibilityMode_V31 = SelfClass.CompatibilityMode(31)
SelfClass.CompatibilityMode_V32 = SelfClass.CompatibilityMode(32)
SelfClass.CompatibilityMode_V33 = SelfClass.CompatibilityMode(33)
SelfClass.CompatibilityMode_V34 = SelfClass.CompatibilityMode(34)
SelfClass.CompatibilityMode_V35 = SelfClass.CompatibilityMode(35)
SelfClass.CompatibilityMode_V36 = SelfClass.CompatibilityMode(36)
SelfClass.CompatibilityMode_V37 = SelfClass.CompatibilityMode(37)
SelfClass.CompatibilityMode_V38 = SelfClass.CompatibilityMode(38)
SelfClass.CompatibilityMode_V39 = SelfClass.CompatibilityMode(39)
SelfClass.CompatibilityMode_V40 = SelfClass.CompatibilityMode(40)
SelfClass.CompatibilityMode_V41 = SelfClass.CompatibilityMode(41)
SelfClass.CompatibilityMode_V42 = SelfClass.CompatibilityMode(42)
SelfClass.CompatibilityMode_V43 = SelfClass.CompatibilityMode(43)
SelfClass.CompatibilityMode_V44 = SelfClass.CompatibilityMode(44)
SelfClass.CompatibilityMode_V45 = SelfClass.CompatibilityMode(45)
SelfClass.CompatibilityMode_V46 = SelfClass.CompatibilityMode(46)
SelfClass.CompatibilityMode_V47 = SelfClass.CompatibilityMode(47)
SelfClass.CompatibilityMode_V48 = SelfClass.CompatibilityMode(48)
SelfClass.CompatibilityMode_V49 = SelfClass.CompatibilityMode(49)
SelfClass.CompatibilityMode_V50 = SelfClass.CompatibilityMode(50)
SelfClass.CompatibilityMode_V51 = SelfClass.CompatibilityMode(51)
SelfClass.CompatibilityMode_V52 = SelfClass.CompatibilityMode(52)
SelfClass.CompatibilityMode_V53 = SelfClass.CompatibilityMode(53)
SelfClass.CompatibilityMode_V54 = SelfClass.CompatibilityMode(54)
SelfClass.CompatibilityMode_V55 = SelfClass.CompatibilityMode(55)
SelfClass.CompatibilityMode_V56 = SelfClass.CompatibilityMode(56)
SelfClass.CompatibilityMode_V57 = SelfClass.CompatibilityMode(57)
SelfClass.CompatibilityMode_V58 = SelfClass.CompatibilityMode(58)
SelfClass.CompatibilityMode_V59 = SelfClass.CompatibilityMode(59)
SelfClass.CompatibilityMode_V60 = SelfClass.CompatibilityMode(60)
SelfClass.CompatibilityMode_V61 = SelfClass.CompatibilityMode(61)
SelfClass.CompatibilityMode_V62 = SelfClass.CompatibilityMode(62)
SelfClass.CompatibilityMode_V63 = SelfClass.CompatibilityMode(63)
SelfClass.CompatibilityMode_V64 = SelfClass.CompatibilityMode(64)
SelfClass.CompatibilityMode_V65 = SelfClass.CompatibilityMode(65)
SelfClass.CompatibilityMode_V66 = SelfClass.CompatibilityMode(66)
SelfClass.CompatibilityMode_V67 = SelfClass.CompatibilityMode(67)
SelfClass.CompatibilityMode_V68 = SelfClass.CompatibilityMode(68)
SelfClass.CompatibilityMode_V69 = SelfClass.CompatibilityMode(69)
SelfClass.CompatibilityMode_V70 = SelfClass.CompatibilityMode(70)
SelfClass.CompatibilityMode_V71 = SelfClass.CompatibilityMode(71)
SelfClass.CompatibilityMode_V72 = SelfClass.CompatibilityMode(72)
SelfClass.CompatibilityMode_V73 = SelfClass.CompatibilityMode(73)
SelfClass.CompatibilityMode_V74 = SelfClass.CompatibilityMode(74)
SelfClass.CompatibilityMode_V75 = SelfClass.CompatibilityMode(75)
SelfClass.CompatibilityMode_V76 = SelfClass.CompatibilityMode(76)
SelfClass.CompatibilityMode_V77 = SelfClass.CompatibilityMode(77)
SelfClass.CompatibilityMode_V78 = SelfClass.CompatibilityMode(78)
SelfClass.CompatibilityMode_V79 = SelfClass.CompatibilityMode(79)
SelfClass.CompatibilityMode_V80 = SelfClass.CompatibilityMode(80)
SelfClass.CompatibilityMode_V81 = SelfClass.CompatibilityMode(81)
SelfClass.CompatibilityMode_V82 = SelfClass.CompatibilityMode(82)
SelfClass.CompatibilityMode_V83 = SelfClass.CompatibilityMode(83)
SelfClass.CompatibilityMode_V84 = SelfClass.CompatibilityMode(84)
SelfClass.CompatibilityMode_V85 = SelfClass.CompatibilityMode(85)
SelfClass.CompatibilityMode_V86 = SelfClass.CompatibilityMode(86)
SelfClass.CompatibilityMode_V87 = SelfClass.CompatibilityMode(87)
SelfClass.CompatibilityMode_V88 = SelfClass.CompatibilityMode(88)
SelfClass.CompatibilityMode_V89 = SelfClass.CompatibilityMode(89)
SelfClass.CompatibilityMode_V90 = SelfClass.CompatibilityMode(90)
SelfClass.CompatibilityMode_Vspeech = SelfClass.CompatibilityMode(99)
