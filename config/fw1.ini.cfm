<cfscript>
variables.framework = {
    action: 'go',
    usingSubsystems: false,
    defaultSection: 'main',
    defaultItem: 'default',
    error: 'error',
    reload: 'reload',
    password: 'true',
    reloadApplicationOnEveryRequest: false,
    SESOmitIndex: true,
    base: getDirectoryFromPath(CGI.SCRIPT_NAME),
    baseURL: 'useCgiScriptName',
    unhandledExtensions: 'cfc',
    unhandledPaths: '/flex2gateway,/keepalive/,/test/',
    applicationKey: 'framework.one',
    diEngine: 'di1',
    diLocations: '/model/services,/model/utils,/controllers'
};
</cfscript>
