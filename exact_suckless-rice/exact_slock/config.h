/* user and group to drop privileges to */
static const char *user  = "pablo";
static const char *group = "pablo";

static const char *colorname[NUMCOLS] = {
	[INIT] =   "#000000",     /* after initialization */
	[INPUT] =  "#83769c",   /* during input */
	[FAILED] = "#ff004d",   /* wrong password */
	[CAPS] = "#fff024",      /* CapsLock on */     
	[PAM] =    "#29adff",   /* waiting for PAM */
};

/* treat a cleared input like a wrong password (color) */
static const int failonclear = 1;

/* PAM service that's used for authentication */
static const char* pam_service = "login";
