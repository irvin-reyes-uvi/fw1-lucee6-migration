<cfparam name="page_type" default="">
<cfparam name="request.beachesLink" default="http://www.beaches.com">
<cfoutput>
    <img
        src="/assets/images/zz-lt_payment.webp"
        fetchpriority="high"
        decoding="async"
        width="250"
        height="70"
        alt="luxury couples resort"
    >
    <div class="navOuter">
        <ul class="navInner">
            <!---<li>
                <a <cfif page_type eq 'payment'> class="leftmenuitemon"</cfif> href="/payment.cfm">Online Payment</a>
            </li>--->
        </ul>
    </div>
</cfoutput>
