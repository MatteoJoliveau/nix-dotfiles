-- xmonad config used by Vic Fryzel
-- Author: Vic Fryzel
-- https://github.com/vicfryzel/xmonad-config
-- Customized by Matteo Joliveau
-- https://github.com/matteojoliveau/dotfiles

import System.IO
import System.Exit
import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName
import XMonad.Layout.PerWorkspace(onWorkspace)
import XMonad.Layout.Fullscreen
import XMonad.Layout.NoBorders
import XMonad.Layout.Spiral
import XMonad.Layout.Tabbed
import XMonad.Layout.ThreeColumns
import XMonad.Layout.ToggleLayouts
import XMonad.Layout.ResizableTile
import XMonad.Layout.Spacing
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import Graphics.X11.ExtraTypes.XF86
import qualified XMonad.StackSet as W
import qualified Data.Map        as M


------------------------------------------------------------------------
-- Terminal
-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
--
myTerminal = "alacritty"

-- The command to lock the screen or show the screensaver.
myScreensaver = "multilockscreen -l blur --off 600"

-- The command to take a selective screenshot, where you select
-- what you'd like to capture on the screen.
mySelectScreenshot = "select-screenshot"

-- The command to take a fullscreen screenshot.
myScreenshot = "screenshot"

-- The command to lookup an emoji
myEmoji = "splatmoji type"

-- The command to use as a launcher, to launch applications that don't have
-- preset keybindings.
myAppLauncher = "rofi -show combi -modi combi -combi-modi ssh,drun -theme onedark"

-- Password manager command
myPasswordManager = "bwmenu -- -theme onedark"

-- Clipboard manager command
myClipboardManager = "rofi -show clipboard -theme onedark -modi 'clipboard:greenclip print' -run-command '{cmd}'"

-- Location of your xmobar.hs / xmobarrc
myXmobarrc = "~/.xmonad/xmobar.hs"


------------------------------------------------------------------------
-- Workspaces
-- The default number of workspaces (virtual screens) and their names.
--
myWorkspaces = ["1:chats","2:web","3:code","4:terminals","5:games","6:media"] ++ map show [6..9]


------------------------------------------------------------------------
-- Window rules
-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
myManageHook = composeAll
    [ className =? "TelegramDesktop"         --> doShift "1:chats"
    , className =? "Slack"                   --> doShift "1:chats"
    , className =? "Discord"                 --> doShift "1:chats"
    , className =? "discord"                 --> doShift "1:chats"
    , className =? "Mailspring"              --> doShift "1:chats"
    , className =? "Navigator"               --> doShift "2:web"
    , className =? "Firefox"                 --> doShift "2:web"
    , className =? "Google-chrome"           --> doShift "2:web"
    , className =? "firefoxdeveloperedition" --> doShift "2:web"
    , className =? "jetbrains-idea"          --> doShift "3:code"
    , className =? "spotify"                 --> doShift "4:media"
    , resource  =? "desktop_window"          --> doIgnore
    , className =? "Galculator"              --> doFloat
    , className =? "Steam"                   --> doFloat
    , className =? "Gimp"                    --> doFloat
    , resource  =? "gpicview"                --> doFloat
    , className =? "MPlayer"                 --> doFloat
    , className =? "stalonetray"             --> doIgnore
    , isFullscreen --> (doF W.focusDown <+> doFullFloat)]


------------------------------------------------------------------------
-- Layouts
-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--
mySpacing i = spacingRaw True (Border i i i i) True (Border i i i i) True

myLayouts = avoidStruts (
--    mySpacing 5 $
   onWorkspace "1:chats" tabbedS $
   resizableTall |||
   threeColMid |||
   Mirror resizableTall |||
   tabbedS |||
   spiral (6/7)) |||
   noBorders (fullscreenFull Full)
  where
   resizableTall = ResizableTall 1 (3/100) (1/2) []
   threeColMid = ThreeColMid 1 (3/100) (1/2)
   tabbedS = tabbed shrinkText tabConfig


------------------------------------------------------------------------
-- Colors and borders
-- Currently based on the ir_black theme.
--
black = "#000000"
primaryColor = "#CEFFAC"

myNormalBorderColor  = black
myFocusedBorderColor = primaryColor

-- Colors for text and backgrounds of each tab when in "Tabbed" layout.
tabConfig = defaultTheme {
    activeBorderColor = primaryColor,
    activeTextColor = primaryColor,
    activeColor = black,
    inactiveBorderColor = "#7C7C7C",
    inactiveTextColor = "#EEEEEE",
    inactiveColor = black
}

-- Color of current window title in xmobar.
xmobarTitleColor = "#FFB6B0"

-- Color of current workspace in xmobar.
xmobarCurrentWorkspaceColor = primaryColor

-- Width of the window border in pixels.
myBorderWidth = 1


------------------------------------------------------------------------
-- Key bindings
--
-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
myModMask = mod4Mask

myKeys conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $
  ----------------------------------------------------------------------
  -- Custom key bindings
  --

  -- Start a terminal.  Terminal to start is specified by myTerminal variable.
  [ ((modMask, xK_Return),
     spawn $ XMonad.terminal conf)

  -- Lock the screen using command specified by myScreensaver.
  , ((modMask .|. shiftMask, xK_x),
     spawn myScreensaver)

  -- Spawn the launcher using command specified by myAppLauncher.
  -- Use this to launch programs without a key binding.
  , ((modMask, xK_d),
     spawn myAppLauncher)

  -- Spawn the emoji selector using command specified by myEmoji.
  , ((modMask .|. shiftMask, xK_d),
     spawn myEmoji)

  -- Spawn NetworkManager Dmenu
  , ((modMask, xK_F2),
     spawn "networkmanager_dmenu")

  -- Spawn Password Manager
  , ((modMask, xK_F3),
     spawn myPasswordManager)

  -- Spawn Clipboard Manager
  , ((modMask, xK_grave),
     spawn myClipboardManager)

  -- Take a selective screenshot using the command specified by mySelectScreenshot.
  , ((modMask .|. shiftMask, xK_p),
     spawn mySelectScreenshot)

  -- Take a full screenshot using the command specified by myScreenshot.
  , ((modMask .|. controlMask .|. shiftMask, xK_p),
     spawn myScreenshot)

  -- Mute volume.
  , ((0, xF86XK_AudioMute),
     spawn "pamixer --toggle-mute")

  -- Decrease volume.
  , ((0, xF86XK_AudioLowerVolume),
     spawn "pamixer --decrease 5")

  -- Increase volume.
  , ((0, xF86XK_AudioRaiseVolume),
     spawn "pamixer --increase 5")

  -- Audio previous.
  , ((0, xF86XK_AudioPrev),
     spawn "playerctl previous")

  -- Play/pause.
  , ((0, xF86XK_AudioPlay),
     spawn "playerctl play-pause")

  -- Audio next.
  , ((0, xF86XK_AudioNext),
     spawn "playerctl next")

  -- Display Brightness Up
  , ((0, xF86XK_MonBrightnessUp),
     spawn "brightnessctl set 10%+")

  -- Display Brightness Down
  , ((0, xF86XK_MonBrightnessDown),
     spawn "brightnessctl set 10%-")

  --------------------------------------------------------------------
  -- "Standard" xmonad key bindings
  --

  -- Close focused window.
  , ((modMask .|. shiftMask, xK_q),
     kill)

  -- Cycle through the available layout algorithms.
  , ((modMask, xK_space),
     sendMessage NextLayout)

  -- Toggle Fullscreen
  , ((modMask .|. shiftMask, xK_f),
      sendMessage (Toggle "Full"))

  -- Reset the layouts on the current workspace to default.
  , ((modMask .|. shiftMask, xK_space),
     setLayout $ XMonad.layoutHook conf)

  -- Resize viewed windows to the correct size.
  , ((modMask, xK_n),
     refresh)

  -- Resize vertically
  , ((modMask, xK_i), sendMessage MirrorShrink)
  , ((modMask, xK_o), sendMessage MirrorExpand)

  -- Move focus to the next window.
  , ((modMask, xK_Tab),
     windows W.focusDown)

  -- Move focus to the next window.
  , ((modMask, xK_j),
     windows W.focusDown)

  -- Move focus to the previous window.
  , ((modMask, xK_k),
     windows W.focusUp  )

  -- Move focus to the master window.
  , ((modMask, xK_m),
     windows W.focusMaster  )

  -- Swap the focused window and the master window.
  , ((modMask .|. shiftMask, xK_Return),
     windows W.swapMaster)

  -- Swap the focused window with the next window.
  , ((modMask .|. shiftMask, xK_j),
     windows W.swapDown  )

  -- Swap the focused window with the previous window.
  , ((modMask .|. shiftMask, xK_k),
     windows W.swapUp    )

  -- Shrink the master area.
  , ((modMask, xK_h),
     sendMessage Shrink)

  -- Expand the master area.
  , ((modMask, xK_l),
     sendMessage Expand)

  -- Push window back into tiling.
  , ((modMask, xK_t),
     withFocused $ windows . W.sink)

  -- Increment the number of windows in the master area.
  , ((modMask, xK_comma),
     sendMessage (IncMasterN 1))

  -- Decrement the number of windows in the master area.
  , ((modMask, xK_period),
     sendMessage (IncMasterN (-1)))

  -- Toggle the status bar gap.
  -- TODO: update this binding with avoidStruts, ((modMask, xK_b),

  -- Quit xmonad.
  , ((modMask .|. shiftMask, xK_z),
     io (exitWith ExitSuccess))

  -- Restart xmonad.
  , ((modMask .|. shiftMask, xK_c),
     restart "xmonad" True)
  ]
  ++

  -- mod-[1..9], Switch to workspace N
  -- mod-shift-[1..9], Move client to workspace N
  [((m .|. modMask, k), windows $ f i)
      | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
      , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
  ++

  -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
  -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
  [((m .|. modMask, key), screenWorkspace sc >>= flip whenJust (windows . f))
      | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
      , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]


------------------------------------------------------------------------
-- Mouse bindings
--
-- Focus rules
-- True if your focus should follow your mouse cursor.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

myMouseBindings (XConfig {XMonad.modMask = modMask}) = M.fromList $
  [
    -- mod-button1, Set the window to floating mode and move by dragging
    ((modMask, button1),
     (\w -> focus w >> mouseMoveWindow w))

    -- mod-button2, Raise the window to the top of the stack
    , ((modMask, button2),
       (\w -> focus w >> windows W.swapMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modMask, button3),
       (\w -> focus w >> mouseResizeWindow w))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
  ]


------------------------------------------------------------------------
-- Status bars and logging
-- Perform an arbitrary action on each internal state change or X event.
-- See the 'DynamicLog' extension for examples.
--
-- To emulate dwm's status bar
--
-- > logHook = dynamicLogDzen
--


------------------------------------------------------------------------
-- Startup hook
-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
myStartupHook :: X ()
myStartupHook = do
   setWMName "LG3D"
   spawnOn "1:chats" (myTerminal ++ " -e aerc")


------------------------------------------------------------------------
-- Run xmonad with all the defaults we set up.
--
main = do
  xmproc <- spawnPipe ("xmobar " ++ myXmobarrc)
  xmonad $ defaults {
      logHook = dynamicLogWithPP $ xmobarPP {
            ppOutput = hPutStrLn xmproc
          , ppTitle = xmobarColor xmobarTitleColor "" . shorten 100
          , ppCurrent = xmobarColor xmobarCurrentWorkspaceColor ""
          , ppSep = "   "
      }
      , manageHook = manageDocks <+> myManageHook
      , startupHook = myStartupHook
      , handleEventHook = docksEventHook
  }


------------------------------------------------------------------------
-- Combine it all together
-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will
-- use the defaults defined in xmonad/XMonad/Config.hs
--
-- No need to modify this.
--
defaults = defaultConfig {
    -- simple stuff
    terminal           = myTerminal,
    focusFollowsMouse  = myFocusFollowsMouse,
    borderWidth        = myBorderWidth,
    modMask            = myModMask,
    workspaces         = myWorkspaces,
    normalBorderColor  = myNormalBorderColor,
    focusedBorderColor = myFocusedBorderColor,

    -- key bindings
    keys               = myKeys,
    mouseBindings      = myMouseBindings,

    -- hooks, layouts
    layoutHook         = smartBorders $ myLayouts,
    manageHook         = myManageHook,
    startupHook        = myStartupHook
}
