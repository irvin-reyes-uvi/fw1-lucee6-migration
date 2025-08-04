	<cfparam name="phoneNumToShow" default="US">
    <cfparam name="request.sandalsLink" default="">
    <cfparam name="request.beachesLink" default="">
    <cfparam name="request.sandalsSelectLink" default="">
    <cfset imagesDir = '/assets/images' />
    
    <cfscript>
        
        function FormatPhone(str) {
            if (len(str) neq 10)
                return str;
            else
                return"(" & left(str, 3) & ")" & " " & mid(str, 4, 3) & "-" & right(str, 4);
        }
    </cfscript>


    <cfif isDefined("cookie.weddingFamily")>
        <cfset phoneNumToShow = "weddingFamily">
    </cfif>

    <cfif isDefined("cookie.groupsFamily")>
        <cfset phoneNumToShow = "groupsFamily">
    </cfif>

    <cfif isDefined("cookie.cobrand_cookie") and cookie.cobrand_cookie neq 0 and cookie.cobrand_cookie neq "108844">
        <cfset phoneNumToShow = "cobrand">
    </cfif>

    <!--- PPC Ad phone number --->
    <cfif request.region_code eq "US" and (isDefined("url.esv_ppc") or (isDefined("cookie.US_ppc_Ad") and cookie.US_ppc_Ad neq 0))>
        <cfif isDefined("cookie.cobrand_cookie") and cookie.cobrand_cookie neq 0 and cookie.cobrand_cookie neq "108844">
            <cfset phoneNumToShow = "cobrand">
        <cfelse>
            <cfcookie name="US_ppc_Ad" value="1" expires="60">
            <cfset phoneNumToShow = "US_PPC">
        </cfif>
    <cfelse>
        <cfif request.region_code eq "UK">
            <!--- Different number for weddings pages --->
            <cfif cgi.PATH_TRANSLATED contains "weddingmoons">
                <cfif (isDefined("url.esv_ukwedding") or (isDefined("cookie.UK_wedding_ppc_ad") and cookie.UK_wedding_ppc_ad neq 0))>
                    <cfcookie name="UK_wedding_ppc_ad" value="1" expires="60">
                    <cfset phoneNumToShow = "UK_PPC_weddings">
                </cfif>
            <cfelse>
                <cfif (isDefined("url.esv_ukppc") or (isDefined("cookie.UK_ppc_ad") and cookie.UK_ppc_ad neq 0))>
                    <cfcookie name="UK_ppc_ad" value="1" expires="60">
                    <cfset phoneNumToShow = "UK_PPC">
                </cfif>
            </cfif>
        </cfif>
    </cfif>


    <div class="clearer"></div>

    <div id="footerNav">
        <ul>
            <li>Book a <cfif request.region_code is "UK">Holiday<cfelse>Vacation</cfif></li>
            <cfif request.region_code eq "UK">
                <li><a href="//res.sandalsuk.co.uk/">Book Online</a></li>
                <li><a href="//res.sandalsuk.co.uk/">Get a Price Quote</a></li>
            <cfelse>
                <li><a href="//obe.sandals.com/?&event=ehOBE.dspHome/">Book Online</a></li>
                <li><a href="//obe.sandals.com/?&event=ehOBE.dspHome/">Get a Price Quote</a></li>
            </cfif>
            <li><a href="//www.sandals.com/specials/">View Specials</a></li>
            <li><a href="//www.sandals.com/planner/">Find your Sandals</a></li>
            <cfif request.region_code neq "UK" and phoneNumToShow neq 'cobrand'>
                <li><a href="//taportal.sandals.com/landing/">Find a Travel Agent</a></li>
                <li><a href="//www.sandals.com/sandalsNights/">Meet a Sandals Specialist</a></li>
            </cfif>
        </ul>
        <div class="footerDivider"></div>
        <ul style="width:165px;">
            <li>Already Booked?</li>
            <cfif request.region_code eq "UK">
                <li><a href="//checkin.sandals.co.uk">Check-in Online</a></li>
            <cfelse>
                <li><a href="//checkin.sandals.com">Check-in Online</a></li>
            </cfif>
            <li><a href="//www.sandals.com/extras/">Book Optional <cfif request.region_code is "UK">Holiday<cfelse>Vacation</cfif> Extras</a></li>
            <cfif request.region_code neq "UK"><li><a href="/payment.cfm">Make a Balance Payment</a></li></cfif>
            <li><a href="//butlerservice.sandals.com/">Select your Butler Preferences</a></li>
            <li><a href="//www.sandals.com/wallpapers/">Download a Desktop Wallpaper</a></li>
        </ul>
      <div class="footerDivider"></div>
        <ul>
            <li>The Resorts</li>
            <li><a href="//www.sandals.com/destinations/jamaica">Jamaica Hotels</a></li>
            <li><a href="//www.sandals.com/destinations/stlucia/">St. Lucia Hotels</a></li>
            <li><a href="//www.sandals.com/destinations/antigua/">Antigua Hotels</a></li>
            <li><a href="//www.sandals.com/destinations/bahamas/">Bahamas Hotels</a></li>
        </ul>
        <div class="footerDivider"></div>
        <ul>
            <li>Weddingmoons<sup>&reg;</sup></li>
            <li><a href="//www.sandals.com/weddingmoons/">Weddings</a></li>
            <li><a href="//www.sandals.com/honeymoons/">Honeymoons</a></li>
            <li><a href="//www.sandals.com/vow-renewals/">Vow Renewals</a></li>
            <li><a href="//www.sandals.com/weddings/guests/">Wedding Groups</a></li>
            <li><a href="//www.sandalsweddingblog.com/">Wedding Blog</a></li>
        </ul>
        <div class="footerDivider"></div>
        <ul>
            <li>About Sandals</li>
            <li><a href="//www.sandals.com/faqs/">FAQs</a></li>
            <li><a href="//www.sandals.com/terms-conditions/">Terms &amp; Conditions</a></li>
            <cfif request.region_code neq "UK"><li><a href="//www.sandals.com/about/employment/">Employment</a></li></cfif>
            <li><a href="//www.sandals.com/privacy-policy/">Cookies &amp; Privacy Policy</a></li>
            <li><a href="//www.sandals.com/about/resort-brands/">Our Resorts Family</a></li>
            <li><a href="//sandalsfoundation.org/">The Sandals Foundation</a></li>
            <li><a href="//www.sandals.com/sitemap/">Site Map</a></li>
        </ul>
        <div class="clearer"></div>
    </div>

    <div align="center">

        <div id="footerPhone" class="inlineBlock">
            <cfswitch expression="#phoneNumToShow#">
                <!--- US --->
                <cfcase value="US">
                    <div class="contact-block">
                        <p class="title-line">GROUPS DIRECT LINE</p>
                        <p class="main-phone-number">1-800-327-1991</p>
                        <p class="details-line">EXT 2793</p>
                    </div>
                </cfcase>
                
               
                <!--- UK --->
                <cfcase value="UK">
                    <div align="center"><a href="tel:<cfoutput>#request.footerNumberUK#</cfoutput>"
                         rel="nofollow">
                         <img src="<cfoutput>#imagesDir#</cfoutput>/number-UK.gif" 
                                fetchpriority="high"
                                decoding="async"
                                style="margin-top:20px;" alt="0800 22 30 30" width="323" height="47" /></a></div>
                </cfcase>

                <!--- US PPC --->
                <cfcase value="US_PPC">
                    <div align="center"><a href="//www.sandals.com/bookingengine/"><img src="<cfoutput>#imagesDir#</cfoutput>/number-ppc.gif"
                         style="margin-top:20px;" alt="866-726-3257" width="291" height="46" /></a></div>
                </cfcase>

                <!--- UK PPC --->
                <cfcase value="UK_PPC">
                    <p style="text-align:center; margin:20px 0;"><strong style="font-size:14px;">Please call 0808 168 9512</strong><br /><span style="font-size:12px;">to book your wedding vacation.</span></p>
                </cfcase>

                <!--- UK PPC Weddings--->
                <cfcase value="UK_PPC_weddings">
                    <p style="text-align:center; margin:20px 0;"><strong style="font-size:14px;">Please call 0808 168 9513</strong><br /><span style="font-size:12px;">to book your wedding vacation.</span></p>
                </cfcase>


                <!--- Wedding Family --->
                <cfcase value="weddingFamily">
                    <p style="text-align:center; margin:20px 0;"><strong style="font-size:14px;">Please call 877-724-7230</strong><br /><span style="font-size:12px;">to book your wedding vacation.</span></p>
                </cfcase>

                <!--- Groups Family --->
                <cfcase value="groupsFamily">
                    <p style="text-align:center; margin:20px 0;"><strong style="font-size:14px;">Please call 877-724-7235</strong><br /><span style="font-size:12px;">to book your groups vacation.</span></p>
                </cfcase>

                <cfcase value="PR">
                    <!---#### Puerto Rico  ####--->
                     <div align="center"><a title="Call 866-503-8409 to Book Your Vacation" href="//obe.sandals.com/?&event=ehOBE.dspHome/"><img src="<cfoutput>#imagesDir#</cfoutput>/number-<cfoutput>#phoneNumToShow#</cfoutput>.gif" style="margin-top:20px;" alt="866-503-8409" width="385" height="45" /></a></div>
                </cfcase>

                <cfcase value="AR">
                    <!---#### Argentina  ####--->
                    <div align="center"><a ti`tle="Call 00-800-0726-3257 to Book Your Vacation" href="//obe.sandals.com/?&event=ehOBE.dspHome/"><img src="<cfoutput>#imagesDir#</cfoutput>/number-<cfoutput>#phoneNumToShow#</cfoutput>.gif" style="margin-top:20px;" alt="00-800-0726-3257" width="385" height="45" /></a></div>
                </cfcase>

                <cfcase value="CO">
                    <!---#### Colombia  ####--->
                    <div align="center"><a title="Call 01-800-710-2236 to Book Your Vacation" href="//obe.sandals.com/?&event=ehOBE.dspHome/"><img src="<cfoutput>#imagesDir#</cfoutput>/number-<cfoutput>#phoneNumToShow#</cfoutput>.gif" style="margin-top:20px;" alt="01-800-710-2236" width="385" height="45" /></a></div>
                </cfcase>

                <cfcase value="BR">
                    <!---#### Brazil  ####--->
                    <div align="center"><a title="Call  0021-800-0726-3257  to Book Your Vacation" href="//obe.sandals.com/?&event=ehOBE.dspHome/"><img src="<cfoutput>#imagesDir#</cfoutput>/number-<cfoutput>#phoneNumToShow#</cfoutput>.gif" style="margin-top:20px;" alt=" 0021-800-0726-3257 " width="385" height="45" /></a></div>
                </cfcase>

                <cfcase value="MX">
                    <!---#### Mexico  ####--->
                    <div align="center"><a title="Call  001-800-726-3257 to Book Your Vacation" href="//obe.sandals.com/?&event=ehOBE.dspHome/"><img src="<cfoutput>#imagesDir#</cfoutput>/number-<cfoutput>#phoneNumToShow#</cfoutput>.gif" style="margin-top:20px;" alt="001-800-726-3257" width="385" height="45" /></a></div>
                </cfcase>

                <cfcase value="ES">
                    <!---#### Spain  ####--->
                    <div align="center"><a title="Call 00-800-0726-3257 to Book Your Vacation" href="//obe.sandals.com/?&event=ehOBE.dspHome/"><img src="<cfoutput>#imagesDir#</cfoutput>/number-<cfoutput>#phoneNumToShow#</cfoutput>.gif" style="margin-top:20px;" alt="00-800-0726-3257" width="385" height="45" /></a></div>
                </cfcase>

                <cfcase value="AU">
                    <!---#### Spain  ####--->
                    <div align="center"><a title="Call 0011-800-0726-3257 to Book Your Vacation" href="//obe.sandals.com/?&event=ehOBE.dspHome/"><img src="<cfoutput>#imagesDir#</cfoutput>/number-<cfoutput>#phoneNumToShow#</cfoutput>.gif" style="margin-top:20px;" alt="0011-800-0726-3257" width="430" height="45" /></a></div>
                </cfcase>

                <cfdefaultcase>
                    <!---#### Same as US  ####--->
                    <cfif request.region_code is "UK">
                        <div align="center"><a href="//www.sandals.com"><img src="<cfoutput>#imagesDir#</cfoutput>/number-UK.gif" style="margin-top:20px;" alt="0800 22 30 30" width="323" height="47" /></a></div>
                    <cfelse>
                        <!---#### Same as US  ####--->
                        <div align="center"><a title="Call 1-888-SANDALS to Book Your Vacation" href="//obe.sandals.com/?&event=ehOBE.dspHome/"><img src="<cfoutput>#imagesDir#</cfoutput>/number-US2.gif" style="margin-top:20px;" alt="1-888-SANDALS" width="435" height="50" /></a></div>
                    </cfif>

                </cfdefaultcase>
            </cfswitch>
        </div>

        <ul id="footerSocialIcons" class="inlineBlock">
            <li><a href="//www.facebook.com/sandalsresorts" class="icFacebook socialIcons" target="_blank"></a></li>
            <li><a href="//www.twitter.com/sandalsresorts" class="icTwitter socialIcons" target="_blank"></a></li>
            <li><a href="//plus.google.com/116658650670739791219/posts" class="icGooglePlus socialIcons" target="_blank"></a></li>
            <li><a href="//pinterest.com/sandalsresorts" class="icPinterest socialIcons" target="_blank"></a></li>
        </ul>

    </div>


    <div id="phoneNumberLinks">

        <cfset currentPath = replaceNoCase(cgi.script_name,'index.cfm','')>
        <cfif request.region_code is "UK">
            <cfset sandalsURL = "http://" & replaceNoCase(cgi.SERVER_NAME, ".co.uk", ".com") & currentPath & "?UKredirect=no">
        <cfelse>
            <cfset sandalsURL = "http://" & replaceNoCase(cgi.SERVER_NAME, ".com", ".co.uk") & currentPath>
        </cfif>



        <a href="<cfoutput>#request.sandalsSelectLink#</cfoutput>">Returning Guests</a>
        <a href="//www.sandals.com/groups/" rel="nofollow">For Groups</a>
        <cfif phoneNumToShow neq 'cobrand'><a href="//taportal.sandals.com/landing/">For Travel Agents</a></cfif>
        
        <cfif phoneNumToShow neq 'cobrand'><a href="//www.sandals.com/affiliates/" rel="nofollow">For Affiliates</a></cfif>
            <a href="//news.sandals.com" rel="nofollow">News</a>
        <cfif phoneNumToShow neq 'cobrand'><a href="//www.sandals.com/contact/" rel="nofollow">Contact Us</a></cfif><br />
             <img id="footerLine" src="<cfoutput>#imagesDir#</cfoutput>/footer-divider.gif" width="848" height="4" />
        <cfif request.region_code eq "UK">
             <img src="<cfoutput>#imagesDir#</cfoutput>/footer-flagsUK.gif" width="490" height="28" border="0" usemap="#FooterFlags" />
        <cfelse>
             <img src="<cfoutput>#imagesDir#</cfoutput>/footer-flagsUS.gif" width="490" height="28" border="0" usemap="#FooterFlags" />
        </cfif>
        <map name="FooterFlags" id="FooterFlags">
          <area shape="rect" coords="0,0,166,28" href="<cfoutput>#sandalsURL#</cfoutput>" />
          <area shape="rect" coords="325,0,490,28" href="//www.sandals.com/contact/worldwide/" />
        </map>

        <cfif request.region_code eq "UK">
            <img src="<cfoutput>#imagesDir#</cfoutput>/footer-divider.gif" width="848" height="4" />
            <div id="ukLogos">
                <a href="//www.sandals.com/terms-conditions/"><img id="ukLogos" src="<cfoutput>#imagesDir#</cfoutput>/uk-logos.gif" width="230" height="69" /></a>
                <p>Fully Protected Holidays - The Inclusive Tour Holidays Bookable Online are ATOL Protected by the UK Civil Aviation Authority. Our ATOL number is 2853. ATOL Protection Extends Primarily to Customers who Book and Pay in the UK.</p>
                <div class="clearer"></div>
            </div>
        </cfif>

    </div>


    <div id="footerLogosWrapper">
        <div id="footerLogos">
            <cfif phoneNumToShow eq 'cobrand'>
                
                <cfset referral= "">
            <cfelse>
                <cfset referral = "">
            </cfif>
            <a href="<cfoutput>#request.beachesLink##referral#</cfoutput>" title="Beaches Family Resorts - All Inclusive Family Vacation in the Caribbean">
                <img src="<cfoutput>#imagesDir#</cfoutput>/footer-logo-beaches-new.png" alt="Beaches Vacation Resorts – All Inclusive Family Vacations in the Caribbean" width="204" height="114" /></a>

           <cfif request.region_code eq "US">
                <a href="<cfoutput>#request.fowlCayLink##referral#</cfoutput>" title="Fowl Cay - Royal Plantation Adventure Resort &amp; Private Island">
                <img src="<cfoutput>#imagesDir#</cfoutput>/footer-logo-fowlCay.png" alt="Fowl Cay - Royal Plantation Adventure Resort &amp; Private Island" width="255" height="114" /></a>
            <cfelse>
                <a href="http://www.fowl-cay.co.uk/" title="Fowl Cay - Royal Plantation Adventure Resort &amp; Private Island">
                <img src="<cfoutput>#imagesDir#</cfoutput>/footer-logo-fowlCay.png" alt="Fowl Cay - Royal Plantation Adventure Resort &amp; Private Island" width="255" height="114" /></a>
            </cfif>
            
        </div>
        <div id="footerBtnSpacer"></div>
        <div id="footerLogosBtn">
            <div align="center" class="zeroDiv ie7_footer"><img src="<cfoutput>#imagesDir#</cfoutput>/footer-divider2.gif" width="838" height="1" /><br />
                 <img src="<cfoutput>#imagesDir#</cfoutput>/footer-ourFamily.jpg" width="695" height="27" />
            </div>
        </div>
    </div>

    
	<cfoutput>#request.sandalsMenu_footerContent#</cfoutput>

    <cfset scriptsDir = '/assets/scripts' />
        <script type="text/javascript" src="<cfoutput>#scriptsDir#</cfoutput>/jquery-3.6.1.min.js" nonce="#application.nonce#"></script>
        <!---<script type="text/javascript" defer src="https://cdn.sandals.com/sandals/browsers/script.js" nonce="#application.nonce#"></script>--->
          <script type="text/javascript" src="/assets/scripts/paymentStep2.js" nonce="#application.nonce#"></script>
          <script src="/assets/scripts/makePaymentButtons.js" type="text/javascript" nonce="#application.nonce#"></script>    
        <script type="text/javascript" defer src="<cfoutput>#scriptsDir#</cfoutput>/MaskedPassword.js" nonce="#application.nonce#"></script>
        <script type="text/javascript" defer src="<cfoutput>#scriptsDir#</cfoutput>/jqry_date_solutions.js" nonce="#application.nonce#"></script>
        <script type="text/javascript" defer src="<cfoutput>#scriptsDir#</cfoutput>/countryState.js" nonce="#application.nonce#"></script>
        <script  defer src="<cfoutput>#scriptsDir#</cfoutput>/makePaymentButtons.js" type="text/javascript" nonce="#application.nonce#"></script>
        <script  defer src="<cfoutput>#scriptsDir#</cfoutput>/paymentsCFM.js" type="text/javascript" nonce="#application.nonce#"></script>
        <script  defer src="<cfoutput>#scriptsDir#</cfoutput>/loaderProcessor.js" type="text/javascript" nonce="#application.nonce#"></script>
    
</body>
</html>