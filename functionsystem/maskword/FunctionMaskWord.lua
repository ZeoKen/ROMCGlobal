FunctionMaskWord = class("FunctionMaskWord")
FunctionMaskWord.MaskWordType = {
  SpecialSymbol = 1,
  Chat = 2,
  SpecialName = 4,
  Soliloquize = 8,
  NameExclude = 16,
  GuildSpecialSymbol = 32
}
FunctionMaskWord.MaxLength = 32

function FunctionMaskWord.Me()
  if nil == FunctionMaskWord.me then
    FunctionMaskWord.me = FunctionMaskWord.new()
  end
  return FunctionMaskWord.me
end

function FunctionMaskWord:ctor()
  self.replaceSymbol = "*"
  self:InitFilterWords()
end

function FunctionMaskWord:CheckMaskWord(word, type)
  return false
end

function FunctionMaskWord:Check(word, characterLibrary)
  for i = 1, #characterLibrary do
    if string.find(word, characterLibrary[i]) then
      return true, characterLibrary[i]
    end
  end
  return false
end

function FunctionMaskWord:ReplaceMaskWord(word, type)
  return self.csharpFilter:ReplaceBadWord(word, type)
end

local concatTable = {}

function FunctionMaskWord:Replace(word, characterLibrary)
  for i = 1, #characterLibrary do
    local lib = characterLibrary[i]
    if string.find(word, lib) then
      local len = StringUtil.Utf8len(lib)
      local replaceSymbol = ""
      TableUtility.ArrayClear(concatTable)
      for i = 1, len do
        concatTable[i] = self.replaceSymbol
      end
      replaceSymbol = table.concat(concatTable)
      word = string.gsub(word, lib, replaceSymbol)
    end
  end
  return word
end

function FunctionMaskWord:GetCharacterLibraryByType(maskType)
  if maskType == MaskWordType.SpecialSymbol then
    return self.fspecial
  elseif maskType == MaskWordType.Chat then
    return self.fchat
  elseif maskType == MaskWordType.SpecialName then
    return self.fname
  end
  return nil
end

function FunctionMaskWord:InitFilterWords()
  self.csharpFilter = DirtyWordFilter.Instance
  self.csharpFilter:ResetMaxLength(self.MaxLength)
  self:InitFilterWord(ObscenceLanguage.SpecialSymbol, FunctionMaskWord.MaskWordType.SpecialSymbol)
  self:InitFilterWord(ObscenceLanguage.Chat, FunctionMaskWord.MaskWordType.Chat)
  self:InitFilterWord(ObscenceLanguage.Name, FunctionMaskWord.MaskWordType.SpecialName)
  self:InitFilterWord(ObscenceLanguage.Soliloquize, FunctionMaskWord.MaskWordType.Soliloquize)
  self:InitFilterWord(ObscenceLanguage.NameExclude, FunctionMaskWord.MaskWordType.NameExclude)
  if ObscenceLanguage.GuildSpecialSymbol then
    self:InitFilterWord(ObscenceLanguage.GuildSpecialSymbol, FunctionMaskWord.MaskWordType.GuildSpecialSymbol)
  end
  ObscenceLanguage = nil
end

function FunctionMaskWord:InitFilterWord(strs, type)
  for i = 1, #strs do
    if strs[i] and 0 < #strs[i] and StringUtil.Utf8len(strs[i]) < self.MaxLength then
      self.csharpFilter:InitString(strs[i], type)
    else
      helplog("InitFilterWord is wrong", tostring(strs[i]), type)
    end
  end
end
