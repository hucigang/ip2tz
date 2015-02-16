
void *tz_setup(const char *);
enum {
	TZ_OK = 0,
	TZ_PRIV_IP,
};
int tz_lookup(void *, char *, sa_family_t, int *tz);
void tz_shutdown(void *);
