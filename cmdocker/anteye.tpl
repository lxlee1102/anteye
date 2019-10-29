{
    "debug": false,
    "deploy_env": "%%DEPLOY_ENV%%",
    "http": {
        "enable": true,
        "listen": "0.0.0.0:8001"
    },
    "mail" : {
        "enable": true,
        "url" : "%%MAIL_API%%",
        "receivers" : "%%MAIL_RECEIVERS%%"
    },
    "sms" : {
        "enable": false,
        "url" : "%%SMS_API%%",
        "receivers" : "%%SMS_RECEIVERS%%"
    },
    "callback" : {
        "enable": false,
        "url" : "%%CALLBACK_API%%"
    },
    "monitor" : {
        "cluster" : [
	    %%MONITOR_CLUSTER%%
        ]
    }
}
