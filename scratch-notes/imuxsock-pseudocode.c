// Psuedocode written in an effort to understand how the imuxsock module works with systemd present
// see also rsyslog/rsyslog-doc#436

if (the user has not explicitly chosen to set SysSock.Use="off") {

    set the default listener socket name to "/dev/log"

    if (the user has specified sysSock.Name="/path/to/custom/socket") {
        listen on the user-specified socket
        do not manage (unlink, create, unlink later) the "/dev/log" socket
        do not listen on the "/dev/log" socket
        do not listen on the systemd-provided socket
    }

    else if (systemd is present and running) {

        if (the systemd-provided socket exists and is a valid socket) {
            listen on the systemd-provided socket
            do not manage (unlink, create, unlink later) the "/dev/log" socket
            do not listen on the "/dev/log" socket
        }

        else if (the socket does not exist) {
            unlink "/dev/log"
            recreate "/dev/log"
            listen on the "/dev/log" socket
            unlink "/dev/log" socket again during shutdown phase
        }

    }

}
