static const char norm_fg[] = "#FFFFFF";
static const char norm_bg[] = "#1e1f26";
static const char norm_border[] = "#6272A4";

static const char sel_fg[] = "#FFFFFF";
static const char sel_bg[] = "#50FA7B";
static const char sel_border[] = "#FFFFFF";

static const char urg_fg[] = "#FFFFFF";
static const char urg_bg[] = "#FF5555";
static const char urg_border[] = "#FF5555";

static const char *colors[][3]      = {
    /*               fg           bg         border                         */
    [SchemeNorm] = { norm_fg,     norm_bg,   norm_border }, // unfocused wins
    [SchemeSel]  = { sel_fg,      sel_bg,    sel_border },  // the focused win
    [SchemeUrg] =  { urg_fg,      urg_bg,    urg_border },
};
