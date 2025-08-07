<cfoutput>
    <!doctype html>
    <html lang="en">
         #view('includes/header')#
        <body>
           

            <table
                width="100%"
                cellpadding="0"
                cellspacing="0"
                bgcolor="##f5f5f5"
                border="0" id="pageholder"
                align="center"
            >
                <tr>
                    <td width="250" valign="top" id="leftcolumn">
                        <cfset page_type = 'payment'>
                        #view('includes/leftmenu')#
                    </td>

                    <td valign="top" align="center">
                        <div id="loader-overlay">
                            <div class="loader"></div>
                        </div>
                        #body#
                    </td>
                      
                </tr>
            </table>
             
            #view('includes/footer')#
        </body>
    </html>
</cfoutput>
