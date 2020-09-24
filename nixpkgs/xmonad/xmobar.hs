-- xmobar config
-- Original Author: Vic Fryzel
-- https://github.com/vicfryzel/xmonad-config
-- Author: Matteo Joliveau
-- https://github.com/matteojoliveau/dotfiles

Config {
    position = Top,
    border = NoBorder,
    font = "xft:JetBrains Mono:size=10",
    bgColor = "#222",
    fgColor = "#ffffff",
    lowerOnStart = False,
    overrideRedirect = False,
    allDesktops = True,
    persistent = True,
    commands = [
          Run MultiCpu ["-t","Cpu: <total0> <total1> <total2> <total3> <total4> <total5>","-L","30","-H","60","-h","#FFB6B0","-l","#CEFFAC","-n","#FFFFCC","-w","3"] 10
        , Run Memory ["-t","Mem: <usedratio>%","-H","8192","-L","4096","-h","#FFB6B0","-l","#CEFFAC","-n","#FFFFCC"] 10
        , Run Swap ["-t","Swap: <usedratio>%","-H","1024","-L","512","-h","#FFB6B0","-l","#CEFFAC","-n","#FFFFCC"] 10
        , Run Date "%a %b %_d %H:%M" "date" 10
        , Run Wireless "wlp59s0" ["-a","l","-t","WiFi: <essid>"] 10
        , Run DynNetwork ["-t","Net: <rx>, <tx>","-H","200","-L","10","-h","#FFB6B0","-l","#CEFFAC","-n","#FFFFCC"] 10
        , Run Com "pamixer" ["--get-volume-human"] "volumelevel" 10
        , Run Battery ["-t", "<acstatus>: <left>%", "--", "-O", "AC", "-o", "Bat", "-h", "green", "-l", "red"] 10
        , Run StdinReader
    ],
    sepChar = "%",
    alignSep = "}{",
    template = "%StdinReader% }{ %multicpu%   %memory%   %swap%   %wlp59s0wi%   %dynnetwork%   Vol: <fc=#b2b2ff>%volumelevel%</fc> %battery%  <fc=#CEFFAC>%date%</fc>"
}
