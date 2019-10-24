
function isAlphabet(inputtext, helperMsg)
{
	var alphaExp = /^[a-zA-Z]+$/; 
	
	if(inputtext.value.match(alphaExp))
		{
			return true;
		}
	
	else
		{
			alert(helperMsg); 
			inputtext.focus();
			return false;
		}
}



 function formValidator()
 
{
	var firstname = document.getElementById('First_name');
	
	var surname = document.getElementById('Last_name');
	
	
	
	if(isAlphabet(firstname, "Please enter only letters for your name")) 
	{
		if(isAlphabet(surname, "Please enter only letters for your surname"))
		{
			

						return true;
						
		}
	}
	
	return false;	
	
	
}


