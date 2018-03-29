# 2018-02-21 15:25:33    Login.Intruder.User     111.222.333.444 mouse123456           5 failed login attempts; evading username
rule=:%datestamp:date-iso%%-:whitespace%%timestamp:time-24hr%%-:whitespace%%event:word%%-:whitespace%%ip:ipv4%%-:whitespace%%auth:word%%-:rest%

# 2018-02-21 15:25:50    Login.Intruder.IP       111.222.333.444 mouse123456
rule=:%datestamp:date-iso%%-:whitespace%%timestamp:time-24hr%%-:whitespace%%event:word%%-:whitespace%%ip:ipv4%%-:whitespace%%auth:word%
