static const char norm_fg[] = "#fff1e8";
static const char norm_bg[] = "#000000";
static const char norm_border[] = "#008751";

static const char sel_fg[] = "#fff1e8";
static const char sel_bg[] = "#00e756";
static const char sel_border[] = "#fff1e8";

static const char urg_fg[] = "#fff1e8";
static const char urg_bg[] = "#ff004d";
static const char urg_border[] = "#ff004d";

static const char *colors[][3]      = {
    /*               fg           bg         border                         */
    [SchemeNorm] = { norm_fg,     norm_bg,   norm_border }, // unfocused wins
    [SchemeSel]  = { sel_fg,      sel_bg,    sel_border },  // the focused win
    [SchemeUrg] =  { urg_fg,      urg_bg,    urg_border },
};
