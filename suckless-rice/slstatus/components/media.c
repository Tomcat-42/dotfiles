#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <mpd/client.h>

#include "../util.h"

void
format_title(char *title, const char *mpd_title, size_t n)
{
        if (strlen(mpd_title) >= n) {
                strncpy(title, mpd_title, n - 4);
                memset(title + n - 4, '.', 3);
                title[n] = '\0';
                return;
        }

        strcpy(title, mpd_title);
}

const char *
media_mpd_stat()
{
        struct mpd_connection *conn;
        struct mpd_status *status;
        struct mpd_song *song;
        char *mpc_title, title[16];
        char ret[64];
        unsigned state;
        int elapsed, total;

        /* Teste para checar se o MPD está ON pra não chrashar na libmpdclient */
        if (system("nc -w 1 -z 127.0.0.1 60960") ||
            !((conn = mpd_connection_new(NULL, 0, 1000)) ||
                      mpd_connection_get_error(conn)))
                return NULL;

        mpd_command_list_begin(conn, true);
        mpd_send_status(conn);
        mpd_send_current_song(conn);
        mpd_command_list_end(conn);
        status = mpd_recv_status(conn);
        if (status) {
                state = mpd_status_get_state(status);
                if (state == MPD_STATE_PLAY) {
                        mpd_response_next(conn);
                        song = mpd_recv_song(conn);
                        mpc_title = (char *)mpd_song_get_tag(song,
                                MPD_TAG_TITLE, 0);
                        format_title(title, mpc_title, sizeof(title));
                        elapsed = mpd_status_get_elapsed_time(status);
                        total = mpd_status_get_total_time(status);
                        snprintf(ret, 64, " %s  [%.2d:%.2d/%.2d:%.2d]  ",
                                title, elapsed / 60, elapsed %60,
                                total / 60, total %60);
                        free(mpc_title);
                } else if (state == MPD_STATE_PAUSE) {
                        mpd_response_next(conn);
                        song = mpd_recv_song(conn);
                        mpc_title = (char *)mpd_song_get_tag(song,
                                MPD_TAG_TITLE, 0);
                        format_title(title, mpc_title, sizeof(title));
                        elapsed = mpd_status_get_elapsed_time(status);
                        total = mpd_status_get_total_time(status);
                        snprintf(ret, 64, " %s [%.2d:%.2d/%.2d:%.2d]  ",
                                title, elapsed / 60, elapsed %60,
                                total / 60, total %60);
                        free(mpc_title);
                } else if (state == MPD_STATE_STOP) {
                        mpd_response_next(conn);
                        if ((song = mpd_recv_song(conn))) {
                            mpc_title = (char *)mpd_song_get_tag(song,
                                    MPD_TAG_TITLE, 0);
                            format_title(title, mpc_title, sizeof(title));
                            snprintf(ret, 64, "%s  ", title);
                            free(mpc_title);
                        } else {
                            snprintf(ret, 64, "");
                        }
                } else {
                        /* state == MPD_STATE_UNKNOWN */
                        snprintf(ret, 64, "");
                } 
        } else {
                return NULL;
        }
        mpd_response_finish(conn);
        mpd_connection_free(conn);
        strcpy(buf, ret);

        return buf;
}
