(function( $ ) {
 
    $.fn.changestates = function(selectID, otherID, countryOther, vcountry) {
      
		var selectField = document.getElementById(selectID),
			theSelect = document.getElementById(selectID),
			$currentSelect = $('#'+selectID).find('.input-select-wrappertext');
			countryOther = document.getElementById(countryOther);
			var otherField = document.getElementById(otherID);
			selectField.style.display = 'inline-block';
      
		if(vcountry == "CANADA" || vcountry == "CA"|| vcountry == "USA" || vcountry == "US" || vcountry == "UNITED KINGDOM" || vcountry == "UK" || vcountry == "GB" )
		{
			if(countryOther){countryOther.style.display = 'none'; $('#otherCountry').removeClass('error');$('#otherCountry').siblings('.errMsgBottom').hide();}
			if(otherID){otherField.style.display = 'none';}
		}
		if( vcountry == "CANADA" || vcountry == "CA"){
			theSelect.length = 12 + 1;
			theSelect.options[0].value = "";
			theSelect.options[0].text = "Select A Province";
			
			theSelect.options[1].value = "AB";
			theSelect.options[1].text = "Alberta";
			theSelect.options[1].selected = false;
			
			theSelect.options[2].value = "BC";
			theSelect.options[2].text = "British Columbia";
			theSelect.options[2].selected = false;
			
			theSelect.options[3].value = "MB";
			theSelect.options[3].text = "Manitoba";
			theSelect.options[3].selected = false;
			
			theSelect.options[4].value = "NB";
			theSelect.options[4].text = "New Brunswick";
			theSelect.options[4].selected = false;
			
			theSelect.options[5].value = "NF";
			theSelect.options[5].text = "Newfoundland";
			theSelect.options[5].selected = false;
			
			theSelect.options[6].value = "NS";
			theSelect.options[6].text = "Nova Scotia";
			theSelect.options[6].selected = false;
			
			theSelect.options[7].value = "NT";
			theSelect.options[7].text = "NW Territories";
			theSelect.options[7].selected = false;
			
			theSelect.options[8].value = "ON";
			theSelect.options[8].text = "Ontario";
			theSelect.options[8].selected = false;
			
			theSelect.options[9].value = "PE";
			theSelect.options[9].text = "P. Edward Island";
			theSelect.options[9].selected = false;
			
			theSelect.options[10].value = "QC";
			theSelect.options[10].text = "Quebec";
			theSelect.options[10].selected = false;
			
			theSelect.options[11].value = "SK";
			theSelect.options[11].text = "Saskatchewan";
			theSelect.options[11].selected = false;
			
			theSelect.options[12].value = "YT";
			theSelect.options[12].text = "Yukon Territory";
			theSelect.options[12].selected = false;
			
			theSelect.options[0].selected = true;
		}
		else if( vcountry == "USA" || vcountry == "US")
		{
			theSelect.length = 52 + 1;
			theSelect.options[0].value = "";
			theSelect.options[0].text = "Select A State";
	
			
			theSelect.options[1].value = "AL";
			theSelect.options[1].text = "Alabama";
			theSelect.options[1].selected = false;
			
			theSelect.options[2].value = "AK";
			theSelect.options[2].text = "Alaska";
			theSelect.options[2].selected = false;
			
			theSelect.options[3].value = "AZ";
			theSelect.options[3].text = "Arizona";
			theSelect.options[3].selected = false;
			
			theSelect.options[4].value = "AR";
			theSelect.options[4].text = "Arkansas";
			theSelect.options[4].selected = false;
			
			theSelect.options[5].value = "CA";
			theSelect.options[5].text = "California";
			theSelect.options[5].selected = false;
			
			theSelect.options[6].value = "CO";
			theSelect.options[6].text = "Colorado";
			theSelect.options[6].selected = false;
			
			theSelect.options[7].value = "CT";
			theSelect.options[7].text = "Connecticut";
			theSelect.options[7].selected = false;
			
			theSelect.options[8].value = "DC";
			theSelect.options[8].text = "D.C.";
			theSelect.options[8].selected = false;
			
			theSelect.options[9].value = "DE";
			theSelect.options[9].text = "Delaware";
			theSelect.options[9].selected = false;
			
			theSelect.options[10].value = "FL";
			theSelect.options[10].text = "Florida";
			theSelect.options[10].selected = false;
			
			theSelect.options[11].value = "GA";
			theSelect.options[11].text = "Georgia";
			theSelect.options[11].selected = false;
			
			theSelect.options[12].value = "HI";
			theSelect.options[12].text = "Hawaii";
			theSelect.options[12].selected = false;
			
			theSelect.options[13].value = "ID";
			theSelect.options[13].text = "Idaho";
			theSelect.options[13].selected = false;
			
			theSelect.options[14].value = "IL";
			theSelect.options[14].text = "Illinois";
			theSelect.options[14].selected = false;
			
			theSelect.options[15].value = "IN";
			theSelect.options[15].text = "Indiana";
			theSelect.options[15].selected = false;
			
			theSelect.options[16].value = "IA";
			theSelect.options[16].text = "Iowa";
			theSelect.options[16].selected = false;
			
			theSelect.options[17].value = "KS";
			theSelect.options[17].text = "Kansas";
			theSelect.options[17].selected = false;
			
			theSelect.options[18].value = "KY";
			theSelect.options[18].text = "Kentucky";
			theSelect.options[18].selected = false;
			
			theSelect.options[19].value = "LA";
			theSelect.options[19].text = "Louisiana";
			theSelect.options[19].selected = false;
			
			theSelect.options[20].value = "ME";
			theSelect.options[20].text = "Maine";
			theSelect.options[20].selected = false;
			
			theSelect.options[21].value = "MD";
			theSelect.options[21].text = "Maryland";
			theSelect.options[21].selected = false;
			
			theSelect.options[22].value = "MA";
			theSelect.options[22].text = "Massachusetts";
			theSelect.options[22].selected = false;
			
			theSelect.options[23].value = "MI";
			theSelect.options[23].text = "Michigan";
			theSelect.options[23].selected = false;
			
			theSelect.options[24].value = "MN";
			theSelect.options[24].text = "Minnesota";
			theSelect.options[24].selected = false;
			
			theSelect.options[25].value = "MS";
			theSelect.options[25].text = "Mississippi";
			theSelect.options[25].selected = false;
			
			theSelect.options[26].value = "MO";
			theSelect.options[26].text = "Missouri";
			theSelect.options[26].selected = false;
			
			theSelect.options[27].value = "MT";
			theSelect.options[27].text = "Montana";
			theSelect.options[27].selected = false;
			
			theSelect.options[28].value = "NE";
			theSelect.options[28].text = "Nebraska";
			theSelect.options[28].selected = false;
			
			theSelect.options[29].value = "NV";
			theSelect.options[29].text = "Nevada";
			theSelect.options[29].selected = false;
			
			theSelect.options[30].value = "NH";
			theSelect.options[30].text = "New Hampshire";
			theSelect.options[30].selected = false;
			
			theSelect.options[31].value = "NJ";
			theSelect.options[31].text = "New Jersey";
			theSelect.options[31].selected = false;
			
			theSelect.options[32].value = "NM";
			theSelect.options[32].text = "New Mexico";
			theSelect.options[32].selected = false;
			
			theSelect.options[33].value = "NY";
			theSelect.options[33].text = "New York";
			theSelect.options[33].selected = false;
			
			theSelect.options[34].value = "NC";
			theSelect.options[34].text = "North Carolina";
			theSelect.options[34].selected = false;
			
			theSelect.options[35].value = "ND";
			theSelect.options[35].text = "North Dakota";
			theSelect.options[35].selected = false;
			
			theSelect.options[36].value = "OH";
			theSelect.options[36].text = "Ohio";
			theSelect.options[36].selected = false;
			
			theSelect.options[37].value = "OK";
			theSelect.options[37].text = "Oklahoma";
			theSelect.options[37].selected = false;
			
			theSelect.options[38].value = "OR";
			theSelect.options[38].text = "Oregon";
			theSelect.options[38].selected = false;
			
			theSelect.options[39].value = "PA";
			theSelect.options[39].text = "Pennsylvania";
			theSelect.options[39].selected = false;
			
			theSelect.options[40].value = "PR";
			theSelect.options[40].text = "Puerto Rico";
			theSelect.options[40].selected = false;
			
			theSelect.options[41].value = "RI";
			theSelect.options[41].text = "Rhode Island";
			theSelect.options[41].selected = false;
			
			theSelect.options[42].value = "SC";
			theSelect.options[42].text = "South Carolina";
			theSelect.options[42].selected = false;
			
			theSelect.options[43].value = "SD";
			theSelect.options[43].text = "South Dakota";
			theSelect.options[43].selected = false;
			
			theSelect.options[44].value = "TN";
			theSelect.options[44].text = "Tennessee";
			theSelect.options[44].selected = false;
			
			theSelect.options[45].value = "TX";
			theSelect.options[45].text = "Texas";
			theSelect.options[45].selected = false;
			
			theSelect.options[46].value = "UT";
			theSelect.options[46].text = "Utah";
			theSelect.options[46].selected = false;
			
			theSelect.options[47].value = "VT";
			theSelect.options[47].text = "Vermont";
			theSelect.options[47].selected = false;
			
			theSelect.options[48].value = "VA";
			theSelect.options[48].text = "Virginia";
			theSelect.options[48].selected = false;
			
			theSelect.options[49].value = "WA";
			theSelect.options[49].text = "Washington";
			theSelect.options[49].selected = false;
			
			theSelect.options[50].value = "WV";
			theSelect.options[50].text = "West Virginia";
			theSelect.options[50].selected = false;
			
			theSelect.options[51].value = "WI";
			theSelect.options[51].text = "Wisconsin";
			theSelect.options[51].selected = false;
			
			theSelect.options[52].value = "WY";
			theSelect.options[52].text = "Wyoming";
			theSelect.options[52].selected = false;
			
			theSelect.options[0].selected = true;
		} 
		else if( vcountry == "UNITED KINGDOM" || vcountry == "UK" || vcountry == "GB"  ){
			theSelect.length = 84 + 1;
			theSelect.options[0].value = "";
			theSelect.options[0].text = "Select A State";
	
			
			theSelect.options[1].value = "AD";
			theSelect.options[1].text = "Aberdeenshire";
			theSelect.options[1].selected = false;
			
			theSelect.options[2].value = "AE";
			theSelect.options[2].text = "Anglesey";
			theSelect.options[2].selected = false;
			
			theSelect.options[3].value = "AN";
			theSelect.options[3].text = "Angus";
			theSelect.options[3].selected = false;
			
			theSelect.options[4].value = "AG";
			theSelect.options[4].text = "Argyllshire";
			theSelect.options[4].selected = false;
			
			theSelect.options[5].value = "AY";
			theSelect.options[5].text = "Ayrshire";
			theSelect.options[5].selected = false;
 
			theSelect.options[6].value = "BF";
			theSelect.options[6].text = "Bedfordshire";
			theSelect.options[6].selected = false;
			
			theSelect.options[7].value = "BS";
			theSelect.options[7].text = "Berkshire";
			theSelect.options[7].selected = false;
			
			theSelect.options[8].value = "BW";
			theSelect.options[8].text = "Berwickshire";
			theSelect.options[8].selected = false;
			
			theSelect.options[9].value = "BK";
			theSelect.options[9].text = "Buckinghamshire";
			theSelect.options[9].selected = false;
			
			theSelect.options[10].value = "BT";
			theSelect.options[10].text = "Buteshire";
			theSelect.options[10].selected = false;
			
			theSelect.options[11].value = "CH";
			theSelect.options[11].text = "Caithness";
			theSelect.options[11].selected = false;
			
			theSelect.options[12].value = "CG";
			theSelect.options[12].text = "Cambridgeshire";
			theSelect.options[12].selected = false;
			
			theSelect.options[13].value = "CD";
			theSelect.options[13].text = "Cardiganshire";
			theSelect.options[13].selected = false;
			
			theSelect.options[14].value = "CI";
			theSelect.options[14].text = "Carmarthenshire";
			theSelect.options[14].selected = false;
			
			theSelect.options[15].value = "CS";
			theSelect.options[15].text = "Cheshire";
			theSelect.options[15].selected = false;
			
			theSelect.options[16].value = "CL";
			theSelect.options[16].text = "Clackmannanshire";
			theSelect.options[16].selected = false;
			
			theSelect.options[17].value = "CW";
			theSelect.options[17].text = "Conwy";
			theSelect.options[17].selected = false;
			
			theSelect.options[18].value = "CN";
			theSelect.options[18].text = "Cornwall";
			theSelect.options[18].selected = false;
			
			theSelect.options[19].value = "CR";
			theSelect.options[19].text = "Cromartyshire";
			theSelect.options[19].selected = false;
			
			theSelect.options[20].value = "CM";
			theSelect.options[20].text = "Cumbria";
			theSelect.options[20].selected = false;
			
			theSelect.options[21].value = "DB";
			theSelect.options[21].text = "Denbigshire";
			theSelect.options[21].selected = false;
			
			theSelect.options[22].value = "DR";
			theSelect.options[22].text = "Derbyshire";
			theSelect.options[22].selected = false;
			
			theSelect.options[23].value = "DV";
			theSelect.options[23].text = "Devon";
			theSelect.options[23].selected = false;
			
			theSelect.options[24].value = "DS";
			theSelect.options[24].text = "Dorset";
			theSelect.options[24].selected = false;
			
			theSelect.options[25].value = "DM";
			theSelect.options[25].text = "Dumfriesshire";
			theSelect.options[25].selected = false;
			
			theSelect.options[26].value = "DN";
			theSelect.options[26].text = "Dunbartonshire";
			theSelect.options[26].selected = false;
			
			theSelect.options[27].value = "DH";
			theSelect.options[27].text = "Durham";
			theSelect.options[27].selected = false;
			
			theSelect.options[28].value = "EL";
			theSelect.options[28].text = "East Lothian";
			theSelect.options[28].selected = false;
			
			theSelect.options[29].value = "EX";
			theSelect.options[29].text = "East Sussex";
			theSelect.options[29].selected = false;
			
			theSelect.options[30].value = "ES";
			theSelect.options[30].text = "Essex";
			theSelect.options[30].selected = false;
			
			theSelect.options[31].value = "FI";
			theSelect.options[31].text = "Fife";
			theSelect.options[31].selected = false;
			
			theSelect.options[32].value = "FT";
			theSelect.options[32].text = "Flintshire";
			theSelect.options[32].selected = false;
			
			theSelect.options[33].value = "GM";
			theSelect.options[33].text = "Glamorgan";
			theSelect.options[33].selected = false;
			
			theSelect.options[34].value = "GL";
			theSelect.options[34].text = "Gloucestershire";
			theSelect.options[34].selected = false;
			
			theSelect.options[35].value = "HP";
			theSelect.options[35].text = "Hampshire";
			theSelect.options[35].selected = false;
			
			theSelect.options[36].value = "HF";
			theSelect.options[36].text = "Herefordshire";
			theSelect.options[36].selected = false;
			
			theSelect.options[37].value = "HE";
			theSelect.options[37].text = "Hertfordshire";
			theSelect.options[37].selected = false;
			
			theSelect.options[38].value = "IV";
			theSelect.options[38].text = "Inverness-shire";
			theSelect.options[38].selected = false;
			
			theSelect.options[39].value = "IR";
			theSelect.options[39].text = "Ireland";
			theSelect.options[39].selected = false;
			
			theSelect.options[40].value = "IW";
			theSelect.options[40].text = "Isle Of White";
			theSelect.options[40].selected = false;
			
			theSelect.options[41].value = "KT";
			theSelect.options[41].text = "Kent";
			theSelect.options[41].selected = false;
			
			theSelect.options[42].value = "KN";
			theSelect.options[42].text = "Kincardineshire";
			theSelect.options[42].selected = false;
			
			theSelect.options[43].value = "KC";
			theSelect.options[43].text = "Kinross-shire";
			theSelect.options[43].selected = false;
			
			theSelect.options[44].value = "KR";
			theSelect.options[44].text = "Kirkcudbrightshire";
			theSelect.options[44].selected = false;
			
			theSelect.options[45].value = "LK";
			theSelect.options[45].text = "Lanarkshire";
			theSelect.options[45].selected = false;
			
			theSelect.options[46].value = "LN";
			theSelect.options[46].text = "Lancashire";
			theSelect.options[46].selected = false;
			
			theSelect.options[47].value = "LE";
			theSelect.options[47].text = "Leicestershire";
			theSelect.options[47].selected = false;
			
			theSelect.options[48].value = "LC";
			theSelect.options[48].text = "Lincolnshire";
			theSelect.options[48].selected = false;
			
			theSelect.options[49].value = "LD";
			theSelect.options[49].text = "London";
			theSelect.options[49].selected = false;
			
			theSelect.options[50].value = "ML";
			theSelect.options[50].text = "MIDDLESEX";
			theSelect.options[50].selected = false;
			
			theSelect.options[51].value = "MH";
			theSelect.options[51].text = "Middlesex";
			theSelect.options[51].selected = false;
			
			theSelect.options[52].value = "MU";
			theSelect.options[52].text = "Monmouthshire";
			theSelect.options[52].selected = false;
			
			theSelect.options[53].value = "MR";
			theSelect.options[53].text = "Morayshire";
			theSelect.options[53].selected = false;
			
			theSelect.options[54].value = "NR";
			theSelect.options[54].text = "Nairnshire";
			theSelect.options[54].selected = false;
			
			theSelect.options[55].value = "NK";
			theSelect.options[55].text = "Norfolk";
			theSelect.options[55].selected = false;
			
			theSelect.options[56].value = "NP";
			theSelect.options[56].text = "Northamptonshire";
			theSelect.options[56].selected = false;
			
			theSelect.options[57].value = "NU";
			theSelect.options[57].text = "Northumberland";
			theSelect.options[57].selected = false;
			
			theSelect.options[58].value = "NG";
			theSelect.options[58].text = "Nottinghamshire";
			theSelect.options[58].selected = false;
			
			theSelect.options[59].value = "OY";
			theSelect.options[59].text = "Orkney";
			theSelect.options[59].selected = false;
			
			theSelect.options[60].value = "OX";
			theSelect.options[60].text = "Oxfordshire";
			theSelect.options[60].selected = false;
			
			theSelect.options[61].value = "PB";
			theSelect.options[61].text = "Peebleshire";
			theSelect.options[61].selected = false;
			
			theSelect.options[62].value = "PM";
			theSelect.options[62].text = "Pembrokeshire";
			theSelect.options[62].selected = false;
			
			theSelect.options[63].value = "PT";
			theSelect.options[63].text = "Perthshire";
			theSelect.options[63].selected = false;
			
			theSelect.options[64].value = "PY";
			theSelect.options[64].text = "Powys";
			theSelect.options[64].selected = false;
			
			theSelect.options[65].value = "RE";
			theSelect.options[65].text = "Renfrewshire";
			theSelect.options[65].selected = false;
			
			theSelect.options[66].value = "RS";
			theSelect.options[66].text = "Ross-shireE";
			theSelect.options[66].selected = false;
			
			theSelect.options[67].value = "RX";
			theSelect.options[67].text = "Roxburghshire";
			theSelect.options[67].selected = false;
			
			theSelect.options[68].value = "SE";
			theSelect.options[68].text = "Selkirkshire";
			theSelect.options[68].selected = false;
			
			theSelect.options[69].value = "ST";
			theSelect.options[69].text = "Shetland";
			theSelect.options[69].selected = false;
			
			theSelect.options[70].value = "SH";
			theSelect.options[70].text = "Shropshire";
			theSelect.options[70].selected = false;
			
			theSelect.options[71].value = "SS";
			theSelect.options[71].text = "Somerset";
			theSelect.options[71].selected = false;
			
			theSelect.options[72].value = "SO";
			theSelect.options[72].text = "Staffordshire";
			theSelect.options[72].selected = false;
			
			theSelect.options[73].value = "SL";
			theSelect.options[73].text = "Stirlingshire";
			theSelect.options[73].selected = false;
			
			theSelect.options[74].value = "SF";
			theSelect.options[74].text = "Suffolk";
			theSelect.options[74].selected = false;
			
			theSelect.options[75].value = "SR";
			theSelect.options[75].text = "Surrey";
			theSelect.options[75].selected = false;
			
			theSelect.options[76].value = "SU";
			theSelect.options[76].text = "Sutherland";
			theSelect.options[76].selected = false;
			
			theSelect.options[77].value = "WW";
			theSelect.options[77].text = "Warwickshire";
			theSelect.options[77].selected = false;
			
			theSelect.options[78].value = "WL";
			theSelect.options[78].text = "West Lothian";
			theSelect.options[78].selected = false;
			
			theSelect.options[79].value = "WM";
			theSelect.options[79].text = "West Midlands";
			theSelect.options[79].selected = false;
			
			theSelect.options[80].value = "WX";
			theSelect.options[80].text = "West Sussex";
			theSelect.options[80].selected = false;
			
			theSelect.options[81].value = "WG";
			theSelect.options[81].text = "Wigtownshire";
			theSelect.options[81].selected = false;
			
			theSelect.options[82].value = "WT";
			theSelect.options[82].text = "Wiltshire";
			theSelect.options[82].selected = false;
			
			theSelect.options[83].value = "WS";
			theSelect.options[83].text = "Worcestershire";
			theSelect.options[83].selected = false;
			
			theSelect.options[84].value = "YS";
			theSelect.options[84].text = "Yorkshire";
			theSelect.options[84].selected = false;
			
			theSelect.options[0].selected = true;
			} 
			else if( vcountry = "other" || vcountry == "ot" ){
				selectField.style.display = 'none';
				if(countryOther){countryOther.style.display = 'inline-block';}
				if(otherID){otherField.style.display = 'inline-block';}
			} 
			else if( vcountry == ""){
				theSelect.length = 1;
				theSelect.options[0].value = "";
				theSelect.options[0].text = "Select A Country First";	
				theSelect.options[0].selected = true;
				selectField.style.display = 'inline-block';
				if(countryOther){countryOther.style.display = 'none';}
				if(otherID){otherField.style.display = 'none';}
			} 
			else {
				theSelect.length = 1;
				theSelect.options[0].value = "";
				theSelect.options[0].text = "Select A Country First";	
				theSelect.options[0].selected = true;
				selectField.style.display = 'none';
				if(countryOther){countryOther.style.display = 'inline-block';}
				if(otherID){otherField.style.display = 'inline-block';}
			}
		$currentSelect.html(theSelect.options[0].text);
	}
}( jQuery ));


