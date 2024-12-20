local select = require "select"
select.label_maker = function(s)
  local chars = s.charset("asdfqwerzxcv")
  return s.trim(s.sort(s.reverse(chars)))
end

local newtab_chrome = require "newtab_chrome"
newtab_chrome.new_tab_file = nil
newtab_chrome.new_tab_src = nil
