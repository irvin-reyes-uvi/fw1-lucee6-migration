component extends="framework.one" {

    this.mappings = {
        '/controllers': expandPath('./controllers'),
        '/model': expandPath('./model'),
        '/views': expandPath('./views'),
        '/layouts': expandPath('./layouts'),
        '/includes': expandPath('./views/includes'),
        '/assets': expandPath('./assets'),
        '/framework': expandPath('./framework')
    };

    this.customtagpaths = [
        expandPath('/views/includes/custom_tags')
        //expandPath('/views/includes/custom_tags/sandals'),
        //expandPath('/views/includes/custom_tags/beaches'),
        //expandPath('/views/includes/custom_tags/general')
    ];
    //from
    variables.framework = {
        usingSubsystems: false,
        action: 'go',
        defaultItem: 'default',
        reload: 'reload',
        unhandledExtensions: 'cfc',
        base: getDirectoryFromPath(CGI.SCRIPT_NAME),
        baseURL: 'useCgiScriptName',
        SESOmitIndex: true,
        routesCaseSensitive: false,
        viewsFolder: 'views',
        trace: false,
        jsonPrettyPrint: true,
        reloadApplicationOnEveryRequest: true,
        diEngine: 'di1',
        diLocations: '/model/services,/model/utils,/model/providers,/controllers'

    };


    public void function setupApplication() {
        var findLocal = findNoCase('local', CGI.SERVER_NAME);
        var findTst = findNoCase('tst', CGI.SERVER_NAME);
        var findTest = findNoCase('test', CGI.SERVER_NAME);
        var findDev = findNoCase('dev', CGI.SERVER_NAME);
        var find127 = findNoCase('127', CGI.SERVER_NAME);


        application.isDev = findLocal || findTst || findTest || findDev || find127;
        application.env = application.isDev ? 'dev' : 'prod';

        request.footerNumberUS = '8887263257';
        request.footerNumberUK = '0800223030';
        application.regEx = '[^0-9A-Za-z ]';
        application.nonce = createUUID();


        request.os_type = findNoCase('MAC', cgi.HTTP_USER_AGENT) ? 'mac' : 'wintel';
        request.browser_type = findNoCase('MSIE', cgi.HTTP_USER_AGENT) ? 'ie' : 'other';

        if (findNoCase('dev', cgi.http_host)) {
            var domains = 'dev1.sandals.net';
            cfsetting(showdebugoutput = "yes");
            request.ws_login = 'components';
            request.ws_password = 'JFK69BLONDE';
            request.workingenv = 'DEV';
        } else {
            var domains = '.sandals.com';
            request.ws_login = 'components';
            request.ws_password = 'JFK69BLONDE';
            request.workingenv = 'PROD';
        }

        request.stylePath = (isDefined('url.brand') && url.brand == 'beaches')
         ? 'http://www.beaches.com/'
         : 'http://www.sandals.com/';

        request.pathLink = findNoCase('devj2', cgi.HTTP_HOST)
         ? 'devj2.sandals.com'
         : 'www.sandals.com';

        request.pathLink = (
            cgi.SERVER_PORT_SECURE == 1
             ? 'https://'
             : 'http://'
        ) & request.pathLink;

        if (!structKeyExists(request, 'MassmailsDS')) {
            request.MassmailsDS = 'MassMails';
        }

        include './views/includes/tags/initEnv.cfm'
        if (!structKeyExists(request, 'action') && !structKeyExists(url, 'action')) {
            location(url = buildURL('main.default'), addToken = false);
        }

        application.isGoldDown = false;
        if (application.isGoldDown) {
            include './views/error/default.cfm';
            abort;
        }
    }

    public void function setupRequest() {
    }



    public string function setupResponse() {
        super.onRequestEnd();
        return '';
    }

}
