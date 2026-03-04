web:
    behindreverseproxy: true
    corsallowedorigin:
        - http://${WEBUI_HOST}:${WEBUI_PORT}
    debug: false
    enabled: true
    enableui: true
    listen: ${API_HOST}:${API_PORT}
    logfile: ui.log
    secret:
    tls:
        alloweddomains: []
        autocert: false
        certfile: ""
        enabled: false
        keyfile: ""
        selfcert: false
        selfcertdomain: ligolo
    trustedproxies:
        - 127.0.0.1
    users:
        ligolo: $argon2id$v=19$m=32768,t=3,p=4$HXL5BvpB143YFAGyFEsHHQ$J4Lsc0U/VrY6d/CutXkjKZpDMV3zkt8xMB4SQ3dHfco