-- init.lua

-- Richard Zhao <richardz@andrew.cmu.edu>
-- modified by Aaron Gutierrez

local log = hs.logger.new('init', 'debug')
log.i('initializing')

--------------------------------------------------------------------------------
-- General ---------------------------------------------------------------------

local hyper = {'cmd', 'shift'}

local hotkey = require 'hs.hotkey'

hs.alert.defaultStyle.radius = 2
hs.alert.defaultStyle.textSize = 22
hs.alert.defaultStyle.textFont = 'Helvetica Neue'
hs.alert.defaultStyle.textColor = { white = 1, alpha = 0.95 }
hs.alert.defaultStyle.strokeColor = { white = 1, alpha = 0 }
hs.alert.defaultStyle.fillColor = { white = 0.2, alpha = 0.9 }

-- Configuration reload
hotkey.bind(hyper, 'r', function ()
  hs.reload()
end)
hs.alert.show('Config loaded')

--------------------------------------------------------------------------------
-- Scripts ---------------------------------------------------------------------

function newTerm()
  local iterm = [[ tell application "iTerm"
  create window with default profile
  activate
end tell
]]
  hs.osascript.applescript(iterm)
end

function newBrowser()
  local chrome = [[ tell application "Google Chrome"
  make new window
  activate
end tell
]]
  hs.osascript.applescript(chrome)
end

-- Open a new iTerm window
hotkey.bind(hyper, 'c', newTerm)
-- Open a new Chrome window
hotkey.bind(hyper, 'g', newBrowser)

-- Open a url (or prompt for one) and open as a chrome web app
function webApp(app)
 local web = [[
do shell script "~/bin/webapp APP"
]]
  hs.osascript.applescript(string.gsub(web, "APP", app))
end

local screen = require 'hs.screen'
local window = require 'hs.window'
local geom   = require 'hs.geometry'

function box ()
  return screen.primaryScreen():currentMode()
end

--------------------------------------------------------------------------------
-- Drawing ---------------------------------------------------------------------

local drawing = require 'hs.drawing'
local timer   = require 'hs.timer'

local hints = {
  font = 'Helvetica Neue',
  size = 36,
  width = 300,
  duration = 2,
  fadeIn = 0.2,
  fadeOut = 0.3,
}

local colors = {
  orange = { red = 214 / 255, green = 93 / 255, blue = 14 / 255, alpha = 0.9 },
  green  = { red = 152 / 255, green = 151 / 255, blue = 26 / 255, alpha = 0.9 },
  blue = { red = 69 / 255, green = 133 / 255, blue = 136 / 255, alpha = 0.9 },
  grey = { red = 0, green = 0, blue = 0, alpha = 0.7 }
}

-- Create a circle centered at (x, y) with radius r.
function hints.circle (x, y, r, color)
  local c = drawing.circle(geom(x - r, y - r, 2 * r, 2 * r))
  c:setStroke(false)
  c:setFillColor(color)
  return c
end

function hints.background ()
  local b = box ()
  local rect = drawing.rectangle(geom(0, 0, b.w, b.h))
                 :setStroke(false)
                 :setFillColor(colors.grey)
  return {
    show = function ()
      rect:show(hints.fadeIn)
    end,
    hide = function ()
      rect:hide(hints.fadeOut)
    end
  }
end

function hints.hint (x, y, key, msg, color)
  local radius = hints.size
  local circle = hints.circle(x + radius, y + radius, radius, color)
  local keyBox = hs.drawing.getTextDrawingSize(key, {
    font = hints.font, size = hints.size, alignment = 'center',
  })
  keyBox.w = keyBox.w + 3 -- known fudge factor (see getTextDrawingSize docs)

  local left = x + radius - keyBox.w / 2
  local top  = y + radius - keyBox.h / 2

  local keyText = hs.drawing.text(geom(left, top, keyBox.w, keyBox.h), key)
                   :setTextFont(hints.font)
                   :setTextSize(hints.size)

  local msgBox = hs.drawing.getTextDrawingSize(msg, {
    font = hints.font, size = hints.size, alignment = 'left',
  })
  msgBox.w = msgBox.w + hints.size
  if msgBox.w > hints.width then
    log.i('width ' .. msgBox.w .. ' of hint ' .. msg .. ' too large')
  end

  local msgText = hs.drawing.text(geom(left + hints.size * 2, top, hints.width, msgBox.h), msg)
                    :setTextFont(hints.font)
                    :setTextSize(hints.size)

  return {
    show = function ()
      circle:show(hints.fadeIn)
      keyText:show(hints.fadeIn)
      msgText:show(hints.fadeIn)
    end,
    hide = function ()
      circle:hide(hints.fadeOut)
      keyText:hide(hints.fadeOut)
      msgText:hide(hints.fadeOut)
    end
  }
end

--------------------------------------------------------------------------------
-- Hydra -----------------------------------------------------------------------

local hydraExitKey = 'escape'

local hydraDefinitions = {
  {
    mods  = hyper,
    key   = 'space',
    hint  = 'head',
    master = true,
    actions = {
      { mod = '', key = 'A', hint = 'Asana', target = function() webApp('https://app.asana.com') end, exit = true },
      { mod = '', key = 'G', hint = 'Google Chrome', target = newBrowser, exit = true },
      { mod = '', key = 'N', hint = 'New York Times', target = function() webApp('http://app.nytimes.com') end, exit = true },
      { mod = '', key = 'M', hint = 'Messenger', target = function() webApp('https://messenger.com') end, exit = true },
      { mod = '', key = 'S', hint = 'Slack', target = function() hs.application.launchOrFocus('Slack')  end, exit = true },
      { mod = '', key = 'T', hint = 'Terminal', target = newTerm, exit = true },
      { mod = '', key = 'W', hint = 'WebApp', target = function() webApp('') end, exit = true },
    },
    hydras = {}
  }
}

function tableLen(T)
  local count = 0
  for k, v in pairs(T) do
    count = count + 1
  end
  return count
end

function hydraGenerateHints (hydra)
  local b = box ()
  local hintTable = {}

  local numHints = tableLen(hydra.hydras) + tableLen(hydra.actions)
  local height = hints.size * 2 + hints.size / 2
  local totalHeight = numHints * height

  local left = b.w / 2 - hints.width / 2 - 50
  local top  = b.h / 2 - totalHeight / 2

  local y = top

  -- generate child hydras first
  for _, child in pairs(hydra.hydras) do
    local hint = hints.hint(left, y, child.key, child.hint, colors.orange)
    table.insert(hintTable, hint)
    y = y + height
  end

  -- and then actions
  for _, child in pairs(hydra.actions) do
    local hint
    if child.exit then
      hint = hints.hint(left, y, child.key, child.hint, colors.blue)
    else
      hint = hints.hint(left, y, child.key, child.hint, colors.green)
    end
    table.insert(hintTable, hint)
    y = y + height
  end

  return {
    show = function ()
      for _, hint in pairs(hintTable) do
        hint.show()
      end
    end,
    hide = function ()
      for _, hint in pairs(hintTable) do
        hint.hide()
      end
    end
  }
end

function hydraExitAllAndHideHints ()
  recurse = function (hydras)
    for _, hydra in pairs(hydras) do
      if hydra.master ~= nil and hydra.master == true then
        hydra.background.hide()
      end
      hydra.modal:exit()
      hydra.hints.hide()
      if next(hydra.hydras) ~= nil then
        recurse(hydra.hydras)
      end
    end
  end
  recurse(hydraDefinitions)
end

function hydraInit (parentHydra, hydras)
  if next(hydras) == nil then return end

  -- add modals to each body and bind all actions
  for _, hydra in pairs(hydras) do
    -- generate a new modal and put it under its parent
    hydra.modal = hotkey.modal.new()
    hydra.modal:bind('', hydraExitKey, function() hydraExitAllAndHideHints () end)

    -- global bind of master
    if hydra.master ~= nil and hydra.master == true then
      hydra.background = hints.background ()
      hotkey.bind(hydra.mods, hydra.key, function ()
        hydra.background.show()
        hydra.modal:enter()
      end)
    else
      parentHydra.modal:bind(hydra.mods, hydra.key, function()
        parentHydra.modal:exit()
        hydra.modal:enter()
      end)
    end

    -- add the hint drawing objects
    hydra.hints = hydraGenerateHints(hydra)

    -- for debugging
    function hydra.modal:entered()
      hydra.hints.show()
      log.i("hydra [" .. hydra.hint .. "] entered")
    end
    function hydra.modal:exited()
      hydra.hints.hide()
      log.i("hydra [" .. hydra.hint .. "] exited")
    end

    -- add actions
    for _, action in ipairs(hydra.actions) do
      hydra.modal:bind(action.mod, action.key, function ()
        if action.exit then hydraExitAllAndHideHints () end
        action.target ()
      end)
      log.i("hydra [" .. hydra.hint .. "] binding action " .. action.hint)
    end

    -- recurse on children
    hydraInit (hydra, hydra.hydras)
  end
end

-- Create all hydras under the head
hydraInit (nil, hydraDefinitions)
