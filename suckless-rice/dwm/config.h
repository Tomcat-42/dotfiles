/* See LICENSE file for copyright and license details. */

/* Teclas especiais */
#include <X11/XF86keysym.h>

#define KP_LEFT 0xff96
#define KP_RIGHT 0xff98
#define KP_BEGIN 0xff9d
#define KP_UP 0xff97
#define KP_DOWN 0xff99
#define KP_DIVIDE 0xffaf
#define KP_NEXT 0xff9b
#define KP_END 0xff9c
#define KP_SUBTRACT 0xffad
#define KP_PRIOR 0xff9a
#define KP_HOME 0xff95
#define KP_DECIMAL
#define KP_ENTER 0xff8d
#define KP_ADD 0xffab
#define KP_INSERT 0xff9e
#define KP_DELETE 0xff9f
#define SND_MUTE 0x1008ff12
#define SND_DEC 0x1008ff11
#define SND_INC 0x1008ff13
#define MIC_MUTE 0x1008ffb2
// #define BRIGH_DEC 0x1008ffb2
// #define BRIGH_DEC 0x1008ffb2
#define MONIT_SEL 0x1008ff59
#define WIFI_TOGGLE 0x1008ff95
#define CONFIG_LAUNCH 0x1008ff81
#define TOOGLE_BT 0x1008ff94
#define FAVORITES 0x1008ff30
#define SUPER 0xffeb
#define ISO3SHIFT 0xfe03
#define PRINT 0xff61

/* Programas */
#define BROWSER "firefox"
#define TERM "st"
#define GUIFM "pcmanfm"
#define CLIFM "ranger"

/* Fontes */
#define FONT "Iosevka Nerd Font:size=11:antialias=true:autohint=true"
#define FONT2 "Noto Color Emoji:pixelsize=16:antialias=true:autohint=true"
//#define FONT2 "Iosevka Term:size=11:antialias=true:autohint=true"

/* Cores do pywal */
#define PYWAL 1


/* appearance */
static const unsigned int borderpx  = 1;        /* border pixel of windows */
static const unsigned int snap      = 0;       /* snap pixel */
static const unsigned int gappih    = 0;       /* horiz inner gap between windows */
static const unsigned int gappiv    = 0;       /* vert inner gap between windows */
static const unsigned int gappoh    = 0;       /* horiz outer gap between windows and screen edge */
static const unsigned int gappov    = 0;       /* vert outer gap between windows and screen edge */
static       int smartgaps          = 1;        /* 1 means no outer gap when there is only one window */
static const int swallowfloating    = 1;        /* 1 means swallow floating windows by default */
static const int showbar            = 1;        /* 0 means no bar */
static const int topbar             = 1;        /* 0 means bottom bar */
static const int vertpad            = 0;       /* vertical padding of bar */
static const int sidepad            = 0;       /* horizontal padding of bar */

/*  Display modes of the tab bar: never shown, always shown, shown only in  */
/*  monocle mode in the presence of several windows.                        */
/*  Modes after showtab_nmodes are disabled.                                */
enum showtab_modes { showtab_never, showtab_auto, showtab_nmodes, showtab_always};
static const int showtab = showtab_auto;        /* Default tab bar show mode */
static const int toptab = 1;               /* False means bottom tab bar */

static const char *fonts[]          = { FONT, FONT2 };
static const char dmenufont[]       = FONT;

static const char norm_fg[] = "#fff1e8";
static const char norm_bg[] = "#000000";
static const char norm_border[] = "#000000";
static const char norm_float[] = "#000000";

static const char sel_fg[] = "#fff1e8";
static const char sel_bg[] = "#00e756";
static const char sel_border[] = "#83769c";
static const char sel_float[] = "#83769c";

static const char urg_fg[] = "#fff1e8";
static const char urg_bg[] = "#ff004d";
static const char urg_border[] = "#ff004d";
static const char urg_float[] = "#ff004d";


static const char col_gray1[]       = "#222222";
static const char col_gray2[]       = "#444444";
static const char col_gray3[]       = "#bbbbbb";
static const char col_gray4[]       = "#eeeeee";
static const char col_cyan[]        = "#29adff";

static const char col_col1[] = "#ffffff";
static const char col_col2[] = "#ff004d";
static const char col_col3[] = "#00e756";
static const char col_col4[] = "#fff024";
static const char col_col5[] = "#83769c";
static const char col_col6[] = "#ff77a8";
static const char col_col7[] = "#29adff";
static const char col_col8[] = "#ffffff";
static const char col_col9[] = "#008751";
static const char col_col10[] = "#fff1e8";
static const char col_col11[] = "#000000";


static const char *colors[][4]      = {
    /*               fg           bg         border       float      */
    [SchemeNorm] = { norm_fg,     norm_bg,   norm_border, norm_float }, // unfocused wins
    [SchemeSel]  = { sel_fg,      sel_bg,    sel_border, sel_float },  // the focused win
    [SchemeUrg] = {urg_fg, urg_border, urg_border, urg_float}
};

/* tagging */
static const char *tags[] = { "壱", "弐", "参", "四","五", "六", "七", "八", "九" };

static const char *tagsel[][2] = {
	{"#1e1f26",  "#ff004d"},
	{"#1e1f26",  "#00e756"},
	{"#1e1f26",  "#fff024"},
	{"#1e1f26",  "#83769c"},
	{"#1e1f26",  "#ff77a8"},
	{"#1e1f26",  "#29adff"},
	{"#1e1f26",  "#ffffff"},
	{"#1e1f26",  "#ff79c6"},
	{"#1e1f26",  "#008751"},
};

static const unsigned int ulinepad = 5;	/* horizontal padding between the underline and tag */
static const unsigned int ulinestroke = 2;	/* thickness / height of the underline */
static const unsigned int ulinevoffset = 0;	/* how far above the bottom of the bar the line should appear */
static const int ulineall = 0;	/* 1 to show underline on all tags, 0 for just the active ones */

static const Rule rules[] = {
	/* xprop(1):
	 *	WM_CLASS(STRING) = instance, class
	 *	WM_NAME(STRING) = title
	 */
	/* class                      instance              title                                tags mask               iscentered        isfloating        isterminal              noswallow                       monitor */
	{ "St",                       NULL,                 NULL,                                 1 << 8,                     0,                0,               1,                     -1,                             -1 },
	{ "Sxiv",                     NULL,                 NULL,                                 0     ,                     1,                1,               0,                      0,                             -1 },
	{ "mpv",                      NULL,                 NULL,                                 0     ,                     1,                1,               0,                      0,                             -1 },
	{ TERM ,                      NULL,                 CLIFM,                                1 << 1,                     0,                0,               0,                      0,                             -1 },
	{ "Pcmanfm",                  NULL,                 NULL,                                 1 << 1,                     0,                0,               0,                      0,                             -1 },
	{ "firefox",                  NULL,                 NULL,                                 1 << 2,                     0,                0,               0,                     -1,                             -1 },
	{ "Chromium",                 NULL,                 NULL,                                 1 << 2,                     0,                0,               0,                      0,                             -1 },
	{ "firefox",                  "Devtools",           NULL,                                 0,                          1,                1,               0,                      0,                             -1 },
	{ "qutebrowser",              NULL,                 NULL,                                 1 << 2,                     0,                0,               0,                      0,                             -1 },
	{ "Tor Browser",              NULL,                 NULL,                                 1 << 2,                     0,                0,               0,                      0,                             -1 },
	{ TERM ,                      NULL,                 "ncmpcpp",                            1 << 3,                     0,                0,               0,                      0,                             -1 },
	{ NULL,                       NULL,                 "spotify",                            1 << 3,                     0,                0,               0,                      0,                             -1 },
	{ "feh",                      NULL,                 NULL,                                 1 << 3,                     0,                0,               0,                      0,                             -1 },
	{ "vlc",                      NULL,                 NULL,                                 1 << 3,                     0,                0,               0,                      0,                             -1 },
	{ "Minetest",                 NULL,                 NULL,                                 1 << 4,                     0,                0,               0,                      0,                             -1 },
	//xonotic                                                                                                                                    
	{ "Darkplaces",               NULL,                 NULL,                                 1 << 4,                     0,                0,               0,                      0,                             -1 },
	{ "retroarch",                NULL,                 NULL,                                 1 << 4,                     0,                0,               0,                      0,                             -1 },
	//shiginima                                                                                                                                  
	{ "net-mc-main-Main",         NULL,                 NULL,                                 1 << 4,                     0,                0,               0,                      0,                             -1 },
	//minecraft                                                                                                                                  
	{ "^.*\\b(Minecraft)\\b.*$",  NULL,                 NULL,                                 1 << 4,                     0,                0,               0,                      0,                             -1 },
	{ "Steam" ,                   NULL,                 NULL,                                 1 << 4,                     0,                0,               0,                      0,                             -1 },
	//arduino-ide                                                                                                                                
	{ "PCSX2" ,                   NULL,                 NULL,                                 1 << 4,                     0,                0,               0,                      0,                             -1 },
	//{ "MPlayer",                 NULL,                 NULL,                                 1 << 5,                     1,                1,             0,0                       ,                              -1 },
	{ "MPlayer",                  NULL,                 NULL,                                 0,                          1,                1,               0,                      0,                             -1 },
	{ "ffplay",                   NULL,                 NULL,                                 1 << 5,                     1,                1,               0,                      0,                             -1 },
	{ "Gimp",                     NULL,                 NULL,                                 1 << 6,                     1,                1,               0,                      0,                             -1 },
	{ "Leafpad",                  NULL,                 NULL,                                 1 << 6,                     0,                0,               0,                      0,                             -1 },
	{ "Libreoffice",              NULL,                 NULL,                                 1 << 6,                     0,                0,               0,                      0,                             -1 },
	{ "Libreoffice-writer",       NULL,                 NULL,                                 1 << 6,                     0,                0,               0,                      0,                             -1 },
	{ "Libreoffice-impress",      NULL,                 NULL,                                 1 << 6,                     0,                0,               0,                      0,                             -1 },
	{ "Pavucontrol",              NULL,                 NULL,                                 1 << 7,                     0,                0,               0,                      0,                             -1 },
	{ "qpaeq" ,                   NULL,                 NULL,                                 1 << 7,                     0,                0,               0,                      0,                             -1 },
	{ "Lxappearance",             NULL,                 NULL,                                 1 << 7,                     0,                0,               0,                      0,                             -1 },
	{ "Gparted",                  NULL,                 NULL,                                 1 << 7,                     0,                0,               0,                      0,                             -1 },
	{ "Gsmartcontrol",            NULL,                 NULL,                                 1 << 7,                     0,                0,               0,                      0,                             -1 },
	{ "Filezilla",                NULL,                 NULL,                                 1 << 8,                     0,                0,               0,                      0,                             -1 },
	{ "discord",                  NULL,                 NULL,                                 1 << 8,                     0,                0,               0,                      0,                             -1 },
	{ TERM ,                      NULL,                 "newsboat",                           1 << 8,                     0,                0,               0,                      0,                             -1 },
	{ TERM ,                      NULL,                 "clima",                              1 << 8,                     0,                0,               0,                      0,                             -1 },
	{ TERM ,                      NULL,                 "calendario",                         1 << 8,                     0,                0,               0,                      0,                             -1 },
	{ "processing-app-Base" ,     NULL,                 NULL,                                 1 << 8,                     0,                0,               0,                      0,                             -1 },
	{ TERM ,                      NULL,                 "nload",                              1 << 8,                     0,                0,               0,                      0,                             -1 },
	{ "Microsoft Teams - Preview",NULL,                 NULL,                                 1 << 8,                     0,                0,               0,                      0,                             -1 },
	{ NULL,                       NULL,                 "Notificação do Microsoft Teams",     1 << 9,                     1,                1,               0,                      0,                             -1 },
	{ "quick_file_open",          "quick_file_open",    "quick_file_open",                    0,                          1,                1,               0,                      0,                             -1 },
};

/* layout(s) */
static const float mfact     = 0.55; /* factor of master area size [0.05..0.95] */
static const int nmaster     = 1;    /* number of clients in master area */
static const int resizehints = 1;    /* 1 means respect size hints in tiled resizals */
static const int lockfullscreen = 1; /* 1 will force focus on the fullscreen window */
static const int attachdirection = 5;    /* 0 default, 1 above, 2 aside, 3 below, 4 bottom, 5 top */

#define FORCE_VSPLIT 1  /* nrowgrid layout: force two clients to always split vertically */
#include "vanitygaps.c"
#include "movestack.c"

static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "H[]",      deck },
	{ "[M]",      monocle },
	{ ">M>",      centeredfloatingmaster },
	{ "|M|",      centeredmaster },
	{ "[]=",      tile },    /* first entry is default */
	{ "[@]",      spiral },
	{ "[\\]",     dwindle },
	{ "DD",     doubledeck },
	{ "TTT",      bstack },
	{ "===",      bstackhoriz },
	{ "HHH",      grid },
	{ "###",      nrowgrid },
	{ "---",      horizgrid },
	{ ":::",      gaplessgrid },
	{ "><>",      NULL },    /* no layout function means floating behavior */
	{ NULL,       NULL },
};

/* key definitions */
/* #define MODKEY Mod1Mask */
#define MODKEY Mod4Mask
#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

/* commands */
static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */
static const char *dmenucmd[] = { "dmenu_run", "-m", dmenumon, "-fn", dmenufont, NULL };
static const char *termcmd[]  = { TERM, NULL };
static const char *shellpythoncmd[]  = { TERM, "-t", "Shell_python", "-e", "python",  NULL };
static const char *password_manager[]  = {"spm-dmenu",  NULL };
static const char *browsercmd[]  = { BROWSER, NULL };
static const char *guiFMcmd[]  = { GUIFM, NULL };
static const char *cliFMcmd[]  = { TERM, "-t", "ranger", "-e", CLIFM, NULL };
static const char *ncmpcpp[]  = { TERM, "-t", "ncmpcpp", "-e", "ncmpcpp", NULL };
/* static const char *netmngr[]  = { "networkmanager_dmenu", NULL }; */
static const char *netmngr[]  = { "/home/pablo/scripts/dmenu_connection_manager", NULL };

static const char *quick_file_open[]  = { "st", "-i", "-g", "160x10+0+0", "-c", "quick_file_open", "-n", "quick_file_open","-t", "quick_file_open", "-e", "/home/pablo/scripts/quick_file_open", NULL };

static Key keys[] = {
  /* Custom Keys */

	//mpd keys
	{ MODKEY|ControlMask,             XK_u,      spawn,          SHCMD("mpc prev")},
	{ MODKEY|ControlMask,             XK_o,      spawn,          SHCMD("mpc next")},
	{ MODKEY|ControlMask,             XK_i,      spawn,          SHCMD("mpc toggle")},
	{ MODKEY|ControlMask,             XK_l,      spawn,          SHCMD("mpc seek +5")},
	{ MODKEY|ControlMask,             XK_j,      spawn,          SHCMD("mpc seek -5")},
	{ MODKEY|ControlMask,             XK_semicolon, spawn,          SHCMD("mpc random")},
	{ MODKEY|ControlMask,             XK_p,      spawn,          SHCMD("mpc stop")},
	//{ 0,                            KP_SUBTRACT,  spawn,       SHCMD("mpc shuffle")},
	//{ 0,                            KP_DECIMAL,   spawn,          SHCMD("mpc consume")},
	{ MODKEY|ControlMask,             XK_bracketright,  spawn,          SHCMD("mpc volume -5")},
	{ MODKEY|ControlMask,             XK_bracketleft,   spawn,          SHCMD("mpc volume +5")},
	//{ 0,                            KP_ENTER,  spawn,          SHCMD("mpc single")},
	//volume keys
	{ 0,                            SND_INC,     spawn,          SHCMD("pamixer -i 5")},
	{ 0,                            SND_DEC,   spawn,          SHCMD("pamixer -d 5")},
	{ 0,                            SND_MUTE, spawn,          SHCMD("pamixer -t")},
	{ 0,                            MIC_MUTE, spawn,          SHCMD("pamixer --default-source -t")},
	{ 0,                            MONIT_SEL, spawn,          SHCMD("/home/pablo/scripts/displayselect")},
	{ 0,                            WIFI_TOGGLE, spawn,          SHCMD("/home/pablo/scripts/toggle_wifi")},
	{ 0,                            FAVORITES,     spawn,          SHCMD("/home/pablo/scripts/search")},
	{ MODKEY,                       XK_period, spawn,          SHCMD("/home/pablo/scripts/mpdnotify")},
	
	//F1-F12 keys
	{ MODKEY,                       XK_F1,     spawn,          SHCMD(TERM " -t newsboat -e newsboat")},
	{ MODKEY,                       XK_F2,     spawn,          SHCMD(TERM " -t clima -e 'curl wttr.in'")},
	{ MODKEY,                       XK_F3,     spawn,          SHCMD(TERM " -t calendario -e 'bash /home/pablo/scripts/binding_calcurse.sh'")},
	{ MODKEY,                       XK_F5,     spawn,          SHCMD("/home/pablo/scripts/dmenu_mount")},
	{ MODKEY,                       XK_F6,     spawn,          SHCMD("/home/pablo/scripts/dmenu_umount")},
	{ MODKEY,                       XK_F8,     spawn,          SHCMD(TERM " -t nload -e nload")},
	{ MODKEY,                       XK_F9,     spawn,          SHCMD("/home/pablo/scripts/webcam")},
	{ MODKEY,                       XK_F10,    spawn,          SHCMD("/home/pablo/scripts/dmenu_record")},


	//Outros
	//{ MODKEY|ControlMask,           XK_k,      spawn,          SHCMD("setxkbmap -model abnt2 -layout br ; xset r rate 280 35") },
	{ MODKEY|ControlMask,           XK_l,      spawn,          SHCMD("/home/pablo/scripts/lock_n_off.sh") },
	{ MODKEY|ShiftMask,             XK_o,      spawn,          SHCMD("/home/pablo/scripts/desligar_monitor.sh off") },
	{ MODKEY|ShiftMask,             XK_s,      spawn,          SHCMD("/home/pablo/scripts/lock_n_off_n_suspend.sh") },
	{ MODKEY|ShiftMask,             XK_r,      spawn,          SHCMD("/home/pablo/scripts/redshift_dmenu") },
	{ MODKEY|ControlMask,           XK_b,      spawn,          SHCMD("/home/pablo/scripts/tlp_dmenu") },
	{ 0,                            CONFIG_LAUNCH,spawn,       SHCMD("/home/pablo/scripts/toggletouchpad") },
	//{ MODKEY,                  XK_Tab,      spawn,          SHCMD("rofi -show window -i -lines 10 -eh 1 -width 50 -padding 50 -opacity "85" -font \"Droid Sans 16\" ") },
	{ MODKEY,                       XK_Tab,    view,           {0} },
	{ MODKEY|ShiftMask,             XK_Tab,    spawn,           SHCMD("/home/pablo/scripts/switch") },
	{ MODKEY,                       XK_f,      spawn,          {.v = browsercmd} },
	{ MODKEY,                       XK_p,      spawn,          {.v = password_manager} },
	{ MODKEY,                       XK_o,      spawn,          {.v = quick_file_open} },
	// limpa as seleções
	{ MODKEY|ShiftMask,             XK_p,      spawn,          SHCMD("xsel -psb -c") },
	{ MODKEY,                       XK_m,      spawn,          {.v = guiFMcmd} },
	{ MODKEY,                       XK_r,      spawn,          {.v = cliFMcmd} },
	{ MODKEY,                       XK_n,      spawn,          {.v = ncmpcpp} },
	{ MODKEY|ShiftMask,             XK_n,      spawn,          {.v = netmngr} },
	{ MODKEY|ShiftMask,             XK_q,      killclient,     {0} },
	{ MODKEY|ShiftMask,              XK_Insert, spawn,          SHCMD("/home/pablo/scripts/showclip") },
	{ MODKEY|ControlMask,            XK_Insert, spawn,          SHCMD("/home/pablo/scripts/xcqr") },
	{ MODKEY,                       XK_w,      spawn,          SHCMD( TERM " -t weechat -e weechat")},
	//{ MODKEY,                       XK_c,      spawn,          SHCMD("/home/pablo/scripts/chcolor_gui") },
	{ MODKEY|ShiftMask,             XK_l,      spawn,          SHCMD("/home/pablo/scripts/toggle_caffeine") },
	{ MODKEY|ShiftMask,             XK_h,      spawn,          SHCMD("xcolor | xsel -i -b") },
	{ 0,                       XK_Print,  spawn,              SHCMD("/home/pablo/scripts/scrot_dmenu") },
	//{ MODKEY,                       XK_Print,     spawn,              SHCMD("scrot /home/pablo/`date +%Y-%m-%d_%H:%M:%S`.png") },
	//{ MODKEY|ShiftMask,             XK_Print,     spawn,          SHCMD("scrot -u /home/pablo/`date +%Y-%m-%d_%H:%M:%S`.png") },
	//{ MODKEY|ControlMask,           XK_Print,     spawn,          SHCMD("scrot -s /home/pablo/`date +%Y-%m-%d_%H:%M:%S`.png") },
	{ MODKEY,                       XK_Delete, spawn,          SHCMD("/home/pablo/scripts/dmenu_computer") },
	{ MODKEY,                       XK_x, spawn,          SHCMD("/home/pablo/scripts/mpdmenu :: -l 3") },
	{ MODKEY,                       XK_a, spawn,          SHCMD("/home/pablo/scripts/dmenu_xkb") },
	{ MODKEY,                       XK_g, spawn,          SHCMD("/home/pablo/scripts/dmenu_gpu") },
	
	//teclas especiais
	{ 0,                            XF86XK_MonBrightnessDown, spawn, SHCMD("xbacklight -dec 10") },
	{ 0,                            XF86XK_MonBrightnessUp, spawn, SHCMD("xbacklight -inc 10") },
	//{ 0,                            XF86XK_AudioPlay, spawn, SHCMD("mpc toggle") },
	{ 0,                            XF86XK_Sleep, spawn, SHCMD("/home/pablo/scripts/lock_n_off.sh") },
	{ MODKEY,                       XK_t,      spawn,          {.v = termcmd } },
	{ MODKEY,                       XK_c,      spawn,          {.v = dmenucmd } },


	/* modifier                     key        function        argument */
	{ MODKEY,                       XK_b,      togglebar,      {0} },
	{ MODKEY,                       XK_j,      focusstack,     {.i = +1 } },
	{ MODKEY,                       XK_k,      focusstack,     {.i = -1 } },
	{ MODKEY|ShiftMask,             XK_j,      movestack,      {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_k,      movestack,      {.i = -1 } },
	{ MODKEY,                       XK_i,      incnmaster,     {.i = +1 } },
	{ MODKEY,                       XK_d,      incnmaster,     {.i = -1 } },
	{ MODKEY,                       XK_h,      setmfact,       {.f = -0.05} },
	{ MODKEY,                       XK_l,      setmfact,       {.f = +0.05} },
  { MODKEY,                       XK_s,      togglecanfocusfloating,   {0} },
	{ MODKEY,                       XK_Return, zoom,           {0} },
	{ MODKEY|Mod4Mask,              XK_u,      incrgaps,       {.i = +1 } },
	{ MODKEY|Mod4Mask|ShiftMask,    XK_u,      incrgaps,       {.i = -1 } },
	{ MODKEY|Mod4Mask,              XK_i,      incrigaps,      {.i = +1 } },
	{ MODKEY|Mod4Mask|ShiftMask,    XK_i,      incrigaps,      {.i = -1 } },
	{ MODKEY|Mod4Mask,              XK_o,      incrogaps,      {.i = +1 } },
	{ MODKEY|Mod4Mask|ShiftMask,    XK_o,      incrogaps,      {.i = -1 } },
	{ MODKEY|Mod4Mask,              XK_6,      incrihgaps,     {.i = +1 } },
	{ MODKEY|Mod4Mask|ShiftMask,    XK_6,      incrihgaps,     {.i = -1 } },
	{ MODKEY|Mod4Mask,              XK_7,      incrivgaps,     {.i = +1 } },
	{ MODKEY|Mod4Mask|ShiftMask,    XK_7,      incrivgaps,     {.i = -1 } },
	{ MODKEY|Mod4Mask,              XK_8,      incrohgaps,     {.i = +1 } },
	{ MODKEY|Mod4Mask|ShiftMask,    XK_8,      incrohgaps,     {.i = -1 } },
	{ MODKEY|Mod4Mask,              XK_9,      incrovgaps,     {.i = +1 } },
	{ MODKEY|Mod4Mask|ShiftMask,    XK_9,      incrovgaps,     {.i = -1 } },
	{ MODKEY|Mod4Mask,              XK_0,      togglegaps,     {0} },
	{ MODKEY|Mod4Mask|ShiftMask,    XK_0,      defaultgaps,    {0} },
	{ MODKEY|ShiftMask,             XK_c,      killclient,     {0} },
	{ MODKEY|ControlMask,		XK_comma,  cyclelayout,    {.i = -1 } },
	{ MODKEY|ControlMask,           XK_period, cyclelayout,    {.i = +1 } },
	{ MODKEY,                       XK_space,  setlayout,      {0} },
	{ MODKEY|ShiftMask,             XK_space,  togglefloating, {0} },
	{ MODKEY|ShiftMask,             XK_f,      togglefullscr,  {0} },
	{ MODKEY,                       XK_Down,   moveresize,     {.v = "0x 25y 0w 0h" } },
	{ MODKEY,                       XK_Up,     moveresize,     {.v = "0x -25y 0w 0h" } },
	{ MODKEY,                       XK_Right,  moveresize,     {.v = "25x 0y 0w 0h" } },
	{ MODKEY,                       XK_Left,   moveresize,     {.v = "-25x 0y 0w 0h" } },
	{ MODKEY|ShiftMask,             XK_Down,   moveresize,     {.v = "0x 0y 0w 25h" } },
	{ MODKEY|ShiftMask,             XK_Up,     moveresize,     {.v = "0x 0y 0w -25h" } },
	{ MODKEY|ShiftMask,             XK_Right,  moveresize,     {.v = "0x 0y 25w 0h" } },
	{ MODKEY|ShiftMask,             XK_Left,   moveresize,     {.v = "0x 0y -25w 0h" } },
	{ MODKEY|ControlMask,           XK_Up,     moveresizeedge, {.v = "t"} },
	{ MODKEY|ControlMask,           XK_Down,   moveresizeedge, {.v = "b"} },
	{ MODKEY|ControlMask,           XK_Left,   moveresizeedge, {.v = "l"} },
	{ MODKEY|ControlMask,           XK_Right,  moveresizeedge, {.v = "r"} },
	{ MODKEY|ControlMask|ShiftMask, XK_Up,     moveresizeedge, {.v = "T"} },
	{ MODKEY|ControlMask|ShiftMask, XK_Down,   moveresizeedge, {.v = "B"} },
	{ MODKEY|ControlMask|ShiftMask, XK_Left,   moveresizeedge, {.v = "L"} },
	{ MODKEY|ControlMask|ShiftMask, XK_Right,  moveresizeedge, {.v = "R"} },
	{ MODKEY,                       XK_s,      togglesticky,   {0} },
	{ MODKEY,                       XK_0,      view,           {.ui = ~0 } },
	{ MODKEY|ShiftMask,             XK_0,      tag,            {.ui = ~0 } },
	{ MODKEY,                       XK_comma,  focusmon,       {.i = +1 } },
	{ MODKEY,                       XK_period, focusmon,       {.i = -1 } },
	{ MODKEY|ShiftMask,             XK_comma,  tagmon,         {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_period, tagmon,         {.i = -1 } },
	TAGKEYS(                        XK_1,                      0)
	TAGKEYS(                        XK_2,                      1)
	TAGKEYS(                        XK_3,                      2)
	TAGKEYS(                        XK_4,                      3)
	TAGKEYS(                        XK_5,                      4)
	TAGKEYS(                        XK_6,                      5)
	TAGKEYS(                        XK_7,                      6)
	TAGKEYS(                        XK_8,                      7)
	TAGKEYS(                        XK_9,                      8)
};

/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static Button buttons[] = {
	/* click                event mask      button          function        argument */
	{ ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
	{ ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
	{ ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },
	{ ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
	{ ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
	{ ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
	{ ClkTagBar,            0,              Button1,        view,           {0} },
	{ ClkTagBar,            0,              Button3,        toggleview,     {0} },
	{ ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};
