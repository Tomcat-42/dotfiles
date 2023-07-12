#define _BSD_SOURCE
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>
#include <ctype.h>
#include <strings.h>
#include <sys/time.h>
#include <time.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <X11/Xlib.h>
#include <sys/statvfs.h>
#include <mpd/client.h>
#include <sys/sysinfo.h>

//0 desktop , 1 notebook
#define NOTEBOOK 1

//options
#define BAT_DEVICE_1 "BAT1"
#define BAT_DEVICE_0 "BAT0"
#define BAT_FULL_SYMBOL '='
#define BAT_CHARGING_SYMBOL '+'
#define BAT_DISCHARGING_SYMBOL '-'
#define TEMP_SENSOR_DIR "/sys/devices/virtual/thermal/thermal_zone0/"
#define TEMP_SENSOR0 "hwmon1"
#define MPD_PORT 60960
#define MPD_HOST "localhost"
#define MPD_MAX_SONG_LEN 25
#define MPD_STATUS_ICON ""
#define MPD_PLAYING_ICON ""
#define MPD_PAUSED_ICON ""
#define ROOTFS "/"
#define DATAFS "/mnt/PABLO"
#define WIRELESS_IFACE "wlp3s0"
#define WIRED_IFACE "enp0s31f6"

//timezones
char *tzutc = "UTC";
char *tzsp = "America/Sao_Paulo";

static Display *dpy;

char *
smprintf(char *fmt, ...)
{
	va_list fmtargs;
	char *ret;
	int len;

	va_start(fmtargs, fmt);
	len = vsnprintf(NULL, 0, fmt, fmtargs);
	va_end(fmtargs);

	ret = malloc(++len);
	if (ret == NULL) {
		perror("malloc");
		exit(1);
	}

	va_start(fmtargs, fmt);
	vsnprintf(ret, len, fmt, fmtargs);
	va_end(fmtargs);

	return ret;
}

void
settz(char *tzname)
{
	setenv("TZ", tzname, 1);
}

char *
mktimes(char *fmt, char *tzname)
{
	char buf[129];
	time_t tim;
	struct tm *timtm;

	settz(tzname);
	tim = time(NULL);
	timtm = localtime(&tim);
	if (timtm == NULL)
		return smprintf("");

	if (!strftime(buf, sizeof(buf)-1, fmt, timtm)) {
		fprintf(stderr, "strftime == 0\n");
		return smprintf("");
	}

	return smprintf("%s", buf);
}

void
setstatus(char *str)
{
	XStoreName(dpy, DefaultRootWindow(dpy), str);
	XSync(dpy, False);
}

char *
loadavg(void)
{
	double avgs[3];

	if (getloadavg(avgs, 3) < 0)
		return smprintf("");

	//return smprintf("%.2f %.2f %.2f", avgs[0], avgs[1], avgs[2]);
	return smprintf("%.2f", avgs[0]);
}

char *
readfile(char *base, char *file)
{
	char *path, line[513];
	FILE *fd;

	memset(line, 0, sizeof(line));

	path = smprintf("%s/%s", base, file);
	fd = fopen(path, "r");
	free(path);
	if (fd == NULL)
		return NULL;

	if (fgets(line, sizeof(line)-1, fd) == NULL)
		return NULL;
	fclose(fd);

	return smprintf("%s", line);
}

#if NOTEBOOK
char *
getbattery(char *base0, char *base1)
{
	char *co, status0, status1;
	int capacity0, capacity1;
	/*
	int descap, remcap;

	descap = -1;
	remcap = -1;

	co = readfile(base, "present");
	if (co == NULL)
		return smprintf("");
	if (co[0] != '1') {
		free(co);
		return smprintf("not present");
	}
	free(co);

	co = readfile(base, "charge_full_design");
	if (co == NULL) {
		co = readfile(base, "energy_full_design");
		if (co == NULL)
			return smprintf("");
	}
	sscanf(co, "%d", &descap);
	free(co);

	co = readfile(base, "charge_now");
	if (co == NULL) {
		co = readfile(base, "energy_now");
		if (co == NULL)
			return smprintf("");
	}
	sscanf(co, "%d", &remcap);
	free(co);
	*/
	co = readfile(base0, "capacity");
	sscanf(co, "%d",&capacity0);
	co = readfile(base1, "capacity");
	sscanf(co, "%d",&capacity1);


	co = readfile(base0, "status");
	if (!strncmp(co, "Discharging", 11)) {
		status0 = BAT_DISCHARGING_SYMBOL;
	} else if(!strncmp(co, "Charging", 8)) {
		status0 = BAT_CHARGING_SYMBOL;
	} else {
		status0 = BAT_FULL_SYMBOL;
	}

	co = readfile(base1, "status");
	if (!strncmp(co, "Discharging", 11)) {
		status1 = BAT_DISCHARGING_SYMBOL;
	} else if(!strncmp(co, "Charging", 8)) {
		status1 = BAT_CHARGING_SYMBOL;
	} else {
		status1 = BAT_FULL_SYMBOL;
	}
	
	/*
	if (remcap < 0 || descap < 0)
		return smprintf("invalid");
	*/

	return smprintf("%d%%%c | %d%%%c" , capacity0, status0, capacity1, status1);
}
#endif

char *
gettemperature(char *base, char *sensor)
{
	char *co;

	co = readfile(base, sensor);
	if (co == NULL)
		return smprintf("");
	return smprintf("%02.0f°C", atof(co) / 1000);
}

////ugly hack, don't stare at him
//char *
//cut_song_name(char *name)
//{
//	/* the mpd_song_get_uri function from mpdlib returns a complete 
//	 * path of the song(relative to the mpd song dir).
//	 * Therefore, this function processes the mpd_song_get_uri return 
//	 * string and removes the adjacent dir paths,also caps the strlen to 
//	 * MPD_MAX_SONG_LEN */
//
//	if(!strcmp(name, "")) return name;
//	
//	char *strRet;
//	char *p;
//	int lenp;
//
//	p =strstr(name, "/") + 1;
//	while(strstr(p, "/") != NULL)
//		p = strstr(p, "/") + 1;
//	
//	lenp = strlen(p);
//
//	if(lenp > MPD_MAX_SONG_LEN) {
//		strRet = (char *)calloc(MPD_MAX_SONG_LEN+6,sizeof(char));
//		strncpy(strRet, p,MPD_MAX_SONG_LEN);
//		strcat(strRet,"...");
//	}
//	else {
//		strRet = (char *)calloc(lenp + 2, sizeof(char));
//		strcpy(strRet,p);
//	}
//
//	free(name);
//	return(strRet);	
//}
//
//char *
//getmpdstat() {
//    struct mpd_song * song = NULL;
//	//const char * title = NULL;
//	//const char * artist = NULL;
//	const char * file_name = NULL;
//	char * retstr = NULL;
//	//int elapsed = 0, total = 0;
//    struct mpd_connection * conn ;
//    if (!(conn = mpd_connection_new(MPD_HOST, 0, MPD_PORT)) ||
//        mpd_connection_get_error(conn)){
//            return smprintf("");
//    }
//
//    mpd_command_list_begin(conn, true);
//    mpd_send_status(conn);
//    mpd_send_current_song(conn);
//    mpd_command_list_end(conn);
//
//    struct mpd_status* theStatus = mpd_recv_status(conn);
//    	/* MPD_STATE_PLAY, MPD_STATE_PAUSE , MPD_STATE_STOP */
//	if ((theStatus) && (mpd_status_get_state(theStatus) !=  MPD_STATE_STOP)){ 
//                mpd_response_next(conn);
//                song = mpd_recv_song(conn);
//                //title = smprintf("%s",mpd_song_get_tag(song, MPD_TAG_TITLE, 0));
//                //artist = smprintf("%s",mpd_song_get_tag(song, MPD_TAG_ARTIST, 0));
//                file_name = smprintf("%s",mpd_song_get_uri(song));
//
//                //elapsed = mpd_status_get_elapsed_time(theStatus);
//                //total = mpd_status_get_total_time(theStatus);
//                mpd_song_free(song);
//                /*
//		retstr = smprintf("%.2d:%.2d/%.2d:%.2d %s - %s",
//                                elapsed/60, elapsed%60,
//                                total/60, total%60,
//                                artist, title);
//		*/
//		/*
//		retstr = smprintf("(%.2d:%.2d/%.2d:%.2d) %s",
//				elapsed/60,
//				elapsed%60,
//                                total/60,
//				total%60,
//                                file_name);
//                */
//		
//		retstr = smprintf("%s",file_name);
//		//free((char*)title);
//                //free((char*)artist);
//                free((char*)file_name);
//        }
//        else retstr = smprintf("");
//		mpd_response_finish(conn);
//		mpd_connection_free(conn);
//		return retstr;
//}

char *get_freespace(char *mntpt){
    struct statvfs data;
    double total, used = 0;

    if ( (statvfs(mntpt, &data)) < 0){
		fprintf(stderr, "can't get info on disk.\n");
		return("?");
    }
    total = (data.f_blocks * data.f_frsize);
    used = (data.f_blocks - data.f_bfree) * data.f_frsize ;
    return(smprintf("%.0f", (used/total*100)));
}

char*
runcmd(char* cmd) {
	FILE* fp = popen(cmd, "r");
	if (fp == NULL) return NULL;
	char ln[50];
	fgets(ln, sizeof(ln)-1, fp);
	pclose(fp);
	ln[strlen(ln)-1]='\0';
	return smprintf("%s", ln);
}

int 
runevery(time_t *ltime, int sec){
    /* return 1 if sec elapsed since last run
     * else return 0 
    */
    time_t now = time(NULL);
    
    if ( difftime(now, *ltime ) >= sec)
    {
        *ltime = now;
        return(1);
    }
    else 
        return(0);
}

char *
get_vol() {
	//int right=0;
	int left=0;
        
	//sscanf(runcmd("amixer sget Master | grep 'Right:' | awk -F'[][]' '{ print $2 }'"), "%d%%", &right);
        sscanf(runcmd("amixer sget Master | grep 'Left:' | awk -F'[][]' '{ print $2 }'"), "%d%%", &left);
	
	//return smprintf("%d%%|%d%%",left, right);
	return smprintf("%d%%",left);
}

// 1 retorna a memória utilizada e 0 a memória livre
char 
*get_mem(int tipo) {
	const double megabytes = 1024 * 1024;
	unsigned long freemem,totalmem,ram;
	struct sysinfo si;
	
	sysinfo(&si);
	
	freemem = si.freeram;
	totalmem = si.totalram;
	ram = tipo ? (totalmem - freemem)/megabytes : freemem/megabytes;
		
	return smprintf("%luM",ram);
}

char 
*get_ip(const char *iface) {

	char *ip = calloc(17,sizeof(char));
	strcpy(ip, runcmd(smprintf("ip -4 -o addr show dev %s | awk '{split($4,a,\"/\");print a[1]}'",iface)));
	ip[17]='\0';

	
	//sp
	//char cmd0[] = "ip -4 -o addr show dev " , cmd1[] = " | awk '{split($4,a,\"/\");print a[1]}'";
	//strcat(cmd0,iface);
	//strcat(cmd0,cmd1);

	//printf("%s",cmd0);
	
	//sscanf(runcmd(cmd0), "%s", &ip);
	
	//return runcmd(smprintf("ip -4 -o addr show dev %s | awk '{split($4,a,\"/\");print a[1]}'",iface));
	
	//toda string contendo um endereço ip terá o primeiro caractere alfanumerico,assim , uma saída inválida será filtrada nessa exceção
	if(!isdigit(ip[0]))
        ip[0] = '\0';
	return ip;
}

//int sysinfo(struct sysinfo *info);
//struct sysinfo {
//	long uptime;             /* Seconds since boot */
//       	unsigned long loads[3];  /* 1, 5, and 15 minute load averages */
//       	unsigned long totalram;  /* Total usable main memory size */
//       	unsigned long freeram;   /* Available memory size */
//       	unsigned long sharedram; /* Amount of shared memory */
//       	unsigned long bufferram; /* Memory used by buffers */
//       	unsigned long totalswap; /* Total swap space size */
//       	unsigned long freeswap;  /* swap space still available */
//       	unsigned short procs;    /* Number of current processes */
//      	unsigned long totalhigh; /* Total high memory size */
//       	unsigned long freehigh;  /* Available high memory size */
//       	unsigned int mem_unit;   /* Memory unit size in bytes */
//   };	

char *
tmpinfo()
{
    	/* usr path as a buffer for any text */
    	char *path = "/tmp/dwmbuf";
    	char line[255];
    	char *toprint = NULL;
	FILE *fin;
	//FILE *fout;
	int c = 0;

	fin = fopen(path, "r");
	if (fin == NULL)
        return(smprintf("%s",""));

	/*
	fout = fopen("/tmp/.dwmbuf.tmp", "w");
	if (fout == NULL)
    	{
        	fclose(fin);
        	return(smprintf("%s"," "));
    	}
	*/

    	while (fgets(line, sizeof(line), fin))
    	{
        	if (c == 0)
		{
        	    line[strlen(line)-1]='\0';
            		toprint = smprintf("%s",line);
		}
		/*
        	if (c > 0)
            	fputs(line, fout);
        	c += 1;
		*/
    }

    fclose(fin);
    //fclose(fout);

    //rename("/tmp/.dwmbuf.tmp", path);

    if (toprint != NULL)
        return(smprintf("%s",toprint));
    else
        return(smprintf("%s",""));
}

char 
*getmpcstat() {
	char song[MPD_MAX_SONG_LEN+10];
	int status;
	strncpy(song, runcmd("mpc current -f '%artist% - %title%'"), MPD_MAX_SONG_LEN);
	song[MPD_MAX_SONG_LEN] = '\0';
	status = atoi( runcmd("[ -n \"$(mpc|grep playing)\" ] ; echo $?") );

	if(!strlen(song))
		return smprintf("");
	else
		return smprintf("%s | %s", song,  !status ? MPD_PLAYING_ICON : MPD_PAUSED_ICON, song);

}


int
parse_netdev(unsigned long long int *receivedabs, unsigned long long int *sentabs)
{
	char buf[255];
	char *datastart;
	static int bufsize;
	int rval;
	FILE *devfd;
	unsigned long long int receivedacc, sentacc;

	bufsize = 255;
	devfd = fopen("/proc/net/dev", "r");
	rval = 1;

	// Ignore the first two lines of the file
	fgets(buf, bufsize, devfd);
	fgets(buf, bufsize, devfd);

	while (fgets(buf, bufsize, devfd)) {
	    if ((datastart = strstr(buf, "lo:")) == NULL) {
		datastart = strstr(buf, ":");

		// With thanks to the conky project at http://conky.sourceforge.net/
		sscanf(datastart + 1, "%llu  %*d     %*d  %*d  %*d  %*d   %*d        %*d       %llu",\
		       &receivedacc, &sentacc);
		*receivedabs += receivedacc;
		*sentabs += sentacc;
		rval = 0;
	    }
	}

	fclose(devfd);
	return rval;
}

void
calculate_speed(char *speedstr, unsigned long long int newval, unsigned long long int oldval)
{
	double speed;
	speed = (newval - oldval) / 1024.0;
	if (speed > 1024.0) {
	    speed /= 1024.0;
	    sprintf(speedstr, "%.3f MB/s", speed);
	} else {
	    sprintf(speedstr, "%.2f KB/s", speed);
	}
}

char *
get_netusage(unsigned long long int *rec, unsigned long long int *sent)
{
	unsigned long long int newrec, newsent;
	newrec = newsent = 0;
	char downspeedstr[15], upspeedstr[15];
	static char retstr[42];
	int retval;

	retval = parse_netdev(&newrec, &newsent);
	if (retval) {
	    fprintf(stdout, "Error when parsing /proc/net/dev file.\n");
	    exit(1);
	}

	calculate_speed(downspeedstr, newrec, *rec);
	calculate_speed(upspeedstr, newsent, *sent);

	sprintf(retstr, " %s  %s", downspeedstr, upspeedstr);

	*rec = newrec;
	*sent = newsent;
	return retstr;
}

int
main(void)
{
	
	char *status = NULL;
	#if NOTEBOOK
	char *bat = NULL;
	#endif
	char *date = NULL;
	char *temp = NULL;
	char *loadAvg = NULL;
	char *mpdSong = NULL;
	char *dataFS = NULL;
	char *rootFS = NULL;
	char *info = NULL;
	char *vol = NULL;
	char *mem = NULL;
	char *ip_eth = NULL;
	char *ip_wifi = NULL;

  char *netstats = NULL;
	static unsigned long long int rec = 0, sent = 0;

	//time_t count5min = 0;
    	time_t count60 = 0;
    	time_t count5 = 0;

	if (!(dpy = XOpenDisplay(NULL))) {
		fprintf(stderr, "dwmstatus: cannot open display.\n");
		return 1;
	}

	for (;;sleep(1)) {
	
		/* roda a cada minuto */
		if ( runevery(&count60, 60) ) {
			free(date);
			#if NOTEBOOK
			free(bat);
			#endif
			date = mktimes("%d/%m/%y %a-%b %H:%M", tzsp);
			#if NOTEBOOK
			bat = getbattery("/sys/class/power_supply/"BAT_DEVICE_0, "/sys/class/power_supply/"BAT_DEVICE_1);
			#endif
		}

		/* roda a cada 5 segundos */
		if (runevery(&count5, 5)){
			free(dataFS);
			free(rootFS);
			free(ip_eth);
			#if NOTEBOOK
			free(ip_wifi);
			#endif
			dataFS = get_freespace(DATAFS);
			rootFS = get_freespace(ROOTFS);
			ip_eth = get_ip(WIRED_IFACE);
			#if NOTEBOOK
			ip_wifi = get_ip(WIRELESS_IFACE);
			#endif
     		}

		/* roda a cada 5 min
		if (runevery(&count5min, 300) ){
		}
		*/

		/* Roda a cada segundo */
		vol = get_vol();
		temp = gettemperature(TEMP_SENSOR_DIR TEMP_SENSOR0 , "temp1_input");
		loadAvg = loadavg();
		//mpdSong = cut_song_name(getmpdstat());
		mpdSong = getmpcstat();
		mem = get_mem(0);
		info = tmpinfo();
    netstats = get_netusage(&rec, &sent);
		
		/* status = smprintf(" ::|%s|  ::|%s|  ::|%s| ::|%s|  ::|%s|  ::|%s|  ::|%s%%  %s%%|  ::|%s|  ::|%s|   ::|%s %s| ", */
				/* mpdSong, */
				/* loadAvg, */
				/* mem, */
				/* temp, */
				/* ip_wifi, */
				/* ip_eth, */
				/* rootFS, */
				/* dataFS, */
				/* date, */
				/* vol, */
				/* bat, */
				/* info); */

          status = smprintf("\x02  %s \x05  %s \x03  %s \x04  %s \x07  %s \x08  %s \x09   %s \xa  %s%%  %s%% \x06  %s \x07  %s \x02   %s %s",
				mpdSong,
				loadAvg,
				mem,
				temp,
				ip_wifi,
				ip_eth,
        netstats,
				rootFS,
				dataFS,
				date,
				vol,
				bat,
				info);


		setstatus(status);
		
		free(temp);
		free(loadAvg);
		free(status);
		free(mpdSong);
		free(vol);
		free(info);

	}

	XCloseDisplay(dpy);

	return 0;
}

