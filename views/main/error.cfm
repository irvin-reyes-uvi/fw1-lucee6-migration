<div id="content-left-layout" class="errover" style="margin-top: 20px;">
    <div class="errorCont">
        <h6>Booking Error!</h6>

        <p><cfoutput>#request.exception#</cfoutput></p>
      <a href="<cfoutput>#buildURL('main.default')#</cfoutput>" class="blue-button">BACK</a>
    </div>
</div>
